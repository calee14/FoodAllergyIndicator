//
//  UIButton+Utility.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/4/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import UIKit

public enum ButtonStatus {
    case active, selected
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
