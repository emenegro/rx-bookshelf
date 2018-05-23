//
//  BooksService.swift
//  RxBookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

enum BooksError: Error {
    case wrongUrl
    case downloadError
    case addError
    case deleteError
    case markReadError
}

protocol BooksService {
    func list() -> Observable<BookResult<[Book]>>
    func add(book: Book) -> Observable<BookResult<Book>>
    func markAsRead(book: Book, isRead: Bool) -> Observable<BookResult<Book>>
    func delete(book: Book) -> Observable<BookResult<Book>>
}

class BooksServiceImpl {
    let networkSession: URLSession
    let configuration: APIConfiguration
    private var cachedBooks: [Book] = []
    
    init(networkSession: URLSession, configuration: APIConfiguration) {
        self.networkSession = networkSession
        self.configuration = configuration
    }
    
    private func url(bookId: String = "") -> Observable<URL> {
        if var url = URL(string: "\(configuration.backendHost)/\(configuration.booksEndpoint)") {
            url.appendPathComponent(bookId)
            return .just(url)
        } else {
            return .error(BooksError.wrongUrl)
        }
    }
}

extension BooksServiceImpl: BooksService {
    func list() -> Observable<BookResult<[Book]>> {
        return url()
            .map({ URLRequest(url: $0) })
            .executeIn(self.networkSession)
            .retry(kNumberOfRetries)
            .mapBooks()
            .map({ [weak self] in
                self?.cachedBooks = $0
                return BookResult.success($0)
            })
            .catchErrorJustReturn(BookResult.error(BooksError.downloadError, cached: cachedBooks))
    }
    
    func add(book: Book) -> Observable<BookResult<Book>> {
        return url()
            .map({
                var request = URLRequest(url: $0)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "post"
                request.httpBody = try JSONEncoder().encode(book)
                return request
            })
            .executeIn(self.networkSession)
            .retry(kNumberOfRetries)
            .mapBook()
            .map(BookResult.success)
            .catchErrorJustReturn(BookResult.error(BooksError.addError, cached: nil))
    }

    func markAsRead(book: Book, isRead: Bool) -> Observable<BookResult<Book>> {
        return url(bookId: book.id)
            .map({
                var request = URLRequest(url: $0)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "put"
                request.httpBody = try JSONSerialization.data(withJSONObject: ["isRead": isRead], options: [])
                return request
            })
            .executeIn(self.networkSession)
            .retry(kNumberOfRetries)
            .mapBook()
            .map(BookResult.success)
            .catchErrorJustReturn(BookResult.error(BooksError.markReadError, cached: nil))
    }

    func delete(book: Book) -> Observable<BookResult<Book>> {
        return url(bookId: book.id)
            .map({
                var request = URLRequest(url: $0)
                request.httpMethod = "delete"
                return request
            })
            .executeIn(self.networkSession)
            .retry(kNumberOfRetries)
            .mapBook()
            .map(BookResult.success)
            .catchErrorJustReturn(BookResult.error(BooksError.deleteError, cached: nil))
    }
}

fileprivate let kNumberOfRetries: Int = 2
