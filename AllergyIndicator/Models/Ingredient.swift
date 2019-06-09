//
//  Ingredient.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/9/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Ingredient {
    private var ingredientName: String
    private var isImportant: Bool
    
    init(_ ingredientName: String, isImportant: Bool) {
        self.ingredientName = ingredientName
        self.isImportant = isImportant
    }
    
    init(_ ingredientName: String) {
        self.ingredientName = ingredientName
        self.isImportant = true
    }
    
    func getIngredientName() -> String {
        return self.ingredientName
    }
    
    func getIsImportant() -> Bool {
        return self.isImportant
    }
    
    func setIngredientName(ingredientName: String) {
        self.ingredientName = ingredientName
    }
    
    func setIsImportant(isImportant: Bool) {
        self.isImportant = isImportant
    }
}
