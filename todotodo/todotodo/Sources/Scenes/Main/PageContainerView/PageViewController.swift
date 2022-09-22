
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel
import RealmSwift



class PageViewController: BaseViewController {
    
    let pageView = PageView()
    override func loadView() {
        self.view = pageView
    }
    
    let repository = ToDoRepository()
    
    let fpc = FloatingPanelController()
    let contentVC = WriteViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ToDo>!
    var contentConfiguration: UIListContentConfiguration!
    
    var SectionDataStore = SectionWeek.allCases.map { $0.title }
    var sectionArray = SectionWeek.allCases.map { $0 } //[]
    var isSelectedMonth: Month? //ex 3월 --> march
    var weekStatus: SectionWeek? = .week5
    var a: [String] = []
    
    var todoList: Results<ToDo> {
        return repository.fetch()
    }
    

    
    
    var weekList: [Results<ToDo>] = []
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }
    
    
    
    override func configure() {
        pageView.collectionView.delegate = self
        
        
        registerSectionHeaterView()
        configureCollectionViewDataSource()
        //applyInitialSnapShot()
        

    }
    
}




extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("♥️♥️♥️\(todoList)")
        snapShot(month: isSelectedMonth!)
        //configureSnapShot(month: isSelectedMonth!)
//        configureSnapShot2()
    }
}


// MARK: - DataSource, applySnapShot
extension PageViewController {
    
    //헤더등록
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
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }
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
        newSnapshot.deleteItems(repository.fetch().toArray())
        newSnapshot.appendSections([.week1])
        newSnapshot.appendItems(repository.filterMonth(currentMonth: month).toArray())
        collectionViewDataSource.apply(newSnapshot)
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
        print("\(fpc.surfaceLocation.y)")
        print("\(fpc.surfaceLocation(for: .tip).y)")
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

