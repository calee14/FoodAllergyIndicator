//
//  IngredientService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/17/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct IngredientService {
    
    private static let DatabaseIngredientsPath = Constants.DatabasePath.userIngredients
    
    static func setIngredient(for user: User, ingredient: Ingredient, completion: @escaping ([Ingredient]) -> Void) {
        var results = [String : Any]()
        
        let time = NSDate().timeIntervalSince1970
        results[ingredient.getIngredientName()] = time
        
        let ref = Database.database().reference().child(DatabaseIngredientsPath).child(user.uid)
        
        ref.updateChildValues(results) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String : TimeInterval] else { return }
                // Sorting in ascending order so that the most recent pics are on top
                let sortedDict = dict.sorted(by: { $0.value > $1.value })
                
                var ingredients = [Ingredient]()
                for ingredient in sortedDict {
                    ingredients.append(Ingredient(ingredient.key))
                }
                completion(ingredients)
            })
        }
    }
    static func retrieveAllIngredients(for user: User, completion: @escaping ([Ingredient]) -> Void) {
        let ref = Database.database().reference().child(DatabaseIngredientsPath).child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String : TimeInterval] else { return }
            // Sorting in ascending order so that the most recent pics are on top
            let sortedDict = dict.sorted(by: { $0.value > $1.value })
            
            var ingredients = [Ingredient]()
            for ingredient in sortedDict {
                ingredients.append(Ingredient(ingredient.key))
            }
            completion(ingredients)
        })
    }
    
    static func removeIngredient(for user: User, ingredient: Ingredient, completion: @escaping ([Ingredient]) -> Void) {
        let ingredientKey = ingredient.getIngredientName()
        let ref = Database.database().reference().child(DatabaseIngredientsPath).child(user.uid).child(ingredientKey)
        ref.removeValue { (error, ref) in
            retrieveAllIngredients(for: user, completion: { (ingredients) in
                completion(ingredients)
            })
        }
    }
    
    static func doesUserHaveIngredients(for user: User, completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(DatabaseIngredientsPath).child(user.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // The user has alrady add ingredients
                completion(true)
            } else {
                // The user didn't add any ingredients
                completion(false)
            }
        }
    }
}
