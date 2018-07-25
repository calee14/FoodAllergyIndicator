//
//  HomeViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        AllergyService.retrieveAllergies(for: User.current) { (alleriges) in
            let allergyCount = alleriges.count
            if allergyCount == 0 {
                // if the user hasn't set allergies yet
                AllergyService.setAllergies(for: User.current, allergies: AllergyService.initializeEmptyAllergies(), completion: { (allergies) in
                    
                    self.goToSetAllergiesViewController()
                })
            } else {
                // do something if the user has already set allergies
            }
        }
    }
    
    func goToSetAllergiesViewController() {
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let setAllergiesController = storyboard.instantiateViewController(withIdentifier: "SetAllergiesViewController") as! SetAllergiesViewController
        
        self.navigationController?.pushViewController(setAllergiesController, animated: true)
    }
}
