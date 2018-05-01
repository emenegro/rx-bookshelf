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
    var emptyStateView: EmptyStateView!
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
        setupView()
        bindViewModel()
    }
}

private extension ListViewController {
    func setupView() {
        setupNavigation()
        setupTableView()
        setupPullToRefresh()
        setupEmptyStateView()
    }
    
    func setupNavigation() {
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setupTableView() {
        tableView.dataSource = nil // To not interfere with Rx
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.reuseIdentifier)
    }
    
    func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
    }
    
    func setupEmptyStateView() {
        emptyStateView = EmptyStateView.createFromNib()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: kEmptyStateViewTopMargin),
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }
}

private extension ListViewController {
    func bindViewModel() {
        bindTableView()
    }
    
    func bindTableView() {
        let viewWillAppearObservable = rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map({ _ in () })
        let refreshObservable = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        let getListObservable = Observable.of(viewWillAppearObservable, refreshObservable).merge()

        booksViewModel.set(getListTrigger: getListObservable)
            .do(onNext: { [refreshControl, emptyStateView] list in
                refreshControl?.endRefreshing()
                emptyStateView?.isHidden = !list.isEmpty
            })
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

private let kEmptyStateViewTopMargin: CGFloat = 30
