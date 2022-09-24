
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
    
    var isSelectedMonth: Month? //ex 3월 --> march
    
    var delegate: passUISearchResultsUpdating?
    
    var todoList: Results<ToDo> {
        return repository.fetch()
    }
    var isFilterling: Bool?
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }
    
    
    var firstWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week1)
    }
    var secondWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week2)
    }
    var thirdWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week3)
    }
    var fourthWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week4)
    }
    var fiveWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week5)
    }
    var sixWeek: Results<ToDo> {
        return repository.filterWeek(currentMonth: isSelectedMonth!, currnetWeek: .week6)
    }

    override func configure() {
        pageView.collectionView.delegate = self
        registerSectionHeaterView()
        configureCollectionViewDataSource()
    }
    //let mainVC = MainViewController()
}




extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("✅✅✅\(todoList)")
        print("🖍🖍🖍🖍\(isSelectedMonth)")
        snapShot(month: isSelectedMonth!)
        
        //mainVC.delegate = self
    }
}


// MARK: - HeaderRegister, DataSource, applySnapShot Methods
extension PageViewController {
    
    //
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
            cell.backgroundView?.backgroundColor = .red
            cell.backgroundColor = .random
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
    
    
    func applyInitialSnapShot(month: Month) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.deleteItems(repository.fetch().toArray())
        snapshot.appendSections([.week1])
        snapshot.appendItems(repository.filterMonth(currentMonth: month).toArray())
        collectionViewDataSource.apply(snapshot)
    }
    
    func snapShot(month: Month) {
        var newSnapshot = NSDiffableDataSourceSnapshot<SectionWeek, ToDo>()
        newSnapshot.deleteItems(repository.fetch().toArray()) //다른 화면 갔다 왔을 경우 때문에.
        newSnapshot.appendSections([.week1])
        newSnapshot.appendItems(repository.filterMonth(currentMonth: month).toArray())
        collectionViewDataSource.apply(newSnapshot)
        //collectionViewDataSource에 item들 많이 있는상태
    }
    
    func searchSnapShot() {
        
    }
    
//    var isSearchControllerFiltering: Bool {
//        guard let searchController = self.navigationItem.searchController, let searchBarText = self.navigationItem.searchController?.searchBar.text else { return false }
//        let isActive = searchController.isActive
//        let hasText = searchBarText.isEmpty == false
//        return isActive && hasText
//    }

}

extension PageViewController: passUISearchResultsUpdating {
//    func pass(,searchController: UISearchController, searchedText: String) {
//        <#code#>
//    }
    func pass(_ viewController: MainViewController, searchController: UISearchController, searchedText: String) {
        if viewController.isSearchControllerFiltering || searchController.isActive {
             //pageVC 에서 생성한 이 매서드 넘겨주기
            //writeVC.delgate = self  -> 다음
            
            print("🥧🥧🥧🥧\(searchedText)")
            var snapShot = self.collectionViewDataSource.snapshot()
            snapShot.deleteItems(self.repository.fetch().toArray())
            snapShot.appendSections([.week1])
            snapShot.appendItems(self.repository.fetch().toArray())
            //contentVC.collectionViewDataSource.apply(snapShot, to: .)
            collectionViewDataSource.apply(snapShot)
            
            
        }
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








//extension PageViewController {
//
//    func makeNumberOfWeeksPerMonth(month: Int)  {
//        let pointDateComponent = DateComponents( year: 2022, month: month)
//        let calendar2 = Calendar.current
//        let hateDay = calendar2.date(from: pointDateComponent)
//
//        let calendar = Calendar.current
//        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: hateDay!)
//        for i in weekRange! {
//            a.append(String(i) + "주")
//        }
//    }
//
//}

