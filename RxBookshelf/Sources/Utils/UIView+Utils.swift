//
//  UIView+Utils.swift
//  RxBookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

extension UIView {
    static func createFromNib<T>() -> T {
        let nibName = String(describing: self)
        guard let view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? T else{
            fatalError("Cannot load Nib for \(nibName)")
        }
        return view
    }
}
