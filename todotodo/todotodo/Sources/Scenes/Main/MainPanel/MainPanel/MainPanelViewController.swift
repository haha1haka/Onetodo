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
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, ToDo>!
    
    var today = Date()

    var sectionTitle: String = ""
    
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
            cell.label.textColor = UIColor(hex: itemIdentifier.labelColor)
            cell.backgroundColor = UIColor(hex: itemIdentifier.backgroundColor)
            return cell
        }
        // 2️⃣ Header
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>.init( elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier.description
        }
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })
    }
    
    
    func applySnapShot() {
        var snapshot = collectionViewDataSource.snapshot()
        //.width섹션 없으면 추가
        snapshot.deleteAllItems()
        snapshot.deleteSections([""])
        if !snapshot.sectionIdentifiers.contains("오늘 확인") {
            snapshot.appendSections(["오늘 확인"])
        }
        //.width섹션에 오늘 todo 만 넣기.
        snapshot.appendItems(repository.filteringToday(today: today), toSection: "오늘 확인")
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }


    
    func fullScreenSnapShot() {
        //datasource 에 오늘 메모 들어가 있음
        for (index, item) in collectionViewDataSource.snapshot(for: "오늘 확인").items.enumerated() {

            var coreItem: ToDo?
            var genralItem: ToDo?
            var value = ""

            //해당 메모만큼 섹션 만들기 위해
            switch index {
            case 0:
                value = "중요도 높음"
            default :
                value = "중요도 보통"
            }
            
            sectionTitle = value
            
            //datasource 에 오늘 메모 들어가 있음
            var snapShot = self.collectionViewDataSource.snapshot()
            
            //모두 지우기
            snapShot.deleteItems([item])
            
            //섹션 아이템 모두 없어졌으면 지우기
            if snapShot.itemIdentifiers(inSection: "오늘 확인").isEmpty {
                snapShot.deleteSections(["오늘 확인"])
            }
            
            //넣을려는 섹션이 없으면 섹션 추가
            if !snapShot.sectionIdentifiers.contains(sectionTitle) {
                snapShot.appendSections([sectionTitle])
            }
            print("🥎\(item.priority) - \(item.title)")
            if item.priority {
                coreItem = item
                snapShot.appendItems([coreItem!], toSection: "중요도 높음")
            } else {
                genralItem = item
                snapShot.appendItems([genralItem!], toSection: "중요도 보통")
            }
            
            self.collectionViewDataSource.apply(snapShot, animatingDifferences: true, completion: nil)
            
            
        }
        
        
        
    }
    

    
    
    
    
    
}
