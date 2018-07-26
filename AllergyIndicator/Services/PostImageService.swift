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
        let imageRef = Storage.storage().reference().child("test_image.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
        }
    }
}

