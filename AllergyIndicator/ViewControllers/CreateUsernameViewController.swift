//
//  CreateUsernameViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            AllergyService.setAllergies(for: user, allergies: AllergyService.initializeEmptyAllergies(), completion: { (allergy) in
                print(allergy)
            })
            
            let initialViewController = UIStoryboard.initializeViewController(for: .main)
            
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    
}
