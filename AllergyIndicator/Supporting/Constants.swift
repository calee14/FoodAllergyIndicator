//
//  Constants.swift
//  AllergyIndicator
//
//  Created by Cappillen on 7/24/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Username {
        static let domain = "@whatsingredient.com"
    }
    
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
        static let loginUser = "loginUser"
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let currentPicture = "currentPicture"
    }
    
    struct Allergens {
        static let allergenNames = ["Egg", "Nuts", "Fish", "Milk", "Butter", "Cheese", "Yogurt", "Shellfish", "Wheat", "Gluten", "Peanuts", "Almond", "Pecan", "Walnut", "Pistachio","Hazelnut", "Macadamia", "Brazilnut", "Cashew", "Chestnut", "Pinenut", "Coconut", "Soy", "Fruits", "Kiwi Fruits", "Strawberries", "Anchovy", "Bass", "Cod", "Eel", "Flounder", "Grouper", "Halibut", "Herring", "Lingcod", "Mackerel", "Mahi Mahi", "Orange ruffy", "Pollock", "Salmon", "Sanddab", "Sardine", "Smelt", "Snapper", "Sole", "Sturgeon", "Tilapia", "Trout", "Tuna", "Whitefish", "Crab", "Lobser", "Shrimp", "Clam", "Crayfish", "Cuttlefish", "Mussel", "Octopus", "Oysters", "Scalop", "Squid", "Snails", "Apples", "Pears", "Peaches", "Apricots", "Nectarines", "Plums", "Cherries", "Melons", "Avocado", "Tomato", "Carrot", "Corn", "Celery", "Garlic", "Eggplant", "Bean", "Peas", "Lentils", "Lupin", "Legumes", "Sesame seeds", "Buckwheat", "Mustard", "Curry", "Mayonnaise"]
    }
    struct DatabasePath {
        static let allergies = "allergies"
        static let ingredients = "ingredient"
        static let userIngredients = "userIngredients"
        static let iap = "iap"
    }
    struct WarningMenu {
        static let cellID = "cellID"
    }
}

extension Notification.Name {
    static let pictureCountDidUpdate = Notification.Name(rawValue: "pictureCountUpdate")
}
