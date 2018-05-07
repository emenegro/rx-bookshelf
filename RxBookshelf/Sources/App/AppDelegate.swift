//
//  AppDelegate.swift
//  RxBookshelf
//
//  Created by Mario on 24/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureEntryPoint()
        activateRxSwiftDebugMode()
        return true
    }
    
    private func configureEntryPoint() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow()
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        ServiceLocator.injectInitialDependencies(window: window)
        AppAppearance.apply(to: window)
    }
    
    private func activateRxSwiftDebugMode() {
//        #if DEBUG
//        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { _ in
//                print("RxSwift resource count \(RxSwift.Resources.total)")
//            })
//        #endif
    }
}

