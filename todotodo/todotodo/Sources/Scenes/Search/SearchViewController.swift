//
//  SearchViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/23.
//

import UIKit
import RealmSwift
import SnapKit

enum SearchSection: CaseIterable {
    case main
}

class SearchViewController: UIViewController {

    let repository = ToDoRepository()
    
    var allTodoObjects: Results<ToDo> {
        return repository.fetch()
    }
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = ColorType.backgroundColorSet
        return view
    }()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<SearchSection, ToDo>!
    
    var isSearchControllerFiltering: Bool {
        guard let searchController = self.navigationItem.searchController, let searchBarText = self.navigationItem.searchController?.searchBar.text else { return false }
        let isActive = searchController.isActive
        let hasText = searchBarText.isEmpty == false
        return isActive && hasText
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureUINavigationBar()
        configureViewConstraints()
        configureCollectionViewDataSource()
        applyInitialSnapShot()
        //setBlur()
    }

    
    func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func configureUINavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Onetodo"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = ColorType.backgroundColorSet
        //navigationController?.navigationBar.backdr
        appearance.backgroundImage = UIImage()
        appearance.backgroundEffect = nil
        appearance.shadowImage = UIImage()
        //navigationController?.navigationBar.backgroundColor = .red
        appearance.shadowColor = .clear
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    func configureViewConstraints() {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
//    func setBlur() {
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.bounds
//        self.view.addSubview(blurEffectView)
//        self.view.sendSubviewToBack(blurEffectView)
//        blurEffectView.layer.cornerRadius = 35
//        blurEffectView.clipsToBounds = true
//    }

}


extension SearchViewController {
        
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            //1️⃣ Item, Group Section Layout
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.edgeSpacing = .init(leading: .fixed(8), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }, configuration: configuration)
    }
    
    
    
    
    func configureCollectionViewDataSource() {
        
        // 1️⃣ Cell
        let cellRegistration = UICollectionView.CellRegistration<SearchCell,ToDo> { cell,  indexPath, itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        collectionViewDataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)

            //cell.backgroundColor = .random
            //cell.layer.backgroundColor = UIColor.random.cgColor

            //cell.layer.borderWidth = 1
            cell.layer.masksToBounds = true
            cell.backgroundColor = UIColor(hex: itemIdentifier.backgroundColor)
            cell.label.textColor = UIColor(hex: itemIdentifier.labelColor)
            
            return cell
        }

    }
    
    func applyInitialSnapShot() {
        var snapShot = collectionViewDataSource.snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(allTodoObjects.toArray())
        collectionViewDataSource.apply(snapShot,animatingDifferences: true)
    }
    
    func searchingSnapShot() {
        
    }
    
    
}




extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchController = self.navigationItem.searchController, let text = self.navigationItem.searchController?.searchBar.text else { return }
        
        if self.isSearchControllerFiltering || searchController.isActive {
            var newSnapShot = NSDiffableDataSourceSnapshot<SearchSection, ToDo>()
            //var snapshot = collectionViewDataSource.snapshot()
            //newSnapShot.deleteItems(repository.fetch().toArray())
            newSnapShot.appendSections([.main])
            newSnapShot.appendItems(repository.fetch().filter { element in
                let content = element.title
                return content.localizedStandardContains(text)
            })
            collectionViewDataSource.apply(newSnapShot, animatingDifferences: true)
        }
        
        if !searchController.isActive {
            
            var snapShot = collectionViewDataSource.snapshot()
            snapShot.deleteAllItems()
            snapShot.appendSections([.main])
            snapShot.appendItems(allTodoObjects.toArray())
            collectionViewDataSource.apply(snapShot,animatingDifferences: true)
        }
        
    

    }
    
}
