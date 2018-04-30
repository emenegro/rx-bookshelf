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
    var query: Variable<String> { get }
    var searchOutput: Driver<[Book]> { get }
    init(searchService: SearchService)
}

struct SearchViewModelImpl: SearchViewModel {
    let query = Variable("")
    let searchOutput: Driver<[Book]>
    
    init(searchService: SearchService) {
        searchOutput = query.asObservable()
            .throttle(kDelayTime, scheduler: MainScheduler.instance)
            .filter({ !$0.isEmpty })
            .distinctUntilChanged()
            .flatMapLatest({ searchService.search(query: $0) })
            .startWith([])
            .asDriver(onErrorJustReturn: [])
    }
}

fileprivate let kDelayTime: RxTimeInterval = 0.5
