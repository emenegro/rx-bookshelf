//
//  ServiceLocator.swift
//  Bookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

final class ServiceLocator {
    private static var networkSession = URLSession.shared

    static var searchViewModel: SearchViewModel {
        let searchService = SearchServiceImpl(networkSession: networkSession)
        return SearchViewModelImpl(searchService: searchService)
    }
    
    static func injectInitialDependencies(window: UIWindow?) {
        guard let flowViewController = window?.rootViewController as? BookshelfFlowNavigationController else {
            fatalError("Initial UI is not correctly configured, please review Main.storyboard")
        }
        flowViewController.configureInitialViewController()
    }
}
