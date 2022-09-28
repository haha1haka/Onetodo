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
    var itemidentifier: ToDo?
    var savedDate: Date?
    var sections = SettingSection.makeData()
    var sectionIndexPath: Int = 0
    
    
    var dateString: String?
    var priority: Bool = false
    var priorityString = ""
    var colorString = "#000000"
    var backgroundColorString = "#555555"
    
    var flag = false
    
    override func configure() {
        configureNavigationBarButtonItem()
        configureCollectionViewDataSource()
        applyInitialSnapShot()
        writeView.collectionView.delegate = self
    }
}

extension WriteViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    @objc
    func back(sender: UIBarButtonItem) {

        if flag {
            dismissSheetPresentationController()
            navigationController?.popViewController(animated: true)
            
        } else {
            print("dfsfsd")
            navigationController?.popViewController(animated: true)
        }
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
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
        guard let dateText = dateString else { return }
        let priority = self.priority
        print("📭📭📭📭📭📭📭\(priority)")
        
        
        
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
            print("🎾\(itemidentifier)잘 넘어옴")
        }
        
        // 수정 했을때
        navigationController?.popViewController(animated: true)
        
    }
    
    func showSheetPresentatilnController() {
        
        flag = true
        datepickerViewController.delegate = self
        let navi = UINavigationController(rootViewController: datepickerViewController)
        isModalInPresentation = true
        
        
        
        if let sheet = navi.sheetPresentationController {
            print("fdsfds")
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
        }
        
        self.present(navi, animated: true)
        
    }
    
    func dismissSheetPresentationController() {
        datepickerViewController.dismiss(animated: true)
    }
}









extension WriteViewController {
    
    // MARK: - 데이터소스
    func configureCollectionViewDataSource() {
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Setting> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.secondaryText = ""
            //contentConfiguration.imageProperties.tintColor = .label
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            contentConfiguration.imageProperties.tintColor = .tintColor
            contentConfiguration.image = itemIdentifier.image
            guard let selectedItem = self.collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        
            //수정화면
            if !(self.itemidentifier == nil) {
                if indexPath.section == 0 && indexPath.row == 0 {
                    let dateStr = self.dateFormatter.string(from: self.itemidentifier?.date ?? Date())
                    contentConfiguration.secondaryText = dateStr
                    
                }
            }
            
            if !(self.dateString == nil) {
                contentConfiguration.secondaryText = self.dateString
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
                print("📮📮📮📮📮📮\(selectedCell.priority)")
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
extension WriteViewController: UISheetPresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print("🥡🥡🥡🥡🥡asdfadsfadsfasd")
        return true
    }
}




// MARK: - dateDelegate
extension WriteViewController: DateDelegate {
    func sendDate(_ date: Date) {
        //writeView.contentTextField.text = dateFormatter.string(from: date)
        dateString = dateFormatter.string(from: date) //이걸로 판단하기
        print("\(date)")
        savedDate = date
        guard let selectedCell = collectionViewDataSource.itemIdentifier(for: IndexPath(row: 0, section: 0)) else { return }
        var newSnaShot = collectionViewDataSource.snapshot()
        newSnaShot.reloadItems([selectedCell])
        collectionViewDataSource.apply(newSnaShot, animatingDifferences: true)
    }
}






