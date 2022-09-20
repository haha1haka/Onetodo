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
    
//    //MARK: 피커뷰 위한 툴바
//    func configToolbar() {
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = UIColor.white
//        toolBar.backgroundColor = .black
//        toolBar.sizeToFit()
//
//        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        //let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
//
//        toolBar.setItems([flexibleSpace,doneBT], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
//
//    }
//    //MARK: 피커 선택
//    @objc func donePicker() {
//        let row = self.writeView.pickerView.selectedRow(inComponent: 0)
//        self.writeView.pickerView.selectRow(row, inComponent: 0, animated: false)
//        let text = self.pickerSelect[row].split(separator: ":")
//        self.writeView.opendateInput.text = String(text[1])
//        self.writeView.opendateInput.resignFirstResponder()
//    }
    
//    //MARK: 피커 취소
//    @objc func cancelPicker() {
//        self.writeView.opendateInput.text = nil
//        self.writeView.opendateInput.resignFirstResponder()
//    }
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
    @objc // MARK: - ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    func tappedSaveButton() {
        print("fdsfdsfs")
        guard let dateLabelText = writeView.dateLable.text,
              let textFieldText = writeView.contentTextField.text else { return }
        print("🟩🟩\(dateLabelText), \(textFieldText)")
        
        if dateLabelText.isEmpty {
            presentAlertController("날짜와 시간을 선택해주세요")
        }
        
        if todo == nil { //😄작성
            repository.create(ToDo(content: textFieldText, date: Date(), dateString: dateLabelText, completed: false, priority: 1))
            
        } else { //😱작성
            guard let todo = todo else { return print("수정하기!")}
            repository.update(todo, content: textFieldText, date: Date(), completed: false)
        }
        navigationController?.popViewController(animated: true)
        // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    }
    
    
//    
//    func createDatePickerView() {
//        let toolbar = UIToolbar()
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "done", style: .plain, target: nil, action: #selector(tappedDoneButton))
//        var buttonList = [UIBarButtonItem]()
//        buttonList.append(flexibleSpace)
//        buttonList.append(doneButton)
//
//        buttonList.forEach { bt in
//            bt.tintColor = .black
//        }
//
//        toolbar.sizeToFit()
//        toolbar.setItems(buttonList, animated: false)
//        textField.inputAccessoryView = toolbar
//    }
//    @objc
//    func tappedDoneButton() {
//        guard let dateLabelText = dateLabel.text,
//              let textFieldText = textField.text else { return }
//       
//        if dateLabelText.isEmpty {
//            presentAlertController("날짜와 시간을 선택해주세요")
//        }
//        else if textFieldText.isEmpty {
//            textField.text = ""
//            presentAlertController("할 일을 입력해주세요")
//        } else {
//            coreDataStore.createTodo(text: textFieldText, date: date)
//            dateLabel.text = ""
//            
//            textField.do {
//                $0.resignFirstResponder()
//                $0.text = ""
//                $0.placeholder = "날짜와 시간을 선택해주세요"
//            }
//            
//            UIView.animate(withDuration: 0.5) { [weak self] in
//                guard let self = self else { return }
//                
//                self.addToDoButton.transform = .identity
//            }
//            dateLabel.isHidden = true
//            configureSnapshot(selectedFilter)
//        }
//    }
//
//    
//    override func willChangeKeyboard(isHidden: Bool) {
//        bottomStackView.isHidden = isHidden
//        addTodoButtonBottomConstraint?.isActive = !isHidden
//    }
}




extension WriteViewController: DateDelegate {
    func sendDate(_ date: Date) {
        print("🟩🟩\(date)")
        writeView.dateLable.text = dateFormatter.string(from: date)
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
        
        
        
        
        //panelVC = DatePickerViewController()
//        fpc = FloatingPanelController()
//        fpc.changePanelStyle()
//        fpc.delegate = self
//        fpc.set(contentViewController: panelVC)
//        fpc.track(scrollView: panelVC.popPanelView.collectionView)
        //fpc.track(scrollView: contentVC.mainPanelView.collectionView)
//        fpc.addPanel(toParent: self) // fpc를 관리하는 UIViewController
//        fpc.isRemovalInteractionEnabled = true
//        fpc.behavior = MyFloatingPanelBehavior()
//        fpc.layout = MyFloatingPanelLayout3()

        
//        fpc.invalidateLayout() // if needed
        //self.view.addSubview(fpc.view)
        //view.addSubview(fpc.view)
        //addChild(fpc)
//        fpc.show(animated: false) { [weak self] in
//            guard let self = self else { return }
//            self.didMove(toParent: self)
//        }
        
        
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


