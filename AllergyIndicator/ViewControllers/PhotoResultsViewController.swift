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
    var allergens: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        concepts = [ClarifaiConcept(conceptName: "Pizza"), ClarifaiConcept(conceptName: "Spaghetti")]
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            CheckService.checkAllergies(ingreidents: self.concepts, allergies: allergies, completion: { (allergens) in
                guard let allergens = allergens else { return }
                self.allergens = allergens
                self.tableView.reloadData()
                print(allergens)
            })
        }
        CheckService.checkRecipe(foodQueries: concepts.map { $0.conceptName }) { (result) in
//            print(result?.results[0].ingredients)
        }
        // Do any additional setup after loading the view.
        print("Photo Result")
    }

}

extension PhotoResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concepts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell") as! ResultsTableViewCell
        let ingredientdata = concepts[indexPath.row]
        cell.ingredientLabel.text = ingredientdata.conceptName
        cell.scoreLabel.text = String(ingredientdata.score)
        if allergens.contains(ingredientdata.conceptName) {
            cell.ingredientLabel.textColor = .red
        } else {
            cell.ingredientLabel.textColor = .green
        }
        return cell
    }
}
