//
//  BookTableViewCell.swift
//  Bookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookTableViewCell: SearchResultTableViewCell {
    private let isReadImageView: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        isReadImageView = UIImageView(image: R.Img.checkIcon.image)
        isReadImageView.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(isReadImageView)
        NSLayoutConstraint.activate([
            isReadImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -kCheckIconMargin),
            isReadImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: kCheckIconMargin)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with book: Book) {
        super.configure(with: book)
        isReadImageView.isHidden = !book.isRead
    }
}

private let kCheckIconMargin: CGFloat = 10
