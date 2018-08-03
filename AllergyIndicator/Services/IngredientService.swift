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
    
    static func addIngredient(ingredientName: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(ingredientsPath)
        let ingredientData = [ingredientName : ingredientName]
        ref.updateChildValues(ingredientData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            success(true)
        }
    }
    
    static func doesIngredientExists(ingredientName: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(ingredientsPath)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(ingredientName) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
