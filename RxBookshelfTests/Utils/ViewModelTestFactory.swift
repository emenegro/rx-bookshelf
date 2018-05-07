//
//  ViewModelTestFactory.swift
//  RxBookshelfTests
//
//  Created by Mario on 7/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift
import RxTest

struct ViewModelTestFactory {
    let disposeBag: DisposeBag
    let scheduler: TestScheduler
    
    func observer<T, O>(binding subject: PublishSubject<T>,
                       toEvents events: [Recorded<Event<T>>],
                       toObserve observable: Observable<O>) -> TestableObserver<O> {
        
        let observer = scheduler.createObserver(O.self)
        
        scheduler
            .createHotObservable(events)
            .bind(to: subject)
            .disposed(by: disposeBag)
        
        observable
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        return observer
    }
}
