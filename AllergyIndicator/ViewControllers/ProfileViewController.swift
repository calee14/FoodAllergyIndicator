//
//  ProfileViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/7/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit
import Clarifai_Apple_SDK
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var pictureLeftLabel: UILabel!
    @IBOutlet weak var pictureTakenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setStrings();
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
    
    func setStrings() {
     
        usernameLabel.text = User.current.username
        emailLabel.text = User.current.email
        pictureLeftLabel.text = "\(Pictures.current.numpictures)"
    }
    
    @IBAction func tosButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        termsViewController.term = .terms
        self.present(termsViewController, animated: true, completion: nil)
    }
    
    @IBAction func thirdPartyLicenseButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        termsViewController.term = .thirdyPartyLicense
        self.present(termsViewController, animated: true, completion: nil)
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
