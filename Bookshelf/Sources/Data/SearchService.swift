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
    case downloadError
}

protocol SearchService {
    func search(query: String) -> Observable<BookResult<[Book]>>
}

class SearchServiceImpl {
    let networkSession: URLSession
    private let host = Configuration.backendHost.stringValue
    private let searchEndpoint = Configuration.searchEndpoint.stringValue
    
    init(networkSession: URLSession) {
        self.networkSession = networkSession
    }
    
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
    func search(query: String) -> Observable<BookResult<[Book]>> {
        return url(query: query)
            .map({ URLRequest(url: $0) })
            .execute(in: networkSession)
            .retry(kNumberOfRetries)
            .mapBooks()
            .startWith([])
            .map({ BookResult.success($0) })
            .catchErrorJustReturn(BookResult.error(SearchError.downloadError, cached: nil))
    }
}

fileprivate let kNumberOfRetries: Int = 2
