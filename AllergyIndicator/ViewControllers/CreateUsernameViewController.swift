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
import NVActivityIndicatorView

typealias FIRUser = FirebaseAuth.User

let signUpButtonTitle = "Confirm"

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    
    let activityData = ActivityData()

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
        errorLabel.isHidden = true
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)

        backgroundView.applyGradient(colours: backgroundGradients)
        
        nextButton.applyDefaultColoredButtonStyle()
        nextButton.setTitle(signUpButtonTitle, for: .normal)
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
    
    @IBAction func termsOfUseButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)        
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.navigationController?.present(termsViewController, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        /* Create a new user with the credentials he or she
         inputted */
        
        // check if the text fields are empty and if so change the error label
        if(textFieldsEmpty()) {
            self.errorLabel.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.errorLabel.text = "Make sure to fill out all boxes"
            })
            return
        }
        
        if(!emailTextField.text!.isValidEmail()) {
            self.errorLabel.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.errorLabel.text = "This is an invalid email address."
            })
            return
        }
        
        /* Disable sign up button so the function isn't called more than once */
        nextButton.isUserInteractionEnabled = false
        
        var username = usernameTextField.text!
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        /* This email variable is a concatenation of the username
         The actual email the user inputs is for IAP, receipts, and user contact */
        let email = "\(username)\(Constants.Username.domain)"
        let actualUserEmail = emailTextField.text!
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)

        UserService.doesEmailExist(for: actualUserEmail) { (doesExists) in
            if doesExists {
                self.errorLabel.isHidden = false
                UIView.animate(withDuration: 0.1, animations: {
                    self.errorLabel.text = "This email is already in use by another account."
                })
                self.nextButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            } else if !doesExists {
                self.createNewUser(email: email, actualUserEmail: actualUserEmail, username: username, password: password)
            }
        }
    }
    
    /* Use Firebase Auth API to create a new user,
     update the user info in the database,
     and store the user locally in User defaults */
    func createNewUser(email: String, actualUserEmail: String, username: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                self.errorLabel.isHidden = false

                if error.localizedDescription == "The email address is badly formatted." {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.errorLabel.text = "This is an invalid email address."
                    })
                }
                if error.localizedDescription == "The email address is already in use by another account." {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.errorLabel.text = "The username has already been taken."
                    })
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.errorLabel.text = "The password must be 6 characters long or more.awdawawdawdawd"
                    })
                }
                self.nextButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            guard (authData?.user) != nil else {
                self.nextButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            guard let firUser = Auth.auth().currentUser,
                let username = self.usernameTextField.text,
                !username.isEmpty else {
                    self.nextButton.isUserInteractionEnabled = true
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    return
            }
            
            UserService.create(firUser, username: username, email: actualUserEmail) { (user) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                guard let user = user else {
                    self.nextButton.isUserInteractionEnabled = true
                    return
                }
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initializeViewController(for: .main)
                
                HomeViewController.shouldDisplayDisclaimer = true
                
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
