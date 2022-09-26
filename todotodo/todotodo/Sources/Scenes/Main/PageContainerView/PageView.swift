//
//  PageView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit



class PageView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
        return view
    }()
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            //1️⃣ Item, Group Section Layout
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
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
            $0.top.equalTo(self)
            $0.leading.equalTo(self)
            $0.trailing.equalTo(self)
            $0.bottom.equalTo(self).inset(20)
        }
    }
}


