//
//  DidSelectPanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import RealmSwift

//struct TodaySection: Hashable {
//
//    var name: String
//
//    static let queue: TodaySection = .init(name: "Queue")
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//    }
//}
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

    static let width: Section22 = .init(name: "width")

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
    
    var today = Date()
    override func loadView() {
        self.view = mainPanelView
    }
    
    var todayToDo: Results<ToDo> {
        return repository.fetch().filter("dateToday == '\(today.day)'")
    }
    
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





extension MainPanelViewController {
    
    func registerSectionHeaderView() {
        mainPanelView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MainPanelCell,ToDo> { cell,  indexPath, itemIdentifier in
            cell.configureCell(item: itemIdentifier)
        }
        
        collectionViewDataSource = .init(collectionView: mainPanelView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.backgroundColor = .random
            return cell
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>.init(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [weak self] supplementaryView, elementKind, indexPath in

            guard let self = self,
                  let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }

            supplementaryView.titleLabel.text = sectionIdentifier.name
        }
        
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })



        //3
//        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
//
//            let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section)
//            //let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
//            view?.titleLabel.text = sectionIdentifier.title
//            return view
//        }


    }
    func loadInitialData() {
        var snapshot = collectionViewDataSource.snapshot()
        if !snapshot.sectionIdentifiers.contains(.width) {
            snapshot.appendSections([.width])
        }
        snapshot.appendItems(todayToDo.toArray(), toSection: .width)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }



    func fullScreenSnapShot() {
        
        for item in collectionViewDataSource.snapshot(for: .width).items {
            //DispatchQueue.global().async {
            
            let sectionTitle = Section22(name: "\(Int.random(in: 1...1000))")
            
                var snapShot = self.collectionViewDataSource.snapshot()
                snapShot.deleteItems([item])
            if snapShot.itemIdentifiers(inSection: .width).isEmpty {
                snapShot.deleteSections([.width])
                }
                //넣을려는 섹션이 없으면 섹샨 추가
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
        snapshot.deleteItems(todayToDo.toArray())
        snapshot.appendItems(todayToDo.toArray(), toSection: .width)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
    }
    
    
    
    
    
}
