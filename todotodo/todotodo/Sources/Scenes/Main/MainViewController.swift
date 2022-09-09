//
//  ViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

//typealias DataSource = UICollectionViewDiffableDataSource<Section, Video>
//typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Video>

import UIKit

class MainViewController: BaseViewController {

    let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
        mainView.collectionView.delegate = self
        configureUINavigationBar()
    }
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, String>!
}






extension MainViewController {
    func configureUINavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "todotodo"
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = COLOR_BRANDI_PRIMARY
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}





// MARK: - CollectionViewDiffableDataSource
extension MainViewController {
    func configureCollectionViewDataSource() {
        let mainCellRegistration = UICollectionView.CellRegistration<MainCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: mainView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
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
            this.mainView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}




// MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        transition(detailViewController, transitionStyle: .push)
    }
}
