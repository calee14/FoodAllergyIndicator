//
//  PostImageService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/25/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostImageService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            create(forURLString: urlString, aspectHeight: 320)
        }
    }
    
    static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        
        let currentUser = User.current
        let post = AllergyImagePost(imageURL: urlString, imageHeight: aspectHeight)
        
        let dict = post.dictValue
        
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("images").child(currentUser.uid).childByAutoId()
        newPostRef.updateChildValues(dict)
    }
}

