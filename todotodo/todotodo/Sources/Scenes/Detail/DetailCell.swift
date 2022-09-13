//
//  DetailCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class DetailCell: BaseCollectionViewCell {
    
    
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
            $0.center.equalTo(self)
        }
    }
    func configureCell(itemIdentifier: String) {
        label.text = itemIdentifier
    }
    
    
}



