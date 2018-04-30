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
    // Inputs
    var getList: PublishSubject<Void> { get }
    // Outputs
    var list: Driver<[Book]> { get }
}

struct BooksViewModelImpl: BooksViewModel {
    var getList = PublishSubject<Void>()
    let list: Driver<[Book]>
    
    init(booksService: BooksService) {
        list = getList
            .throttle(kListDelay, scheduler: MainScheduler.instance)
            .flatMap({ booksService.list() })
            .startWith([])
            .asDriver(onErrorJustReturn: [])
    }
}

private let kListDelay: RxTimeInterval = 0.5
