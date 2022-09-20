
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel
import RealmSwift

enum Section2 {
    case main
}

struct Itme2: Hashable {

    
    var title: String
    

}



class PageViewController: BaseViewController {
    
    let pageView = PageView()
    override func loadView() {
        self.view = pageView
    }
    
    let repository = ToDoRepository()
    
    let fpc = FloatingPanelController()
    let contentVC = WriteViewController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Month, ToDo>!
    var contentConfiguration: UIListContentConfiguration!
    
    var SectionDataStore = SectionWeek.allCases.map { $0.title }
    var dataStore: [String] = []
    var a: [String] = []

    var ToDoArray: Results<ToDo> {
        return repository.fetch()
        print("""
             ♻️♻️♻️♻️♻️♻️♻️♻️♻️♻️
            """)
    }
    
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
        applyInitialSnapShot()
        
        print("🟪\(dataStore)")
    }
}


extension PageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}


// MARK: - DataSource, applySnapShot
extension PageViewController {
    
    //헤더뷰2🥹
    func registerSectionHeaterView() {
        pageView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }

    func configureCollectionViewDataSource() {
        
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,ToDo> {  [weak self] cell,  indexPath, itemIdentifier in
            guard let self = self else { return }
            self.contentConfiguration = cell.defaultContentConfiguration()
            self.contentConfiguration.text = itemIdentifier.content
            self.contentConfiguration.attributedText = nil
            self.contentConfiguration.secondaryText = self.dateFormatter.string(from: itemIdentifier.date)
            self.contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            //cell.backgroundColor = .red
            //self.contentConfiguration = self.contentConfiguration
        }
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
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

//    func applySnapshot(animatingDifferences: Bool = true) {
//        //makeNumberOfWeeksPerMonth(month: month)
//        var snapshot = collectionViewDataSource.snapshot()
//        snapshot.appendSections([.week1, .week2, .week3, .week4, .week5, .week6, .week7])
//        sections.forEach { section in
//            snapshot.appendItems(, toSection: .week1)
//        }
//        collectionViewDataSource.apply(snapshot) { [weak self] in
//            guard let this = self else { return }
//            this.pageView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
//        }
//    }
    
    func applyInitialSnapShot() {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections([.jan])
        snapshot.appendItems(ToDoArray.map{$0})
        collectionViewDataSource.apply(snapshot)
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

