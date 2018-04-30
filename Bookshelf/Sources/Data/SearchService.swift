//
//  SearchNetworkDataSource.swift
//  Bookshelf
//
//  Created by Mario on 24/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

enum SearchError: Error {
    case wrongUrl
}

protocol SearchService {
    func search(query: String) -> Observable<[Book]>
}

struct SearchServiceImpl {
    let networkSession: URLSession
    private let host = Configuration.backendHost.stringValue
    private let searchEndpoint = Configuration.searchEndpoint.stringValue
    
    private func url(query: String) -> Observable<URL> {
        if let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
           let url = URL(string: "\(host)/\(searchEndpoint)?q=\(q)") {
            return Observable<URL>.just(url)
        } else {
            return Observable.error(BooksError.wrongUrl)
        }
    }
}

extension SearchServiceImpl: SearchService {
    func search(query: String) -> Observable<[Book]> {
        return url(query: query)
            .map({ URLRequest(url: $0) })
            .execute(in: networkSession)
            .mapBooks()
    }
}
