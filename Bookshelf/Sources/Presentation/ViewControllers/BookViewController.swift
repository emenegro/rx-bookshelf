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
    @IBOutlet weak var readImageView: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shelfBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var readBarButtonItem: UIBarButtonItem!
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
            .asDriver()
            .drive(onNext: { self.populate(with: $0) })
            .disposed(by: disposeBag)
        
        bookViewModel.set(toggleInShelfTrigger: shelfBarButtonItem.rx.tap.asObservable())
        bookViewModel.set(toggleReadTrigger: readBarButtonItem.rx.tap.asObservable())
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
        shelfBarButtonItem.title = book.isInShelf ? L10n.remove.localized : L10n.add.localized
        readBarButtonItem.title = book.isRead ? L10n.markUnread.localized : L10n.markRead.localized
        readImageView.isHidden = !book.isRead
        readBarButtonItem.isEnabled = book.isInShelf
    }
}
