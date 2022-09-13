//
//  DetailViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit



class DetailViewController: BaseViewController {

    
    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController()
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    lazy var dailyTopicViewController: DailyViewController = {
        let dailyTopicViewController = DailyViewController()
        dailyTopicViewController.eventDelegate = self
        return dailyTopicViewController
    }()
    
        
    

    var pageContentViewControllers: [UIViewController] = []
    
    
    var dummyDatas = ["월", "화", "수", "목", "금", "토", "일"]

    
    override func configure() {
        setFirstPageViewController()
        setupTopicViewController()
        setupPageViewControllers()
    }
}



extension DetailViewController {

    
    func setFirstPageViewController() {
        
        pageContentViewControllers = dummyDatas.map { month in
            let vc = ListViewController()
            return vc
        }
        print("✅\(pageContentViewControllers)")
        if let pageContentViewController = pageContentViewControllers.first {
            pageViewController.setViewControllers([pageContentViewController], direction: .forward, animated: false)
        }
    }
    

    
    func setupTopicViewController() {
        addChild(dailyTopicViewController)
        view.addSubview(dailyTopicViewController.view)
        dailyTopicViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        dailyTopicViewController.didMove(toParent: self)
    }
    
    

    
    func setupPageViewControllers() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(dailyTopicViewController.dailyTopicView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }
    
    
    
}






// MARK: - DailyTopicViewControllerEvent
extension DetailViewController: DailyTopicViewControllerEvent {
    func topic(_ viewController: DailyViewController, didSelectItem: String) {
        if let selectedIndex = dummyDatas.firstIndex(of: didSelectItem) {
            pageViewController.setViewControllers([pageContentViewControllers[selectedIndex]],
                                                   direction: .forward,
                                                   animated: false)
        }
    }
}











// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension DetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pageContentViewControllers.firstIndex(of: viewController) {
            if currentIndex > 0 {
                return pageContentViewControllers[currentIndex-1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pageContentViewControllers.firstIndex(of: viewController) {
            if currentIndex < pageContentViewControllers.count - 1 {
                return pageContentViewControllers[currentIndex+1]
            }
        }
        return nil
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pageContentViewControllers.firstIndex(of: currentViewController) {
            let indexPath = IndexPath(item: currentIndex, section: .zero)
            dailyTopicViewController.dailyTopicView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        }
    }
}
