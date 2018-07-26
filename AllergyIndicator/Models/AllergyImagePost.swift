//
//  AllergyImagePost.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/25/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class AllergyImagePost {
    var key: String?
    let imageURL: String
    // might not need it
    var imageHeight: CGFloat
    let creationDate: Date
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo]
    }
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    
}
