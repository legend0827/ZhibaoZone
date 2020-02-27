//
//  AllOrdersViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AllOrdersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    //定义订单列表的类型
    var _orderlistType:orderListCategoryType = .allOrderCategory
    

    init(orderlistType:orderListCategoryType) {
        super.init(nibName: nil, bundle: nil)
        _orderlistType = orderlistType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    //是否正在进行网络请求
    var isRequesting = false // false
    
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    //用户角色信息
    var _userid:String?
    var _token:String?
    
    var _roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    //测试用
    var orderList:[String] = []
    var page: Int = 1
    var totalPageCount:Int = 1
    var selectorParamters = [Int:String]()
    //图片下载队列
    let queue = OperationQueue()
    var testQueue = 0
    
    //订单图
    var orderImages:[Int:UIImage] = [:]
   
    let heightHeader:CGFloat = 40.0
    
    //状态标志栏
    var statusListView:[Int:[UIImageView]] = [:]
    
    //选择的订单的index
    var selectedIndex = 0
    //加载中的动画集合
    var theLoadingViewNeedsToBeKill:[UIView] = []
    
    let CELL_ID = "cell_id";
    lazy var scrollView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - 140 - heightChangeForiPhoneXFromBottom))
        tempScrollView.contentSize = CGSize(width: kWidth, height: kHight - 140 - heightChangeForiPhoneXFromBottom) //40
        tempScrollView.backgroundColor = UIColor.lineColors(color: .grayLevel5)
        tempScrollView.delegate = self
        return tempScrollView
    }()
    
    lazy var AllOrdersCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(kWidth - 50)/2,height: (kWidth - 50)/2 + 92)  //设置item尺寸
        layout.minimumLineSpacing = 5  //上下间隔
        layout.minimumInteritemSpacing = 5 //左右间隔
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)            //section四周的缩进
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - 180 - heightChangeForiPhoneXFromBottom ),collectionViewLayout:layout) // -180
        tempCollectionView.backgroundColor =  UIColor.lineColors(color: .grayLevel5)// UIColor.backgroundColors(color: .white)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.isScrollEnabled = true
        
      //  tempCollectionView.isScrollEnabled = true // 允许拖动
        tempCollectionView.register(OrdersCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        // 注册一个headView
        tempCollectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        return tempCollectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cellidentifier = NSString.init(format: "cell%ld%ld", indexPath.section,indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! OrdersCollectionViewCell
        
        let orderInfoObjects = orderArray[indexPath.row]
       // let dictionaryObjectInOrderArray = orderArray[indexPath.row]
      //  let statusObjects = systemParam[1] as! NSDictionary
        let productObjects = systemParam[0] as! NSDictionary
       // let commandsObjects = systemParam[2] as! NSArray
        
        let commandsCode = orderInfoObjects.value(forKey: "command") as! String

        //设置图片
        if orderImages.keys.contains(indexPath.row) {
            cell.orderCellImageView.image = (orderImages as NSDictionary).object(forKey: indexPath.row) as! UIImage// value(forKey: "\(indexPath.row)") as! UIImage//orderImages[indexPath.row]
        }else{
            cell.orderCellImageView.image = UIImage(named: "defualt-design-pic-loading")
        }
        //产品类型
        let goodsClassObject = productObjects.value(forKey: "goodsClass") as! NSArray
        let productType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "goodsClass") as! String, In: goodsClassObject, By: "goodsClass")
        //材质
        let materailObject = productObjects.value(forKey: "material") as! NSArray
        let materialType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "material") as! String, In: materailObject, By: "material")
        
        cell.productTypeAndMaterialInCell.text = productType + " " + materialType
        
        //产品数量
        cell.productQuantityInCell.text = "\(orderInfoObjects.value(forKey: "number") as! Int)"
        //设置产品尺寸
        var sizeString:String = ""
        //长
        print(orderInfoObjects.value(forKey: "orderid") as! String)
        if orderInfoObjects.value(forKey: "length") as? NSNumber != nil {
            
            let lengthString =  "\(orderInfoObjects.value(forKey: "length") as! NSNumber)"
            if lengthString.contains("."){
                sizeString += "\(orderInfoObjects.value(forKey: "length")as! Double)"
            }else{
                sizeString += "\(orderInfoObjects.value(forKey: "length")as! NSNumber)"
            }
            
           // sizeString += "\(orderInfoObjects.value(forKey: "length")as! NSNumber)"
        }
        //宽
        if orderInfoObjects.value(forKey: "width") as? NSNumber != nil {
            let widthString =  "\(orderInfoObjects.value(forKey: "width") as! NSNumber)"
            if widthString.contains("."){
                sizeString += "x\(orderInfoObjects.value(forKey: "width")as! Double)"
            }else{
                sizeString += "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
            }
            
           // sizeString += "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
        }else{
            sizeString += "x "
        }
        //高
        if orderInfoObjects.value(forKey: "height") as? NSNumber != nil {
            let heightString =  "\(orderInfoObjects.value(forKey: "height") as! NSNumber)"
            if heightString.contains("."){
                sizeString += "x\(orderInfoObjects.value(forKey: "height")as! Double)(mm)"
            }else{
                sizeString += "x\(orderInfoObjects.value(forKey: "height")as! NSNumber)(mm)"
            }
            
           // sizeString += "x\(orderInfoObjects.value(forKey: "height")as! NSNumber)(mm)"
        }else{
            sizeString += "x (mm)"
        }
        cell.productSize.text = sizeString
        
        
        cell.acceptDesignBtnInCell.isHidden = true
        cell.acceptProduceBtnInCell.isHidden = true
        cell.quotePriceBtnInCell.isHidden = true
        cell.biddingBtnInCell.isHidden = true
        cell.shippingBtnInCell.isHidden = true
        cell.takePhotoForProductBtnInCell.isHidden = true
        cell.designRequiresBtnInCell.isHidden = true
        cell.modifyRequiresBtnInCell.isHidden = true
        cell.dealBargainBtnInCell.isHidden = true
        
        cell.biddingBtnInCell.addTarget(self, action: #selector(quotePriceBtnClicked), for: .touchUpInside)
        cell.acceptDesignBtnInCell.addTarget(self, action: #selector(acceptDesignBtnClicked), for: .touchUpInside)
        cell.quotePriceBtnInCell.addTarget(self, action: #selector(quotePriceBtnClicked), for: .touchUpInside)
        cell.acceptProduceBtnInCell.addTarget(self, action: #selector(acceptProduceBtnClicked), for: .touchUpInside)
        cell.shippingBtnInCell.addTarget(self, action: #selector(shippingBtnClicked), for: .touchUpInside)
        cell.takePhotoForProductBtnInCell.addTarget(self, action: #selector(takePhotoBtnCliced), for: .touchUpInside)
        cell.designRequiresBtnInCell.addTarget(self, action: #selector(designRequireBtnClicked), for: .touchUpInside)
        cell.modifyRequiresBtnInCell.addTarget(self, action: #selector(modifyRequireBtnClicked), for: .touchUpInside)
        cell.dealBargainBtnInCell.addTarget(self, action: #selector(dealBargainBtnClicked), for: .touchUpInside)
        
        cell.biddingBtnInCell.tag = indexPath.row
        cell.acceptDesignBtnInCell.tag = indexPath.row
        cell.quotePriceBtnInCell.tag = indexPath.row
        cell.acceptProduceBtnInCell.tag = indexPath.row
        cell.shippingBtnInCell.tag = indexPath.row
        cell.takePhotoForProductBtnInCell.tag = indexPath.row
        cell.designRequiresBtnInCell.tag = indexPath.row
        cell.modifyRequiresBtnInCell.tag = indexPath.row
        cell.dealBargainBtnInCell.tag = indexPath.row
        
        if self.statusListView.keys.contains(indexPath.row){
            for subview in cell.orderCellView.subviews{
                if subview.isKind(of: UIImageView.self){
                    if (subview as! UIImageView).image == UIImage(named: "renewordericonimg") || (subview as! UIImageView).image == UIImage(named: "barginordericonimg") || (subview as! UIImageView).image == UIImage(named: "overperoidicon") || (subview as! UIImageView).image == UIImage(named: "issuesubmittediconimg"){
                        subview.removeFromSuperview()
                    }
                }
            }
            for item in (self.statusListView as NSDictionary).object(forKey: indexPath.row) as! [UIImageView]{
                cell.orderCellView.addSubview(item)
                cell.orderCellView.bringSubview(toFront: item)
                //cell.bringSubview(toFront: item)
               // print("item as \(item) added to \(indexPath.row)")
            }
            
//            for item in self.statusListView{
//                print("1")
//            }
            updateOrderStatueIcon(iconList: (self.statusListView as NSDictionary).object(forKey: indexPath.row) as! [UIImageView])
        }
        
        
        switch _roleType {
        case 1:
            print("RoleType 为 1")
        case 2:
            
            //显示接受设计按钮
            if (commandsCode.contains("ACCEPT_DESIGN")){//显示报价按钮
                cell.acceptDesignBtnInCell.isHidden = false
                cell.designRequiresBtnInCell.isHidden = true
                cell.modifyRequiresBtnInCell.isHidden = true
            }else if (commandsCode.contains("EDIT_DESIGN")) || (commandsCode.contains("COMMIT_DESIGN")){
                cell.acceptDesignBtnInCell.isHidden = true
                cell.designRequiresBtnInCell.isHidden = true
                cell.modifyRequiresBtnInCell.isHidden = false
            }
            
            //设置设计费显示
            if orderInfoObjects.value(forKey: "designPrice") as? Float == nil{
                cell.priceLabel.text = "¥8.0"
            }else{
                cell.priceLabel.text = "¥\(orderInfoObjects.value(forKey: "designPrice") as! Float)0"
            }
        case 3: // 角色为车间
            //查看订单是否需要展示报价按钮
            
            if (commandsCode.contains("QUOTE")){//显示报价按钮
                cell.quotePriceBtnInCell.isHidden = false
            }else{
                cell.quotePriceBtnInCell.isHidden = true
            }
            
            if (commandsCode.contains("BARGIN_FEEDBACK")){
                cell.dealBargainBtnInCell.isHidden = false
            }else{
                cell.dealBargainBtnInCell.isHidden = true
            }
            
            if (commandsCode.contains("BIDDING_FEEDBACK")){
                cell.biddingBtnInCell.isHidden = false
            }else{
                cell.biddingBtnInCell.isHidden = true
            }
            
            
            if (orderInfoObjects.value(forKey: "produceStatus") as! Int) <= 1{
                //显示上次报价
                if (orderInfoObjects.value(forKey: "lastQuote") as! Double) == 0.0{
                    //上次未报价
                    cell.priceLabel.text = "未报价"
                }else{
                    //有上次报价，显示上次报价
                    cell.priceLabel.text = "¥\(orderInfoObjects.value(forKey: "lastQuote") as! Double)"
                }
            }else{
                //显示生产费
                cell.priceLabel.text = "¥\(orderInfoObjects.value(forKey: "producePrice") as! NSNumber)"
            }
            
            // 接受生产按钮显示控制
            //订单状态为7表示需要接受生产
            if (commandsCode.contains("ACCEPT_PRODUCE")){//显示接受生产
                cell.acceptProduceBtnInCell.isHidden = false
            }else{
                cell.acceptProduceBtnInCell.isHidden = true
            }
            
            //订单在生产中，允许上传物流
            if (commandsCode.contains("MAIL")){//显示接受生产
                cell.shippingBtnInCell.isHidden = false
                cell.takePhotoForProductBtnInCell.isHidden = false
                cell.productTypeAndMaterialInCell.isHidden = true
                cell.orderIDValue.isHidden = false
                cell.productSizeLabel.isHidden = true
                cell.productQuantityInCellLabel.isHidden = true
                cell.orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as! String
                cell.productSize.isHidden = true
                cell.productQuantityInCell.isHidden = true
            }else{
               // cell.shippingBtnInCell.isHidden = true
                cell.orderIDValue.isHidden = true
                cell.productSize.isHidden = false
                cell.productTypeAndMaterialInCell.isHidden = false
                cell.productQuantityInCell.isHidden = false                
                cell.productTypeAndMaterialInCell.frame = CGRect(x: 10, y: cell.frame.width, width: 300, height: 20)
            }
            
            
            
           
//
//            if priceInfoObjects.value(forKey: "mindprice") as? Float != nil && priceInfoObjects.value(forKey: "mindprice") as? Float != 0.0{
//                if priceInfoObjects.value(forKey: "returnprice") as? Float != nil && priceInfoObjects.value(forKey: "returnprice") as? Float != 0.0{
//                    if priceInfoObjects.value(forKey: "returnprice") as! Float > priceInfoObjects.value(forKey: "mindprice") as! Float{
//                        cell.statusImageView.isHidden = false
//                    }else{
//                        cell.statusImageView.isHidden = true
//                    }
//                }else{
//                    cell.statusImageView.isHidden = true
//                }
//            }else{
//                cell.statusImageView.isHidden = true
//            }
//
        case 4:
            print("RoleType 为 4")
        default:
            print("RoleType 为 default")
        }
        
        return cell
    }
    
    //分区数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        systemParam = getSystemParasFromPlist()
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
        
        
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
        _userid = userInfos.value(forKey: "userid") as? String
        _token = userInfos.value(forKey: "token") as? String
        
        
//        if _orderlistType == .notQuotePriceYetOrderCategory || _orderlistType == .waitForDesignCategory{
//            StartLoadingAnimation()
//            DispatchQueue.global().async {
//                self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistType)
//            }
//
//        }else{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                self.StartLoadingAnimation()
//                DispatchQueue.global().async {
//                    self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistType)
//                }
//            }
//        }
       // self.view.addSubview(AllOrdersCollectionView)
        self.view.addSubview(scrollView)
        //添加下拉刷新
        AllOrdersCollectionView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        //添加上拉加载
        AllOrdersCollectionView.es.addInfiniteScrolling {
            [weak self] in
            self?.loadMore()
        }

    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page = 1
            self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistType)
        }
//        self.orderList.removeAll()
//        for i in 1..<70{
//            self.loadOrderDataFromServer(pages: i, categoryType: .notQuotePriceYetOrderCategory)
//            sleep(20)
//            print("执行\(i)次")
//            if i == 70{
//                print("order List\(self.orderList) ")
//
//            }
//        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page, categoryType: self._orderlistType)
                self.AllOrdersCollectionView.reloadData()
            }else{
                self.AllOrdersCollectionView.es.noticeNoMoreData()
                
            }
        }
    }
    
    func updateOrderStatueIcon(iconList:[UIImageView]){
        var firstX:CGFloat = 0.0
        var secondX:CGFloat = 0.0
        var thirdX:CGFloat = 0.0
        var fourthX:CGFloat = 0.0
        var firstGapX:CGFloat = 0.0
        var secondGapX:CGFloat = 0.0
        var thirdGapX:CGFloat = 0.0
        
        switch iconList.count {
        case 0,1,2:
            firstGapX = 0.0
            secondGapX = 0.0
            thirdGapX = 0.0
        case 3:
            firstGapX = 2.0
            secondGapX = 0.0
            thirdGapX = 0.0
        case 4:
            firstGapX = 2.0
            secondGapX = 2.0
            thirdGapX = 0.0
        case 5:
            firstGapX = 2.0
            secondGapX = 2.0
            thirdGapX = 2.0
        default:
            firstGapX = 0.0
            secondGapX = 0.0
        }
        for imageView in iconList{
            
            if imageView.image == UIImage(named: "renewordericonimg") {
                firstX = 26.0
                print("renew icon in list")
            }
            if imageView.image == UIImage(named: "barginordericonimg") {
                secondX = 26.0
                print("bargin order in list")
            }
            if imageView.image == UIImage(named: "overperoidicon") {
                thirdX = 34.0
                print("issue icon in list")
            }
            if imageView.image == UIImage(named: "issuesubmittediconimg"){
                fourthX = 54.0
                print("over Proid in list")
            }
        }
        
        for imageView in iconList{
            
            if imageView.image == UIImage(named: "renewordericonimg") {
                imageView.frame = CGRect(x: 10, y: 147, width: firstX, height: 15)
            }
            if imageView.image == UIImage(named: "barginordericonimg") {
                imageView.frame =  CGRect(x: 10 + firstX + firstGapX, y: 147, width: secondX, height: 15)
            }
            if imageView.image == UIImage(named: "overperoidicon"){
                imageView.frame =  CGRect(x: 10 + firstX + firstGapX + secondX + secondGapX, y: 147, width: thirdX, height: 15)
            }
            if imageView.image == UIImage(named: "issuesubmittediconimg") {
                imageView.frame =  CGRect(x: 10 + firstX + firstGapX + secondX + secondGapX + thirdX + thirdGapX, y: 147, width: fourthX, height: 15)//+ firstX + secondX + thirdX + firstGapX + secondGapX
                if iconList.count == 3{
                    print("11")
                }
            }
        }
        
        
        
    }
//    func exdispatchQueue(){
//        let serialQ = DispatchQueue(label: "getimage", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target:)
//    }
    func loadStatusImageViews(){
        DispatchQueue.main.async {
            let rangeMax = (self.orderArray.count <= self.page * 6) ? self.orderArray.count : (self.page * 6)
            for index in (self.page - 1)*6 ..< rangeMax{
                let orderInfoObjects = self.orderArray[index]
                
                //超工期
                let overPeriodStatusImageView:UIImageView = {
                    let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
                    tempImageView.image = UIImage(named: "overperoidicon")
                    return tempImageView
                }()
                //续订标志
                let renewOrderImageView:UIImageView = {
                    let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
                    tempImageView.image = UIImage(named: "renewordericonimg")
                    return tempImageView
                }()
                //竞价标志
                let barginOrderImageView:UIImageView = {
                    let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
                    tempImageView.image = UIImage(named: "barginordericonimg")
                    return tempImageView
                }()
                //问题已提交
                let issueSubmittedImageView:UIImageView = {
                    let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
                    tempImageView.image = UIImage(named: "issuesubmittediconimg")
                    return tempImageView
                }()
                
                //问题已提交
                let emptyImageView:UIImageView = {
                    let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
                    tempImageView.image = UIImage.init()
                    return tempImageView
                }()
                
                //插入空的状态View占位
                var tempStatusImageList:[UIImageView] = []
                tempStatusImageList.append(emptyImageView)
                
                if orderInfoObjects.value(forKey: "quoteStep") as? Int != nil{
                    if orderInfoObjects.value(forKey: "quoteStep") as! Int == 2{
                        tempStatusImageList.append(barginOrderImageView)
                    }
                }
                
                
                // tempStatusImageList.append(cell.renewOrderImageView)
              //  tempStatusImageList.append(barginOrderImageView)
                //tempStatusImageList.append(cell.issueSubmittedImageView)
                
                if orderInfoObjects.value(forKey: "problemFeedback") as! Int == 1{
                    tempStatusImageList.append(issueSubmittedImageView)
                }
                
                if orderInfoObjects.value(forKey: "isContinueOrder") as! Int == 1 || orderInfoObjects.value(forKey: "isContinueOrder") as! Int == 3 {
                    tempStatusImageList.append(renewOrderImageView)
                }
                
                //显示超工期
                var lastPeriod = 0
                var deadline = 0
                if orderInfoObjects.value(forKey: "userPeriod") as? Int == nil{
                    deadline = 0
                }else{
                    deadline = orderInfoObjects.value(forKey: "userPeriod") as! Int
                }
                if orderInfoObjects.value(forKey: "lastPeriod") as? Int == nil{
                    lastPeriod = 0
                }else{
                    lastPeriod = orderInfoObjects.value(forKey: "lastPeriod") as! Int
                }
                
                if (deadline < lastPeriod) && deadline != 0{
                    //超过工期
                    tempStatusImageList.append(overPeriodStatusImageView)
                    //return
                }
                self.statusListView.updateValue(tempStatusImageList, forKey: index)
            }
        }
    }
    
    //下载订单图片
    func downloadOrderImages(){
        testQueue += 1
        let downloadImageOpt = BlockOperation{
            let temp = self.testQueue
            let rangeMax = (self.orderArray.count <= self.page * 6) ? self.orderArray.count : (self.page * 6)
            for index in (self.page - 1)*6 ..< rangeMax{
               // print("index of range is \(index) and rangMax = \(rangeMax), temp = \(temp)")
                if self.orderArray.count < index{
                    return
                }
                let orderInfoObjects = self.orderArray[index]
              //  let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
                if orderInfoObjects.value(forKey: "smallGoodsImage") as? String == nil || orderInfoObjects.value(forKey: "smallGoodsImage") as? String == ""{ // 图片字段为空
                    self.orderImages.updateValue(UIImage(named:"defualt-design-pic")!, forKey: index)
                    //self.orderImages.append(UIImage(named:"defualt-design-pic")!)
                }else{
                    let imageURLString:String = "\(self.downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "smallGoodsImage") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                        let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        self.orderImages.updateValue(image!, forKey: index)
                    }catch{
                        let imageURLString:String = "\(self.downloadURLHeader)\(orderInfoObjects.value(forKey: "smallGoodsImage") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            let oImage = UIImage.gif(data:data)
                            let image = UIImage(data: compressionImage(with: oImage!) as Data)
                            self.orderImages.updateValue(image!, forKey: index)
                        }catch{
                            print(error)
                            print("orderID = \(orderInfoObjects.value(forKey: "orderid"))")
                            self.orderImages.updateValue(UIImage(named:"defualt-design-pic")!, forKey: index)
                        }
                        print("无缩略图")
                    }
                }
                //图片下载完了,重新加载表格
                OperationQueue.main.addOperation({
                    self.loadStatusImageViews()
                    self.AllOrdersCollectionView.reloadData()
                })
                
            }
        }
        queue.cancelAllOperations()
        queue.addOperation(downloadImageOpt)
    }
    
    
    @objc func acceptDesignBtnClicked(_ button:UIButton){
        print("点击了接受设计按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let acceptDesignView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptDesignView.popupVC = popVC
        acceptDesignView._orderID = orderID
        acceptDesignView._customID = customID
        acceptDesignView.allOrderVC = self
        
        acceptDesignView.createViewWithActionType(ActionType: .acceptDesign)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptDesignView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    
    @objc func designRequireBtnClicked(_ button:UIButton){
        print("点击了查看设计要求按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let acceptDesignView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptDesignView.popupVC = popVC
        acceptDesignView._orderID = orderID
        acceptDesignView._customID = customID
        acceptDesignView.allOrderVC = self
        
        acceptDesignView.createViewWithActionType(ActionType: .designRequires)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptDesignView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    
    @objc func dealBargainBtnClicked(_ button:UIButton){
        print("点击了查看修改要求按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let dealBargainView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 166))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        dealBargainView.popupVC = popVC
        dealBargainView._orderID = orderID
        dealBargainView._customID = customID
        dealBargainView.allOrderVC = self
        
        dealBargainView.createViewWithActionType(ActionType: .dealBargain)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(dealBargainView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    @objc func modifyRequireBtnClicked(_ button:UIButton){
        print("点击了查看设计要求按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let acceptDesignView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 166))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptDesignView.popupVC = popVC
        acceptDesignView._orderID = orderID
        acceptDesignView._customID = customID
        acceptDesignView.allOrderVC = self
        
        acceptDesignView.createViewWithActionType(ActionType: .modifyRequires) // modifyRequires实际上是留言沟通
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptDesignView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    
    @objc func quotePriceBtnClicked(_ button:UIButton){
        print("点击了报价按钮")
        
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let quotePriceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 166 ))
        let commandsCode = orderInfoObjects.value(forKey: "command") as! String
        
        var _isBidding = false
        
        if (commandsCode.contains("BIDDING_FEEDBACK")){
            _isBidding = true
        }else{
            _isBidding = false
        }
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        quotePriceView.popupVC = popVC
        quotePriceView._orderID = orderID
        quotePriceView._customID = customID
        quotePriceView._isBidding = _isBidding
        quotePriceView.allOrderVC = self
        
        quotePriceView.createViewWithActionType(ActionType: .quotePrice)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(quotePriceView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    @objc func acceptProduceBtnClicked(_ button:UIButton){
        print("点击了接受生产按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let acceptProduceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight )) //+ 166
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptProduceView.popupVC = popVC
        acceptProduceView._orderID = orderID
        acceptProduceView._customID = customID
        acceptProduceView.allOrderVC = self
        
        acceptProduceView.createViewWithActionType(ActionType: .acceptProduce)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptProduceView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    
    @objc func takePhotoBtnCliced(_ button:UIButton){
        print("点击了拍摄成品按钮在\(button.tag)")
        selectedIndex = button.tag
        let uploadVC = UploadProductImageViewController()
        
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        //let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        uploadVC.orderObject = dictionaryObjectInOrderArray
        
//        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
//        let customID = orderInfoObjects.value(forKey: "customid") as! String
//        let goodsID = orderInfoObjects.value(forKey: "goodsid") as! String
//        let goodsImage = orderInfoObjects.value(forKey: "smallGoodsImage") as! String
//        uploadVC._goodsImage =
//        uploadVC._orderID = orderID
//        uploadVC._productType
//        uploadVC._modalAndColor
//        uploadVC._materialAndAccessory
        
        let nav = UINavigationController.init(rootViewController: uploadVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func shippingBtnClicked(_ button:UIButton){
        print("点击了发货按钮")
        selectedIndex = button.tag
        let orderInfoObjects = orderArray[selectedIndex]
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let shippingView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 303 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        shippingView.popupVC = popVC
        shippingView._orderID = orderID
        shippingView._customID = customID
        shippingView.allOrderVC = self
        
        if orderImages[selectedIndex] == nil{
            shippingView.googsImge = UIImage(named: "defualt-design-pic")! 
        }else{
            shippingView.googsImge = orderImages[selectedIndex]!
        }
        shippingView.createViewWithActionType(ActionType: .shippingProduct)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(shippingView)
        
        self.present(popVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func StartLoadingAnimation(){
        //加载中动画与文字
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
        //动画imageView
        let imageView = UIImageView()

        //当loadingView不为空的时候，表示有LoadingView在运行
        if theLoadingViewNeedsToBeKill.count != 0 {
            for item in theLoadingViewNeedsToBeKill{
                item.removeFromSuperview()
            }
        }
            
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
        
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()

        theLoadingViewNeedsToBeKill.append(imageView)
        theLoadingViewNeedsToBeKill.append(noticeWhenLoadingData)
        
        self.view.addSubview(imageView)
        self.view.addSubview(noticeWhenLoadingData)

    }
    
    func StopLoadingAnimation(){
        if theLoadingViewNeedsToBeKill.count != 0 {
            for item in theLoadingViewNeedsToBeKill {
                item.removeFromSuperview()
            }
        }
    }
    ///获取订单概览数据
    func loadOrderDataFromServer(pages:Int,categoryType:orderListCategoryType) {
        //去除未完成的数据请求
//        for task in AllOrdersViewController.requestCacheArr{
//            task.cancel()
//        }
       // AllOrdersViewController.requestCacheArr.removeAll()
        if isRequesting{
            return
        }else{
            isRequesting = true // 检查是不是正在重新
        }
        DispatchQueue.main.async {
            //先删除重试按钮
            if self.view.viewWithTag(100) != nil{ //100,101tag是重试按钮的view
                self.view.viewWithTag(100)?.removeFromSuperview()
                self.view.viewWithTag(101)?.removeFromSuperview()
            }
            //先删除没有订单的提示信息
            if self.view.viewWithTag(901) != nil{
                self.view.viewWithTag(901)?.removeFromSuperview()
                self.view.viewWithTag(902)?.removeFromSuperview()
                self.view.viewWithTag(903)?.removeFromSuperview()
            }
        }

        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        

        #if DEBUG
            let requestURL:String = apiAddresses.value(forKey: "orderListSupplementaryDebug") as! String
        #else
            let requestURL:String = apiAddresses.value(forKey: "orderListSupplementary") as! String
        #endif

        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        
        let now = NSDate()
        let startTime = (Int(now.timeIntervalSince1970) - 2592000)*1000 //30天前   51840000
        let endTime = getEndDateTimeOfToday().TimeInterval * 1000
        params["sortCategory"] =  "synthesize"
        params["sortType"] = "desc"
        params["startTime"] = startTime//startTime// 全部订单
        params["endTime"] = endTime
        params["pageNum"] = pages
        params["pageSize"] = 6// 6
        
        //params["isUrgency"] = 0
        //params["isContinueOrder"] = 0
        
        //系统分类ID表格
        //var systemNavigationIDArray:[NSDictionary] = [["待接单":"39","待修改":"43","已定稿":"77"],
          //                                            ["全部订单":"50","未报价":"53","已报价":"55","待接单":"60","待发货":"62"]]
        //根据分类制定NavID
        switch categoryType {
        case orderListCategoryType.allOrderCategory:
            switch _roleType{
            case 1:
                params["navId"] = 3
            case 2:
                params["navId"] = 36
            case 3:
                params["navId"] = 50
               // params["navId"] = 81
            case 4:
                params["navId"] = 3
            default:
                params["navId"] = 3
            }
        case orderListCategoryType.notQuotePriceYetOrderCategory:
            params["navId"] = 8888//53
        case orderListCategoryType.alreadyQuotedOderCategory:
            params["navId"] = 9999//55
        case orderListCategoryType.waitForAcceptProduceOrderCategory:
           params["navId"] = 59 // 60
        case orderListCategoryType.bargainNotDealedCategory:
            params["navId"] = 57
        case orderListCategoryType.bargainDealedCategory:
            params["navId"] = 58
        case orderListCategoryType.producingOrderCategory:
           params["navId"] = 61//62
        case orderListCategoryType.allFactoryNotQuoteCategory:
            params["navId"] = 89 //都未报价
        case orderListCategoryType.waitForDesignCategory:
            //待接受设计
            params["navId"] = 38
        case orderListCategoryType.designningCategory:
            params["navId"] = 40//41
        case orderListCategoryType.waitForConfirmDesignCategory:
            params["navId"] = 76
        case orderListCategoryType.waitForModifyCategory:
           params["navId"] = 42//43
        case orderListCategoryType.customerConfirmedCategory:
            params["navId"] = 77
        default:
            params["navId"] = 3
        }
        
        //获取token
      //  DispatchQueue.main.async {
        let userInfo = getCurrentUserInfo()
        let token = userInfo.value(forKey: "token") as! String
        header["token"] = token
        //}
        
        let dataRequest = Alamofire.request(requestURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            if orderListCategoryType.producingOrderCategory == categoryType  {
                print("hello")
            }
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int
                    if statusCode == 200{ //数据获取成功
                        if json["data","pageData"].count != 0 {
                            if pages == 1{
                                self.orderArray.removeAll()
                                self.orderImages.removeAll()
                                self.statusListView.removeAll()
                            }
                            self.totalPageCount = json["data","pageMessage","rowCount"].int!
                            for item in json["data","pageData"].array! {
                                let restoreItem = item.dictionaryObject as! NSDictionary
                                self.orderArray.append(restoreItem)
                            }
                            if !self.scrollView.subviews.contains(self.AllOrdersCollectionView) {
                                self.scrollView.addSubview(self.AllOrdersCollectionView)
                                self.StopLoadingAnimation()
                            }
                            self.downloadOrderImages()
                            self.AllOrdersCollectionView.reloadData()
                            self.AllOrdersCollectionView.es.stopPullToRefresh()
                            self.AllOrdersCollectionView.es.stopLoadingMore()
                        }else{
                            if self.page == 1{
                                self.orderArray.removeAll()
                                self.orderImages.removeAll()
                                self.statusListView.removeAll()
                                self.AllOrdersCollectionView.reloadData()
                                self.StopLoadingAnimation()
                                self.emytyAreaShowingLabel(withRetry: true)
                                self.AllOrdersCollectionView.es.stopPullToRefresh()
                                self.AllOrdersCollectionView.es.stopLoadingMore()
                            }else{
                                self.AllOrdersCollectionView.es.noticeNoMoreData()
                            }
                        }
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                    }else{
                        let msg = json["message"].string
                        greyLayerPrompt.show(text: msg!)
                    }
                    self.isRequesting = false
                }
            case false:
                print("执行出错了")
                self.AllOrdersCollectionView.es.stopPullToRefresh()
                if self.scrollView.subviews.contains(self.AllOrdersCollectionView) {
                    self.AllOrdersCollectionView.removeFromSuperview()
                }else{
                    self.StopLoadingAnimation()
                    let loadingFailedLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200))
                    loadingFailedLabel.text = "加载失败，请重试..."
                    loadingFailedLabel.tag = 100
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
                    retryBtn.tag = 101
                    retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
                    //先删除后添加，防止重复点击重复创建
                    self.view.viewWithTag(100)?.removeFromSuperview()
                    self.view.viewWithTag(101)?.removeFromSuperview()
                    
                    self.view.addSubview(loadingFailedLabel)
                    self.view.addSubview(retryBtn)
                }
                if responseObject.result.error?.localizedDescription != "cancelled" && responseObject.result.error?.localizedDescription as! String != "已取消"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print(responseObject.result.error ?? "No result found")
                        if responseObject.result.error?.localizedDescription as! String == "The Internet connection appears to be offline."{
                            greyLayerPrompt.show(text: "未接入网络，请接入网络再试")
                        }else{
                            if responseObject.result.error?.localizedDescription as! String != "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format." && responseObject.error?.localizedDescription as! String != "Response could not be serialized, input data was nil or zero length."{
                                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                            }
                            
                        }
                        let loadingFailedLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200))
                        loadingFailedLabel.text = "加载失败，请重试..."
                        loadingFailedLabel.tag = 100
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
                        retryBtn.tag = 101
                        retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
                        //先删除后添加，防止重复点击重复创建
                        self.view.viewWithTag(100)?.removeFromSuperview()
                        self.view.viewWithTag(101)?.removeFromSuperview()
                        
                        self.view.addSubview(loadingFailedLabel)
                        self.view.addSubview(retryBtn)
                    }
                }
                self.isRequesting = false
            }
        }
        //AllOrdersViewController.requestCacheArr.append(dataRequest)
    }
    
    

   
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.clear)
        setStatusBarHiden(toHidden: false, ViewController: self)
        self.view.backgroundColor = UIColor.white
        //从datacore获取用户数据
        //获取管理的数据上下文，对象
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedObjectContext = appDelegate.persistentContainer.viewContext
//
//        //声明数据的请求
//        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
//        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
//        //        fetchRequest.fetchOffset = 0 //查询到偏移量
//        fetchRequest.returnsObjectsAsFaults = false
//
//        // 设置查询条件
//        let predicate = NSPredicate(format: "id = '1'")
//        fetchRequest.predicate = predicate
//
//        //查询操作
//        do {
//            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
//
//            //遍历查询结果
//            for info in fetchedObjects{
//                self._roleType = Int(info.roleType)
//                try managedObjectContext.save()
//            }
//        } catch  {
//            fatalError("获取失败")
//        }
        self._roleType = UserDefaults.standard.value(forKey: "currentRoleType") as! Int
        if _roleType == 0{
            emytyAreaShowingLabel()
        }
    }
    
    @objc func retryBtnInViewClicked(){
        orderArray.removeAll()
        orderImages.removeAll()
        loadOrderDataFromServer(pages: 1, categoryType: _orderlistType)
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        //什么都没有
        let sizeOfNothing:Int = 180
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 300, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 120 , width: 200, height: 44))
        nothingToSHowLabel.text = "空空如也..."
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.tag = 901
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
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
            self.view.addSubview(retryBtn)
        }
    }
    func emytyAreaShowingLabel(){
        //什么都没有
        let sizeOfNothing:Int = 180
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 300, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 120 , width: 200, height: 44))
        nothingToSHowLabel.text = "空空如也..."
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        self.view.addSubview(nothingToShow)
    }
    
    func reloadData(){
        self.page = 1
        loadOrderDataFromServer(pages: 1, categoryType: self._orderlistType)
    }
    
}
