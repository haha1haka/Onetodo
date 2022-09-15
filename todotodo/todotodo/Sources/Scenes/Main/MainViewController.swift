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
import FloatingPanel


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
    
    var fpc: FloatingPanelController!
    var panelVC: PanelViewController!
    

    var pageContentViewControllers: [UIViewController] = []
    
    
    
    var dummyDatas = ["1월", "2월", "3월",
                          "4월", "5월", "6월",
                          "7월", "8월", "9월",
                          "10월", "11월", "12월"]
    
    var monthData = [1,2,3,4,5,6,7,8,9,10,11,12]


    override func configure() {
        configureUINavigationBar()
        setFirstPageViewController()
        setupTopicViewController()
        setupPageViewControllers()
        setupPanelView()
        
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
        view.addSubview(topicViewController.view)
        topicViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        topicViewController.didMove(toParent: self)
    }
    
    
    
    func setupPageViewControllers() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(topicViewController.topicView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageViewController.didMove(toParent: self)
    }
    
    func configureUIToolBar() {
        self.navigationController?.isToolbarHidden = false
        let writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonClicked))
        writeButton.tintColor = .label
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, writeButton]
    }
    @objc func writeButtonClicked() {
        let vc = DetailViewController()
        transition(vc, transitionStyle: .push)
    }

    
}











// MARK: - TopicViewControllerEvent
extension MainViewController: TopicViewControllerEvent {
    //didSelectItem 받아오기
    func topic(_ viewController: TopicViewController, didSelectItem: String) {
        if let selectedIndex = dummyDatas.firstIndex(of: didSelectItem) {
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
    
    
    
    // 페이징 할때, topic 넘어가기
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pageContentViewControllers.firstIndex(of: currentViewController) {
            let indexPath = IndexPath(item: currentIndex, section: .zero)
            topicViewController.topicView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [.centeredHorizontally])
        }
    }
}








// MARK: - Panel Methods
extension MainViewController {
    func setupPanelView() {
        panelVC = PanelViewController()
        fpc = FloatingPanelController()
        fpc.changePanelStyle() // panel 스타일 변경 (대신 bar UI가 사라지므로 따로 넣어주어야함)
        fpc.delegate = self
        fpc.set(contentViewController: panelVC) // floating panel에 삽입할 것
        fpc.track(scrollView: panelVC.panelView.collectionView)
        fpc.addPanel(toParent: self) // fpc를 관리하는 UIViewController
        fpc.layout = MyFloatingPanelLayout()
        fpc.invalidateLayout() // if needed
    }
}


extension FloatingPanelController {
    func changePanelStyle() {
            let appearance = SurfaceAppearance()
            let shadow = SurfaceAppearance.Shadow()
            shadow.color = UIColor.black
            shadow.offset = CGSize(width: 0, height: -4.0)
            shadow.opacity = 0.15
            shadow.radius = 2
            appearance.shadows = [shadow]
            appearance.cornerRadius = 15.0
            appearance.backgroundColor = .clear
            appearance.borderColor = .clear
            appearance.borderWidth = 0

            surfaceView.grabberHandle.isHidden = true
            surfaceView.appearance = appearance

        }
}

extension MainViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangePosition(_ fpc: FloatingPanelController) {
        if fpc.state == .full {
                //
            } else {

            }
        }
    
}
