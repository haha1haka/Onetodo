//
//  WriteViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit
import FloatingPanel
import SnapKit

enum Type: String, CaseIterable {
    case requiredSetting = "필수사항"
    case colorSetting = "Color Setting"
}

class SettingSection: Hashable {
    var id = UUID()
    var headerText: String
    var footerText: String
    var settings: [Setting]
    
    init(headerText: String,footerText: String, settings: [Setting]) {
        self.headerText = headerText
        self.footerText = footerText
        self.settings = settings
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: SettingSection, rhs: SettingSection) -> Bool {
        lhs.id == rhs.id
    }
    
    static func makeData() -> [SettingSection] {
        let data = [SettingSection(headerText: "필수 입력사항",footerText: "날짜와 우선순위를 지정해서 관리하세요", settings: [
                        Setting(name: "car", type: .requiredSetting, title: "날짜선택"),
                        Setting(name: "car", type: .colorSetting, title: "우선순위")]
                                  ),
                    SettingSection(headerText: "Color Setting",footerText: "각 이벤트에 맞게 색상을 지정해 주세요.", settings: [
                        Setting(name: "car", type: .requiredSetting, title: "Lable Color"),
                        Setting(name: "car", type: .colorSetting, title: "Background Color")]
                                  )]
        return data
    }
}
//extension SettingSection {
//    static var alllSections: [SettingSection] = [SettingSection(title: "필수입력", settings: [Setting(title: "날짜선택"),
//                                                                                          Setting(title: "우선순위선택")]),
//                                                 SettingSection(title: "Color Setting", settings: [Setting(title: "LableColor"),                                            Setting(title: "BackgroundColor")])
//    ]
//}



class Setting: Hashable {
    var id = UUID()
    var name: String
    var title: String
    var image: UIImage
    var type: Type
    var value: Int
    
    init(name: String,type: Type, title: String, value: Int = 0) {
        self.id = UUID()
        self.name = name //이미지 떄문
        self.title = title //
        self.image = UIImage(systemName: name)!
        self.type = type
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        lhs.id == rhs.id
    }
}






class WriteViewController: BaseViewController {
    
    let writeView = WriteView()
    override func loadView() {
        self.view = writeView
    }
    
