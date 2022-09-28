//
//  PopPanelView.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/16.
//

import UIKit
import SnapKit

class MainPanelView: BaseView {
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = modeColor
        return view
    }()
    
    let mainTitle: UILabel = {
        let view = UILabel()
        view.backgroundColor = modeColor
        view.textColor = modeTextColor
        view.text = " Today"
        view.font = .systemFont(ofSize: 44, weight: .bold)
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = modeColor
        view.textColor = modeTextColor
        view.font = .systemFont(ofSize: 12, weight: .regular)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        view.text = formatter.string(from: Date())
        
        
        return view
    }()
    

    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }

    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        view.alwaysBounceVertical = false
//        view.backgroundColor = .red
//        view.backgroundColor = .clear
        return view
    }()
    
    
    

    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        return UICollectionViewCompositionalLayout.init(sectionProvider: { sectionIndex, environment in
            //1️⃣ Item, Group Section Layout)
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(128), heightDimension: .estimated(128))
            let Item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = itemSize
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [Item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 16

            //2️⃣ Header Layout
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(128))
            let headerItemLayout = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [headerItemLayout]
            return section
        }, configuration: configuration)
    }

    
    
    override func configure() {
        [collectionView, containerView].forEach { self.addSubview($0) }
        containerView.addSubview(mainTitle)
        containerView.addSubview(dateLabel)
        //setBlur()
        self.backgroundColor = UIColor(red: 11/255, green: 11/255, blue: 15/255, alpha: 1.0)
    }
    func setBlur() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
        
        self.sendSubviewToBack(blurEffectView)
        
        
        blurEffectView.layer.cornerRadius = 35
        blurEffectView.clipsToBounds = true
    }
    
    
    override func setConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(self)
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(120)
        }
        mainTitle.snp.makeConstraints {
            $0.leading.equalTo(containerView).offset(10)
            $0.top.bottom.equalTo(containerView)
            //$0.width.equalTo(200)
        }
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(containerView).inset(10)
            $0.bottom.equalTo(containerView.snp.bottom).inset(10)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom)
            $0.leading.trailing.equalTo(self)
            $0.bottom.equalToSuperview()
        }

            
        
        

    }

    
}







