//
//  StorageService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/25/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import FirebaseStorage

class StorageService {
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }
        
        reference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        }
    }
}
