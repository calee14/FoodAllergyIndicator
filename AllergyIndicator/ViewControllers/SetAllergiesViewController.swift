//
//  SetAllergiesViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class SetAllergiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addIngredientButton: UIButton!
    
    var allergens = [Allergy]()
    var importantIngredients = [Ingredient]()
    
    private var user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup layout
        setupLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        // Load the ingredients from the db
        // Required for when the app has to pop a view controller
        IngredientService.retrieveAllIngredients(for: User.current) { (ingredients) in
            self.importantIngredients = ingredients
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    func setupLayout() {
        
        // Changing some properties of the add button
        let buttonWidth = 70
        addIngredientButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - CGFloat(buttonWidth) - (self.view.frame.width * 0.06), y: self.view.frame.height - (self.view.frame.height * 0.15)), size: CGSize(width: buttonWidth, height: buttonWidth))
        addIngredientButton.layer.zPosition = 10
        addIngredientButton.applyGradient(colours: backgroundGradients)
        addIngredientButton.setTitleColor(.white, for: .normal)
        addIngredientButton.layer.cornerRadius = min(addIngredientButton.frame.width, addIngredientButton.frame.height) / 2
        addIngredientButton.layer.masksToBounds = true
        
        // Removing the selection of table view cells since it interferes with user's touch when
        // trying to remove an ingredient
        self.tableView.allowsSelection = false
    }
    
    @IBAction func pressedIngredientButton(_ sender: UIButton) {
        goToAddIngredientsViewController()
    }
    
    func goToAddIngredientsViewController() {
        // Retrieve the storyboard the app is going to seque to
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let addingredientViewController = storyboard.instantiateViewController(withIdentifier: "AddIngredientViewController") as! AddIngredientViewController
        
        // Navigate to the results view controller
        self.navigationController?.pushViewController(addingredientViewController, animated: true)
    }
    
}

extension SetAllergiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.importantIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientTableViewCell
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.importantIngredients[indexPath.row].setIsImportant(isImportant: false) // we delete the unimportant ones
            
            IngredientService.removeIngredient(for: self.user, ingredient: self.importantIngredients[indexPath.row]) { (ingredients) in
                self.importantIngredients = ingredients
                self.tableView.reloadData()
            }
        }
    
        return [delete]
    }
    
    func configure(cell: IngredientTableViewCell, atIndexPath indexPath: IndexPath) {
        let ingredient = importantIngredients[indexPath.row]
        cell.ingredientName?.text = ingredient.getDisplayIngredientName()
    }
}
