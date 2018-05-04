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
    func showDetailOf(book: Book)
}

class BookshelfFlowNavigationController: UINavigationController, AppFlowController {
    private var searchResultsViewController: SearchResultsViewController {
        let searchResultsViewController = SearchResultsViewController.createFromStoryboard()
        ServiceLocator.injectDependencies(to: searchResultsViewController)
        searchResultsViewController.flowViewController = self
        return searchResultsViewController
    }
    
    func configureInitialViewController() {
        guard let listViewController = topViewController as? ListViewController else {
            fatalError("Initial UI is not correctly configured, please review Main.storyboard")
        }
        ServiceLocator.injectDependencies(to: listViewController)
        listViewController.searchResultsViewController = searchResultsViewController
        listViewController.flowViewController = self
    }
    
    func showDetailOf(book: Book) {
        let bookViewController = BookViewController.createFromStoryboard()
        ServiceLocator.injectDependencies(to: bookViewController, using: book)
        show(bookViewController, sender: self)
    }
}
