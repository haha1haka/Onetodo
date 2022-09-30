//
//  Schema.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//

import UIKit
import RealmSwift

enum Month:Int, CaseIterable {
    case jan = 1, feb, mar, apr,
         may, jun, jul, aug,
         sep, oct, nov, dec
    
    var title: String {
        switch self {
        case .jan: return "January"
        case .feb: return "February"
        case .mar: return "March"
        case .apr: return "April"
        case .may: return "May"
        case .jun: return "June"
        case .jul: return "July"
        case .aug: return "August"
        case .sep: return "September"
        case .oct: return "October"
        case .nov: return "November"
        case .dec: return "December"
        }
    } 
    
}


enum SectionWeek:Int, CaseIterable {
    case week1 = 1, week2, week3, week4, week5, week6, week7
    
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





enum Type: String, CaseIterable {
case requiredSetting = "필수사항"
case colorSetting = "Color Setting"
}

class SettingSection: Hashable {
    var id = UUID()
    var headerText: String
    var footerText: String
    var settings: [Setting]
    
    init(headerText: String,footerText: String, settings: [Setting]) {
        self.headerText = headerText
        self.footerText = footerText
        self.settings = settings
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: SettingSection, rhs: SettingSection) -> Bool {
        lhs.id == rhs.id
    }
    
    static func makeData() -> [SettingSection] {
        let data = [SettingSection(headerText: "필수 입력사항",footerText: "우선순위 기본값은 보통 입니다", settings: [
            Setting(name: "calendar", type: .requiredSetting, title: "날짜선택",priority: false),
            Setting(name: "hand.thumbsup", type: .colorSetting, title: "중요도",priority: false),]
                                  ),
                    SettingSection(headerText: "옵션 사항",footerText: "중요한 이벤트에 색상을 지정해주세요", settings: [
                        Setting(name: "highlighter", type: .requiredSetting, title: "Lable color", priority: false),
                        Setting(name: "scribble.variable", type: .colorSetting, title: "Background color", priority: false)]
                                  )]
        return data
    }
}




class Setting: Hashable {
    var id = UUID()
    var name: String
    var title: String
    var image: UIImage
    var type: Type
    var priority: Bool
    
    init(name: String,type: Type, title: String, priority: Bool) {
        self.id = UUID()
        self.name = name //이미지 떄문
        self.title = title //
        self.image = UIImage(systemName: name)!
        self.type = type
        self.priority = false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        lhs.id == rhs.id
    }
}
