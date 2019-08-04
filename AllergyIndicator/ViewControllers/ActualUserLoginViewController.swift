//
//  ActualUserLoginViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/3/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit

class ActualUserLoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For the password text field making sure everything is hidden
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .newPassword
        } else {
            // Fallback on earlier versions
        }
        passwordTextField.isSecureTextEntry = true
        
        // Adds tap recoginizer to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    func setupLayout() {
        
        // Hide the error label until there is an error to display
        self.errorLabel.isHidden = true
        
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: backgroundView.frame.height)
        
        backgroundView.applyGradient(colours: [lightblue, cyan])
        
        loginButton.layer.cornerRadius = CGFloat(10)
        
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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        }
        
        loginButton.isUserInteractionEnabled = false
        
        var username = usernameTextField.text!
        username = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text
        // temporarily create an email until require field for real email
        let email = "\(username)@test.com"
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
