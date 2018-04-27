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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.detail.localized
        bindViewModel()
    }
    
    func bindViewModel() {
        bookViewModel.book
            .asDriver()
            .drive(onNext: {
                $0.coverImageUrl?.remoteImage
                    .observeOn(MainScheduler.instance)
                    .bind(to: self.coverImageView.rx.image)
                    .disposed(by: self.disposeBag)
                self.titleLabel.text = $0.title
                self.authorsLabel.text = $0.authorsString
                self.descriptionLabel.text = $0.description
            })
            .disposed(by: disposeBag)
    }
}
