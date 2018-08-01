//
//  TakePhotoViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/23/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import Clarifai_Apple_SDK
import Clarifai

class TakePhotoViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    
    // MARK: - Properties
    
    let cameraController = CameraController()
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Take photo")
        
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
        
        captureButton.layer.zPosition = 10
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        
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
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        cameraController.captureImage { (image, error) in
            // get image
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.captureButton.isUserInteractionEnabled = false
            
            // change ui view
            self.cameraController.previewLayer?.isHidden = true
            self.imageView.frame = self.previewView.frame
            self.imageView.image = image
            self.previewView.insertSubview(self.imageView, at: 0)
            
//            PredictService.predictImage(image: image, completion: { (concepts) in
//                guard let concepts = concepts else { return }
//                self.goToShowResultsViewController(concepts: concepts, image: image)
//            })
//            PredictService.predictFoodImage(image: image, completion: { (concepts) in
//                guard let concepts = concepts else { return }
//                DispatchQueue.main.async {
//                    self.goToShowResultsViewController(concepts: concepts)
//                }
//            })

            // Store image on Firebase server
//            PostImageService.create(for: image)
            self.goToShowResultsViewController(concepts: [ClarifaiConcept](), image: image)
        }
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
