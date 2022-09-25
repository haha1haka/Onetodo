//
//  Schema.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//

import Foundation
import RealmSwift

enum Month:Int, CaseIterable {
    case jan = 1, feb, mar, apr,
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


class ToDo: Object {
    @Persisted var content: String
    @Persisted var date: Date
    @Persisted var dateMonth: String
    @Persisted var dateWeek: String
    @Persisted var dateToday: String
    //@Persisted var date: String
    @Persisted var completed: Bool
    @Persisted var priority: Int
    @Persisted var labelColor: String
    @Persisted var backgroundColor: String

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(content: String, date: Date, dateMonth: String, dateWeek: String, dateToday: String, completed: Bool, priority: Int, labelColor: String, backgroundColor: String) {
        self.init()
        self.content = content
        self.date = date
        self.dateMonth = dateMonth
        self.dateWeek = dateWeek
        self.dateToday = dateToday
        self.completed = false
        self.priority = priority
        self.labelColor = labelColor
        self.backgroundColor = backgroundColor
    }
}




