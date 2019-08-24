//
//  LoginViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

let titleText = "WHATS\nINGREDIENT"
let descriptionText = "AI-powered camera to help you find the general ingredients in your food."
let registerButtonTitle = "GET STARTED"
let loginButtonTitle = "Already an user? Sign in!"

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var actualLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        backgroundView.applyGradient(colours: backgroundGradients)
    
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        
        registerButton.setTitle(registerButtonTitle, for: .normal)
        registerButton.applyDefaultColoredButtonStyle()

        actualLoginButton.setTitle(loginButtonTitle, for: .normal)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        /* Perform the seque to the sign up vc */
        self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
    }
    
    @IBAction func actualLoginButtonTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: Constants.Segue.loginUser, sender: self)
    }
}
