//
//  ServiceLocator.swift
//  RxBookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

final class ServiceLocator {
    private static let networkSession = URLSession.shared
    
    static func injectInitialDependencies(window: UIWindow?) {
        guard let flowViewController = window?.rootViewController as? BookshelfFlowNavigationController else {
            fatalError("Initial UI is not correctly configured, please review Main.storyboard")
        }
        flowViewController.configureInitialViewController()
    }
    
    static func injectDependencies(to listViewController: ListViewController) {
        let booksService = BooksServiceImpl(networkSession: networkSession)
        let listViewModel = ListViewModelImpl(booksService: booksService)
        listViewController.listViewModel = listViewModel
    }
    
    static func injectDependencies(to searchResultsViewController: SearchResultsViewController) {
        let searchService = SearchServiceImpl(networkSession: networkSession)
        let searchViewModel = SearchViewModelImpl(searchService: searchService)
        searchResultsViewController.searchViewModel = searchViewModel
    }
    
    static func injectDependencies(to bookViewController: BookViewController, using book: Book) {
        let booksService = BooksServiceImpl(networkSession: networkSession)
        let bookViewModel = BookViewModelImpl(book: book, booksService: booksService)
        bookViewController.bookViewModel = bookViewModel
    }
}
