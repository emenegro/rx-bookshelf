//
//  SearchServiceStub.swift
//  RxBookshelfTests
//
//  Created by Mario on 6/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift
@testable import RxBookshelf

class SearchServiceStub: SearchService {
    let erroring: Bool
    
    init(erroring: Bool) {
        self.erroring = erroring
    }
    
    func search(query: String) -> Observable<BookResult<[Book]>> {
        if erroring {
            return .just(BookResult.error(SearchError.downloadError, cached: nil))
        } else {
            return dummyBooks.map(BookResult.success)
        }
    }
}
