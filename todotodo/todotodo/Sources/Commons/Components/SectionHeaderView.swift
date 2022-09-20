//
//  SectionHeaderView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/19.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    static var identifier: String {
        return String(describing: SectionHeaderView.self)
    }
    // 2
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 3
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        self.backgroundColor = .clear
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.top.equalTo(self).offset(40)
            $0.bottom.equalTo(self).offset(-8)
            //$0.centerY.equalTo(self)
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



