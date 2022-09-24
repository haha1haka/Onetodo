//
//  ToDoRepository.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//

import Foundation
import RealmSwift

protocol ToDoDataBaseRepository {
    func create(_ toDo: ToDo)
    func fetch() -> Results<ToDo>
}

class ToDoRepository: ToDoDataBaseRepository {
    
    let database = try! Realm()
    
    

    
    // MARK: - CRUD
    //-  Create
    func create(_ toDo: ToDo) {
        do {
            try database.write {
                database.add(toDo)
            }
        } catch let error {
            print(error)
        }
    }
    
    

//    //- update(핀 토글)
//    func updatePin(updateObject: Memo, isFiexd: Bool) {
//        try! localRealm.write {
//            updateObject.isFixed = isFiexd
//        }
//    }
    //- update(게시글 수정)

    func update(_ toDo: ToDo, content: String, date: Date, completed: Bool) {
        do {
            try database.write {
                toDo.content = content
                toDo.date = date
                toDo.completed = completed
            }
        } catch let error {
            print(error)
        }

    }
    
    
    
    
    
    
    
    
    // MARK: - 패치
    
    func fetch() -> Results<ToDo> {
        return database.objects(ToDo.self)
    }
    
    
    func filterMonth(currentMonth: Month) -> Results<ToDo> {
        print("🟥\(currentMonth.rawValue)")
        return database.objects(ToDo.self).filter("dateMonth == '\(currentMonth.rawValue)'")
    }
    //func filterYear(currentYear: )
    func filterWeek(currentMonth: Month, currnetWeek: SectionWeek) -> Results<ToDo> {
        return filterMonth(currentMonth: currentMonth).filter("dateWeek == '\(currnetWeek.rawValue)'")
    }
    
    func filterTodoDay(object: ToDo, currentMonth: Month, currentToday: Int) -> Results<ToDo> {
        return filterMonth(currentMonth: currentMonth).filter("dateToday == '\(currentToday)'")
    }
    
    
    
    
//    func fistWeek(currenMonth: Month) -> Results<ToDo> {
//        return filterMonth(currentMonth: currenMonth).filter(<#T##isIncluded: (ToDo) -> Bool##(ToDo) -> Bool#>)
//    }
    
    
//    func makeNumberOfWeeksPerMonth(month: Int)  {
//        let pointDateComponent = DateComponents( year: 2022, month: month)
//        let calendar2 = Calendar.current
//        let hateDay = calendar2.date(from: pointDateComponent)
//        
//        let calendar = Calendar.current
//        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: hateDay!)
//        for i in weekRange! {
//            a.append(String(i) + "주")
//        }
//    }
    
//    //- 패치필터(고정,비고정)
//    func fetchFilter(in object: Results<Memo>, isFixed: Bool) -> Results<Memo> {
//        return object.filter("isFixed == \(isFixed)").sorted(byKeyPath: "date", ascending: false)
//    }
//
//
//    //- 패치필터(검색)
//    func fetchFilterSearchedText(in object: Results<Memo>, text: String) -> Results<Memo> {
//        return object.filter("content  CONTAINS[c] '\(text)' OR title CONTAINS[c]  '\(text)'").sorted(byKeyPath: "date", ascending: false)
//    }
    
    
}
