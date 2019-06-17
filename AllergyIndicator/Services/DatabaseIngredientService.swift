//
//  IngredientService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/3/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DatabaseIngredientService {
    private static let ingredientsPath = Constants.DatabasePath.ingredients
    
    static func addIngredient(ingredientNames: [String], success: @escaping (Bool?) -> Void) {
        let ref = Database.database().reference().child(ingredientsPath)
        var data = [String : Bool]()
        for ingredient in ingredientNames {
            data[ingredient] = false
        }
        ref.updateChildValues(data) { (error, ref) in
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
