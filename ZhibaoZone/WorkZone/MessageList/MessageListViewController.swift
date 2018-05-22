//
//  MessageListViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class MessageListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    //workzone object
    var workZoneVC = WorkZoneViewController()
    
    var roleType = 0// 角色类型
    //任务列表
    var messagesList:[NSDictionary] = []
    var getMessagesCount = 0

    //订单详情获取到了吗？
    var isOrderDetailsGets = false
    
    //订单详情：
    var orderDetail:[NSDictionary] = []
    
    //附件图片下载地址
    var downloadURLHeader = ""
    
    //参考图列表
    var memoPictures:[UIImage] = []
    
    //消息列表
    lazy var messageListTableView:UITableView = {
        //height -77 调好的
        //var heightOfTableView = UIScreen.main.bounds.height - 62
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (64 + heightChangeForiPhoneXFromTop)), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        return tempTableView
    }()
    
    //报价窗口需要关闭的页面
    var quotePriceWeight = 1
    var theChildViewNeedToClose:[UIView] = []
    var isblurPopViewPresenting = false
    //y 最终等于110
    let blurPopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 350)/2, y: UIScreen.main.bounds.height, width: 350, height: 500))
    
    let quotePriceSlideBarRightLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    let quotePriceSlideBarMidLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 320, height: 30))
    let quotePriceSlideBarLeftLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 250, height: 30))
    
    lazy var quotePriceSlideBar:UISlider = {
        var tempSliderBar = UISlider.init(frame: CGRect(x: 15, y: 390, width: 320, height: 20))
        return tempSliderBar
    }()
    
    
    //报价窗口变量定义
    //mark  3 字 y = 60, 4字 y = 75
    let orderTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 50, width: 200, height: 30))
    let orderID:UILabel = UILabel.init(frame: CGRect(x: 198, y: 50, width: 150, height: 30))
    
    //参考图
    let orderDefaultPic: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 75, width: 100, height: 100))
    //点击预览层
    let orderDefaultPicLayer:UIView = UIView.init(frame: CGRect(x: 0, y: 80, width: 100, height: 20))
    
    //产品类型
    let productTypeNameValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 175, width: 250, height: 30))
    //工艺
    let makeStyleValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 200, width: 280, height: 30))
    //附件
    let accessoriesValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 225, width: 280, height: 30))
    
    //订购数目
    let orderCountValue:UILabel = UILabel.init(frame: CGRect(x: 160, y: 75, width: 100, height: 30))
    //产品尺寸
    //长
    // x: 190
    let productSizeOfLengthValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))
    //宽
    let productSizeOfWidthValue:UILabel = UILabel.init(frame: CGRect(x: 190, y: 125, width: 100, height: 30))
    //高
    let productSizeOfHeightValue:UILabel = UILabel.init(frame: CGRect(x: 250, y: 125, width: 100, height: 30))
    
    let quotePriceAtLastTimeValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
    let customerPriceValue:UILabel = UILabel.init(frame: CGRect(x: 225, y: 295, width: 200, height: 44))
    let customerPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))
    
    let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 65, y: 285, width: 200, height: 44))
    let setQuotePriceWeightBtn:UIButton = UIButton.init(type: .system)

    
    //设置生产工期输入框
    lazy var produceTimeCostTextField:UITextField = {
        //label值55，当前值62 差 7
        var tempSliderTextField = UITextField.init(frame: CGRect(x: 250 , y: 342, width: 56, height: 30))
        tempSliderTextField.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempSliderTextField.layer.cornerRadius = 5
        tempSliderTextField.delegate = self
        return tempSliderTextField
    }()
    
    //设置报价值输入框
    lazy var currentValueOnSliderTextField:UITextField = {
        //label值55，当前值62 差 7
        var tempSliderTextField = UITextField.init(frame: CGRect(x: 110, y: 342, width: 86, height: 30))
        tempSliderTextField.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempSliderTextField.layer.cornerRadius = 5
        tempSliderTextField.delegate = self
        return tempSliderTextField
    }()
    //
    //设置设计备注，订单备注输入框
    lazy var orderMemosForDesignOrProducer:UILabel = {
        //label值55，当前值62 差 7
        var tempLabel = UILabel.init(frame: CGRect(x: 15, y: 335+24, width: 320, height: 85))
        tempLabel.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempLabel.layer.cornerRadius = 5
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor.black
        //tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.lineBreakMode = .byTruncatingTail
        tempLabel.numberOfLines = 4
        tempLabel.textAlignment = .justified
        return tempLabel
    }()
    
    //定义毛玻璃灰层
    lazy var grayLayer:UIView = {
        //y= 64表示要显示上方的切换按钮
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.2
        return tempView
    }()
    
    //导航栏
    let navigationBarInMessageList:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
    //

    override func viewDidLoad() {
        super.viewDidLoad()
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
        titleLabel.text = "消息列表"
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
        let rightBarItem = UIBarButtonItem(title: "清空列表", style: .plain,
                                           target: self, action: #selector(clearAllMessgesInList))
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
        
        
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if DEBUG
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        #endif
        
        messageListTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        messageListTableView.isScrollEnabled = true
        messageListTableView.rowHeight = UITableViewAutomaticDimension
        messageListTableView.estimatedRowHeight = 100
        messageListTableView.separatorStyle = .none//.none
        messageListTableView.separatorColor = UIColor.clear
        //调试一下，展示隐藏
        //loadOrderDataFromServer(pages: 1)
        //添加下拉刷新
        //addPullToRefresh(animator: header)
        messageListTableView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }

        self.view.addSubview(messageListTableView)
        // Do any additional setup after loading the view.
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //self.page = 1
            self.messagesList.removeAll()
            self.getMessageList()
            //self.loadOrderDataFromServer(pages:self.page)
        }
    }
    
    func getMessageList(){
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
                    if json["status","code"].int! == 3{
                        for item in json["msginfo"].array! {
                            let restoreItem = item.dictionaryObject as! NSDictionary
                            self.messagesList.append(restoreItem)
                        }
                        self.getMessagesCount = self.messagesList.count
                    }else if json["status","code"].int! == 0{
                        self.getMessagesCount = 0
                    }
                    print("messageList successed")
                    self.messageListTableView.reloadData()
                    self.messageListTableView.es.stopPullToRefresh()
                }
            case false:
                print("update failed")
                self.messageListTableView.reloadData()
                self.messageListTableView.es.stopPullToRefresh()
                
            }
        }
    }
    
    //点击返回
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func clearAllMessgesInList(){
        print("清空消息列表")
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
        params["commandcode"] = 100
        
        var requestUrl:String = ""
        if roletype == "3" {
            #if DEBUG
                requestUrl = apiAddresses.value(forKey: "clearNotificationMsgDebug") as! String
            #else
                requestUrl = apiAddresses.value(forKey: "clearNotificationMsg") as! String
            #endif
        }
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["status","code"].int!
                    if statusObject == 0{
                        print("消息清除成功")
                        greyLayerPrompt.show(text: "清除成功")
                        self.getMessageList()
                    }else{
                        print("报价失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: errorMsg)
                        //self.closeQuotePriceView()
                        //self.getMessageList()
                    }
                }
            case false:
                print("清空失败")
                greyLayerPrompt.show(text: "清空失败,请重试")
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if messagesList.count == 0 {
//            return 1 // 测试
//        }
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessagesTableViewCell.customCell(tableView: messageListTableView)
        if messagesList.count == 0  {
            print("消息列表没有了")
           // workZoneVC.getMessageList()
//            if !isblurPopViewPresenting{
//                self.dismiss(animated: true, completion: nil)
//            }
        }else{
            let dictionaryObjectInTaskArray = messagesList[indexPath.row]
            if dictionaryObjectInTaskArray.value(forKey: "msgsendtime") as? String == nil{
                cell.msgCreateTimeInList.text = "2018-01-01 11:07:28"
            }else{
                cell.msgCreateTimeInList.text = dictionaryObjectInTaskArray.value(forKey: "msgsendtime") as? String
            }
            
            if dictionaryObjectInTaskArray.value(forKey: "msgtitle") as? String == nil{
                cell.msgTitleInList.text = "标准消息"
            }else{
                cell.msgTitleInList.text = dictionaryObjectInTaskArray.value(forKey: "msgtitle") as? String
            }
            
            if dictionaryObjectInTaskArray.value(forKey: "orderid") as? String == nil{
                cell.msgOrderIDInList.text = "10000000000"
            }else{
                cell.msgOrderIDInList.text = dictionaryObjectInTaskArray.value(forKey: "orderid") as? String
            }
            
            if dictionaryObjectInTaskArray.value(forKey: "msgcontent") as? String == nil{
                cell.msgContentInList.text = "无内容"
            }else{
                cell.msgContentInList.text = dictionaryObjectInTaskArray.value(forKey: "msgcontent") as? String
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        return UITableViewCellEditingStyle.delete
//    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //点击删除按钮的响应方法，在这里处理删除的逻辑
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            self.messagesList.remove(at: indexPath.row)// removeAtIndex(indexPath.row)
            self.messageListTableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1//CGFloat.leastNormalMagnitude
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("\(indexPath.row) selected")
        
        /* msgtype
         0：系统消息
         1：发起询价 -
         2：报价 -
         3：定价 -
         4：发起设计 -
         5：接受设计单 -
         6：提交设计稿 -
         7：重新设计 -
         8：定稿 -
         9：付款 -
         10：发送新订单-
         11：开始生产 -
         12：中断生产 -
         13：邮递 -
         14：确认收货 -
         15：发起售后 -
         16：退货后退款
         17：退款 -
         18：退货后重做
         19：重做 -
         20：确认退款 -
         21：信息交流
         22：催单信息
         23：其他信息
         */
        
        
        let dictionaryObjectInTaskArray = messagesList[indexPath.row]
        let msgtype = dictionaryObjectInTaskArray.value(forKey: "msgtype") as! Int
        
        var messageID:String = "0"
        var orderID:String = "10000"
        var customID:String = "12000102"
        
        
        if dictionaryObjectInTaskArray.value(forKey: "orderid") as? String != nil{
            orderID = (dictionaryObjectInTaskArray.value(forKey: "orderid") as? String)!
        }
        if dictionaryObjectInTaskArray.value(forKey: "customid") as? String != nil{
            customID = (dictionaryObjectInTaskArray.value(forKey: "customid") as? String)!
        }
        
        if dictionaryObjectInTaskArray.value(forKey: "msgid") as? String == nil{
            messageID = "0"
        }else{
            messageID = (dictionaryObjectInTaskArray.value(forKey: "msgid") as? String)!
        }

        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        /*roletype 1:客服，2:设计师，3:工厂
         */
        if msgtype == 1 && roletype == "3"/*发起询价*/{
            let quotePriceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
            
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            quotePriceView.popupVC = popVC
            quotePriceView._orderID = orderID
            quotePriceView._customID = customID
            
            quotePriceView.createViewWithActionType(ActionType: .quotePrice)
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(quotePriceView)
            
            self.present(popVC, animated: true, completion: nil)
            //展示报价页面
        }else if msgtype == 4 && roletype == "2"/*发起设计*/{
            let acceptDesignView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
            
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            acceptDesignView.popupVC = popVC
            acceptDesignView._orderID = orderID
            acceptDesignView._customID = customID
            
            acceptDesignView.createViewWithActionType(ActionType: .acceptDesign)
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(acceptDesignView)
            
            self.present(popVC, animated: true, completion: nil)
            //跳转接受设计页面
        }else if msgtype == 10 && roletype == "3" /*发起生产*/{
            let acceptProduceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
            
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            acceptProduceView.popupVC = popVC
            acceptProduceView._orderID = orderID
            acceptProduceView._customID = customID
            
            acceptProduceView.createViewWithActionType(ActionType: .acceptProduce)
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(acceptProduceView)
            
            self.present(popVC, animated: true, completion: nil)
            
        }else {
            //其他处理方式
        }
        //处理消息
      //  dealMsg(MessageID: messageID)
    }
    
    //缩略图imageView点击
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = 0
        //进入图片全屏展示
        //let previewVC = ImagePreviewVC(images: memoPictures, index: index) //(index-10)
        let previewVC = ImagePreviewVC(images:memoPictures , index: index, previewMode: .previewWithoutDelete)
       // previewVC.roleType = roleType
        //previewVC.previewMode = PreviewModeType.previewWithoutDelete
        self.present(previewVC, animated: true, completion: nil)
    }


    //处理消息
    func dealMsg(MessageID:String){
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let requstURL:String = apiAddresses.value(forKey: "getMessagesDealDebug") as! String
        #else
            let requstURL:String = apiAddresses.value(forKey: "getMessagesDeal") as! String
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
                params["commandcode"] = 111
                params["msgid"] = MessageID
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
        _ = Alamofire.request(requstURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                print("处理成功")
                self.getMessageList()
            case false:
                print("处理失败")
                
            }
        }
        
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

// 获取用户信息
func getCurrentUserInfo() -> NSDictionary{
    var UserInfos = [String:String]()
    
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
            UserInfos["userid"] = "\(info.userId)"
            UserInfos["roletype"] = String(info.roleType)
            UserInfos["password"] = info.password

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
            UserInfos["token"] = info.token
        }
    } catch  {
        fatalError("获取失败")
    }
    
    return UserInfos as NSDictionary
}