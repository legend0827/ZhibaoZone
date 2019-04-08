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
  //  var blurView = showBlurEffect()
    var theViewNeedsToCLose:[UIView] = []
    var orderObject:[String:String] = [:]
    
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
        let tabbarvc = TabBarController(royeType: 0)// 上线改成0
        if false{
            self.window?.rootViewController = tabbarvc
        }else{
            self.window?.rootViewController = loginVC
        }

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
            if UIApplication.shared.applicationState == .active {
                showAlertView(userInfo: userInfo)
            }
        }else{
            //应用处于后台时本地推送接受
            print("message present at B")
            showAlertView(userInfo: userInfo)
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
         //   if UIApplication.shared.applicationState == .active {
                showAlertView(userInfo: userInfo)
           // }
        }else{
            //应用处于后态时本地推送接受
            print("message recived at B")
            showAlertView(userInfo: userInfo)
        }
        
        completionHandler()
    }
    
   // @available(iOS 10.0, *)
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("收到新消息Active\(userInfo)")
        UMessage.setAutoAlert(false) // 关闭友盟自带的弹窗出框
        print("message received")
        
        let meVC = MeViewController()
        self.window?.rootViewController?.present(meVC, animated: true, completion: nil)
      
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
//        if application.applicationState == UIApplicationState.active {
//            // 代表从前台接受消息app
//        }else{
//            // 代表从后台接受消息后进入app
//            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
//        completionHandler(.newData)
    
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("应用程序ResignActive")
        let orientation =  UIDevice.current.orientation.rawValue //0 竖直 //3 左倒
        // print("saved \(orientation) status")
        UserDefaults.standard.set(orientation, forKey: "orignalOrientation")
        UserDefaults.standard.set(NSDate(), forKey: "statusUpdateTime")
        UserDefaults.standard.synchronize()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("应用程序DidEnterBackground")
        let orientation =  UIDevice.current.orientation.rawValue //0 竖直 //3 左倒
        print("saved \(orientation) status")
        UserDefaults.standard.set(orientation, forKey: "orignalOrientation")
        UserDefaults.standard.set(NSDate(), forKey: "statusUpdateTime")
        UserDefaults.standard.synchronize()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        //设置横屏
        
