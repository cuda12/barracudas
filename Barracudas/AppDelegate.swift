//
//  AppDelegate.swift
//  Barracudas
//
//  Created by Andreas Rueesch on 11.07.17.
//  Copyright © 2017 Andreas Rueesch. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseAuthUI
import FirebaseInstanceID
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    let stack = CoreDataStack(modelName: "Model")!
    
    
    // MARK: Application Delegate Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // load customized theme
        Theme.applyTheme()
        
        // display notifications (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        Messaging.messaging().delegate = self
        
        application.registerForRemoteNotifications()
                
        // configure Firebase
        FirebaseApp.configure()
        
        // TOOD delete this
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        stack.save()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        stack.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // to enable google authentication 
        return FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication ?? "") ?? false
    }
    
    // the callback to handle data message received via Firebase 
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        //TODO
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("fcm Token: " + fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageID = userInfo["gcm.message_id"] {
            print("message id: \(messageID)")
        }
        if let pageIndex = userInfo["click_action"] {
            if let tabBarController = self.window?.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = Int((pageIndex as? String)!) ?? 0
            }
        }
        print(userInfo)
    }
    
}

