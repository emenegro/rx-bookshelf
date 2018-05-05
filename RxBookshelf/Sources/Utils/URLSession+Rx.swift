//
//  URLSession+Rx.swift
//  RxBookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E == URLRequest {
    func executeIn(_ networkSession: @autoclosure @escaping () -> URLSession) -> Observable<Data> {
        return flatMapLatest({ request -> Observable<Data> in
            networkSession().rx.data(request: request)
        })
    }
}
