//
//  BooksViewModel.swift
//  Bookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ListViewModel {
    // Inputs
    var getList: PublishSubject<Void> { get }
    var deleteBook: PublishSubject<Book> { get }
    // Outputs
    var list: Observable<BookResult<[Book]>> { get }
    var deleteResult: Observable<BookResult<[Book]>> { get }
}

struct ListViewModelImpl: ListViewModel {
    let getList = PublishSubject<Void>()
    let deleteBook = PublishSubject<Book>()
    let list: Observable<BookResult<[Book]>>
    let deleteResult: Observable<BookResult<[Book]>>
    
    init(booksService: BooksService) {
        list = getList
            .throttle(kListDelay, scheduler: MainScheduler.instance)
            .flatMap({ booksService.list() })
        
        deleteResult = deleteBook
            .flatMap({ booksService.delete(book: $0) })
            .flatMap({ _ in booksService.list() }) // TODO: improve this
    }
}

private let kListDelay: RxTimeInterval = 0.5
