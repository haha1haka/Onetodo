//
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit


class PageViewController: BaseViewController {
    
    let pageView = PageView()

    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    var dataStore: [Int] = []
    
    var a: [String] = []
    
    override func loadView() {
        self.view = pageView
    }
    override func configure() {
        
        configureCollectionViewDataSource()
        applySnapshot(month: dataStore.first!)
        pageView.collectionView.delegate = self
        print("🟪\(dataStore)")
    }
    
}




extension PageViewController {

    func makeNumberOfWeeksPerMonth(month: Int)  {
        let pointDateComponent = DateComponents( year: 2022, month: month)
        let calendar2 = Calendar.current
        let hateDay = calendar2.date(from: pointDateComponent)
        
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: hateDay!)
        for i in weekRange! {
            a.append(String(i) + "주")
        }
    }
    
}





// MARK: - CollectionViewDiffableDataSource
extension PageViewController {

    func configureCollectionViewDataSource() {
        let mainCellRegistration = UICollectionView.CellRegistration<PageCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    func applySnapshot(animatingDifferences: Bool = true, month: Int) {
        
        makeNumberOfWeeksPerMonth(month: month)
        
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(a, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.pageView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}




// MARK: - CollectionViewDelegate
extension PageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        transition(detailViewController, transitionStyle: .push)
    }
}
