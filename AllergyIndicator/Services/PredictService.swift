//
//  PredictService.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/26/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK
import Clarifai

struct PredictService {
    static func predictFoodInImage(image: UIImage, completion: @escaping ([Concept]?) -> Void) {
        // initialize variables
        var concepts: [Concept] = []
        let model = Clarifai.sharedInstance().generalModel
        
        let image = Image(image: image)
        let dataAsset = DataAsset.init(image: image)
        let input = Input.init(dataAsset: dataAsset)
        let inputs = [input]
        
        model.predict(inputs) { (outputs, error) in
            guard let outputs = outputs else { return completion(nil) }
            for output in outputs {
                if let dataConcepts = output.dataAsset.concepts {
                    concepts.append(contentsOf: dataConcepts)
                }
            }
            completion(concepts)
        }
    }
    
    static func predictFoodImage(image: UIImage, completion: @escaping ([ClarifaiConcept]?) -> Void) {
        // add the api here
        let apikey = ConstantsAPI.clarifaiapi.key
        let app = ClarifaiApp(apiKey: apikey)
        
        if let app = app {
            app.getModelByName("food-items-v1.0", completion: { (model, error) in
                let clarifaiImage = ClarifaiImage(image: image)!
                model?.predict(on: [clarifaiImage], completion: { (outputs, error) in
                    guard let outputs = outputs else { return completion(nil) }
                    if let output = outputs.first {
                        let concepts = output.concepts
                        completion(concepts)
                    } else {
                        completion(nil)
                    }
                })
            })
        } else {
            completion(nil)
        }
    }
}
