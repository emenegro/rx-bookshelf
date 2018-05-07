//
//  SearchViewModelTest.swift
//  RxBookshelfTests
//
//  Created by Mario on 6/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import RxBookshelf

class SearchViewModelTest: XCTestCase {
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func test_when_searchErrored_then_nextEventWithError() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: true), scheduler: scheduler)
        let observer = arrangeTest(sut: sut, events: [
            Recorded.next(200, ("Rx")),
            Recorded.next(800, ("RxSwift"))
            ]
        )

        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.error(SearchError.downloadError, cached: nil)),
            Recorded.next(800, BookResult<[Book]>.error(SearchError.downloadError, cached: nil))
        ]
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchSucceeds_then_nextEventWithBooks() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let observer = arrangeTest(sut: sut, events: [
            Recorded.next(200, ("RxSwift"))
            ]
        )
        
        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.success(rawBooks))
        ]
        
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchWithSameQuery_then_onlyOneEventSent() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let observer = arrangeTest(sut: sut, events: [
            Recorded.next(200, ("RxSwift")),
            Recorded.next(300, ("RxSwift"))
            ]
        )
        
        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.success(rawBooks))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchWithEmptyQuery_then_nothingSent() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let observer = arrangeTest(sut: sut, events: [
            Recorded.next(200, (""))
            ]
        )
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [])
    }
}

private extension SearchViewModelTest {
    func arrangeTest(sut: SearchViewModelImpl, events: [Recorded<Event<String>>]) -> TestableObserver<BookResult<[Book]>> {
        let observer = scheduler.createObserver(BookResult<[Book]>.self)
        
        scheduler
            .createHotObservable(events)
            .bind(to: sut.query)
            .disposed(by: disposeBag)
        
        sut.results
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        return observer
    }
}
