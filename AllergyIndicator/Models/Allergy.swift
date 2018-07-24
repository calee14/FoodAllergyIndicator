//
//  File.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class Allergy {
    let allergyName: String
    let isAllergic: Bool
    
    init(_ allergyName: String, isAllergic: Bool) {
        self.allergyName = allergyName
        self.isAllergic = isAllergic
    }
}
