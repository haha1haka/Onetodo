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
    
    var coreItem: [ToDo] {
        return repository.fetch().filter("priority == true").toArray()
    }
    var generalItem: [ToDo] {
        return repository.fetch().filter("priority == false").toArray()
    }
    
    override func configure() {
        //mainPanelView.backgroundColor = .red
        registerSectionHeaderView()
        configureCollectionViewDataSource()
    }
}

extension MainPanelViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapShot()
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setBlur()
//    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setBlur()
    }
    
    
    
    func setBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = mainPanelView.bounds
        self.view.addSubview(blurEffectView)
        
        self.view.sendSubviewToBack(blurEffectView)
        
        
        blurEffectView.layer.cornerRadius = 35
        blurEffectView.clipsToBounds = true
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
        var snapshot = collectionViewDataSource.snapshot()
        for item in collectionViewDataSource.snapshot(for: "오늘 확인").items {
            
            
            
            snapshot.deleteItems([item])
            
            if snapshot.itemIdentifiers(inSection: "오늘 확인").isEmpty {
                snapshot.deleteSections(["오늘 확인"])
            }
            
            
            if item.priority {
                if !snapshot.sectionIdentifiers.contains("중요 todo") {
                    snapshot.appendSections(["중요 todo"])
                }
                snapshot.appendItems([item], toSection: "중요 todo")
            } else {
                if !snapshot.sectionIdentifiers.contains("일반 todo") {
                    snapshot.appendSections(["일반 todo"])
                }
                snapshot.appendItems([item], toSection: "일반 todo")
            }
            
        }
        collectionViewDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    

    
    
}
