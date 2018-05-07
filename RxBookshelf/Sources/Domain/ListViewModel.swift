//
//  BooksViewModel.swift
//  RxBookshelf
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
            .flatMapLatest({ booksService.list() })
        
        deleteResult = deleteBook
            .flatMapLatest({ booksService.delete(book: $0) })
            .flatMapLatest({ result -> Observable<BookResult<[Book]>> in // TODO: use RxDataSources to diff data source and avoid get list again
                if case let .error(error, _) = result {
                    return .just(BookResult<[Book]>.error(error, cached: nil))
                } else {
                    return booksService.list()
                }
            })
    }
}
