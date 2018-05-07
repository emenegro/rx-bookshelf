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

class SearchViewModelTest: ViewModelBaseTest {
    
    func test_when_searchErrored_then_nextEventWithDownloadError() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: true), scheduler: scheduler)
        let events = [
            Recorded.next(200, ("Rx")),
            Recorded.next(800, ("RxSwift"))
        ]
        let observer = factory.observer(binding: sut.query, toEvents: events, toObserve: sut.results)

        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.error(SearchError.downloadError, cached: nil)),
            Recorded.next(800, BookResult<[Book]>.error(SearchError.downloadError, cached: nil))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchSucceeds_then_nextEventWithBooks() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let events = [
            Recorded.next(200, ("RxSwift"))
        ]
        let observer = factory.observer(binding: sut.query, toEvents: events, toObserve: sut.results)

        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.success(rawDummyBooks))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchWithSameQuery_then_onlyOneEventSent() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let events = [
            Recorded.next(200, ("RxSwift")),
            Recorded.next(300, ("RxSwift"))
        ]
        let observer = factory.observer(binding: sut.query, toEvents: events, toObserve: sut.results)

        scheduler.start()
        
        let expected = [
            Recorded.next(200, BookResult<[Book]>.success(rawDummyBooks))
        ]
        XCTAssertEqual(observer.events, expected)
    }
    
    func test_when_searchWithEmptyQuery_then_nothingSent() {
        let sut = SearchViewModelImpl(searchService: SearchServiceStub(erroring: false), scheduler: scheduler)
        let events = [
            Recorded.next(200, (""))
        ]
        let observer = factory.observer(binding: sut.query, toEvents: events, toObserve: sut.results)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [])
    }
}
