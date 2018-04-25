//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by Mario on 24/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let searchInput = Observable.just("masters of doom")
//        let searchService = SearchService(searchInput: searchInput)
//        searchService.searchOutput
//            .subscribe({ print($0) })
//            .disposed(by: disposeBag)
        
        let book = Book(
            id: "5ae083094d9d070010b361f4",
            title: "Libro 1",
            authors: ["Mario Negro", "Lucas Perez"],
            description: "Un libro",
            publisher: "Random House",
            publishedDate: "21-01-1982",
            coverImageUrl: nil,
            isRead: true
        )
        let booksListInput = Observable<Void>.just(())
        let booksAddInput = Observable.just(book)
        let booksMarkAsReadInput = Observable.just(book)
        let booksDeleteInput = Observable.just(book)
        let booksService = BooksService(listInput: booksListInput,
                                        addInput: booksAddInput,
                                        markAsReadInput: booksMarkAsReadInput,
                                        deleteInput: booksDeleteInput)
        booksService.listOutput
            .subscribe({ print($0) })
            .disposed(by: disposeBag)
//        booksService.addOutput
//            .subscribe({ print($0) })
//            .disposed(by: disposeBag)
//        booksService.markAsReadOutput
//            .subscribe({ print($0) })
//            .disposed(by: disposeBag)
//        booksService.deleteOutput
//            .subscribe({ print($0) })
//            .disposed(by: disposeBag)
        
        return true
    }
}

