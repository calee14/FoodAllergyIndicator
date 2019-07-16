//
//  AddIngredientViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/10/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController {

    @IBOutlet weak var ingredientHeaderTextView: UITextView!
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
        // Setting ui colors
        let lightblue = UIColor(rgb: 0x0093DD)
        
        errorLabel.isHidden = true
        
        // Changing properties of the header uitextview
        ingredientHeaderTextView.textAlignment = .center
        ingredientHeaderTextView.text = "Set important ingredients\n The app will alert you\n when you take a picture of a food\n that contains the ingredient you set."
        ingredientHeaderTextView.layer.borderWidth = 2
        ingredientHeaderTextView.layer.cornerRadius = 5
        ingredientHeaderTextView.clipsToBounds = true
        ingredientHeaderTextView.translatesAutoresizingMaskIntoConstraints = true
        ingredientHeaderTextView.isScrollEnabled = false
        ingredientHeaderTextView.isUserInteractionEnabled = false
        ingredientHeaderTextView.textContainerInset = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 30)
        ingredientHeaderTextView.sizeToFit()
        
        // Change the layout of the set button
        ingredientButton.backgroundColor = lightblue
        ingredientButton.setTitleColor(.white, for: .normal)
        ingredientButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        ingredientButton.layer.cornerRadius = 6
        ingredientButton.clipsToBounds = true
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
            // add the name of the ingredient to the db and pop back to the previous view controller
            addIngredientPopVC(ingredient: ingredient)
        }
    }
    
    func checkTextField(text: String) -> String {
        if(text.isEmpty) {
            return "Please enter the name of your ingredient"
        }
        return "Valid text"
    }
    
    func addIngredientPopVC(ingredient: String) {
        IngredientService.setIngredient(for: User.current, ingredient: Ingredient(ingredient)) { (ingredients) in
            // list ingredients here if must
            
            // move back to the previous view controller once the ingredient has been added
            self.navigationController?.popViewController(animated: true)
        }
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
        guard let ingredient = self.addIngredientTextField.text else { return false }
        addIngredientPopVC(ingredient: ingredient)
        return false
    }
}
