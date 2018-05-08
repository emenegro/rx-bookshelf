//
//  BookViewModelTests.swift
//  RxBookshelfTests
//
//  Created by Mario on 8/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxBookshelf

class BookViewModelTests: ViewModelBaseTest {

    func test_when_creatingViewModel_then_firstBookReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: false))
        
        let observer = factory.observer(binding: PublishSubject<Void>(), toEvents: [], toObserve: sut.book)
        scheduler.start()
        
        let expected = [
            Recorded.next(0, BookResult<Book>.success(rawDummyBook))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_addingErrored_then_addErrorReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: true))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.addBook, toObservable: sut.book, testingError: BooksError.addError)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_addingSucceeds_then_bookReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: false))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.addBook, toObservable: sut.book)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_removingErrored_then_deleteErrorReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: true))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.removeBook, toObservable: sut.book, testingError: BooksError.deleteError)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_removingSucceeds_then_bookReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: false))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.removeBook, toObservable: sut.book)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_markReadErrored_then_markReadErrorReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: true))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.markRead, toObservable: sut.book, testingError: BooksError.markReadError)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_markReadSucceeds_then_bookReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: false))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.markRead, toObservable: sut.book)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_markUnreadErrored_then_markReadErrorReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: true))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.markUnread, toObservable: sut.book, testingError: BooksError.markReadError)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_markUnreadSucceeds_then_bookReturned() {
        let sut = BookViewModelImpl(book: rawDummyBook, booksService: BooksServiceStub(erroring: false))
        
        let (observer, expected) = prepareTest(bindingSubject: sut.markUnread, toObservable: sut.book)
        scheduler.start()
        
        XCTAssertEqual(observer.events, expected)
    }
}

private extension BookViewModelTests {
    func prepareTest(bindingSubject subject: PublishSubject<Void>,
                     toObservable observable: Observable<BookResult<Book>>,
                     testingError errorToTest: BooksError? = nil) -> (observer: TestableObserver<BookResult<Book>>, expected: [Recorded<Event<BookResult<Book>>>]) {
        
        let events = [
            Recorded.next(100, ())
        ]
        let observer = factory.observer(binding: subject, toEvents: events, toObserve: observable)
        
        var expected = [Recorded.next(0, BookResult<Book>.success(rawDummyBook))]
        if let error = errorToTest {
            expected.append(Recorded.next(100, BookResult<Book>.error(error, cached: nil)))
        } else {
            expected.append(Recorded.next(100, BookResult<Book>.success(rawDummyBook)))
        }
        
        return (observer, expected)
    }
}
