//
//  NewTaskViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 07/01/2018.
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

class NewTaskViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //从本地上传到IOS客户端的路径
    var imageURLs:[String] = []
    //预览路径
    var previewURLs:[URL] = []
    
    //处理期限转换为时间
    var deadLineInMinsInInt = 30
    var isDataInTaskViewCleared = true
    var isTaskCreating = false
    //上传图片到COS临时存储到名字
    var taskImages:[String] = []
    
    
    let progressBtn = KVProgressBar.init(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 10, width: 30, height: 30))
    
    let greyMask:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    let newTaksView:UIView = UIView.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35))
    var newTaskViewTitle:UILabel = UILabel.init(frame:CGRect(x: UIScreen.main.bounds.width/2 - 44, y: 13, width: 88, height: 30))
    
    let cancelBtnOnTaskView:UIButton = UIButton.init(type: .system)
    let doneBtnOnTaskView:UIButton = UIButton.init(type: .system)
    
    //订单号
    let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 22))
    let orderIDTextField:UITextField = UITextField.init(frame: CGRect(x: 117, y: 10, width: kWidth - 139, height: 30))
    //mark  3 字 y = 60, 4字 y = 75
    //处理期限
    let deadlineTextField:UILabel = UILabel.init(frame: CGRect(x: 117, y: 15, width: kWidth - 139, height: 22))
    let deadlineDatePicker:UIDatePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 216))
    let deadlineLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 30))
    
    //任务类型
    let taskTypeLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 22))
    let taskTypePickerLabel:UILabel = UILabel.init(frame: CGRect(x: 117, y: 15, width: kWidth - 139, height: 22))
    //发送给
    let postToPplLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 22))
    let postToPplTextFeild:UITextView = UITextView.init(frame: CGRect(x: 117, y: 10, width: kWidth - 139, height: 30))
    let postToPplAddContact:UIButton = UIButton.init(type: UIButtonType.contactAdd)
    //上传图片，视频
    let uploadPicLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 22))
    let uploadPicBtn:UIButton = UIButton.init(frame: CGRect(x: 117, y: 10, width: 100, height: 30))
    let uploadPicHit:UILabel = UILabel.init(frame: CGRect(x: 240, y: 10, width: 150, height: 30))
    var AttachmentPics:[UIImage] = []
    var AttachmentTypes:[String] = []
    
    
    //任务详情
    let taskDetailLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 100, height: 22))
    let taskDetailTextView:UITextView = UITextView.init(frame: CGRect(x: 15, y: 35, width: UIScreen.main.bounds.width - 30, height: 40))
    let textNumberLimit:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 115, y: 10, width: 100, height: 40))
    
    var deadlineSelectedFlag = 0
    var deletingLastWords = false
    var addingFirstWords = false
    var attachmentPicCount = 0
    
    var contactedUserID:String = ""
    
    //var taskTypeSelectedFlag = 0
    var deadLineInMins:TimeInterval = TimeInterval.init()
    
    lazy var newTaskTableView:UITableView = {
        //y = 58调好的
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (64 + heightChangeForiPhoneXFromTop)), style: UITableViewStyle.grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.backgroundColor = UIColor.white
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))

        
        return tempTableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .white)

        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "发送", style: .plain,
                                           target: self, action: #selector(sendBtnClicked))
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
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        newTaskTableView.keyboardDismissMode = .interactive
        orderIDTextField.keyboardType = .numberPad
        
        orderIDTextField.placeholder = "请输入订单号(选填)"
        deadlineTextField.text = "30分钟"
        taskTypePickerLabel.text = "普通任务"
        postToPplTextFeild.text = "输入/选中任务接受者"
        postToPplTextFeild.textColor = UIColor.titleColors(color: .lightGray)
        
        
        //初始化值
        textNumberLimit.text = "\(taskDetailTextView.text.count)\\300"
        self.view.addSubview(newTaskTableView)
        
        checkSendBtnAvailable()
    }
    @objc func cancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func sendBtnClicked(){
        self.navigationController?.dismiss(animated: true, completion: nil)
        greyLayerPrompt.show(text: "发送中,请稍后...")
        if imageURLs.count != 0{
            taskImages = uploadFiles(images: imageURLs)
        }else{
            createTaskList()//创建任务
        }
    }
    
    //发送按钮点击
    func createTaskList(){
        //uploadFiles
        //标记正在创建任务
        if isTaskCreating == true{
            greyLayerPrompt.show(text: "上一个任务还在发布中，请稍后再试")
            return
        }
        isDataInTaskViewCleared = false
        isTaskCreating = true
        //        if imageURLs.count != 0{
        //            taskImages = uploadFiles(images: imageURLs)
        //        }
        //loading文字
        let preventingView:UIView = UILabel.init(frame: CGRect(x: 0, y: 0, width: newTaksView.bounds.width, height: newTaksView.bounds.height))
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
        if newTaksView.subviews.contains(preventingView) {
            print("view exists")
        }else{
            print("view not exists")
            newTaksView.addSubview(preventingView)
            preventingView.addSubview(imageView)
            preventingView.addSubview(noticeWhenLoadingData)
        }
        // let tempTest = uploadAttachmentsFiles()// 测试用的
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        //            let newTaskUpdateURL:String = "http://192.168.1.102:8068/task/createTasklist.do"
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "createTaskAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "createTaskAPI") as! String
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
                params["commandcode"] = 90
                params["operatecode"] = 0
                params["taskreceiver"] = contactedUserID//postToPplTextFeild.text//
                params["orderid"] = orderIDTextField.text//"205175564028082"
                params["taskinfo"] = taskDetailTextView.text//
                params["taskperiod"] = deadLineInMinsInInt//
                params["tasktype"] = 0//标准任务
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
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                print("update successed")
                greyLayerPrompt.show(text: "任务发布成功")
                self.newTaksView.viewWithTag(1010)?.removeFromSuperview()
                self.clearDataInTaskView()
                //print("***************任务创建成功********************")
                self.isTaskCreating = false
            case false:
                print("update failed")
                self.isTaskCreating = false
                if self.view.viewWithTag(1010) != nil {
                    self.view.viewWithTag(1010)?.removeFromSuperview()// preventing view removed
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print(responseObject.result.error ?? "No result found")
                    greyLayerPrompt.show(text: "任务保存失败，请稍后再试")
                }
            }
        }
    }
    
    func clearDataInTaskView(){
        orderIDTextField.text = ""
        deadlineTextField.text = ""
        postToPplTextFeild.text = ""
        attachmentPicCount = 0
        taskDetailTextView.text = ""
        contactedUserID = ""
        textNumberLimit.text = "0\\300"
        AttachmentPics.removeAll()
        AttachmentTypes.removeAll()
        clearTextView(textView: taskDetailTextView)
        newTaskTableView.reloadData()
        //文件管理器
        for i in imageURLs {
            let fileManager: FileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: i)
            }
            catch  {
                print("something wrong was happening")
            }
        }
        imageURLs.removeAll()
        previewURLs.removeAll()
        taskImages.removeAll()
        isDataInTaskViewCleared = true
        //newTaskTableView.beginUpdates()
        //newTaskTableView.endUpdates()
    }
    
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        if taskDetailTextView.isFirstResponder{
            //界面偏移动画
            UIView.animate(withDuration: duration, animations: { ()->Void in
                print("向上移动y=\(UIScreen.main.bounds.height + 300)")
                self.newTaksView.transform = CGAffineTransform(translationX: 0, y:-(UIScreen.main.bounds.height + 300))
            })
        }
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_notification: Notification){
        
        let kbInfo = _notification.userInfo
        /*
         swift2.3正常，swift3.0取值为nil
         */
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        if taskDetailTextView.isFirstResponder {
            UIView.animate(withDuration: duration, animations: {()->Void in
                self.newTaksView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-35))// -632
                print("向下移动y=\(UIScreen.main.bounds.height + 300)")
            })
        }
        
        
    }
    
    //时间选择空间值改变
    @objc func dateChanged(datePicker : UIDatePicker){
        
        deadLineInMins = datePicker.date.timeIntervalSinceNow
        var days = 0
        var hrs = 0
        var mins = 0
        
        // print("deadLine to Int\(Int(deadLineInMins))")
        
        if deadLineInMins < 60{
            mins = 0
            deadlineTextField.text = "\(mins)分钟"
        }else{
            //> 60秒时
            mins = (Int(deadLineInMins)/60)%60
            if Int(deadLineInMins)/60 < 60{
                deadlineTextField.text = "\(mins)分钟"
            }else {
                // > 60分钟时
                hrs = Int(deadLineInMins)/60/60%24
                if Int(deadLineInMins)/60 < 60*24{
                    //< 60*24分钟
                    deadlineTextField.text = "\(hrs)小时 \(mins)分钟"
                }else{
                    //60*24分钟
                    days = Int(deadLineInMins)/60/60/24
                    deadlineTextField.text = "\(days)天 \(hrs)小时 \(mins)分钟"
                }
            }
        }
        deadLineInMinsInInt = Int(deadLineInMins)/60
        updateCellView(tableView: newTaskTableView)
    }
    
    //删除附件
    func deleteAttachment(atIndex:Int){
        if atIndex >= AttachmentPics.count {
            print("can't found this pic becasue out of range")
        }else{
            AttachmentPics.remove(at: atIndex)
            AttachmentTypes.remove(at: atIndex)
            //文件管理器
            let fileManager: FileManager = FileManager.default
            let imagePath = imageURLs[atIndex]
            
            do {
                try fileManager.removeItem(atPath: imagePath)
            }
            catch  {
                print("something wrong was happening")
            }
            imageURLs.remove(at: atIndex)
            previewURLs.remove(at: atIndex)
            attachmentPicCount -= 1
            updateCellView(tableView: newTaskTableView)
            print("delete row called succedd")
        }
    }
    //更新表格
    func updateTableViewFromCall(){
        updateCellView(tableView: newTaskTableView)
    }
    func checkSendBtnAvailable() {
        var orderFieldIsEmpty = false
        var deadlineIsEmpty = true
        var postToPplFieldIsEmpty = true
        var taskDetailFieldIsEmpty = true
        
        //处理期限输入框判断
        if deadlineTextField.isFirstResponder && addingFirstWords{
            deadlineIsEmpty = false
        }else{
            if deadlineTextField.text != ""{
                deadlineIsEmpty = false
            }else{
                deadlineIsEmpty = true
            }
        }
        //发送给输入框判断
        if postToPplTextFeild.isFirstResponder && addingFirstWords{
            postToPplFieldIsEmpty = false
        }else{
            if postToPplTextFeild.text != ""{
                postToPplFieldIsEmpty = false
            }else{
                postToPplFieldIsEmpty = true
            }
        }
        //任务详情输入框判断
        if taskDetailTextView.isFirstResponder && addingFirstWords{
            taskDetailFieldIsEmpty = false
        }else{
            if taskDetailTextView.text != ""{
                taskDetailFieldIsEmpty = false
            }else{
                taskDetailFieldIsEmpty = true
            }
        }
        
        let someOfTheFieldIsEmpty = orderFieldIsEmpty || deadlineIsEmpty || postToPplFieldIsEmpty || taskDetailFieldIsEmpty
        if deletingLastWords {
            doneBtnOnTaskView.isEnabled = false
        }else{
            if  someOfTheFieldIsEmpty {
                doneBtnOnTaskView.isEnabled = false
            }else{
                doneBtnOnTaskView.isEnabled = true
            }
        }
    }
    
    //MARK1 - Picker View 控制区域
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    //MARK2 - Table View 控制区域
    //选中tableView cell时执行
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var closeTapViewFlag = 0
        if deadlineSelectedFlag == 1{
            closeTapViewFlag = 1
        }
        deadlineSelectedFlag = 0
        deadlineDatePicker.removeFromSuperview()
        
        orderIDTextField.resignFirstResponder()
        postToPplTextFeild.resignFirstResponder()
        taskDetailTextView.resignFirstResponder()
        postToPplAddContact.isHidden = true
        if indexPath.row == 0 {
            orderIDTextField.becomeFirstResponder()
        }else if indexPath.row == 1{
            //处理期限
            deadlineDatePicker.locale = Locale(identifier: "zh_CN")
            deadlineDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
            if closeTapViewFlag == 1{
                deadlineDatePicker.removeFromSuperview()
                closeTapViewFlag = 0
            }else{
                if deadlineTextField.text == nil{
                    deadlineTextField.text = "30分钟"
                }
                tableView.cellForRow(at: indexPath)?.addSubview(deadlineDatePicker)
                deadlineSelectedFlag = 1
            }
            // print("\(indexPath.row)selected")
        }else if indexPath.row == 2{
            //任务类型
            // print("\(indexPath.row)selected")
        }else if indexPath.row == 3{
            //发送给
            postToPplTextFeild.becomeFirstResponder()
            postToPplAddContact.isHidden = false
        }else if indexPath.row == 4{
            //上传图片
            //  print("\(indexPath.row)selected")
        }else{
            taskDetailTextView.becomeFirstResponder()
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //表格中cell高度控制
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5  {
            let tempCellHeight = taskDetailTextView.bounds.height + 28.0
            return tempCellHeight
        }else if indexPath.row == 1{
            if deadlineSelectedFlag == 1{
                let tempCellHeight = 50.0 + 220.0
                return CGFloat(tempCellHeight)
            }else{
                return 50
            }
        }else if indexPath.row == 4{
            uploadPicBtn.isEnabled = true
            uploadPicBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
            
            if self.view.viewWithTag(10) != nil{
                self.view.viewWithTag(10)?.removeFromSuperview()
            }
            if self.view.viewWithTag(11) != nil{
                self.view.viewWithTag(11)?.removeFromSuperview()
            }
            if self.view.viewWithTag(12) != nil{
                self.view.viewWithTag(12)?.removeFromSuperview()
            }
            
            if attachmentPicCount != 0{
                //修改导航栏返回按钮文字
                for i in 0..<attachmentPicCount{
                    let AttachPic = UIImageView()
                    AttachPic.frame = CGRect(x: 15+i*100, y: 50, width: 90, height: 90)
                    AttachPic.tag = i+10
                    AttachPic.contentMode = .scaleAspectFill
                    AttachPic.clipsToBounds = true
                    AttachPic.image = UIImage(cgImage: AttachmentPics[i].cgImage!)
                    if AttachmentTypes[i] == "public.movie"{ //如果是视频
                        let playVideoLayer:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
                        playVideoLayer.image = UIImage(named:"playvideoicon-white")
                        AttachPic.addSubview(playVideoLayer)
                    }
                    AttachPic.isUserInteractionEnabled = true
                    
                    tableView.cellForRow(at: indexPath)?.addSubview(AttachPic)
                    
                    let tapSingle=UITapGestureRecognizer(target:self,
                                                         action:#selector(imageViewTap(_:)))
                    tapSingle.numberOfTapsRequired = 1
                    tapSingle.numberOfTouchesRequired = 1
                    
                    AttachPic.addGestureRecognizer(tapSingle)
                }
                if attachmentPicCount == 3{
                    uploadPicBtn.isEnabled = false
                    uploadPicBtn.layer.borderColor = UIColor.gray.cgColor
                }
                return 150
            }else{
                if self.view.viewWithTag(10) != nil{
                    self.view.viewWithTag(10)?.removeFromSuperview()
                }
                return 50
            }
        }
        return 50 //UITableViewAutomaticDimension
    }
    //缩略图imageView点击
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = recognizer.view!.tag
        //进入图片全屏展示
        
        if AttachmentTypes[index-10] == "publuc.movie"{
            
        }
        
        let previewVC = ImagePreviewVC(images: AttachmentPics, index: (index-10), previewMode: .previewWithDelete)
        previewVC.imageUrls = self.previewURLs
        previewVC.PreviewType = AttachmentTypes
        previewVC.createNewTaskVCObject = self
        previewVC.previewSourceVC = "WorkZoneVC"
        //  previewVC.previewMode = .previewWithDelete
        previewVC.modalPresentationStyle = .fullScreen
        self.present(previewVC, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. 提供cell，默认复用
        let cell = NewTaskViewCell.customCell(tableView:newTaskTableView)
        
        cell.btnClickBlock = {() in
            // print("点击了按钮，当前属于\(indexPath.row)")
        }
        orderIDLabel.text = "订单号"
        orderIDLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orderIDLabel.textColor = UIColor.titleColors(color: .black)
        
        deadlineLabel.text = "处理期限"
        deadlineLabel.font = UIFont.boldSystemFont(ofSize: 16)
        deadlineLabel.textColor = UIColor.titleColors(color: .black)
        
        taskTypeLabel.text = "任务类型"
        taskTypeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        taskTypeLabel.textColor = UIColor.titleColors(color: .black)
        
        postToPplLabel.text = "发送给"
        postToPplLabel.font = UIFont.boldSystemFont(ofSize: 16)
        postToPplLabel.textColor = UIColor.titleColors(color: .black)
        
        uploadPicLabel.text = "上传图片"
        uploadPicLabel.font = UIFont.boldSystemFont(ofSize: 16)
        uploadPicLabel.textColor = UIColor.titleColors(color: .black)
        
        taskDetailLabel.text = "任务详情"
        taskDetailLabel.font = UIFont.boldSystemFont(ofSize: 16)
        taskDetailLabel.textColor = UIColor.titleColors(color: .black)
        textNumberLimit.textAlignment = .right
        textNumberLimit.font = UIFont.systemFont(ofSize: 14)
        textNumberLimit.textColor = UIColor.gray
        
        uploadPicHit.text = "图片不能超过2M"
        uploadPicHit.font = UIFont.boldSystemFont(ofSize: 13)
        uploadPicHit.textColor = UIColor.gray
        
        //设置上传图片按钮设置
        uploadPicBtn.setTitle("上传图片", for: .normal)
        uploadPicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        uploadPicBtn.backgroundColor = UIColor.white
        uploadPicBtn.layer.cornerRadius = 5
        uploadPicBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        uploadPicBtn.layer.borderWidth = 1
        uploadPicBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
        uploadPicBtn.setTitleColor(UIColor.gray, for: .disabled)
        uploadPicBtn.addTarget(self, action: #selector(uploadPicBtnClicked), for: .touchUpInside)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if indexPath.row == 0 {
            //订单号
            orderIDTextField.font = UIFont.systemFont(ofSize: 16)
            orderIDTextField.delegate = self
            cell.contentView.addSubview(orderIDLabel)
            cell.addSubview(orderIDTextField)
            return cell
        }else if indexPath.row == 1{
            //处理期限
            deadlineDatePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
            deadlineTextField.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(deadlineLabel)
            cell.addSubview(deadlineTextField)
            return cell
        }else if indexPath.row == 2{
            //任务类型
            taskTypePickerLabel.font = UIFont.systemFont(ofSize: 16)
            taskTypePickerLabel.text = "普通任务"
            cell.addSubview(taskTypeLabel)
            cell.addSubview(taskTypePickerLabel)
            return cell
            
        }else if indexPath.row == 3{
            //发送给
            postToPplTextFeild.delegate = self
            postToPplTextFeild.font = UIFont.systemFont(ofSize: 16)
            postToPplTextFeild.allowsEditingTextAttributes = false
            postToPplTextFeild.textContainer.maximumNumberOfLines = 1
            postToPplTextFeild.textContainer.lineBreakMode = .byClipping
            postToPplTextFeild.textAlignment = .natural
            //postToPplTextFeild.
            postToPplAddContact.frame = CGRect(x: UIScreen.main.bounds.width - 40, y: 10, width: 28, height: 28)
            postToPplAddContact.addTarget(self, action: #selector(addContactClicked), for: .touchUpInside)
            
            cell.addSubview(postToPplTextFeild)
            cell.addSubview(postToPplLabel)
            cell.addSubview(postToPplAddContact)
            postToPplAddContact.isHidden = true
            return cell
        }else if indexPath.row == 4{
            //上传图片
            cell.addSubview(uploadPicLabel)
            cell.addSubview(uploadPicBtn)
            cell.addSubview(uploadPicHit)
            progressBtn.isHidden = true
            progressBtn.backgroundColor = UIColor.white
            cell.addSubview(progressBtn)
            
            
            return cell
        }else{
            //任务详情
            cell.autoresizesSubviews = true
            taskDetailTextView.layer.masksToBounds = true
            taskDetailTextView.delegate = self
            
            //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
            taskDetailTextView.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0)
            taskDetailTextView.font = UIFont.systemFont(ofSize: 16)
            taskDetailTextView.textColor = UIColor.black
            taskDetailTextView.textAlignment = NSTextAlignment.left
            taskDetailTextView.isScrollEnabled = false
            
            // 给文中的电话、网址 自动加链接
            taskDetailTextView.dataDetectorTypes = UIDataDetectorTypes.all
            
            //定义选中文字的内容
            //            let mail = UIMenuItem(title: "邮件", action: #selector(ViewController.onMail))
            //            let wechat = UIMenuItem(title: "微信", action: #selector(ViewController.onWechat))
            //            let menu = UIMenuController()
            //
            //            menu.menuItems = [mail,wechat]
            //
            //            func onMail() {
            //                print("mail")
            //            }
            //
            //            func onWechat() {
            //                print("onWechat")
            //
            //            }
            cell.addSubview(taskDetailTextView)
            cell.addSubview(taskDetailLabel)
            cell.addSubview(textNumberLimit)
            return cell
        }
    }
    //获取Label文本高度
    func getLabHeigh(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        
        let statusLabelText: String = labelStr
        let size = CGSize(width:width, height:900)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size,options: .usesLineFragmentOrigin,attributes: dic as? [NSAttributedStringKey:Any],context: nil)
        return strSize.height
    }
    //获取Label文本宽度
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: String = labelStr
        let size = CGSize(width:900, height:height)
        let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size,options: .usesLineFragmentOrigin,attributes: dic as? [NSAttributedStringKey:Any],context: nil)
        return strSize.width
        
    }
    //选择联系人按钮点击了
    @objc func addContactClicked(){
        
        //加载新的view去点击
        let chooseContactVC = chooseContactViewController()
        chooseContactVC.createNewTaskVCObject = self
        chooseContactVC.modalPresentationStyle = .fullScreen
        self.present(chooseContactVC, animated: true, completion: nil)
    }
    //设置联系人结构化String
    func setPostToPplTextField(text:String){
        let myAttribute =  [NSAttributedStringKey.foregroundColor: UIColor.blue,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
        
        let myAttriString = NSAttributedString(string: text, attributes: myAttribute as [NSAttributedStringKey : Any])
        postToPplTextFeild.attributedText = myAttriString
    }
    
    //MARK - 图片上传按钮点击事件
    @objc func uploadPicBtnClicked(){
        
        //备份代码
        let actionSheet = UIAlertController(title: "上传图片", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive) { (action:UIAlertAction) -> Void in
            //断是否能进行拍照，可以的话打开相机
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
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            //开始选择照片，最多允许选择4张
            let allowChooseCount = 3 - self.attachmentPicCount
            _ = self.presentHGImagePicker(maxSelected:allowChooseCount) { (assets) in
                //结果处理
                print("共选择了\(assets.count)张图片，分别如下：")
                for asset in assets {
                    self.PHAssetToUIImage(asset: asset)
                }
            }
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    // MARK: - 将PHAsset对象转为UIImage对象
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
                    self.progressBtn.progress = CGFloat(progress)
                    self.progressBtn.isHidden = false
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.progressBtn.isHidden = true
                    self.updateCellView(tableView: self.newTaskTableView)
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
                        self.progressBtn.progress = CGFloat(progress)
                        self.progressBtn.isHidden = false
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.progressBtn.isHidden = true
                        self.updateCellView(tableView: self.newTaskTableView)
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
                        
                        self.AttachmentPics.append(tempHDImage)
                    })
                    //图片保存的路径
                    //这里将图片放在沙盒的documents文件夹中
                    
                    //Home目录
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/TaskAttachment"
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
                    if self.attachmentPicCount == 0 {
                        fnameIndex = "00"
                    }else if self.attachmentPicCount == 1{
                        fnameIndex = "01"
                    }else if self.attachmentPicCount == 2{
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
                    self.imageURLs.append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.previewURLs.append((urlAssets?.url)!)
                    self.attachmentPicCount += 1
                    
                    self.AttachmentTypes.append("public.movie")// 视频或者视频
                    DispatchQueue.main.async(execute: {
                        self.progressBtn.isHidden = true
                        self.updateCellView(tableView: self.newTaskTableView)
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
                    let documentPath = homeDirectory + "/Documents/TaskAttachment"
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
                    if self.attachmentPicCount == 0 {
                        fnameIndex = "00"
                    }else if self.attachmentPicCount == 1{
                        fnameIndex = "01"
                    }else if self.attachmentPicCount == 2{
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
                    self.imageURLs.append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.previewURLs.append(urls)
                    self.attachmentPicCount += 1
                    self.AttachmentPics.append(tempHDImage)
                    self.AttachmentTypes.append("public.image")// 视频或者视频
                    
                    
                    
                    DispatchQueue.main.async(execute: {
                        self.progressBtn.isHidden = true
                        self.updateCellView(tableView: self.newTaskTableView)
                    })
                    //self.updateCellView(tableView: self.newTaskTableView)
                })
            }
        }
        
    }
    
    //获取缩略图
    func getAssetThumbnail(asset:PHAsset) -> UIImage{
        var image:UIImage?
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        let targetSize:CGSize = CGSize(width: 90, height: 90)
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (thumbnailImage, info) in
            print("getted thumbnailimaged")
            image = thumbnailImage
        }
        return image!
    }
    
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
            let documentPath = homeDirectory + "/Documents/TaskAttachment"
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
            if self.attachmentPicCount == 0 {
                fnameIndex = "00"
            }else if self.attachmentPicCount == 1{
                fnameIndex = "01"
            }else if self.attachmentPicCount == 2{
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
            
            AttachmentPics.append(image)
            AttachmentTypes.append("public.image")
            
            imageURLs.append(filePath)
            let urls:URL = URL.init(string: filePath)!
            previewURLs.append(urls)
            print("the taken pic upload successed")
            attachmentPicCount += 1
            picker.dismiss(animated: true, completion: nil)
            updateCellView(tableView: newTaskTableView)
            
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
            let documentPath = homeDirectory + "/Documents/TaskAttachment"
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
            if self.attachmentPicCount == 0 {
                fnameIndex = "00"
            }else if self.attachmentPicCount == 1{
                fnameIndex = "01"
            }else if self.attachmentPicCount == 2{
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
            AttachmentPics.append(image)
            AttachmentTypes.append("public.movie")
            imageURLs.append(filePath) // filePath
            previewURLs.append(mediaUrl)
            print("videoPath: \(videoPath)")
            print("the taken video upload successed")
            attachmentPicCount += 1
            picker.dismiss(animated: true, completion: nil)
            updateCellView(tableView: newTaskTableView)
            
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
    //MARK3 - Date Picker Vier控制区域
    
    
    //MARK3 - Text View控制区域
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        if textView.isEqual(postToPplTextFeild) {
            print("postToFiled selected")
            postToPplAddContact.isHidden = false
        }else{
            postToPplAddContact.isHidden = true
        }
        
//        if textView.isEqual(self.postToPplTextFeild) && postToPplTextFeild.text == "输入/选中任务接受者"{
//            postToPplTextFeild.text = ""
//        }
        
        self.taskDetailTextView.inputAccessoryView = topView
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        deadlineDatePicker.removeFromSuperview()
        deadlineSelectedFlag = 0
        self.updateCellView(tableView: self.newTaskTableView)
        if textView.isEqual(postToPplTextFeild) {
            postToPplAddContact.isHidden = false
        }else{
            postToPplAddContact.isHidden = true
        }
        if postToPplTextFeild.text == ""{
            postToPplTextFeild.text = "输入/选中任务接受者"
        }
        if textView.isEqual(self.postToPplTextFeild) && postToPplTextFeild.text == "输入/选中任务接受者"{
            postToPplTextFeild.text = ""
        }
        
    }
    func textViewDidChange(_ textView: UITextView) {
        let textcount = textView.text.count
        if textcount > 300 {
            textNumberLimit.textColor = UIColor.red
        }else{
            textNumberLimit.textColor = UIColor.gray
        }
        
        if textView.isEqual(self.postToPplTextFeild) && postToPplTextFeild.text == ""{
            postToPplTextFeild.text = "输入/选中任务接受者"
        }
        textNumberLimit.text = "\(textcount)\\300"
        self.updateCellView(tableView: self.newTaskTableView)
        checkSendBtnAvailable()
    }
    
    func updateCellView(tableView:UITableView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //计算文本高度
    func heightForTextView(textView:UITextView, withText:String)->CGFloat{
        
        let constraint = CGSize(width: textView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        let attributes:NSDictionary = NSDictionary(object:UIFont.systemFont(ofSize: 15),forKey: NSAttributedStringKey.font as NSCopying)
        let size = withText.boundingRect(with: constraint,options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: attributes as? [NSAttributedStringKey : Any], context: nil)
        
        let textHeight = size.size.height + 22.0
        return textHeight
    }
    // func heightForSingleLineTextView(textView:UITextView,withText:String) ->CGFloat{
    //        let constraint = CGSize(width: textView.contentSize.width, height: CGFloat.greatestFiniteMagnitude)
    //        let attributes:NSDictionary = NSDictionary(object:UIFont.systemFont(ofSize: 15),forKey: NSAttributedStringKey.font as NSCopying)
    //        let size = withText.boundingRect(with: constraint,options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: attributes as? [NSAttributedStringKey : Any], context: nil)
    //
    //        let textHeight = size.size.height + 22.0
    //        return textHeight
    //    }
    
    func clearTextView(textView: UITextView) {
        var frame = textView.frame
        var height:CGFloat
        height = heightForTextView(textView: textView, withText:"")
        frame.size.height = height
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            textView.frame = frame
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.isEqual(taskDetailTextView){
            let temp = range.location == 0 && range.length == 1 //删除最后一个字符
            let temp2 = range.location == 0 && range.length == 0 //添加第一个字符
            if temp{
                deletingLastWords = true // 0 yes. 1 no.
            }else{
                deletingLastWords = false // 0 yes. 1 no.
            }
            if temp2{
                addingFirstWords = true
            }else{
                addingFirstWords = false
            }
            var frame = textView.frame
            var height:CGFloat
            height = heightForTextView(textView: textView, withText:textView.text+text)
            frame.size.height = height
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                textView.frame = frame
            })
            return true
        }else{
            if text.contains("\n"){
                return false
            }
            
            return true
        }
    }
    
    //MARK5 - Text Field控制区域
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        if postToPplTextFeild.text == ""{
            postToPplTextFeild.text = "输入/选中任务接受者"
        }
        
        self.orderIDTextField.inputAccessoryView = topView
        self.postToPplTextFeild.inputAccessoryView = topView
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        deadlineDatePicker.removeFromSuperview()
        deadlineSelectedFlag = 0
        checkSendBtnAvailable()
        self.updateCellView(tableView: self.newTaskTableView)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let temp = range.location == 0 && range.length == 1 //定位到删除操作
        let temp2 = range.location == 0 && range.length == 0 //定位到添加第一个字符
        
        if temp{
            deletingLastWords = true // 0 yes. 1 no.
        }else{
            deletingLastWords = false // 0 yes. 1 no.
        }
        if temp2{
            addingFirstWords = true
        }else{
            addingFirstWords = false
        }
        checkSendBtnAvailable()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        orderIDTextField.resignFirstResponder()
        taskDetailTextView.resignFirstResponder()
        postToPplTextFeild.resignFirstResponder()
        

        checkSendBtnAvailable()
    }
    
    func CloseLayer() {
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
                
                greyLayerPrompt.show(text: "任务创建中:开始上传附件")
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
                            greyLayerPrompt.show(text: "任务创建中:附件\(LoopCurrentCount)上传成功")
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
