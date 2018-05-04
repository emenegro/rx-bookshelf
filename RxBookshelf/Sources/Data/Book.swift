//
//  Book.swift
//  Bookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation

struct Book: Codable {
    let id: String
    let title: String
    let authors: [String]
    let description: String
    let publisher: String
    let publishedDate: String
    let coverImageUrl: URL?
    var coverImage: Data?
    let isRead: Bool
    
    var authorsString: String {
        return authors.joined(separator: ", ")
    }
    
    var isInShelf: Bool {
        return !id.isEmpty // Id is only populated when added to shelf
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, authors, description, publisher, publishedDate, coverImageUrl, isRead
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        authors = try container.decodeIfPresent([String].self, forKey: .authors) ?? []
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        publisher = try container.decodeIfPresent(String.self, forKey: .publisher) ?? ""
        publishedDate = try container.decodeIfPresent(String.self, forKey: .publishedDate) ?? ""
        coverImageUrl = try container.decodeIfPresent(URL.self, forKey: .coverImageUrl) ?? nil
        isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        // Don't encode id nor isRead because is populated automatically by server
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authors)
        try container.encode(description, forKey: .description)
        try container.encode(publisher, forKey: .publisher)
        try container.encode(publishedDate, forKey: .publishedDate)
        try container.encode(coverImageUrl, forKey: .coverImageUrl)
    }
}
