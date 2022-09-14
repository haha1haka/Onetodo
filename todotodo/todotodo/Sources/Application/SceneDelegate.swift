//
//  SceneDelegate.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//        window?.rootViewController =  CustomNavigationController(rootViewController: MainViewController())
        window?.rootViewController =  PanelViewController()
        window?.makeKeyAndVisible()
    }
}
