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
    static func addDataToFirebase(ingredientData: [String]) {
        
    }
}
