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

    var launchImageCombineView:UIImageView!
    let animationDuration = 0.8
    var umUserInfo:[AnyHashable:Any]?
    lazy var managerVC = OrdersViewController()
    
    var blockRotation:Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        //Umeng推送
        let appKey = "5b3ecd6a8f4a9d69e70000a1"
        UMConfigure.initWithAppkey(appKey, channel: "App Store") // 设置推送AppKey
        UMConfigure.setLogEnabled(true)
        
       // let appMasterSecret = "c8y0p2bmp3j6p3qzqbr4qbxkmgal0fpa"
        
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
        
        let entity = UMessageRegisterEntity.init()
        entity.types = Int(UMessageAuthorizationOptions.alert.rawValue|UMessageAuthorizationOptions.badge.rawValue|UMessageAuthorizationOptions.sound.rawValue)
           // [UMessageAuthorizationOptions.alert,UMessageAuthorizationOptions.badge,UMessageAuthorizationOptions.sound] //Int(UInt8(UMessageAuthorizationOptions.badge.rawValue)||UInt8(UMessageAuthorizationOptions.alert.rawValue)||UInt8(UMessageAuthorizationOptions.sound.rawValue))
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted {
                // 用户接收到了PUSH消息
            }else{
                //用户拒绝接受PUSH
                print("用户拒绝接受PUSH消息")
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        
        //open after killed
        if #available(iOS 10.0, *){
            
        }else{
            if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject]{
                guard notification["key"] != nil else{
                    return true
                }
                
                guard notification["value"] != nil else{
                    return true
                }
                
                let key = notification["key"] as! String
                let value = notification["value"] as! String
                
                switch key{
                case "1" :
                    handlePushNotificationTo(key:"1")
                case "2" :
                    break
                default:
                    break
                }
            }
        }
        
        
        
        
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

        if UIDevice.current.isX(){
            heightChangeForiPhoneXFromTop = 24.0
            heightChangeForiPhoneXFromBottom = 34.0
        }else{
            heightChangeForiPhoneXFromTop = 0.0
            heightChangeForiPhoneXFromBottom = 0.0
        }
        self.window?.backgroundColor = UIColor.white
        
        return true
    }
    
//    //注册远程通知
//    private func registerAppNotificationSettings(launchOptions: [NSObject: AnyObject]?) {
//        if #available(iOS 10.0, *) {
//            let notifiCenter = UNUserNotificationCenter.current()
//            notifiCenter.delegate = self
//            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
//            notifiCenter.requestAuthorization(options: types) { (flag, error) in
//            if flag {
//                print("iOS request notification success")
//                //MPrintLog("iOS request notification success")
//            }else{
//                print("iOS 10 request notification fail")
//                //MPrintLog(" iOS 10 request notification fail")
//            }
//        }
//        } else { //iOS8,iOS9注册通知
//            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(setting)
//        }
//
//        UIApplication.shared.registerForRemoteNotifications()
//    }
    
    func handlePushNotificationTo(key:String){

    }
    
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger{
            //应用处于前台时远程推送接收
            //关闭友盟自带弹窗
            UMessage.setAutoAlert(false)
            //
            UMessage.didReceiveRemoteNotification(userInfo)
            print("message present at A")

            //定制自定的弹窗框
//            if UIApplication.shared.applicationState == .active {
//                showAlertView(userInfo: userInfo)
//            }
        }else{
            //应用处于后台时本地推送接受
            print("message present at B")
           //showAlertView(userInfo: userInfo)
        }
      //  print("userInfo10:\(userInfo)")
        //completionHandler([.sound,.alert])
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UNNotificationPresentationOptions.sound.rawValue)|UNNotificationPresentationOptions.alert.rawValue|UNNotificationPresentationOptions.badge.rawValue))
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        if response.notification.request.trigger is UNPushNotificationTrigger{
            //应用处于前台时远程推送接收
            //关闭友盟自带弹窗
            UMessage.setAutoAlert(false)
            //
            UMessage.didReceiveRemoteNotification(userInfo)
            print("message recived at A")
        }else{
            //应用处于后态时本地推送接受
            print("message recived at B")
        }
        
        completionHandler()
    }
    
   // @available(iOS 10.0, *)
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("收到新消息Active\(userInfo)")
        UMessage.setAutoAlert(false) // 关闭友盟自带的弹窗出框
        print("message received")
          
        if UIDevice.current.systemVersion < "10"{
            UMessage.didReceiveRemoteNotification(userInfo)
            self.umUserInfo = userInfo
            
            //定制自定的弹窗框
            if UIApplication.shared.applicationState == .active{
                let alertViewVC = UIAlertController.init(title: "通知消息", message: "Test On ApplicationStateActive", preferredStyle: UIAlertControllerStyle.alert)
                alertViewVC.addAction(UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: { (alertView) in
                    //sure Clickjedd
                }))
                self.window?.rootViewController?.present(alertViewVC, animated: true, completion: nil)
            }
            completionHandler(UIBackgroundFetchResult.newData)
        }
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
        var token = device.description.replacingOccurrences(of: "<", with: "")
        token = token.replacingOccurrences(of: ">", with: "")
        token = token.replacingOccurrences(of: " ", with: "")

        print("我的deviceToken：\(token)")
        UserDefaults.standard.set(token, forKey: "myDeviceToken")
        UserDefaults.standard.synchronize()
        
    }
//定义支持横屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.blockRotation{
            return UIInterfaceOrientationMask.all
        }else{
            return UIInterfaceOrientationMask.portrait
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("应用程序WillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let value = UserDefaults.standard.value(forKey: "orignalOrientation")
        print("The orientation value is \(value)")
        let now = NSDate()
        let savedTime = UserDefaults.standard.object(forKey: "statusUpdateTime") as? NSDate
        if savedTime != nil{
            if value == nil{
                UIDevice.current.setValue(0, forKey: "orientation")
            }else{
                UIDevice.current.setValue(value, forKey: "orientation")
                print("应用程序DidBecomeActive at 2")
            }
        }else{
            UIDevice.current.setValue(0, forKey: "orientation")
            print("timeInterval is nil")
        }
        print("应用程序DidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AccountInfo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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

