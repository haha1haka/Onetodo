//
//  Schema.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//

import Foundation
import RealmSwift


enum Month: CaseIterable {
    case jan, feb, mar, apr,
         may, jun, jul, aug,
         sep, oct, nov, dec
    
    var title: String {
        switch self {
        case .jan: return "1월"
        case .feb: return "2월"
        case .mar: return "3월"
        case .apr: return "4월"
        case .may: return "5월"
        case .jun: return "6월"
        case .jul: return "7월"
        case .aug: return "8월"
        case .sep: return "9월"
        case .oct: return "10월"
        case .nov: return "11월"
        case .dec: return "12월"
        }
    }
    
}
//struct SectionWeek: Hashable {
//    var title: String
//}
enum SectionWeek: CaseIterable {
    case week1, week2, week3, week4, week5, week6, week7
    
    var title: String {
        switch self {
        case .week1:
            return "1주차"
        case .week2:
            return "2주차"
        case .week3:
            return "3주차"
        case .week4:
            return "4주차"
        case .week5:
            return "5주차"
        case .week6:
            return "6주차"
        case .week7:
            return "7주차"
        }
    }
}

class ToDo: Object {
    @Persisted var content: String
    @Persisted var date: Date
    @Persisted var dateString: String
    @Persisted var completed: Bool
    @Persisted var priority: Int

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(content: String, date: Date, dateString: String, completed: Bool, priority: Int) {
        self.init()
        self.content = content
        self.date = date
        self.dateString = dateString
        self.completed = false
        self.priority = priority
    }
}




