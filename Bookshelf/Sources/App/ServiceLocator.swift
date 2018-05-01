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
    private static var booksService = BooksServiceImpl(networkSession: networkSession)
    private static var searchViewModel: SearchViewModel {
        let searchService = SearchServiceImpl(networkSession: networkSession)
        return SearchViewModelImpl(searchService: searchService)
    }
    private static var booksViewModel: BooksViewModel {
        return BooksViewModelImpl(booksService: booksService)
    }
    
    static func injectInitialDependencies(window: UIWindow?) {
        guard let flowViewController = window?.rootViewController as? BookshelfFlowNavigationController else {
            fatalError("Initial UI is not correctly configured, please review Main.storyboard")
        }
        flowViewController.configureInitialViewController()
    }
    
    static func injectDependencies(to listViewController: ListViewController) {
        listViewController.booksViewModel = booksViewModel
    }
    
    static func injectDependencies(to searchResultsViewController: SearchResultsViewController) {
        searchResultsViewController.searchViewModel = searchViewModel
    }
    
    static func injectDependencies(to bookViewController: BookViewController, using book: Book) {
        let viewModel = BookViewModelImpl(book: book, booksService: booksService)
        bookViewController.bookViewModel = viewModel
    }
}
