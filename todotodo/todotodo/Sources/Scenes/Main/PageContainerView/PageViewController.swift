//
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit
import FloatingPanel


class PageViewController: BaseViewController {
    
    let pageView = PageView()

    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ItemDay>!
    
    var sections = SectionWeek.allSections
    var dataStore: [Int] = []
    var a: [String] = []
    
    
    let fpc = FloatingPanelController()
    let contentVC = DetailViewController()
    
    
    override func loadView() {
        self.view = pageView
    }
    
    override func configure() {
        configureCollectionViewDataSource()
        
        applySnapshot(month: dataStore.first!)
        pageView.collectionView.delegate = self
        print("🟪\(dataStore)")
        
        pageView.collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
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
        
        //1
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,ItemDay> { cell,  indexPath, itemIdentifier in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = itemIdentifier.dateStringLable
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = contentConfiguration
        }
        
        //2
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
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
    

    
    
    func applySnapshot(animatingDifferences: Bool = true, month: Int) {
        makeNumberOfWeeksPerMonth(month: month)
        var snapshot = collectionViewDataSource.snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.days, toSection: section)
        }
        collectionViewDataSource.apply(snapshot) { [weak self] in
            guard let this = self else { return }
            this.pageView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
}




// MARK: - CollectionViewDelegate
extension PageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let detailViewController = DetailViewController()
        //transition(detailViewController, transitionStyle: .push)
        
        
        fpc.set(contentViewController: contentVC)
        fpc.layout = MyFloatingPanelLayout2()
        fpc.isRemovalInteractionEnabled = true // Optional: Let it removable by a swipe-down
//        UIView.animate(withDuration: 0.25) { [weak self] in
//            fpc.move(to: .full, animated: false)
//        }
        
        
        fpc.delegate = self
        fpc.changePanelStyle()
        fpc.behavior = FloatingPanelStocksBehavior()
        //fpc.show()
        
        
        self.present(fpc, animated: true, completion: nil)
    }
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        
        print("\(fpc.surfaceLocation.y)")
        print("\(fpc.surfaceLocation(for: .tip).y)")
        if fpc.surfaceLocation.y >= fpc.surfaceLocation(for: .tip).y - 100 {
            print("🟧🟧🟧🟧🟧🟧🟧")
            contentVC.dismiss(animated: true)
        }
        
    }
}

extension PageViewController: FloatingPanelControllerDelegate {
  
    func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
        if fpc.state == .full {
            print("🍠🍠🍠")
                fp_dismiss(animated: true)
            } else {

            }
        }
    
}






//1
//        let mainCellRegistration = UICollectionView.CellRegistration<PageCell, ItemDay> { cell,indexPath,itemIdentifier in
//            cell.configureCell(itemIdentifier: itemIdentifier)
//        }

