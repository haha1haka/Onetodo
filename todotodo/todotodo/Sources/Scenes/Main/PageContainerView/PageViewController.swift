
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel
import RealmSwift

//protocol PageViewControllerDatasourceDelegate: AnyObject {
//    func datasource(viewController: PageViewController, datasource: UICollectionViewDiffableDataSource<SectionWeek, ToDo>)
//}


enum SectionWeek:Int, CaseIterable {
    case week1 = 1, week2, week3, week4, week5, week6, week7
    
    var title: String {
        switch self {
        case .week1:
            return "1주차"
        case .week2:
            return "2주차"
        case .week3:
            return "3주차"
        case .week4:
            return "4주차"
        case .week5:
            return "5주차"
        case .week6:
            return "6주차"
        case .week7:
            return "7주차"
        }
    }
}


class PageViewController: BaseViewController {
    
    let pageView = PageView()
    override func loadView() {
        self.view = pageView
    }
    
    let repository = ToDoRepository()
    
    let fpc = FloatingPanelController()
    let contentVC = WriteViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ToDo>!
    
    var selectedMonth: Month?

    var firstWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week1)
    }
    var secondWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week2)
    }
    var thirdWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week3)
    }
    var fourthWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week4)
    }
    var fiveWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week5)
    }
    var sixWeek: [ToDo] {
        return repository.filteringWeek(currentMonth: selectedMonth!, currentWeek: .week6)
    }
    var totalWeek: [[ToDo]] = []

    override func configure() {
        pageView.collectionView.delegate = self
        registerSectionHeaterView()
        configureCollectionViewDataSource()
        print("🗂🗂🗂🗂\(repository.database.configuration.fileURL!)🗂🗂🗂🗂")
    }
}




extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalWeek = [firstWeek, secondWeek, thirdWeek, fourthWeek, fiveWeek, sixWeek]
        applySnapShot()
    }
}


// MARK: - HeaderRegister, DataSource, applySnapShot Methods
extension PageViewController {
    
    func registerSectionHeaterView() {
        pageView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<PageCell,ToDo> { cell,  indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.label.textColor = UIColor(hex: itemIdentifier.labelColor)
            cell.backgroundColor = UIColor(hex: itemIdentifier.backgroundColor)
            return cell
        }
        
        // 2️⃣ Header
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>.init( elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier.title
        }
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })

    }
    
    
    func applySnapShot() {
        var newSnapShot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
        newSnapShot.deleteItems(repository.fetch().toArray())
        for (section, item) in totalWeek.enumerated() {
            if !item.isEmpty {
                newSnapShot.appendSections([SectionWeek(rawValue: section+1)!])
                newSnapShot.appendItems(item)
            }
        }
        collectionViewDataSource.apply(newSnapShot)
    }
}



// MARK: - CollectionViewDelegate
extension PageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fpc.set(contentViewController: contentVC)
        fpc.layout = MyFloatingPanelLayout2()
        fpc.isRemovalInteractionEnabled = true
        fpc.delegate = self
        fpc.changePanelStyle()
        fpc.behavior = MyFloatingPanelBehavior()
        self.present(fpc, animated: true, completion: nil)
    }
}



// MARK: - FloatingPanelControllerDelegate
extension PageViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.surfaceLocation.y >= fpc.surfaceLocation(for: .tip).y - 100 {
            print("🟧🟧🟧🟧🟧🟧🟧")
            contentVC.dismiss(animated: true)
        }
    }
}
