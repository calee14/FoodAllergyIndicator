//
//  PhotoResultsViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK
import Clarifai

class PhotoResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foodImageView: UIImageView!
    
    // MARK: - Properties
    var concepts: [ClarifaiConcept] = []
    var allergens: [String] = []
    var safeIngredients: [String] = []
    var ingredientsInFood: [String] = []
    
    let warningController = WarningController()
    
    weak var foodImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        concepts = [ClarifaiConcept(conceptName: "spaghetti"), ClarifaiConcept(conceptName: "Cookie"), ClarifaiConcept(conceptName: "egg")]
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            CheckService.checkAllergies(ingreidents: self.concepts, allergies: allergies, completion: { (allergens, safeIngredients) in
                guard let allergens = allergens else { return }
                guard let safeIngredients = safeIngredients else { return }
                self.allergens = allergens
                self.safeIngredients = safeIngredients
                self.combineAllergensAndSafeIngredientsAndUpdateTable()
                var foods = [String]()
                let group = DispatchGroup()
                for concept in self.concepts {
                    group.enter()
                    IngredientService.doesIngredientExists(ingredientName: concept.conceptName, completion: { (exist) in
                        if !exist {
                            foods.append(concept.conceptName)
                        }
                        group.leave()
                    })
                }
                group.notify(queue: .main) {
                    print(foods)
                    CheckService.checkRecipe(foodQueries: foods) { (result) in
                        guard let ingredients = result else { return }
                        guard let allergiesInRecipe = CheckService.checkIngredientsInRecipe(recipeIngredients: ingredients, allergies: allergies) else { return }
                        self.allergens.append(contentsOf: allergiesInRecipe)
                        self.combineAllergensAndSafeIngredientsAndUpdateTable()
                        self.showWarningMenu(allergies: self.allergens.count >= 1)
                    }
                }
            })
        }
        
        setupLayout()
        
        guard let foodImage = foodImage else { return }
        self.foodImageView.image = foodImage
    }
    
    func combineAllergensAndSafeIngredientsAndUpdateTable() {
        ingredientsInFood = allergens + safeIngredients
        self.tableView.reloadData()
    }
    
    func setupLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped))
    }
    
    @objc func homeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showWarningMenu(allergies: Bool) {
        warningController.showWarningMenu(allergies: allergies)
    }
}

extension PhotoResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsInFood.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as! ResultsTableViewCell
        let ingredientdata = ingredientsInFood[indexPath.row]
        cell.ingredientLabel.text = ingredientdata
        cell.scoreLabel.text = indexPath.row < allergens.count ? "Bad" : "Good"
        cell.ingredientLabel.textColor = indexPath.row < allergens.count ? .red : .green
        return cell
    }
}
