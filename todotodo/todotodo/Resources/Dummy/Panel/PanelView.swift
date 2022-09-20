//
//  PanelView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

//import UIKit
//import SnapKit
//
//class PanelView: BaseView {
//    
//    lazy var collectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
//        view.backgroundColor = .black
//        return view
//    }()
//    
//    func configureCollectionViewLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) in
//            let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
//            let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
//            //itemLayout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//            let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44*5))
//            let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [itemLayout,itemLayout,itemLayout])
//            
//            
//            let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
//            sectionLayout.contentInsets.leading = 16
//            sectionLayout.contentInsets.trailing = 16
//            sectionLayout.interGroupSpacing = 16
//    
//            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(8))
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            sectionLayout.boundarySupplementaryItems = [sectionHeader]
//            return sectionLayout
//        }
//    }
//    
//    
//    override func configure() {
//        self.addSubview(collectionView)
//    }
//    
//    override func setConstraints() {
//        collectionView.snp.makeConstraints {
//            $0.top.equalTo(self.safeAreaLayoutGuide)
//            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
//            $0.bottom.equalTo(self)
//        }
//    }
//}
