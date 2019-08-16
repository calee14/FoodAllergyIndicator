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
import Firebase

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
    var showNavagationController: Bool = false
    
    // Create an instance of the warning controller
    var warningController: WarningController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* This method is called after the view controller
         has loaded its view hierarchy into memory. */
        
        print(User.current.username)
        print(User.current.email)
        print(Pictures.current.numpictures)
        
        toggleAllButtons(status: false)
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
        
        warningController = WarningController()
        
        /* Check if the user has added any ingredients
        If not then send them to the view controller to add it
         */
        IngredientService.doesUserHaveIngredients(for: User.current) { (userContains) in
            if !userContains {
                // Move to the SetAllergiesViewController to set the allerigies of the user
                print("move to next controller")
                self.goToSetAllergiesViewController()
                
            } else if userContains {
                // Do something if the user has already set their allergies
                /* Do nothing for now */
                self.toggleAllButtons(status: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* This method is called before the view controller's view
         is about to be added to a view hierarchy */
        // Set UI for the view controller
        setupLayout()
        
        if warningController == nil {
             warningController = WarningController()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disappear(animated: animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if warningController != nil {
            warningController?.handleDismiss()
        }
    }
    
    func setupLayout() {
        // Set background
        let backgroundimg = UIImage(named: "backgroundv3")
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
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
        termsButton.titleLabel?.numberOfLines = 0
        
        termsButton.backgroundColor = cyan
        
        termsBackground.layer.cornerRadius = 6
        termsBackground.layer.masksToBounds = true
        
        // Change UI for the fourth button - the picture count
        leftButton.layer.cornerRadius = 6
        leftButton.clipsToBounds = false
        
        leftButton.backgroundColor = cyan
        leftButton.setTitle("My Profile", for: .normal)
        
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
    
    func toggleAllButtons(status: Bool) {
        toggleTakePhotoButton(status: status)
        toggleSetAllergiesButton(status: status)
        toggleTermsButton(status: status)
        toggleLeftButton(status: status)
    }
    
    func goToSetAllergiesViewController() {
        defer {
            // Change the status of all the rest of the buttons after performing seque
            toggleSetAllergiesButton(status: true)
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
        termsViewController.term = .terms
        self.navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    func goDoWhateverLeftButtonDoes() {
        defer {
            // Change the status of all the rest of the buttons to active after performing seque
            toggleSetAllergiesButton(status: true)
            toggleTakePhotoButton(status: true)
            toggleTermsButton(status: true)
        }
        
        // Make sure the navagational bar will be shown
        showNavagationController = true
        
        // Seque to the TermsViewController
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileViewController, animated: true)
        
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
        print("swiper")
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
    
    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            // Perform action.
        }
    }
    
}
