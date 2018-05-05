//
//  BookInListView.xib
//  RxBookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookInListView: UIView {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorsLabel.text = book.authorsString
        populateCoverImage(book)
    }
    
    func populateCoverImage(_ book: Book) {
        guard let url = book.coverImageUrl?.absoluteString else { return }
        DispatchQueue.global().async { [coverImageView] in
            let image = UIImage(url: url)
            DispatchQueue.main.async {
                coverImageView?.image = image
            }
        }
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        authorsLabel.text = nil
        coverImageView.image = nil
    }
}
