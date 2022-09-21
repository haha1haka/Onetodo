
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel
import RealmSwift

enum Section2 {
    case main
}

struct Itme2: Hashable {
    var title: String
}
enum WWWWWWW {
    case first
    case second
    case third
    case fourth
    case fifth
    case sixth
    
//    var fetch:
    
}
struct SomeWeek {
    var section: SectionWeek
    var item: Results<ToDo>
}


class PageViewController: BaseViewController {
    
    let pageView = PageView()
    override func loadView() {
        self.view = pageView
    }
    
    let repository = ToDoRepository()
    
    let fpc = FloatingPanelController()
    let contentVC = WriteViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ToDo>!
    var contentConfiguration: UIListContentConfiguration!
    
    var SectionDataStore = SectionWeek.allCases.map { $0.title }
    var sectionArray = SectionWeek.allCases.map { $0 } //[]
    var isSelectedMonth: Month? //ex 3월 --> march
    var weekStatus: SectionWeek? = .week5
    var a: [String] = []
    
    var todoList: Results<ToDo> {
        return repository.fetch()
    }
    
    //var isSelectedMonth: Month!
    var index = 0
    
    
    var firstWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week1)
    }
    var secondWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week2)
    }
    var thirdWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week3)
    }
    var fourthWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week4)
    }
    var fiveWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week5)
    }
    var sixWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week6)
    }
    
    
    var weekList: [Results<ToDo>] = []
    var dd: [SomeWeek] = []
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }
    
    
    
    override func configure() {
        pageView.collectionView.delegate = self
        print("df")
        registerSectionHeaterView()
        configureCollectionViewDataSource()
        applyInitialSnapShot()
        weekList = [firstWeek, secondWeek, thirdWeek, fourthWeek, fiveWeek, sixWeek]
        dd = [
            SomeWeek(section: .week1, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week1)),
        SomeWeek(section: .week2, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week2)),
        SomeWeek(section: .week3, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week3)),
        SomeWeek(section: .week4, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week4)),
        SomeWeek(section: .week5, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week5)),
        SomeWeek(section: .week6, item: repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week6))
        ]
        
        //print("🟪\(dataStore)")
//        for i in
    }
    
}


extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("♥️♥️♥️\(todoList)")
        //print("✅✅✅\(isSelectedMonth)")
        //updateSnapShot(month: isSelectedMonth!)
        configureSnapShot(month: isSelectedMonth!)
    }
}


// MARK: - DataSource, applySnapShot
extension PageViewController {
    
    //헤더뷰2🥹
    func registerSectionHeaterView() {
        pageView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        
        // 1️⃣ Cell
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,ToDo> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = itemIdentifier.content
            contentConfiguration.secondaryText = itemIdentifier.date.formatted()
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
        }
        
        
        
        //        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,ToDo> { cell,  indexPath, itemIdentifier in
        //
        //            print("\(itemIdentifier.content)")
        //
        //            self.contentConfiguration = cell.defaultContentConfiguration()
        //            self.contentConfiguration.text = itemIdentifier.content
        //            self.contentConfiguration.text = "dfsdfs"
        //            self.contentConfiguration.attributedText = nil
        //            self.contentConfiguration.secondaryText = self.dateFormatter.string(from: itemIdentifier.date)
        //            self.contentConfiguration.secondaryTextProperties.color = .secondaryLabel
        ////            self.contentConfiguration.backgroundColor = .red
        //            //self.contentConfiguration = self.contentConfiguration
        //
        //
        //        }
        
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.backgroundView?.backgroundColor = .red
            cell.backgroundColor = .red
            return cell
        }
        
        
        
        // 2️⃣ Header
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }
    }
    
    
    func applyInitialSnapShot() {
        //guard let array = todoList else { return  print("안됨")}
        
        //var a = array.toArray()
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections([.week1])
        snapshot.appendItems(repository.fetch().toArray())
        collectionViewDataSource.apply(snapshot)
    }
    
    
    //    func updateSnapShot(month: Month) {
    //        var newSnapshot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
    //        newSnapshot.deleteItems(repository.fetch().toArray())
    //
    //
    //
    //
    //        newSnapshot.appendSections([month])
    //        newSnapshot.appendItems(repository.fetch().toArray())
    //        collectionViewDataSource.apply(newSnapshot)
    //    }
    
