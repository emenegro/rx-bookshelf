//
//  SearchResultTableViewCell.swift
//  RxBookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultTableViewCell: UITableViewCell {
    private let bookView: BookInListView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        bookView = BookInListView.createFromNib()
        bookView.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bookView)
        NSLayoutConstraint.activate([
            bookView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: kContentLeftMargin),
            bookView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bookView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bookView.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with book: Book) {
        bookView.configure(with: book)
    }
    
    override func prepareForReuse() {
        bookView.prepareForReuse()
    }
}

private let kContentLeftMargin: CGFloat = 10
