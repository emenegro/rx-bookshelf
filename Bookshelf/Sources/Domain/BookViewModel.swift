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
    // Inputs
    var addBook: PublishSubject<Void> { get }
    var removeBook: PublishSubject<Void> { get }
    var markRead: PublishSubject<Void> { get }
    var markUnread: PublishSubject<Void> { get }
    // Outputs
    var book: Observable<Book> { get }
}

struct BookViewModelImpl: BookViewModel {
    let bookVariable: Variable<Book>
    let addBook = PublishSubject<Void>()
    let removeBook = PublishSubject<Void>()
    let markRead = PublishSubject<Void>()
    let markUnread = PublishSubject<Void>()
    let book: Observable<Book>
    
    init(book: Book, booksService: BooksService) {
        self.bookVariable = Variable(book)
        
        let addResult = addBook
            .mapBookFrom(bookVariable)
            .flatMapLatest({ booksService.add(book: $0) })
            .updateBookVariable(bookVariable)

        let removeResult = removeBook
            .mapBookFrom(bookVariable)
            .flatMapLatest({ booksService.delete(book: $0) })
            .updateBookVariable(bookVariable)
        
        let markReadResult = markRead
            .mapBookFrom(bookVariable)
            .flatMapLatest({ booksService.markAsRead(book: $0, isRead: true) })
            .updateBookVariable(bookVariable)
        
        let markUnreadResult = markUnread
            .mapBookFrom(bookVariable)
            .flatMapLatest({ booksService.markAsRead(book: $0, isRead: false) })
            .updateBookVariable(bookVariable)
        
        self.book = Observable.of(addResult, removeResult, markReadResult, markUnreadResult).merge()
            .startWith(book)
    }
}

private extension ObservableType where E == Void {
    func mapBookFrom(_ variable: Variable<Book>) -> Observable<Book> {
        return map({ _ in return variable.value })
    }
}

private extension ObservableType where E == Book {
    func updateBookVariable(_ variable: Variable<Book>) -> Observable<Book> {
        return self.do(onNext: { variable.value = $0 })
    }
}
