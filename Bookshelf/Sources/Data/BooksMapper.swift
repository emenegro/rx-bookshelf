//
//  BooksMapper.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift

enum BooksMapperError: Error {
    case general
}

extension ObservableType where E == Data {
    func mapBooks() -> Observable<[Book]> {
        return flatMap({ (data) -> Observable<[Book]> in
            do {
                let result = try JSONDecoder().decode([Book].self, from: data)
                return Observable.just(result)
            } catch {
                return Observable<[Book]>.error(BooksMapperError.general)
            }
        })
    }
    
    func mapBook() -> Observable<Book> {
        return flatMap({ (data) -> Observable<Book> in
            do {
                let result = try JSONDecoder().decode(Book.self, from: data)
                return Observable.just(result)
            } catch {
                return Observable<Book>.error(BooksMapperError.general)
            }
        })
    }

}
