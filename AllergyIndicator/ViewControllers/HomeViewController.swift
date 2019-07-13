//
//  HomeViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

// import libraries
import UIKit
import Clarifai_Apple_SDK

class HomeViewController: UIViewController {
    
    // Global class ui elements
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var setAllergiesButton: UIButton!
    @IBOutlet weak var takePhotoBackground: UIView!
    @IBOutlet weak var setAllergiesBackground: UIView!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var termsBackground: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var leftButtonBackground: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    // MARK: - Properties
    
    // Global class variables
    static var shouldDisplayDisclaimer: Bool = false
    var showNavagationController: Bool = false
    
    // Create an instance of the warning controller
    let warningController = WarningController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* This method is called after the view controller
         has loaded its view hierarchy into memory. */
        
//        let data = PushIngredientsToDB.retrieveLocalData()
//
//        PushIngredientsToDB.addDataToFirebase(ingredientData: data) { (success) in
//            print("\(success) this is the status of the db")
//        }
        
        // Get the in app-purchase products
        IAPHelper.shared.getProducts()
        
//        // Launch Clarifai SDK
//        let apikey = ConstantsAPI.clarifaiapi.key
//        Clarifai.sharedInstance().start(apiKey: apikey)
        
//        IngredientService.addIngredient(ingredientNames: ["egg", "toast", "grapes"]) { (success) in
//            print(success)
//        }
        DatabaseIngredientService.doesIngredientExists2(ingredientName: "mozzarella") { (exist) in
            print(exist)
        }
        
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
        
        // Only display the disclaimer once every ten times
        let randNum = arc4random_uniform(10)
        
        // Only display the disclaimer only when the user first opens the app
        
        /* If the user seques back to the HomeViewController the viewDidLoad function will run again
        so we only want to display the disclaimer once.
        */
        if !HomeViewController.shouldDisplayDisclaimer {
            
            HomeViewController.shouldDisplayDisclaimer = randNum <= 4 ? true : false
        }
        
        // Check if we should display the disclaimer
        if HomeViewController.shouldDisplayDisclaimer {
            
            // Get the path of the file that contains the contents of the disclaimer
            let filePath = Bundle.main.path(forResource: "Disclaimer", ofType: "txt")
            
            // Retrieve the contents in the file
            guard let content = try? String(contentsOf: URL(fileURLWithPath: filePath!)) else { return }
            
            // Put a disclaimer on screen
            self.warningController.showWarningMenu(title: "Disclaimer", content: content)
            
            // Reset the should-display-disclaimer variable
            HomeViewController.shouldDisplayDisclaimer = false
        }
        
        // Retrieve the allergies for this user on the firebase database
        AllergyService.retrieveAllergies(for: User.current) { (allergies) in
            // Check check the allergies the user has
            let doesHaveAllergies = allergies.filter { $0.isAllergic != false }
            // If the user has no allergies
            if doesHaveAllergies.count == 0 {
                // Move to the SetAllergiesViewController to set the allerigies of the user
                print("move to next controller")
                self.goToSetAllergiesViewController()
            } else {
                // Do something if the user has already set their allergies
                /* Do nothing for now */
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* This method is called before the view controller's view
         is about to be added to a view hierarchy */
        // Set UI for the view controller
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disappear(animated: animated)
    }
    
    func setupLayout() {
        // Set background
        let backgroundimg = UIImage(named: "backgroundv3")
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = backgroundimg
        imageView.center = self.view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        // Make the background clear
        self.buttonStackView.backgroundColor = .clear
        
        self.takePhotoButton.backgroundColor = .clear
        self.setAllergiesButton.backgroundColor = .clear
        self.leftButton.backgroundColor = .clear
        self.termsButton.backgroundColor = .clear
        
        // Hide navbar for the first view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Retrieve colors
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        // Change the colors of the navigation bar
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [lightblue , cyan])
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.alpha = 0.95
        
        // Change UI for the first button - the take photo button
        takePhotoButton.backgroundColor = cyan
        
        takePhotoButton.layer.cornerRadius = 6
        takePhotoButton.clipsToBounds = false
        
        takePhotoBackground.layer.cornerRadius = 6
        takePhotoBackground.layer.masksToBounds = true
        
        // Change UI for the second button - the set allergies button
        setAllergiesButton.backgroundColor = cyan

        setAllergiesButton.layer.cornerRadius = 6
        setAllergiesButton.clipsToBounds = false
        
        setAllergiesBackground.layer.cornerRadius = 6
        setAllergiesBackground.layer.masksToBounds = true
        
        // Change UI for the third button - the terms of service button
        termsButton.layer.cornerRadius = 6
        termsButton.clipsToBounds = false
        
        termsButton.backgroundColor = cyan
        
        termsBackground.layer.cornerRadius = 6
        termsBackground.layer.masksToBounds = true
        
        // Change UI for the fourth button - the picture count
        leftButton.layer.cornerRadius = 6
        leftButton.clipsToBounds = false
        
        leftButton.backgroundColor = cyan
        leftButton.setTitle("Pictures: \(Pictures.current.numpictures)", for: .normal)
        
        leftButtonBackground.layer.cornerRadius = 6
        leftButtonBackground.layer.masksToBounds = true
        
        // Set up constraints that need to be proportional with the screen
        setupConstraints()
    }
    
