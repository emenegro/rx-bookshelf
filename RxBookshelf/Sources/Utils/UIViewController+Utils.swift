//
//  UIViewController+Utils.swift
//  RxBookshelf
//
//  Created by Mario on 1/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

extension UIViewController {
    static func createFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboard(name)
    }
    
    private static func instantiateFromStoryboard<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let storyboardId = String(describing: self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: storyboardId) as? T else {
            fatalError("\(storyboardId) not found in \(storyboard)")
        }
        return viewController
    }
}
