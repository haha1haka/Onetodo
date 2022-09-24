//
//  ViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit
import FloatingPanel


protocol passUISearchResultsUpdating: AnyObject {
    func pass(_ viewController: MainViewController,searchController: UISearchController, searchedText: String)
}

class MainViewController: BaseViewController {

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
    
    var delegate: passUISearchResultsUpdating?
    
    var fpc: FloatingPanelController!
    var contentVC: MainPanelViewController!
    
    var pageContentViewControllers: [UIViewController] = []
    var topicDataStore = Month.allCases.map { $0 } // [Month]
    
    var flag = false
    
    var currentMonth = Int(Date().month)! // --> 9️⃣
    
    var isSearchControllerFiltering: Bool {
        guard let searchController = self.navigationItem.searchController, let searchBarText = self.navigationItem.searchController?.searchBar.text else { return false }
        let isActive = searchController.isActive
        let hasText = searchBarText.isEmpty == false
        return isActive && hasText
    }
    
    
    override func configure() {
        configureUINavigationBar()
        configureNavigationBarButtonItem()
        configureFirstPageViewController()
        configureTopicViewController()
        configurePageViewControllers()
        configurePanelView()

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
    
    func configureNavigationBarButtonItem() {
        let createButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tappedCreateButton))
        navigationItem.rightBarButtonItem = createButton
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tappedSearchButton))
        navigationItem.leftBarButtonItem = searchButton
    }
    @objc
    func tappedCreateButton() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
    }
    @objc
    func tappedSearchButton() {
        let vc = SearchViewController()
        transition(vc, transitionStyle: .presentNavigation)
    }
    
    func configureFirstPageViewController() {
        
        pageContentViewControllers = topicDataStore.map { month in
            let vc = PageViewController()
            print("🆗\(month)")
            vc.isSelectedMonth = month
            return vc
        }
        let pageContentViewController = pageContentViewControllers[currentMonth-1] // [8] --> 9번째 page
        //9월을 첫번째 페이지로
        pageViewController.setViewControllers([pageContentViewController], direction: .forward, animated: false)
        //9월을 첫번째 토픽으로
        DispatchQueue.main.async { //왜 이렇게 해줘야 할까? --> 그냥 시점만 빠르게 해줌.
            let indexPath = IndexPath(row: self.currentMonth-1, section: 0)
            self.topicViewController.topicView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }

    }
    
    func configureTopicViewController() {
        addChild(topicViewController)
        view.addSubview(topicViewController.view)
        topicViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        topicViewController.didMove(toParent: self)
    }
    
    func configurePageViewControllers() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(topicViewController.topicView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }
    
    func configurePanelView() {
        contentVC = MainPanelViewController()
        fpc = FloatingPanelController()
        fpc.changePanelStyle()
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.mainPanelView.collectionView)
        fpc.addPanel(toParent: self)
        fpc.behavior = MyFloatingPanelBehavior()
        fpc.layout = MainFPCPanelLayout()
        fpc.invalidateLayout()
        fpc.show(animated: false) { [weak self] in
            guard let self = self else { return }
            self.didMove(toParent: self)
        }
    }
    
    
}




// MARK: - TopicViewControllerEvent
extension MainViewController: TopicViewControllerEvent {
    //didSelectItem 받아오기
    func topic(_ viewController: TopicViewController, didSelectItem: Month) {
        if let selectedIndex = topicDataStore.firstIndex(of: didSelectItem) {
            pageViewController.setViewControllers([pageContentViewControllers[selectedIndex]], direction: .forward, animated: false)
        }

    }
    

}




// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
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
    
    
    // 페이징 -> topicVC 전달
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        if flag == false {
            flag = true
            print("🌝🌝\(currentMonth)")
            let indexPathForFirstRow = IndexPath(row: currentMonth, section: 0)
            topicViewController.topicView.collectionView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [.centeredHorizontally])

        }
        
        
        if let currentViewController = pageViewController.viewControllers?.first!,
           let currentIndex = pageContentViewControllers.firstIndex(of: currentViewController) {
            let indexPath = IndexPath(item: currentIndex, section: .zero)
            topicViewController.topicView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
            
            

        }
    }
}



    //.full: FloatingPanelLayoutAnchor(absoluteInset: 0.0, edge: .top, referenceGuide: .safeArea),
// MARK: - FloatingPanelControllerDelegate
extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        print(fpc.surfaceLocation.y , fpc.surfaceLocation(for: .full).y)
        print(round(fpc.surfaceLocation.y))
        if round(fpc.surfaceLocation.y) == fpc.surfaceLocation(for: .full).y {

            print("🟥🟥🟥🟥🟥🟥\(fpc.surfaceLocation.y)")
            
            contentVC.fullScreenSnapShot()
            
        } else {
            print("🟩🟩🟩🟩🟩🟩")
            //contentVC.halfCurrentSnapShot()
        }
    }
}
//writeVC.delgate = self

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchController = self.navigationItem.searchController, let text = self.navigationItem.searchController?.searchBar.text else { return }
        
        print("🍱🍱🍱🍱\(text)")
        
        
        
        
        delegate?.pass(self,searchController: searchController, searchedText: text)

    }
}





