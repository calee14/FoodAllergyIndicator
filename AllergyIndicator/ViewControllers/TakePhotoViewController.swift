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
            let x = touchPoint.location(in: previewView).y / screenSize.height
            let y = 1.0 - touchPoint.location(in: previewView).x / screenSize.width
            let focusPoint = CGPoint(x: x, y: y)
            
            if let device = cameraController.rearCamera {
                do {
                    try device.lockForConfiguration()
                    
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
        let lightblue = UIColor(rgb: 0x0093DD)
        let cyan = UIColor(rgb: 0x0AD2A8)
        
        captureButton.layer.zPosition = 10
//        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.layer.borderColor = UIColor.clear.cgColor
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        
        buttonBackground.applyGradient(colours: [lightblue, cyan])
        buttonBackground.layer.cornerRadius = min(buttonBackground.frame.width, buttonBackground.frame.height) / 2
        buttonBackground.layer.masksToBounds = true
        buttonBackground.transform = CGAffineTransform.init(scaleX: 1.4, y: 1.4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraController.previewLayer?.isHidden = false
        self.captureButton.isUserInteractionEnabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageView.removeFromSuperview()
        print("Disappear")
    }
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0

    @IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
        
        guard let device = cameraController.rearCamera else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(sender.scale * lastZoomFactor)
        
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
        
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
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
        }
        
        let onGoingtransactions = IAPHelper.shared.paymentQueue.transactions.isEmpty
        if !onGoingtransactions { return }
        Pictures.decrementPictureCount()
        let pictureCount = Pictures.current.numpictures
        print("Pic \(pictureCount)")
        
        if pictureCount > 0 {
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
                
    //            PredictService.predictImage(image: image, completion: { (concepts) in
    //                guard let concepts = concepts else { return }
    //                self.goToShowResultsViewController(concepts: concepts, image: image)
    //            })
                
                PredictService.predictFoodImage(image: image, completion: { (concepts) in
                    guard let concepts = concepts else { return }
                    DispatchQueue.main.async {
                        self.goToShowResultsViewController(concepts: concepts, image: image)
                    }
                })

                // Store image on Firebase server
                PostImageService.create(for: image)
//                self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: image)
            }
    //        self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: nil)
        } else if pictureCount <= 0 {
            print("Out of pictures")
            purchaseMorePictures()
//            Pictures.incrementPictureCount()
        }
    }
    
    func purchaseMorePictures() {
        defer {
            self.captureButton.isUserInteractionEnabled = true
        }
        self.captureButton.isUserInteractionEnabled = false
        IAPHelper.shared.purchase(product: .Picture)
    }
    
    func goToShowResultsViewController(concepts: [ClarifaiConcept], image: UIImage?) {
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let photoResultsController = storyboard.instantiateViewController(withIdentifier: "PhotoResultsViewController") as! PhotoResultsViewController
        
        photoResultsController.concepts = concepts
        
        if let image = image {
            photoResultsController.foodImage = image
        }
        
        self.navigationController?.pushViewController(photoResultsController, animated: true)
    }
}
