//
//  PageCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/21.
//

import UIKit
import SnapKit

class PageCell: BaseCollectionViewCell {
    
    var label: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
    }
    override func prepareForReuse() {
        label.attributedText = nil
    }
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalTo(self).inset(10)
            $0.leading.trailing.equalTo(self).inset(10)
        }
    }
    
    func configureCell(itemIdentifier: ToDo) {
        label.text = itemIdentifier.title
        
    }
}
