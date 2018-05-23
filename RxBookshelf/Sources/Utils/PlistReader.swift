//
//  PlistReader.swift
//  RxBookshelf
//
//  Created by Mario on 23/05/2018.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation

class PlistReader {
    private let dictionary: NSDictionary
    
    init(fileName: String) {
        guard
            let path = Bundle.main.path(forResource: fileName, ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) else {
                fatalError("Cannot read \(fileName).plist file.")
        }
        self.dictionary = dictionary
    }
    
    private func value<T>(_ key: String) -> T? {
        return dictionary[key] as? T
    }
    
    // MARK: Utility methods.
    // Force unwrapped because if there is no correct value in the plist file it is a logic error.
    
    func string(key: String) -> String {
        let result: String = value(key)!
        return result
    }
    
    func double(key: String) -> Double {
        let result: Double = value(key)!
        return result
    }
}
