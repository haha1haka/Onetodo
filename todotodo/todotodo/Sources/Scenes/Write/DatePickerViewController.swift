//
//  DatePickerViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/19.
//

import UIKit
import SnapKit

protocol DateDelegate {
    func sendDate(_ date: Date)
}

class DatePickerViewController: BaseViewController {
    
    var delegate: DateDelegate?
    var date: Date!
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.tintColor = .link
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        return picker
    }()
    
    override func configure() {
        view.addSubview(datePicker)
        view.backgroundColor = .black
        datePicker.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(self.datePicker.snp.width)
        }
        
        
        configureNavigationBarButtonItem()
        
    }
    @objc
    func changedDate() {
        date = self.datePicker.date
        print("🆗")
        delegate?.sendDate(date)
    }
    
    func configureNavigationBarButtonItem() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDoneButton))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func tappedDoneButton() {
        date = self.datePicker.date
        print("🍖🍖🍖🍖🍖")
        delegate?.sendDate(date)
        self.dismiss(animated: true)
    }

}
extension DatePickerViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("사라짐")
    }
}
