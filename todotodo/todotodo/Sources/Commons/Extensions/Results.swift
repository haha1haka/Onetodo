//
//  Results.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/21.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [Element] {
        return compactMap {$0}
    }
    
}
