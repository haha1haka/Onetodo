//
//  Date.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/21.
//

import Foundation

extension Date {
    var year: String {
        return String(Calendar.current.component(.year, from: self))
    }
    
    var month: String {
        return String(Calendar.current.component(.month, from: self))
    }
    
    var week: String {
        return String(Calendar.current.component(.weekOfMonth, from: self))
    }
    
    var day: String {
        return String(Calendar.current.component(.day, from: self))
    }
    
    var hour: String {
        return String(Calendar.current.component(.hour, from: self))
    }
    
    var minute: String {
        return String(Calendar.current.component(.minute, from: self))
    }
}
