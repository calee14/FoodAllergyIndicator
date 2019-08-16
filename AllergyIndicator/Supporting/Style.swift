//
//  Style.swift
//  AllergyIndicator
//
//  Created by Chon-Hei Ma on 8/11/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import Foundation
import UIKit

let lightBlue = UIColor(red: 0, green: 147.0/255.0, blue: 221.0/255.0, alpha: 0.8)
let cyan = UIColor(red: 10.0/255.0, green: 210.0/255.0, blue: 168.0/255.0, alpha: 0.8)
let backgroundGradients = [lightBlue, cyan]

let normalButtonColor = UIColor(red: 2.0/255.0, green: 153.0/255.0, blue: 216.0/255.0, alpha: 1.0)
let selectedButtonColor = UIColor(red: 2.0/255.0, green: 153.0/255.0, blue: 216.0/255.0, alpha: 0.5)

extension UIButton {
    
    func applyDefaultColoredButtonStyle() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
        self.setBackgroundColor(color: normalButtonColor, forState: .normal)
        self.setBackgroundColor(color: selectedButtonColor, forState: .selected)
        self.setBackgroundColor(color: selectedButtonColor, forState: .highlighted)
    }
}
