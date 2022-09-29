//
//  WriteView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    

    let contentTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .myDarkGray
        view.placeholder = "  할 일을 입력해주세요"
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.textColor = .link
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        return view
    }()
    
    
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    
    
    override func configure() {
        self.backgroundColor = ColorType.writeViewColorSet
        [contentTextField, collectionView].forEach { self.addSubview($0) }
    }
    
    
    override func setConstraints() {

        
        contentTextField.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(50)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(contentTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalToSuperview()
        }
    }
    
    
}
