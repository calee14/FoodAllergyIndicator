//
//  Pictures.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/6/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation

class Pictures: Codable {
    var numpictures: Int
    
    private static var _current: Pictures?
    
    static var current: Pictures {
        guard let currentNum = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentNum
    }
    
    init(numpictures: Int) {
        self.numpictures = numpictures
    }
    
    static func setCurrent(_ picture: Pictures, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(picture) {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentPicture)
            }
        }
        _current = picture
    }
    static func decrementPictureCount() {
        let newPicture = Pictures.current
        newPicture.numpictures -= 1
        if let data = try? JSONEncoder().encode(newPicture) {
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentPicture)
        }
        _current = newPicture
    }
}
