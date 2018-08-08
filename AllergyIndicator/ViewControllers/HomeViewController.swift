//
//  HomeViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var setAllergiesButton: UIButton!
    @IBOutlet weak var takePhotoBackground: UIView!
    @IBOutlet weak var setAllergiesBackground: UIView!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var termsBackground: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var leftButtonBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPHelper.shared.getProducts()
//        IngredientService.addIngredient(ingredientNames: ["egg", "toast", "grapes"]) { (success) in
//            print(success)
//        }
//        IngredientService.doesIngredientExists(ingredientName: "egg") { (exist) in
//            print(exist)
//        }
//        print("test \(CheckService.diceCoefficient(s: "I bet my life", t: "I bet your life"))")
//        fatalError()
        // Do any additional setup after loading the view.
        
//        AllergyService.checkIfUserHasSetAllergies(for: User.current) { (hasSet) in
//            if !hasSet {
//                print("move to next controleler")
//                self.goToSetAllergiesViewController()
//            } else {
//                // Do something if the user has already set their allergies
//            }
//        }
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            let doesHaveAllergies = allergies.filter { $0.isAllergic != false }
            if doesHaveAllergies.count == 0 {
                print("move to next controleler")
                self.goToSetAllergiesViewController()
            } else {
                // Do something if the user has already set their allergies
            }
        }
        setupLayout()
    }
    
    func setupLayout() {
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [lightblue , cyan])
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.alpha = 0.95
        
        takePhotoButton.backgroundColor = cyan
        
        takePhotoButton.layer.cornerRadius = 6
        takePhotoButton.clipsToBounds = false
        
        takePhotoBackground.layer.cornerRadius = 6
        takePhotoBackground.layer.masksToBounds = true
        
        setAllergiesButton.backgroundColor = cyan

        setAllergiesButton.layer.cornerRadius = 6
        setAllergiesButton.clipsToBounds = false
        
        setAllergiesBackground.layer.cornerRadius = 6
        setAllergiesBackground.layer.masksToBounds = true
        
        termsButton.layer.cornerRadius = 6
        termsButton.clipsToBounds = false
        
        termsButton.backgroundColor = cyan
        
        termsBackground.layer.cornerRadius = 6
        termsBackground.layer.masksToBounds = true
        
        leftButton.layer.cornerRadius = 6
        leftButton.clipsToBounds = false
        
        leftButton.backgroundColor = cyan
        leftButton.setTitle("Pictures: \(Pictures.current.numpictures)", for: .normal)
        
        leftButtonBackground.layer.cornerRadius = 6
        leftButtonBackground.layer.masksToBounds = true
    }
    
    func toggleTakePhotoButton(status: Bool) {
        takePhotoButton.isUserInteractionEnabled = status
    }
    
    func toggleSetAllergiesButton(status: Bool) {
        setAllergiesButton.isUserInteractionEnabled = status
    }
    
    func toggleTermsButton(status: Bool) {
        termsButton.isUserInteractionEnabled = status
    }
    
    func toggleLeftButton(status: Bool) {
        leftButton.isUserInteractionEnabled = status
    }
    
    func goToSetAllergiesViewController() {
        defer {
            toggleTakePhotoButton(status: true)
            toggleTermsButton(status: true)
            toggleLeftButton(status: true)
        }
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let setAllergiesController = storyboard.instantiateViewController(withIdentifier: "SetAllergiesViewController") as! SetAllergiesViewController
        
        self.navigationController?.pushViewController(setAllergiesController, animated: true)
    }
    
    func goToTakePhotoViewController() {
        defer {
            toggleSetAllergiesButton(status: true)
            toggleTermsButton(status: true)
            toggleLeftButton(status: true)
        }
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let takePhotoController = storyboard.instantiateViewController(withIdentifier: "TakePhotoViewController") as! TakePhotoViewController
        
        self.navigationController?.pushViewController(takePhotoController, animated: true)
    }
    
    func goToTermsOfServiceViewController() {
        defer {
            toggleSetAllergiesButton(status: true)
            toggleTakePhotoButton(status: true)
            toggleLeftButton(status: true)
        }
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    func goDoWhateverLeftButtonDoes() {
        defer {
            toggleSetAllergiesButton(status: true)
            toggleTakePhotoButton(status: true)
            toggleTermsButton(status: true)
        }
    }
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func takePhotoHighlight(_ sender: UIButton) {
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.takePhotoButton.backgroundColor = .white
            self.takePhotoButton.setTitleColor(lightblue, for: .normal)
            self.takePhotoBackground.applyGradient(colours: [lightblue , cyan])
        }
    }
    
    @IBAction func takePhotoEnd(_ sender: UIButton) {
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func setAllergiesButtonTapped(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
    @IBAction func setAllergiesHighlight(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.setAllergiesButton.backgroundColor = .white
            self.setAllergiesBackground.applyGradient(colours: [lightblue , cyan])
            self.setAllergiesButton.setTitleColor(lightblue, for: .normal)
        }
        
    }
    @IBAction func setAllergiesEnd(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.termsButton.backgroundColor = cyan
        self.termsBackground.removeGradient()
        self.termsButton.setTitleColor(.white, for: .normal)
        self.goToTermsOfServiceViewController()
    }
    
    @IBAction func termsHighlight(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.termsButton.backgroundColor = .white
            self.termsBackground.applyGradient(colours: [lightblue , cyan])
            self.termsButton.setTitleColor(lightblue, for: .normal)
        }
    }
    
    @IBAction func termsEnd(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.termsButton.backgroundColor = cyan
        self.termsBackground.removeGradient()
        self.termsButton.setTitleColor(.white, for: .normal)
        self.goToTermsOfServiceViewController()
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.leftButton.backgroundColor = cyan
        self.leftButtonBackground.removeGradient()
        self.leftButton.setTitleColor(.white, for: .normal)
        self.goDoWhateverLeftButtonDoes()
    }
    
    
    @IBAction func leftButtonHighlighted(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.leftButton.backgroundColor = .white
            self.leftButtonBackground.applyGradient(colours: [lightblue , cyan])
            self.leftButton.setTitleColor(lightblue, for: .normal)
        }
    }
    
    @IBAction func leftButtonEnd(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.leftButton.backgroundColor = cyan
        self.leftButtonBackground.removeGradient()
        self.leftButton.setTitleColor(.white, for: .normal)
        self.goDoWhateverLeftButtonDoes()
//        sender.isSelected = false
    }
    
    
}