    func setupConstraints() {
        let constraintsArray: [[NSLayoutConstraint]] = [self.takePhotoBackground.getAllConstraints(), self.setAllergiesBackground.getAllConstraints(), self.termsBackground.superview!.getAllConstraints()]
        for constraints in constraintsArray {
            for constraint in constraints {
                if constraint.identifier == "leftMargin" || constraint.identifier == "rightMargin" {
                    constraint.constant = (self.view.frame.width * 0.10)
                } else if constraint.identifier == "topMargin" || constraint.identifier == "bottomMargin" {
                    constraint.constant = (self.view.frame.height * 0.03)
                }
            }
        }
    }
    
    func disappear(animated: Bool) {
        // Show the navigation bar when we change view controllers
        self.navigationController?.setNavigationBarHidden(!showNavagationController, animated: animated)
    }
    
    func toggleTakePhotoButton(status: Bool) {
        // Change the status of the takePhotoButton
        takePhotoButton.isUserInteractionEnabled = status
    }
    
    func toggleSetAllergiesButton(status: Bool) {
        // Change the status of the setAllergiesButton
        setAllergiesButton.isUserInteractionEnabled = status
    }
    
    func toggleTermsButton(status: Bool) {
        // Change the status of the termsButton
        termsButton.isUserInteractionEnabled = status
    }
    
    func toggleLeftButton(status: Bool) {
        // Change the status of the leftButton
        leftButton.isUserInteractionEnabled = status
    }
    
    func goToSetAllergiesViewController() {
        defer {
            // Change the status of all the rest of the buttons after performing seque
            toggleTakePhotoButton(status: true)
            toggleTermsButton(status: true)
            toggleLeftButton(status: true)
        }
        // Make sure the navagational bar will be shown
        showNavagationController = true
        
        // Seque to the SetAllergiesViewController
        let storyboard = UIStoryboard(name: "SetAllergies", bundle: nil)
        
        let setAllergiesController = storyboard.instantiateViewController(withIdentifier: "SetAllergiesViewController") as! SetAllergiesViewController
        
        self.navigationController?.pushViewController(setAllergiesController, animated: true)
    }
    
    func goToTakePhotoViewController() {
        defer {
            // Change the status of all the rest of the buttons after performing seque
            toggleSetAllergiesButton(status: true)
            toggleTermsButton(status: true)
            toggleLeftButton(status: true)
        }
        
        // Make sure the navagational bar will not be shown
        showNavagationController = false
        
        // Seque to the TakePhotoViewController
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let takePhotoController = storyboard.instantiateViewController(withIdentifier: "TakePhotoViewController") as! TakePhotoViewController
        
        self.navigationController?.pushViewController(takePhotoController, animated: true)
    }
    
