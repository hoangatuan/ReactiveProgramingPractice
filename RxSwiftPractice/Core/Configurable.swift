//
//  Configurable.swift
//  RxSwiftPractice
//
//  Created by Tuan Hoang on 03/01/2023.
//

import Foundation

public protocol Configurable {}

extension NSObject: Configurable {}

public extension Configurable where Self: AnyObject {

    @discardableResult
    func configure(_ transform: (Self) -> Void) -> Self {
        transform(self)
        return self
    }
}
