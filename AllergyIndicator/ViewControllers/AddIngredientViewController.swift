//
//  AddIngredientViewController.swift
//  AllergyIndicator
//
//  Created by Cappillen on 6/10/19.
//  Copyright © 2019 Cappillen. All rights reserved.
//

import UIKit

class AddIngredientViewController: UIViewController {

    @IBOutlet weak var ingredientsHeaderLabel: UILabel!
    @IBOutlet weak var addIngredientTextField: UITextField!
    @IBOutlet weak var ingredientButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pressedIngredientButton(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
