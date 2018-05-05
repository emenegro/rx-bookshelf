//
//  AppDelegate.swift
//  RxBookshelf
//
//  Created by Mario on 24/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ServiceLocator.injectInitialDependencies(window: window)
        AppAppearance.apply(to: window)
        activateRxSwiftDebugModeIfNeeded()
        return true
    }
    
    private func activateRxSwiftDebugModeIfNeeded() {
        #if DEBUG
        _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                print("RxSwift resource count \(RxSwift.Resources.total)")
            })
        #endif
    }
}

