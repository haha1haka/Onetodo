//
//  MainCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class PageCell: BaseCollectionViewCell {
    
    
    let dateNumberLabel: UILabel = {
        let view = UILabel()
        //view.backgroundColor = .brown
        return view
    }()
    
    let dateStringLabel: UILabel = {
        let view = UILabel()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.textAlignment = .center
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.darkGray.cgColor
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    
    override func configure() {
        [dateNumberLabel, dateStringLabel, contentLabel].forEach { self.addSubview($0) }
        //self.backgroundColor = .black
    }
    
    
    override func setConstraints() {
        dateNumberLabel.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(self)
            $0.leading.equalTo(10)
        }
        
        dateStringLabel.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalTo(self)
            $0.leading.equalTo(dateNumberLabel.snp.trailing).offset(10)
        }
        
        contentLabel.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(self)
            $0.leading.equalTo(dateStringLabel.snp.trailing).offset(20)
        }
        
    }
    
    
    func configureCell(itemIdentifier: ItemDay) {
        dateNumberLabel.text = itemIdentifier.dateNumberLable
        dateStringLabel.text = itemIdentifier.dateStringLable
        contentLabel.text = itemIdentifier.contentLabel.first!
    }
}








