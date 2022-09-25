//
//  SearchCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/23.
//

import UIKit
import SnapKit

class SearchCell: BaseCollectionViewCell {
    
    var label: UILabel = {
        let view = UILabel()
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
        
    }
    
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self).inset(4)
        }
    }
    func configureCell(itemIdentifier: ToDo) {
        label.text = itemIdentifier.title
    }
}
