//
//  WriteViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import FloatingPanel

class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    var fpc = FloatingPanelController()
    var contentVC = DatePickerViewController()
    
    
    let repository = ToDoRepository()
    var todo: ToDo?
    var savedDate: Date?

    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        //fpc.delegate = self
        return formatter
    }
    
    override func configure() {
        writeView.backgroundColor = .black
        configureNavigationBarButtonItem()
        configureButtonTarget()
        //configToolbar()
    }
    

}


// MARK: - LifeCycle
extension WriteViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        contentVC.dismiss(animated: true)
        
    }
}


extension WriteViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //contentVC.dismiss(animated: true)
        print("사라짐")
    }
}

extension WriteViewController {
    
    
    func configureButtonTarget() {
        writeView.dateButton.addTarget(self, action: #selector(tappedDateButton), for: .touchUpInside)
    }
    @objc
    func tappedDateButton() {
        contentVC.delegate = self
        showDatePickerPanel()
    }
    
    
    func configureNavigationBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(tappedSaveButton))
        navigationItem.rightBarButtonItem = saveButton
    }
    @objc
    func tappedSaveButton() { //⭐️⭐️⭐️⭐️⭐️
        print("fdsfdsfs")
        guard let dateLabelText = writeView.dateLable.text,
              //let date = datepicker
              let textFieldText = writeView.contentTextField.text else { return }
        print("🟩🟩\(dateLabelText), \(textFieldText)")
        guard let currentDate = savedDate else { return print("시간 없음.")}
        
        if dateLabelText.isEmpty {
            presentAlertController("날짜와 시간을 선택해주세요")
        }
        //ToDo(content: textFieldText, date: Date(), dateString: dateLabelText, completed: false, priority: 1)
        if todo == nil { //작성
            repository.create(ToDo(content: textFieldText, date: currentDate, dateMonth: String(currentDate.month), dateWeek: String(currentDate.week), completed: false, priority: 1))
            
        } else { //작성
            guard let todo = todo else { return print("수정하기!")}
            repository.update(todo, content: textFieldText, date: Date(), completed: false)
        }
        navigationController?.popViewController(animated: true)
        //⭐️⭐️⭐️⭐️⭐️
    }
    
    

}




extension WriteViewController: DateDelegate {
    func sendDate(_ date: Date) {
        print("🟩🟩🟩🟩🟩🟩🟩🟩🟩\(date)")
        writeView.dateLable.text = dateFormatter.string(from: date)
        savedDate = date
    }
}



// MARK: - FloatingPanelControllerDelegate
extension WriteViewController: FloatingPanelControllerDelegate {
    
    func showDatePickerPanel() {
        
        fpc.set(contentViewController: UINavigationController(rootViewController: contentVC))
        fpc.layout = MyFloatingPanelLayout3()
        fpc.isRemovalInteractionEnabled = true
        fpc.delegate = self
        fpc.changePanelStyle()
        //fpc.addPanel(toParent: self)
        //fpc.invalidateLayout()
        fpc.behavior = MyFloatingPanelBehavior()
        self.present(fpc, animated: true, completion: nil)
        
        
        
        

        
        
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        print("\(fpc.surfaceLocation.y)")
        print("\(fpc.surfaceLocation(for: .tip).y)")
        if fpc.surfaceLocation.y >= fpc.surfaceLocation(for: .tip).y - 100 {
            print("🟧🟧🟧🟧🟧🟧🟧")
            contentVC.dismiss(animated: true)
        }
    }
    
    

}


