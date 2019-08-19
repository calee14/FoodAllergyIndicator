//
//  CheckAllergyService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/27/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Clarifai_Apple_SDK

struct CheckService {
    static func checkIngredients(concepts: [Concept], impIngredients: [Ingredient], completion: ([String]?, [String]?) -> Void) {
        
        var locatedImpIngredients = [String]()
        var regularIngredients = [String]()
        let usersImpIngredients = impIngredients
        
        for concept in concepts {
            var foundAnIngredient = false
            for ingredient in impIngredients {
                let coefficient = diceCoefficient(s: concept.name, t: ingredient.getIngredientName())
                let threshold = 50.0
                if coefficient * 100.0 > threshold {
                    locatedImpIngredients.append(concept.name)
                    foundAnIngredient = true
                    break
                }
            }
            
            if !foundAnIngredient {
                regularIngredients.append(concept.name)
            }
        }
        
        completion(locatedImpIngredients, regularIngredients)
    }
    
    static func checkAllergies(ingreidents: [Concept], allergies: [Allergy], completion: ([String]?, [String]?) -> Void) {
        var possibleAllergies = [String]()
        var safeIngredients = [String]()
        let usersAllergies = getOnlyAllergic(allergens: allergies)
        for i in ingreidents {
            if i.score < 0.5 { continue }
            var foundAllergy = false
            for j in usersAllergies {
                if j.isAllergic {
                    let coefficient = diceCoefficient(s: i.name, t: j.allergyName)
                    /* This threshold decides whether the user is allergic to this food */
                    let threshold = 50.0
                    if coefficient * 100.0 > threshold {
                        possibleAllergies.append(i.name)
                        foundAllergy = true
                        break
                    }
//                    if let dist = LevenshteinDistance(s: i.conceptName.lowercased(), t: j.allergyName.lowercased()), ((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0) >= 90 {
//                        print("blah \(((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0)) \(j.allergyName) \(i.conceptName)")
//                        print("blah \(dist) \((1 - (dist/min(i.conceptName.count, j.allergyName.count)))) \((dist/min(i.conceptName.count, j.allergyName.count))) \(min(i.conceptName.count, j.allergyName.count))")
//                        print(((1 - (dist/min(i.conceptName.count, j.allergyName.count))) * 100) >= 90)
//                        print(i.conceptName)
//                        print(j.allergyName)
//                        possibleAllergies.append(i.conceptName)
//                    }
                } else {
                    continue
                }
            }
            if !foundAllergy {
                safeIngredients.append(i.name)
            }
        }
        completion(possibleAllergies, safeIngredients)
    }
    
