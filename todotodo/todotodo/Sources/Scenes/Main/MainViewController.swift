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
    var selectedMonth: Month = .aug
    var flag = false
    
    var isSearchControllerFiltering: Bool {
        guard let searchController = self.navigationItem.searchController, let searchBarText = self.navigationItem.searchController?.searchBar.text else { return false }
        let isActive = searchController.isActive
        let hasText = searchBarText.isEmpty == false
        return isActive && hasText
    }
    
    
    override func configure() {
        setupSearchController()
        configureUINavigationBar()
        configureNavigationBarButtonItem()
        configureFirstPageViewController(isSelectedMonth:selectedMonth )
        configureTopicViewController()
        configurePageViewControllers()
        configurePanelView()
        
        
        
        
//        topicViewController.topicView.collectionView.s
        
     
    }
    //let vc = PageViewController()
}


extension MainViewController {

    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
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
    }
    @objc
    func tappedCreateButton() {
        let vc = WriteViewController()
        transition(vc, transitionStyle: .push)
    }
    
    func configureFirstPageViewController(isSelectedMonth: Month) {
        
        pageContentViewControllers = topicDataStore.map { month in
            let vc = PageViewController()
            vc.isSelectedMonth = month
            
            return vc
        }
        print("✅\(pageContentViewControllers)")
        let pageContentViewController = pageContentViewControllers[isSelectedMonth.rawValue]
        print("\(pageContentViewController)")
        pageViewController.setViewControllers([pageContentViewController], direction: .forward, animated: false)
        
        DispatchQueue.main.async { //왜 이렇게 해줘야 할까? --> 그냥 시점만 빠르게 해줌.
            let indexPath = IndexPath(row: isSelectedMonth.rawValue, section: 0)
            self.topicViewController.topicView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        //        if let pageContentViewController = pageContentViewControllers.first {
//            pageViewController.setViewControllers([pageContentViewController], direction: .forward, animated: false)
//        }
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
    
//    override func viewDidAppear(_ animated: Bool) {
//        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
//        topicViewController.topicView.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: [])
//        collectionView(CollectionView, didSelectItemAt: indexPathForFirstRow)
//    }
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
            print("🌝🌝\(selectedMonth.rawValue)")
            let indexPathForFirstRow = IndexPath(row: selectedMonth.rawValue, section: 0)
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





