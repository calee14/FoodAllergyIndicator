//
//  StorageReference+Post.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/26/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
