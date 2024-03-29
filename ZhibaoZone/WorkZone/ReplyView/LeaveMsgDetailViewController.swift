//
//  LeaveMsgDetailViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 25/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import AVFoundation
import PagingMenuController
import Photos
import QCloudCOSXML
import QCloudCore

class LeaveMsgDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
 
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    var taskDetailArray:[NSDictionary] = []
    var taskInfoDic:NSDictionary = [:]
    
    
    //任务详情加载情况
    var isTaskDetailLoadEnd = false
    var isTaskDetailInfosLoadEnd = false
    var AttachmentsLoaded = false
    
    //任务回复条数
    var countOfContent:Int = 1
    //附件图片数
    var attachmentPicCount:[Int] = []// 前一个数第几条消息，后一个是图片数目
    //附件图片
    var AttachmentPics:[UIImage] = []
    var AttachmentPicsArray:[[UIImage]] = []
    //附件文件类型
    var AttachmentTypes:[String] = []
    var AttachmentTypesArray:[[String]] = []
    //预览路径
    var previewURLs:[URL] = []
    var previewURLsArray:[[URL]] = []
    //附件后缀名
    var AttachmentExtensions:[String] = []
    var AttachmentExtensionsArray:[[String]] = []
    
    //回复正在发送中
    var isReplyCreating = false
    //上传图片到COS临时存储到名字
    var taskImages:[String] = []
    var isDataInReplyViewCleared = true
    
    //附件图片下载地址
    var downloadURLHeader = ""
    
    var currentTaskID:String?
    var currentCustomid:String?
    var currentTaskType:Int?
    var currentOrderID:String?
    var currentGoodsID:String?
    
    //回复按钮点击定位：
    var replySelectorParamters = [Int:String]()
    
    //选择的订单的index
    var selectedIndex = 0
    
    //回复窗口的值设置；
    var isRepling = false
    var AttachPicArrayInRelay:[UIImageView] = []
    
    //键盘隐藏还是显示
    var isKeyboardHidden = false
    //回复页面的TableView
    lazy var replyTaskTableView:UITableView = {
        //y = 58调好的
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55), style: UITableViewStyle.grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.white
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        return tempTableView
    }()
    
    //回复输入框
    lazy var replyTextView:UITextView = {
        let tempTextView:UITextView = UITextView.init(frame: CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 410))) // 305
        //tempTextView.delegate = self as! UITextViewDelegate
        tempTextView.backgroundColor = UIColor.colorWithRgba(245, g: 245, b: 245, a: 1.0)
        tempTextView.isScrollEnabled = true
        tempTextView.layer.cornerRadius = 5
        return tempTextView
    }()
    
    
    var replyTaskViewTitle:UILabel = UILabel.init(frame:CGRect(x: UIScreen.main.bounds.width/2 - 44, y: 13, width: 88, height: 30))
    let placeholderLabel = UILabel.init() // placeholderLabel是全局属性
    let textNumberLimit:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 115, y: UIScreen.main.bounds.height - 410, width: 100, height: 40))
    let taskSendToNameLabel:UILabel = UILabel.init(frame: CGRect(x: kWidth - 220, y: 32, width: 200, height: 20))
    let progressBtn = KVProgressBar.init(frame: CGRect(x: UIScreen.main.bounds.width - 115, y: UIScreen.main.bounds.height - 410, width: 30, height: 30))
    lazy var progressLabel:UILabel = {
        let tempLabel:UILabel = UILabel.init(frame:CGRect(x: UIScreen.main.bounds.width/2 - 50, y: 33, width: 100, height: 30))
        tempLabel.textAlignment = .center
        tempLabel.textColor = UIColor.colorWithRgba(150, g: 150, b: 150, a: 1.0)
        tempLabel.font = UIFont.systemFont(ofSize: 10)
        return tempLabel
    }()
    
    var iPhoneXHeightChange:CGFloat = 35.0
    //回复附件
    var attachmentPicCountInReply = 0
    var AttachmentPicsInReply:[UIImage] = []
    var AttachmentTypesInReply:[String] = []
    var previewURLsInReply:[URL] = []
    var imageURLsInReply:[String] = []
    
    //倒计时
    var timer:Timer!
    var countdownTime:Int = 0
    
    var currentTimeString:String {
        get {
            if countdownTime <= 0 {
                
                return "0分钟"
                
            } else {
                
                
                return String(format:"%02d小时%02d分钟",Int(countdownTime)/3600
                    ,Int(countdownTime)/60%60)
            }
        }
    }
    //显示成）00:00:00
