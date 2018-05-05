//
//  AppAppearance.swift
//  RxBookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

struct AppColors {
    static let background = UIColor.white
    static let foreground = UIColor(red:0.20, green:0.29, blue:0.36, alpha:1.00)
    static let secondary = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.00)
    static let tint = UIColor(red:0.70, green:0.07, blue:0.56, alpha:1.00)
}

class AppAppearance {
    static func apply(to window: UIWindow?) {
        guard let window = window else { return }
        applyWindowStyle(window)
        applyNavigationBarStyle()
        applyToolbarStyle()
    }
}

private extension AppAppearance {
    static func applyWindowStyle(_ window: UIWindow) {
        window.backgroundColor = AppColors.background
        window.tintColor = AppColors.tint
    }
    
    static func applyNavigationBarStyle() {
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = AppColors.secondary
        let textAttributes = [NSAttributedStringKey.foregroundColor: AppColors.foreground]
        appearance.titleTextAttributes = textAttributes
        appearance.largeTitleTextAttributes = textAttributes
    }
    
    static func applyToolbarStyle() {
        let appearance = UIToolbar.appearance()
        appearance.barTintColor = AppColors.secondary
    }
}
