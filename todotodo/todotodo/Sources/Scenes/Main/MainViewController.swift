//
//  ViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import SnapKit
import FloatingPanel

class MainViewController: BaseViewController {
    
    lazy var topicViewController: TopicViewController = {
        let topicViewController = TopicViewController()
        topicViewController.eventDelegate = self
        return topicViewController
    }()

    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        return pageViewController
    }()
    
    var BackFloatingPanel: FloatingPanelController!
    var floatingPanel: MainPanelViewController!
    
    var pageContentViewControllers: [UIViewController] = []
    var topicDataStore = Month.allCases.map { $0 } // [Month]
    var thisMonth = Date().month // --> 9️⃣
    
    var isSearchControllerFiltering: Bool {
        guard let searchController = self.navigationItem.searchController else { return false }
        guard let searchBarText = self.navigationItem.searchController?.searchBar.text else { return false }
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


// MARK: - configure Methods
extension MainViewController {

    func configureUINavigationBar() {
        self.navigationItem.title = "todotodo"
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = ColorType.backgroundColorSet
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
            vc.selectedMonth = month
            vc.delegate = self
            return vc
        }
        let pageContentViewController = pageContentViewControllers[thisMonth-1] // [8] --> 9번째 page
        //9월을 첫번째 페이지로
        pageViewController.setViewControllers([pageContentViewController], direction: .forward, animated: false)
        //9월을 첫번째 토픽으로
        DispatchQueue.main.async { //왜 이렇게 해줘야 할까? --> 그냥 시점만 빠르게 해줌.
            let indexPath = IndexPath(row: self.thisMonth-1, section: 0)
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
        floatingPanel = MainPanelViewController()
        BackFloatingPanel = FloatingPanelController()
        BackFloatingPanel.changePanelStyle()
        BackFloatingPanel.delegate = self
        BackFloatingPanel.set(contentViewController: floatingPanel)
        BackFloatingPanel.track(scrollView: floatingPanel.mainPanelView.collectionView)
        BackFloatingPanel.addPanel(toParent: self)
        BackFloatingPanel.behavior = MyFloatingPanelBehavior()
        BackFloatingPanel.layout = MainFPCPanelLayout()
        BackFloatingPanel.invalidateLayout()
        BackFloatingPanel.show(animated: false) { [weak self] in
            guard let self = self else { return }
            self.didMove(toParent: self)
        }
    }
}





// MARK: - TopicViewControllerEventDelegate
extension MainViewController: TopicViewControllerEvent {
    //didSelectItem 받아오기
    func topic(_ viewController: TopicViewController, didSelectItem: Month) {
        if let selectedIndex = topicDataStore.firstIndex(of: didSelectItem) {
            pageViewController.setViewControllers([pageContentViewControllers[selectedIndex]], direction: .forward, animated: false)
        }
    }
}


// MARK: - TopicViewControllerEventDelegate
extension MainViewController: PageViewControllerEvent {
    func item(_ viewController: PageViewController, itemidentifier: ToDo) {
        var snapshot = floatingPanel.collectionViewDataSource.snapshot()
        snapshot.deleteItems([itemidentifier])
        floatingPanel.collectionViewDataSource.apply(snapshot, animatingDifferences: true)
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
        if let currentViewController = pageViewController.viewControllers?.first!,
           let currentIndex = pageContentViewControllers.firstIndex(of: currentViewController) {
            let indexPath = IndexPath(item: currentIndex, section: .zero)
            topicViewController.topicView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        }
    }
}



// MARK: - FloatingPanelControllerDelegate
// ⚠️Refactor: 시점
extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let height =  fpc.surfaceLocation.y
        if round(height) == fpc.surfaceLocation(for: .full).y {
            floatingPanel.fullScreenSnapShot()
        } else if round(height) == fpc.surfaceLocation(for: .half).y {
            floatingPanel.applySnapShot()
        }
    }
}






