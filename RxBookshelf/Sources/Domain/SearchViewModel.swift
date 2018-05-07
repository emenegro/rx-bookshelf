//
//  SearchViewModel.swift
//  RxBookshelf
//
//  Created by Mario on 26/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchViewModel {
    // Inputs
    var query: PublishSubject<String> { get }
    // Outputs
    var results: Observable<BookResult<[Book]>> { get }
}

struct SearchViewModelImpl: SearchViewModel {
    let query = PublishSubject<String>()
    let results: Observable<BookResult<[Book]>>
    
    init(searchService: SearchService, scheduler: SchedulerType = MainScheduler.instance) {
        results = query
            .distinctUntilChanged()
            .throttle(kThrottleTime, scheduler: scheduler)
            .filter({ !$0.isEmpty })
            .flatMapLatest({ searchService.search(query: $0) })
    }
}

fileprivate let kThrottleTime: RxTimeInterval = 1
