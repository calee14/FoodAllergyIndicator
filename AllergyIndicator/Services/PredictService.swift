//
//  PredictService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/26/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK

struct PredictService {
    static func predictFoodInImage(image: UIImage, completion: @escaping ([Concept]?) -> Void) {
        // initialize variables
        var concepts: [Concept] = []
        var model: Model!
        
        model = Clarifai.sharedInstance().generalModel
        
        let image = Image(image: image)
        
        let dataAsset = DataAsset.init(image: image)
        
        let input = Input.init(dataAsset: dataAsset)
        let inputs = [input]
        
        model.predict(inputs) { (outputs, error) in
            guard let outputs = outputs else { return completion(nil) }
            for output in outputs {
                concepts.append(contentsOf: output.dataAsset.concepts!)
            }
            completion(concepts)
        }
        
    }
    
    static func predictFoodImage(image: UIImage, completion: @escaping ([Concept]?) -> Void) {

        Clarifai.sharedInstance().load(entityId: "food-items-v1.0", entityType: .model) { (entity, error) in
            guard let model = entity as? Model else {
                return
            }
            
            let image = Image(image: image)
            let dataAsset = DataAsset.init(image: image)
            let input = Input.init(dataAsset: dataAsset)
            
            model.predict([input], completionHandler: { (outputs, error) in
                guard let outputs = outputs else { return completion(nil) }
                if let output = outputs.first {
                    let concepts = output.dataAsset.concepts
                    completion(concepts)
                }
            })
        }
    }
}
