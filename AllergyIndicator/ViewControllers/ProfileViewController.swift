//
//  ProfileViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/7/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupLayout()
    }
    
    func setupLayout() {
        
        let red = UIColor.init(red: 255, green: 38, blue: 0)
        
        // Styles for the logout button
        logoutButton.layer.borderColor = red.cgColor
        logoutButton.layer.borderWidth = CGFloat(2)
        logoutButton.layer.cornerRadius = CGFloat(10)
        logoutButton.backgroundColor = .clear
        logoutButton.clipsToBounds = true
        self.logoutButton.setBackgroundColor(color: .white, forState: .normal)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let red = UIColor.init(red: 255, green: 38, blue: 0)
        self.logoutButton.setTitleColor(red, for: .normal)
    }
    @IBAction func logoutButtonHighlight(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            let red = UIColor.init(red: 255, green: 38, blue: 0)
            self.logoutButton.backgroundColor = red
            self.logoutButton.setTitleColor(.white, for: .normal)
        }
        
    }
    
}
