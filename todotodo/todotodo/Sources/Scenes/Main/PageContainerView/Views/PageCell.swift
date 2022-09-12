//
//  MainCell.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit

class PageCell: BaseUICollectionViewCell {
    var collectionView2DataSource: UICollectionViewDiffableDataSource<String, String>!
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = .systemGreen
        view.textColor = .white
        view.font = .systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.backgroundColor = .blue
        return view
    }()
    
    override func configure() {
        self.addSubview(label)
        self.addSubview(collectionView)
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        configureCollectionViewDataSource()
        applySnapshot2()
    }
    
    override func setConstraints() {
        label.snp.makeConstraints {
            $0.top.leading.equalTo(self).offset(10)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self).offset(100)
            $0.trailing.leading.bottom.equalTo(self).inset(20)
        }
        
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1.0))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let groupLayoutSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .absolute(44))
        let groupLayout = NSCollectionLayoutGroup.vertical(layoutSize: groupLayoutSize, subitems: [itemLayout])
        let sectionLayout = NSCollectionLayoutSection(group: groupLayout)
        //sectionLayout.orthogonalScrollingBehavior = .continuous
        sectionLayout.contentInsets.top = 8
        sectionLayout.contentInsets.leading = 16
        sectionLayout.contentInsets.trailing = 16
        sectionLayout.interGroupSpacing = 8
        return UICollectionViewCompositionalLayout(section: sectionLayout)
    }
    func configureCollectionViewDataSource() {
        let mainCellRegistration = UICollectionView.CellRegistration<KeywordCell, String> { cell,indexPath,itemIdentifier in
            cell.configureCell(itemIdentifier: itemIdentifier)
        }

        collectionView2DataSource = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    func applySnapshot2(animatingDifferences: Bool = true) {
        
        var snapshot = collectionView2DataSource.snapshot()
        snapshot.appendSections(["topic"])
        snapshot.appendItems(["1", "2","3","4","5"], toSection: "topic")
        collectionView2DataSource.apply(snapshot) { [weak self] in // apply : UI Update 관련한걸 reflect 한다.
            guard let this = self else { return }
            this.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    
    func configureCell(itemIdentifier: String) {
        label.text = itemIdentifier
    }
    
    
}

