//
//  AppDelegate.swift
//  MusicAlarm
//
//  Created by 최아람 on 2023/02/15.
//

import UIKit
import NotificationCenter
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authorizationOptions) { _, error in
            if let error = error {
                print("ERROR : \(error.localizedDescription)")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(notification.request.content.userInfo["link"] ?? "")
        
        
        print("willpresent")
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let pushUrl = response.notification.request.content.userInfo["link"] as? String
        if pushUrl !=  nil {
            NSLog("앱델레케이트 푸시타고 들어옴, 링크있음")
            if UIApplication.shared.applicationState == .active {
                NSLog("포그라운드에서 클릭")
                showMainViewController(pushUrl ?? "")
            }else if UIApplication.shared.applicationState == .background || UIApplication.shared.applicationState == .inactive {
                NSLog("백그라운드에서 클릭")
                // * Push에서 전달받은 UserInfo 데이터를 변수에 담습니다.
                let userInfo = response.notification.request.content.userInfo

                // * UserDefaults에 URL 정보를 저장합니다.
                //    - PUSH_URL 이름의 키로 userInfo 안 link 데이터를 저장합니다.
                let userDefault = UserDefaults.standard
                userDefault.set(userInfo["link"] ?? "", forKey: "PUSH_URL")
                userDefault.synchronize()
                showMainViewController(userDefault.string(forKey: "PUSH_URL") ?? "")
            }
        }
        completionHandler()
    }
    private func showMainViewController(_ url : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let webViewController = storyboard.instantiateViewController(identifier: "WebViewController") as? WebViewController else {return}
        webViewController.url = url
        webViewController.modalPresentationStyle = .popover
        UIApplication.shared.windows.first?.rootViewController?.show(webViewController, sender: nil)
    }
}

