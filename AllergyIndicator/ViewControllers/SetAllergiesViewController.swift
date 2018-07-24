//
//  SetAllergiesViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class SetAllergiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allergens = [Allergy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
}

extension SetAllergiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Allergens.allergenNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllergyCell") as! AllergyTableViewCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: AllergyTableViewCell, atIndexPath indexPath: IndexPath) {
        
    }
}

extension SetAllergiesViewController: IsAllergicCellDelegate {
    func didSwitchAllergicSwitch(_ isAllergicSwitch: UISwitch, on cell: AllergyTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        isAllergicSwitch.isUserInteractionEnabled = false
//        let allergen =
    }
    

}
