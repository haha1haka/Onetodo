//
//  ListViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit

class ListViewController: BaseViewController {

    let listView = ListView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!

    var todo = ["전화하기", "자전거타기", "물마시기", "놀기1","전화하기1", "자전거타기1", "물마시기1", "놀기2","전화하기2", "자전거타기2", "물마시기2", "놀기3","전화하기3", "자전거타기3", "물마시기3", "놀기4","전화하기4", "자전거타기4", "물마시기4", "놀기5"]
    
    override func loadView() {
        self.view = listView
    }


    override func configure() {
        view.backgroundColor = .lightGray
        configureCollectionViewDataSource()
        applySnapshot()
    }


}






extension ListViewController {

    func configureCollectionViewDataSource() {
        let mainCellRegistration = UICollectionView.CellRegistration<ListCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }

        collectionViewDataSource = .init(collectionView: listView.mainCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            cell.backgroundColor = .white
            return cell
        }
    }

    
    
    func applySnapshot(animatingDifferences: Bool = true) {
        
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(todo, toSection: "topic")
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.listView.mainCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }

}



