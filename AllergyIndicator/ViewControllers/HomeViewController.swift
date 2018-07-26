//
//  HomeViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var setAllergiesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            let doesHaveAllergies = allergies.filter { $0.isAllergic != false }
            if doesHaveAllergies.count == 0 {
                print("move to next controleler")
                self.goToSetAllergiesViewController()
            } else {
                // Do something if the user has already set their allergies
            }
        }
    }
    
    func goToSetAllergiesViewController() {
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let setAllergiesController = storyboard.instantiateViewController(withIdentifier: "SetAllergiesViewController") as! SetAllergiesViewController
        
        self.navigationController?.pushViewController(setAllergiesController, animated: true)
    }
    
    func goToTakePhotoViewController() {
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let takePhotoController = storyboard.instantiateViewController(withIdentifier: "TakePhotoViewController") as! TakePhotoViewController
        
        self.navigationController?.pushViewController(takePhotoController, animated: true)
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        self.goToTakePhotoViewController()
    }
    
    @IBAction func setAllergiesButtonTapped(_ sender: UIButton) {
        self.goToSetAllergiesViewController()
    }
}
