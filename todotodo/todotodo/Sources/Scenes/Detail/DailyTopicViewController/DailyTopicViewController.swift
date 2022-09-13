//
//  DailyTopicViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/12.
//

import UIKit

protocol DailyTopicViewControllerEvent: AnyObject {
    func topic(_ viewController: DailyViewController, didSelectItem: String)
}

class DailyViewController: BaseViewController {

    let dailyTopicView = DailyTopicView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
    var dummyDatas = ["월", "화", "수", "목", "금", "토", "일"]
    
    weak var eventDelegate: DailyTopicViewControllerEvent?
    
    override func loadView() {
        self.view = dailyTopicView
    }
    
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
        dailyTopicView.collectionView.delegate = self
        
    }
    

}








// MARK: - CollectionViewDiffableDataSource
extension DailyViewController {
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<DailyTopicCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: dailyTopicView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(dummyDatas, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.dailyTopicView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }

}




// MARK: - CollectionViewDelegate


extension DailyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath) {
            eventDelegate?.topic(self, didSelectItem: itemIdentifier)
        }
    }
}

