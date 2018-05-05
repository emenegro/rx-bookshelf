//
//  BookImageFiller.swift
//  RxBookshelf
//
//  Created by Mario on 5/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

protocol BookImageFiller {
}

extension UIImageView: BookImageFiller {}

extension BookImageFiller where Self == UIImageView {
    func populateCoverImage(_ book: Book) {
        guard let url = book.coverImageUrl?.absoluteString else { return }
        DispatchQueue.global().async {
            let image = UIImage(url: url)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
