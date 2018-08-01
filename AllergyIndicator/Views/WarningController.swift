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
        return label
    }()
    
    let allergiesTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "lajsdlf;jaslk;dfj\n laksjdfl;ajsd\n alsjdflk;ajsdlkfj\n alksjdl;fkjaslk;djfkl\nalsdjf;laskjdf\nlajsflajslkdfjal;sd\n;ljasdl;fkjalk;djf\nlajsdf;lkajsdkl;f\nl;lklkl"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.isEditable = false
        return textView
    }()
    
    func showWarningMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
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
        warningTitleLabel.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
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

