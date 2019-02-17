//
//  StatisticOrderListViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/24.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class StatisticOrderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statisticOrderListTableViewCell.customCell(tableView: statisticOrderListTableView)
        cell.backgroundColor = UIColor.backgroundColors(color: .clear)
        
        
        let statusObjects = systemParam[1] as! NSDictionary
        
        let orderInfoObjects = orderListDic[indexPath.row] as NSDictionary
        
        //订单状态
        
        let inquryStatusObject = statusObjects.value(forKey: "inquiryStatus") as! NSArray
        let produceStatusObject = statusObjects.value(forKey: "produceStatus") as! NSArray
        let designStatusObject = statusObjects.value(forKey: "designStatus") as! NSArray
        
        for item in inquryStatusObject{
            if ((item as! NSDictionary).value(forKey: "code") as! Int) == (orderInfoObjects.value(forKey: "inquiry_status") as! Int){
                cell.inquryStatusLabel.text = (item as! NSDictionary).value(forKey: "servicerTag") as! String
            }
        }
        
        if orderInfoObjects.value(forKey: "produce_status") as! Int == 0 {
            cell.produceStatusLabel.text = "未付款"
        }else{
            for item in produceStatusObject{
                if ((item as! NSDictionary).value(forKey: "code") as! Int) == (orderInfoObjects.value(forKey: "produce_status") as! Int){
                    cell.produceStatusLabel.text = (item as! NSDictionary).value(forKey: "servicerTag") as! String
                }
            }
        }
        
        for item in designStatusObject{
            if ((item as! NSDictionary).value(forKey: "code") as! Int) == (orderInfoObjects.value(forKey: "design_status") as! Int){
                cell.designStatusLabel.text = (item as! NSDictionary).value(forKey: "servicerTag") as! String
            }
        }
        //订单号
        cell.orderIDLabel.text = "订单号 \(orderInfoObjects.value(forKey: "orderid")!)"
        //产品品类 材质
        cell.productTypeAndMaterialLabel.text = "\(orderInfoObjects.value(forKey: "goodsclass") as! String) \(orderInfoObjects.value(forKey: "material") as! String)"
        //生产工艺
        var technologyString = "无工艺参数"
        
        if orderInfoObjects.value(forKey: "model") as! String != "无" {
            technologyString = orderInfoObjects.value(forKey: "model") as! String
        }
        
        if orderInfoObjects.value(forKey: "technology") as! String != "无"{
            if technologyString == "无工艺参数" {
                technologyString = orderInfoObjects.value(forKey: "technology") as! String
            }else{
                technologyString += orderInfoObjects.value(forKey: "technology") as! String
            }
        }
        if orderInfoObjects.value(forKey: "color") as! String != "无" {
            if technologyString == "无工艺参数" {
                technologyString = orderInfoObjects.value(forKey: "color") as! String
            }else{
                technologyString += orderInfoObjects.value(forKey: "color") as! String
            }
        }
        
        cell.produceParasLabel.text = technologyString
        //产品尺寸
        var produceSizeValue = ""
        if orderInfoObjects.value(forKey: "length") as? NSNumber != nil {
            let lengthString =  "\(orderInfoObjects.value(forKey: "length") as! NSNumber)"
            if lengthString.contains("."){
                produceSizeValue = produceSizeValue + "\(orderInfoObjects.value(forKey: "length")as! Double)"
            }else{
                produceSizeValue = produceSizeValue + "\(orderInfoObjects.value(forKey: "length")as! NSNumber)"
            }
        }else{
            produceSizeValue = ""
        }
        
        if orderInfoObjects.value(forKey: "width") as? NSNumber != nil {
            let widthString =  "\(orderInfoObjects.value(forKey: "width") as! NSNumber)"
            if widthString.contains("."){
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! Double)"
            }else{
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
            }
            //produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
            
        }else{
            produceSizeValue = produceSizeValue + "x "
        }
        if orderInfoObjects.value(forKey: "height") as? NSNumber != nil {
            
            let heightString =  "\(orderInfoObjects.value(forKey: "height") as! NSNumber)"
            if heightString.contains("."){
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! Double)(mm)"
            }else{
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! NSNumber)(mm)"
            }
        }else{
            produceSizeValue = produceSizeValue + "x (mm)"
        }
        cell.sizeLabel.text = produceSizeValue
        //数量
        cell.amountLabel.text = "x\(orderInfoObjects.value(forKey: "number") as! Int)"
        //客服
        cell.customerServiceLabel.text = "客服:\(orderInfoObjects.value(forKey: "servicer_name") as! String)"
        if orderInfoObjects.value(forKey: "designer_name") as? String == "" || orderInfoObjects.value(forKey: "designer_name") as? String == nil{
            cell.designerLabel.text = "设计:暂无"
        }else{
            let orignalText = NSMutableAttributedString(string: "设计(¥\(orderInfoObjects.value(forKey: "design_price") as! Double)0):\(orderInfoObjects.value(forKey: "designer_name") as! String)")
                //上次报价
            let range = orignalText.string.range(of: "¥\(orderInfoObjects.value(forKey: "design_price") as! Double)0")
            let nsRange = orignalText.string.nsRange(from: range!)
            orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: nsRange)
            cell.designerLabel.attributedText = orignalText
        }
        if orderInfoObjects.value(forKey: "workshop_name") as? String == "" || orderInfoObjects.value(forKey: "workshop_name") as? String == nil{
            cell.factoryLabel.text = "车间:暂无"
        }else{
            cell.factoryLabel.text = "车间:\(orderInfoObjects.value(forKey: "workshop_name") as! String)"
        }
        if orderInfoObjects.value(forKey: "manager_name") as? String == "" || orderInfoObjects.value(forKey: "manager_name") as? String == nil{
            cell.managerAcountLabel.text = ""
        }else{
            cell.managerAcountLabel.text = "跟单:\(orderInfoObjects.value(forKey: "manager_name") as! String)"
        }
        
        var priceString = "¥-"
        if orderInfoObjects.value(forKey: "order_price") as? String == "" || orderInfoObjects.value(forKey: "order_price") as? String == nil{
            priceString = "¥-"
        }else{
            priceString = "¥\(orderInfoObjects.value(forKey: "order_price")!)"
            //priceString = "订单金额: ¥999,000.00"
        }

        let orignalText = NSMutableAttributedString(string: priceString)
        cell.priceLabel.attributedText = orignalText
        
