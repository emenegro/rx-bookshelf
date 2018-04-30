//
//  R.swift
//  Bookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

enum R {
    enum Img: String {
        case checkIcon = "ic_check_circle"
        
        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
}
