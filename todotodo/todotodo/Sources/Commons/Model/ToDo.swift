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
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var completed: Bool
    @Persisted var priority: Bool
    @Persisted var labelColor: String
    @Persisted var backgroundColor: String

    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, date: Date, completed: Bool, priority: Bool, labelColor: String, backgroundColor: String) {
        self.init()
        self.title = title
        self.date = date
        self.completed = completed
        self.priority = priority // 보통
        self.labelColor = labelColor
        self.backgroundColor = backgroundColor
    }
}




