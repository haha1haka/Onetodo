//
//  TopicView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class TopicView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .absolute(44))
        let groupLayout = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.orthogonalScrollingBehavior = .continuous
        
        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 16
        return UICollectionViewCompositionalLayout(section: sectionLayout)
    }
    
    override func configure() {
        [collectionView, dividerView].forEach { self.addSubview($0) }
    }
    

    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalTo(self)
        }
    }
}







