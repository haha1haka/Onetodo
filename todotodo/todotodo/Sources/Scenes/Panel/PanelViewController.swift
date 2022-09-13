//
//  PanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import UIKit
import SnapKit


class PanelViewController: BaseViewController {
    
    
    let panelView = PanelView()
    //var collectionReusableView = UICollectionReusableView()
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ToDo>!
    
    var sections = Section.allSections
    
    
//    var dummyToDo = [ToDo(dateTitleLabel: "8월 1주차(월)", contentLabel: "엄마한테 전화하기"),
//                     ToDo(dateTitleLabel: "8월 1주차(화)", contentLabel: "물마시기"),
//                     ToDo(dateTitleLabel: "8월 1주차(수)", contentLabel: "친구랑 놀기"),
//                     ToDo(dateTitleLabel: "8월 1주차(목)", contentLabel: "잘자기"),
//                     ToDo(dateTitleLabel: "8월 1주차(금)", contentLabel: "Floating Button 공부하기"),
//                     ToDo(dateTitleLabel: "8월 1주차(토)", contentLabel: "휴식"),
//                     ToDo(dateTitleLabel: "8월 1주차(일)", contentLabel: "휴식2")]
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ToDo>
    
    
    override func loadView() {
        self.view = panelView
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
        
        //        panelView.collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.identifier)
//        panelView.collectionView.register(<#T##viewClass: AnyClass?##AnyClass?#>, forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: <#T##String#>)
        panelView.collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.identifier)
    }
    
}




// MARK: - CollectionViewDiffableDataSource
extension PanelViewController {
    
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<PanelCell, ToDo> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        
        collectionViewDataSource = .init(collectionView: panelView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.panelView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        }
        
        
        
        
        
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            // 4
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            // 5            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            // 6
            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            
            return view
        }
        
        
        
        
        
    }
    

    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.todos, toSection: section)
        }
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.panelView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}






