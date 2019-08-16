//
//  Pictures.swift
//  AllergyIndicator
//
//  Created by Cappillen on 8/6/18.
//  Copyright © 2018 Cappillen. All rights reserved.
//

import Foundation

class Pictures: Codable {
    var numpictures: Int {
        didSet {
            if numpictures < 0 {
                numpictures = 0
            }
        }
    }
    
    private static var _current: Pictures?
    
    static var current: Pictures {
        guard let currentNum = _current else {
            fatalError("Error: current picture doesn't exist")
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
        NotificationCenter.default.post(name: .pictureCountDidUpdate, object: nil)
    }
    
    static func incrementPictureCount(by num: Int=100) {
        let newPicture = Pictures.current
        newPicture.numpictures += num
        if let data = try? JSONEncoder().encode(newPicture) {
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentPicture)
        }
        _current = newPicture
        NotificationCenter.default.post(name: .pictureCountDidUpdate, object: nil)
    }
}
