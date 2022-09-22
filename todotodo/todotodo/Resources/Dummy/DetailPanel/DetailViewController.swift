//
//  DetailViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//

import UIKit

//class DetailViewController: BaseViewController {
//    
//    let detailView = DetailView()
//    
//    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, Item>!
//    
////    var sections = SectionWeek.allSections
//
//    
//    override func loadView() {
//        self.view = detailView
//    }
//    
//    override func configure() {
//        configureCollectionViewDataSource()
//        
//        //applySnapshot()
//        
//        
//        
//        detailView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
//    }
//    
//    
//}
//extension DetailViewController {
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        print("사라짐")
//    }
//    
//    
//}
//
//extension DetailViewController {
//    
//    func configureCollectionViewDataSource() {
//        
//        //1
//        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> { cell,  indexPath, itemIdentifier in
//            var contentConfiguration = cell.defaultContentConfiguration()
////            contentConfiguration.text = itemIdentifier.dateStringLable
//            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
//            cell.contentConfiguration = contentConfiguration
//        }
//        
//        //2
//        collectionViewDataSource = .init(collectionView: detailView.collectionView) { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        }
//        
//        
//        //3
//        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
//            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
//            view?.titleLabel.text = section.title
//            return view
//        }
//        
//        
//    }
//    
//    
//    
//    
////    func applySnapshot(animatingDifferences: Bool = true) {
////        //makeNumberOfWeeksPerMonth(month: month)
////        var snapshot = collectionViewDataSource.snapshot()
////        snapshot.appendSections(sections)
////        sections.forEach { section in
//////            snapshot.appendItems(section.days, toSection: section)
////        }
////        collectionViewDataSource.apply(snapshot) { [weak self] in
////            guard let this = self else { return }
////            this.detailView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
////        }
////    }
//}
