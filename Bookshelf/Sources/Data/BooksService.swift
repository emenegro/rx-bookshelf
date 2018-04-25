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
    case general
    case adding
}

enum BooksResult {
    case success([Book])
    case error(BooksError)
}

struct BooksService {
    private let session = URLSession.shared
    private let host = "http://127.0.0.1:8080"
    
    let listOutput: Observable<BooksResult>
    let addOutput: Observable<BooksResult>
    let markAsReadOutput: Observable<BooksResult>
    let deleteOutput: Observable<BooksResult>
    
    init(listInput: Observable<Void>, addInput: Observable<Book>, markAsReadInput: Observable<Book>, deleteInput: Observable<Book>) {
        listOutput = listInput
            .flatMap({ [host] in
                Observable.from(optional: URL(string: "\(host)/books"))
            })
            .flatMap({ [session] in
                session.rx.data(request: URLRequest(url: $0))
            })
            .map({ (data) -> BooksResult in
                let decoder = JSONDecoder()
                let books = try decoder.decode([Book].self, from: data)
                return BooksResult.success(books)
            })
        
        addOutput = addInput
            .flatMap({ [host, session] book -> Observable<Data> in
                let url = URL(string: "\(host)/books")!
                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "post"
                request.httpBody = try JSONEncoder().encode(book)
                return session.rx.data(request: request)
            })
            .map({ (data) -> BooksResult in
                let decoder = JSONDecoder()
                let book = try decoder.decode(Book.self, from: data)
                return BooksResult.success([book])
            })
        
        markAsReadOutput = markAsReadInput
            .flatMap({ [host, session] book -> Observable<Data> in
                let url = URL(string: "\(host)/books/\(book.id!)")!
                var request = URLRequest(url: url)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "put"
                request.httpBody = try JSONEncoder().encode(book) // Encode only isRead
                return session.rx.data(request: request)
            })
            .map({ (data) -> BooksResult in
                let decoder = JSONDecoder()
                let book = try decoder.decode(Book.self, from: data)
                return BooksResult.success([book])
            })
        
        deleteOutput = deleteInput
            .flatMap({ [host, session] book -> Observable<Data> in
                let url = URL(string: "\(host)/books/\(book.id!)")!
                var request = URLRequest(url: url)
                request.httpMethod = "delete"
                return session.rx.data(request: request)
            })
            .map({ (data) -> BooksResult in
                return BooksResult.success([])
            })
    }
}

