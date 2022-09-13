//
//  WriteView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import SnapKit

class WriteView: BaseView {

    
    lazy var label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
        self.addSubview(textField)
    }
        
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.top.equalTo(self).offset(100)
            $0.leading.equalTo(self).offset(100)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(44)
        }
    }
}


