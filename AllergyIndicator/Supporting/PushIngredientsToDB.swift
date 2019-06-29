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
    
    private static let DatabaseIngredientsPath = Constants.DatabasePath.ingredients
    
    static func retrieveLocalData() -> [String] {
        let file = "indvl_ingredientv1"
        if let path = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                return myStrings
            } catch {
                print("There was an error in retrieving the data \(error)")
            }
        }
        return [String]()
    }
    
    static func addDataToFirebase(ingredientData: [String], success: @escaping (Bool) -> Void) {

        var ingredientDict = [String: Bool]()

        for ingredient in ingredientData {
            if ingredient == "" {
                continue
            }
            ingredientDict[ingredient] = true
        }

        print(ingredientDict.capacity)

        let ref = Database.database().reference().child("ingredient")

        ref.setValue(ingredientDict) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }

            success(true)
        }
    }
}
