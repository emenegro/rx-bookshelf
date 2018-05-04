//
//  L10n.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation

enum L10n: String {
    case accept
    case add
    case addBook = "add_book"
    case detail
    case edit
    case error
    case errorDownloading = "error_downloading"
    case errorExecutingOperation = "error_executing_operation"
    case markRead = "mark_read"
    case markUnread = "mark_unread"
    case remove
}

extension L10n: Localizable {
    var localized: String {
        return self.rawValue.localized
    }
}
