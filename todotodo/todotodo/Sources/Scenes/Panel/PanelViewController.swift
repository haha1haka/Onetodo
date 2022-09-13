//
//  PanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import UIKit




class PanelViewController: BaseViewController {
    
    
    let panelView = PanelView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    var dummyDatas = [
        "1월", "2월", "3월", "4월", "5월",
        "6월", "7월", "8월", "9월", "10월",
        "11월", "12월"]
    
    override func loadView() {
        self.view = panelView
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
    }
    
}




// MARK: - CollectionViewDiffableDataSource
extension PanelViewController {
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<TopicCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: panelView.collectionView) { ㄱr, indexPath, itemIdentifier in
            let cell = self.panelView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(dummyDatas, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.panelView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}
