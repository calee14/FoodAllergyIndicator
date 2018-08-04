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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IngredientService.addIngredient(ingredientNames: ["egg", "toast", "grapes"]) { (success) in
            print(success)
        }
        print(IngredientService.doesIngredientExists(ingredientName: "egg"))
        print("test \(CheckService.diceCoefficient(s: "I bet my life", t: "I bet your life"))")
//        fatalError()
        // Do any additional setup after loading the view.
        
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
        
    }
    
    func toggleTakePhotoButton(status: Bool) {
        takePhotoButton.isUserInteractionEnabled = status
    }
    
    func toggleSetAllergiesButton(status: Bool) {
        setAllergiesButton.isUserInteractionEnabled = status
    }
    
    func goToSetAllergiesViewController() {
        toggleTakePhotoButton(status: true)
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let setAllergiesController = storyboard.instantiateViewController(withIdentifier: "SetAllergiesViewController") as! SetAllergiesViewController
        
        self.navigationController?.pushViewController(setAllergiesController, animated: true)
    }
    
    func goToTakePhotoViewController() {
        defer {
            toggleSetAllergiesButton(status: true)
        }
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let takePhotoController = storyboard.instantiateViewController(withIdentifier: "TakePhotoViewController") as! TakePhotoViewController
        
        self.navigationController?.pushViewController(takePhotoController, animated: true)
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        toggleSetAllergiesButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func takePhotoHighlight(_ sender: UIButton) {
        toggleSetAllergiesButton(status: false)
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
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func setAllergiesButtonTapped(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
    @IBAction func setAllergiesHighlight(_ sender: UIButton) {
        toggleTakePhotoButton(status: false)
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
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
}