//        var priceString = "订单金额: ¥-"
//        if orderInfoObjects.value(forKey: "order_price") as? String == "" || orderInfoObjects.value(forKey: "order_price") as? String == nil{
//            priceString = "订单金额: ¥-"
//        }else{
//            priceString = "订单金额: ¥\(orderInfoObjects.value(forKey: "order_price")!)"
//            //priceString = "订单金额: ¥999,000.00"
//        }
//
//        let orignalText = NSMutableAttributedString(string: priceString)
//        //上次报价
//        let range = orignalText.string.range(of: "订单金额: ")
//        let nsRange = orignalText.string.nsRange(from: range!)
//    orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 9)], range: nsRange)
//        cell.priceLabel.attributedText = orignalText
        
//        if orderInfoObjects.value(forKey: "order_price") as? String == "" || orderInfoObjects.value(forKey: "order_price") as? String == nil{
//            cell.priceLabel.text  = "¥-"
//        }else{
//            cell.priceLabel.text = "¥\(orderInfoObjects.value(forKey: "order_price")!)"
//        }
//
        cell.createTimeLabel.text = "\(orderInfoObjects.value(forKey: "create_time")!)"
        
//
//        let orignalText = NSMutableAttributedString(string: "上次报价/工期: \(lastQuotePrice) / - 天")
//        //上次报价
//        let range = orignalText.string.range(of: lastQuotePrice)
//        let nsRange = orignalText.string.nsRange(from: range!)
//        orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: nsRange)
//        quotePriceAtLastLabel.attributedText = orignalText
//
        //设置订单图片
        //设置图片
        if orderImages.keys.contains(indexPath.row) {
            cell.produceImage.image = (orderImages as NSDictionary).object(forKey: indexPath.row) as! UIImage// value(forKey: "\(indexPath.row)") as! UIImage//orderImages[indexPath.row]
        }else{
            cell.produceImage.image = UIImage(named: "defualt-design-pic-loading")
        }

        //添加长按复制
        cell.backGroundView.isUserInteractionEnabled = true
        cell.backGroundView.tag = indexPath.row
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHander(_:)))
      
        cell.backGroundView.addGestureRecognizer(longPressGesture)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206.0
    }
    //导航栏
    let navigationBarInMessageList:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
    //
    lazy var orderListDic:[NSDictionary] = []
    //订单图
    var orderImages:[Int:UIImage] = [:]
    //图片下载队列
    let queue = OperationQueue()
    var testQueue = 0
    
    var isDataLoading = false
    var _categoryListType:statisticCategoryListType = .newCreateOrder
    var _currentPage = 1 //当前页
    var _totalPageCount = 1//总页数
    var timeInterval_from:TimeInterval = 0
    var timeInterval_to:TimeInterval = 0
    
    var systemParam:[AnyObject] = []
    var downloadURLHeader:String = ""
    var downloadURLHeaderForThumbnail:String = ""
    var theViewNeedToBeKill:[UIView] = []
    
    //在线人员列表
    lazy var statisticOrderListTableView:UITableView = {
        //height -77 调好的
        //var heightOfTableView = UIScreen.main.bounds.height - 62
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (64 + heightChangeForiPhoneXFromTop)), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempTableView.isScrollEnabled = true
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 100
        tempTableView.separatorStyle = .singleLine//.none
        tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel3)
        return tempTableView
    }()
    
    
    init(with categoryListType:statisticCategoryListType,startTime:TimeInterval,endTime:TimeInterval){
        super.init(nibName: nil, bundle: nil)
        self._categoryListType = categoryListType
        self.timeInterval_from = startTime
        self.timeInterval_to = endTime
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

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
        switch _categoryListType {
        case .newCreateOrder:
            titleLabel.text = "新建订单列表"
        case .dealOrder:
            titleLabel.text = "成交订单列表"
        case .bargainingOrder:
            titleLabel.text = "议价中订单列表"
        case .waitForDesignOrder:
            titleLabel.text = "待设计订单列表"
        case .designingOrder:
            titleLabel.text = "设计中订单列表"
        case .designComfirmed:
            titleLabel.text = "已定稿订单列表"
        case .waitForProduce:
            titleLabel.text = "待生产订单列表"
        case .waitForQuotePrice:
            titleLabel.text = "待报价订单列表"
        case .waitForBargain:
            titleLabel.text = "待议价订单列表"
        case .waitForBid:
            titleLabel.text = "待竞价订单列表"
        case .producingOrder:
            titleLabel.text = "生产中订单列表"
        case .waitForDelivery:
            titleLabel.text = "待发货订单列表"
        default:
            titleLabel.text = "新建订单列表"
        }
        
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
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        //灰层
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        //添加下拉刷新
        //addPullToRefresh(animator: header)
        statisticOrderListTableView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        
        //添加上拉加载
        statisticOrderListTableView.es.addInfiniteScrolling {
            [weak self] in
            self?.loadMore()
        }
        systemParam = getSystemParasFromPlist()
        
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        //        #if DEBUG
        //            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        //        #else
        //            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        //        #endif
        #if DEBUG
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnailDebug") as! String
        #else
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnail") as! String
        #endif
        
        loadListData(with: _categoryListType, page: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .backgroundColors(color: .red))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .clear)
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    
    @objc func longPressGestureHander(_ gestureRecognizer:UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let index = gestureRecognizer.view!.tag
            let orderInfosObject = self.orderListDic[index] as NSDictionary
            UIPasteboard.general.string = orderInfosObject.value(forKey: "orderid") as! String
            greyLayerPrompt.show(text: "订单号复制成功")
        }else{
            print("pressEnded")
        }
    }
    
    //点击返回
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }

    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self._currentPage = 1
            //  self._onlineStatusList.removeAll()
            self.loadListData(with: self._categoryListType , page: self._currentPage)
            self.statisticOrderListTableView.es.stopPullToRefresh()
            //self.loadOrderDataFromServer(pages:self.page)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self._currentPage += 1
            if self._currentPage <= self._totalPageCount{
                self.loadListData(with: self._categoryListType, page: self._currentPage)
                self.statisticOrderListTableView.es.stopLoadingMore()
            }else{
                self.statisticOrderListTableView.es.noticeNoMoreData()
            }
        }
    }
    
    
    //下载订单图片
    func downloadOrderImages(){
        testQueue += 1
        let downloadImageOpt = BlockOperation{
            let temp = self.testQueue
            let rangeMax = (self.orderListDic.count <= self._currentPage * 10) ? self.orderListDic.count : (self._currentPage * 10)
            for index in (self._currentPage - 1)*10 ..< rangeMax{
                // print("index of range is \(index) and rangMax = \(rangeMax), temp = \(temp)")
                if self.orderListDic.count < index{
                    return
                }
                let orderInfoObjects = self.orderListDic[index] as NSDictionary
               // let orderInfoObjects = self.orderArray[index]
                //  let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
                let orderid = orderInfoObjects.value(forKey: "orderid") as! String
                if orderid == "201793925646222"{
                    print("hellp")
                }
                if orderInfoObjects.value(forKey: "small_goods_image") as? String == nil || orderInfoObjects.value(forKey: "small_goods_image") as? String == ""{ // 图片字段为空
                    self.orderImages.updateValue(UIImage(named:"defualt-design-pic")!, forKey: index)
                    //self.orderImages.append(UIImage(named:"defualt-design-pic")!)
                }else{
                    let imageURLString:String = "\(self.downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "small_goods_image") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                        let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        self.orderImages.updateValue(image!, forKey: index)
                    }catch{
                        let imageURLString:String = "\(self.downloadURLHeader)\(orderInfoObjects.value(forKey: "small_goods_image") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            let oImage = UIImage.gif(data:data)
                            let image = UIImage(data: compressionImage(with: oImage!) as Data)
                            self.orderImages.updateValue(image!, forKey: index)
                        }catch{
                            print(error)
                            self.orderImages.updateValue(UIImage(named:"defualt-design-pic")!, forKey: index)
                        }
                        print("无缩略图")
                    }
                }
                
                
//                if orderInfoObjects.value(forKey: "small_goods_image") as? String != nil && orderInfoObjects.value(forKey: "small_goods_image") as? String != "" {
//                    let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "small_goods_image") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let oImage = UIImage.gif(data:data)
//                        let image = UIImage(data: compressionImage(with: oImage!) as Data)
//                        DispatchQueue.main.async {
//                            cell.produceImage.image = image
//                        }
//
//                    }catch{
//                        print(error)
//                        DispatchQueue.main.async {
//                            cell.produceImage.image = UIImage(named:"defualt-design-pic")//  UIImage(image:image)
//                        }
//                        //原图也下载失败
//                    }
//                    print("无缩略图")
//                }else{
//                    DispatchQueue.main.async {
//                        cell.produceImage.image = UIImage(named:"defualt-design-pic")//  UIImage(image:image)
//                    }
//                }
//
                //图片下载完了,重新加载表格
                OperationQueue.main.addOperation({
                    self.statisticOrderListTableView.reloadData()
                })
                
            }
        }
        queue.cancelAllOperations()
        queue.addOperation(downloadImageOpt)
    }
    
    func loadListData(with categoryType:statisticCategoryListType, page:Int){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        
        let startTime = timeInterval_from// (Int(now.timeIntervalSince1970) - 2592000)*1000 //30天前   51840000
        let endTime = timeInterval_to//getEndDateTimeOfToday() * 1000
        
        let startDate = Date(timeIntervalSince1970: startTime)
        let endDate = Date(timeIntervalSince1970: endTime)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = .current
        
        params["startTime"] = formatter.string(from: startDate)
        params["endTime"] = formatter.string(from: endDate)
        params["page"] = page
        params["pageSize"] = 10
        params["endTime"] = formatter.string(from: endDate)
        header["token"] = token
        print("startTime \(formatter.string(from: startDate))")
        print("endTime \(formatter.string(from: endDate))")
        
        switch categoryType {
        case .newCreateOrder:
            params["categoryList"] = "newCreateOrder"
        case .dealOrder:
            params["categoryList"] = "dealOrder"
        case .bargainingOrder:
            params["categoryList"] = "bargainingOrder"
        case .waitForDesignOrder:
            params["categoryList"] = "waitForDesignOrder"
        case .designingOrder:
            params["categoryList"] = "designingOrder"
        case .designComfirmed:
            params["categoryList"] = "designComfirmed"
        case .waitForQuotePrice:
            params["categoryList"] = "waitForQuotePrice"
        case .waitForBargain:
            params["categoryList"] = "waitForBargain"
        case .waitForBid:
            params["categoryList"] = "waitForBid"
        case .waitForProduce:
            params["categoryList"] = "waitForProduce"
        case .producingOrder:
            params["categoryList"] = "producingOrder"
        case .waitForDelivery:
            params["categoryList"] = "waitForDelivery"
        default:
            params["categoryList"] = "newCreateOrder"
        }
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "statisticOrderListAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "statisticOrderListAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        self._totalPageCount = json["totalCount"].int!/10
                        if page == 1{
                            self.orderListDic.removeAll()
                            self.orderImages.removeAll()
                        }
                        for item in json["data"].array!{
                            let dicItem = item.dictionaryObject! as NSDictionary
                            self.orderListDic.append(dicItem)
                        }
                        if self.orderListDic.count == 0{
                            self.emytyAreaShowingLabel(withRetry: true)
                        }else{
                            self.view.addSubview(self.statisticOrderListTableView)
                            self.downloadOrderImages()
                            self.statisticOrderListTableView.reloadData()
                        }
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                        self.orderListDic.removeAll()
                        self.emytyAreaShowingLabel(withRetry: true)
                        self.statisticOrderListTableView.removeFromSuperview()
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
                self.orderListDic.removeAll()
                self.emytyAreaShowingLabel(withRetry: true)
                self.statisticOrderListTableView.removeFromSuperview()
            }
             self.statisticOrderListTableView.es.stopPullToRefresh()
        }
        
    }
    
    @objc func retryBtnInViewClicked(){
        orderListDic.removeAll()
        loadListData(with: _categoryListType, page: 1)
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        for item in theViewNeedToBeKill{
            item.removeFromSuperview()
        }
        //什么都没有
        let sizeOfNothing:Int = 180
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 300, width: sizeOfNothing, height: sizeOfNothing))
        theViewNeedToBeKill.append(nothingToShow)
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 120 , width: 200, height: 44))
        nothingToSHowLabel.text = "空空如也..."
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.tag = 901
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        theViewNeedToBeKill.append(nothingToSHowLabel)
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        nothingToShow.tag = 903
        self.view.addSubview(nothingToShow)
        if withRetry {
            let retryBtn:UIButton = UIButton.init(type: .system)
            retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 + 50, width: 150, height: 44)
            retryBtn.backgroundColor = UIColor.white
            retryBtn.layer.cornerRadius = 5
            retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
            retryBtn.layer.borderWidth = 1
            retryBtn.tag = 902
            retryBtn.setTitle("再试试", for: .normal)
            retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
            retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
            theViewNeedToBeKill.append(retryBtn)
            self.view.addSubview(retryBtn)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
