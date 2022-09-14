//
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit
import SnapKit


//class SectionWeek: Hashable {
//    var id = UUID()
//
//    var title: String
//    var days: [ItemDay]
//
//    init(title: String, days: [ItemDay]) {
//        self.title = title
//        self.days = days
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    static func == (lhs: SectionWeek, rhs: SectionWeek) -> Bool {
//        lhs.id == rhs.id
//    }
//}

struct SectionWeek: Hashable {
    var title: String
    var days: [ItemDay]
}

struct ItemDay: Hashable {
    var dateNumberLable: String
    var dateStringLable: String
    var contentLabel: [String]
}

extension SectionWeek {
  static var allSections: [SectionWeek] = [
    SectionWeek(title: "1 주차", days: [ItemDay(dateNumberLable: "7", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "8", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "9", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "10", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "11", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "12", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "13", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "2 주차", days: [ItemDay(dateNumberLable: "14", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "15", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "16", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "17", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "18", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "19", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "20", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "3 주차", days: [ItemDay(dateNumberLable: "21", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "22", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "23", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "24", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "25", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "26", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "27", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "4 주차", days: [ItemDay(dateNumberLable: "28", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "29", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "30", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "31", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "32", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "33", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "34", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               ),
    SectionWeek(title: "5 주차", days: [ItemDay(dateNumberLable: "35", dateStringLable: "월", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "36", dateStringLable: "화", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "37", dateStringLable: "수", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "38", dateStringLable: "목", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "39", dateStringLable: "금", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "40", dateStringLable: "토", contentLabel: ["놀기","밥먹기"]),
                                      ItemDay(dateNumberLable: "41", dateStringLable: "일", contentLabel: ["놀기","밥먹기"])
                                     ]
               )
    
  ]
}



class PageViewController: BaseViewController {
    
    let pageView = PageView()

    var collectionViewDataSource: UICollectionViewDiffableDataSource<SectionWeek, ItemDay>!
    
    
    var sections = SectionWeek.allSections
    
    
    var dataStore: [Int] = []
    
    var a: [String] = []
    
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
        let mainCellRegistration = UICollectionView.CellRegistration<PageCell, ItemDay> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
            //cell.layer.cornerRadius = 8
            //cell.layer.masksToBounds = true
        }
        collectionViewDataSource = .init(collectionView: pageView.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
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
        let detailViewController = DetailViewController()
        transition(detailViewController, transitionStyle: .push)
    }
}
