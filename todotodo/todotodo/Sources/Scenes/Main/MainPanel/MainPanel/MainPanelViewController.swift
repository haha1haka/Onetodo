//
//  DidSelectPanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import RealmSwift

extension Int {
    func toString() -> String {
        return String(self) + " 순위"
    }
}
enum TodaySection {
    case widthScroll
    case heightScroll
    
    var title: String {
        switch self {
        case .widthScroll: return "오늘의 주요사항"
        case .heightScroll: return "펼쳐보기"
        }
    }
}

struct Section22: Hashable {

    var name: String = ""

    static let width: Section22 = .init(name: "오늘의 주요사항")

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}


struct TodayItem: Hashable {
    var name: String
    var color: UIColor
    var length: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}



class MainPanelViewController: BaseViewController {
    let repository = ToDoRepository()
    let mainPanelView = MainPanelView()
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, ToDo>!
    //var sections = TodoStatus.allSections
    
    var today = Date().day
    override func loadView() {
        self.view = mainPanelView
    }
    
    var todayToDo: Results<ToDo> {//⭐️priority 설정 화면 넣고, 해당 prioroty에 따라서 ToDo초기화 -> 램에 넣고 난후
        //이곳에서 prorot 높은 순으로 배열 만들기 --> .sorted(byKeyPath: "date", ascending: false)
        return repository.fetch().filter("dateToday == '\(today)'")
    }
    
    var sectionTitle: Int = 0
    var radomNumber = Int.random(in: 1...10000)
    
    override func configure() {
        mainPanelView.backgroundColor = .red
        registerSectionHeaderView()
        configureCollectionViewDataSource()
        loadInitialData()
        
        
    }
}
extension MainPanelViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadInitialData()
        //fullScreenSnapShot()
        print("업데이트됨")
    }
}




// MARK: - HeaderRegister, DataSource, applySnapShot Methods
extension MainPanelViewController {
    
    func registerSectionHeaderView() {
        mainPanelView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<MainPanelCell,ToDo> { cell,  indexPath, itemIdentifier in
            cell.configureCell(item: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: mainPanelView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.backgroundColor = .random
            return cell
        }
        // 2️⃣ Header
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>.init( elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier.toString()
        }
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })
    }
    
    
    func loadInitialData() {
        var snapshot = collectionViewDataSource.snapshot()
        //.width섹션 없으면 추가
        if !snapshot.sectionIdentifiers.contains(0) {
            snapshot.appendSections([0])
        }
        //.width섹션에 오늘 todo 만 넣기.
        snapshot.appendItems(todayToDo.toArray(), toSection: 0)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }


    
    func fullScreenSnapShot() {
        //datasource 에 오늘 메모 들어가 있음
        for (index, item) in collectionViewDataSource.snapshot(for: 0).items.enumerated() {
            //DispatchQueue.global().async {
            //해당 메모만큼 섹션 만들기 위해
            sectionTitle = index
            //datasource 에 오늘 메모 들어가 있음
            var snapShot = self.collectionViewDataSource.snapshot()
            //모두 지우기
            snapShot.deleteItems([item])
            
            //섹션 아이템 모두 없어졌으면 지우기
            if snapShot.itemIdentifiers(inSection: 0).isEmpty {
                snapShot.deleteSections([0])
            }
            
            //넣을려는 섹션이 없으면 섹션 추가
            if !snapShot.sectionIdentifiers.contains(sectionTitle) {
                snapShot.appendSections([sectionTitle])
            }
            
            snapShot.appendItems([item], toSection: sectionTitle)
            self.collectionViewDataSource.apply(snapShot, animatingDifferences: true, completion: nil)
            
            
        }
        
        
        //}
    }
    
//    func halfScreenSnapShot() {
//        var snapshot = collectionViewDataSource.snapshot()
//        snapShot.deleteSections([sectionTitle])
//        snapshot.deleteItems(todayToDo.toArray())
//        snapshot.appendItems(todayToDo.toArray(), toSection: .width)
//        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
//
//
//
//
//
//    }
    
    
    
    
    
}
