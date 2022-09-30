//
//  PopPanelCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import SnapKit

class MainPanelCell: BaseCollectionViewCell {

    let label: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints{
            $0.top.leading.top.trailing.leading.equalTo(self).inset(20)
        }
    }
    override func prepareForReuse() {
        label.attributedText = nil
    }
    
    func configureCell(item: ToDo) {
        label.text = item.title
    }
}
