//
//  WriteViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import FloatingPanel
import SnapKit




class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SettingSection, Setting>!
    
    let datepickerViewController = DatePickerViewController()
    let repository = ToDoRepository()
    var sections = SettingSection.makeData()
    var sectionIndexPath: Int = 0
    
    var itemidentifier: ToDo?
    
    var savedDate: Date?
    var dateString: String?
    var priority: Bool = false
    var priorityString = ""
    var colorString = ColorType.lableColorSet.toHexString()
    var backgroundColorString = ColorType.completeStringSet.toHexString()
    
    
    override func configure() {
        writeView.collectionView.delegate = self
        writeView.contentTextField.delegate = self
        configureNavigationBarButtonItem()
        configureCollectionViewDataSource()
        applyInitialSnapShot()
        configureToolbar()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: writeView.contentTextField)
        
        
    }
}

// MARK: - LifeCycles
extension WriteViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    @objc
    func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - configure Methods
extension WriteViewController {
    func configureNavigationBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(tappedCompleteButton))
        navigationItem.rightBarButtonItem = saveButton
    }
    @objc
    func tappedCompleteButton() {
        guard let contentText = writeView.contentTextField.text else { return }
        if contentText == "" {
            showAlertMessage(title: "할일을 등록해주세요")
            return
        }
        
        guard let date = savedDate else {
            showAlertMessage(title: "날짜를 입력해주세요")
            return
        }
        
        let priority = self.priority
        
        if itemidentifier == nil {
            repository.create(ToDo(title: contentText, date: date, completed: false, priority: priority, labelColor: colorString, backgroundColor: backgroundColorString))
        } else {
            guard let itemidentifier = itemidentifier else { return print("수정하기!")}
            guard let contentText = writeView.contentTextField.text else { return }
            if contentText == "" {
                showAlertMessage(title: "할일을 확인해주세요")
                return
            }
            guard let date = savedDate else { return }
            repository.update2(itemidentifier, title: contentText,  date: date, priority: self.priority, labelColor: colorString, backgroundColor: backgroundColorString)

        }
        navigationController?.popViewController(animated: true)
    }
    
    func showSheetPresentatilnController() {
        datepickerViewController.delegate = self
        let navi = UINavigationController(rootViewController: datepickerViewController)

        if let sheet = navi.sheetPresentationController {
            print("fdsfds")
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        self.present(navi, animated: true)
    }
    func configureToolbar() {
        let toolbar = UIToolbar()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tappedDoneButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.backgroundColor = .clear
        
        toolbar.tintColor = .link
        toolbar.layer.cornerRadius = 8
        
        toolbar.layer.masksToBounds = true
        
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = toolbar.bounds
        toolbar.addSubview(blurEffectView)
        toolbar.sendSubviewToBack(blurEffectView)
        blurEffectView.layer.cornerRadius = 8
        blurEffectView.clipsToBounds = true
        
        writeView.contentTextField.inputAccessoryView = toolbar
    }

    
    @objc
    func tappedDoneButton() {
        view.endEditing(true)
    }
    
    func configureData(item: ToDo) {
        itemidentifier = item
        savedDate = item.date
        priority = item.priority
        colorString = item.labelColor
        backgroundColorString = item.backgroundColor
        writeView.contentTextField.text = item.title
        dateString = self.dateFormatter.string(from: item.date)
        writeView.contentTextField.backgroundColor =  UIColor(hex: item.backgroundColor)
        writeView.contentTextField.textColor = UIColor(hex: item.labelColor)
    }
}








// MARK: - DataSource, applySnapShot HeaderFooter, Methods
extension WriteViewController {
    
    func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Setting> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.secondaryText = ""
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            contentConfiguration.imageProperties.tintColor = .tintColor
            contentConfiguration.image = itemIdentifier.image
            //guard let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        
            //수정화면
            if !(self.itemidentifier == nil) {
                if indexPath.section == 0 && indexPath.row == 0 {
                    let dateStr = self.dateFormatter.string(from: self.itemidentifier?.date ?? Date())
                    if self.dateString == nil {
                        contentConfiguration.secondaryText = dateStr
                    } else {
                        contentConfiguration.secondaryText = self.dateString
                    }
                    
                    
                }
            } else {
                if indexPath.section == 0 && indexPath.row == 0 {
                    contentConfiguration.secondaryText = self.dateString
                }
            }
            

            

            
            if indexPath.section == 0 && indexPath.row == 1 {
                if self.priority {
                    self.priorityString = "높음"
                    contentConfiguration.secondaryText = self.priorityString
                    self.priority = true
                } else {
                    self.priorityString = "보통"
                    contentConfiguration.secondaryText = self.priorityString
                    self.priority = false
                }
                print(self.priorityString)
                print(self.priority)
            }
            
