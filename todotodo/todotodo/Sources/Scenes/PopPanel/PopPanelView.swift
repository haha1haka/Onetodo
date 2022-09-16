//
//  PopPanelView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import SnapKit

class PopPanelView: BaseView {
    
    
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
        view.backgroundColor = .red
        return view
    }()
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        // MARK: - 3
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.backgroundColor = .secondarySystemBackground
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
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







