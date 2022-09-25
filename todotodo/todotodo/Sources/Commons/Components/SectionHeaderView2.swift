//
//  File.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/24.
//

import UIKit
import SnapKit

class SectionHeaderView2: UICollectionReusableView {
    static var identifier: String {
        return String(describing: SectionHeaderView2.self)
    }
    // 2
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        
        self.backgroundColor = .clear
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self).offset(10)
            $0.trailing.equalTo(self)
            $0.top.equalTo(self).offset(30)
            $0.bottom.equalTo(self).offset(-8)
            //$0.centerY.equalTo(self)
        }

        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




