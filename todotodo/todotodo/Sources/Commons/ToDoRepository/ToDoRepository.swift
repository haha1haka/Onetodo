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

    func create(_ toDo: ToDo) {
        do {
            try database.write {
                database.add(toDo)
            }
        } catch let error {
            print(error)
        }
    }
    
    func update(_ toDo: ToDo, title: String, date: Date, completed: Bool) {
        do {
            try database.write {
                toDo.title = title
                toDo.date = date
                toDo.completed = completed
            }
        } catch let error {
            print(error)
        }

    }
//    var monthFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "M"
//        return formatter
//    }()
//    
//    var weekFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "w"
//        return formatter
//    }
//    var todayformatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "d"
//        return formatter
//    }



            
        

    
    
//    func updateTodo() {
//        let list = self.fetchTodo()
//        let todoList = list.filter {
//            // 완료했거나 날짜가 지난 todo들 중 현재와 todo의 day가 다르고 고정하지 않은 todo를 걸러낸다
//            ($0.completed == true || $0.todoAt ?? Date() < Date()) && $0.createdAt?.day ?? 0 != Date().day && !$0.fix
//        }
//        todoList.forEach { element in
//            persistentContainer.viewContext.delete(element)
//        }
//        list.forEach { element in
//            if element.todoAt ?? Date() < Date() , element.createdAt?.day ?? 0 != Date().day {
//                if element.fix , element.completed {
//                    element.completed.toggle()
//                }
//            }
//        }
//        saveContext()
//    }
    
    
    // MARK: - 패치
    
    func fetch() -> Results<ToDo> {
        return database.objects(ToDo.self)
    }
    func filteringMonth(currentMonth: Month) -> [ToDo] {
        let list = self.fetch().toArray()
        //print("⚠️⚠️⚠️⚠️⚠️⚠️\(list)")
        let monthList = list.filter {
            $0.date.month == String(currentMonth.rawValue)
        }
        //print("♥️♥️♥️♥️\(monthList)")
        return monthList
    }
    func filteringWeek(currentMonth: Month, currentWeek: SectionWeek) -> [ToDo] {
        let list = self.filteringMonth(currentMonth: currentMonth)
        let weekList = list.filter {
            $0.date.week == String(currentWeek.rawValue)
        }
        return weekList
    }
    

//    func filterMonth(currentMonth: Month) -> Results<ToDo> {
//        return database.objects(ToDo.self).filter("dateMonth == '\(currentMonth.rawValue)'")
//    }
//
//    func filterWeek(currentMonth: Month, currnetWeek: SectionWeek) -> Results<ToDo> {
//        return filterMonth(currentMonth: currentMonth).filter("dateWeek == '\(currnetWeek.rawValue)'")
//    }
//
//    func filterTodoDay(object: ToDo, currentMonth: Month, currentToday: Int) -> Results<ToDo> {
//        return filterMonth(currentMonth: currentMonth).filter("dateToday == '\(currentToday)'")
//    }
}
