//
//  Configuration.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation

enum Configuration: String {
    case backendHost
    case searchEndpoint
    case booksEndpoint
    case requestsTimeoutInSeconds
}

extension Configuration {
    private var dictionary: NSDictionary? {
        guard let path = Bundle.main.path(forResource: "Configuration", ofType: "plist") else {
            fatalError("Cannot find Configuration.plist file.")
        }
        return NSDictionary(contentsOfFile: path)
    }
    
    private func value<T>() -> T? {
        return dictionary?[self.rawValue] as? T
    }
    
    var stringValue: String {
        let result: String = self.value() ?? ""
        return result
    }
    
    var intValue: Int {
        let result: Int = self.value() ?? 0
        return result
    }
}
