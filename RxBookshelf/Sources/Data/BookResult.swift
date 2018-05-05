//
//  BookResult.swift
//  RxBookshelf
//
//  Created by Mario on 4/5/18.
//  Copyright © 2018 Mario Negro. All rights reserved.
//

import RxSwift

enum BookResult<T> {
    case success(T)
    case error(Error, cached: T?)
}
