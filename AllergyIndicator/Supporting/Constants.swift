//
//  Constants.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
    
    struct Allergens {
        static let allergenNames = ["Egg", "Nuts", "Fish", "Dairy products", "Shellfish", "Wheat", "Gluten", "Peanuts",
                                    "Soy", "Fruits", "Citrus Fruits", "Kiwi Fruits", "Strawberries", "Apples", "Pears",
                                    "Peaches", "Apricots", "Nectarines", "Plums", "Cherries", "Melons", "Avocado",
                                    "Vegetables", "Tomatoes", "Carrots", "Corn", "Celery", "Garlic", "Eggplant", "Beans",
                                    "Peas", "Lentils", "Lupin", "Legumes", "Sesame seeds", "Buckwheat", "Mustart",
                                    "Curry", "Glutamate", "Mayonnaise", "Colorants"]
    }
    struct DatabasePath {
        static let allergies = "allergies"
    }
    struct WarningMenu {
        static let cellID = "cellID"
    }
}
