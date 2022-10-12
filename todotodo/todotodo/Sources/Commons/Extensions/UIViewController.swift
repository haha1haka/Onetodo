//
//  UIViewController.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        case .presentFullNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension UIViewController {
    func presentAlertController(_ title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: false)
    }

}

extension UIViewController {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }
}

extension UIViewController {
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    //최상위 뷰컨트롤러를 판단 해주는 메서드
    func topViewController(currentViewController: UIViewController) -> UIViewController {
        
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController
        {
            return self.topViewController(currentViewController: selectedViewController)
        }
        
        else if let navigationController = currentViewController as? UINavigationController,
                let visibleViewController = navigationController.visibleViewController
        {
            return self.topViewController(currentViewController: visibleViewController)
        }
        
        else if let presentedViewController = currentViewController.presentedViewController
        {
            return self.topViewController(currentViewController: presentedViewController)
        }
        
        else
        {
            return currentViewController
        }
    }
}