//    var currentTimeString:String {
//        get {
//            if countdownTime <= 0 {
//
//                return "00:00:00"
//
//            } else {
//
//
//                return String(format:"%02d:%02d:%02d",Int(countdownTime)/3600
//                              ,Int(countdownTime)/60%60,Int(countdownTime)%60)
//            }
//        }
//    }
    
    //任务详情页面数据集合
    var taskCountDownTimerValue:UILabel = UILabel.init(frame: CGRect(x: 77, y: 15, width: 200, height: 20))
    var taskSenderNameValue:UILabel = UILabel.init(frame: CGRect(x: 70, y: 32, width: 200, height: 20))
    var taskOrderIDValue:UILabel = UILabel.init(frame: CGRect(x: 84, y: 10, width: 200, height: 20))
    let taskDeadlineValue:UILabel = UILabel.init(frame: CGRect(x: kWidth - 220, y: 10, width: 200, height: 20))
    var taskCreateTimeValue:UILabel = UILabel.init(frame: CGRect(x: kWidth - 220 , y: 15, width: 200, height: 20))
    var taskContentValue:UILabel = UILabel.init(frame: CGRect(x: 20, y: 37, width: kWidth - 40, height: 20))
    let taskInfoBackgroundView:UIView = UIView.init(frame: CGRect(x: 0, y: 5, width: kWidth, height: 193))
    let taskReplyBtn:UIButton = UIButton.init(type: .custom)
    //回复窗口
    let greyMask:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var replyTaskView:UIView = UIView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35))

    let cancelBtnOnReplyView:UIButton = UIButton.init(type: .system)
    let doneBtnOnReplyView:UIButton = UIButton.init(type: .system)
    
    //导航栏
    //let navigationBarInTaskDetail:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20+heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: 30))
    
    //任务详情回复内容表
    lazy var LeaveMessageContentTableView:UITableView = {
        let temTableView:UITableView = UITableView.init(frame: CGRect(x: 0, y: 322 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 357))
        temTableView.backgroundColor = UIColor.white
        temTableView.separatorColor = UIColor.colorWithRgba(230, g: 230, b: 230, a: 1.0)
        temTableView.separatorStyle = .none//.singleLineEtched
        temTableView.keyboardDismissMode = .interactive
        return temTableView
    }()
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if isTaskDetailInfosLoadEnd{
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .red)
        navBar.barTintColor = UIColor.backgroundColors(color: .red)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "新建任务"
        titleLabel.textColor = UIColor.titleColors(color: .white)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-white")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .white)
        
        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "完成任务", style: .plain,
                                           target: self, action: #selector(taskFinishedBtnClicked))
        rightBarItem.tintColor = UIColor.backgroundColors(color: .white)
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        navItem.setRightBarButton(rightBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        //灰层
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)

        loadTaskDetailBasicInfo(taskType: currentTaskType!)
        //        if isRepling {
        //            self.view.bringSubview(toFront: self.greyMask)
        //            self.view.bringSubview(toFront: self.replyTaskView)
        //        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                self.loadOrderDataFromServer()
            })
            var count = 0
            while true{
                count += 1
                print("count = \(count)")
                if self.isTaskDetailLoadEnd{
                    DispatchQueue.main.async(execute: {
                        self.loadTaskDetailViewData(taskType: self.currentTaskType!)
                    })
                    self.isTaskDetailLoadEnd = false
                    break
                }
            }
            
        }
        
        LeaveMessageContentTableView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        replyTaskTableView.keyboardDismissMode = .interactive
    }
    
    private func refresh() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                self.loadOrderDataFromServer()
            })
            var count = 0
            while true{
                count += 1
                print("count = \(count)")
                if self.isTaskDetailLoadEnd{
                    DispatchQueue.main.async(execute: {
                        self.loadTaskDetailViewData(taskType: self.currentTaskType!)
                    })
                    self.isTaskDetailLoadEnd = false
                    break
                }
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        replyTextView.becomeFirstResponder()
        isTaskDetailInfosLoadEnd = true
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if DEBUG
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        #endif

    }
    
    func loadTaskDetailBasicInfo(taskType:Int){
        //加载任务基本信息
        //标准任务界面
        let timerBackgroundView:UIView = UIView.init(frame: CGRect(x: 0, y: 69 + heightChangeForiPhoneXFromTop, width: kWidth, height: 50))
        timerBackgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let taskCountDownTimerIcon:UIImageView = UIImageView.init(frame: CGRect(x: 24, y: 13, width: 16, height: 24))
        taskCountDownTimerIcon.image = UIImage(named: "timericon-normal")
        
        let taskCountDownTimerLabel:UILabel = UILabel.init(frame: CGRect(x: 49, y: 15, width: 200, height: 20))
        taskCountDownTimerLabel.text = "剩余"
        taskCountDownTimerLabel.textColor = UIColor.titleColors(color: .red)
        taskCountDownTimerLabel.font = UIFont.systemFont(ofSize: 14)
        
        taskCountDownTimerValue.text = "0分钟"
        taskCountDownTimerValue.textColor = UIColor.titleColors(color: .red)
        taskCountDownTimerValue.font = UIFont.systemFont(ofSize: 14)
        
        taskCreateTimeValue.text = "2018-01 12:99:12"
        taskCreateTimeValue.textAlignment = .right
        taskCreateTimeValue.textColor = UIColor.titleColors(color: .black)
        taskCreateTimeValue.font = UIFont.systemFont(ofSize: 14)
        
        timerBackgroundView.addSubview(taskCountDownTimerValue)
        timerBackgroundView.addSubview(taskCreateTimeValue)
        timerBackgroundView.addSubview(taskCountDownTimerLabel)
        timerBackgroundView.addSubview(taskCountDownTimerIcon)
        self.view.addSubview(timerBackgroundView)
        
        
        taskInfoBackgroundView.frame = CGRect(x: 0, y: 124 + heightChangeForiPhoneXFromTop, width: kWidth, height: 193)
        taskInfoBackgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let taskSenderNameLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 32, width: 88, height: 20))
        taskSenderNameLabel.text = "发送者:"
        taskSenderNameLabel.textColor = UIColor.titleColors(color: .gray)
        taskSenderNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        let taskOrderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 10, width: 88, height: 20))
        taskOrderIDLabel.text = "相关订单:"
        taskOrderIDLabel.textColor = UIColor.titleColors(color: .black)
        taskOrderIDLabel.font = UIFont.systemFont(ofSize: 14)
        
        taskOrderIDValue.font = UIFont.systemFont(ofSize: 14)
        taskOrderIDValue.textColor = UIColor.titleColors(color: .black)
        
        taskDeadlineValue.text = "期限:"
        taskDeadlineValue.textAlignment = .right
        taskDeadlineValue.textColor = UIColor.titleColors(color: .black)
        taskDeadlineValue.font = UIFont.systemFont(ofSize: 14)
        
        taskSendToNameLabel.text = "接受者:"
        taskSendToNameLabel.textColor =  UIColor.titleColors(color: .gray)
        taskSendToNameLabel.textAlignment = .right
        taskSendToNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        taskSenderNameValue.font = UIFont.systemFont(ofSize: 14)
        taskSenderNameValue.textColor = UIColor.titleColors(color: .gray)
        
        
        let sepereateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 62, width: kWidth - 40, height: 1))
        sepereateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
        let taskContentLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 73, width: 88, height: 20))
        taskContentLabel.text = "任务详情:"
        taskContentLabel.textColor = UIColor.titleColors(color: .black)
        taskContentLabel.font = UIFont.systemFont(ofSize: 14)
        
        taskContentValue.frame = CGRect(x: 20, y: 100, width: kWidth - 40, height: 20)
        taskContentValue.font = UIFont.systemFont(ofSize: 14)
        taskContentValue.textColor = UIColor.titleColors(color: .black)
        
        let replyImg:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
        replyImg.image = UIImage(named: "replyicon")
        taskReplyBtn.addSubview(replyImg)
        print("frame: \(taskInfoBackgroundView.frame.maxY - 23)")
        taskReplyBtn.frame = CGRect(x: kWidth - 45, y: taskInfoBackgroundView.frame.height - 23, width: 25, height: 18)
        replySelectorParamters[0] = "\(0)"
        taskReplyBtn.tag = 0
        taskReplyBtn.addTarget(self, action: #selector(replyBtnClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(taskInfoBackgroundView)
        taskInfoBackgroundView.addSubview(sepereateLine)
        taskInfoBackgroundView.addSubview(taskSenderNameLabel)
        taskInfoBackgroundView.addSubview(taskSenderNameValue)
        taskInfoBackgroundView.addSubview(taskOrderIDLabel)
        taskInfoBackgroundView.addSubview(taskOrderIDValue)
        taskInfoBackgroundView.addSubview(taskDeadlineValue)
        taskInfoBackgroundView.addSubview(taskSendToNameLabel)
        taskInfoBackgroundView.addSubview(taskContentLabel)
        taskInfoBackgroundView.addSubview(taskContentValue)
        taskInfoBackgroundView.addSubview(taskReplyBtn)

    }
    
    func loadTaskDetailViewData(taskType:Int){
        if taskType == 0{
            let taskDetailInfoObject = taskDetailArray
            let taskInfoObject = taskInfoDic
            
            //值
            if taskInfoObject.value(forKey: "tasksendername") as? String == nil{
                taskSenderNameValue.text = "未找到任务发起者"
            }else{
                taskSenderNameValue.text = (taskInfoDic.value(forKey: "tasksendername") as! String)
            }
            
            //任务订单号
            if taskInfoDic.value(forKey: "orderid") as? String == nil{
                taskOrderIDValue.text = "无相关订单"
            }else{
                taskOrderIDValue.text = (taskInfoDic.value(forKey: "orderid") as! String)
            }

            //任务创建时间
            if taskInfoDic.value(forKey: "tasksendtime") as? String == nil{
                taskCreateTimeValue.text = "2018-01-01 00:00:00"
            }else{
                if taskInfoDic.value(forKey: "tasksendtime") as! String != "null"{
                    taskCreateTimeValue.text = (taskInfoDic.value(forKey: "tasksendtime") as! String)
                }else{
                    taskCreateTimeValue.text = "2018-01-01 00:00:00"
                }
            }
            //任务截止时间
            // 获取当前系统时间
            
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale.current
            timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let strNowTime = timeFormatter.string(from: date) as String
            
            let now = timeFormatter.date(from: strNowTime)
            //将创建任务时间转换为Date格式
            let dateResult = timeFormatter.date(from: taskCreateTimeValue.text!)
            
            let gregorian = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
            let result = gregorian?.components(.second, from: dateResult!, to: now!, options: NSCalendar.Options.init(rawValue: 0)).second as! Int
            
            if taskInfoDic.value(forKey: "taskperiod") as? String == nil{
                taskDeadlineValue.text = "期限: 30分钟"
            }else{
                countdownTime = Int((taskInfoDic.value(forKey: "taskperiod") as! String))!*60 - result
                taskDeadlineValue.text = "期限: \(changeDeadLineFormat(deadLineInMins: Int((taskInfoDic.value(forKey: "taskperiod") as! String))!))"
            }
 
            //倒计时开始计时
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeEventsOfCountDown), userInfo: nil, repeats: true)
            
            //接受任务人
            if taskInfoDic.value(forKey: "taskreceivername") as? String == nil{
                taskSendToNameLabel.text = "接受者: 未指定任务接受者"
            }else{
                taskSendToNameLabel.text = "接受者: \(taskInfoDic.value(forKey: "taskreceivername") as! String)"
            }
            
            
            
            if taskInfoDic.value(forKey: "orderid") as? String == nil{
                taskOrderIDValue.text = "无相关订单"
            }else{
                taskOrderIDValue.text = taskInfoDic.value(forKey: "orderid") as! String
            }
            
            //附件图片数量
            AttachmentPicsArray.removeAll()
            
            var itemID = 0
            for detailItem in taskDetailInfoObject{
                var imageCount = 0
                AttachmentPicsArray.append([])
                previewURLs.removeAll()
                AttachmentTypes.removeAll()
                AttachmentExtensions.removeAll()
                print("AttachmentPicsArray append a item at [\(itemID)]")

                if detailItem.value(forKey: "taskimageurl1") as? String != nil && detailItem.value(forKey: "taskimageurl1") as! String != ""{
                    let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl1") as! String)"
                    let url = URL(string: imageURLString)!

                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        if fnameExtension.uppercased() != ".MOV" && fnameExtension.uppercased() != ".MP4"{
                            AttachmentTypes.append("public.image")
                        }else{
                            AttachmentTypes.append("public.movie")
                        }
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        AttachmentTypes.append("public.image")
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else{
                        //不可预览素材
                    }

                }

                if detailItem.value(forKey: "taskimageurl2") as? String != nil && detailItem.value(forKey: "taskimageurl2") as! String != ""{
                    let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl2") as! String)"
                    let url = URL(string: imageURLString)!

                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        if fnameExtension.uppercased() != ".MOV" && fnameExtension.uppercased() != ".MP4"{
                            AttachmentTypes.append("public.image")
                        }else{
                            AttachmentTypes.append("public.movie")
                        }
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        AttachmentTypes.append("public.image")
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else{
                        //不可预览素材
                    }

                }

                if detailItem.value(forKey: "taskimageurl3") as? String != nil && detailItem.value(forKey: "taskimageurl3") as! String != ""{
                    let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl3") as! String)"
                    let url = URL(string: imageURLString)!

                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        if fnameExtension.uppercased() != ".MOV" && fnameExtension.uppercased() != ".MP4"{
                            AttachmentTypes.append("public.image")
                        }else{
                            AttachmentTypes.append("public.movie")
                        }
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        AttachmentTypes.append("public.image")
                        AttachmentExtensions.append(fnameExtension)
                        previewURLs.append(url)
                        imageCount += 1

                    }else{
                        //不可预览素材
                    }

                }
                attachmentPicCount.append(imageCount)
                AttachmentTypesArray.append(AttachmentTypes)
                AttachmentExtensionsArray.append(AttachmentExtensions)
                previewURLsArray.append(previewURLs)
            }
            
            // 加载任务内容
            let detailItem = taskDetailArray[0]
            
            
            //发送内容
            if (detailItem.value(forKey: "taskinfo") as? String == nil){
                taskContentValue.text = "无指定内容"
                taskContentValue.textColor = UIColor.colorWithRgba(100, g: 100, b: 100, a: 1.0)
            }else{
                taskContentValue.text = detailItem.value(forKey: "taskinfo") as! String
                taskContentValue.textColor = UIColor.black
            }
            
            let height = autoLabelHeight(with: taskContentValue.text!, labelWidth: UIScreen.main.bounds.width - 75, textFont: taskContentValue.font)
            
            taskContentValue.numberOfLines = 100//Int(height/23)
            
            taskContentValue.frame =  CGRect(x: 20, y: 100, width: kWidth - 40, height: height + 10)
            
            taskInfoBackgroundView.frame = CGRect(x: 0, y: 124 + heightChangeForiPhoneXFromTop, width: kWidth, height: 193 + height)
            taskReplyBtn.frame = CGRect(x: kWidth - 45, y: taskInfoBackgroundView.frame.height - 31, width: 25, height: 18)
            LeaveMessageContentTableView.frame = CGRect(x: 0, y: 322 + heightChangeForiPhoneXFromTop + height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 357 - height)
            
            //附件图片数量
            var imageCount = 0
            if detailItem.value(forKey: "taskimageurl1") as? String != nil && detailItem.value(forKey: "taskimageurl1") as! String != ""{
                imageCount += 1
            }
            if detailItem.value(forKey: "taskimageurl2") as? String != nil && detailItem.value(forKey: "taskimageurl2") as! String != ""{
                imageCount += 1
            }
            if detailItem.value(forKey: "taskimageurl3") as? String != nil && detailItem.value(forKey: "taskimageurl3") as! String != ""{
                imageCount += 1
            }
            
            attachmentPicCount[0] = imageCount
            
            if imageCount != 0{
                //修改导航栏返回按钮文字
                var count = 0
                for i in 0..<attachmentPicCount[0]{
                    let AttachPic = UIImageView()
                    
                    //let yOfAttachPic = Int(taskContentValue.frame.height + 35)
                    
                    AttachPic.frame = CGRect(x: 20 + i * 78, y: Int(taskInfoBackgroundView.frame.height - 81) , width: 68, height: 68)
                    AttachPic.layer.cornerRadius = 6
                    AttachPic.layer.masksToBounds = true
                    let StringTag = "1\(i)\(0)\(10)"
                    AttachPic.tag = Int(StringTag)!
                    AttachPic.contentMode = .scaleAspectFill
                    AttachPic.clipsToBounds = true
                    
                    if AttachmentPicsArray.count == 0{
                        AttachPic.image =  UIImage(named: "defualt-design-pic-loading")
                    }else{
                        if AttachmentPicsArray[0].count == 0{
                            AttachPic.image = UIImage(named: "defualt-design-pic-loading")
                        }else{
                            if i >= AttachmentPicsArray[0].count{
                                AttachPic.image =  UIImage(named: "defualt-design-pic-loading")
                            }else{
                                AttachPic.image = AttachmentPicsArray[0][i]//UIImage(cgImage: AttachmentPicsArray[indexPath.row][i].cgImage!)
                            }
                        }
                    }
                    if self.view.viewWithTag(Int(StringTag)!) == nil{
                        taskInfoBackgroundView.addSubview(AttachPic)
                        print("AttachPic add count\(count+1)")
                    }
                }
            }
            
            var heightForFooterItems = taskContentValue.frame.height + 28
            if imageCount != 0 {
                heightForFooterItems = taskContentValue.frame.height + 98
            }
            
            //加载附件图片（下载)
            DispatchQueue.global(qos: .background).async(execute: {
                self.loadTaskDetailCommentsAttach()
            })

            
            self.view.addSubview(LeaveMessageContentTableView)
            LeaveMessageContentTableView.delegate = self
            LeaveMessageContentTableView.dataSource = self
            
        }
        isTaskDetailLoadEnd = true
    }
    
    func loadTaskDetailCommentsAttach(){
        if AttachmentsLoaded{
            return
        }
        AttachmentsLoaded = true
        //加载回复附件
        let taskDetailInfoObject = taskDetailArray
        
        var itemID = 0
        for detailItem in taskDetailInfoObject{
            if detailItem.value(forKey: "taskimageurl1") as? String != nil && detailItem.value(forKey: "taskimageurl1") as! String != ""{
                let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl1") as! String)"
                let url = URL(string: imageURLString)!
                let currentTag = Int("10\(itemID)10")
                let tempItemID = itemID
                do{
                    let data = try Data.init(contentsOf: url)
                    //截取末尾字段
                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    
                    var image:UIImage?
                    
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        
                        image = getVideoImage(videoUrl: url)
                        
                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        image = UIImage.gif(data:data)
                    }else{
                        //不可预览素材
                    }
                    //AttachmentPics.append(image!)
                    AttachmentPicsArray[tempItemID].append(image!)
                    print("Picture at \(tempItemID),\(0) added to AttachemntPicsArray")
                    DispatchQueue.main.async(execute: {
                        
                        let imageView = self.view.viewWithTag(currentTag!) as! UIImageView
                        
                        imageView.isUserInteractionEnabled = true
                        
                        let tapSingle=UITapGestureRecognizer(target:self,
                                                             action:#selector(self.imageViewTap(_:)))
                        tapSingle.numberOfTapsRequired = 1
                        tapSingle.numberOfTouchesRequired = 1
                        
                        imageView.addGestureRecognizer(tapSingle)
                        
                        imageView.image = UIImage(cgImage:image!.cgImage!)
                        
                        if self.AttachmentTypesArray[tempItemID][0] == "public.movie"{
                            //支持播放的视频格式
                            let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                            playVideoLayer.image = UIImage(named:"playvideoicon-white")
                            imageView.addSubview(playVideoLayer)
                        }else if self.AttachmentTypesArray[tempItemID][0] == "public.image" {
                            let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                            
                            let fnameExtension = self.AttachmentExtensionsArray[tempItemID][0]
                            if !JPGExtentsions.contains(fnameExtension.uppercased()){
                                //不支持播放的视频格式
                                let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                                playVideoLayer.image = UIImage(named:"unableplayvideoicon-white")
                                imageView.addSubview(playVideoLayer)
                                imageView.removeGestureRecognizer(tapSingle)
                            }else{
                                //imageView.loadGif(name: "loadingGif")
                            }
                        }
                        print("begain to reload image 0,0")
//                        DispatchQueue.main.async(execute: {
//                            self.taskContentTableView.reloadData()
//                        })
                        
                    })
                }catch{
                    print(error)
                }
            }
            //第二张图
            if detailItem.value(forKey: "taskimageurl2") as? String != nil && detailItem.value(forKey: "taskimageurl2") as! String != ""{
                let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl2") as! String)"
                let url = URL(string: imageURLString)!
                let currentTag = Int("11\(itemID)10")
                let tempItemID = itemID
                do{
                    let data = try Data.init(contentsOf: url)
                    //截取末尾字段
                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    
                    var image:UIImage?
                    
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        
                        image = getVideoImage(videoUrl: url)
                        
                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        image = UIImage.gif(data:data)
                    }else{
                        //不可预览素材
                    }
                    //AttachmentPics.append(image!)
                    AttachmentPicsArray[tempItemID].append(image!)
                    print("Picture at \(tempItemID),\(1) added to AttachemntPicsArray")
                    DispatchQueue.main.async(execute: {
                        
                        let imageView = self.view.viewWithTag(currentTag!) as! UIImageView
                        
                        imageView.isUserInteractionEnabled = true
                        
                        let tapSingle=UITapGestureRecognizer(target:self,
                                                             action:#selector(self.imageViewTap(_:)))
                        tapSingle.numberOfTapsRequired = 1
                        tapSingle.numberOfTouchesRequired = 1
                        
                        imageView.addGestureRecognizer(tapSingle)
                        
                        imageView.image = UIImage(cgImage:image!.cgImage!)
                        //self.AttachmentPics.append(image!)
                        
                        if self.AttachmentTypesArray[tempItemID][1] == "public.movie"{
                            //支持播放的视频格式
                            let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                            playVideoLayer.image = UIImage(named:"playvideoicon-white")
                            imageView.addSubview(playVideoLayer)
                        }else if self.AttachmentTypesArray[tempItemID][1] == "public.image" {
                            let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                            
                            let fnameExtension = self.AttachmentExtensionsArray[tempItemID][1]
                            if !JPGExtentsions.contains(fnameExtension.uppercased()){
                                //不支持播放的视频格式
                                let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                                playVideoLayer.image = UIImage(named:"unableplayvideoicon-white")
                                imageView.addSubview(playVideoLayer)
                                imageView.removeGestureRecognizer(tapSingle)
                            }
                        }
                        
//                        DispatchQueue.main.async(execute: {
//                            self.taskContentTableView.reloadData()
//                        })
                    })
                }catch{
                    print(error)
                }
            }
            //第三张图：
            if detailItem.value(forKey: "taskimageurl3") as? String != nil && detailItem.value(forKey: "taskimageurl3") as! String != ""{
                let imageURLString = "\(downloadURLHeader)\(detailItem.value(forKey: "taskimageurl3") as! String)"
                let url = URL(string: imageURLString)!
                let currentTag = Int("12\(itemID)10")
                let tempItemID = itemID
                do{
                    let data = try Data.init(contentsOf: url)
                    //截取末尾字段
                    let theFileName = (imageURLString as NSString).lastPathComponent
                    let fnameExtension = theFileName.substring(from: theFileName.index(of: ".")!)
                    let VideoExtensions = [".MOV",".MP4",".FLV",".AVI",".RMVB",".RM"]
                    let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                    
                    var image:UIImage?
                    
                    if VideoExtensions.contains(fnameExtension.uppercased()){
                        
                        image = getVideoImage(videoUrl: url)
                        
                    }else if JPGExtentsions.contains(fnameExtension.uppercased()){
                        //图片格式
                        image = UIImage.gif(data:data)
                    }else{
                        //不可预览素材
                    }
                    //AttachmentPics.append(image!)
                    AttachmentPicsArray[tempItemID].append(image!)
                    print("Picture at \(tempItemID),\(2) added to AttachemntPicsArray")
                    DispatchQueue.main.async(execute: {
                        let imageView = self.view.viewWithTag(currentTag!) as! UIImageView
                        
                        imageView.isUserInteractionEnabled = true
                        
                        let tapSingle=UITapGestureRecognizer(target:self,
                                                             action:#selector(self.imageViewTap(_:)))
                        tapSingle.numberOfTapsRequired = 1
                        tapSingle.numberOfTouchesRequired = 1
                        
                        imageView.addGestureRecognizer(tapSingle)
                        
                        imageView.image = UIImage(cgImage:image!.cgImage!)
                        //self.AttachmentPics.append(image!)
                        
                        if self.AttachmentTypesArray[tempItemID][2] == "public.movie"{
                            //支持播放的视频格式
                            let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                            playVideoLayer.image = UIImage(named:"playvideoicon-white")
                            imageView.addSubview(playVideoLayer)
                        }else if self.AttachmentTypesArray[tempItemID][2] == "public.image" {
                            let JPGExtentsions = [".JPGE",".GIF",".JPG",".PNG",".BMP"]
                            
                            let fnameExtension = self.AttachmentExtensionsArray[tempItemID][2]
                            if !JPGExtentsions.contains(fnameExtension.uppercased()){
                                //不支持播放的视频格式
                                let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                                playVideoLayer.image = UIImage(named:"unableplayvideoicon-white")
                                imageView.addSubview(playVideoLayer)
                                imageView.removeGestureRecognizer(tapSingle)
                            }
                        }
                        
//                        DispatchQueue.main.async(execute: {
//                            self.taskContentTableView.reloadData()
//                        })
                    })
                }catch{
                    print(error)
                }
            }
            itemID += 1
            //AttachmentPicsArray.append(AttachmentPics)
           // self.taskContentTableView.reloadData()
        }
        

        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == LeaveMessageContentTableView{
            countOfContent = taskDetailArray.count - 1
            return countOfContent
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == LeaveMessageContentTableView{ // 任务内容表格
            
            let cell = LeaveMsgContentTableViewCell.customCell(tableView: LeaveMessageContentTableView)
            cell.backgroundColor = UIColor.white//UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
            cell.selectionStyle = .none
            //任务内容

            let detailItem = taskDetailArray[indexPath.row + 1]
            //发送者姓名
            if (detailItem.value(forKey: "tasksendername") as? String == nil){
                cell.senderInContentNameLabel.text = "无名氏："
            }else{
                cell.senderInContentNameLabel.text = "\(detailItem.value(forKey: "tasksendername") as! String):"
            }
            //发送时间
            if (detailItem.value(forKey: "tasksendtime") as? String == nil) || detailItem.value(forKey: "tasksendtime") as! String == "null"{
                cell.sendTimeInCotentLabel.text = "2018-01-01 00:00:00"
            }else{
                cell.sendTimeInCotentLabel.text = detailItem.value(forKey: "tasksendtime") as! String
            }
            
            //发送内容
            if (detailItem.value(forKey: "taskinfo") as? String == nil){
                cell.contentLabel.text = "无指定内容"
                cell.contentLabel.textColor = UIColor.colorWithRgba(100, g: 100, b: 100, a: 1.0)
            }else{
                cell.contentLabel.text = detailItem.value(forKey: "taskinfo") as! String
                cell.contentLabel.textColor = UIColor.black
            }
            
            let height = autoLabelHeight(with: cell.contentLabel.text!, labelWidth: UIScreen.main.bounds.width - 75, textFont: cell.contentLabel.font)
            
            cell.contentLabel.numberOfLines = 100//Int(height/23)
            
            cell.contentLabel.frame =  CGRect(x: 20, y: 43, width: UIScreen.main.bounds.width - 75, height: height + 10)
            
            
            //附件图片数量
            var imageCount = 0
            if detailItem.value(forKey: "taskimageurl1") as? String != nil && detailItem.value(forKey: "taskimageurl1") as! String != ""{
                imageCount += 1
            }
            if detailItem.value(forKey: "taskimageurl2") as? String != nil && detailItem.value(forKey: "taskimageurl2") as! String != ""{
                imageCount += 1
            }
            if detailItem.value(forKey: "taskimageurl3") as? String != nil && detailItem.value(forKey: "taskimageurl3") as! String != ""{
                imageCount += 1
            }
            
            attachmentPicCount[indexPath.row + 1] = imageCount
            
            if imageCount != 0{
                //修改导航栏返回按钮文字
                var count = 0
                for i in 0..<attachmentPicCount[indexPath.row + 1]{
                    let AttachPic = UIImageView()
                    
                    let yOfAttachPic = Int(cell.contentLabel.frame.maxY + 12)
                    
                    AttachPic.frame = CGRect(x: 20 + i * 78, y: yOfAttachPic , width: 68, height: 68)
                    let StringTag = "1\(i)\(indexPath.row + 1)\(10)"
                    AttachPic.layer.cornerRadius = 6
                    AttachPic.layer.masksToBounds = true
                    AttachPic.tag = Int(StringTag)!
                    AttachPic.contentMode = .scaleAspectFill
                    AttachPic.clipsToBounds = true
                    
                    if AttachmentPicsArray.count == 0{
                        AttachPic.image =  UIImage(named: "defualt-design-pic-loading")
                    }else{
                        if AttachmentPicsArray[indexPath.row +  1].count == 0{
                            AttachPic.image = UIImage(named: "defualt-design-pic-loading")
                        }else{
                            if i >= AttachmentPicsArray[indexPath.row + 1].count{
                               AttachPic.image =  UIImage(named: "defualt-design-pic-loading")
                            }else{
                                print("loaded image at\(indexPath.row + 1),\(i)")
                                AttachPic.image = AttachmentPicsArray[indexPath.row + 1][i]//UIImage(cgImage: AttachmentPicsArray[indexPath.row][i].cgImage!)
                            }
                        }
                    }
                    if self.view.viewWithTag(Int(StringTag)!) == nil{
                        cell.contentView.addSubview(AttachPic)
                        print("AttachPic add count\(count+1)")
                    }
                }
            }
            
            var heightForFooterItems = cell.contentLabel.frame.height + 28
            if imageCount != 0 {
                heightForFooterItems = cell.contentLabel.frame.height + 98
            }
            cell.replyBtn.frame = CGRect(x: UIScreen.main.bounds.width - 44, y: heightForFooterItems, width: 40, height: 20)
            replySelectorParamters[indexPath.row + 1] = "\(indexPath.row + 1)"
            cell.replyBtn.tag = indexPath.row + 1
            cell.replyBtn.addTarget(self, action: #selector(replyBtnClicked), for: .touchUpInside)
           // cell.sendTimeInCotentLabel.frame = CGRect(x: 60, y: heightForFooterItems, width: 120, height: 20)
            return cell
            
        }else{
            //任务回复
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55 - 300))
            cell.backgroundColor = UIColor.white//UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
            cell.selectionStyle = .none
    
            //上传图片
//            progressBtn.isHidden = true
            progressLabel.isHidden = true
//            progressBtn.backgroundColor = UIColor.white
//            cell.contentView.addSubview(progressBtn)
            replyTaskView.addSubview(progressLabel)
    
            cell.contentView.addSubview(replyTextView)
            cell.contentView.addSubview(textNumberLimit)
            if self.view.viewWithTag(10) != nil{
                self.view.viewWithTag(10)?.removeFromSuperview()
            }
            if self.view.viewWithTag(11) != nil{
                self.view.viewWithTag(11)?.removeFromSuperview()
            }
            if self.view.viewWithTag(12) != nil{
                self.view.viewWithTag(12)?.removeFromSuperview()
            }
            
            if attachmentPicCountInReply != 0{
                //修改导航栏返回按钮文字
                for i in 0..<attachmentPicCountInReply{
                    let AttachPic = UIImageView()
                    AttachPic.frame = CGRect(x: 20 + i * 78, y: Int(UIScreen.main.bounds.height - 465 + iPhoneXHeightChange) , width: 68, height: 68)
                    AttachPic.tag = i + 10
                    AttachPic.contentMode = .scaleAspectFill
                    AttachPic.clipsToBounds = true
                    AttachPic.image = UIImage(cgImage: AttachmentPicsInReply[i].cgImage!)
                    if AttachmentTypesInReply[i] == "public.movie"{ //如果是视频
                        let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 30, height: 30))
                        playVideoLayer.image = UIImage(named:"playvideoicon-white")
                        AttachPic.addSubview(playVideoLayer)
                    }
                    AttachPic.isUserInteractionEnabled = true
                    
                    cell.contentView.addSubview(AttachPic)
                    
                    let tapSingle=UITapGestureRecognizer(target:self,
                                                         action:#selector(imageViewTapInReply(_:)))
                    tapSingle.numberOfTapsRequired = 1
                    tapSingle.numberOfTouchesRequired = 1
                    
                    AttachPic.addGestureRecognizer(tapSingle)
                }
                if attachmentPicCountInReply == 3{
//                    uploadPicBtn.isEnabled = false
//                    uploadPicBtn.layer.borderColor = UIColor.gray.cgColor
                }
            }else{
                if self.view.viewWithTag(10) != nil{
                    self.view.viewWithTag(10)?.removeFromSuperview()
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == LeaveMessageContentTableView{
            let detailItem = taskDetailArray[indexPath.row + 1]
            
            var labelContent = ""
            //发送内容
            if (detailItem.value(forKey: "taskinfo") as? String == nil){
                labelContent = "无指定内容"
            }else{
                labelContent = detailItem.value(forKey: "taskinfo") as! String
            }
            
            let tempCellHeight = autoLabelHeight(with: labelContent, labelWidth: UIScreen.main.bounds.width - 75, textFont: UIFont.systemFont(ofSize: 13))
            
            
            if attachmentPicCount[indexPath.row + 1] != 0{
                return tempCellHeight + 78+68//150
            }else{
                if self.view.viewWithTag(10) != nil{
                    self.view.viewWithTag(10)?.removeFromSuperview()
                }
                return tempCellHeight + 78
            }
            
        }else{
            //回复表格
            if UIDevice.current.isX(){
                iPhoneXHeightChange = 35.0
            }else{
                iPhoneXHeightChange = 0.0
            }

            if attachmentPicCountInReply == 0 {
                replyTextView.frame = CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 410 + iPhoneXHeightChange))
                textNumberLimit.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY-30, width: 100, height: 40)
//                progressBtn.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY+10, width: 30, height: 30)
//                return UIScreen.main.bounds.height - 345
                
            }else{
                replyTextView.frame = CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 480 + iPhoneXHeightChange))
                textNumberLimit.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY+10, width: 100, height: 40)
