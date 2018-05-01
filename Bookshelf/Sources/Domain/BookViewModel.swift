//
//  BookViewModel.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BookViewModel {
    var book: Driver<Book> { get }
    func set(toggleInShelfTrigger: Observable<Void>)
    func set(toggleReadTrigger: Observable<Void>)
}

struct BookViewModelImpl {
    let disposeBag = DisposeBag()
    let _book: Variable<Book>
    let booksService: BooksService
    var book: Driver<Book> {
        return _book.asDriver()
    }
    
    init(book: Book, booksService: BooksService) {
        self._book = Variable(book)
        self.booksService = booksService
    }
}

extension BookViewModelImpl: BookViewModel {
    func set(toggleInShelfTrigger: Observable<Void>) {
        toggleInShelfTrigger
            .map({ self._book.value })
            .flatMap({ [booksService] book -> Observable<Book> in
                return (book.isInShelf ?
                        booksService.delete(book: book) :
                        booksService.add(book: book))
            })
            .subscribe(onNext: { self._book.value = $0 })
            .disposed(by: disposeBag)
    }
    
    func set(toggleReadTrigger: Observable<Void>) {
        toggleReadTrigger
            .map({ self._book.value })
            .flatMap({ [booksService] book -> Observable<Book> in
                booksService.markAsRead(book: book, isRead: !book.isRead)
            })
            .subscribe(onNext: { self._book.value = $0 })
            .disposed(by: disposeBag)
    }
}
