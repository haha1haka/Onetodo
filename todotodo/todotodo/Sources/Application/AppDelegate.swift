//
//  AppDelegate.swift
//  todotodo
//
//  Created by HWAKSEONG KIM on 2022/09/09.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 파이어베이스와 연결
        FirebaseApp.configure()
        
        //원격 알림 시스템에 앱 등록
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self //권한담당
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        } else {
          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // Firebase APNs 와 소통하기에, Firebase에게 역할을 위임
        Messaging.messaging().delegate = self
        
        return true
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // foreground 상태 일때 link 타게 해주는 코드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        //SearchViewController 에 있을시 푸쉬 안오게끔,
        //그외 viewController 에서는 알림 오게끔 설정
        if viewController is SearchViewController {
            
        } else {
            // .banner, .list: iOS14+
            completionHandler([.badge, .sound, .banner, .list])
        }
    }
}

extension AppDelegate: MessagingDelegate {
    // 토큰 바뀔 때마다 찍어주는 코드
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
}
