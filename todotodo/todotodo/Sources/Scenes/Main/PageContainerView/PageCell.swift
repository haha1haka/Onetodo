//
//  MainCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class PageCell: BaseCollectionViewCell {
    
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .systemGreen
        view.textColor = .white
        view.font = .systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    

    
    
    override func configure() {
        self.addSubview(label)
        //self.addSubview(collectionView)
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true

    }
    
    
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }

        
    }
    
    func configureCell(itemIdentifier: String) {
        label.text = itemIdentifier
    }
}









extension PageCell {
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .absolute(44))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.contentInsets.top = 8
        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 8
        return UICollectionViewCompositionalLayout(section: sectionLayout)
    }

}
