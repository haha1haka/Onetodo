//
//  TopicCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class TopicCell: BaseCollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return view
    }()

    let selectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.isHidden = true
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            invalidateCell()
        }
    }
    
    func invalidateCell() {
        selectionView.isHidden = !isSelected
    }
    
    override func configure() {
        [selectionView, label].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.center.equalTo(self)
        }
        
        selectionView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self)
        }
    }
    
    func configureCell(itemIdentifier: Month) {
        label.text = itemIdentifier.title
        
    }  
}


