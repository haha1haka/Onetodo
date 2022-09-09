//
//  MainCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class MainCell: BaseUICollectionViewCell {
    
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .brown
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
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

