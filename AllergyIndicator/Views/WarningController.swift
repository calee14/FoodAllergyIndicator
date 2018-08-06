//
//  WarningController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/31/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class WarningController: NSObject {
    
    let blackView = UIView()
    
    let collectionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let warningTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Warning!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    let allergiesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.textAlignment = .center
        return textView
    }()
    
    let dissmissButton: UIButton = {
        let button = UIButton()
        button.setTitle("CONFIRM", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    let widthDifference: CGFloat = 50
    
    func showWarningMenu(allergies: Bool) {
        var titleString = "BE CAREFUL"
        var allergyString = "Possiblle Allergens Detected!!! \nConfirm with the food preparer to verify ingredients. As always, be careful and consume with caution."
        if allergies == false {
            titleString = "Should Be Safe To Eat"
            allergyString = "Reminder! \nConfirm with the food preparer to verify ingredients. As always, be careful and consume with caution."
        }
        
        warningTitleLabel.text = titleString
        allergiesTextView.text = allergyString
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            window.addSubview(dissmissButton)
            
            let height: CGFloat = 225
            let y = (window.frame.height / 2) - (height / 2)
            var rectShape = CAShapeLayer()
            
            collectionView.frame = CGRect(x: widthDifference / 2, y: window.frame.height, width: window.frame.width - self.widthDifference, height: height)
            rectShape = CAShapeLayer()
            rectShape.bounds = collectionView.frame
            rectShape.position = collectionView.center
            rectShape.path = UIBezierPath(roundedRect: collectionView.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            //Here I'm masking the textView's layer with rectShape layer
            
            collectionView.layer.mask = rectShape
            
            dissmissButton.frame = CGRect(x: widthDifference / 2, y: window.frame.height + collectionView.frame.height, width: window.frame.width - self.widthDifference, height: 50)
            let lightblue = UIColor(rgb: 0x0093DD)
            dissmissButton.backgroundColor = lightblue
            
            rectShape = CAShapeLayer()
            rectShape.bounds = dissmissButton.frame
            rectShape.position = dissmissButton.center
            rectShape.path = UIBezierPath(roundedRect: dissmissButton.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
            //Here I'm masking the textView's layer with rectShape layer
            dissmissButton.layer.mask = rectShape
            
            dissmissButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: self.widthDifference / 2, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                self.dissmissButton.frame = CGRect(x: self.widthDifference / 2, y: y + self.collectionView.frame.height, width: self.collectionView.frame.width, height: 50)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: self.widthDifference / 2, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                self.dissmissButton.frame = CGRect(x: self.widthDifference / 2, y: window.frame.height + self.collectionView.frame.height, width: self.dissmissButton.frame.width, height: self.dissmissButton.frame.height)
            }
        }
    }
    
    override init() {
        super.init()
        
        collectionView.addSubview(warningTitleLabel)
        collectionView.addSubview(allergiesTextView)
        
        setupLayout()
    }
    
    func setupLayout() {
        
        warningTitleLabel.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 75)
        warningTitleLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 10).isActive = true
        warningTitleLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        warningTitleLabel.textColor = .black
        
//        allergiesTextView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 100)
        allergiesTextView.topAnchor.constraint(equalTo: warningTitleLabel.bottomAnchor, constant: 10).isActive = true
        allergiesTextView.leftAnchor.constraint(equalTo: collectionView.leftAnchor).isActive = true
        allergiesTextView.rightAnchor.constraint(equalTo: collectionView.rightAnchor).isActive = true
        allergiesTextView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0).isActive = true
        
    }
}

