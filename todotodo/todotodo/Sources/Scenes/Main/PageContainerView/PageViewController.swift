
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel
import RealmSwift


protocol PageViewControllerEvent: AnyObject {
    func item(_ viewController: PageViewController, itemidentifier: ToDo, identifier: dataPassType)
}

class PageViewController: BaseViewController {

    let pageView = PageView()
    override func loadView() {
        self.view = pageView
    }
    
    let repository = ToDoRepository()
    
    let backFloatingPanel = FloatingPanelController()
    let floatingPanel = WriteViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ToDo>!
    
    var delegate: PageViewControllerEvent?
    
    var selectedMonth: Month?
    
    var totalWeek: [[ToDo]] = []

    //⚠️하 이거 개선해보기
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
    
    override func configure() {
        pageView.collectionView.delegate = self
        registerSectionHeaterView()
        
        print("🗂🗂🗂🗂\(repository.database.configuration.fileURL!)🗂🗂🗂🗂")
    }
}



// MARK: - LifeCycle
extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalWeek = [firstWeek, secondWeek, thirdWeek, fourthWeek, fiveWeek, sixWeek]
        print("fasdfsdfsdfsdfsdfsadfsdfsadfas✅")
        configureCollectionViewDataSource()
        applySnapShot()
    }
}


// MARK: - HeaderRegister, DataSource, applySnapShot Methods
extension PageViewController {

    func registerSectionHeaterView() {
        pageView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<PageCell,ToDo> { cell,  indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
            cell.label.textColor = UIColor(hex: itemIdentifier.labelColor)
            cell.backgroundColor = UIColor(hex: itemIdentifier.backgroundColor)

            if itemIdentifier.completed {
                cell.label.attributedText = itemIdentifier.title.strikeThrough()
                cell.backgroundColor = ColorType.completeColorSet //⚠️리터럴제거하기
                //⭐️ todayPanel 에도 레이블 strike 랑, backgroundColor 적용 해주기
            }
        }
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>.init( elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self, let sectionIdentifier = self.collectionViewDataSource.sectionIdentifier(for: indexPath.section) else { return }
            supplementaryView.titleLabel.text = sectionIdentifier.title
        }
        collectionViewDataSource.supplementaryViewProvider = .some({ collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        })
    }
    //⚠️ Section 구조화 하기
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
    
    func configureContextMenu(item: ToDo) -> UIContextMenuConfiguration {
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
                let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                    let writeViewController = WriteViewController()
                    writeViewController.configureData(item: item)
                    self.transition(writeViewController, transitionStyle: .push)
                }
                
                let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                    
                    self.delegate?.item(self, itemidentifier: item, identifier: .delete)

                    var newSnapShot = self.collectionViewDataSource.snapshot()
                    let currentSection = newSnapShot.sectionIdentifier(containingItem: item)
                    if newSnapShot.itemIdentifiers(inSection: currentSection!).count == 1 {
                        newSnapShot.deleteSections([currentSection!])
                    }
                    newSnapShot.deleteItems([item])
                    self.collectionViewDataSource.apply(newSnapShot)
                    self.repository.deleteItem(item: item)
                }
                return UIMenu(title: "Onetodo", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            }
            return context
        }
}



// MARK: - CollectionViewDelegate
extension PageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = collectionViewDataSource.itemIdentifier(for: indexPath) else { return }
        repository.updateComplete(item: selectedItem)
        var snapShot = collectionViewDataSource.snapshot()
        snapShot.reloadItems([selectedItem])
        collectionViewDataSource.apply(snapShot, animatingDifferences: true)
        self.delegate?.item(self, itemidentifier: selectedItem, identifier: .completed)
        //⚠️ int로 구별하는거 enum 으로 개선해보기
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let selectedItem = collectionViewDataSource.itemIdentifier(for: indexPath) else { return nil }
        return configureContextMenu(item: selectedItem)
    }
}
