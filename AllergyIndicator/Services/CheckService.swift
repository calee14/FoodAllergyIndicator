//
//  CheckAllergyService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/27/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import Clarifai
import Alamofire
import SwiftyJSON

struct CheckService {
    static func checkAllergies(ingreidents: [ClarifaiConcept], allergies: [Allergy], completion: ([String]?) -> Void) {
        var possibleAllergies = [String]()
        for i in ingreidents {
            for j in allergies {
                if j.isAllergic {
                    if let dist = LevenshteinDistance(s: i.conceptName.lowercased(), t: j.allergyName.lowercased()), ((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0) >= 90 {
                        print("blah \(((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0)) \(j.allergyName) \(i.conceptName)")
                        print("blah \(dist) \((1 - (dist/min(i.conceptName.count, j.allergyName.count)))) \((dist/min(i.conceptName.count, j.allergyName.count))) \(min(i.conceptName.count, j.allergyName.count))")
                        print(((1 - (dist/min(i.conceptName.count, j.allergyName.count))) * 100) >= 90)
                        print(i.conceptName)
                        print(j.allergyName)
                        possibleAllergies.append(i.conceptName)
                    }
                } else {
                    continue
                }
            }
        }
        completion(possibleAllergies)
    }
    static func checkRecipe(foodQueries: [String], completion: @escaping ([String]?) -> Void) {
        let apiCallString = "http://www.recipepuppy.com/api/?q="
        var possibleIngredients: [String] = [String]()
        let group = DispatchGroup()
        for query in foodQueries {
            group.enter()
            Alamofire.request(apiCallString + query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(RecipeResult.self, from: response.data!)
                    
                    // filter out recipes that doesn't match our food string
                    let possibleRecipes: [Recipe] = (result?.results.filter{ (r: Recipe) -> Bool in
                        var lensum = Double(r.title.count)
                        if r.title.count < query.count {
                            lensum = Double(query.count)
                        }
                        let dist = LevenshteinDistance(s: r.title.lowercased(), t: query.lowercased())!
                        print("Results \(query)")
                        print("Results \(((1.0 - (Double(dist)/lensum)) * 100.0) >= 50)")
                        print("Results \(((1.0 - (Double(dist)/lensum)) * 100.0))")
                        if let dist = LevenshteinDistance(s: r.title.lowercased(), t: query.lowercased()), ((1.0 - (Double(dist)/lensum)) * 100.0) >= 25 {
                            return true
                        }
                        return false
                        })!
                    for recipe in possibleRecipes {
                        possibleIngredients.append(contentsOf: recipe.ingredients.components(separatedBy: ", "))
                    }
                    print("Results \(possibleRecipes)")
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("finished all tasks")
            completion(possibleIngredients)
        }
    }
    static func checkIngredientsInRecipe(recipeIngredients: [String], allergies: [Allergy]) -> [String]? {
        var possibleAllergies = [String]()
        for ingredient in recipeIngredients {
            for allergy in allergies {
                if allergy.isAllergic {
                    var lsum = Double(ingredient.count)
                    if ingredient.count < allergy.allergyName.count {
                        lsum = Double(allergy.allergyName.count)
                    }
                    let dist = LevenshteinDistance(s: ingredient.lowercased(), t: allergy.allergyName.lowercased())
                    if ((1.0 - (Double(dist!)/lsum)) * 100.0) >= 30 {
                        if !possibleAllergies.contains(ingredient) {
                            possibleAllergies.append(ingredient)
                        }
                        print("WARN \(((1.0 - (Double(dist!)/lsum)) * 100.0) >= 30) \(((1.0 - (Double(dist!)/lsum)) * 100.0)) \(ingredient) \(allergy.allergyName)")
                    }
                } else {
                    continue
                }
            }
        }
        return possibleAllergies
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
            let index = s.lowercased().index(s.startIndex, offsetBy: i)
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
    static func diceCoefficient(s: String, t: String) -> Float {
        if s == t {
            return 1
        }

        if s.count < 2 || t.count < 2 {
            return 0
        }
        
//        var firstArray = bigrams(s: s)
//        var secondArray = bigrams(s: t)

        let sortedBigrams: [String] = bigrams(s: s).sorted()
        let otherSortedBigrams = bigrams(s: t).sorted()

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

        return Float(matches * 2) / Float(sortedBigrams.count + otherSortedBigrams.count)
    }
   
    static func diceCoeffitient(s: String, t: String) -> Double {
        if s.count < 2 || t.count < 2 {
            return 0
        }
        var bigrams = [String : Int]()
        for i in 0..<s.count - 1 {
            let bigram = String(s[i...i+2])
            print(bigram)
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
