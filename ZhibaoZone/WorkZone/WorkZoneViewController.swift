//
//  WorkZoneViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData
import PagingMenuController
import Photos
import Alamofire
import QCloudCOSXML
import QCloudCore
import AudioToolbox

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //订单子视图
    private let ordersVC = OrdersViewController()
    //任务子视图
    private let TaskVC = TastsViewController()

    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    

    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [ordersVC, TaskVC]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), horizontalPadding: 0, verticalPadding: 0)
        }

    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "订单"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "任务"))
        }
    }
}

class WorkZoneViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
    
    //消息按钮
    let messageBtnLayer:UIView = UIView.init()
    let messageListBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: -5, y: -5, width: 25, height: 25))


    var theChildViewNeedToClose:[UIView] = []
    //var
    let messageListPopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 350)/2, y: UIScreen.main.bounds.height, width: 350, height: 500))
    
    
    //定义毛玻璃灰层
    lazy var grayLayer:UIView = {
        //y= 64表示要显示上方的切换按钮
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.2
        return tempView
    }()
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        if taskDetailTextView.isFirstResponder {
//            return UIStatusBarStyle.lightContent
//        }
//        return UIStatusBarStyle.default
//    }
//    //动画提交
//    override func viewDidAppear(_ animated: Bool) {
//        addSacleAnimation(animatedView: messageBtnLayer)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //每30秒获取一次消息列表
        getMessageList()//先获取一次
        timerForMessageList = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getMessageList), userInfo: nil, repeats: true)
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 15 //64
        pagingMenuController.view.frame.size.height -= 15
        
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)
        
        
        //var tempOrderVC = OrdersViewController()
        let tempOrderVC = options.pagingControllers[0] as! OrdersViewController
        //tempOrderVC.workZoneVCObject = self
        
        let circleViewBtn = UIButton.init(type: UIButtonType.custom)

        //iPhone X设备处理
        if UIDevice.current.isX(){
            circleViewBtn.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 155 , width: 60, height: 60)
            messageListBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 215 , width: 50, height: 50)
            messageBtnLayer.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 220 , width: 60, height: 60)
        }else{
            circleViewBtn.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 120 , width: 60, height: 60)
            messageListBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 180 , width: 50, height: 50)
            messageBtnLayer.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 185 , width: 60, height: 60)
        }
 
        
        
        messageBtnLayer.backgroundColor = UIColor.white// #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        messageBtnLayer.layer.cornerRadius = 30
        messageBtnLayer.layer.shadowOffset = CGSize(width: 2, height: 2)
        messageBtnLayer.layer.shadowOpacity = 0.8
        messageBtnLayer.layer.shadowColor = UIColor.black.cgColor
        
        messageListBtn.backgroundColor = UIColor.white
        messageListBtn.layer.cornerRadius = 25

        messageListBtn.addTarget(self, action: #selector(messageListBtnClicked), for: UIControlEvents.touchUpInside)
        //用户名输入框左侧图标
        let msgListImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        msgListImg.image = UIImage(named:"messagelisticon")
        //let plusImg:UIImage = UIImage.init(named: "plus-white")!
        self.view.addSubview(messageBtnLayer)
        self.view.addSubview(messageListBtn)
        //messageBtnLayer.addSubview(messageListBtn)
        messageListBtn.addSubview(msgListImg)
        
        messageCountLabel.backgroundColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        messageCountLabel.layer.cornerRadius = 12.5
        messageCountLabel.text = "\(messagesList.count)"
        messageCountLabel.textColor = UIColor.white
        messageCountLabel.textAlignment = .center
        messageCountLabel.clipsToBounds = true // 对Label切角度
        
        messageListBtn.addSubview(messageCountLabel)
        
        if messagesList.count == 0{
            messageBtnLayer.isHidden = true
            messageListBtn.isHidden = true
        }else{
            messageBtnLayer.isHidden = false
            messageListBtn.isHidden = false
        }
//        newTaskTableView.keyboardDismissMode = .interactive
//        orderIDTextField.keyboardType = .numberPad
}
//    //消息列表动画
//    private func addSacleAnimation(animatedView:UIView){
//
//        DispatchQueue.global(qos: .background).sync {
//            animatedView.layer.removeAllAnimations()
//            let animate = CABasicAnimation(keyPath: "transform.scale")
//            animate.fromValue = 1
//            animate.toValue = 0.9
//            animate.repeatCount = HUGE
//            animate.duration = 1
//            animate.autoreverses = true
//            animate.isRemovedOnCompletion = true //动画播放不停止
//            animatedView.layer.add(animate, forKey: nil)
//        }
//    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func messageListBtnClicked(){
       let messageListVC = MessageListViewController()
        messageListVC.messagesList = messagesList
        messageListVC.workZoneVC = self
        messageListVC.getMessagesCount = getMessagesCount
        
        self.present(messageListVC, animated: true, completion: nil)
       
    }
    //获取消息列表
    @objc func getMessageList(){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                //获取列表
                //messagesList = "111222"
                
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
                for item in params{
                    print(item)
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
                            }
                            if self.messagesList.count == 0{
                                self.messageBtnLayer.isHidden = true
                                self.messageListBtn.isHidden = true
                            }else{
                                self.messageBtnLayer.isHidden = false
                                self.messageListBtn.isHidden = false
                                self.messageCountLabel.text = "\(self.messagesList.count)"
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
                let mySelf = Unmanaged<WorkZoneViewController>.fromOpaque(inClientData!)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}




