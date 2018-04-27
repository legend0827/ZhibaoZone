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
        var heightOfTableView = UIScreen.main.bounds.height - 62
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
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
        currentValueOnSliderTextField.keyboardType = .decimalPad
        produceTimeCostTextField.keyboardType = .decimalPad

        self.view.backgroundColor = UIColor.white
        
        navigationBarInMessageList.isHidden = false
        navigationBarInMessageList.backgroundColor = UIColor.white
        navigationBarInMessageList.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "消息列表"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        let rightButton = UIBarButtonItem(title: "清空列表", style: .done, target: self, action: #selector(clearAllMessgesInList))
        rightButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)], for: .normal)
        
        rightButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        rightButton.titleTextAttributes(for: .normal)
        
        
        navItem.setLeftBarButton(leftButton, animated: false)
        navItem.setRightBarButton(rightButton, animated: false)
        navigationBarInMessageList.pushItem(navItem, animated: false)
        self.view.addSubview(navigationBarInMessageList)
        
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
                        self.closeQuotePriceView()
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
        if messagesList.count == 0 {
            return 1 // 测试
        }
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessagesTableViewCell.customCell(tableView: messageListTableView)
        if messagesList.count == 0  {
            print("消息列表没有了")
            workZoneVC.getMessageList()
            if !isblurPopViewPresenting{
                self.dismiss(animated: true, completion: nil)
            }
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
            
            if dictionaryObjectInTaskArray.value(forKey: "nickname") as? String == nil{
                cell.msgSenderUserNameInList.text = "无名氏"
            }else{
                cell.msgSenderUserNameInList.text = dictionaryObjectInTaskArray.value(forKey: "nickname") as? String
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
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
            DispatchQueue.main.async(execute: {
                self.showBlurPopView(operaType: "quotePrice") //显示报价窗口
                self.isblurPopViewPresenting = true
            })
            DispatchQueue.global(qos: .background).async(execute: {
                //获取订单详细信息
                DispatchQueue.main.async(execute: {
                    //显示报价数据
                    self.getOrderDetails(OrderID: orderID, CustomID: customID)
                })
                //当还没获取到订单时
                while(true){
                    if self.isOrderDetailsGets{
                        if self.orderDetail.count != 0{
                            DispatchQueue.main.async(execute: {
                                //显示报价数据
                                self.showBlurViewData()
                            })
                        }
                        break
                    }
                    //sleep(1)
                }
            })
            //展示报价页面
        }else if msgtype == 4 && roletype == "2"/*发起设计*/{
            DispatchQueue.main.async(execute: {
                self.showBlurPopView(operaType: "acceptDesign") //显示报价窗口
                self.isblurPopViewPresenting = true
            })
            DispatchQueue.global(qos: .background).async(execute: {
                //获取订单详细信息
                DispatchQueue.main.async(execute: {
                    //显示报价数据
                    self.getOrderDetails(OrderID: orderID, CustomID: customID)
                })
                //当还没获取到订单时
                var count = 0
                while(true){
                    count += 1
                    print("getting OrderDetails Data \(count)")
                    if self.isOrderDetailsGets{
                        if self.orderDetail.count != 0{
                            DispatchQueue.main.async(execute: {
                                //显示设计数据
                                self.showBlurViewData()
                            })
                        }
                        break
                    }
                    //sleep(1)
                }
            })
            //跳转接受设计页面
        }else if msgtype == 10 && roletype == "3" /*发起生产*/{
            DispatchQueue.main.async(execute: {
                self.showBlurPopView(operaType: "acceptProduce") //显示报价窗口
                self.isblurPopViewPresenting = true
            })
            DispatchQueue.global(qos: .background).async(execute: {
                //获取订单详细信息
                DispatchQueue.main.async(execute: {
                    //显示报价数据
                    self.getOrderDetails(OrderID: orderID, CustomID: customID)
                })
                //当还没获取到订单时
                var count = 0
                while(true){
                    count += 1
                    print("getting OrderDetails Data \(count)")
                    if self.isOrderDetailsGets{
                        if self.orderDetail.count != 0{
                            DispatchQueue.main.async(execute: {
                                //显示生产数据
                                self.showBlurViewData()
                            })
                        }
                        break
                    }
                    //sleep(1)
                }
            })
            //跳转接受订单页面
            
        }else{
            //其他处理方式
        }
        //处理消息
        dealMsg(MessageID: messageID)
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
    // 加载报价所需数据
    func showBlurViewData(){

        var maxPrice = 5000.0
        var currentValue:Float = 0.0
        
        //设置客户心理价(预算）
        var mindPrice:Float = 0.0
        var quotePriceOfFactory:Float = 0.0
        let userInfo = getCurrentUserInfo()
        roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
        //let roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
        
        let dictionaryObjectInOrderArray = orderDetail
        let priceInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "price") as! NSDictionary
         let statusObjects = dictionaryObjectInOrderArray[2].value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "orderinfo") as! NSDictionary
        
        let orderaddinfos = dictionaryObjectInOrderArray[1]
        
        let accessoriesObject = goodsInfoObjects.value(forKey: "accessoriesname")
        let colorObject = goodsInfoObjects.value(forKey: "color")
        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary
        
        //附件图片数目
        var attachImageCount:Int = 0
        //设计师图递增
        if roleType == 2{
            memoPictures.removeAll()
            if orderaddinfos.value(forKey: "imageurl1") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "imageurl2") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
                
            }
            if orderaddinfos.value(forKey: "imageurl3") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
        }
        //工厂图递增
        if roleType == 3{
            memoPictures.removeAll()
            if orderaddinfos.value(forKey: "fimageurl1") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "fimageurl2") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "fimageurl3") as? String != nil {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            
            //没有一张工厂的参考图
            if attachImageCount == 0{
                if orderaddinfos.value(forKey: "imageurl1") as? String != nil {
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
                if orderaddinfos.value(forKey: "imageurl2") as? String != nil {
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
                if orderaddinfos.value(forKey: "imageurl3") as? String != nil {
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
            }
        }
        
        orderDefaultPicLayer.removeFromSuperview()
        for subview in orderDefaultPic.subviews{
            subview.removeFromSuperview()
        }
        
        if attachImageCount != 0{
            
            orderDefaultPic.addSubview(orderDefaultPicLayer)
            for i in 1...attachImageCount{
                //附件数目小红点
                var positionX = 0
                var fistPositon = 35
                if attachImageCount == 2{
                    positionX = i*(30/(attachImageCount+1))
                    fistPositon = 35
                }else{
                    positionX = i*(40/(attachImageCount+1))
                    fistPositon = 30
                }
                let imageCountLabel:UILabel = UILabel.init(frame: CGRect(x: fistPositon + positionX, y: 87, width: 5, height: 5))
                imageCountLabel.backgroundColor = UIColor.white
                imageCountLabel.layer.cornerRadius = 2.5
                //imageCountLabel.text = "\(attachImageCount)"
                imageCountLabel.textColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
                imageCountLabel.textAlignment = .center
                imageCountLabel.clipsToBounds = true // 对Label切角度
                
                orderDefaultPic.addSubview(imageCountLabel)
            }
            orderDefaultPic.isUserInteractionEnabled = true

            let tapSingle=UITapGestureRecognizer(target:self,
                                                 action:#selector(imageViewTap(_:)))
            tapSingle.numberOfTapsRequired = 1
            tapSingle.numberOfTouchesRequired = 1
            
            orderDefaultPic.addGestureRecognizer(tapSingle)
        }
        
        
        //设置图片
        if roleType == 2 {
            var imageURLString:String = ""
            if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
                if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
                    if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
                        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                    }else{
                        //第三张图不为空
                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            
                            //测试gif图
                            //let image = UIImage(data: data)
                            let image = UIImage.gif(data:data)
                            orderDefaultPic.image = image//  UIImage(image:image)
                        }catch{
                            print(error)
                        }
                    }
                }else{
                    //第二不为空
                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        //测试gif图
                        //let image = UIImage(data: data)
                        let image = UIImage.gif(data:data)
                        orderDefaultPic.image = image//  UIImage(image:image)
                    }catch{
                        print(error)
                    }
                }
            }else{
                //第一张图不为空
                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    //测试gif图
                    //let image = UIImage(data: data)
                    let image = UIImage.gif(data:data)
                    orderDefaultPic.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
            }
        }else if roleType == 3{
            var imageURLString:String = ""
            if orderaddinfos.value(forKey: "fimageurl1") as? String == nil {
                if orderaddinfos.value(forKey: "fimageurl2") as? String == nil {
                    if orderaddinfos.value(forKey: "fimageurl3") as? String == nil {
                        //三张工厂参考图都为空，加载设计参考图
                        if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
                            if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
                                if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
                                    orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                                }else{
                                    //第三张图不为空
                                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                                    let url = URL(string: imageURLString)!
                                    do{
                                        let data = try Data.init(contentsOf: url)
                                        //测试gif图
                                        //let image = UIImage(data: data)
                                        let image = UIImage.gif(data:data)
                                        orderDefaultPic.image = image//  UIImage(image:image)
                                    }catch{
                                        print(error)
                                    }
                                }
                            }else{
                                //第二不为空
                                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                                let url = URL(string: imageURLString)!
                                do{
                                    let data = try Data.init(contentsOf: url)
                                    //测试gif图
                                    //let image = UIImage(data: data)
                                    let image = UIImage.gif(data:data)
                                    orderDefaultPic.image = image//  UIImage(image:image)
                                }catch{
                                    print(error)
                                }
                            }
                        }else{
                            //第一张图不为空
                            imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                            let url = URL(string: imageURLString)!
                            do{
                                let data = try Data.init(contentsOf: url)
                                //测试gif图
                                //let image = UIImage(data: data)
                                let image = UIImage.gif(data:data)
                                orderDefaultPic.image = image//  UIImage(image:image)
                            }catch{
                                print(error)
                            }
                        }
                    }else{
                        //第三张图不为空
                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            //测试gif图
                            //let image = UIImage(data: data)
                            let image = UIImage.gif(data:data)
                            orderDefaultPic.image = image//  UIImage(image:image)
                        }catch{
                            print(error)
                        }
                    }
                }else{
                    //第二不为空
                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        //测试gif图
                        //let image = UIImage(data: data)
                        let image = UIImage.gif(data:data)
                        orderDefaultPic.image = image//  UIImage(image:image)
                    }catch{
                        print(error)
                    }
                }
            }else{
                //第一张图不为空
                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    //测试gif图
                    //let image = UIImage(data: data)
                    let image = UIImage.gif(data:data)
                    orderDefaultPic.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
            }
        }else{
            orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        }

        
        orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
        orderID.text = orderInfoObjects.value(forKey: "orderid") as? String
        productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsclass") as? String
        
        var tempMakeStyleValue = ""
        var texturenameValue = ""
        if goodsInfoObjects.value(forKey: "texturename") as? String != nil{
            texturenameValue = goodsInfoObjects.value(forKey: "texturename") as! String
            tempMakeStyleValue += texturenameValue
        }
        
        var colorValue = ""
        if colorObject as? String != nil {
            colorValue = colorObject as! String
            tempMakeStyleValue += ",\(colorValue)"
        }
        var shapeVlaue = ""
        if goodsInfoObjects.value(forKey: "shape") as? String != nil{
            shapeVlaue = goodsInfoObjects.value(forKey: "shape") as! String
            tempMakeStyleValue += ",\(shapeVlaue)"
        }
        
        var technologyValue = ""
        if goodsInfoObjects.value(forKey: "technology") as? String != nil{
            technologyValue = goodsInfoObjects.value(forKey: "technology") as! String
            tempMakeStyleValue += ",\(technologyValue)"
        }
        
        makeStyleValue.text = tempMakeStyleValue
        accessoriesValue.text = accessoriesObject as? String
        
        //设置产品数目
        if goodsInfoObjects.value(forKey: "number") as? Int != nil{
            orderCountValue.text = "\(goodsInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            orderCountValue.text = ""
        }

        if sizeObject.value(forKey: "height") as? Float != nil {
            productSizeOfHeightValue.text = "\(sizeObject.value(forKey: "height")as! Float)"
        }else{
            productSizeOfHeightValue.text = ""
        }
        
        if sizeObject.value(forKey: "width") as? Float != nil {
            productSizeOfWidthValue.text = "\(sizeObject.value(forKey: "width")as! Float)"
        }else{
            productSizeOfWidthValue.text = ""
        }
        
        if sizeObject.value(forKey: "length") as? Float != nil {
            productSizeOfLengthValue.text = "\(sizeObject.value(forKey: "length")as! Float)"
        }else{
            productSizeOfLengthValue.text = ""
        }
                

        
        //优先客户心理价，再估价，再系统估价
        if priceInfoObjects.value(forKey: "mindprice") as? Float == nil || priceInfoObjects.value(forKey: "mindprice") as! Float == 0.0{
            maxPrice = 5000.0
        }else{
            maxPrice = Double((priceInfoObjects.value(forKey: "mindprice") as! Float)*3)
        }
        
        //设置上次报价
        if priceInfoObjects.value(forKey: "returnprice") as? Float == nil{
            quotePriceAtLastTimeValue.text = "¥0.00"
        }else{
            quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
            quotePriceOfFactory = priceInfoObjects.value(forKey: "returnprice") as! Float
            currentValue = Float(priceInfoObjects.value(forKey: "returnprice") as! Float)
            
        }
        
        //设置订单金额（工厂接受生产时显示）
        if roleType == 3 && (statusObjects.value(forKey:"orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int == 7{//接受生产
            if priceInfoObjects.value(forKey: "finalprice") as? Float == nil{
                quotePriceAtLastTimeValue.text = "¥0.00"
            }else{
                quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Float)0"
                quotePriceOfFactory = priceInfoObjects.value(forKey: "finalprice") as! Float
                currentValue = Float(priceInfoObjects.value(forKey: "finalprice") as! Float)
            }
        }
        
        if priceInfoObjects.value(forKey: "mindprice") as? Float == nil{
            customerPriceValue.text = "¥0.00"
        }else{
            customerPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Float)0"
            mindPrice = priceInfoObjects.value(forKey: "mindprice") as! Float
        }
        
        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
        if mindPrice != 0.0 {
            if roleType != 1{
                if roleType == 3 && (mindPrice < quotePriceOfFactory){
                    if (statusObjects.value(forKey:"payoffstate") as! NSDictionary).value(forKey: "code") as! Int == 1{
                        customerPriceLabel.isHidden = true
                        customerPriceValue.isHidden = true
                    }else{
                        customerPriceLabel.isHidden = false
                        customerPriceValue.isHidden = false
                    }
                }else{
                    customerPriceLabel.isHidden = true
                    customerPriceValue.isHidden = true
                }
            }else{
                customerPriceLabel.isHidden = false
                customerPriceValue.isHidden = false
            }
        }else{
            customerPriceLabel.isHidden = true
            customerPriceValue.isHidden = true
        }
        
        currentValueOnSliderTextField.text = "\(currentValue)"
        quotePriceSlideBar.maximumValue = Float(maxPrice)
        quotePriceSlideBar.setValue(currentValue, animated: true)
        quotePriceSlideBarRightLabel.text = "¥\(maxPrice)0"
        quotePriceSlideBarMidLabel.text = "¥\(maxPrice/2)0"
        quotePriceSlideBarLeftLabel.text = "¥0.00"
        
        if roleType == 2{
            //加载设计备注信息
            var designMemoInfo = orderaddinfos.value(forKey: "remarks") as? String
            if designMemoInfo == nil{
                designMemoInfo = "无备注信息"
            }else{
                designMemoInfo = orderaddinfos.value(forKey: "remarks") as! String
            }
            orderMemosForDesignOrProducer.text = designMemoInfo
            
            designFeeValue.text =  "¥\(priceInfoObjects.value(forKey: "designprice") as! Int).00"
        }else if roleType == 3{
            //加载工厂备注信息
            var factoryMemoInfo = orderaddinfos.value(forKey: "fremarks") as? String
            if factoryMemoInfo == nil{
                factoryMemoInfo = "无备注信息"
            }else{
                factoryMemoInfo = orderaddinfos.value(forKey: "fremarks") as! String
            }
            orderMemosForDesignOrProducer.text = factoryMemoInfo
        }else{
            orderMemosForDesignOrProducer.text = "没有备注"
        }

    }
    
    //显示报价窗口
    func showBlurPopView(operaType:String){
        produceTimeCostTextField.text = ""
        
        var maxPrice = 5000.0
        var currentValue:Float = 0.0

        //mark  3 字 y = 60, 4字 y = 75
        let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 150, y: 50, width: 200, height: 30))
        
        //产品类型
        let productTypeNameLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 175, width: 100, height: 30))
        //工艺
        let makeStyleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 200, width: 200, height: 30))
        //附件
        let accessoriesLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 225, width: 100, height: 30))
        
        //订购数目
        let orderCountLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 75, width: 100, height: 30))
        //产品尺寸
        //长
        // x: 190
        let productSizeOfLengthLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 100, width: 100, height: 30))
        //宽
        let productSizeOfWidthLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 100, width: 100, height: 30))
        //高
        let productSizeOfHeightLabel:UILabel = UILabel.init(frame: CGRect(x: 250, y: 100, width: 100, height: 30))
        //圆形产品尺寸提示
        let productSizeHintLabel:UILabel = UILabel.init(frame:CGRect(x: 130, y: 150, width: 200, height: 30))
        
        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        orderDefaultPicLayer.backgroundColor = UIColor.gray
        orderDefaultPicLayer.alpha = 0.4
        
        orderDefaultPic.layer.borderColor = UIColor.gray.cgColor
        orderDefaultPic.layer.borderWidth = 1
        orderDefaultPic.layer.cornerRadius = 5
        
        orderDefaultPicLayer.layer.borderColor = UIColor.clear.cgColor
        orderDefaultPicLayer.layer.borderWidth = 1
        orderDefaultPicLayer.layer.cornerRadius = 5
        
        orderTimeLabel.text = "2017-10-16 09:00:00"
        orderTimeLabel.font = UIFont.systemFont(ofSize: 13)
        orderTimeLabel.textColor = UIColor.gray
        
        orderIDLabel.text = "订单号:"
        orderIDLabel.font = UIFont.systemFont(ofSize: 13)
        orderIDLabel.textColor = UIColor.gray
        
        orderID.text = "000000000000000"
        orderID.font = UIFont.systemFont(ofSize: 13)
        orderID.textColor = UIColor.black
        
        productTypeNameLabel.text = "产品类型:"
        productTypeNameLabel.font = UIFont.systemFont(ofSize: 13)
        productTypeNameLabel.textColor = UIColor.gray
        productTypeNameValue.text = "..."
        productTypeNameValue.font = UIFont.systemFont(ofSize: 14)
        productTypeNameValue.textColor = UIColor.black
        
        
        let tempMakeStyleValue = "..."
        let texturenameValue = "..."
        let colorValue = "..."
        let shapeVlaue = "..."
        let technologyValue = "..."

        makeStyleLabel.text = "工艺:"
        makeStyleLabel.font = UIFont.systemFont(ofSize: 13)
        makeStyleLabel.textColor = UIColor.gray
        makeStyleValue.text = tempMakeStyleValue
        makeStyleValue.font = UIFont.systemFont(ofSize: 14)
        makeStyleValue.textColor = UIColor.black
        
        accessoriesLabel.text = "附件:"
        accessoriesLabel.font = UIFont.systemFont(ofSize: 13)
        accessoriesLabel.textColor = UIColor.gray
        accessoriesValue.text = "..."
        accessoriesValue.font = UIFont.systemFont(ofSize: 14)
        accessoriesValue.textColor = UIColor.black
        
        orderCountLabel.text = "数量"
        orderCountLabel.font = UIFont.systemFont(ofSize: 13)
        orderCountLabel.textColor = UIColor.gray
        
        //设置产品数目
        orderCountValue.text = "0" //"1000"

        orderCountValue.font = UIFont.systemFont(ofSize: 14)
        orderCountValue.textColor = UIColor.black
        
        productSizeOfHeightLabel.text = "高(mm)"
        productSizeOfHeightLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfHeightLabel.textColor = UIColor.gray
        productSizeOfHeightValue.text = "0"
        
        productSizeOfHeightValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfHeightValue.textColor = UIColor.black
        
        productSizeOfWidthLabel.text = "宽(mm) x"
        productSizeOfWidthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfWidthLabel.textColor = UIColor.gray
        productSizeOfWidthValue.text = "0"
        productSizeOfWidthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfWidthValue.textColor = UIColor.black
        
        productSizeOfLengthLabel.text = "长(mm) x"
        productSizeOfLengthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfLengthLabel.textColor = UIColor.gray
        productSizeOfLengthValue.text = "0"
        
        productSizeOfLengthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfLengthValue.textColor = UIColor.black
        
        productSizeHintLabel.text = "圆形产品直径参考长度（或宽度）值"
        productSizeHintLabel.textColor = UIColor.gray
        productSizeHintLabel.font = UIFont.systemFont(ofSize: 10)
        
        
        //设置客户心理价(预算）
        var mindPrice = 0
        var quotePriceOfFactory = 0
        let userInfo = getCurrentUserInfo()
        roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
        
        let quotePriceAtLastTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 295, width: 200, height: 44))
        quotePriceAtLastTimeLabel.text = "上次报价:"
        quotePriceAtLastTimeLabel.textColor = UIColor.gray
        quotePriceAtLastTimeLabel.font = UIFont.systemFont(ofSize: 14)
        //设置上次报价
        quotePriceAtLastTimeValue.text = "¥0.00"
        quotePriceOfFactory = 0

        quotePriceAtLastTimeValue.textColor = UIColor.orange
        quotePriceAtLastTimeValue.font = UIFont.systemFont(ofSize: 16)
        
        customerPriceLabel.text = "预算:"
        customerPriceLabel.textColor = UIColor.gray
        customerPriceLabel.font = UIFont.systemFont(ofSize: 14)
        
        customerPriceValue.text = "¥0.00"
        customerPriceValue.textColor = UIColor.orange
        customerPriceValue.font = UIFont.systemFont(ofSize: 16)
        
        
        let quotePriceCurrentLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 335, width: 200, height: 44))
        quotePriceCurrentLabel.text = "设置当前报价:"
        quotePriceCurrentLabel.textColor = UIColor.gray
        quotePriceCurrentLabel.font = UIFont.systemFont(ofSize: 14)
        
        let produceTimeCostLabel:UILabel = UILabel.init(frame: CGRect(x: 211, y: 335, width: 200, height: 44))
        produceTimeCostLabel.text = "工期:"
        produceTimeCostLabel.textColor = UIColor.gray
        produceTimeCostLabel.font = UIFont.systemFont(ofSize: 14)
        
        let produceTimeCostHintLabel:UILabel = UILabel.init(frame: CGRect(x: 311, y: 335, width: 200, height: 44))
        produceTimeCostHintLabel.text = "天"
        produceTimeCostHintLabel.textColor = UIColor.gray
        produceTimeCostHintLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        quotePriceSlideBar.maximumValue = Float(maxPrice)
        quotePriceSlideBar.minimumValue = 0.0
        quotePriceSlideBar.isContinuous = true
        quotePriceSlideBar.setValue(currentValue, animated: true)
        
        quotePriceSlideBarRightLabel.text = "¥\(maxPrice)0"
        quotePriceSlideBarRightLabel.textColor = UIColor.orange
        quotePriceSlideBarRightLabel.font = UIFont.systemFont(ofSize: 10)
        quotePriceSlideBarRightLabel.textAlignment = .right
        
        
        quotePriceSlideBarMidLabel.text = "¥\(maxPrice/2)0"
        quotePriceSlideBarMidLabel.textColor = UIColor.orange
        quotePriceSlideBarMidLabel.font = UIFont.systemFont(ofSize: 10)
        quotePriceSlideBarMidLabel.textAlignment = .center
        
        quotePriceSlideBarLeftLabel.text = "¥0.00"
        quotePriceSlideBarLeftLabel.textColor = UIColor.orange
        quotePriceSlideBarLeftLabel.font = UIFont.systemFont(ofSize: 10)
        
        quotePriceSlideBar.addTarget(self, action: #selector(quotePriceSliderBarValueChanged(_:)), for: .valueChanged)
        
        currentValueOnSliderTextField.font = UIFont.systemFont(ofSize: 16)
        
        
        blurPopView.backgroundColor = UIColor.white
        blurPopView.layer.cornerRadius = 15

        
        //分割线view for 订单信息
        let seperateLineForOrderInfoView: UIView = UIView.init(frame: CGRect(x: 25, y: 30, width: 300, height: 1))
        seperateLineForOrderInfoView.backgroundColor = UIColor.gray
        
        let titleLabelOnLineForOrderInfoView:UILabel = UILabel.init(frame: CGRect(x: 135, y: 15, width: 80, height: 30))
        titleLabelOnLineForOrderInfoView.text = "订单信息"
        titleLabelOnLineForOrderInfoView.font = UIFont.systemFont(ofSize: 14)
        titleLabelOnLineForOrderInfoView.textAlignment = .center
        titleLabelOnLineForOrderInfoView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        titleLabelOnLineForOrderInfoView.backgroundColor = UIColor.white
        
        //分割线view
        let seperateLineView: UIView = UIView.init(frame: CGRect(x: 25, y: 280, width: 300, height: 1))
        seperateLineView.backgroundColor = UIColor.gray
        let titleLabelOnLineView:UILabel = UILabel.init(frame: CGRect(x: 155, y: 265, width: 40, height: 30))
        titleLabelOnLineView.text = "报价"
        titleLabelOnLineView.font = UIFont.systemFont(ofSize: 14)
        titleLabelOnLineView.textAlignment = .center
        titleLabelOnLineView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        titleLabelOnLineView.backgroundColor = UIColor.white

        //关闭按钮
        let closeQuotePriceBtn:UIButton = UIButton.init(type: .system)
        closeQuotePriceBtn.frame = CGRect(x: 305, y: 5, width: 40, height: 40)
        closeQuotePriceBtn.layer.backgroundColor = UIColor.white.cgColor
        closeQuotePriceBtn.layer.cornerRadius = 20
        let iconImage = UIImage(named:"close-red")?.withRenderingMode(.alwaysOriginal)
        closeQuotePriceBtn.setImage(iconImage, for: UIControlState.normal)
        //closeQuotePriceBtn.adjustsImageWhenHighlighted = false
        closeQuotePriceBtn.addTarget(self, action: #selector(closeQuotePriceView), for: .touchUpInside)
        
        //报价按钮
        let confirmQuotePriceBtn:UIButton = UIButton.init(type: .system)
        confirmQuotePriceBtn.frame = CGRect(x: 195, y: 455, width: 120, height: 40)
        confirmQuotePriceBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
        confirmQuotePriceBtn.layer.cornerRadius = 5
        confirmQuotePriceBtn.setTitle("提交报价", for: .normal)
        confirmQuotePriceBtn.setTitleColor(UIColor.white, for: .normal)
        
        //设置或权重
        setQuotePriceWeightBtn.frame = CGRect(x: -5, y: 437, width: 120, height: 40)
        setQuotePriceWeightBtn.setTitle("调整报价精度", for: .normal)
        setQuotePriceWeightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        setQuotePriceWeightBtn.titleLabel?.textAlignment = .left
        setQuotePriceWeightBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
        setQuotePriceWeightBtn.addTarget(self, action: #selector(setQuotePriceWeight), for: .touchUpInside)
        
        
        //接受设计按钮
        let accpetDesignBtn:UIButton = UIButton.init(type: .system)
        accpetDesignBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
        accpetDesignBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
        accpetDesignBtn.layer.cornerRadius = 5
        accpetDesignBtn.setTitle("接受设计", for: .normal)
        accpetDesignBtn.setTitleColor(UIColor.white, for: .normal)
        
        //接受生产按钮
        let accpetProduceBtn:UIButton = UIButton.init(type: .system)
        accpetProduceBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
        accpetProduceBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
        accpetProduceBtn.layer.cornerRadius = 5
        accpetProduceBtn.setTitle("开始生产", for: .normal)
        accpetProduceBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        confirmQuotePriceBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
        accpetDesignBtn.addTarget(self, action: #selector(confirmAcceptDesignBtnClicked), for: .touchUpInside)
        accpetProduceBtn.addTarget(self, action: #selector(confirmAcceptProduceBtnClicked), for: .touchUpInside)
        
        currentValueOnSliderTextField.text = "\(currentValue)"
        
        let orderMemosForDesignOrProducerLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 320, width: 200, height: 44))
        orderMemosForDesignOrProducerLabel.textColor = UIColor.gray
        orderMemosForDesignOrProducerLabel.font = UIFont.systemFont(ofSize: 14)
        orderMemosForDesignOrProducerLabel.text = "设计备注"

        //quotePriceSlideBarLeftLabel.text = "¥0.00"
        designFeeValue.textColor = UIColor.orange
        designFeeValue.font = UIFont.systemFont(ofSize: 16)
        designFeeValue.text = ""
        
        orderMemosForDesignOrProducer.text = ""
        //根据身份判断显示字段和隐藏字段
        if roleType == 2 {
            //设计师角色
            accpetDesignBtn.isHidden = false
            accpetProduceBtn.isHidden = true
            confirmQuotePriceBtn.isHidden = true
            setQuotePriceWeightBtn.isHidden = true
            
            //隐藏数量字段
            orderCountLabel.isHidden = true
            orderCountValue.isHidden = true
            //高度（厚度）隐藏
            productSizeOfHeightValue.isHidden = true
            productSizeOfWidthLabel.text = "宽(mm)"
            productSizeOfHeightLabel.isHidden = true
            
            //调整长*宽显示位置
            productSizeOfHeightLabel.frame = CGRect(x: 250, y: 75, width: 100, height: 30)
            productSizeOfWidthLabel.frame = CGRect(x: 190, y: 75, width: 100, height: 30)
            productSizeOfLengthLabel.frame = CGRect(x: 130, y: 75, width: 100, height: 30)
            productSizeHintLabel.frame = CGRect(x: 130, y: 125, width: 200, height: 30)
            
            productSizeOfHeightValue.frame = CGRect(x: 250, y: 100, width: 100, height: 30)
            productSizeOfWidthValue.frame = CGRect(x: 190, y: 100, width: 100, height: 30)
            productSizeOfLengthValue.frame = CGRect(x: 130, y: 100, width: 100, height: 30)
            

            
            //隐藏上次报价，预算，当前报价，工期，拖动条等
            quotePriceAtLastTimeLabel.isHidden = true
            quotePriceAtLastTimeValue.isHidden = true
            customerPriceLabel.isHidden = true
            customerPriceValue.isHidden = true
            quotePriceCurrentLabel.isHidden = true
            currentValueOnSliderTextField.isHidden = true
            produceTimeCostLabel.isHidden = true
            produceTimeCostHintLabel.isHidden = true
            produceTimeCostTextField.isHidden = true
            quotePriceSlideBar.isHidden = true
            quotePriceSlideBarMidLabel.isHidden = true
            quotePriceSlideBarLeftLabel.isHidden = true
            quotePriceSlideBarRightLabel.isHidden = true
            
            
            //文案调整
            titleLabelOnLineView.text = "设计备注"
            titleLabelOnLineView.frame = CGRect(x: 135, y: 265, width: 80, height: 30)
            
            let designFeeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 285, width: 200, height: 44))
            designFeeLabel.textColor = UIColor.gray
            designFeeLabel.font = UIFont.systemFont(ofSize: 14)
            designFeeLabel.text = "设计费"
            
            designFeeValue.isHidden = false
            orderMemosForDesignOrProducerLabel.isHidden = false
            orderMemosForDesignOrProducer.isHidden = false
            
            blurPopView.addSubview(designFeeLabel)
            
        }else if roleType == 3{
            //显示数量字段
            orderCountLabel.isHidden = false
            orderCountValue.isHidden = false
            
            //高度（厚度）隐藏
            productSizeOfHeightValue.isHidden = false
            productSizeOfWidthLabel.text = "宽(mm) x"
            productSizeOfHeightLabel.isHidden = false
            
            //隐藏设计费
            designFeeValue.isHidden = true
            
            orderMemosForDesignOrProducerLabel.text = "生产备注"

            //工厂角色
            if operaType == "quotePrice"{
                accpetDesignBtn.isHidden = true
                accpetProduceBtn.isHidden = true
                setQuotePriceWeightBtn.isHidden = false
                confirmQuotePriceBtn.isHidden = false
                
                //文案调整
                titleLabelOnLineView.text = "报价"
                
                //显示上次报价，预算，当前报价，工期，拖动条等
                quotePriceAtLastTimeLabel.isHidden = false
                quotePriceAtLastTimeValue.isHidden = false
                customerPriceLabel.isHidden = false
                customerPriceValue.isHidden = false
                quotePriceCurrentLabel.isHidden = false
                currentValueOnSliderTextField.isHidden = false
                produceTimeCostLabel.isHidden = false
                produceTimeCostHintLabel.isHidden = false
                produceTimeCostTextField.isHidden = false
                produceTimeCostLabel.frame = CGRect(x: 211, y: 335, width: 200, height: 44)
                produceTimeCostHintLabel.frame = CGRect(x: 311, y: 335, width: 200, height: 44) //335
                produceTimeCostTextField.frame = CGRect(x: 250, y: 342, width: 56, height: 30) // 342
                quotePriceSlideBar.isHidden = false
                quotePriceSlideBarMidLabel.isHidden = false
                quotePriceSlideBarLeftLabel.isHidden = false
                quotePriceSlideBarRightLabel.isHidden = false
                
                orderMemosForDesignOrProducerLabel.isHidden = true
                orderMemosForDesignOrProducer.isHidden = true

            }else if operaType == "acceptProduce"{
                accpetDesignBtn.isHidden = true
                accpetProduceBtn.isHidden = false
                confirmQuotePriceBtn.isHidden = true
                setQuotePriceWeightBtn.isHidden = true
                
                //显示上次报价，预算，当前报价，工期，拖动条等
                quotePriceAtLastTimeLabel.isHidden = false
                quotePriceAtLastTimeLabel.text = "订单金额"
                quotePriceAtLastTimeValue.isHidden = false
                customerPriceLabel.isHidden = true
                customerPriceValue.isHidden = true
                quotePriceCurrentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = false
                produceTimeCostHintLabel.isHidden = false
                produceTimeCostTextField.isHidden = false
                produceTimeCostLabel.frame = CGRect(x: 211, y: 295, width: 200, height: 44)
                produceTimeCostHintLabel.frame = CGRect(x: 311, y: 295, width: 200, height: 44) //335
                produceTimeCostTextField.frame = CGRect(x: 250, y: 302, width: 56, height: 30) // 342
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                
                orderMemosForDesignOrProducerLabel.isHidden = false
                orderMemosForDesignOrProducer.isHidden = false
                
                //文案调整
                titleLabelOnLineView.text = "订单备注"
                titleLabelOnLineView.frame = CGRect(x: 135, y: 265, width: 80, height: 30)

            }else{
                print("error type")
            }
        }else {
            //其他角色
            accpetDesignBtn.isHidden = true
            accpetProduceBtn.isHidden = true
            confirmQuotePriceBtn.isHidden = true
            print("error roleType")
        }
        
        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
        customerPriceLabel.isHidden = true
        customerPriceValue.isHidden = true
        
        blurPopView.addSubview(designFeeValue)
        blurPopView.addSubview(orderMemosForDesignOrProducer)
        blurPopView.addSubview(orderMemosForDesignOrProducerLabel)
        
        
        blurPopView.addSubview(accpetDesignBtn)
        blurPopView.addSubview(accpetProduceBtn)
        blurPopView.addSubview(setQuotePriceWeightBtn)
        blurPopView.addSubview(produceTimeCostHintLabel)
        blurPopView.addSubview(produceTimeCostLabel)
        blurPopView.addSubview(produceTimeCostTextField)
        blurPopView.addSubview(orderDefaultPic)
        blurPopView.addSubview(orderTimeLabel)
        blurPopView.addSubview(orderIDLabel)
        blurPopView.addSubview(orderID)
        blurPopView.addSubview(productTypeNameLabel)
        blurPopView.addSubview(productTypeNameValue)
        blurPopView.addSubview(makeStyleLabel)
        blurPopView.addSubview(makeStyleValue)
        blurPopView.addSubview(accessoriesLabel)
        blurPopView.addSubview(accessoriesValue)
        blurPopView.addSubview(orderCountLabel)
        blurPopView.addSubview(orderCountValue)
        blurPopView.addSubview(productSizeOfWidthLabel)
        blurPopView.addSubview(productSizeOfWidthValue)
        blurPopView.addSubview(productSizeOfLengthLabel)
        blurPopView.addSubview(productSizeOfLengthValue)
        blurPopView.addSubview(productSizeOfHeightLabel)
        blurPopView.addSubview(productSizeOfHeightValue)
        blurPopView.addSubview(productSizeHintLabel)
        blurPopView.addSubview(quotePriceCurrentLabel)
        blurPopView.addSubview(quotePriceAtLastTimeValue)
        blurPopView.addSubview(quotePriceAtLastTimeLabel)
        blurPopView.addSubview(customerPriceLabel)
        blurPopView.addSubview(customerPriceValue)
        
        blurPopView.addSubview(currentValueOnSliderTextField)
        blurPopView.addSubview(quotePriceSlideBar)
        blurPopView.addSubview(quotePriceSlideBarLeftLabel)
        blurPopView.addSubview(quotePriceSlideBarMidLabel)
        blurPopView.addSubview(quotePriceSlideBarRightLabel)
        blurPopView.addSubview(seperateLineView)
        blurPopView.addSubview(titleLabelOnLineView)
        blurPopView.addSubview(seperateLineForOrderInfoView)
        blurPopView.addSubview(titleLabelOnLineForOrderInfoView)
        blurPopView.addSubview(closeQuotePriceBtn)
        blurPopView.addSubview(confirmQuotePriceBtn)
        
        blurPopView.backgroundColor = UIColor.white
        blurPopView.layer.cornerRadius = 15
        
        theChildViewNeedToClose.removeAll()

        if roleType == 2 {
            //设计师角色
            let blurView = showBlurEffect(text: "接受设计")
            self.view.addSubview(blurView)
            theChildViewNeedToClose.append(blurView)

        }else if roleType == 3{
            //工厂角色
            if operaType == "quotePrice"{
                let blurView = showBlurEffect(text: "订单报价")
                self.view.addSubview(blurView)
                theChildViewNeedToClose.append(blurView)

            }else if operaType == "acceptProduce"{
                let blurView = showBlurEffect(text: "接受生产")
                self.view.addSubview(blurView)
                theChildViewNeedToClose.append(blurView)
            }else{
                print("error type")
            }
        }else {
            //其他角色
            accpetDesignBtn.isHidden = true
            accpetProduceBtn.isHidden = true
            confirmQuotePriceBtn.isHidden = true
            print("error roleType")
        }
        
        
        self.view.addSubview(grayLayer)
        self.view.addSubview(blurPopView)
        self.view.addSubview(blurPopView)
        
        
        UIView.animate(withDuration: 0.3, animations: {()->Void in
            self.blurPopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))
        })
        
        
        theChildViewNeedToClose.append(grayLayer)
        theChildViewNeedToClose.append(blurPopView)
    }
    
    func getOrderDetails(OrderID:String,CustomID:String){
        let userAccountInfo = getCurrentUserInfo()
        let userID = userAccountInfo.value(forKey: "userid")
        let token = userAccountInfo.value(forKey: "token")
        let roletype = userAccountInfo.value(forKey: "roletype") as? String
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetailsDebug") as! String
        #else
            let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetails") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userId"] =  userID
        params["orderId"] =  OrderID
        params["customId"] =  CustomID
        params["roletype"] = roletype
        params["token"] = token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    self.orderDetail.removeAll()
                    
                    let userinfoItem = json["userinfo"].dictionaryObject! as NSDictionary
                    let orderaddinfoItem = json["orderaddinfo"].dictionaryObject! as NSDictionary
                    let ordersummaryItem = json["ordersummary"].dictionaryObject! as NSDictionary
                    let nicknameItem = json["nickname"].dictionaryObject! as NSDictionary
                    let useraddressItem = json["useraddress"].dictionaryObject! as NSDictionary
                    let designinfoItem = json["designinfo"].dictionaryObject! as NSDictionary
                    self.orderDetail.append(userinfoItem)
                    self.orderDetail.append(orderaddinfoItem)
                    self.orderDetail.append(ordersummaryItem)
                    self.orderDetail.append(nicknameItem)
                    self.orderDetail.append(useraddressItem)
                    self.orderDetail.append(designinfoItem)
                    
                    print("get order detail successed")
                }
                self.isOrderDetailsGets = true
            case false:
                print("get order detail failed")
                self.isOrderDetailsGets = true
            }
        }
    }
    
    @objc func setQuotePriceWeight(){
        let setParameterVC = SetParamtersViewController(roleType: roleType)
        self.present(setParameterVC, animated: true, completion: nil)
    }
    //关闭报价按钮
    @objc func closeQuotePriceView(){
        UIView.animate(withDuration: 0.3, animations: {()->Void in
            for Closingviews in self.theChildViewNeedToClose{
                Closingviews.transform = CGAffineTransform(translationX: 0, y: (UIScreen.main.bounds.height))
            }
        },completion:{
            Void in
            for childViews in self.theChildViewNeedToClose{
                childViews.removeFromSuperview()
                if childViews.isEqual(self.blurPopView){
                    for quotePriveSubViews in self.blurPopView.subviews{
                        quotePriveSubViews.removeFromSuperview()
                    }
                }
            }
            self.isblurPopViewPresenting = false
            if self.messagesList.count == 0{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    //点击报价按钮
    @objc func confirmQuotePriceBtnClicked(){
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
        }else{
                
            //获取用户信息
            let userInfos = getCurrentUserInfo()
            let roletype = userInfos.value(forKey: "roletype") as? String
            let userid = userInfos.value(forKey: "userid") as? String
            let token = userInfos.value(forKey: "token") as? String
            
            //获取订单信息
            let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
            let customID = orderinfoObject?.value(forKey: "customid") as? String
            let orderid = orderinfoObject?.value(forKey: "orderid") as? String
            var deadline = 0
            
            if orderinfoObject?.value(forKey: "deadline") as? Int == nil{
                deadline = 0
            }else{
                deadline = orderinfoObject?.value(forKey: "deadline") as! Int
            }
            if (deadline < Int(produceTimeCostTextField.text!)!)&&deadline != 0{
                greyLayerPrompt.show(text: "订单生产周期超过预期")
                //return
            }
            //获取报价信息
            let currentValueOfQuotePrice = quotePriceSlideBar.value
            //获取列表
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
            //定义请求参数
            let params:NSMutableDictionary = NSMutableDictionary()
            params["userId"] = userid
            params["roleType"] = roletype
            params["token"] = token
            params["customid"] = customID
            params["orderid"] = orderid
            params["returnprice"] = Int(currentValueOfQuotePrice)//String(format: "%.2f", currentValueOfQuotePrice)
            params["productioncycle"] = produceTimeCostTextField.text
            params["commandcode"] = 141
            
            var requestUrl:String = ""
            if roletype == "3" {
                #if DEBUG
                    requestUrl = apiAddresses.value(forKey: "quotePriceDebug") as! String
                #else
                    requestUrl = apiAddresses.value(forKey: "quotePrice") as! String
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
                            print("报价成功")
                            greyLayerPrompt.show(text: "报价成功")
                            self.closeQuotePriceView()
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
                    print("处理失败")
                    greyLayerPrompt.show(text: "报价失败,请重试")
                }
            }
            
        }
        print("报价按钮点击了")
        
    }
    @objc func quotePriceSliderBarValueChanged(_ slider:UISlider){
        quotePriceWeight = getQuotePriceWeight()
        currentValueOnSliderTextField.text = "\(Int(slider.value/Float(quotePriceWeight))*quotePriceWeight).00"
    }
    
    @objc func confirmAcceptDesignBtnClicked(){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        //获取订单信息
        let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
        let customID = orderinfoObject?.value(forKey: "customid") as? String
        let orderID = orderinfoObject?.value(forKey: "orderid") as? String

        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["orderid"] = orderID
        params["customid"] = customID
        params["isreceive"] = 1
        params["commandcode"] = 143
        
        
        var requestUrl:String = ""
        if roletype == "2" {
            #if DEBUG
                requestUrl = apiAddresses.value(forKey: "acceptDesignDebug") as! String
            #else
                requestUrl = apiAddresses.value(forKey: "acceptDesign") as! String
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
                        print("接受设计成功")
                        greyLayerPrompt.show(text: "接受设计成功")
                        self.closeQuotePriceView()
                        self.getMessageList()
                    }else{
                        print("接受失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "接受设计失败，请重试")
            }
        }
        print("接受设计按钮点击了")
        
    }
    // 输入框的值发生变化
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentValueOnSliderTextField.resignFirstResponder()
        produceTimeCostTextField.resignFirstResponder()
        if textField.isEqual(currentValueOnSliderTextField){
            if currentValueOnSliderTextField.text == ""{
                currentValueOnSliderTextField.text = "0.00"
            }
            var sliderValue = currentValueOnSliderTextField.text
                
            if Float(sliderValue as! String)! > quotePriceSlideBar.maximumValue {
                quotePriceSlideBar.maximumValue = Float(sliderValue as! String)!
            }
            quotePriceSlideBar.setValue(Float(sliderValue as! String)!, animated: true)
            quotePriceSlideBarRightLabel.text = "¥\(quotePriceSlideBar.maximumValue)0"
            quotePriceSlideBarMidLabel.text = "¥\(quotePriceSlideBar.maximumValue/2)0"
            quotePriceSlideBarLeftLabel.text = "¥0.00"
        }else{
           print("工期完成输入")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        textField.inputAccessoryView = topView
        return true
    }
    
    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        if currentValueOnSliderTextField.isFirstResponder{
            //界面偏移动画
            //UIScreen.main.bounds.height
            UIView.animate(withDuration: duration, animations: { ()->Void in
                self.blurPopView.transform = CGAffineTransform(translationX: 0, y:-(UIScreen.main.bounds.height + 130)) //-(height+300)+200
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
        
        if currentValueOnSliderTextField.isFirstResponder {
            UIView.animate(withDuration: duration, animations: {()->Void in
                self.blurPopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))// -(height-35)+200  -632
            })
        }
    }
    //创建毛玻璃效果
    func showBlurEffect(text:String) -> UIVisualEffectView {
        //创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height )
        let label = UILabel(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 100))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.black
        blurView.contentView.addSubview(label)
        // blurView.contentView.addSubview(closeBtn)
        return blurView
    }
    
    @objc func confirmAcceptProduceBtnClicked(){
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        //获取订单信息
        let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
        let customID = orderinfoObject?.value(forKey: "customid") as? String
        let orderID = orderinfoObject?.value(forKey: "orderid") as? String
        let goodsID = orderinfoObject?.value(forKey: "goodsid") as? String
        
        //获取订单信息
        var deadline = 0
        
        if orderinfoObject?.value(forKey: "deadline") as? Int == nil{
            deadline = 0
        }else{
            deadline = orderinfoObject?.value(forKey: "deadline") as! Int
        }
        
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
            return
        }else{
            if (deadline < Int(produceTimeCostTextField.text!)!) && deadline != 0{
                greyLayerPrompt.show(text: "客户要求工期为\(deadline)天以内，请修改生产周期")
                return
            }
            
        }
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["orderid"] = orderID
        params["customid"] = customID
        params["goodsid"] = goodsID
        params["isreceive"] = 1
        params["commandcode"] = 171
        
        
        var requestUrl:String = ""
        if roletype == "3" {
            #if DEBUG
                requestUrl = apiAddresses.value(forKey: "acceptProduceDebug") as! String
            #else
                requestUrl = apiAddresses.value(forKey: "acceptProduce") as! String
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
                        print("接受生产成功")
                        greyLayerPrompt.show(text: "接受生产成功")
                        self.closeQuotePriceView()
                    }else{
                        print("接受失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "接受生产失败，请重试")
            }
        }
        print("接受生产按钮点击了")
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
