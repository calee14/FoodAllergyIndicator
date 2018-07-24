//
//  AllergyTableViewCell.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation
import UIKit

protocol IsAllergicCellDelegate: class {
    func didSwitchAllergicSwitch(_ isAllergicSwitch: UISwitch, on cell: AllergyTableViewCell)
}

class AllergyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var isAllergicSwitch: UISwitch!
    @IBOutlet weak var allergenName: UILabel!
    
    weak var delegate: IsAllergicCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func isAllergicSwitchToggled(_ sender: UISwitch) {
        print(sender.isOn)
        delegate?.didSwitchAllergicSwitch(sender, on: self)
    }
}
