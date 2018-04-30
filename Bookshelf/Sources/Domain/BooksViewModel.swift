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
    init(booksService: BooksService)
}

struct BooksViewModelImpl: BooksViewModel {
    var getList = PublishSubject<Void>()
    let list: Driver<[Book]>
    
    init(booksService: BooksService) {
        list = getList
            .throttle(0.5, scheduler: MainScheduler.instance)
            .flatMap({ booksService.list() })
            .startWith([])
            .asDriver(onErrorJustReturn: [])
    }
}