    var fpc = FloatingPanelController()
    var contentVC = DatePickerViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SettingSection, Setting>!
    
    
    let repository = ToDoRepository()
    var todo: ToDo?
    var savedDate: Date?
    var sections = SettingSection.makeData()
    var sectionIndexPath: Int = 0
    
    
    var dateString: String?
    var value: Int = 0
    var colorString = "#000000"
    var backgroundColorString = "#555555"
    
    
    
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
        //configureButtonTarget()
        //registerSectionHeaterView()
        configureCollectionViewDataSource()
        applyInitialSnapShot()
        writeView.collectionView.delegate = self
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



// MARK: - configure Methods
extension WriteViewController {
    func configureNavigationBarButtonItem() {
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(tappedSaveButton))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc
    func tappedSaveButton() {
        guard let contentText = writeView.contentTextField.text else { return }
        guard let date = savedDate else { return print("알럿 : 시간을 선택해 주세요") }
        guard let dateText = dateString else { return print("...") }
        let priority = value
        
        if dateText.isEmpty {
            presentAlertController("날짜와 시간을 선택해주세요")
        }
        if todo == nil {
            repository.create(ToDo(content: contentText, date: date, dateMonth: date.month, dateWeek: date.week, dateToday: date.day, completed: false, priority: priority, labelColor: colorString, backgroundColor: backgroundColorString))
        } else {
            guard let todo = todo else { return print("수정하기!")}
        }
        
        // 수정 했을때
        navigationController?.popViewController(animated: true)

    }
    
    
//    func configureNavigationBarButtonItem() {
//        //self.navigationController?.navigationBar.prefersLargeTitles = true
//        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(tappedSaveButton))
//        navigationItem.rightBarButtonItem = saveButton
//    }
//
//    @objc
//    func tappedSaveButton() { //⭐️⭐️⭐️⭐️⭐️
//        print("fdsfdsfs")
//        guard let dateLabelText = writeView.dateLable.text,
//              //let date = datepicker
//              let textFieldText = writeView.contentTextField.text else { return }
//        print("🟩🟩\(dateLabelText), \(textFieldText)")
//        guard let currentDate = savedDate else { return print("시간 없음.")}
//
//        if dateLabelText.isEmpty {
//            presentAlertController("날짜와 시간을 선택해주세요")
//        }
//        //ToDo(content: textFieldText, date: Date(), dateString: dateLabelText, completed: false, priority: 1)
//        if todo == nil { //작성
//            repository.create(ToDo(content: textFieldText, date: currentDate, dateMonth: currentDate.month, dateWeek: currentDate.week, dateToday: currentDate.day, completed: false, priority: 1))
//
//        } else { //작성
//            guard let todo = todo else { return print("수정하기!")}
//            repository.update(todo, content: textFieldText, date: Date(), completed: false)
//        }
//        navigationController?.popViewController(animated: true)
//        //⭐️⭐️⭐️⭐️⭐️
//    }
    func showSheetPresentatilnController() {
        let vc = DatePickerViewController()
        vc.delegate = self
        let navi = UINavigationController(rootViewController: vc)
        isModalInPresentation = true
        if let sheet = navi.sheetPresentationController {
            print("fdsfds")
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }
        
        self.present(navi, animated: true)
    }
    func showColorPickerController() {
        
    }
    

}









extension WriteViewController {
    
    
    func configureCollectionViewDataSource() {
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Setting> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = itemIdentifier.title
            contentConfiguration.secondaryText = ""
            contentConfiguration.imageProperties.tintColor = .label
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            //contentConfiguration.description = "안녕하세요"
            //contentConfiguration.attributedText = "dfsfsdfsdfs"
            //contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            
            if !(self.dateString == nil) {
                contentConfiguration.secondaryText = self.dateString
            }
            if indexPath.section == 0 && indexPath.row == 1 {
                contentConfiguration.secondaryText = String(itemIdentifier.value)
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


extension WriteViewController: DateDelegate {
    func sendDate(_ date: Date) {
        //writeView.contentTextField.text = dateFormatter.string(from: date)
        dateString = dateFormatter.string(from: date)
        print("\(date)")
        savedDate = date
        guard let selectedCell = collectionViewDataSource.itemIdentifier(for: IndexPath(row: 0, section: 0)) else { return }
        var newSnaShot = collectionViewDataSource.snapshot()
        newSnaShot.reloadItems([selectedCell])
        collectionViewDataSource.apply(newSnaShot, animatingDifferences: true)
    }
}


extension WriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.section)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                showSheetPresentatilnController()
            default:
                guard let selectedCell = collectionViewDataSource.itemIdentifier(for: IndexPath(row: 1, section: 0)) else { return }
                selectedCell.value += 1
                print(selectedCell.value)
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
//    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//        print("칼라 선택 끝")
//
//        switch sectionIndexPath?.section {
//        case 0:
//
//        default:
//            print("fdsfdsfds")
//        }
//    }
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










class MyUICollectionViewListCell: UICollectionViewListCell {
    let button = UIColorWell(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        button.addTarget(self, action: #selector(colortWellVaueChanged), for: .valueChanged)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure() {
        self.addSubview(button)
        
        
    }
    
    
    @objc
    func colortWellVaueChanged() {
        print("fdsfdsfsdfsd")
        self.backgroundColor = button.selectedColor
        
    }
    
    func setConstraints() {
        button.snp.makeConstraints {
            $0.centerY.equalTo(self.snp.centerY)
            $0.trailing.equalTo(self).inset(10)
        }
    }
}
