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
                if let dist = LevenshteinDistance(s: i.conceptName.lowercased(), t: j.allergyName.lowercased()), ((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0) >= 90 {
                    print("blah \(((1.0 - (Double(dist)/Double(min(i.conceptName.count, j.allergyName.count)))) * 100.0)) \(j.allergyName) \(i.conceptName)")
                    print("blah \(dist) \((1 - (dist/min(i.conceptName.count, j.allergyName.count)))) \((dist/min(i.conceptName.count, j.allergyName.count))) \(min(i.conceptName.count, j.allergyName.count))")
                    print(((1 - (dist/min(i.conceptName.count, j.allergyName.count))) * 100) >= 90)
                    print(i.conceptName)
                    print(j.allergyName)
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
}
