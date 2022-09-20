//
//  DidSelectPanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit



struct TodoStatus: Hashable {
    var title: String
    var items: [Item]
}

struct Item: Hashable {
    var todo: String?
}

extension TodoStatus {
  static var allSections: [TodoStatus] = [TodoStatus(title: "한눈에 보기",
                                                     items: []),
                                          TodoStatus(title: "완료 • 미완료 상태",
                                                     items: [
                                                            Item(todo: "밥먹기"),
                                                            Item(todo: "말타기"),
                                                            Item(todo: "자전거 타기")]),
                                         TodoStatus(title: "Optional", items: [])
                                        ]
}



class MainPanelViewController: BaseViewController {
    
    let mainPanelView = MainPanelView()
    var collectionViewDataSource: UICollectionViewDiffableDataSource<TodoStatus, Item>!
    var sections = TodoStatus.allSections
    
    override func loadView() {
        self.view = mainPanelView
    }
    
    override func configure() {
        mainPanelView.backgroundColor = .red
        configureCollectionViewDataSource()
        applySnapshot()
        registerSectionHeaderView()
    }
}





extension MainPanelViewController {
    
    func registerSectionHeaderView() {
        mainPanelView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Item> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = itemIdentifier.todo
            
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = contentConfiguration
            
//            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
//            backgroundConfig.backgroundColor = UIColor(named: "CellColor")
//            backgroundConfig.strokeColor = .green
//            cell.backgroundConfiguration = backgroundConfig
            
            var background = UIBackgroundConfiguration.listGroupedCell()
              background.backgroundColorTransformer = UIConfigurationColorTransformer { [weak cell] c in
                guard let state = cell?.configurationState else { return .darkGray }
                return state.isSelected || state.isHighlighted ? .green : .clear
              }
              cell.backgroundConfiguration = background
        }
        
        
        //2
        collectionViewDataSource = .init(collectionView: mainPanelView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        }



        //3
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView
            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }


    }




    func applySnapshot(animatingDifferences: Bool = true) {
        //makeNumberOfWeeksPerMonth(month: month)
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        collectionViewDataSource.apply(snapshot) { [weak self] in
            guard let this = self else { return }
            this.mainPanelView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}
