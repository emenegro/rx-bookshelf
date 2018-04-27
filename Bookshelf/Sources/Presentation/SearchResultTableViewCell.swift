//
//  SearchResultTableViewCell.swift
//  Bookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultTableViewCell"
    static let nibName = "SearchResultTableViewCell"
    private let disposeBag = DisposeBag()
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorsLabel.text = book.authorsString
        book.coverImageUrl?.remoteImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.coverImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        authorsLabel.text = nil
        coverImageView.image = nil
    }
}
