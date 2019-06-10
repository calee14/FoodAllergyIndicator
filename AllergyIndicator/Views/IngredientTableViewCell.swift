//
//  IngredientTableViewCell.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/09/19.
//  Copyright © 2018 Cappillen. All rights reserved.
//
import Foundation
import UIKit

protocol DeleteCellDelegate: class {
    func didPressDeleteButton(_ deleteButton: UIButton, on cell: IngredientTableViewCell)
}

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: DeleteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.didPressDeleteButton(sender, on: self)
    }
}
