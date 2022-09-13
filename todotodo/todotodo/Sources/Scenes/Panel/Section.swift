//
//  Section.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import Foundation

class Section: Hashable {
    var id = UUID()
    // 2
    var title: String
    var todos: [ToDo]
    
    init(title: String, todos: [ToDo]) {
        self.title = title
        self.todos = todos
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}


extension Section {
  static var allSections: [Section] = [Section(title: "월요일", todos: [ToDo(dateTitleLabel: "잠자기", contentLabel: "fdfd")]),
                                      Section(title: "화요일", todos: [ToDo(dateTitleLabel: "전화하기", contentLabel: "sdfdsfsd")]),
                                      Section(title: "수요일", todos: [ToDo(dateTitleLabel: "휴식1", contentLabel: "fdsfdsfds")]),
                                      Section(title: "목요일", todos: [ToDo(dateTitleLabel: "휴식2", contentLabel: "sdfdsfdsf")]),
                                      Section(title: "금요일", todos: [ToDo(dateTitleLabel: "놀기", contentLabel: "sdfdsfdsf")]),
                                      Section(title: "토요일", todos: [ToDo(dateTitleLabel: "자전거 타기", contentLabel: "fffㄹㅇㄹㅇ너륑ㄴㄹㅇㄴ")]),
                                      Section(title: "일요일", todos: [ToDo(dateTitleLabel: "코딩하기", contentLabel: "fㄹㅇㄹㅇ너륑ㄴㄹㅇ")])]
}
