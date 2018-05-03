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
    func set(deleteTrigger: Observable<Book>) -> Observable<[Book]>
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
    
    func set(deleteTrigger: Observable<Book>) -> Observable<[Book]> {
        return deleteTrigger
            .flatMap({ self.booksService.delete(book: $0) })
            .flatMap({ _ in self.booksService.list() })
    }
}

private let kListDelay: RxTimeInterval = 0.5
