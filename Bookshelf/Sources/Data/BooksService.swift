//
//  BooksService.swift
//  Bookshelf
//
//  Created by Mario on 25/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

enum BooksError: Error {
    case wrongUrl
    case adding
}

protocol BooksService {
    func list() -> Observable<[Book]>
    func add(book: Book) -> Observable<Book>
    func markAsRead(book: Book, isRead: Bool) -> Observable<Book>
    func delete(book: Book) -> Observable<Void>
}

struct BooksServiceImpl {
    let networkSession: URLSession
    private let host = Configuration.backendHost.stringValue
    private let booksEndpoint = Configuration.booksEndpoint.stringValue
    
    private func url(bookId: String = "") -> Observable<URL> {
        if var url = URL(string: "\(host)/\(booksEndpoint)") {
            url.appendPathComponent(bookId)
            return Observable<URL>.just(url)
        } else {
            return Observable.error(BooksError.wrongUrl)
        }
    }
}

extension BooksServiceImpl: BooksService {
    func list() -> Observable<[Book]> {
        return url()
            .map({ URLRequest(url: $0) })
            .execute(in: networkSession)
            .mapBooks()
    }
    
    func add(book: Book) -> Observable<Book> {
        return url()
            .map({
                var request = URLRequest(url: $0)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "post"
                request.httpBody = try JSONEncoder().encode(book)
                return request
            })
            .execute(in: networkSession)
            .mapBook()
    }

    func markAsRead(book: Book, isRead: Bool) -> Observable<Book> {
        return url(bookId: book.id)
            .map({
                var request = URLRequest(url: $0)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "put"
                request.httpBody = try JSONEncoder().encode(isRead)
                return request
            })
            .execute(in: networkSession)
            .mapBook()
    }

    func delete(book: Book) -> Observable<Void> {
        return url(bookId: book.id)
            .map({
                var request = URLRequest(url: $0)
                request.httpMethod = "delete"
                return request
            })
            .execute(in: networkSession)
            .map({ _ -> Void in return () })
    }
}

