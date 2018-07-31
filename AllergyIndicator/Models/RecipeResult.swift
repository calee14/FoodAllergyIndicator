//
//  RecipeResult.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/30/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    let title: String
    let href: String
    let ingredients: String
    let thumbnail: String
}

struct RecipeResult: Decodable {
    let title: String
    let version: Double
    let href: String
    let results: [Recipe]
}
