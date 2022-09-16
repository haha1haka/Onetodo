//
//  PanelViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/13.
//

import UIKit
import SnapKit


class Section: Hashable {
    var id = UUID()
    
    var title: String
    var todos: [ToDo]
    
    init(title: String, todos: [ToDo]) {
        self.title = title
        self.todos = todos
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
extension Section {
  static var allSections: [Section] = [Section(title: "화", todos: [ToDo(todoLabel: "밥먹기"),
                                                                   ToDo(todoLabel: "자전거타기"),
                                                                   ToDo(todoLabel: "엄마한테 전화하기")
                                                                  ]
                                              )
                                      ]
}


struct ToDo: Hashable {
    var todoLabel: String
}



class PanelViewController: BaseViewController {
    
    let panelView = PanelView()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<Section, ToDo>!
    
    var sections = Section.allSections
    
    
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ToDo>
    
    
    override func loadView() {
        self.view = panelView
        
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        applySnapshot()
        
        
        panelView.collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.identifier)
        
        
        
      
    }
    
}




// MARK: - CollectionViewDiffableDataSource
extension PanelViewController {
    
    
    func configureCollectionViewDataSource() {
        let topicCellRegistration = UICollectionView.CellRegistration<PanelCell, ToDo> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }
        
        
        collectionViewDataSource = .init(collectionView: panelView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = self.panelView.collectionView.dequeueConfiguredReusableCell(using: topicCellRegistration, for: indexPath, item: itemIdentifier)
            cell.content.text = itemIdentifier.todoLabel
            return cell
        }
        
        
        collectionViewDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            // 4
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            // 5
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.identifier, for: indexPath) as? SectionHeaderReusableView
            // 6
            let section = self.collectionViewDataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            
            return view
        }
    }
    
    
    
    
    
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.todos, toSection: section)
        }
        collectionViewDataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.panelView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
}






