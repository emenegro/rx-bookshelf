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

struct SearchService {
    let networkSession: URLSession
    private let host = Configuration.backendHost.stringValue
    private let searchEndpoint = Configuration.searchEndpoint.stringValue
    
    func search(query: String) -> Observable<[Book]> {
        guard
            let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
            let url = URL(string: "\(host)/\(searchEndpoint)?q=\(q)") else {
                return Observable.error(SearchResultError.general)
        }
        return networkSession.rx
            .data(request: URLRequest(url: url))
            .debug()
            .map({ (data) -> [Book] in
                let decoder = JSONDecoder()
                let books = try decoder.decode([Book].self, from: data)
                return books
            })
    }
}
