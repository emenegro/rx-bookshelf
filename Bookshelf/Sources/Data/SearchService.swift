//
//  SearchNetworkDataSource.swift
//  Bookshelf
//
//  Created by Mario on 24/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

enum SearchResultError: Error {
    case general
}

enum SearchResult {
    case success([Book])
    case error(SearchResultError)
}

struct SearchService {
    private let session = URLSession.shared
    private let host = "http://127.0.0.1:8080"
    
    let searchOutput: Observable<SearchResult>
    
    init(searchInput: Observable<String>) {
        searchOutput = searchInput
            .flatMap({ [host] (query) -> Observable<URL> in
                let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? ""
                return Observable.from(optional: URL(string: "\(host)/search?q=\(q)"))
            })
            .flatMap({ [session] in
                session.rx.data(request: URLRequest(url: $0))
            })
            .map({ (data) -> SearchResult in
                let decoder = JSONDecoder()
                let books = try decoder.decode([Book].self, from: data)
                return SearchResult.success(books)
            })
            .catchErrorJustReturn(SearchResult.error(SearchResultError.general))
    }
}
