//
//  AppFlowController.swift
//  Bookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

protocol AppFlowController {
    func configureInitialViewController()
}

class BookshelfFlowNavigationController: UINavigationController, AppFlowController {
    private var searchResultsViewController: SearchResultsViewController {
        let searchResultsViewController = SearchResultsViewController(style: .plain)
        searchResultsViewController.searchViewModel = ServiceLocator.searchViewModel
        return searchResultsViewController
    }
    
    func configureInitialViewController() {
        guard let listViewController = topViewController as? ListViewController else {
            fatalError("Initial UI is not correctly configured, please review Main.storyboard")
        }
        listViewController.searchViewModel = ServiceLocator.searchViewModel
        listViewController.searchResultsViewController = searchResultsViewController
    }
}
