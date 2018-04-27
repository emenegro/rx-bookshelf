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
    case wrongUrl
}

protocol SearchService {
    func search(query: String) -> Observable<[Book]>
}

struct SearchServiceImpl: SearchService, BooksMapper {
    let networkSession: URLSession
    private let host = Configuration.backendHost.stringValue
    private let searchEndpoint = Configuration.searchEndpoint.stringValue
    
    func search(query: String) -> Observable<[Book]> {
        guard
            let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
            let url = URL(string: "\(host)/\(searchEndpoint)?q=\(q)") else {
                return Observable.error(SearchResultError.wrongUrl)
        }
        return networkSession.rx
            .data(request: URLRequest(url: url))
            .map({ [mapBooks] in try mapBooks($0) })
    }
}
