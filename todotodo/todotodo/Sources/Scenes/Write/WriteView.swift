//
//  WriteView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import SnapKit

class WriteView: BaseView {

    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabelTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()

    lazy var dateLabelTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var statusLable: UILabel = {
        let view = UILabel()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    lazy var completeButton: UIButton = {
        let view = UIButton()
        view.setTitle("완료", for: .normal)
        view.backgroundColor = .red
        return view
    }()
    lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setTitle("삭제", for: .normal)
        view.backgroundColor = .black
        return view
    }()

    
    
    
    
    
    override func configure() {
        [titleLabel, titleLabelTextField].forEach { self.addSubview($0) }
        [dateLabel, dateLabelTextField].forEach { self.addSubview($0) }
        self.addSubview(stackView)
        [completeButton, deleteButton].forEach { stackView.addArrangedSubview($0) }
    }
        
    override func setConstraints() {
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(44)
            $0.leading.equalTo(self).offset(20)
        }
        
        titleLabelTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(44)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabelTextField.snp.bottom).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(44)
            $0.leading.equalTo(self).offset(20)
        }
        
        dateLabelTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(44)
        }
        
        
        
        
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(dateLabelTextField.snp.bottom).offset(20)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(200)
            $0.height.equalTo(54)
        }
        
        
        
    }
}


