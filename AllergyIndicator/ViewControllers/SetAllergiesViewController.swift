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
    
    var allergens = [Allergy]()
    var importantIngredients = [Ingredient]()
    
    private var user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load allergies
//        AllergyService.retrieveAllergies(for: user) { (allergies) in
//            var allergens = [Allergy]()
//            for allergy in allergies {
//                if allergy.isAllergic {
//                    print("stuff")
//                    allergens.insert(allergy, at: 0)
//                } else {
//                    allergens.append(allergy)
//                }
//            }
//            self.allergens = allergens
//            self.tableView.reloadData()
//        }
        
        // load ingredients
        importantIngredients = [Ingredient("egg"), Ingredient("cheese"), Ingredient("noodles")]
        self.tableView.reloadData()
        
    }
}

extension SetAllergiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.importantIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell") as! IngredientTableViewCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: IngredientTableViewCell, atIndexPath indexPath: IndexPath) {
        let ingredient = importantIngredients[indexPath.row]
        cell.ingredientName?.text = ingredient.getIngredientName()
    }
}

extension SetAllergiesViewController: DeleteCellDelegate {
    func didPressDeleteButton(_ deleteButton: UIButton, on cell: IngredientTableViewCell) {
        print("tried deleting ingredient")
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.importantIngredients[indexPath.row].setIsImportant(isImportant: false) // we delete the unimportant ones
        
        // delete the ingredient from the table view here
        // ...
        self.importantIngredients.remove(at: indexPath.row)
        self.tableView.reloadData()
        
        // remove the ingredient from the database here
        // ...
    }
}
extension SetAllergiesViewController: IsAllergicCellDelegate {
    func didSwitchAllergicSwitch(_ isAllergicSwitch: UISwitch, on cell: AllergyTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        isAllergicSwitch.isUserInteractionEnabled = false
        
        self.importantIngredients[indexPath.row].setIsImportant(isImportant: isAllergicSwitch.isOn)
        
        // update the databse with the ingredient we want here
        // ...
        
        
//        AllergyService.updateAllergy(for: user, allergy: self.allergens[indexPath.row]) { (snapshot) in
//            defer {
//                isAllergicSwitch.isUserInteractionEnabled = true
//            }
//            guard snapshot != nil else { return }
//
//            self.tableView.reloadRows(at: [indexPath], with: .none)
//        }
    }
}
