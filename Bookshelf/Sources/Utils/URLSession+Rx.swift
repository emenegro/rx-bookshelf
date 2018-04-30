//
//  URLSession+Rx.swift
//  Bookshelf
//
//  Created by Mario on 30/4/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E == URLRequest {
    func execute(in networkSession: URLSession) -> Observable<Data> {
        return flatMap({ request -> Observable<Data> in
            networkSession.rx.data(request: request)
        })
    }
}
