//
//  DidSelectPanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import RealmSwift

class MainPanelViewController: BaseViewController {
    
    let mainPanelView = MainPanelView()
    override func loadView() {
        self.view = mainPanelView
    }
    
    let repository = ToDoRepository()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, ToDo>!
    
    var today = Date()
    
    var coreItem: [ToDo] {
        return repository.fetch().filter("priority == true").toArray()
    }
    
    var generalItem: [ToDo] {
        return repository.fetch().filter("priority == false").toArray()
    }
    
    override func configure() {
        registerSectionHeaderView()
        
    }
}

extension MainPanelViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionViewDataSource()
        applySnapShot()
    }

}



// MARK: - HeaderRegister, DataSource, applySnapShot Methods
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
            cell.label.textColor = UIColor(hex: itemIdentifier.labelColor)
            cell.backgroundColor = UIColor(hex: itemIdentifier.backgroundColor)
            
            if itemIdentifier.completed {
                cell.label.attributedText = itemIdentifier.title.strikeThrough()
                cell.backgroundColor = ColorType.completeColorSet //???????????????????????????
                //?????? todayPanel ?????? ????????? strike ???, backgroundColor ?????? ?????????
            }
            return cell
        }
        
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
        //.width?????? ????????? ??????
        snapshot.deleteAllItems()
        snapshot.deleteSections([""])
        if !snapshot.sectionIdentifiers.contains("?????? ??????") {
            snapshot.appendSections(["?????? ??????"])
        }
        //.width????????? ?????? todo ??? ??????.
        snapshot.appendItems(repository.filteringToday(today: today), toSection: "?????? ??????")
        collectionViewDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    
    
    func fullScreenSnapShot() {
        //datasource ??? ?????? ?????? ????????? ??????
        var snapshot = collectionViewDataSource.snapshot()
        for item in collectionViewDataSource.snapshot(for: "?????? ??????").items {
            
            snapshot.deleteItems([item])
            
            if snapshot.itemIdentifiers(inSection: "?????? ??????").isEmpty {
                snapshot.deleteSections(["?????? ??????"])
            }
            
            if item.priority {
                if !snapshot.sectionIdentifiers.contains("?????? todo") {
                    snapshot.appendSections(["?????? todo"])
                }
                snapshot.appendItems([item], toSection: "?????? todo")
            } else {
                if !snapshot.sectionIdentifiers.contains("?????? todo") {
                    snapshot.appendSections(["?????? todo"])
                }
                snapshot.appendItems([item], toSection: "?????? todo")
            }
            
        }
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }

}
