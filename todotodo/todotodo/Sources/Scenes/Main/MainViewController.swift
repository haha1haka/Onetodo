//
//  ViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

//typealias DataSource = UICollectionViewDiffableDataSource<Section, Video>
//typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Video>

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    let mainView = MainView()
    
    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController()
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    lazy var topicViewController: TopicViewController = {
        let topicViewController = TopicViewController()
        topicViewController.eventDelegate = self
        return topicViewController
    }()

    var pageContentViewControllers: [UIViewController] = []
    
    var topicDataStore = ["1월", "2월", "3월",
                          "4월", "5월", "6월",
                          "7월", "8월", "9월",
                          "10월", "11월", "12월"]
    var monthData = [1,2,3,4,5,6,7,8,9,10,11,12]

    override func loadView() {
        self.view = mainView
    }
    
    override func configure() {
        configureUINavigationBar()
        setFirstPageViewController()
        setupTopicViewController()
        setupPageViewControllers()
        
    }

    
}








extension MainViewController {
    
    func setFirstPageViewController() {
        
        pageContentViewControllers = monthData.map { month in
            let vc = PageViewController()
            vc.dataStore.append(month)
            return vc
        }
        print("✅\(pageContentViewControllers)")

        if let pageContentViewController = pageContentViewControllers.first {
            pageViewController.setViewControllers([pageContentViewController],
                                                   direction: .forward,
                                                   animated: false)
        }
    }
    
    
    func setupTopicViewController() {
        addChild(topicViewController)
        mainView.addSubview(topicViewController.view)
        topicViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(mainView.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        topicViewController.didMove(toParent: self)
    }
    
    
    
    func setupPageViewControllers() {
        addChild(pageViewController)
        mainView.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(topicViewController.topicView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }
    

}





extension MainViewController {
    func configureUINavigationBar() {
        self.navigationItem.title = "todotodo"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}







extension MainViewController: TopicViewControllerEvent {
    func topic(_ viewController: TopicViewController, didSelectItem: String) {
        if let selectedIndex = topicDataStore.firstIndex(of: didSelectItem) {
            pageViewController.setViewControllers([pageContentViewControllers[selectedIndex]],
                                                   direction: .forward,
                                                   animated: false)
        }
    }
}







extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
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
            topicViewController.topicView.topicCollectionView.selectItem(at: indexPath,
                                                           animated: true,
                                                           scrollPosition: [.centeredHorizontally])
        }
    }
}
