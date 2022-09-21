//
//  WriteView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    
    let dateButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .link
        view.setTitle("날짜선택", for: .normal)
        view.setTitleColor(.white, for: .normal)
        return view
    }()
    
    let dateLable: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.backgroundColor = .brown
        return view
    }()
    
    let contentTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .black
        view.placeholder = "할 일을 입력해주세요"
        return view
    }()
    
    
    override func configure() {
        [dateButton, dateLable].forEach { self.addSubview($0) }
        [contentTextField].forEach { self.addSubview($0) }
    }
    
    
    override func setConstraints() {
        dateButton.snp.makeConstraints {
            $0.top.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(88)
            $0.height.equalTo(55)
        }
        dateLable.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.leading.equalTo(dateButton.snp.trailing).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(44)
        }
        
        contentTextField.snp.makeConstraints {
            $0.top.equalTo(dateLable.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(44)
            
        }
    }
    
    
}
