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
    
    var randomColor = UIColor.random.cgColor
    
    var delegate: DateDelegate?
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    var date: Date!
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.timeZone = NSTimeZone.local
        picker.tintColor = .link
        picker.backgroundColor = UIColor.green
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        return picker
    }()

    
    override func configure() {
        

        
        view.addSubview(scrollView)
        scrollView.addSubview(datePicker)
        
        
        

        scrollView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.leading.trailing.equalTo(self.view)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
            $0.bottom.equalTo(self.view)
        }
        
        datePicker.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 20)
            $0.leading.equalTo(scrollView.snp.leading).offset(10)
            $0.trailing.equalTo(scrollView.snp.trailing).offset(-10)
            $0.top.equalTo(scrollView).offset(-5)
            $0.bottom.equalTo(scrollView)
            
        }

        
        configureNavigationBarButtonItem()
        self.view.backgroundColor = ColorType.writeViewColorSet
        //configureUINavigationBar()
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
        let cancelButton = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
    }
    func configureUINavigationBar() {
//        self.navigationItem.title = "Date"
//        let appearance = UINavigationBarAppearance()
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]
//        //appearance.backgroundColor = ColorType.backgroundColorSet
//        appearance.shadowColor = .clear
//        navigationItem.standardAppearance = appearance
//        navigationItem.scrollEdgeAppearance = appearance
    }
    
    @objc func tappedDoneButton() {
        date = self.datePicker.date
        print("🍖🍖🍖🍖🍖")
        delegate?.sendDate(date)
        self.dismiss(animated: true)
    }
    @objc func tappedCancelButton() {
        self.dismiss(animated: true)
    }

}






extension DatePickerViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("사라짐")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("♥️♥️♥️\(self.isBeingPresented)")
    }
}


