//
//  BookViewController.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var removeBarButtonItem: UIBarButtonItem!
    @IBOutlet var markReadBarButtonItem: UIBarButtonItem!
    @IBOutlet var markUnreadBarButtonItem: UIBarButtonItem!
    var bookViewModel: BookViewModel!
}

extension BookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
}

private extension BookViewController {
    func setupView() {
        title = L10n.detail.localized
    }
}

private extension BookViewController {
    func bindViewModel() {
        bookViewModel.book
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { self.populate(with: $0) })
            .disposed(by: disposeBag)
        
        addBarButtonItem.rx.tap.asObservable()
            .bind(to: bookViewModel.addBook)
            .disposed(by: disposeBag)
        
        removeBarButtonItem.rx.tap.asObservable()
            .bind(to: bookViewModel.removeBook)
            .disposed(by: disposeBag)
        
        markReadBarButtonItem.rx.tap.asObservable()
            .bind(to: bookViewModel.markRead)
            .disposed(by: disposeBag)
        
        markUnreadBarButtonItem.rx.tap.asObservable()
            .bind(to: bookViewModel.markUnread)
            .disposed(by: disposeBag)
    }
}

private extension BookViewController {
    func populate(with book: Book) {
        book.coverImageUrl?.remoteImage
            .observeOn(MainScheduler.instance)
            .bind(to: coverImageView.rx.image)
            .disposed(by: self.disposeBag)
        titleLabel.text = book.title
        authorsLabel.text = book.authorsString
        publisherLabel.text = book.publisher
        publishedDateLabel.text = book.publishedDate
        descriptionLabel.text = book.description
        markReadBarButtonItem.isEnabled = book.isInShelf
        setToolbarItems(for: book)
    }
    
    func setToolbarItems(for book: Book) {
        var items = [UIBarButtonItem]()
        
        if book.isInShelf {
            items.append(removeBarButtonItem)
        } else {
            items.append(addBarButtonItem)
        }
        
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        
        if book.isRead {
            items.append(markUnreadBarButtonItem)
        } else {
            items.append(markReadBarButtonItem)
        }
        
        toolbar.setItems(items, animated: false)
    }
}
