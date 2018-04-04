//
//  AppDelegate.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import QCloudCOSXML
import QCloudCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,QCloudSignatureProvider {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //注册用户通知
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self 
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    print("iOS request notification success")
                    //MPrintLog("iOS request notification success")
                }else{
                    print("iOS 10 request notification fail")
                    //MPrintLog(" iOS 10 request notification fail")
                }
            }
        } else { //iOS8,iOS9注册通知
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        // 创建腾讯云所需的配置
        // 实例化QCloudServiceConfiguration
        
        //#warning 输入您的APPID
        let configuration = QCloudServiceConfiguration()
        configuration.appID = "1255653994" //项目ID
        configuration.signatureProvider = self
        let endpoint:QCloudCOSXMLEndPoint = QCloudCOSXMLEndPoint.init()
    
        
        //#warning 输入Bucket所在地域
        endpoint.regionName = "ap-chengdu"
        configuration.endpoint = endpoint
        // 实例化QCloudCOSXLMLService
        QCloudCOSXMLService.registerDefaultCOSXML(with: configuration)
        // 实例化QCloudCOSTransferManagerService
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: configuration)

        
        // 创建View Controller
        let loginVC = ViewController()
        self.window?.rootViewController = loginVC
//        
//        let workZoneVC = WorkZoneViewController()
//        let meVC = MeViewController()
//        
//        workZoneVC.tabBarItem.image = UIImage(named:"workzoneicon")
//        meVC.tabBarItem.image = UIImage(named:"accounticon")
//        
//        
//        workZoneVC.tabBarItem.title = "工作台"
//        meVC.tabBarItem.title = "我的"
//        
//        let tabBar = TabBarController()
//        tabBar.viewControllers = [workZoneVC,meVC]
//        
//        let loginStatus = false
//        if !loginStatus {
//            self.window?.rootViewController = loginVC
//        }else{
//            self.window?.rootViewController = tabBar
//        }
        self.window?.backgroundColor = UIColor.white
        
        return true
    }
    //注册远程通知
    private func registerAppNotificationSettings(launchOptions: [NSObject: AnyObject]?) {
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
            if flag {
                print("iOS request notification success")
                //MPrintLog("iOS request notification success")
            }else{
                print("iOS 10 request notification fail")
                //MPrintLog(" iOS 10 request notification fail")
            }
        }
        } else { //iOS8,iOS9注册通知
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //iOS10新增：处理前台收到通知的代理方法
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        
        completionHandler()
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("收到新消息Active\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }else{
            // 代表从后台接受消息后进入app
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler(.newData)
    
    }
    
    func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
        // 生成签名
        let credential = QCloudCredential()
        credential.secretID = "AKIDlPzX1SO396wiJlKPZghYosvulW6pvvFU"
        credential.secretKey = "gGk9lGcpt382pRuFPNAqLit166c4b2tb"
        let creator:QCloudAuthentationV5Creator = QCloudAuthentationV5Creator.init(credential: credential)
        let signature:QCloudSignature = creator.signature(forData: urlRequst)
        continueBlock(signature, nil)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 发送给我们自己的服务器
      //  let tokenString = deviceToken.hexString
        
        let device = NSData(data: deviceToken)
        let deviceID = device.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        print("我的deviceToken：\(deviceID)")
       // let deviceToken:String = deviceID
        
        UserDefaults.standard.set(deviceID, forKey: "myDeviceToken")
        UserDefaults.standard.synchronize()
        
       // UserDefaults.string("deviceToken")
//        
//        let plistFile = Bundle.main.path(forResource: "deviceToken", ofType: "plist")
//        //临时deviceToken
//        let emptyArray:NSArray = ["\"deviceToken\":\"\(deviceID)\""]
//        emptyArray.write(toFile: plistFile!, atomically: true)
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AccountInfo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}

