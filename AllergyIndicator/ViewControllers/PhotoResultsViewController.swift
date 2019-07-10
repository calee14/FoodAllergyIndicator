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
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var backPictureButton: UIButton!
    
    // MARK: - Properties
    var concepts: [ClarifaiConcept] = []
    var allergens: [String] = []
    var safeIngredients: [String] = []
    var ingredientsInFood: [String] = []
    var noFood: Bool = false
    
    let warningController = WarningController()
    
    weak var foodImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // if there is no camera access request access
        if concepts == [ClarifaiConcept]() && !noFood{
            self.handleNoCamera()
            return
        }
        
        // If there is no food in the image make message
        if noFood {
            self.handleNoFood()
            return
        }
        
        IngredientService.retrieveAllIngredients(for: User.current) { (usersIngredients) in
            /* After retrieving the important ingredients pass them to the
             check service to see if the ingredients the user wants to find.
            */
            CheckService.checkIngredients(concepts: self.concepts, impIngredients: usersIngredients, completion: { (impIngredients, regIngredients) in
                guard let impIngredients = impIngredients else { return }
                guard let regIngredients = regIngredients else { return }
                // need to change to impIngredients no longer called allergens
                // ...
                self.allergens = impIngredients
                // need to change to impIngredients no longer called allergens
                // ...
                self.safeIngredients = regIngredients
                self.combineImportantWithRegularIngredients()
                
                /* Check if any of the foods are ingredients.
                 If it is an ingredient then don't add it to the recipe search query */
                var foods = [String]()
                let group = DispatchGroup()
                for concept in self.concepts {
                    /* MARK: Make sure to only accept concepts above 90 percent confidence */
                    let threshold: Float = 50.0
                    
                    print(concept.score)
                    
                    // Handing some threshold stuff
//                    if concept.score < threshold {
//                        continue
//                    }
                    
                    // enter into a dispatch group
                    group.enter()
                    DatabaseIngredientService.doesIngredientExists(ingredientName: concept.conceptName, completion: { (exist) in
                        print("\(concept.conceptName) does exists \(exist)")
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
                        // need to update the check ingredient recipe func
                        /*
                        guard let allergiesInRecipe = CheckService.checkIngredientsInRecipe(recipeIngredients: ingredients, allergies: usersIngredients) else { return }
                        self.allergens.append(contentsOf: allergiesInRecipe)
                        self.combineAllergensAndSafeIngredientsAndUpdateTable()
                        */
                        self.showWarningMenu(allergies: self.allergens.count >= 1)
                    }
                }
            })
        }
        
        setupLayout()
        
        guard let foodImage = foodImage else { return }
        self.foodImageView.image = foodImage
    }
    
    func handleNoCamera() {
        self.cameraAutherization()
        
        ingredientsInFood.append("No data provided.")
        
        setupLayout()
        
        guard let foodImage = foodImage else { return }
        self.foodImageView.image = foodImage
    }
    
    func handleNoFood() {
        self.noFoodMessage()
        
        ingredientsInFood.append("No food in the image taken.")
        
        setupLayout()
        
        guard let foodImage = foodImage else { return }
        self.foodImageView.image = foodImage
    }
    
    func combineAllergensAndSafeIngredientsAndUpdateTable() {
        ingredientsInFood = allergens + safeIngredients
        self.tableView.reloadData()
    }
    
    func combineImportantWithRegularIngredients() {
        // note need to change the array names
        // ...
        ingredientsInFood = allergens + safeIngredients
        self.tableView.reloadData()
    }
    
    func setupLayout() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped))
        
        // Change the layout and position of button
        backPictureButton.frame = CGRect(x: 30, y: 45, width: 35, height: 35)
        backPictureButton.titleLabel?.textColor = UIColor(red: 249, green: 248, blue: 248)
        backPictureButton.backgroundColor = .clear
        backPictureButton.layer.borderWidth = 1.0
        backPictureButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        backPictureButton.layer.cornerRadius = min(backPictureButton.frame.width, backPictureButton.frame.height) / 2
        
        // Change the layout and position of button
        homeButton.frame = CGRect(x: self.view.bounds.width - 30 - homeButton.frame.width, y: 45, width: 35, height: 35)
        homeButton.titleLabel?.textColor = UIColor(red: 249, green: 248, blue: 248)
        homeButton.backgroundColor = .clear
        homeButton.layer.borderWidth = 1.0
        homeButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        homeButton.layer.cornerRadius = min(homeButton.frame.width, homeButton.frame.height) / 2
        
        // Change image of the home button
        let homeImage = UIImage(named: "homebutton")
        homeButton.setImage(homeImage, for: .normal)
        homeButton.tintColor = .white
    }
    
    @objc func homeTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func cameraAutherization() {
        let titleString = "Camera not available"
        let contentString = "You did not allow access to camera. Please turn on camera access in the settings to see results."
        warningController.showWarningMenu(title: titleString, content: contentString)
        
    }
    
    func noFoodMessage() {
        let titleString = "No food in image"
        let contentString = "You did not take a picture that contained any type of food. Please take a picture of food to see results."
        warningController.showWarningMenu(title: titleString, content: contentString)
    }
    
    func showWarningMenu(allergies: Bool) {
        var titleString = "BE CAREFUL"
        var allergyString = "Possiblle Allergens Detected!!! \nConfirm with the food preparer to verify ingredients. As always, be careful and consume with caution."
        if allergies == false {
            titleString = "Should Be Safe To Eat"
            allergyString = "Reminder! \nConfirm with the food preparer to verify ingredients. As always, be careful and consume with caution."
        }
        
        warningController.showWarningMenu(title: titleString, content: allergyString)
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
        cell.scoreLabel.text = indexPath.row < allergens.count ? "❌" : "✔️"
        cell.ingredientLabel.textColor = indexPath.row < allergens.count ? .red : .black
        return cell
    }
}
