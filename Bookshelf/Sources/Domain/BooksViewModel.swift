//
//  BooksViewModel.swift
//  Bookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BooksViewModel {
    func set(getListTrigger: Observable<Void>) -> Driver<[Book]>
}

struct BooksViewModelImpl {
    let booksService: BooksService
    
    init(booksService: BooksService) {
        self.booksService = booksService
    }
}

extension BooksViewModelImpl: BooksViewModel {
    func set(getListTrigger: Observable<Void>) -> Driver<[Book]> {
        return getListTrigger
            .throttle(kListDelay, scheduler: MainScheduler.instance)
            .flatMap({ self.booksService.list() })
            .startWith([])
            .asDriver(onErrorJustReturn: [])
    }
}

private let kListDelay: RxTimeInterval = 0.5
