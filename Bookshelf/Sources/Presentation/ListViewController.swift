//
//  SearchTableViewController.swift
//  Bookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var searchViewModel: SearchViewModel!
    var searchResultsViewController: SearchResultsViewController!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}
