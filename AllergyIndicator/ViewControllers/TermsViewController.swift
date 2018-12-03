//
//  TermsViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/5/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        
        var text: String?
        
        // Do any additional setup after loading the view.
        do {
            let filePath = Bundle.main.path(forResource: "Terms", ofType: "txt")
            text = try? String(contentsOf: URL(fileURLWithPath: filePath!))
            textView.attributedText = attributedText(terms: text!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func attributedText(terms: String) -> NSAttributedString {
        
        let string = terms as NSString
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Bold", size: 18)!]
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [.font: UIFont(name: "AvenirNext-Regular", size: 16)!])
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Terms and Conditions of Use"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Termination"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "The Site Does Not Provide Medical Advice"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "User Submissions — Image, Video, Audio Files"))
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: "Disclaimer"))
        
        
        // 4
        return attributedString
    }
}
