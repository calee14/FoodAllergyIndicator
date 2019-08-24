//
//  ActualUserLoginViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/3/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

let signinButtonTitle = "Continue"

class ActualUserLoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    
    let activityData = ActivityData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For the password text field making sure everything is hidden
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .newPassword
        }
        passwordTextField.isSecureTextEntry = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        // Hide the error label until there is an error to display
        self.errorLabel.isHidden = true
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)
        backgroundView.applyGradient(colours: backgroundGradients)
        
        loginButton.applyDefaultColoredButtonStyle()
        loginButton.setTitle(signinButtonTitle, for: .normal)
    }
    
    /* Checks the text fields if they're empty or not
     returns true if empty and false if not empty */
    func textFieldsEmpty() -> Bool {
        if (usernameTextField.text == nil || passwordTextField.text == nil) {
            return true;
        }
        return usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termOfUseTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        termsViewController.term = .terms
        self.navigationController?.present(termsViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        /* Login in the user with the credentials they
         inputted */
        
        // check if the text fields are empty and if so change the error label
        if(textFieldsEmpty()) {
            self.errorLabel.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.errorLabel.text = "Make sure to fill out all boxes"
            })
            return
        }
        
        loginButton.isUserInteractionEnabled = false
        
        var username = usernameTextField.text!
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        // temporarily create an email until require field for real email
        let email = "\(username)\(Constants.Username.domain)"
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authData, error in
            guard let strongSelf = self else {
                self?.loginButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            if let error = error {
                self?.errorLabel.isHidden = false
                self?.loginButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            guard (authData?.user) != nil else {
                self?.loginButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            guard let firUser = Auth.auth().currentUser else {
                self?.loginButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
            }
            
            /* Retrieve the user info from the db,
             create a new User object with the data from the db,
             then set the current User for the app to user defaults */
            UserService.retrieve(firUser, completion: { (user) in
                strongSelf.loginButton.isUserInteractionEnabled = true
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

                guard let user = user else { return }
                
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initializeViewController(for: .main)
                strongSelf.view.window?.rootViewController = initialViewController
                strongSelf.view.window?.makeKeyAndVisible()
            })
        }
    }
}