            cell.contentConfiguration = contentConfiguration
        }
        
        collectionViewDataSource = .init(collectionView: writeView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>.init(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, string, indexPath) in
            var config = UIListContentConfiguration.groupedHeader()
            config.text = self.sections[indexPath.section].headerText
            //config.image = self.sections[indexPath.section].settings
            supplementaryView.contentConfiguration = config
        }
        let footerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>.init(elementKind: UICollectionView.elementKindSectionFooter) { (supplementaryView, string, indexPath) in
            var config = UIListContentConfiguration.groupedFooter()
            config.text = self.sections[indexPath.section].footerText
            //config.image = self.sections[indexPath.section].settings
            supplementaryView.contentConfiguration = config
        }
        
        collectionViewDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return self.writeView.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration,for: indexPath)
            default :
                return self.writeView.collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration,for: indexPath)
            }
        }
        
    }
    
    
    func applyInitialSnapShot() {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.settings, toSection: section)
        }
        collectionViewDataSource.apply(snapshot)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if ((writeView.contentTextField.text?.count)! > maxLength) {
            textField.deleteBackward()
        }
    }
    
    @objc
    func textDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            var maxLength = 20
            if let text = textField.text {
                
                if text.count > maxLength {
                    // 8글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                    showAlertMessage(title: "15글자 까지 입력됩니다")
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
//                else if text.count < 2 {
//                    warningLabel.text = "2글자 이상 8글자 이하로 입력해주세요"
//                    warningLabel.textColor = .red
//
//                }
//                else {
//                    warningLabel.text = "사용 가능한 닉네임입니다."
//                    warningLabel.textColor = .green
//
//                }
            }
        }
    }
    
    
}



extension WriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.section)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                writeView.contentTextField.resignFirstResponder()
                showSheetPresentatilnController()
            default:
                writeView.contentTextField.resignFirstResponder()
                guard let selectedCell = collectionViewDataSource.itemIdentifier(for: IndexPath(row: 1, section: 0)) else { return }
                selectedCell.priority.toggle()
                self.priority.toggle()
                var snapshot = collectionViewDataSource.snapshot()
                snapshot.reloadItems([selectedCell])
                collectionViewDataSource.apply(snapshot, animatingDifferences: true)
            }
        default:
            switch indexPath.row {
            case 0:
                let picker = UIColorPickerViewController()
                picker.selectedColor = .white
                picker.delegate = self
                sectionIndexPath = indexPath.row
                self.present(picker, animated: true, completion: nil)
            default:
                let picker = UIColorPickerViewController()
                picker.selectedColor = .darkGray
                picker.delegate = self
                sectionIndexPath = indexPath.row
                self.present(picker, animated: true, completion: nil)
            }
        }
    }
}



extension WriteViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        print("고를때마다 선택이됨.")
        switch sectionIndexPath {
        case 0:
            colorString = viewController.selectedColor.toHexString()
            print(colorString)
            writeView.contentTextField.textColor = UIColor(hex: colorString)
        default:
            backgroundColorString = viewController.selectedColor.toHexString()
            writeView.contentTextField.backgroundColor = UIColor(hex: backgroundColorString)
        }
        
        
    }

}




// MARK: - dateDelegate
extension WriteViewController: DateDelegate {
    func sendDate(_ date: Date) {
        dateString = dateFormatter.string(from: date) //이걸로 판단하기
        print("\(date)")
        savedDate = date
        guard let selectedCell = collectionViewDataSource.itemIdentifier(for: IndexPath(row: 0, section: 0)) else { return }
        var newSnaShot = collectionViewDataSource.snapshot()
        newSnaShot.reloadItems([selectedCell])
        collectionViewDataSource.apply(newSnaShot, animatingDifferences: true)
    }
}

extension WriteViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = writeView.contentTextField.text else { return false }
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }

        guard let text = textField.text else { return false }
        if text.count >= 20 {
            return false
        }

        return true

    }
    
    
}




