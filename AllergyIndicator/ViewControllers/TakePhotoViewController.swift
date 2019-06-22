//
//  TakePhotoViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

// import libraries
import UIKit
import AVFoundation
import FirebaseStorage
import Clarifai_Apple_SDK
import Clarifai

class TakePhotoViewController: UIViewController {
    
    // Global class ui elements
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var buttonBackground: UIView!
    
    // MARK: - Properties
    
    // Global class variables
    
    // Instance of the CameraController - going to help us take picture
    let cameraController = CameraController()
    // Instance of the WarningController - displays messages
    let warningController = WarningController()
    // Image view to display the image the camera took
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* This method is called after the view controller
         has loaded its view hierarchy into memory. */
        // Do any additional setup after loading the view.
        
        //        IAPHelper.shared.getProducts()
        
        print("Take photo")
        
        // Start up the camera
        cameraController.prepare {(error) in
            // Print the error if given one
            if let error = error {
                print(error)
            }
            // Display the camera feed on the preiview view
            try? self.cameraController.displayPreview(on: self.previewView)
        }
        
        // Set up UI elements
        setupLayout()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let screenSize = previewView.bounds.size
        if let touchPoint = touches.first {
            // Get the x coordinate of the touch
            let x = touchPoint.location(in: previewView).y / screenSize.height
            // Get the y coordinate of the touch
            let y = 1.0 - touchPoint.location(in: previewView).x / screenSize.width
            // Create a CGPoint of the touch
            let focusPoint = CGPoint(x: x, y: y)
            
            // Access the rear camera
            if let device = cameraController.rearCamera {
                do {
                    try device.lockForConfiguration()
                    
                    // Camera focus
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                    device.unlockForConfiguration()
                }
                catch {
                    // ignore
                }
            }
        }
    }
    
    func setupLayout() {
        // Get colors
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        // Round off the button
        captureButton.layer.zPosition = 10
        captureButton.layer.borderWidth = 2
        captureButton.layer.borderColor = UIColor.clear.cgColor
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        
        // Add gradients to the background of the button
        buttonBackground.applyGradient(colours: [lightblue, cyan])
        buttonBackground.layer.cornerRadius = min(buttonBackground.frame.width, buttonBackground.frame.height) / 2
        buttonBackground.layer.masksToBounds = true
        buttonBackground.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /* This method is called before the view controller's
         view is about to be added to a view hierarchy */
        
        // Show the camera view on screen
        self.cameraController.previewLayer?.isHidden = false
        // Activate the camera button
        self.captureButton.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /* This method is called in response to a
         view being removed from a view hierarchy */
        // Remove the image view that stores the picture the user took
        self.imageView.removeFromSuperview()
        print("Disappear")
    }
    
    // Set variables for the camera zoom
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0

    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        
        // Access the camera
        guard let device = cameraController.rearCamera else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                // Zoom camera
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        // Get the magnitude of the pinch
        let newScaleFactor = minMaxZoom(sender.scale * lastZoomFactor)
        
        // Manages the states of the pinch function
        switch sender.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        
        // Get the authorization status of the users camera
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        // Manage the different types of status
        switch cameraAuthorizationStatus {
        case .denied:
            // We don't have access
            // Use the warning controller to dispaly a message saying they need to allow access for the camera
//            let blankImage = self.previewView.asImage()
            let titleString = "Camera not available"
            let contentString = "You did not allow access to camera. Please turn on camera access in the settings to see results."
            self.warningController.showWarningMenu(title: titleString, content: contentString)
//            self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: blankImage)
            return
        case .authorized:
            break
        case .restricted:
            break
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                } else {
                    print("Denied access to \(cameraMediaType)")
                }
            }
        @unknown default:
            fatalError()
        }
        // Remove the ongoing transactions
        let onGoingtransactions = IAPHelper.shared.paymentQueue.transactions.isEmpty
        if !onGoingtransactions { return }
        // Decrement the picture count
        Pictures.decrementPictureCount()
        // Access the picture count
        let pictureCount = Pictures.current.numpictures
        print("Pic \(pictureCount)")
        
        if pictureCount > 0 {
            // Camera controller takes a picture
            cameraController.captureImage { (image, error) in
                // get image
                guard let image = image else {
                    print(error ?? "Image capture error")
                    return
                }
                
                // change ui view
                self.captureButton.isUserInteractionEnabled = false
                self.cameraController.previewLayer?.isHidden = true
                self.imageView.frame = self.previewView.frame
                self.imageView.image = image
                self.previewView.insertSubview(self.imageView, at: 0)
                
                // Checks if there is a food in the image
                PredictService.predictFoodInImage(image: image, completion: { (concepts) in
                    guard let concepts = concepts else { return }
                    var foundFood: Bool = false
                    for concept in concepts {
                        if concept.name == "food" && concept.score >= 0.5 {
                            print("found food: \(concept.score)")
                            foundFood = true
                        }
                    }
                    if foundFood {
                        // Predicts the foods in the image
                        PredictService.predictFoodImage(image: image, completion: { (concepts) in
                            // Send the concepts to the ShowResultsViewController
                            guard let concepts = concepts else { return }
                            DispatchQueue.main.async {
                                self.goToShowResultsViewController(concepts: concepts, image: image)
                            }
                        })
                    } else {
                        // Go straight to the results view controller and display a message saying there was no food detected
                        DispatchQueue.main.async {
                            self.goToShowResultsViewController(image: image)
                        }
                    }
                })

                // Store image on Firebase server
                PostImageService.create(for: image)
//                self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: image)
            }
    //        self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: nil)
        } else if pictureCount <= 0 {
            // Buy more pictures
            print("Out of pictures")
            purchaseMorePictures()
//            Pictures.incrementPictureCount()
        }
    }
    
    func purchaseMorePictures() {
        // Prompt the user to purchase more images
        defer {
            self.captureButton.isUserInteractionEnabled = true
        }
        self.captureButton.isUserInteractionEnabled = false
        IAPHelper.shared.purchase(product: .Picture)
    }
    
    func goToShowResultsViewController(concepts: [ClarifaiConcept], image: UIImage?) {
        // Retrieve the storyboard the app is going to seque to
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let photoResultsController = storyboard.instantiateViewController(withIdentifier: "PhotoResultsViewController") as! PhotoResultsViewController
        
        // Send the images and concepts to the PhotoResultsController
        photoResultsController.concepts = concepts
        
        if let image = image {
            photoResultsController.foodImage = image
        }
        
        // Navigate to the results view controller
        self.navigationController?.pushViewController(photoResultsController, animated: true)
    }
    
    func goToShowResultsViewController(image: UIImage?) {
        // Retrieve the storyboard the app is going to seque to
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let photoResultsController = storyboard.instantiateViewController(withIdentifier: "PhotoResultsViewController") as! PhotoResultsViewController
        
        // Make sure results view controller knows there is no food in the image
        photoResultsController.noFood = true
        
        // Send the image to the results view controller
        if let image = image {
            photoResultsController.foodImage = image
        }
        
        // Navigate to the results view controller
        self.navigationController?.pushViewController(photoResultsController, animated: true)
    }
}
