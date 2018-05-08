//
//  ListViewModelTests.swift
//  RxBookshelfTests
//
//  Created by Mario on 7/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxBookshelf

class ListViewModelTests: ViewModelBaseTest {
    
    func test_when_getListErrored_then_nextEventWithDownloadError() {
        let sut = ListViewModelImpl(booksService: BooksServiceStub(erroring: true))
        let events = [
            Recorded.next(100, ()),
            Recorded.next(300, ())
        ]
        
        let observer = factory.observer(binding: sut.getList, toEvents: events, toObserve: sut.list)
        scheduler.start()
        
        let expected = [
            Recorded.next(100, BookResult<[Book]>.error(BooksError.downloadError, cached: nil)),
            Recorded.next(300, BookResult<[Book]>.error(BooksError.downloadError, cached: nil))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_getListSuccess_then_nextEventWithBooks() {
        let sut = ListViewModelImpl(booksService: BooksServiceStub(erroring: false))
        let events = [
            Recorded.next(100, ())
        ]
        
        let observer = factory.observer(binding: sut.getList, toEvents: events, toObserve: sut.list)
        scheduler.start()
        
        let expected = [
            Recorded.next(100, BookResult<[Book]>.success(rawDummyBooks))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_deleteError_then_nextEventWithDeleteError() {
        let sut = ListViewModelImpl(booksService: BooksServiceStub(erroring: true))
        let events = [
            Recorded.next(100, (rawDummyBook))
        ]
        
        let observer = factory.observer(binding: sut.deleteBook, toEvents: events, toObserve: sut.deleteResult)
        scheduler.start()
        
        let expected = [
            Recorded.next(100, BookResult<[Book]>.error(BooksError.deleteError, cached: nil))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_deleteSucceeds_then_nextEventWithBooks() {
        let sut = ListViewModelImpl(booksService: BooksServiceStub(erroring: false))
        let events = [
            Recorded.next(100, (rawDummyBook))
        ]
        
        let observer = factory.observer(binding: sut.deleteBook, toEvents: events, toObserve: sut.deleteResult)
        scheduler.start()
        
        let expected = [
            Recorded.next(100, BookResult<[Book]>.success(rawDummyBooks))
        ]
        XCTAssertEqual(observer.events, expected)
    }
}
