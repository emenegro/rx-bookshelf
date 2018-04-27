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
    var flowViewController: BookshelfFlowNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableViewBindings()
        bindViewModel()
    }
    
    func setupTableView() {
        let cellNib = UINib(nibName: SearchResultTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func setupTableViewBindings() {
        tableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [flowViewController] in
                flowViewController?.showDetailOf(book: $0)
            }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        searchViewModel.searchOutput
            .drive(tableView.rx.items(cellIdentifier: SearchResultTableViewCell.reuseIdentifier)) { (index, book: Book, cell: SearchResultTableViewCell) in
                cell.configure(with: book)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchViewModel.query.value = searchController.searchBar.text ?? ""
    }
}
