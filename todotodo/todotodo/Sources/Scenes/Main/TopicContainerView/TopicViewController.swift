//
//  TopicViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit

protocol TopicViewControllerEvent: AnyObject {
    func topic(_ viewController: TopicViewController, didSelectItem: Month)
}

class TopicViewController: BaseViewController {
    
    let topicView = TopicView()
    override func loadView() {
        self.view = topicView
    }
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, Month>!
    var topicDataStore = Month.allCases.map { $0.title } // ["1월", ... , "12월"]
    var months = Month.allCases //[Month]
    weak var eventDelegate: TopicViewControllerEvent?
    

    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapShot(items: months)
        topicView.collectionView.delegate = self
    }
}




// MARK: - DataSource, applySnapShot
extension TopicViewController {
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<TopicCell, Month> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: topicView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.topicView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func applySnapShot(items: [Month]) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(items, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in
            self?.topicView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}




// MARK: - UICollectionViewDelegate - didSelectItemAt
extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath) {
            eventDelegate?.topic(self, didSelectItem: itemIdentifier)
        }
    }
}
