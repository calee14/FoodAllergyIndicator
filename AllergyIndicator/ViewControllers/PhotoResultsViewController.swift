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
    
    let warningController = WarningController()
    
    weak var foodImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        concepts = [ClarifaiConcept(conceptName: "pad thai"), ClarifaiConcept(conceptName: "Cookie"), ClarifaiConcept(conceptName: "egg")]
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            CheckService.checkAllergies(ingreidents: self.concepts, allergies: allergies, completion: { (allergens) in
                guard let allergens = allergens else { return }
                self.allergens = allergens
                self.tableView.reloadData()
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
                        if allergiesInRecipe.count > 1 {
                            self.showWarningMenu(allergies: allergiesInRecipe)
                        }
                    }
                }
            })
        }
        
        setupLayout()
        
        guard let foodImage = foodImage else { return }
        self.foodImageView.image = foodImage
        
        
    }
    
    func setupLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped))
    }
    
    @objc func homeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showWarningMenu(allergies: [String]) {
        warningController.showWarningMenu(allergies: allergies)
    }
}

extension PhotoResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concepts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as! ResultsTableViewCell
        let ingredientdata = concepts[indexPath.row]
        cell.ingredientLabel.text = ingredientdata.conceptName
        cell.scoreLabel.text = String(ingredientdata.score)
        if allergens.contains(ingredientdata.conceptName) {
            cell.ingredientLabel.textColor = .red
        } else {
            cell.ingredientLabel.textColor = .green
        }
        return cell
    }
}