//        let value = UserDefaults.standard.value(forKey: "orignalOrientation")
//        UIDevice.current.setValue(value, forKey: "orientation")
//        print("restored status \(value)")
        print("应用程序WillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let value = UserDefaults.standard.value(forKey: "orignalOrientation")
        let now = NSDate()
        let savedTime = UserDefaults.standard.object(forKey: "statusUpdateTime") as? NSDate
        if savedTime != nil{
//            let timeInterval = now.timeIntervalSince(savedTime! as Date)
//            print("timeInterval is \(timeInterval)")
            if value == nil{
                UIDevice.current.setValue(0, forKey: "orientation")
            }else{
                UIDevice.current.setValue(value, forKey: "orientation")
            }
        }else{
            UIDevice.current.setValue(0, forKey: "orientation")
            print("timeInterval is nil")
        }
        
        
        print("应用程序DidBecomeActive")
      //  print("restored status \(value)")
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
    
    @objc func goToCheckClicked(_ button:UIButton){
        print("messageType: \(button.tag) cicked")
        
        let customID = (orderObject as NSDictionary).value(forKey: "customID") as! String/// value( : "customID") as! String
        let orderID = (orderObject as NSDictionary).value(forKey: "orderID") as! String  //button.value(forKey: "orderID") as! String
        
      //  setStatusBarHiden(toHidden: false, ViewController: (self.window?.rootViewController)!)
        var addtionalHeight:CGFloat = 0.0
        if button.tag == 1 || button.tag == 6 || button.tag == 7{
            addtionalHeight = 166.0
        }
        let acceptDesignView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + addtionalHeight))
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptDesignView.popupVC = popVC
        acceptDesignView._orderID = orderID
        acceptDesignView._customID = customID
        
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptDesignView)
        closeUIAlertView()
        //blurView.removeFromSuperview()
        switch button.tag {
        case 0:
            //发起设计
            acceptDesignView.createViewWithActionType(ActionType: .acceptDesign)
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 1:
            //新询价
            acceptDesignView._isBidding = false
            acceptDesignView.createViewWithActionType(ActionType: .quotePrice)
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 2:
            //发起生产
            acceptDesignView.createViewWithActionType(ActionType: .acceptProduce)
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 3:
            //新报价
            print("新报价")
           // acceptDesignView.createViewWithActionType(ActionType: .quotePrice)
           // self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 4:
            //设计提交
          //  acceptDesignView.createViewWithActionType(ActionType: .quotePrice)
          //  self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
            print("设计提交")
        case 5:
            //设计修改
            acceptDesignView.createViewWithActionType(ActionType: .modifyRequires)
            
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 6:
            //议价
            acceptDesignView.createViewWithActionType(ActionType: .dealBargain)
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        case 7:
            //竞价
            acceptDesignView._isBidding = true
            acceptDesignView.createViewWithActionType(ActionType: .quotePrice)
            self.window?.rootViewController?.present(popVC, animated: true, completion: nil)
        default:
            print("hallo")
        }
    }
    
    func showAlertView(userInfo:Any?){
        let tempInfos = userInfo as! NSDictionary
        let orderDic = tempInfos.value(forKey: "aps") as! NSDictionary
        let isNeedsAlert = orderDic.value(forKey: "needsShow") as! NSNumber// needsShow
        let messageType = orderDic.value(forKey: "messageType") as! NSNumber
        var goodsImage = ""
        var orderID = ""
        var customID = ""
        
        let UIAlertView:UIView = UIView.init(frame: CGRect(x: 30, y: 200 + heightChangeForiPhoneXFromTop, width: kWidth - 60, height: 232))
        UIAlertView.layer.cornerRadius = 12
        UIAlertView.backgroundColor = UIColor.white
        
        let grayLayer = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        grayLayer.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.2)
        // blurView = showBlurEffect()
        //   blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(UIAlertView)
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 0, y: 20, width: UIAlertView.frame.width, height: 22))
        title.text = "新消息"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
        let imageView:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: title.frame.maxY + 20, width: 80, height: 80))
        imageView.image = UIImage(named: "defualt-design-pic-loading")
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
        imageView.layer.borderWidth = 0.5
        
        let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: imageView.frame.maxX + 15, y: imageView.frame.minY, width: UIAlertView.frame.width, height: 22))
        orderIDLabel.text = "订单号:"
        orderIDLabel.textAlignment = .left
        orderIDLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        let bodyContentLabel:UILabel = UILabel.init(frame: CGRect(x: orderIDLabel.frame.minX, y: orderIDLabel.frame.maxY + 10, width: UIAlertView.frame.width - 145, height: 100))
        bodyContentLabel.textAlignment = .left
        bodyContentLabel.numberOfLines = 5
        bodyContentLabel.contentMode = .topLeft

        if isNeedsAlert == 1 {
            let closeBtn:UIButton = UIButton.init(type: .custom)
            closeBtn.frame = CGRect(x: UIAlertView.frame.width/2 + 10, y: UIAlertView.frame.height - 60, width: UIAlertView.frame.width/2 - 30, height: 40)
            closeBtn.setTitle("关闭", for: .normal)
            closeBtn.setTitleColor(UIColor.titleColors(color: .red), for: .normal)
            closeBtn.layer.borderWidth = 1
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            closeBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
            closeBtn.backgroundColor = UIColor.white
            closeBtn.addTarget(self, action: #selector(closeUIAlertView), for: .touchUpInside)
            closeBtn.layer.cornerRadius = 6
            
            let goToCheckBtn:UIButton = UIButton.init(type: .custom)
            goToCheckBtn.frame = CGRect(x: 20, y: UIAlertView.frame.height - 60, width: UIAlertView.frame.width/2 - 30, height: 40)
            goToCheckBtn.setTitle("去查看", for: .normal)
            goToCheckBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            goToCheckBtn.backgroundColor = UIColor.backgroundColors(color: .red)
            goToCheckBtn.layer.cornerRadius = 6
            
            goToCheckBtn.addTarget(self, action: #selector(goToCheckClicked), for: .touchUpInside)
            goToCheckBtn.tag = Int(messageType)
            
            UIAlertView.addSubview(closeBtn)
            UIAlertView.addSubview(goToCheckBtn)
        }else{
            let closeBtn:UIButton = UIButton.init(type: .custom)
            closeBtn.frame = CGRect(x: 20, y: UIAlertView.frame.height - 60, width: UIAlertView.frame.width - 40, height: 40)
            closeBtn.setTitle("我知道了", for: .normal)
            closeBtn.layer.cornerRadius = 6
            closeBtn.backgroundColor = UIColor.backgroundColors(color: .red)
            closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            closeBtn.addTarget(self, action: #selector(closeUIAlertView), for: .touchUpInside)
            UIAlertView.addSubview(closeBtn)
        }
        
        
        
        //if isNeedsAlert == 1 {
        
        orderID = orderDic.value(forKey: "orderID") as! String// needsShow
        customID = orderDic.value(forKey: "customID") as! String// needsShow
        orderObject.removeAll()
        orderObject.updateValue("\(customID)", forKey: "customID")
        orderObject.updateValue("\(orderID)", forKey: "orderID")
      //  print(orderObject)
        //  }
        //设置title的名字：
        switch messageType {
        case 0:
            //发起设计
            title.text = "新设计单"
        case 1:
            //新询价
            title.text = "新询价单"
        case 2:
            //发起生产
            title.text = "新生产单"
        case 3:
            //新报价
            //print("新报价")
           title.text = "新报价消息"
        case 4:
            
            //print("设计提交")
            title.text = "设计方案已提交"
        case 5:
            //设计修改
          title.text = "设计修改要求"
        default:
            //print("hallo")
            title.text = "新消息"
        }
        orderIDLabel.text = "订单号:\(orderID)"
        let alertDic = orderDic.value(forKey: "alert") as! NSDictionary
        let str = "\(alertDic.value(forKey: "body") as! String)"
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 5
        //样式属性集合
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12),
                          NSAttributedStringKey.paragraphStyle:paraph,NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .gray)]
        bodyContentLabel.attributedText = NSAttributedString(string: str, attributes: attributes)
        
        let heightOfLabel = calculateLabelHeightWithText(with: bodyContentLabel.text!, labelWidth: bodyContentLabel.frame.width, textFont: UIFont.systemFont(ofSize: 12))
        bodyContentLabel.frame = CGRect(x: orderIDLabel.frame.minX, y: orderIDLabel.frame.maxY + 10, width: UIAlertView.frame.width - 145, height: heightOfLabel + 5)
        DispatchQueue.global().async {
            //downloadImage
            //获取订单图片
            var downloadURLHeader = ""
            var downloadURLHeaderForThumbnail = ""
            
            //下载图片链接地址
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
            #if DEBUG
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
            downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnailDebug") as! String
            #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
            downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnail") as! String
            #endif
            
            if orderDic.value(forKey: "goodsImage") as? String == nil || orderDic.value(forKey: "goodsImage") as? String == ""{
                goodsImage = ""// needsShow
                DispatchQueue.main.async {
                    imageView.image = UIImage(named:"defualt-design-pic")
                }
            }else{
                goodsImage = orderDic.value(forKey: "goodsImage") as! String// needsShow
                do {
                    let imageURLString:String = "\(downloadURLHeaderForThumbnail)\(goodsImage)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        DispatchQueue.main.async {
                            imageView.image = image//  UIImage(image:image)
                        }
                        
                    }catch{
                        let imageURLString:String = "\(downloadURLHeader)\(goodsImage)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            let image = UIImage.gif(data:data)
                            DispatchQueue.main.async {
                                imageView.image = image//  UIImage(image:image)
                            }
                        }catch{
                            print(error)
                        }
                        print("无缩略图")
                    }
                    
                }
            }
        }
        
        UIAlertView.addSubview(title)
        UIAlertView.addSubview(imageView)
        UIAlertView.addSubview(orderIDLabel)
        UIAlertView.addSubview(bodyContentLabel)
        
        self.window?.rootViewController?.view.addSubview(grayLayer)
        theViewNeedsToCLose.append(grayLayer)
    }
    
    @objc func closeUIAlertView(){
        print("close button clicked")
        guard theViewNeedsToCLose.count != nil else {
          //  setStatusBarHiden(toHidden: false, ViewController: (self.window?.rootViewController)!)
            return
        }
        var index = 0
        for view in theViewNeedsToCLose{
            index += 1
            if index == theViewNeedsToCLose.count{
                view.removeFromSuperview()
                theViewNeedsToCLose.remove(at: index - 1)
            }
        }
        
        //blurView.removeFromSuperview()
        //self.window?.rootViewController?.view.addSubview(blurView)
    }
}
extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}

