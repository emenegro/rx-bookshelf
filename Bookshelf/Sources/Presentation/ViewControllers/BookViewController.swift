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
    static let storyboardId = "BookViewController"
    private let disposeBag = DisposeBag()
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var bookViewModel: BookViewModel!
}

extension BookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.detail.localized
        bindViewModel()
    }
}

private extension BookViewController {
    func bindViewModel() {
        bookViewModel.book
            .asDriver()
            .drive(onNext: {
                self.populate(with: $0)
            })
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
        descriptionLabel.text = book.description
    }
}