//                progressBtn.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY+10, width: 30, height: 30)
            }
            return UIScreen.main.bounds.height - 345
        }
        
    }
    
    func replyViewWithOptions(sender:String){
        isRepling = true
        greyMask.backgroundColor = UIColor.black
        greyMask.alpha = 0.4
        //replyTaskView.fatherVC = self // 将目前的UIViewController作为父节点传递过去
        
        
        replyTaskView.backgroundColor = UIColor.white
        replyTaskView.layer.cornerRadius = 8
        replyTaskView.addSubview(replyTaskTableView)
        
        placeholderLabel.frame = CGRect(x:5 , y:5, width:200, height:20)
        placeholderLabel.font = UIFont.systemFont(ofSize: 13)
        replyTextView.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.colorWithRgba(72, g: 82, b: 93, a: 1.0)
        textNumberLimit.text = "\(replyTextView.text.count)\\300"

        textNumberLimit.textAlignment = .right
        textNumberLimit.font = UIFont.systemFont(ofSize: 13)
        textNumberLimit.textColor = UIColor.gray
        
        replyTaskViewTitle.text = "消息回复"
        replyTaskViewTitle.font = UIFont.boldSystemFont(ofSize: 18)
        replyTaskViewTitle.textColor = UIColor.black
        replyTaskViewTitle.textAlignment = .center
        
        cancelBtnOnReplyView.frame =  CGRect(x: 10, y: 15, width: 41, height: 30)
        cancelBtnOnReplyView.setTitle("取消", for: .normal)
        cancelBtnOnReplyView.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelBtnOnReplyView.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal) 
        cancelBtnOnReplyView.addTarget(self, action: #selector(singleTap(recognizer:)), for: .touchUpInside)
        
        doneBtnOnReplyView.frame =  CGRect(x: UIScreen.main.bounds.width - 50, y: 15, width: 41, height: 30)
        doneBtnOnReplyView.setTitle("发送", for: .normal)
        doneBtnOnReplyView.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
        doneBtnOnReplyView.setTitleColor(UIColor.gray, for: .disabled)//禁用状态下文字的颜色
        doneBtnOnReplyView.isEnabled = false
        doneBtnOnReplyView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        doneBtnOnReplyView.addTarget(self, action: #selector(doneBtnTaped), for: .touchUpInside)
        
        
//        let myAttribute =  [NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)]
//        let myAttriString = NSAttributedString(string: "回复 \(sender) :", attributes: myAttribute as [NSAttributedStringKey : Any])
        
        placeholderLabel.text = "回复 \(sender) :"
        replyTextView.delegate = self
        //replyTaskView.replyTextView.attributedText = myAttriString
        //replyTaskView.replyTextView.allowsEditingTextAttributes = false
        replyTaskView.addSubview(replyTaskViewTitle)
        replyTaskView.addSubview(cancelBtnOnReplyView)
        replyTaskView.addSubview(doneBtnOnReplyView)
        
        //初始化值
        self.view.addSubview(greyMask)
        self.view.addSubview(replyTaskView)
        
        //loadNewTaskView()
        //禁用了点击灰色区域收起view的功能
        //        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(singleTap))
        //        //检测灰层点击手势
        //        greyMask.addGestureRecognizer(gestureRecognizer)
        
        //播放不遮眼动画
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.replyTaskView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height - 35))
            UIView.setAnimationCurve(UIViewAnimationCurve.linear)
            UIView.setAnimationRepeatAutoreverses(true)
            UIView.commitAnimations()
        })
        replyTextView.becomeFirstResponder()

    }
    
    //MARK3 - Text View控制区域
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
//        topView.barStyle =  .default
        topView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        topView.backgroundColor = UIColor.gray
        //let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //attachmentCameraBtn.tintColor = UIColor.gray
        let blankView:UIView = UIView.init(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width - 160, height: 50))
        let blankViewItem =  UIBarButtonItem(customView: blankView)

        
        let cameraBtn:UIButton = UIButton.init(frame: CGRect(x: 100, y: 10, width: 80, height: 40))
        cameraBtn.setImage(UIImage(named:"cameraicon-gray"), for: .normal)
        cameraBtn.setImage(UIImage(named:"cameraicon-red"), for: .highlighted)
        cameraBtn.addTarget(self, action: #selector(cameraBtnClicked), for: .touchUpInside)
        let attachmentCameraBtn =  UIBarButtonItem(customView: cameraBtn)
        
        let albumBtn:UIButton = UIButton.init(frame: CGRect(x: 100, y: 10, width: 80, height: 40))
        albumBtn.setImage(UIImage(named:"albumicon-gray"), for: .normal)
        albumBtn.setImage(UIImage(named:"albumicon-red"), for: .highlighted)
        albumBtn.addTarget(self, action: #selector(albumBtnClicked), for: .touchUpInside)
        let attachmentAlbumBtn =  UIBarButtonItem(customView: albumBtn)
        

        let buttonsArray = [blankViewItem,attachmentCameraBtn,attachmentAlbumBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        
        textView.inputAccessoryView = topView
        return true
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            doneBtnOnReplyView.isEnabled = false
            placeholderLabel.isHidden = false
        }else{
            doneBtnOnReplyView.isEnabled = true
            placeholderLabel.isHidden = true
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            textNumberLimit.text = "0\\300"
            textNumberLimit.textColor = UIColor.gray
            placeholderLabel.isHidden = false
            doneBtnOnReplyView.isEnabled = false
        }else{
            textNumberLimit.text = "\(replyTextView.text.count)\\300"
            if replyTextView.text.count > 300{
               textNumberLimit.textColor = UIColor.red
            }else{
                textNumberLimit.textColor = UIColor.gray
            }
                placeholderLabel.isHidden = true
                doneBtnOnReplyView.isEnabled = true
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        placeholderLabel.isHidden = true
        doneBtnOnReplyView.isEnabled = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            placeholderLabel.isHidden = false
            doneBtnOnReplyView.isEnabled = false
        }else{
            placeholderLabel.isHidden = true
            doneBtnOnReplyView.isEnabled = true
        }
    }
    
    //获取原图
    func PHAssetToUIImage(asset: PHAsset){
        var tempHDImage = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        imageRequestOption.isNetworkAccessAllowed = true
        // 按照PHImageRequestOptions指定的规则取出图片
        
        // newTaskViewTitle.text = "正在同步iCloud图片..." //上传图片
        imageRequestOption.progressHandler = { (progress, error, stop, info) in
            //可以控制进度条
            print(progress)
            if progress != 1.0 {
                DispatchQueue.main.async(execute: {
                    self.progressLabel.text = String("从iCloud下载:\(Int(progress*100))%")
                   // self.progressBtn.progress = CGFloat(progress)
                    self.progressLabel.isHidden = false
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.progressLabel.isHidden = true
                   // self.updateCellView(tableView: self.replyTaskTableView)
                })
            }
        }
        if asset.mediaType == .video{
            
            let options:PHVideoRequestOptions = PHVideoRequestOptions.init()
            options.version = .current
            options.deliveryMode = .automatic
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            
            
            options.progressHandler = { (progress, error, stop, info) in
                //可以控制进度条
                print(progress)
                if progress != 1.0 {
                    DispatchQueue.main.async(execute: {
                        self.progressLabel.text = String("从iCloud下载:\(Int(progress*100))%")
                        self.progressLabel.isHidden = false
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.progressLabel.isHidden = true
                      //  self.updateCellView(tableView: self.replyTaskTableView)
                    })
                }
            }
            
            let videoRequstManager:PHCachingImageManager = PHCachingImageManager.init()// PHImageManager = PHImageManager.default()
            
            DispatchQueue.global(qos: .background).async(execute: {
                videoRequstManager.requestAVAsset(forVideo: asset, options: options, resultHandler: {(AVAsset,nil,infos) -> Void in
                    let urlAssets = AVAsset as? AVURLAsset
                    var data = NSData.init(contentsOf: (urlAssets?.url)!)
                    
                    
                    imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill, options: imageRequestOption, resultHandler: {(result,info) in
                        tempHDImage = result! //如果是图片
                        
                        self.AttachmentPicsInReply.append(tempHDImage)
                    })
                    //图片保存的路径
                    //这里将图片放在沙盒的documents文件夹中
                    
                    //Home目录
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/TaskAttachmentReply"
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                    do {
                        try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    
                    var fnameIndex = "00"
                    if self.attachmentPicCountInReply == 0 {
                        fnameIndex = "00"
                    }else if self.attachmentPicCountInReply == 1{
                        fnameIndex = "01"
                    }else if self.attachmentPicCountInReply == 2{
                        fnameIndex = "02"
                    }else {
                        fnameIndex = "03"
                    }
                    
                    // let fileExtent = "MP4"
                    
                    let fnameWithExtend = "/image00\(fnameIndex).MP4"
                    
                    let imagePath = documentPath.appending(fnameWithExtend)
                    fileManager.createFile(atPath: imagePath, contents: data! as Data, attributes: nil)
                    //得到选择后沙盒中图片的完整路径
                    let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
                    //将图片插入到imageURLs
                    self.imageURLsInReply.append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.previewURLsInReply.append((urlAssets?.url)!)
                    self.attachmentPicCountInReply += 1
                    
                    self.AttachmentTypesInReply.append("public.movie")// 视频或者视频
                    DispatchQueue.main.async(execute: {
                        self.progressLabel.isHidden = true
                        self.updateCellView(tableView: self.replyTaskTableView)
                        self.replyTextView.becomeFirstResponder()
                    })
                })
                
            })
        }else{
            //获取原图
            DispatchQueue.global(qos: .background).async {
                imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill, options: imageRequestOption, resultHandler: {(result,info) in
                    tempHDImage = result! //如果是图片
                    
                    //先把图片转成NSData
                    let data = UIImageJPEGRepresentation(tempHDImage, 0.5)
                    
                    //图片保存的路径
                    //这里将图片放在沙盒的documents文件夹中
                    
                    //Home目录
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/TaskAttachmentReply"
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                    do {
                        try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    
                    var fnameIndex = "00"
                    if self.attachmentPicCountInReply == 0 {
                        fnameIndex = "00"
                    }else if self.attachmentPicCountInReply == 1{
                        fnameIndex = "01"
                    }else if self.attachmentPicCountInReply == 2{
                        fnameIndex = "02"
                    }else {
                        fnameIndex = "03"
                    }
                    
                    
                    let fnameWithExtend = "/image00\(fnameIndex).png"
                    let imagePath = documentPath.appending(fnameWithExtend)
                    fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
                    //fileManager.createFileAtPath(documentPath.append("/image.png"), contents: data, attributes: nil)
                    //得到选择后沙盒中图片的完整路径
                    let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
                    //将图片插入到imageURLs
                    self.imageURLsInReply.append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.previewURLsInReply.append(urls)
                    self.attachmentPicCountInReply += 1
                    self.AttachmentPicsInReply.append(tempHDImage)
                    self.AttachmentTypesInReply.append("public.image")// 视频或者视频
                    DispatchQueue.main.async(execute: {
                        self.progressLabel.isHidden = true
                        self.updateCellView(tableView: self.replyTaskTableView)
                        self.replyTextView.becomeFirstResponder()
                    })
                    //self.updateCellView(tableView: self.newTaskTableView)
                })
            }
        }
        
    }
    
    func updateCellView(tableView:UITableView) {
        tableView.reloadData()
    }
    
    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        isKeyboardHidden = false
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        if replyTextView.isFirstResponder{
            if UIDevice.current.isX(){
                iPhoneXHeightChange = 35.0
            }else{
                iPhoneXHeightChange = 0.0
            }

        }
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_notification: Notification){
        
        let kbInfo = _notification.userInfo
        isKeyboardHidden = true
        /*
         swift2.3正常，swift3.0取值为nil
         */
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        if replyTextView.isFirstResponder {
//            UIView.animate(withDuration: duration, animations: {()->Void in
//                self.newTaksView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-35))// -632
//                print("向下移动y=\(UIScreen.main.bounds.height + 300)")
//            })
        }
        
       // replyTaskTableView.reloadData()
    }
    func deleteAttachment(atIndex:Int){
        if atIndex >= AttachmentPicsInReply.count {
            print("can't found this pic becasue out of range")
        }else{
            AttachmentPicsInReply.remove(at: atIndex)
            AttachmentTypesInReply.remove(at: atIndex)
            //文件管理器
            let fileManager: FileManager = FileManager.default
            let imagePath = imageURLsInReply[atIndex]
            
            do {
                try fileManager.removeItem(atPath: imagePath)
            }
            catch  {
                print("something wrong was happening")
            }
            imageURLsInReply.remove(at: atIndex)
            previewURLsInReply.remove(at: atIndex)
            attachmentPicCountInReply -= 1
            updateCellView(tableView: replyTaskTableView)
            print("delete row called succedd")
        }
    }
    
    //上传附件，并返回附件名称
    func uploadFiles(images:[String])->[String]{
        
        //请求用到的参数
        var Bucket = "resource-1255653994"
        #if DEBUG
            Bucket = "test-1255653994"
        #else
            Bucket = "resource-1255653994"
        #endif
        
        //定义请求参数
        var fileUrls:[String] = []
        //循环次数控制
        var LoopMaxCount = images.count
        var LoopCurrentCount = 1
        for image in images{
            do{
                
                let fileLocalUrl:NSURL = NSURL.fileURL(withPath: image) as NSURL
                
                let fnameExtension = image.substring(from: image.index(of: ".")!)
                
                let upload = QCloudCOSXMLUploadObjectRequest<AnyObject>()
                upload.body = fileLocalUrl
                upload.bucket = Bucket
                
                let date = NSDate()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyyMMdd"
                let strNowTime = timeFormatter.string(from: date as Date) as String
                let fnameInDataBase = "task/\(strNowTime)/\(getRandomName())\(fnameExtension)"
                upload.object = "/\(fnameInDataBase)"
                
                greyLayerPrompt.show(text: "回复创建中:开始上传附件")
                upload.setFinish({ (result, error) in
                    DispatchQueue.main.async {
                        print("上传成功图片\(LoopCurrentCount)")
                        if (error != nil) {
                            print("something was wrong,Error message:\(String(describing: error?.localizedDescription))")
                        }else{
                            
                            print("***************图片上传完了，准备创建任务********************")
                            if LoopMaxCount == LoopCurrentCount{
                                print("当前成功上传图片\(LoopMaxCount),开始创建任务task")
                                self.createTaskList()//创建任务在图片上传成功后
                            }else{
                                print("当前成功上传图片\(LoopCurrentCount),不执行CreateTaskList")
                            }
                            print("result:\(result?.qcloud_modelToJSONString() ?? "complte")")
                            greyLayerPrompt.show(text: "回复创建中:附件\(LoopCurrentCount)上传成功")
                            LoopCurrentCount += 1
                        }
                    }
                })
                
                let defaultCOSTRANSFERMANGER:QCloudCOSTransferMangerService = QCloudCOSTransferMangerService.defaultCOSTransferManager()
                defaultCOSTRANSFERMANGER.uploadObject(upload)
                fileUrls.append(fnameInDataBase)//
            }catch{
                print("URL create failded")
            }
            
        }
        return fileUrls
    }

    
    //发送按钮点击
    func createTaskList(){
        //uploadFiles
        //标记正在创建任务
        if isReplyCreating == true{
            greyLayerPrompt.show(text: "上一个回复还在发布中，请稍后再试")
            return
        }
        isDataInReplyViewCleared = false
        isReplyCreating = true
        //        if imageURLs.count != 0{
        //            taskImages = uploadFiles(images: imageURLs)
        //        }
        //loading文字
        let preventingView:UIView = UILabel.init(frame: CGRect(x: 0, y: 0, width: replyTaskView.bounds.width, height: replyTaskView.bounds.height))
        preventingView.backgroundColor = UIColor.white
        preventingView.tag = 1010
        preventingView.alpha = 0.4
        
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
        noticeWhenLoadingData.text = "发送中..."
        noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
        noticeWhenLoadingData.textColor = UIColor.gray
        noticeWhenLoadingData.textAlignment = .center
        //loading动画
        var images:[UIImage] = []
        for i in 0...27{
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named:imagePath)!
            images.append(image)
        }
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        if replyTaskView.subviews.contains(preventingView) {
            print("view exists")
        }else{
            print("view not exists")
            replyTaskView.addSubview(preventingView)
            preventingView.addSubview(imageView)
            preventingView.addSubview(noticeWhenLoadingData)
        }
        // let tempTest = uploadAttachmentsFiles()// 测试用的
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let requestURL:String = apiAddresses.value(forKey: "taskReplyAPIDebug") as! String
        #else
            let requestURL:String = apiAddresses.value(forKey: "taskReplyAPI") as! String
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
                params["roletype"] = UserDefaults.standard.value(forKey: "currentRoleType") as! Int
                params["commandcode"] = 91
                params["operatecode"] = 1
                params["taskid"] = currentTaskID
                params["taskinfo"] = replyTextView.text
                params["tasktype"] = currentTaskType
                
                if taskImages.count == 0{
                    params["taskimageurl1"] = ""
                    params["taskimageurl2"] = ""
                    params["taskimageurl3"] = ""
                }else if taskImages.count == 1 {
                    params["taskimageurl1"] = taskImages[0]
                    params["taskimageurl2"] = ""
                    params["taskimageurl3"] = ""
                }else if taskImages.count == 2{
                    params["taskimageurl1"] = taskImages[0]
                    params["taskimageurl2"] = taskImages[1]
                    params["taskimageurl3"] = ""
                }else if taskImages.count == 3{
                    params["taskimageurl1"] = taskImages[0]
                    params["taskimageurl2"] = taskImages[1]
                    params["taskimageurl3"] = taskImages[2]
                }else{
                    print("Something was wrong in taskImages")
                    params["taskimageurl1"] = ""
                    params["taskimageurl2"] = ""
                    params["taskimageurl3"] = ""
                }
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
        
        _ = Alamofire.request(requestURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                print("update successed")
                greyLayerPrompt.show(text: "回复成功")
                self.replyTaskView.viewWithTag(1010)?.removeFromSuperview()
                self.clearDataInReplyView()
                self.refresh()
                //print("***************任务创建成功********************")
                self.isReplyCreating = false
            case false:
                print("update failed")
                self.isReplyCreating = false
                if self.view.viewWithTag(1010) != nil {
                    self.view.viewWithTag(1010)?.removeFromSuperview()// preventing view removed
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print(responseObject.result.error ?? "No result found")
                    greyLayerPrompt.show(text: "回复保存，请稍后再试")
                }
            }
        }
    }
    func clearDataInReplyView(){
        
        
        textNumberLimit.text = "0\\300"
        AttachmentPicsInReply.removeAll()
        AttachmentTypesInReply.removeAll()
        replyTextView.text = ""
        replyTaskTableView.reloadData()
        //文件管理器
        for i in imageURLsInReply {
            let fileManager: FileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: i)
            }
            catch  {
                print("something wrong was happening")
            }
        }
        imageURLsInReply.removeAll()
        previewURLsInReply.removeAll()
        taskImages.removeAll()
        isDataInReplyViewCleared = true
        //newTaskTableView.beginUpdates()
        //newTaskTableView.endUpdates()
    }
    
    @objc func doneBtnTaped(){
        print("hello，Done button tapped")
        
        //上传图片
        //var taskImages:[String] = []
        if imageURLsInReply.count != 0{
            taskImages = uploadFiles(images: imageURLsInReply)
        }else{
            createTaskList()//创建任务
        }
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.replyTaskView.transform = CGAffineTransform(translationX: 0, y:(UIScreen.main.bounds.height - 35))
            UIView.setAnimationCurve(UIViewAnimationCurve.linear)
            UIView.setAnimationRepeatAutoreverses(true)
            UIView.commitAnimations()
        }, completion: {
            Void in
            //移除所有子视图
//            for childview in self.newTaksView.subviews{
//                childview.removeFromSuperview()
//            }
            self.replyTaskView.removeFromSuperview()
            //self.newTaskTableView.removeFromSuperview()
        })
        self.greyMask.removeFromSuperview()
    }
    
    //取消按钮点击
    @objc func singleTap(recognizer:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.replyTaskView.transform = CGAffineTransform(translationX: 0, y:(UIScreen.main.bounds.height - 35))
            UIView.setAnimationCurve(UIViewAnimationCurve.linear)
            UIView.setAnimationRepeatAutoreverses(true)
            UIView.commitAnimations()
        }, completion: {
            Void in
            self.isRepling = false
            self.replyTaskView.removeFromSuperview()
            self.replyTextView.becomeFirstResponder()
            //self.newTaskTableView.removeFromSuperview()
        })
        self.greyMask.removeFromSuperview()
        //print("关闭\(newTaksView.subviews.count)")
        
    }
    
    @objc func albumBtnClicked(){
        print("Album button clicked")
        //开始选择照片，最多允许选择4张
        let allowChooseCount = 3 - self.attachmentPicCountInReply
        if allowChooseCount == 0{
            greyLayerPrompt.show(text: "最多上传三张附件")
        }else{
            _ = self.presentHGImagePicker(maxSelected:allowChooseCount) { (assets) in
                //结果处理
                print("共选择了\(assets.count)张图片，分别如下：")
                self.replyTextView.becomeFirstResponder()
                for asset in assets {
                    self.PHAssetToUIImage(asset: asset)
                }
            }
        }
    }
    @objc func cameraBtnClicked(){
        print("camera button clicked")
        let allowChooseCount = 3 - self.attachmentPicCountInReply
        if allowChooseCount == 0{
            greyLayerPrompt.show(text: "最多上传三张附件")
        }else{
            //断是否能进行拍照，可以的话打开相机
            self.replyTextView.becomeFirstResponder()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                //根据指定的SourceType来获取该SourceType下可以用的媒体类型，返回的是一个数组
                let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)! as NSArray
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera//.camera
                picker.mediaTypes = (mediaTypeArr as [AnyObject]) as! [String] //允许视频
                picker.videoQuality = .typeHigh
                picker.allowsEditing = false
                picker.videoMaximumDuration = 15
                picker.delegate = self //as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                picker.allowsEditing = false
                picker.modalPresentationStyle = .fullScreen
                self.present(picker, animated: true, completion: nil)
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
                }
            
        }
    }
    @objc func replyBtnClicked(_ button:UIButton){
        print("点击回复")

        for row in replySelectorParamters.values{
            if row == "\(button.tag)"{
                selectedIndex = button.tag
            }
        }
        var sendername = "无名氏"
        if taskDetailArray[selectedIndex].value(forKey: "tasksendername") as? String == nil{
            sendername = "无名氏"
        }else{
            sendername = taskDetailArray[selectedIndex].value(forKey: "tasksendername") as! String
        }
        
        replyViewWithOptions(sender: sendername)
    }
    
    
    @objc func changeDeadLineFormat(deadLineInMins:Int)->String{
        
        var formatedString:String = "0分钟"
        var days = 0
        var hrs = 0
        var mins = 0
        let deadLineInSeconds = deadLineInMins * 60
        // print("deadLine to Int\(Int(deadLineInMins))")
        
        if deadLineInSeconds < 60{
            mins = 0
            formatedString = "\(mins)分钟"
        }else{
            //> 60秒时
            mins = (Int(deadLineInSeconds)/60)%60
            if Int(deadLineInSeconds)/60 < 60{
                formatedString = "\(mins)分钟"
            }else {
                // > 60分钟时
                hrs = Int(deadLineInSeconds)/60/60
//                if Int(deadLineInSeconds)/60 < 60*24{
//                    //< 60*24分钟
                    formatedString = "\(hrs)小时\(mins)分钟"
//                }else{
//                    //60*24分钟
//                    days = Int(deadLineInSeconds)/60/60/24
//                    formatedString = "\(days)天 \(hrs)小时 \(mins)分钟"
//                }
            }
        }
        return formatedString
    }
    
    @objc func taskFinishedBtnClicked(){
        print("完成任务点击了")
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["operatecode"] = 4
        params["taskid"] = currentTaskID

        
        
        #if DEBUG
           let requestUrl = apiAddresses.value(forKey: "taskFinishedAPIDebug") as! String
        #else
           let requestUrl = apiAddresses.value(forKey: "taskFinishedAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["status","code"].int!
                    if statusObject == 0{
                        print("完成任务成功")
                        greyLayerPrompt.show(text: "任务完成")
                        self.cancelBtnClicked()
                    }else{
                        print("结束任务失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "任务完成失败,请重试")
            }
        }
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageViewTapInReply(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        //进入图片全屏展示
        
        let previewVC = ImagePreviewVC(images: AttachmentPicsInReply, index: (index-10), previewMode: .previewWithDelete)
        previewVC.imageUrls = self.previewURLsInReply
        previewVC.PreviewType = AttachmentTypesInReply
        previewVC.taskDetailReplyObject = self
        previewVC.previewSourceVC = "ReplyTaskVC"
        //  previewVC.previewMode = .previewWithDelete
        previewVC.modalPresentationStyle = .fullScreen
        self.present(previewVC, animated: true, completion: nil)

    }
    //缩略图imageView点击
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //let StringTag = "1\(i)\(indexPath.row)\(10)"
        //图片索引
        let tag = String(recognizer.view!.tag)
        let indexInString = tag.index(tag.startIndex, offsetBy:2)
        //图片索引
        let index = Int(tag.substring(to: indexInString))! - 10
        
        //图片数组位置索引
        let endIndex1 = tag.index(tag.startIndex, offsetBy: tag.lengthOfBytes(using: .utf8))
        let startIndex1 = tag.index(tag.startIndex, offsetBy: 2)
        let tempIndexInArray = tag.substring(with:startIndex1..<endIndex1)
        
        let endIndex2 = tempIndexInArray.index(tempIndexInArray.startIndex, offsetBy: tempIndexInArray.lengthOfBytes(using: .utf8)-2)
        let indexInArray = Int(tempIndexInArray.substring(with: tempIndexInArray.startIndex..<endIndex2))
        
        
        //进入图片全屏展示
        let previewVC = ImagePreviewVC(images:AttachmentPicsArray[indexInArray!] , index: index, previewMode: .previewWithoutDelete)
        previewVC.PreviewType = AttachmentTypesArray[indexInArray!]
        previewVC.imageUrls = previewURLsArray[indexInArray!]
        // previewVC.roleType = roleType
        //previewVC.previewMode = PreviewModeType.previewWithoutDelete
        previewVC.modalPresentationStyle = .fullScreen
        self.present(previewVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(currentTaskID:String,currentCustomid:String,currentOrderID:String,currentGoodsID:String,currentTaskType:Int) {
        self.currentTaskID = currentTaskID
        self.currentCustomid = currentCustomid
        self.currentTaskType = currentTaskType
        self.currentGoodsID = currentGoodsID
        self.currentOrderID = currentOrderID

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载数据
    func loadOrderDataFromServer() {
        //去除未完成的数据请求
        for task in LeaveMsgDetailViewController.requestCacheArr{
            task.cancel()
        }
        LeaveMsgDetailViewController.requestCacheArr.removeAll()
        //先删除重试按钮
        if self.view.viewWithTag(300) != nil{ //200,201tag是重试按钮的view
            self.view.viewWithTag(300)?.removeFromSuperview()
            self.view.viewWithTag(301)?.removeFromSuperview()
        }
        //先删除没有订单的提示信息
        if self.view.viewWithTag(701) != nil{
            self.view.viewWithTag(701)?.removeFromSuperview()
            self.view.viewWithTag(702)?.removeFromSuperview()
            self.view.viewWithTag(703)?.removeFromSuperview()
        }
        
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
        noticeWhenLoadingData.text = "加载中，请稍侯..."
        noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
        noticeWhenLoadingData.textColor = UIColor.gray
        noticeWhenLoadingData.textAlignment = .center
        //loading动画
        var images:[UIImage] = []
        for i in 0...27{
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named:imagePath)!
            images.append(image)
        }
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()

        self.view.addSubview(imageView)
        self.view.addSubview(noticeWhenLoadingData)

        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        
        #if DEBUG
            var detailOfURL:String = apiAddresses.value(forKey: "taskDetailAPIDebug") as! String
        #else
            var detailOfURL:String = apiAddresses.value(forKey: "taskDetailAPI") as! String
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
                params["roletype"] = UserDefaults.standard.value(forKey: "currentRoleType") as! Int
                params["commandcode"] = 93//查看任务详情
                params["taskid"] = currentTaskID
                params["taskType"] = currentTaskType
                if currentTaskType != 0{
                    params["customid"] = currentCustomid//查看任务详情
                    params["orderid"] = currentOrderID
                    params["goodsid"] = currentGoodsID
                }
                
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
        
        let dataRequest = Alamofire.request(detailOfURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    self.taskDetailArray.removeAll()
                    //print(json)
                    for item in json["taskdetailinfo"].array! {
                        let restoreItem = item.dictionaryObject! as NSDictionary
                        self.taskDetailArray.append(restoreItem)
                    }
                    //self.taskInfoDic = nil
                    self.taskInfoDic = json["taskinfo"].dictionaryObject! as NSDictionary
                    imageView.removeFromSuperview()
                    noticeWhenLoadingData.removeFromSuperview()
                }
                self.LeaveMessageContentTableView.reloadData()
                self.LeaveMessageContentTableView.es.stopPullToRefresh()
                self.isTaskDetailLoadEnd = true
            case false:
                imageView.removeFromSuperview()
                noticeWhenLoadingData.removeFromSuperview()
                if responseObject.result.error?.localizedDescription != "cancelled" && responseObject.result.error?.localizedDescription as! String != "已取消"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print(responseObject.result.error ?? "No result found")
                        greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                        let loadingFailedLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200))
                        loadingFailedLabel.text = "加载失败，请重试..."
                        loadingFailedLabel.tag = 300
                        loadingFailedLabel.font = UIFont.systemFont(ofSize: 14)
                        loadingFailedLabel.textColor = UIColor.gray
                        loadingFailedLabel.textAlignment = .center
                        
                        let retryBtn:UIButton = UIButton.init(type: .system)
                        retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 - 50, width: 150, height: 44)
                        retryBtn.backgroundColor = UIColor.white
                        retryBtn.layer.cornerRadius = 5
                        retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
                        retryBtn.layer.borderWidth = 1
                        retryBtn.setTitle("重试", for: .normal)
                        retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
                        retryBtn.tag = 301
                        retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
                        //先删除重试按钮
                        self.view.viewWithTag(300)?.removeFromSuperview()
                        self.view.viewWithTag(301)?.removeFromSuperview()
                        
                        self.view.addSubview(loadingFailedLabel)
                        self.view.addSubview(retryBtn)
                        
                    }
                }
                self.isTaskDetailLoadEnd = true
            }
        }
        LeaveMsgDetailViewController.requestCacheArr.append(dataRequest)
    }
    
    @objc func timeEventsOfCountDown(){
        DispatchQueue.main.async {
            self.countdownTime = self.countdownTime - 1
            self.taskCountDownTimerValue.text = self.currentTimeString
        }
    }
    
    @objc func retryBtnInViewClicked(){
        taskDetailArray.removeAll()
        
        loadOrderDataFromServer()
    }
    
    func autoLabelHeight(with text:String , labelWidth: CGFloat ,textFont:UIFont) -> CGFloat{
        
        var size = CGRect()
        let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
        let attibute = [NSAttributedStringKey.font:textFont]
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attibute , context: nil);
        return size.size.height
    }

    
    //有关照片上传的代码（从相册选取）
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        print("canceled")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        //当选择的类型是图片
        if type == "public.image"
        {
            
            //修正图片的位置
            let image = self.fixOrientation(aImage: (info[UIImagePickerControllerOriginalImage] as! UIImage))
            //先把图片转成NSData
            let data = UIImageJPEGRepresentation(image, 0.5)
            
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/TaskAttachmentReply"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch  {
                print("something wrong was happening")
            }
            
            var fnameIndex = "00"
            if self.attachmentPicCountInReply == 0 {
                fnameIndex = "00"
            }else if self.attachmentPicCountInReply == 1{
                fnameIndex = "01"
            }else if self.attachmentPicCountInReply == 2{
                fnameIndex = "02"
            }else {
                fnameIndex = "03"
            }
            let fnameWithExtend = "/image00\(fnameIndex).png"
            
            let imagePath = documentPath.appending(fnameWithExtend)
            fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
            //fileManager.createFileAtPath(documentPath.append("/image.png"), contents: data, attributes: nil)
            //得到选择后沙盒中图片的完整路径
            let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
            print("filePath:" + filePath)
            //            Alamofire.upload(.POST, "http://192.168.3.16:9060/client/updateHeadUrl", multipartFormData: { multipartFormData in
            //                let lastData = NSData(contentsOfFile: filePath)
            //
            //                multipartFormData.appendBodyPart(data: lastData!, name: "image")
            //
            //            }, encodingCompletion: { response in
            //                picker.dismissViewControllerAnimated(true, completion: nil)
            //                switch response {
            //                case .Success(let upload, _, _):
            //                    upload.responseJSON(completionHandler: { (response) in
            //                        print(response)
            //                        self.imageView.image = UIImage(data: data!)
            //
            //                    })
            //
            //                case .Failure(let encodingError):
            //                    print(encodingError)
            //                }
            //
            //            })
            
            AttachmentPicsInReply.append(image)
            AttachmentTypesInReply.append("public.image")
            
            imageURLsInReply.append(filePath)
            let urls:URL = URL.init(string: filePath)!
            previewURLsInReply.append(urls)
            print("the taken pic upload successed")
            attachmentPicCountInReply += 1
            picker.dismiss(animated: true, completion: nil)
            updateCellView(tableView: replyTaskTableView)
        }
        
        //当选择的类型是图片
        if type == "public.movie"
        {
            print("你拍摄的是视频")
            //系统保存到tmp目录里的文件路径
            let infoDic = info as NSDictionary
            let mediaUrl:URL = infoDic[UIImagePickerControllerMediaURL] as! URL
            let videoPath = mediaUrl.path
            
            //如果视频文件可以保存的话
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath){
                //用下边的方法保存视频
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil)
            }
            
            //先把视频转成NSData
            let data = NSData(contentsOf: mediaUrl)
            
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/TaskAttachmentReply"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch  {
                print("something wrong was happening")
            }
            
            var fnameIndex = "00"
            if self.attachmentPicCountInReply == 0 {
                fnameIndex = "00"
            }else if self.attachmentPicCountInReply == 1{
                fnameIndex = "01"
            }else if self.attachmentPicCountInReply == 2{
                fnameIndex = "02"
            }else {
                fnameIndex = "03"
            }
            let fnameWithExtend = "/image00\(fnameIndex).mov"
            
            let imagePath = documentPath.appending(fnameWithExtend)
            
            fileManager.createFile(atPath: imagePath, contents: data! as Data, attributes: nil)
            //得到选择后沙盒中视频的完整路径
            let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
            print("filePath:" + filePath)
            //            Alamofire.upload(.POST, "http://192.168.3.16:9060/client/updateHeadUrl", multipartFormData: { multipartFormData in
            //                let lastData = NSData(contentsOfFile: filePath)
            //
            //                multipartFormData.appendBodyPart(data: lastData!, name: "image")
            //
            //            }, encodingCompletion: { response in
            //                picker.dismissViewControllerAnimated(true, completion: nil)
            //                switch response {
            //                case .Success(let upload, _, _):
            //                    upload.responseJSON(completionHandler: { (response) in
            //                        print(response)
            //                        self.imageView.image = UIImage(data: data!)
            //
            //                    })
            //
            //                case .Failure(let encodingError):
            //                    print(encodingError)
            //                }
            //
            //            })
            //将视频转成avAsset
            let avAsset = AVAsset(url: mediaUrl as URL)
            
            //生成视频截图
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0,600)
            var actualTime:CMTime = CMTimeMake(0,0)
            let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
            let frameImg = UIImage.init(cgImage: imageRef)
            
            let image =  frameImg
            AttachmentPicsInReply.append(image)
            AttachmentTypesInReply.append("public.movie")
            imageURLsInReply.append(filePath) // filePath
            previewURLsInReply.append(mediaUrl)
            print("videoPath: \(videoPath)")
            print("the taken video upload successed")
            attachmentPicCountInReply += 1
            picker.dismiss(animated: true, completion: nil)
            updateCellView(tableView: replyTaskTableView)
            
            //            //测试预览视频
            //            //视频播放
            //
            //            //定义一个视频播放器，通过本地文件路径初始化
            //            let player = AVPlayer(url: mediaUrl)
            //            let playerViewController = AVPlayerViewController()
            //            playerViewController.player = player
            //            self.present(playerViewController, animated: true) {
            //                playerViewController.player!.play()
            //            }
            
        }
    }
    //修复旋转照片的功能
    func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation ==  .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity//  CGAffineTransformIdentity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: -.pi/2)
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        
        let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: (aImage.cgImage?.bitsPerComponent)!, bytesPerRow:0 , space: (aImage.cgImage?.colorSpace!)!, bitmapInfo: (aImage.cgImage?.bitmapInfo)!.rawValue)
        ctx?.concatenate(transform)
        
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.height), height: CGFloat(aImage.size.width)))
        default:
            ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.width), height: CGFloat(aImage.size.height)))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = (ctx?.makeImage())!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
}

