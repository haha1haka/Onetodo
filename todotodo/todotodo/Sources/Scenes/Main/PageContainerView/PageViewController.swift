//
//  PageViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/11.
//

import UIKit

import UIKit
import SnapKit

class ListViewController: UIViewController {
    
}
enum MyCalendar: Int {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    

    
    
//     var weekCounter: Int {
//        switch self {
//        case .january:
//            return makeNumberOfWeeksPerMonth(month: .january)
//        case .february:
//            return makeNumberOfWeeksPerMonth(month: .february)
//        case .march:
//            return makeNumberOfWeeksPerMonth(month: .march)
//        case .april:
//            return makeNumberOfWeeksPerMonth(month: .april)
//        case .may:
//            return makeNumberOfWeeksPerMonth(month: .may)
//        case .june:
//            return makeNumberOfWeeksPerMonth(month: .june)
//        case .july:
//            return makeNumberOfWeeksPerMonth(month: .july)
//        case .august:
//            return makeNumberOfWeeksPerMonth(month: .august)
//        case .september:
//            return makeNumberOfWeeksPerMonth(month: .september)
//        case .october:
//            return makeNumberOfWeeksPerMonth(month: .october)
//        case .november:
//            return makeNumberOfWeeksPerMonth(month: .november)
//        case .december:
//            return makeNumberOfWeeksPerMonth(month: .december)
//        }
//    }
}


class PageViewController: UIViewController {
    
    lazy var mainCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
        view.backgroundColor = .systemMint
        view.delegate = self
        return view
    }()

    var collectionView1DataSource: UICollectionViewDiffableDataSource<String, String>!
    var collectionView2DataSource: UICollectionViewDiffableDataSource<String, String>!
    
    var dataStore: [Int] = []
    
    var a: [String] = []
    
    
}






extension PageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionViewDataSource()
        applySnapshot(month: dataStore.first!)
        
        configureCollectionView()
        print("🟪\(dataStore)")
        
        
    }
    
}

extension PageViewController {
    func configureCollectionView() {
        view.addSubview(mainCollectionView)
        mainCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func makeNumberOfWeeksPerMonth(month: Int)  {
        let pointDateComponent = DateComponents( year: 2022, month: month)
        let calendar2 = Calendar.current
        let hateDay = calendar2.date(from: pointDateComponent) // ⭐️내날짜 -> 인스턴스화


        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfMonth,
                                       in: .month,
                                       for: hateDay!)
        
        for i in weekRange! {
            a.append(String(i) + "주")
        }
        
    }
    func makeWeek() {
        //map 으로 1월 , 2월 3월 들어 옴
        //들어오면서 vc 를 만들때 셀에 갯수를 다르게 만들어야됨.ㄴ
        //그럼 일단 1월 에서 "월"을 빼고 1에 대한 weekRange 만들기
        // 그걸로, 담아 놨다가 셀 그리기
    }
}





// MARK: - CompositionalLayout + CollectionViewDiffableDataSource
extension PageViewController {
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        itemLayout.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 16
        return UICollectionViewCompositionalLayout(section: sectionLayout)
    }
    
    
    func configureCollectionViewDataSource() {
        let mainCellRegistration = UICollectionView.CellRegistration<PageCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }

        collectionView1DataSource = .init(collectionView: mainCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
//    func configureCollectionViewDataSource2() {
//        let mainCellRegistration = UICollectionView.CellRegistration<KeywordCell, String> { cell,indexPath,itemIdentifier in
//            cell.configureCell(itemIdentifier: itemIdentifier)
//        }
//
//        collectionView1DataSource = .init(collectionView: PageCell.collectionView) { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
//            return cell
//        }
//    }
    
    
    func applySnapshot(animatingDifferences: Bool = true, month: Int) {
        
        let numberofWeekPerMonth = makeNumberOfWeeksPerMonth(month: month)
        
        var snapshot = collectionView1DataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(a, toSection: "topic")
        collectionView1DataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.mainCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
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
