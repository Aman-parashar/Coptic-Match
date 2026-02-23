//
//  AppDelegate.swift
//  DatingApp
//
//  Created by Maulik Vinodbhai Vora on 13/09/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Quickblox
import QuickbloxWebRTC
import SVProgressHUD
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import GoogleMaps
import SwiftyStoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    struct TimeIntervalConstant {
        static let answerTimeInterval: TimeInterval = 60.0
        static let dialingTimeInterval: TimeInterval = 5.0
    }
    struct AppDelegateConstant {
        static let enableStatsReports: UInt = 1
    }
    lazy private var backgroundTask: UIBackgroundTaskIdentifier = {
        let backgroundTask = UIBackgroundTaskIdentifier.invalid
        return backgroundTask
    }()
    
    var window: UIWindow?
    var isLoadingViewVisible:Bool = false
    var isOpenChatVCForChat = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.beginReceivingRemoteControlEvents()

        
        //--
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        application.applicationIconBadgeNumber = 0
        
        completeTransaction()
        
        //EDIT
//        QBSettings.applicationID = 95918
//        QBSettings.authKey = "CqDZsbVYuCOkfLm"
//        QBSettings.authSecret = "ZTF4cRyP8eaFntG"
//        QBSettings.accountKey = "xTpPszfhB2_93CGWM1uH"
//
//        QBRTCClient.initializeRTC()
        
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            AppStoreUpdate.shared.checkNewAppVersionAvailableOnAppstore(isForceUpdate: false)
        }
        
        registerForPushNotification(application: application)
        
        //fb
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions:launchOptions)
        
        //for crashlytics only
        FirebaseApp.configure()
        
        //
        GMSServices.provideAPIKey("AIzaSyA7SgaWyyc5yDbCxcWvjLLkOVm9xEzvNCw")
        
        LocationManager.shared.startMonitoringLocation()
        
        return true
    }
    
    func registerForPushNotification(application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().delegate = self
        //self.notificationButtons()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
                
            }
            
        }
    }
    
    //EDIT
//    func notificationButtons() {
//
//        let rejectAction = UNNotificationAction(identifier: "rejectAction", title: "Reject", options: [.foreground])
//        let acceptAction = UNNotificationAction(identifier: "acceptAction", title: "Accept", options: [.foreground])
//
//        let callReminderCategory = UNNotificationCategory(
//            identifier: "CallCategory",
//            actions: [rejectAction, acceptAction],
//            intentIdentifiers: [],
//            options: .customDismissAction)
//
//        UNUserNotificationCenter.current().setNotificationCategories([callReminderCategory])
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    //EDIT
//    func applicationDidEnterBackground(_ application: UIApplication) {
//
//        QBChat.instance.disconnect { (error) in
//        }
//    }
//    func applicationWillEnterForeground(_ application: UIApplication) {
//
//        let currentUser = QBSession.current.currentUser
//
//        if currentUser?.id != nil {//&& currentUser?.password != nil {
//
//            QBChat.instance.connect(withUserID: currentUser!.id, password: "quickblox") { (error) in
//                NotificationCenter.default.post(name: Notification.Name("JoinDialogAgain"), object: nil)
//
//            }
//        }
//    }
//    func applicationWillTerminate(_ application: UIApplication) {
//        QBChat.instance.disconnect { (error) in
//        }
//
//    }
    
    //fb
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        var handled: Bool
//
//          handled = GIDSignIn.sharedInstance.handle(url)
//          if handled {
//            return true
//          }
        
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
      }
    
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        let token = tokenParts.joined()
        //Helper.shared.device_token = token
        print("Device Token: \(token)")
        
        UserDefaults .standard .set("\(token)", forKey: "fcm_devicetoken")
        UserDefaults.standard.synchronize()
        
        //EDIT
        //QB
//        guard let identifierForVendor = UIDevice.current.identifierForVendor else {
//            return
//        }
//        let deviceIdentifier = identifierForVendor.uuidString
//        let subscription = QBMSubscription()
//        subscription.notificationChannel = .APNS
//        subscription.deviceUDID = deviceIdentifier
//        subscription.deviceToken = deviceToken
//        QBRequest.createSubscription(subscription, successBlock: { (response, objects) in
//        }, errorBlock: { (response) in
//            debugPrint("[AppDelegate] createSubscription error: \(String(describing: response.error))")
//            })
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber+1
    }
    //to show notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        let userInfo = notification.request.content.userInfo
        
        if let type = userInfo["type"] as? String {
            
            if type == "qb_chat" {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshInboxUI"), object: nil)
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshBadge"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier_RefreshChatBadge"), object: nil)
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    // Use this method to process the user's response to a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
        
        
        switch response.actionIdentifier {
            case "rejectAction":
                // Handle action
//            let obj = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
//
//            self.window?.rootViewController = obj
//            obj.selectedIndex = 4
//
//            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
//            let navController = obj.selectedViewController as? UINavigationController
//            vc?.userId = id
//            vc?.isFromVC = "Social"
//            navController?.pushViewController(vc!, animated: true)
            
            
            
            
//            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            let navController = UINavigationController()
//
//            //obj.isFromVC = "Social"
//            navController.pushViewController(obj, animated: true)
            print("")
            case "acceptAction":
                // Handle action
            print("")
            default:
                break
            }
    }
}



//MARK: -  In-App Purchase Functions
extension AppDelegate {
    
    func completeTransaction() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
}
