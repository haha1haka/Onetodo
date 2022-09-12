//
//  TopicViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit

protocol TopicViewControllerEvent: AnyObject {
    func topic(_ viewController: TopicViewController, didSelectItem: String)
}

class TopicViewController: BaseViewController {

    let topicView = TopicView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    
    weak var eventDelegate: TopicViewControllerEvent?
    
    override func loadView() {
        self.view = topicView
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
        topicView.topicCollectionView.delegate = self
        
    }
    

}








// MARK: - CollectionViewDiffableDataSource
extension TopicViewController {
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<TopicCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: topicView.topicCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems([
            "1월", "2월", "3월", "4월", "5월",
            "6월", "7월", "8월", "9월", "10월",
            "11월", "12월"], toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.topicView.topicCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    
//    func applyInitialData(items: [String]) {
//        var snapshot = collectionViewDataSource.snapshot()
//        snapshot.appendSections(["topic"])
//        snapshot.appendItems(items, toSection: "topic")
//        collectionViewDataSource.apply(snapshot) { [weak self] in
//            guard let this = self else { return }
//            this.topicView.topicCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
//        }
//    }
    
    

    
    
}




// MARK: - CollectionViewDelegate
//extension TopicViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailViewController = DetailViewController()
//        transition(detailViewController, transitionStyle: .push)
//    }
//}

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath) {
            eventDelegate?.topic(self, didSelectItem: itemIdentifier)
        }
    }
}
