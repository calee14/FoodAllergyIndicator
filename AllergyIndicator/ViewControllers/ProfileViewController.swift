//
//  ProfileViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/7/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)
        backgroundView.applyGradient(colours: backgroundGradients)
        
        // Styles for the logout button
        logoutButton.layer.borderColor = UIColor.init(red: 255, green: 38, blue: 0).cgColor
        logoutButton.layer.borderWidth = CGFloat(2)
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.backgroundColor = .clear
        logoutButton.clipsToBounds = true
        logoutButton.setBackgroundColor(color: .white, forState: .normal)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let red = UIColor.init(red: 255, green: 38, blue: 0)
        self.logoutButton.setTitleColor(red, for: .normal)
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            removeUserDefaultsData()
            goToLanding()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func goToLanding() {

        let initialViewController = UIStoryboard.initializeViewController(for: .login)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func removeUserDefaultsData() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.currentUser)
    }
    
    @IBAction func logoutButtonHighlight(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            let red = UIColor.init(red: 255, green: 38, blue: 0)
            self.logoutButton.backgroundColor = red
            self.logoutButton.setTitleColor(.white, for: .normal)
        }
    }
}
