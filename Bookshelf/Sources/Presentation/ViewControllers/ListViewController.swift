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
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    var emptyStateView: EmptyStateView!
    var refreshControl: UIRefreshControl!
    var booksViewModel: BooksViewModel!
    var searchResultsViewController: SearchResultsViewController!
    var flowViewController: BookshelfFlowNavigationController!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.searchBar.placeholder = L10n.addBook.localized
        searchController.searchBar.returnKeyType = .done
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
        setupEditBarButtonItem()
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
    
    func setupEditBarButtonItem() {
        editBarButtonItem.rx.tap.asObservable()
            .subscribe(onNext: { _ in
                self.tableView.setEditing(!self.tableView.isEditing, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.methodInvoked(#selector(setEditing(_:animated:)))
            .startWith([])
            .subscribe(onNext: { _ in
                self.editBarButtonItem.title = self.tableView.isEditing ? L10n.accept.localized : L10n.edit.localized
            })
            .disposed(by: disposeBag)
    }
}

private extension ListViewController {
    func bindViewModel() {
        bindTableView()
    }
    
    func bindTableView() {
        let viewWillAppearObservable = rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map({ _ in () })
        let refreshObservable = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        Observable.of(viewWillAppearObservable, refreshObservable).merge()
            .bind(to: booksViewModel.getList)
            .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(Book.self)
            .bind(to: booksViewModel.deleteBook)
            .disposed(by: disposeBag)
        
        Observable.of(booksViewModel.list, booksViewModel.deleteResult).merge()
            .asDriver(onErrorJustReturn: [])
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
