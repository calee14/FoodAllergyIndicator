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

    @IBOutlet weak var resultsTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var concepts: [ClarifaiConcept] = []
    var resultString = "These are the results \n"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        concepts = [ClarifaiConcept(conceptName: "Egg"), ClarifaiConcept(conceptName: "Nuts")]
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            CheckService.checkAllergies(ingreidents: self.concepts, allergies: allergies, completion: { (allergens) in
                guard let allergens = allergens else { return }
                print(allergens)
            })
        }
        for concept in concepts {
            resultString += ("Prediction name: \(concept.conceptName) \n")
            resultString += ("Prediction score: \(concept.score) \n")
        }
//        resultsTextView.text = resultString
        // Do any additional setup after loading the view.
        print("Photo Result")
    }

}

extension PhotoResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concepts
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as! ResultsTableViewCell
        cell.ingredientLabel = concepts
        return UITableViewCell()
    }
}
