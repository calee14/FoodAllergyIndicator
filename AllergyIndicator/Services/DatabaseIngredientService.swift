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
        print("in the checking func")
        let ref = Database.database().reference().child(ingredientsPath)
        // NOTE: need to check if this func still works
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(ingredientName) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func doesIngredientExists2(ingredientName: String, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("ingredient").child(ingredientName)
        var exists = false
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                exists = true
                print("\(ingredientName) is an ingredient")
            }
            
            if !exists {
                print("\(ingredientName) is a crafted food")
            }
        }
        completion(true)
    }
}
