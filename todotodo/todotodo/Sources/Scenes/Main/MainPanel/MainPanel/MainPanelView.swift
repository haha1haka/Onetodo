//
//  PopPanelView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import SnapKit

class MainPanelView: BaseView {
    
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
//        view.backgroundColor = .red
        view.backgroundColor = .secondarySystemGroupedBackground
        return view
    }()
    
    
    

    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            //1️⃣ Item, Group Section Layout)
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let Item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [Item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 16

            //2️⃣ Header Layout
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let headerItemLayout = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItemLayout]
            return section
        }, configuration: configuration)
    }

    
    
    override func configure() {
        self.addSubview(collectionView)
        
    }
    
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
    }

    
}







