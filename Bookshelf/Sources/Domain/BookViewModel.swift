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
    var book: Variable<Book> { get }
    init(book: Book)
}

struct BookViewModelImpl: BookViewModel {
    let book: Variable<Book>
    
    init(book: Book) {
        self.book = Variable(book)
    }
}
