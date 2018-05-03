//
//  SearchViewModel.swift
//  Bookshelf
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
    var results: Driver<[Book]> { get }
}

struct SearchViewModelImpl: SearchViewModel {
    let query = PublishSubject<String>()
    let results: Driver<[Book]>
    
    init(searchService: SearchService) {
        results = query
            .throttle(kDelayTime, scheduler: MainScheduler.instance)
            .filter({ !$0.isEmpty })
            .distinctUntilChanged()
            .flatMapLatest({ searchService.search(query: $0) })
            .asDriver(onErrorJustReturn: [])
    }
}

fileprivate let kDelayTime: RxTimeInterval = 0.5