//    func aa() {
//        dd.forEach {
//            switch $0
//        }
//    }

    
    func weekChnage(currentWeek: SectionWeek) {
        let allData = repository.fetch()
        var array: [SomeWeek] = []
        let week1 = SomeWeek(section: .week1, item: allData.filter("dateWeek == 1"))
        let week2 = SomeWeek(section: .week2, item: allData.filter("dateWeek == 2"))
        let week3 = SomeWeek(section: .week3, item: allData.filter("dateWeek == 3"))
        let week4 = SomeWeek(section: .week4, item: allData.filter("dateWeek == 4"))
        let week5 = SomeWeek(section: .week5, item: allData.filter("dateWeek == 5"))
        let week6 = SomeWeek(section: .week6, item: allData.filter("dateWeek == 6"))
        
        //[week1, week2, week3, week4, week5, week6].forEach(<#T##body: (SomeWeek) throws -> Void##(SomeWeek) throws -> Void#>)
        
        
        
        
//        allData.forEach { todo in
//            
//            switch todo.dateWeek {
//            case 0:
//            }
//            
//            todo.dateWeek == .first {
//                let a: SomeWeek = SomeWeek(section: .week1, item: <#T##Results<ToDo>#>)
//                array.append(a)
//            }
//            
//        }
    }
    
    func configureSnapShot(month: Month) {
        var newSnapshot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
        print(month)
        print(repository.database.configuration.fileURL!)
        index = -1
        weekList.forEach { currentWeek in
            index += 1
            if !currentWeek.isEmpty {
                newSnapshot.deleteItems(repository.fetch().toArray())
                newSnapshot.appendSections([sectionArray[index]])
                newSnapshot.appendItems(repository.filterMonth(currentMonth: month).toArray(), toSection: sectionArray[index])
            }
            collectionViewDataSource.apply(newSnapshot, animatingDifferences: true)
        }
        
        
        
//        SectionWeek.allCases.forEach { currentWeek in
//            print(judgeItemInSection(sectionWeek: currentWeek), currentWeek)
//            print()
//            if judgeItemInSection(sectionWeek: currentWeek) {
//
//
//            }
//
//        }
        collectionViewDataSource.apply(newSnapshot, animatingDifferences: true)
    }
    
    
    func judgeItemInSection(sectionWeek: SectionWeek) -> Bool {
        //var newSnapshot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
        var flag = collectionViewDataSource.snapshot(for: sectionWeek)
        if !flag.items.isEmpty {
            return true
        }
        return false
    }
    
//    func playSnapShot() {
//        var newSnapshot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
//        SectionWeek.allCases.forEach {
//            if newSnapshot.i
//            newSnapshot.appendSections($0.rawValue)
//        }
//
//
//    }

    
    
    
}




// MARK: - CollectionViewDelegate
extension PageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fpc.set(contentViewController: contentVC)
        fpc.layout = MyFloatingPanelLayout2()
        fpc.isRemovalInteractionEnabled = true
        fpc.delegate = self
        fpc.changePanelStyle()
        fpc.behavior = MyFloatingPanelBehavior()
        self.present(fpc, animated: true, completion: nil)
    }
}




// MARK: - FloatingPanelControllerDelegate
extension PageViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        print("\(fpc.surfaceLocation.y)")
        print("\(fpc.surfaceLocation(for: .tip).y)")
        if fpc.surfaceLocation.y >= fpc.surfaceLocation(for: .tip).y - 100 {
            print("🟧🟧🟧🟧🟧🟧🟧")
            contentVC.dismiss(animated: true)
        }
    }
}








//extension PageViewController {
//
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
//
//}

