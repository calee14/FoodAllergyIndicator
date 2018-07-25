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
    
    private static let DatabaseAllergiesPath = Constants.DatabasePath.allergies
    
    static func setAllergies(for user: User, allergies: [Allergy], completion: @escaping ([Allergy]) -> Void) {
        var results = [String : Any]()
        for allergy in allergies {
            results[allergy.allergyName] = allergy.isAllergic
        }
        
        let ref = Database.database().reference().child(DatabaseAllergiesPath).child(user.uid)
        ref.setValue(results) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? [String : Any] else { return }
                var allergiesResult = [Allergy]()
                for allergyName in Constants.Allergens.allergenNames {
                    let allergy = Allergy(allergyName, isAllergic: dict[allergyName] as! Bool)
                    allergiesResult.append(allergy)
                }
                completion(allergiesResult)
            })
        }
    }
    static func retrieveAllergies(for user: User, completion: @escaping ([Allergy]) -> Void) {
        var allergens = [Allergy]()
        
        let ref = Database.database().reference().child(DatabaseAllergiesPath).child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else { return }
            for allergyName in Constants.Allergens.allergenNames {
                guard let isAllergic: Bool = dict[allergyName] as? Bool else { fatalError("There was no boolean data type in \(allergyName)") }
                let allergy: Allergy = Allergy(allergyName, isAllergic: isAllergic)
                allergens.append(allergy)
            }
            completion(allergens)
        }
    }
    
    static func updateAllergy(for user: User, allergy: Allergy, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child(DatabaseAllergiesPath).child(user.uid)
        let allergyData = [allergy.allergyName : allergy.isAllergic]
        ref.updateChildValues(allergyData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            success(error == nil)
        }
    }
    
    static func initializeEmptyAllergies() -> [Allergy] {
        var allergyArray = [Allergy]()
        for allergyName in Constants.Allergens.allergenNames {
            let allergy = Allergy(allergyName, isAllergic: false)
            allergyArray.append(allergy)
        }
        return allergyArray
    }
}
