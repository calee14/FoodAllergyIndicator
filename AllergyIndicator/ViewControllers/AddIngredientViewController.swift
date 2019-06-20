//
//  AddIngredientViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/10/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController {

    @IBOutlet weak var ingredientsHeaderLabel: UILabel!
    @IBOutlet weak var addIngredientTextField: UITextField!
    @IBOutlet weak var ingredientButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddIngredientViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addIngredientTextField.delegate = self
        
        // setup layout
        setupLayout()
    }
    
    func setupLayout() {
        errorLabel.isHidden = true
    }
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func pressedIngredientButton(_ sender: UIButton) {
        ingredientButton.isUserInteractionEnabled = false
        
        var ingredient = addIngredientTextField.text!
        ingredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let check = checkTextField(text: ingredient)
        
        if(check == "Please enter the name of your ingredient") {
            errorLabel.isHidden = false
            errorLabel.text = check
            ingredientButton.isUserInteractionEnabled = true
        } else if(check == "Valid text") {
            IngredientService.setIngredient(for: User.current, ingredient: Ingredient(ingredient)) { (ingredients) in
                ingredients.forEach({ (i) in
                    print(i.getIngredientName())
                })
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func checkTextField(text: String) -> String {
        if(text.isEmpty) {
            return "Please enter the name of your ingredient"
        }
        return "Valid text"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddIngredientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        // run code for updating ingredients here
        // ...
        return false
    }
}