    static func checkRecipe(foodQueries: [String], completion: @escaping ([String]?) -> Void) {
        let apiCallString = "http://www.recipepuppy.com/api/?q="
        var recipeIngredients: [String] = [String]()
        let group = DispatchGroup()
        for query in foodQueries {
            group.enter()
            /* Make a api request to a recipe api and get the ingredients of the recipe */
            Alamofire.request(apiCallString + query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!).validate().responseJSON() { response in
                
                switch response.result {
                    
                case .success:
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(RecipeResult.self, from: response.data!)
                    
                    // filter out recipes that doesn't match our food string
                    let possibleRecipes: [Recipe] = (result?.results.filter{ (r: Recipe) -> Bool in
                        /* String Comparison using levenshteinDistance*/
//                        var lensum = Double(r.title.count)
//                        if r.title.count < query.count {
//                            lensum = Double(query.count)
//                        }
//                        let dist = LevenshteinDistance(s: r.title.lowercased(), t: query.lowercased())!
//                        print("Results \(query)")
//                        print("Results \(((1.0 - (Double(dist)/lensum)) * 100.0) >= 50)")
//                        print("Results \(((1.0 - (Double(dist)/lensum)) * 100.0))")
//                        if let dist = LevenshteinDistance(s: r.title.lowercased(), t: query.lowercased()), ((1.0 - (Double(dist)/lensum)) * 100.0) >= 50 {
//                            return true
//                        }
                        
                        /* String Comparison using dice coefficient */
                        /* NOTE: Using dice coefficient because it works better for this application */
                        /* Check the similarity between the recipe name and the
                         food names from the Clarifai API */
                        let coefficient = diceCoefficient(s: r.title, t: query)
                        
                        /* Threshold decides whether we should use recipe */
                        let threshold = 75.0
                        if coefficient * 100.0 >= threshold {
                            print(r.title)
                            print(r.ingredients)
                            // We found a recipe that matches our food
                            return true
                        }
                        
                        // We didn't find a recipe that matches our food
                        return false
                        })!
                    
                    /* Get the ingredients from the recipe */
                    for recipe in possibleRecipes {
                        recipeIngredients.append(contentsOf: recipe.ingredients.components(separatedBy: ", "))
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            /* Add all the ingredients from the recipes to the database.
             This will help by avoiding sending ingredients to the RecipePuppy */
            print(recipeIngredients)
            completion([String]())
//            DatabaseIngredientService.addIngredient(ingredientNames: recipeIngredients, success: { (success) in
//                guard let success = success else { return }
//                completion(recipeIngredients)
//            })
        }
    }
    static func checkIngredientsInRecipe(recipeIngredients: [String], allergies: [Allergy]) -> [String]? {
        var possibleAllergies = [String]()
        let usersAllergies = getOnlyAllergic(allergens: allergies)
        for ingredient in recipeIngredients {
            for allergy in usersAllergies {
                if allergy.isAllergic {
                    let coefficient = diceCoefficient(s: ingredient, t: allergy.allergyName)
//                    let dist = LevenshteinDistance(s: ingredient.lowercased(), t: allergy.allergyName.lowercased())
//                    if ((1.0 - (Double(dist!)/lsum)) * 100.0) >= 30 {
                    /* This threshold decides whether the use is allergic to the recipe ingredients */
                    let threshold = 80.0
                    if coefficient * 100.0 > threshold {
                        if !possibleAllergies.contains(ingredient) {
                            possibleAllergies.append(ingredient)
                        }
//                        print("WARN \(((1.0 - (Double(dist!)/lsum)) * 100.0) >= 30) \(((1.0 - (Double(dist!)/lsum)) * 100.0)) \(ingredient) \(allergy.allergyName)")
                    }
                } else {
                    continue
                }
            }
        }
        return possibleAllergies
    }
    
    static func getOnlyAllergic(allergens: [Allergy]) -> [Allergy] {
        return allergens.filter { $0.isAllergic }
    }
    
    static func minimum(a: Int, b: Int, c: Int) -> Int{
        var mi = a
        if b < mi {
            mi = b
        }
        if c < mi {
            mi = c
        }
        return mi
    }
    
    static func LevenshteinDistance(s: String, t: String) -> Int? {
        var d = [[Int]]()
        var n: Int
        var m: Int
        var s_i: Character
        var t_j: Character
        var cost: Int

        n = s.count
        m = t.count
        if n == 0 {
            return m
        }
        if m == 0 {
            return n
        }
        let newM = [Int](repeating: 0, count: m+1)
        d = [[Int]](repeating: newM, count: n+1)

        for i in 1...n {
            d[i][0] = i
        }

        for j in 1...m {
            d[0][j] = j
        }

        for i in 1...n {
            s_i = s[i-1]

            for j in 1...m {
                t_j = t[j-1]

                if s_i == t_j {
                    cost = 0
                } else {
                    cost = 1
                }

                d[i][j] = minimum(a: d[i-1][j]+1, b: d[i][j-1]+1, c: d[i-1][j-1] + cost)
            }
        }
        return d[n][m]
    }
    
    static func bigrams(s: String) -> [String] {
        var result: [String] = []
        for i in 0..<s.count - 1 {
//            let index = s.lowercased().index(s.startIndex, offsetBy: i)
            let indexStartOfText = s.index(s.startIndex, offsetBy: i)
            let indexEndOfText = s.index(s.startIndex, offsetBy: i+1)
            result.append(String(s.lowercased()[indexStartOfText...indexEndOfText]))
        }
        return result
    }

    /**
     Calculates the case insensitive string similarity (Sørensen–Dice coefficient) between two strings
     - parameter otherString: string to compare with
     - returns: A Float from 0 to 1, where 1 indicates strings are identical
     */
    static func diceCoefficient(s: String, t: String) -> Double {
        if s == t {
            return 1
        }

        if s.count < 2 || t.count < 2 {
            return 0
        }

        let sortedBigrams: [String] = bigrams(s: s).sorted()
        let otherSortedBigrams: [String] = bigrams(s: t).sorted()
        
        var matches = 0
        var i = 0
        var j = 0

        while i < sortedBigrams.count && j < otherSortedBigrams.count {
            if sortedBigrams[i] == otherSortedBigrams[j] {
                matches += 1
                i += 1
                j += 1
            } else if sortedBigrams[i] < otherSortedBigrams[j] {
                i += 1
            } else {
                j += 1
            }
        }
        return Double(matches*2) / Double(sortedBigrams.count + otherSortedBigrams.count)
    }
   
    static func diceCoeffitient(s: String, t: String) -> Double {
        if s.count < 2 || t.count < 2 {
            return 0
        }
        var bigrams = [String : Int]()
        for i in 0..<s.count - 1 {
            let bigram = String(s[i...i+2])
            var count = 0
            if bigrams[bigram] != nil {
                count = bigrams[bigram]! + 1
            } else {
                count = 1
            }
            bigrams[bigram] = count
        }

        var intersectionSize = 0
        for i in 0...t.count {
            let bigram = String(s[i...i+2])
            var count = 0
            if bigrams[bigram] != nil {
                count = bigrams[bigram]!
            } else {
                count = 0
            }
            if count > 0 {
                bigrams[bigram] = count - 1
                intersectionSize += 1
            }
        }
        return (2.0 * Double(intersectionSize)) / Double(s.count + t.count - 2)
    }
}
