//
//  AllergyService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct AllergyService {
    
    static func setAllergies(for user: User, allergies: [Allergy], completion: @escaping ([Allergy]) -> Void) {
        var results = [String : Any]()
        for allergy in allergies {
            results[allergy.allergyName] = allergy.isAllergic
        }
        print(results)
        
        let ref = Database.database().reference().child("allergies").child(user.uid)
        ref.setValue(results) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String : Any] else { return }
                var allergiesResult = [Allergy]()
                for allergyName in Constants.Allergens.allergenNames {
                    var allergy = Allergy(allergyName, isAllergic: dict[allergyName] as! Bool)
                    allergiesResult.append(allergy)
                }
                completion(allergiesResult)
            })
        }
    }
    static func retrieveAllergies(for user: User, completion: @escaping ([Allergy?]) -> Void) {
        var allergens = [Allergy]()
        
        let ref = Database.database().reference().child("allergies").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else { return }
            for allergyName in Constants.Allergens.allergenNames {
                guard let isAllergic: Bool = dict[allergyName] as? Bool else { fatalError("There was no boolean in \(allergyName)") }
                let allergy: Allergy = Allergy(allergyName, isAllergic: isAllergic)
                allergens.append(allergy)
            }
        }
        
        completion(allergens)
    }
}
