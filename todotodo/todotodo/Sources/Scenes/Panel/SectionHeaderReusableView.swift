//
//  SectionHeaderReusableView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import UIKit
import SnapKit

class SectionHeaderReusableView: UICollectionReusableView {
    static var identifier: String {
        return String(describing: SectionHeaderReusableView.self)
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
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.top.equalTo(self).offset(10)
            $0.bottom.equalTo(self).offset(-10)
        }
        
//        NSLayoutConstraint.activate([
//          titleLabel.leadingAnchor.constraint(
//            equalTo: readableContentGuide.leadingAnchor),
//          titleLabel.trailingAnchor.constraint(
//            lessThanOrEqualTo: readableContentGuide.trailingAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//          titleLabel.topAnchor.constraint(
//            equalTo: topAnchor,
//            constant: 10),
//          titleLabel.bottomAnchor.constraint(
//            equalTo: bottomAnchor,
//            constant: -10)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

