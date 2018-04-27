//
//  BooksMapper.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift

protocol BooksMapper {
}

extension BooksMapper {
    // Version returning Observable<[Book]>
    func mapBooks(_ data: Data) throws -> [Book] {
        return try JSONDecoder().decode([Book].self, from: data)
    }
    
    // Version returning Observable<Book>
//    enum BooksMapperError: Error {
//        case general
//    }
//
//    func mapBooks(_ data: Data) -> Observable<Book> {
//        return Observable<Book>.create { (observer) -> Disposable in
//            do {
//                let books = try JSONDecoder().decode([Book].self, from: data)
//                books.forEach({ observer.onNext($0) })
//                observer.onCompleted()
//            } catch {
//                observer.onError(BooksMapperError.general)
//            }
//            return Disposables.create()
//        }
//    }
}
