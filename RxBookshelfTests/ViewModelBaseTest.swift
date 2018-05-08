//
//  ViewModelBaseTest.swift
//  RxBookshelfTests
//
//  Created by Mario on 8/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

class ViewModelBaseTest: XCTestCase {
    var disposeBag = DisposeBag()
    var scheduler: TestScheduler!
    var factory: ViewModelTestFactory!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        factory = ViewModelTestFactory(disposeBag: disposeBag, scheduler: scheduler)
    }
}
