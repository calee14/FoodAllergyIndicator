//
//  IngredientService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/3/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct IngredientService {
    private static let ingredientsPath = Constants.DatabasePath.ingredients
    
    static func addIngredient(ingredientNames: [String], success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(ingredientsPath)
        var data = [String : String]()
        for ingredient in ingredientNames {
            data[ingredient] = ingredient
        }
        ref.updateChildValues(data) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
    
    static func doesIngredientExists(ingredientName: String) -> Bool{
        let ref = Database.database().reference().child(ingredientsPath)
        var existence = false
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(ingredientName) {
                existence = true
            } else {
                existence = false
            }
        }
        return existence
    }
}
