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
    @IBOutlet weak var backButton: UIButton!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupLayout() {
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        errorLabel.isHidden = true
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)

        backgroundView.applyGradient(colours: [lightblue, cyan])
        
        nextButton.layer.cornerRadius = CGFloat(10)
        
        // Change the layout and position of back button
        backButton.frame = CGRect(x: 20, y: 45, width: 40, height: 40)
        backButton.titleLabel?.textColor = UIColor(red: 249, green: 248, blue: 248)
        backButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        backButton.backgroundColor = .clear
        backButton.layer.borderWidth = 2.0
        backButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        backButton.layer.cornerRadius = min(backButton.frame.width, backButton.frame.height) / 2
        
    }
    
    /* Checks the text fields if they're empty or not
     returns true if empty and false if not empty */
    func textFieldsEmpty() -> Bool {
        if(usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty) {
            return true
        }
        return false
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
                self.nextButton.isUserInteractionEnabled = true
                return
            }
            guard (authData?.user) != nil else { return }
            
            guard let firUser = Auth.auth().currentUser,
                let username = self.usernameTextField.text,
                !username.isEmpty else { return }
            
            UserService.create(firUser, username: username) { (user) in
                guard let user = user else { return }
                
                User.setCurrent(user, writeToUserDefaults: true)
                
//                AllergyService.setAllergies(for: user, allergies: AllergyService.initializeEmptyAllergies(), completion: { (allergy) in
//                    print("The allergy: \(allergy) has been set")
//                })
                
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
