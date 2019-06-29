//
//  PushIngredientsToDB.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/28/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PushIngredientsToDB {
    
    private static let DatabaseIngredientsPath = Constants.DatabasePath.userIngredients
    
    static func retrieveLocalData() -> [String] {
        let file = "indv_ingredientv1"
        if let path = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                return myStrings
            } catch {
                print(error)
            }
        }
        return [String]()
    }
    static func addDataToFirebase(ingredientData: [String], success: @escaping (Bool) -> Void) {
        
        let ref = Database.database().reference().child(DatabaseIngredientsPath)
        
        for ingredient in ingredientData {
            let ingredientDict = [ingredient : true]
            
            ref.updateChildValues(ingredientDict) { (error, ref) in
                if let error = error {
                    print("we have an error while trying to add the ingredients to the db")
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
        }
        success(true)
    }
}
