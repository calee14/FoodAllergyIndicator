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
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout() {
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)

        backgroundView.applyGradient(colours: [lightblue, cyan])
        
        nextButton.layer.cornerRadius = CGFloat(10)
    }
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text
        let email = "\(username)@test.com"
        
        Auth.auth().createUser(withEmail: email, password: password!) { (authData, error) in
            if let error = error {
                assertionFailure("Error: creating user: \(error.localizedDescription)")
                return
            }
            guard (authData?.user) != nil else { return }
            
            guard let firUser = Auth.auth().currentUser,
                let username = self.usernameTextField.text,
                !username.isEmpty else { return }
            
            UserService.create(firUser, username: username) { (user) in
                guard let user = user else { return }
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                AllergyService.setAllergies(for: user, allergies: AllergyService.initializeEmptyAllergies(), completion: { (allergy) in
                    print(allergy)
                })
                
                let initialViewController = UIStoryboard.initializeViewController(for: .main)
                
                HomeViewController.shouldDisplayDisclaimer = true
                
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
            
        }
        
//        UserService.create(firUser, username: username) { (user) in
//            guard let user = user else { return }
//
//            User.setCurrent(user, writeToUserDefaults: true)
//
//            AllergyService.setAllergies(for: user, allergies: AllergyService.initializeEmptyAllergies(), completion: { (allergy) in
//                print(allergy)
//            })
//
//            let initialViewController = UIStoryboard.initializeViewController(for: .main)
//
//            HomeViewController.shouldDisplayDisclaimer = true
//
//            self.view.window?.rootViewController = initialViewController
//            self.view.window?.makeKeyAndVisible()
//        }
    }
    
    
}
