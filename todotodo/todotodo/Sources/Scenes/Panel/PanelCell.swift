//
//  PanelCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import UIKit
import SnapKit

class PanelCell: BaseCollectionViewCell {
    
    
//    let label: UILabel = {
//        let view = UILabel()
//        view.backgroundColor = .brown
//        return view
//    }()
    
    let content: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        return view
    }()
    
    override func configure() {
        //self.addSubview(label)
        self.addSubview(content)
    }
    
    override func setConstraints() {
//        label.snp.makeConstraints {
//            $0.center.equalTo(self)
//        }
        content.snp.makeConstraints {
            $0.center.equalTo(self)
            //$0.height.width.equalTo(100)
            //$0.top.equalTo(label.snp.bottom).offset(20)
            //$0.leading.trailing.equalTo(self).inset(20)
            //$0.bottom.equalTo(self)
        }
    }
    func configureCell(itemIdentifier: ToDo) {
        //label.text = itemIdentifier.dateTitleLabel
        content.text = itemIdentifier.contentLabel
    }
    
    
}
