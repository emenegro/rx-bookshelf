//
//  SearchResultsViewController.swift
//  Bookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultsViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    var searchViewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindings()
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupBindings() {
        searchViewModel.searchOutput
            .drive(tableView.rx.items(cellIdentifier: SearchResultTableViewCell.reuseIdentifier)) { (index, book: Book, cell: SearchResultTableViewCell) in
                cell.titleLabel.text = book.title
                cell.authorsLabel.text = book.authors.joined(separator: ", ")
            }
            .disposed(by: disposeBag)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchViewModel.query.value = searchController.searchBar.text ?? ""
    }
}
