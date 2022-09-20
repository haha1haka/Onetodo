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
    //- 패치(날짜별로)
    func fetch() -> Results<ToDo> {
        return database.objects(ToDo.self)
        //.sorted(byKeyPath: "date", ascending: false)
    }
    
    
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
