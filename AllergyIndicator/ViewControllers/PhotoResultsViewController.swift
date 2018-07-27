//
//  PhotoResultsViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK
import Clarifai

class PhotoResultsViewController: UIViewController {

    @IBOutlet weak var resultsTextView: UITextView!
    var concepts: [ClarifaiConcept] = []
    var resultString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for concept in concepts {
            resultString += ("Prediction name: \(concept.conceptName) \n")
            resultString += ("Prediction score: \(concept.score) \n")
        }
        resultsTextView.text = resultString
        // Do any additional setup after loading the view.
        print("Photo Result")
    }

}
