////
////  Test2VC.swift
////  todotodo
////
////  Created by HWAKSEONG KIM on 2022/09/20.
////
//
//import UIKit
//
//
//
//class Test2VC: UIViewController {
//    
//    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
//    var collectionView: UICollectionView! = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureHierarchy()
//        configureDataSource()
//    }
//
//    
//    func configureHierarchy() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
//        view.addSubview(collectionView)
//        //collectionView.delegate = self
//    }
//    func createLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout {
//            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            let leadingItem = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128)))
//            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            
//            let containerGroup = NSCollectionLayoutGroup.horizontal(
//                layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128)), subitems: [leadingItem])
//            let section = NSCollectionLayoutSection(group: containerGroup)
//            section.orthogonalScrollingBehavior = .none
//
//        
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            section.boundarySupplementaryItems = [sectionHeader]
//            
//            
//            
//
//            return section
//        }
//        return layout
//    }
//
//    func registerSectionHeaterView() {
//        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
//    }
//    func configureDataSource() {
//        
//        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
//            // Populate the cell with our item description.
//            cell.label.text = "\(indexPath.section), \(indexPath.item)"
//            cell.contentView.backgroundColor = .systemCyan
//            cell.contentView.layer.borderColor = UIColor.black.cgColor
//            cell.contentView.layer.borderWidth = 1
//            cell.contentView.layer.cornerRadius = 8
//            cell.label.textAlignment = .center
//            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
//        }
//        
//
//        
//        
//        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
//            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
//            // Return the cell.
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
//        }
//
//        
//        
//        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            guard kind == UICollectionView.elementKindSectionHeader else { return }
//            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
//            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
//            view?.titleLabel.text = section.title
//            return view
//        }
//        
//        
//        
//        // initial data
//        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
//        var identifierOffset = 0
//        let itemsPerSection = 3
//        for section in 0..<5 {
//            snapshot.appendSections([section])
//            let maxIdentifier = identifierOffset + itemsPerSection
//            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
//            identifierOffset += itemsPerSection
//        }
//        dataSource.apply(snapshot, animatingDifferences: false)
//    }
//
//}
////extension TestViewController: UICollectionViewDelegate {
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        collectionView.deselectItem(at: indexPath, animated: true)
////    }
////}