    func goToTermsOfServiceViewController() {
        defer {
            // Change the status of all the rest of the buttons after performing seque
            toggleSetAllergiesButton(status: true)
            toggleTakePhotoButton(status: true)
            toggleLeftButton(status: true)
        }
        
        // Make sure the navagational bar will be shown
        showNavagationController = true
        
        // Seque to the TermsViewController
        let storyboard = UIStoryboard(name: "TermsOfService", bundle: nil)
        
        let termsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    func goDoWhateverLeftButtonDoes() {
        defer {
            // Change the status of all the rest of the buttons to active after performing seque
            toggleSetAllergiesButton(status: true)
            toggleTakePhotoButton(status: true)
            toggleTermsButton(status: true)
        }
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func takePhotoHighlight(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.takePhotoButton.backgroundColor = .white
            self.takePhotoButton.setTitleColor(lightblue, for: .normal)
            self.takePhotoBackground.applyGradient(colours: [lightblue , cyan])
        }
    }
    
    @IBAction func takePhotoEnd(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.takePhotoButton.backgroundColor = cyan
        self.takePhotoButton.setTitleColor(.white, for: .normal)
        self.takePhotoBackground.removeGradient()
        self.goToTakePhotoViewController()
    }
    
    @IBAction func setAllergiesButtonTapped(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
    @IBAction func setAllergiesHighlight(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.setAllergiesButton.backgroundColor = .white
            self.setAllergiesBackground.applyGradient(colours: [lightblue , cyan])
            self.setAllergiesButton.setTitleColor(lightblue, for: .normal)
        }
        
    }
    @IBAction func setAllergiesEnd(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleTermsButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.setAllergiesButton.backgroundColor = cyan
        self.setAllergiesBackground.removeGradient()
        self.setAllergiesButton.setTitleColor(.white, for: .normal)
        self.goToSetAllergiesViewController()
    }
    
    @IBAction func termsTapped(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.termsButton.backgroundColor = cyan
        self.termsBackground.removeGradient()
        self.termsButton.setTitleColor(.white, for: .normal)
        self.goToTermsOfServiceViewController()
    }
    
    @IBAction func termsHighlight(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.termsButton.backgroundColor = .white
            self.termsBackground.applyGradient(colours: [lightblue , cyan])
            self.termsButton.setTitleColor(lightblue, for: .normal)
        }
    }
    
    @IBAction func termsEnd(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleLeftButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.termsButton.backgroundColor = cyan
        self.termsBackground.removeGradient()
        self.termsButton.setTitleColor(.white, for: .normal)
        self.goToTermsOfServiceViewController()
    }
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.leftButton.backgroundColor = cyan
        self.leftButtonBackground.removeGradient()
        self.leftButton.setTitleColor(.white, for: .normal)
        self.goDoWhateverLeftButtonDoes()
    }
    
    
    @IBAction func leftButtonHighlighted(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        // change the color of the backgrounds of the button
        UIView.animate(withDuration: 0.1) {
            let lightblue = UIColor(rgb: 0x0093DD)
            let cyan = UIColor(rgb: 0x0AD2A8)
            self.leftButton.backgroundColor = .white
            self.leftButtonBackground.applyGradient(colours: [lightblue , cyan])
            self.leftButton.setTitleColor(lightblue, for: .normal)
        }
    }
    
    @IBAction func leftButtonEnd(_ sender: UIButton) {
        // Change the status of the other buttons to non-user enabled
        toggleTakePhotoButton(status: false)
        toggleSetAllergiesButton(status: false)
        toggleTermsButton(status: false)
        // change the color of the backgrounds of the button
        let cyan = UIColor(rgb: 0x0AD2A8)
        self.leftButton.backgroundColor = cyan
        self.leftButtonBackground.removeGradient()
        self.leftButton.setTitleColor(.white, for: .normal)
        self.goDoWhateverLeftButtonDoes()
//        sender.isSelected = false
    }
    
}
