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


class MainPanelViewController: BaseViewController {
    
    let mainPanelView = MainPanelView()
    override func loadView() {
        self.view = mainPanelView
    }
    
    let repository = ToDoRepository()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Int, ToDo>!
    
    var today = Date()

    var sectionTitle: Int = 0
    
    override func configure() {
        mainPanelView.backgroundColor = .red
        registerSectionHeaderView()
        configureCollectionViewDataSource()
    }
}

extension MainPanelViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapShot()
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
    
    
    func applySnapShot() {
        var snapshot = collectionViewDataSource.snapshot()
        //.width섹션 없으면 추가
        snapshot.deleteAllItems()
        snapshot.deleteSections([0])
        if !snapshot.sectionIdentifiers.contains(0) {
            snapshot.appendSections([0])
        }
        //.width섹션에 오늘 todo 만 넣기.
        snapshot.appendItems(repository.filteringToday(today: today), toSection: 0)
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }


    
    func fullScreenSnapShot() {
        //datasource 에 오늘 메모 들어가 있음
        for (index, item) in collectionViewDataSource.snapshot(for: 0).items.enumerated() {
            
            //해당 메모만큼 섹션 만들기 위해
            sectionTitle = 1
            
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
