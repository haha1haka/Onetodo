//
//  MainView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class MainView: BaseView {
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
        view.backgroundColor = .red
        return view
    }()
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        itemLayout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)

        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 16
        return UICollectionViewCompositionalLayout(section: sectionLayout)
    }
    
    


    
    
    override func configure() {
//        self.addSubview(label)
        self.addSubview(collectionView)
    }
    
    
    override func setConstraints() {

        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
}

//        sectionLayout.orthogonalScrollingBehavior = .continuous




