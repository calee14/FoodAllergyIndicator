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
        
    }
    
    @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
        cameraController.captureImage { (image, error) in
            // get image
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
//            PredictService.predictImage(image: image, completion: { (concepts) in
//                guard let concepts = concepts else { return }
//                self.goToShowResultsViewController(concepts: concepts)
//            })
            PredictService.predictFoodImage(image: image, completion: { (concepts) in
                guard let concepts = concepts else { return }
                DispatchQueue.main.async {
                    self.goToShowResultsViewController(concepts: concepts)
                }
            })
            // Store image on Firebase server
            PostImageService.create(for: image)
        }
    }
    
    func goToShowResultsViewController(concepts: [ClarifaiConcept]) {
        let storyboard = UIStoryboard(name: "TakePhoto", bundle: nil)
        
        let photoResultsController = storyboard.instantiateViewController(withIdentifier: "PhotoResultsViewController") as! PhotoResultsViewController
        
        photoResultsController.concepts = concepts
        
        self.navigationController?.pushViewController(photoResultsController, animated: true)
    }
}
