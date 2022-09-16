//
//  Section.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import Foundation
//class SectionWeek: Hashable {
//    var id = UUID()
//
//    var title: String
//    var days: [ItemDay]
//
//    init(title: String, days: [ItemDay]) {
//        self.title = title
//        self.days = days
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    static func == (lhs: SectionWeek, rhs: SectionWeek) -> Bool {
//        lhs.id == rhs.id
//    }
//}




struct SectionWeek: Hashable {
    var title: String
    var days: [ItemDay]
}

struct ItemDay: Hashable {
    var dateNumberLable: String
    var dateStringLable: String
    var contentLabel: [String]
}

extension SectionWeek {
  static var allSections: [SectionWeek] = [
    SectionWeek(title: "1 주차", days: [ItemDay(dateNumberLable: "7", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "8", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "9", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "10", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "11", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "12", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "13", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "2 주차", days: [ItemDay(dateNumberLable: "14", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "15", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "16", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "17", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "18", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "19", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "20", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "3 주차", days: [ItemDay(dateNumberLable: "21", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "22", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "23", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "24", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "25", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "26", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "27", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "4 주차", days: [ItemDay(dateNumberLable: "28", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "29", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "30", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "31", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "32", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "33", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "34", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "5 주차", days: [ItemDay(dateNumberLable: "35", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "36", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "37", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "38", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "39", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "40", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "41", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               )
    
  ]
}


