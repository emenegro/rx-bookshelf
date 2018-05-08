//
//  BooksServiceStub.swift
//  RxBookshelfTests
//
//  Created by Mario on 7/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxBookshelf

class BooksServiceStub: BooksService {
    let erroring: Bool
    
    init(erroring: Bool) {
        self.erroring = erroring
    }
    
    func list() -> Observable<BookResult<[Book]>> {
        if erroring {
            return .just(BookResult.error(BooksError.downloadError, cached: nil))
        } else {
            return dummyBooks.map(BookResult.success)
        }
    }
    
    func add(book: Book) -> Observable<BookResult<Book>> {
        if erroring {
            return .just(BookResult.error(BooksError.addError, cached: nil))
        } else {
            return dummyBook.map(BookResult.success)
        }
    }
    
    func markAsRead(book: Book, isRead: Bool) -> Observable<BookResult<Book>> {
        if erroring {
            return .just(BookResult.error(BooksError.markReadError, cached: nil))
        } else {
            return dummyBook.map(BookResult.success)
        }
    }
    
    func delete(book: Book) -> Observable<BookResult<Book>> {
        if erroring {
            return .just(BookResult.error(BooksError.deleteError, cached: nil))
        } else {
            return dummyBook.map(BookResult.success)
        }
    }
}
