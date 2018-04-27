//
//  URL+Rx.swift
//  Bookshelf
//
//  Created by Mario on 27/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension URL {
    var remoteImage: Observable<UIImage> {
        return Observable<UIImage>.create({ (observer) -> Disposable in
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: self), let image = UIImage(data: data) else {
                    observer.onCompleted()
                    return
                }
                observer.onNext(image)
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
}
