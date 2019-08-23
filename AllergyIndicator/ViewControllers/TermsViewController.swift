//
//  TermsViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/5/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

let termsFilePath = Bundle.main.path(forResource: "Terms", ofType: "txt")
let thirdPartyLicenseFilePath = Bundle.main.path(forResource: "ThirdyPartyLicense", ofType: "txt")

enum TermsType: String {
    case terms
    case thirdyPartyLicense
}


class TermsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var term: TermsType = .terms
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        
        var text: String?
        
        switch (term) {
        case .terms:
            text = try? String(contentsOf: URL(fileURLWithPath: termsFilePath!))
            textView.attributedText = termsAttributedText(terms: text!)
        case .thirdyPartyLicense:
            text = try? String(contentsOf: URL(fileURLWithPath: thirdPartyLicenseFilePath!))
            textView.attributedText = licenseAttributedText(terms: text!)
        }
        
        // Run layout code
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.isScrollEnabled = true
    }
    
    func setupLayout() {
        // Text view can't be seletable
        textView.isSelectable = false
        
        let image = UIImage(named:"ic_close")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = UIColor.darkGray
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func termsAttributedText(terms: String) -> NSAttributedString {
        
        let string = terms as NSString
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 18)!]
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [.font: UIFont(name: "AvenirNext-Regular", size: 16)!])
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Terms and Conditions of Use"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "1. Registration"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "2. The application and the service"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "3. Limitation on Liability"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "4. Term & Termination"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "5. Rules of conduct"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "6. Ownership"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "7. General"))

        return attributedString
    }
    
    func licenseAttributedText(terms: String) -> NSAttributedString {
        
        let string = terms as NSString
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 18)!]
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [.font: UIFont(name: "AvenirNext-Regular", size: 16)!])
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Third Party Licenses & Notices"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Firebase (firebase-ios-sdk)"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "SwifyJSON"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Alamofire"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "NVActivityIndicatorView"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Clarifai (clarifai-apple-sdk)"))
        
        return attributedString
    }
}
