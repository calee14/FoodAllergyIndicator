//
//  PhotoResultsViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK

class PhotoResultsViewController: UIViewController {

    @IBOutlet weak var resultsTextView: UITextView!
    var concepts: [Concept] = []
    var g = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for concept in concepts {
            g += ("Prediction name: \(concept.name) \n")
            g += ("Prediction score: \(concept.score) \n")
        }
        resultsTextView.text = g
        // Do any additional setup after loading the view.
        print("Photo Result")
    }

}
