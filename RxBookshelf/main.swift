//
//  main.swift
//  RxBookshelf
//
//  Created by Mario on 7/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import UIKit

let appDelegateClass: AnyClass = NSClassFromString("RxBookshelfTests.MockAppDelegate") ?? AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)
    ),
    NSStringFromClass(UIApplication.self),
    NSStringFromClass(appDelegateClass)
)
