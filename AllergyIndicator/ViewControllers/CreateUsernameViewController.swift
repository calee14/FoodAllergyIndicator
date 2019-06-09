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

typealias FIRUser = FirebaseAuth.User

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .newPassword
        } else {
            // Fallback on earlier versions
        }
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout() {
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        errorLabel.isHidden = true
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)

        backgroundView.applyGradient(colours: [lightblue, cyan])
        
        nextButton.layer.cornerRadius = CGFloat(10)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        nextButton.isUserInteractionEnabled = false
        var username = usernameTextField.text!
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text
        let email = "\(username)@test.com"
        
        Auth.auth().createUser(withEmail: email, password: password!) { (authData, error) in
            if let error = error {
                self.errorLabel.isHidden = false
//                assertionFailure("Error: creating user: \(error.localizedDescription)")
                print(error.localizedDescription)
                if error.localizedDescription == "The email address is already in use by another account." {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.errorLabel.text = "The username has already been taken."
                    })
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.errorLabel.text = "The password must be 6 characters long or more."
                    })
                }
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
