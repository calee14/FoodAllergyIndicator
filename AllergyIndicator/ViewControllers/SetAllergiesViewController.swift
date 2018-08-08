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
    
    private var user = User.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load allergies
        AllergyService.retrieveAllergies(for: user) { (allergies) in
            var allergens = [Allergy]()
            for allergy in allergies {
                if allergy.isAllergic {
                    print("stuff")
                    allergens.insert(allergy, at: 0)
                } else {
                    allergens.append(allergy)
                }
            }
            self.allergens = allergens
            self.tableView.reloadData()
        }
    }
}

extension SetAllergiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allergens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllergyCell") as! AllergyTableViewCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func configure(cell: AllergyTableViewCell, atIndexPath indexPath: IndexPath) {
        let allergy = allergens[indexPath.row]
        cell.allergenName?.text = allergy.allergyName
        cell.isAllergicSwitch.isOn = allergy.isAllergic
    }
}

extension SetAllergiesViewController: IsAllergicCellDelegate {
    func didSwitchAllergicSwitch(_ isAllergicSwitch: UISwitch, on cell: AllergyTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        isAllergicSwitch.isUserInteractionEnabled = false
        
        self.allergens[indexPath.row].isAllergic = isAllergicSwitch.isOn
        
        AllergyService.updateAllergy(for: user, allergy: self.allergens[indexPath.row]) { (snapshot) in
            defer {
                isAllergicSwitch.isUserInteractionEnabled = true
            }
            guard snapshot != nil else { return }
            
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
