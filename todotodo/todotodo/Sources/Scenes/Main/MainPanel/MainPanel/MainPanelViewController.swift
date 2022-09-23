//
//  DidSelectPanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import RealmSwift


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
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section22, ToDo>!
    //var sections = TodoStatus.allSections
    
    var today = Date().day
    override func loadView() {
        self.view = mainPanelView
    }
    
    var todayToDo: Results<ToDo> {
        return repository.fetch().filter("dateToday == '\(today)'")
    }
    
    var sectionTitle = Section22()
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
            supplementaryView.titleLabel.text = sectionIdentifier.name
        }
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })
    }
    
    
    func loadInitialData() {
        var snapshot = collectionViewDataSource.snapshot()
        //.width섹션 없으면 추가
        if !snapshot.sectionIdentifiers.contains(.width) {
            snapshot.appendSections([.width])
        }
        //.width섹션에 오늘 todo 만 넣기.
        snapshot.appendItems(todayToDo.toArray(), toSection: .width)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }


    
    func fullScreenSnapShot() {
        //datasource 에 오늘 메모 들어가 있음
        for item in collectionViewDataSource.snapshot(for: .width).items {
            //DispatchQueue.global().async {
            //해당 메모만큼 섹션 만들기 위해
            sectionTitle = Section22(name: "\(Int.random(in: 1...1000))")
            //datasource 에 오늘 메모 들어가 있음
            var snapShot = self.collectionViewDataSource.snapshot()
            //모두 지우기
            snapShot.deleteItems([item])
            
            //섹션 아이템 모두 없어졌으면 지우기
            if snapShot.itemIdentifiers(inSection: .width).isEmpty {
                snapShot.deleteSections([.width])
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
    
    func halfCurrentSnapShot() {
        var snapshot = collectionViewDataSource.snapshot()
//        if !snapshot.sectionIdentifiers.contains(.width) {
//            snapshot.appendSections([.width])
//        }
        //snapshot.deleteSections(<#T##identifiers: [Section22]##[Section22]#>)
        snapshot.deleteItems(todayToDo.toArray())
        snapshot.appendItems(todayToDo.toArray(), toSection: .width)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        

        

    }
    
    
    
    
    
}
