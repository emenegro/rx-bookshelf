//
//  SearchResultTableViewCell.swift
//  Bookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SearchResultTableViewCell"
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
}
