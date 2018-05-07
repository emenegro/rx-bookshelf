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

extension BookResult: Equatable where T: Equatable {
    static func == (lhs: BookResult<T>, rhs: BookResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let l), .success(let r)):
            return l == r
        case (.error(let le, let lc), .error(let re, let rc)):
            return le.localizedDescription == re.localizedDescription && lc == rc
        default:
            return false
        }
    }
}
