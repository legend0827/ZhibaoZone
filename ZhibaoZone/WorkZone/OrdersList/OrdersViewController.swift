//
//  OrdersViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 03/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreData
import PagingMenuController
import Photos
import Alamofire
import QCloudCOSXML
import QCloudCore
import AudioToolbox
import AVFoundation

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //全部订单子视图
    private let allOrdersVC = AllOrdersViewController(orderlistTye: orderListCategoryType.allOrderCategory)
    //待报价子视图
    private let notQuoteYetVC = AllOrdersViewController(orderlistTye: orderListCategoryType.notQuotePriceYetOrderCategory)//NotQuoteYetViewController()
    //已报价子视图
    private let quoteAlreadyVC = AllOrdersViewController(orderlistTye: orderListCategoryType.alreadyQuotedOderCategory)//AllOrdersViewController()//QuoteAlreadyViewController()
    //待接受生产子视图
    private let waitForProduceVC = AllOrdersViewController(orderlistTye: orderListCategoryType.waitForAcceptProduceOrderCategory)//AllOrdersViewController()//WaitForAccpetProduceViewController()

    //生产中子视图
    private let producingVC = AllOrdersViewController(orderlistTye: orderListCategoryType.producingOrderCategory)//AllOrdersViewController()//ProducingViewController()
    
    var backgroundColor: UIColor = UIColor.backgroundColors(color: .white) // 设置菜单栏底色

    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [allOrdersVC,notQuoteYetVC,quoteAlreadyVC,waitForProduceVC,producingVC]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(),MenuItem3(),MenuItem4(),MenuItem5()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 12, verticalPadding: 5) // 水平间距 0 ，垂直间距 0 
        }
        
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            //return .text(title: MenuItemText(text: "全部"))
                return .text(title: MenuItemText(text: "全部", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "未报价", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第3个菜单项
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已报价", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第4个菜单项
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第5个菜单项
    fileprivate struct MenuItem5: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待发货", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第6个菜单项
    fileprivate struct MenuItem6: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第7个菜单项
    fileprivate struct MenuItem7: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待修改", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第8个菜单项
    fileprivate struct MenuItem8: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已定稿", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
}

class OrdersViewController:UIViewController,UITextFieldDelegate {
    
    //系统声音播放
    var isPlaying = false
    var isTheAlertPlayed = false
    
    //获取消息列表
    var timerForMessageList:Timer!
    var messagesList:[NSDictionary] = []
    var previewsMessagesIDList:[String] = []
    var currentMessagesIDList:[String] = []
    var currentMessagesTypeList:[Int] = []
    var isNeedsAlert = true
    var getMessagesCount = 0
    lazy var tabBarVC: TabBarController = {
        return TabBarController(royeType: 1)
    }()
    //var tabBarVC = TabBarController(royeType: 1)
    
    //消息数目
    let messageCountBackLabel:UIView = UIView.init(frame: CGRect(x: 53, y: -5, width: 22, height: 16))
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 22, height: 16))
    
    //用户角色
    var _roleType = 1
    
    //标题栏背景
    let titleBarView:UIView = UIView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
    //扫描二维码按钮
    let scanQRCodeBtn:UIButton = UIButton.init(type: .custom)
    //订单列表的搜素栏
    //let searchBarInOrders:UISearchBar = UISearchBar.init(frame: CGRect(x: 52, y: 5, width:kWidth - 104, height: 28))
    let searchBarInOrders:UIView = UIView.init(frame: CGRect(x: 52, y: 8, width:kWidth - 104, height: 28))
    //消息按钮
    let messageListBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置状态栏颜色
        setStatusBarBackgroundColor(color: .titleColors(color: .red))
        
        
        //每30秒获取一次消息列表
        getMessageList()//先获取一次
        timerForMessageList = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getMessageList), userInfo: nil, repeats: true)
        
        /// 菜单栏配置
        
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 28 //(4 + heightChangeForiPhoneXFromTop)*3
        pagingMenuController.view.frame.size.height -= 5

        if UIDevice.current.isX(){
            heightChangeForiPhoneXFromTop = 24.0
            pagingMenuController.view.frame.origin.y += 56
        }else{
            heightChangeForiPhoneXFromTop = 0.0
            pagingMenuController.view.frame.origin.y += 32//5
        }
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)
        //print("分页显示出来了")

        titleBarView.frame = CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44)
        scanQRCodeBtn.frame = CGRect(x: 20, y: 11, width: 62, height: 22)
        messageListBtn.frame = CGRect(x: kWidth - 82, y: 11, width: 62, height: 22)
        searchBarInOrders.frame = CGRect(x: 52, y: 8, width:kWidth - 104, height: 28)
        //为搜索框添加点击事件
        let gestureRecognizerOfSearach = UITapGestureRecognizer(target: self, action:#selector(searchBarTaped))
        searchBarInOrders.addGestureRecognizer(gestureRecognizerOfSearach)
        
        //顶部titlebar显示
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red) // 红色主色调
        
        //设置扫描二维码按钮样式
        scanQRCodeBtn.addTarget(self, action: #selector(scanQRCodeBtnClicked), for: UIControlEvents.touchUpInside)
        let qrcodeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        qrcodeImg.image =  UIImage(named:"scanqrcodeicon")//  UIImage(named:"messagelisticon")
        self.view.addSubview(scanQRCodeBtn)
        scanQRCodeBtn.addSubview(qrcodeImg)
        
        //设置消息按钮样式和响应
        messageListBtn.addTarget(self, action: #selector(messageListBtnClicked), for: UIControlEvents.touchUpInside)
        let msgListImg = UIImageView(frame: CGRect(x: 40, y: 3, width: 22, height: 18))
        msgListImg.image =  UIImage(named:"messagelisticon")
        self.view.addSubview(messageListBtn)
        
        
        
        messageCountBackLabel.layer.cornerRadius = 7
        messageCountBackLabel.clipsToBounds = true // 对Label切角度
        messageCountBackLabel.isHidden = true
        messageCountBackLabel.backgroundColor = UIColor.backgroundColors(color: .white)
        messageCountLabel.backgroundColor = UIColor.backgroundColors(color: .white)
//        let backLayer = CALayer()
//        backLayer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
//        backLayer.bounds  = CGRect(x: 0, y: 0, width: 22, height: 16)
//        backLayer.position = CGPoint(x: 11, y: 8)
//        messageCountBackLabel.layer.addSublayer(backLayer)
        messageCountLabel.layer.cornerRadius = 7
        messageCountLabel.text = "\(messagesList.count)"
        messageCountLabel.font = UIFont.systemFont(ofSize: 11)
        messageCountLabel.textColor = UIColor.titleColors(color: .red)
        messageCountLabel.textAlignment = .center
        messageCountLabel.clipsToBounds = true // 对Label切角度
        messageCountLabel.isHidden = false
        messageListBtn.addSubview(msgListImg)
        messageListBtn.addSubview(messageCountBackLabel)
        messageCountBackLabel.addSubview(messageCountLabel)
        
        
        
        //设置搜索栏
        searchBarInOrders.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0)
        searchBarInOrders.layer.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0).cgColor
        searchBarInOrders.layer.cornerRadius = 6
        let searchBarHintText:UILabel = UILabel.init(frame: CGRect(x: searchBarInOrders.frame.width/2 - 50, y: 0, width: 100, height: 28))
        searchBarHintText.text = "搜索订单号"
        searchBarHintText.textAlignment = .center
        searchBarHintText.textColor = UIColor.titleColors(color: .white)
        searchBarHintText.font = UIFont.systemFont(ofSize: 14)
        let searchIconImg = UIImageView(frame: CGRect(x: searchBarInOrders.frame.width/2 - 55, y: 7, width: 14, height: 14))
        searchIconImg.image =  UIImage(named:"searchicon")
        searchBarInOrders.addSubview(searchIconImg)
        searchBarInOrders.addSubview(searchBarHintText)

        self.view.addSubview(titleBarView)
        titleBarView.addSubview(searchBarInOrders)
        titleBarView.addSubview(scanQRCodeBtn)
        titleBarView.addSubview(messageListBtn)

    }
    
    @objc func searchBarTaped(){
        print("点击了搜索区域")
        
//        setStatusBarBackgroundColor(color: .clear)
//        titleBarView.backgroundColor = UIColor.clear
//        searchBarInOrders.backgroundColor = UIColor.clear
        
        if _roleType == 1{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidAndWangWangID, roleType: _roleType)
            self.present(searchOrderVC, animated: true, completion: nil)
        }else{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidOnly, roleType: _roleType)
            self.present(searchOrderVC, animated: true, completion: nil)
        }
    }
    @objc func scanQRCodeBtnClicked(){
        print("扫描二维码按钮点击了")
        let scanQRcodeVC = ScanCodeViewController(scanType: .qrCode)
        let nav = UINavigationController.init(rootViewController: scanQRcodeVC)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func messageListBtnClicked(){
        print("消息列表按钮点击了")
        let msgVC = MessageListViewController()
        msgVC.messagesList = messagesList
        //设置跳转带navigation controller的跳转
        let nav = UINavigationController(rootViewController: msgVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        setStatusBarBackgroundColor(color: UIColor.titleColors(color: .red))
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red)
        searchBarInOrders.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0)
        
        //self.view.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        let userinfos = getCurrentUserInfo()
        _roleType = Int(userinfos.value(forKey: "roletype") as! String)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //获取消息列表
    @objc func getMessageList(){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                //获取列表
                
                let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
                let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
                let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
                #if DEBUG
                //            let newTaskUpdateURL:String = "http://192.168.1.102:8068/task/createTasklist.do"
                let newTaskUpdateURL:String = apiAddresses.value(forKey: "getMessagesListDebug") as! String
                #else
                let newTaskUpdateURL:String = apiAddresses.value(forKey: "getMessagesList") as! String
                #endif
                //定义请求参数
                let params:NSMutableDictionary = NSMutableDictionary()
                
                //从datacore获取用户数据
                //获取管理的数据上下文，对象
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                
                //声明数据的请求
                let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
                let fetchRequestOfToken = NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
                //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
                //        fetchRequest.fetchOffset = 0 //查询到偏移量
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequestOfToken.returnsObjectsAsFaults = false
                
                // 设置查询条件
                let predicate = NSPredicate(format: "id = '1'")
                fetchRequest.predicate = predicate
                
                // 设置查询条件
                let predicateOfToken = NSPredicate(format: "id = '1'")
                fetchRequestOfToken.predicate = predicateOfToken
                //查询操作
                do {
                    let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
                    
                    //遍历查询结果
                    for info in fetchedObjects{
                        //更新数据
                        //设置获取全部订单参数组
                        
                        params["userid"] =  info.userId
                        params["roletype"] = info.roleType
                        params["commandcode"] = 110
                        params["isnew"] = 0
                        try managedObjectContext.save()
                    }
                } catch  {
                    fatalError("获取失败")
                }
                
                //查询操作
                do {
                    let fetchedObjects = try managedObjectContext.fetch(fetchRequestOfToken)
                    
                    //遍历查询结果
                    for info in fetchedObjects{
                        //更新数据
                        //设置获取全部订单参数组
                        params["token"] = info.token
                        try managedObjectContext.save()
                    }
                } catch  {
                    fatalError("获取失败")
                }
                _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
                    (responseObject) in
                    switch responseObject.result.isSuccess{
                    case true:
                        if  let value = responseObject.result.value{
                            let json = JSON(value)
                            self.messagesList.removeAll()
                            if json["status","code"].int! == 0{
                                for item in json["msginfo"].array! {
                                    let restoreItem = item.dictionaryObject as! NSDictionary
                                    self.messagesList.append(restoreItem)
                                }
                                self.getMessagesCount = self.messagesList.count
                            }else if json["status","code"].int! == 1{
                                self.getMessagesCount = 0
                                self.tabBarVC.redDot.isHidden = true
                            }
                            if self.messagesList.count == 0{
                                self.tabBarVC.redDot.isHidden = true
                               // self.messageBtnLayer.isHidden = true
                                self.messageCountBackLabel.isHidden = true
                            }else{
                                self.tabBarVC.redDot.isHidden = false
                                //self.messageBtnLayer.isHidden = false
                                self.messageCountBackLabel.isHidden = false
                                if self.messagesList.count > 99{
                                    self.messageCountLabel.text = "99+"
                                }else{
                                    self.messageCountLabel.text = "\(self.messagesList.count)"
                                }
                                self.calculateWeatherNeedsAlert()
                            }
                        }
                    case false:
                        print("update failed")
                    }
                }
            })
        }
    }
    
    func calculateWeatherNeedsAlert()
    {
        
        isNeedsAlert = false
        var AlertFrequencyValue = 0
        //var isTheAlertPlayedThisRound = false
        //遍历当前获取到的列表里的所有
        currentMessagesTypeList.removeAll()
        currentMessagesIDList.removeAll()
        for i in 0..<messagesList.count{
            let mSGType = messagesList[i].value(forKey: "msgtype") as! Int
            let mSGID = messagesList[i].value(forKey: "msgid") as! String
            currentMessagesTypeList.append(mSGType)
            currentMessagesIDList.append(mSGID)
        }
        
        //第一次获取消息,直接判断是不是需要提醒
        if previewsMessagesIDList.count == 0{
            
            //遍历当前消息列表中的消息类型,以此得到是否需要提醒
            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
            for msgType in currentMessagesTypeList{
                let tempAlertTag = getMSGAlertSettings(index: msgType)
                //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
            }
            
            //获取当前设置，决定是否需要提醒，以及提醒多少次
            let frequency = getMsgVoiceAlertFrequencyWeight()
            print(frequency)
            if frequency == 1{
                // 不提醒
                isNeedsAlert = false
                AlertFrequencyValue = 0
            }else if frequency == 10{
                //提醒一次
                //
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 1
            }else{
                //提醒多次
                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
                for msgType in currentMessagesTypeList{
                    let tempAlertTag = getMSGAlertSettings(index: msgType)
                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
                }
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 10
            }
            
            //将当前获取的列表替换到上次的列表中，以便下次比对
            previewsMessagesIDList.removeAll()
            previewsMessagesIDList = currentMessagesIDList
        }else{ //不是第一次获取消息了
            var itemID = 0
            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
            for id in currentMessagesIDList{
                if !previewsMessagesIDList.contains(id){//这条消息不包含在之前的消息里
                    //如果这条消息不在列表里，那么取对应的消息ID查询结果，并与定义的需要提醒取或，只要有一条消息需要提醒，那么值将会是true
                    needsAlertFromCurrentAlertSettingForTargetMSGType =  needsAlertFromCurrentAlertSettingForTargetMSGType || getMSGAlertSettings(index: currentMessagesTypeList[itemID])
                }
                itemID += 1
            }
            //获取当前设置，决定是否需要提醒，以及提醒多少次
            let frequency = getMsgVoiceAlertFrequencyWeight()
            print(frequency)
            if frequency == 1{
                // 不提醒
                isNeedsAlert = false
                AlertFrequencyValue = 0
            }else if frequency == 10{
                //提醒一次
                //
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 1
            }else{
                //提醒多次
                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
                for msgType in currentMessagesTypeList{
                    let tempAlertTag = getMSGAlertSettings(index: msgType)
                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
                }
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 10
            }
        }
        
        if isNeedsAlert == true{
            if (AlertFrequencyValue == 1) && (isTheAlertPlayed == false){
                playAudio()
                isTheAlertPlayed = true
            }else if AlertFrequencyValue == 10{
                playAudio()
            }
        }
        
    }
    
    func playAudio(){
        
        if !isPlaying{
            //建立的SystemSoundID对象
            var soundID:SystemSoundID = 0
            //获取声音地址
            let path = Bundle.main.path(forResource: "msg", ofType: "wav")
            //地址转换
            let baseURL = NSURL(fileURLWithPath: path!)
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<OrdersViewController>.fromOpaque(inClientData!)
                    .takeUnretainedValue()
                mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
            }, observer)
            
            //播放声音
            AudioServicesPlaySystemSound(soundID)
            isPlaying = true
        }
        
        
    }
    //音频结束时的回调
    func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        print("Completion")
        isPlaying = false
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }


}

func getQuotePriceWeight() -> Int{
    var Weight = 1
    //从datacore获取用户数据
    //获取管理的数据上下文，对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<ParameterSettings>(entityName:"ParameterSettings")

    fetchRequest.returnsObjectsAsFaults = false
    
    // 设置查询条件
    let predicate = NSPredicate(format: "id = '1'")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
        
        //遍历查询结果
        for info in fetchedObjects{
            //更新数据
            //设置获取全部订单参数组
            Weight = Int(info.quotePriceWeight)
            
        }
    } catch  {
        fatalError("获取失败")
    }
    return Weight
}

func getMsgVoiceAlertFrequencyWeight() -> Int{
    var Weight = 1
    //从datacore获取用户数据
    //获取管理的数据上下文，对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<ParameterSettings>(entityName:"ParameterSettings")
    
    fetchRequest.returnsObjectsAsFaults = false
    
    // 设置查询条件
    let predicate = NSPredicate(format: "id = '1'")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
        
        //遍历查询结果
        for info in fetchedObjects{
            //更新数据
            //设置获取全部订单参数组
            Weight = Int(info.msgVoiceAlertFrequencyWeight)
            
        }
    } catch  {
        fatalError("获取失败")
    }
    return Weight
}
