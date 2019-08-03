//
//  LoginViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import FirebaseUI
//import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var actualLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout() {
        
        self.navigationController?.isNavigationBarHidden = true
        
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)
        
        backgroundView.applyGradient(colours: [lightblue, cyan])
        
        loginButton.layer.cornerRadius = CGFloat(10)
        
        actualLoginButton.layer.cornerRadius = CGFloat(10)
        
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
//        guard let authUI = FUIAuth.defaultAuthUI() else { return }
//        authUI.delegate = self
//
//        let authViewController = authUI.authViewController()
//
//        present(authViewController, animated: true)
        /* Perform the seque to the sign up vc */
        self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
    }
    
    @IBAction func actualLoginButtonTapped(_ sender: UIButton) {
        
        /* Perform the seque to the login vc
         here ...
         */
        self.performSegue(withIdentifier: Constants.Segue.loginUser, sender: self)
        
    }
    
}

//extension LoginViewController: FUIAuthDelegate {
//    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
//        if let error = error {
//            assertionFailure("Error: signing in: \(error.localizedDescription)")
//            return
//        }
//
//        guard let user = user else { return }
//
//        UserService.show(forUID: user.uid) { (user) in
//            if let user = user {
//                User.setCurrent(user, writeToUserDefaults: true)
//
//                let initialViewController = UIStoryboard.initializeViewController(for: .main)
//
//                HomeViewController.shouldDisplayDisclaimer = true
//
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
//            } else {
//                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
//            }
//        }
//        print("handle user signup / login")
//    }
//}
