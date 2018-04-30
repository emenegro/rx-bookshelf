//
//  SearchTableViewController.swift
//  Bookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var booksViewModel: BooksViewModel!
    var searchResultsViewController: SearchResultsViewController!
    var flowViewController: BookshelfFlowNavigationController!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.searchBar.placeholder = L10n.addBook.localized
        return searchController
    }()
}

extension ListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        setupPullToRefresh()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        booksViewModel.getList.onNext(())
    }
}

private extension ListViewController {
    func setupNavigation() {
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged)
            .filter({ self.refreshControl.isRefreshing })
            .bind(to: booksViewModel.getList)
            .disposed(by: disposeBag)
    }
}

private extension ListViewController {
    func bindViewModel() {
        bindTableView()
    }
    
    private func bindTableView() {
        tableView.dataSource = nil
        booksViewModel.list
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .drive(tableView.rx.items(cellIdentifier: BookTableViewCell.reuseIdentifier)) { (index, book: Book, cell: SearchResultTableViewCell) in
                cell.configure(with: book)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Book.self)
            .subscribe(onNext: { [flowViewController] in
                flowViewController?.showDetailOf(book: $0)
            }).disposed(by: disposeBag)
    }
}