func getVideoImage(videoUrl: URL) -> UIImage {
    
    let avAsset = AVAsset.init(url: videoUrl)
    let generator = AVAssetImageGenerator.init(asset: avAsset)
    generator.appliesPreferredTrackTransform = true
    let time: CMTime = CMTimeMakeWithSeconds(1.0, 600) // 取第0秒， 一秒600帧
    var actualTime: CMTime = CMTimeMake(0, 0)
    let cgImage: CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
    
    return UIImage.init(cgImage: cgImage)
}

enum loadViewOpreaType: Int {
    case start = 1
    case stop
    case remove
}
func loadingView(postion:CGRect,loadType:loadViewOpreaType,superView:UIView){
    let x = postion.origin.x
    let y = postion.origin.y
    //loading文字
    let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: x, y: y, width: 200, height: 30))
    noticeWhenLoadingData.text = "加载中，请稍侯..."
    noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
    noticeWhenLoadingData.textColor = UIColor.gray
    noticeWhenLoadingData.textAlignment = .center
    noticeWhenLoadingData.tag = 888
    //loading动画
    var images:[UIImage] = []
    for i in 0...27{
        let imagePath = "\(i).png"
        let image:UIImage = UIImage(named:imagePath)!
        images.append(image)
    }
    let imageView = UIImageView()
    imageView.frame = CGRect(x: x - 10, y: y - 150, width: 200, height: 200)//self.view.bounds
    imageView.contentMode = .scaleAspectFit//.center
    imageView.animationImages = images
    imageView.animationDuration = 1
    imageView.animationRepeatCount = 0
    imageView.startAnimating()
    imageView.tag = 889

    if loadViewOpreaType.start == loadType {
        //开始
        superView.addSubview(imageView)
        superView.addSubview(noticeWhenLoadingData)
        
    }else if loadViewOpreaType.stop == loadType{
        superView.viewWithTag(888)?.removeFromSuperview()
        superView.viewWithTag(889)?.removeFromSuperview()
    }else if loadViewOpreaType.remove == loadType{
        superView.viewWithTag(888)?.removeFromSuperview()
        superView.viewWithTag(889)?.removeFromSuperview()
    }else{
        print("Wrong loading View Type")
    }
}

