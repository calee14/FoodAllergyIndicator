//
//  CheckAllergyService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/27/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import Clarifai

struct CheckService {
    static func checkAllergies(ingreidents: [ClarifaiConcept], allergies: [Allergy], completion: @escaping ([String]?) -> Void) {
        var possibleAllergies = [String]()
        for i in ingreidents {
            for j in allergies {
                if i.conceptName == j.allergyName {
                    possibleAllergies.append(i.conceptName)
                }
            }
        }
        completion(possibleAllergies)
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
    
    static func LevenshteinDistance(s: String, t: String) -> Int{
        var d = [[Int]]()
        var n: Int
        var m: Int
        var i: Int
        var j: Int
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
        
        for i in 0...n+1 {
            d[i][0] = i
        }
        
        for j in 0...m+1 {
            d[j][0] = j
        }
        
        for i in 1...n+1 {
//            s_i = 
        }
        return 0
    }
}
