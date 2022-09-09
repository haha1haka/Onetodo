//
//  NSObject.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: Self.self)
    }
}
