//
//  SearchNetworkDataSource.swift
//  RxBookshelf
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
    let configuration: APIConfiguration
    
    init(networkSession: URLSession, configuration: APIConfiguration) {
        self.networkSession = networkSession
        self.configuration = configuration
    }
    
    private func url(query: String) -> Observable<URL> {
        if let q = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics),
           let url = URL(string: "\(configuration.backendHost)/\(configuration.searchEndpoint)?q=\(q)") {
            return .just(url)
        } else {
            return .error(BooksError.wrongUrl)
        }
    }
}

extension SearchServiceImpl: SearchService {
    func search(query: String) -> Observable<BookResult<[Book]>> {
        return url(query: query)
            .map({ [configuration] in
                var request = URLRequest(url: $0)
                request.timeoutInterval = configuration.requestTimeOutInSeconds
                return request
            })
            .executeIn(self.networkSession)
            .retry(kNumberOfRetries)
            .mapBooks()
            .startWith([])
            .map(BookResult.success)
            .catchErrorJustReturn(BookResult.error(SearchError.downloadError, cached: nil))
    }
}

fileprivate let kNumberOfRetries: Int = 2
