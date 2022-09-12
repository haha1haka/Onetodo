//
//  KewordCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import SnapKit

class KeywordCell: BaseUICollectionViewCell {
    
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .systemPurple
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    

    
    override func configure() {
        self.addSubview(label)
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
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

import Foundation
