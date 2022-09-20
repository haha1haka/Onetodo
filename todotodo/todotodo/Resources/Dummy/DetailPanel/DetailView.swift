//
//  DetailVIew.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/17.
//
import UIKit

class DetailView: BaseView {
    
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
        
        //이곳에 UILable 넣어서 설명 해도 괜찮겠다
        self.backgroundColor = .black
    }
    
    
    override func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self).offset(50)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
    }
}







