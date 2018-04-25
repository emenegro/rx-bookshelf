//
//  Book.swift
//  Bookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation

struct Book: Codable {
    let id: String?
    let title: String?
    let authors: [String]?
    let description: String?
    let publisher: String?
    let publishedDate: String?
    let coverImageUrl: URL?
    var isRead: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, authors, description, publisher, publishedDate, coverImageUrl, isRead
    }
}
