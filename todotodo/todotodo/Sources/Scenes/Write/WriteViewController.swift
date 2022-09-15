//
//  WriteViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit

class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    
    override func loadView() {
        self.view = writeView
    }
    lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
//        picker.delegate = self
//        picker.dataSource = self
        return picker
    }()
    
    override func configure() {
        writeView.backgroundColor = .blue
    }
}



//extension WriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
//
    
//}
