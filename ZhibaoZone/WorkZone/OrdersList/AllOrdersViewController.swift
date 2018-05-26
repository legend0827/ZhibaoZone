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

class AllOrdersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //定义订单列表的类型
    var _orderlistTye:orderListCategoryType = .allOrderCategory
    
    init(orderlistTye:orderListCategoryType) {
        super.init(nibName: nil, bundle: nil)
        _orderlistTye = orderlistTye
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    var downloadURLHeader = ""
    
    //用户角色信息
    var _userid:String?
    var _token:String?
    
    var _roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    var orderCreateTimeArray:[NSDictionary] = []
    var orderCreateTimes:[String] = []
    var page: Int = 1
    var totalPageCount: Int = 1
    var selectorParamters = [Int:String]()
    
   
    let heightHeader:CGFloat = 40.0
    
    //选择的订单的index
    var selectedIndex = 0
    
    //加载中的动画集合
    var theLoadingViewNeedsToBeKill:[UIView] = []
    
    let CELL_ID = "cell_id";

    lazy var AllOrdersCollectionView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:(kWidth - 50)/2,height: (kWidth - 50)/2 + 92)  //设置item尺寸
        layout.minimumLineSpacing = 5  //上下间隔
        layout.minimumInteritemSpacing = 5 //左右间隔
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)            //section四周的缩进
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - 145),collectionViewLayout:layout) // 
        tempCollectionView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.isScrollEnabled = true // 允许拖动
        tempCollectionView.register(OrdersCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        // 注册一个headView
        tempCollectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        return tempCollectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArray.count
        //return orderCreateTimeArray[section].value(forKey: "count") as! Int
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //restoreCreateTimesArray()
       // return orderCreateTimeArray.count
        return 1
    }
//    // 返回HeadView的宽高
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: kWidth, height: heightHeader)
//    }
    
//    // 返回自定义HeadView或者FootView，我这里以headview为例
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        var reusableview:UICollectionReusableView!
//
//        if kind == UICollectionElementKindSectionHeader
//        {
//            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! CollectionReusableViewHeader
//            //reusableview.backgroundColor = UIColor.green
//            let timeLabelValue = orderCreateTimeArray[indexPath.section].value(forKey: "createDate") as! String
//
//            let date = NSDate()
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "yyyy-MM-dd"
//            let strNowTime = timeFormatter.string(from: date as Date) as String
//            if strNowTime == timeLabelValue {
//                    (reusableview as! CollectionReusableViewHeader).label.text = "今天"
//            }else{
//                 (reusableview as! CollectionReusableViewHeader).label.text = timeLabelValue
//            }
//
//        }
//
//        return reusableview
//    }
    
    func restoreCreateTimesArray(){
        orderCreateTimeArray.removeAll()
        //orderCreateTimes.removeAll()
        var tempTimes:[String] = []
        for item in orderCreateTimes{
            let index = item.index(item.startIndex, offsetBy: 10)
            let tempItem = item.substring(to: index)
            tempTimes.append(tempItem)
        }
        print("tempTimes\(tempTimes)")
        //去重获得有多少日期
        let variableTempTimes:[String] = Array(Set(tempTimes)).sorted(by: {return $0 > $1})
        
        print("variableTempTimes\(variableTempTimes)")
        for item in variableTempTimes{
            var count = 0
            let createDate = item
            for time in tempTimes{
                if time == createDate{
                    count += 1
                }
            }
            let tempDic:NSDictionary = ["createDate":createDate,"count":count]
            orderCreateTimeArray.append(tempDic)
        }
        print(orderCreateTimeArray)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! OrdersCollectionViewCell
        
        let dictionaryObjectInOrderArray = orderArray[indexPath.row]
        let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray.value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        let priceInfoObjects = dictionaryObjectInOrderArray.value(forKey: "price") as! NSDictionary
        
      //  cell.productSize.text = orderInfoObjects.value(forKey: "createtime") as! String // for debug after delete
      //  cell.productQuantityInCell.text =  orderCreateTimeArray[indexPath.section].value(forKey: "createDate") as! String //

//        var tempDateTime = orderInfoObjects.value(forKey: "createtime") as! String
//        let index = tempDateTime.index(tempDateTime.startIndex, offsetBy: 10)
//        tempDateTime = tempDateTime.substring(to: index)
//        if orderCreateTimeArray[indexPath.section].value(forKey: "createDate") as! String != tempDateTime{
//            return cell
//        }
        //获取订单图片
        if orderInfoObjects.value(forKey: "goodsimage") as? String == nil{ // 图片字段为空
            cell.orderCellImageView.image = UIImage(named:"defualt-design-pic")
        }else{
            let imageURLString:String = "\(downloadURLHeader)\(orderInfoObjects.value(forKey: "goodsimage") as! String)"
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage.gif(data:data)
                cell.orderCellImageView.image = image//  UIImage(image:image)
            }catch{
                print(error)
            }
            
        }
        
        // cell.orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String //订单创建时间
        // cell.orderID.text = orderInfoObjects.value(forKey: "orderid") as? String // 订单号
        cell.productTypeAndMaterialInCell.text = "\(orderInfoObjects.value(forKey: "goodsclass") as! String) \(goodsInfoObjects.value(forKey: "texturename") as! String)" //订单产品类别 材质
        cell.productQuantityInCell.text = "x\(goodsInfoObjects.value(forKey: "number") as! Int)"
        //设置产品尺寸
        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary
        var sizeString:String = ""
        //长
        if sizeObject.value(forKey: "length") as? Float != nil {
            sizeString += "\(sizeObject.value(forKey: "length")as! Float)"
        }
        //宽
        if sizeObject.value(forKey: "width") as? Float != nil {
            sizeString += "x\(sizeObject.value(forKey: "width")as! Float)"
        }else{
            sizeString += "x "
        }
        //高
        if sizeObject.value(forKey: "height") as? Float != nil {
            sizeString += "x\(sizeObject.value(forKey: "height")as! Float)(mm)"
        }else{
            sizeString += "x (mm)"
        }
        cell.productSize.text = sizeString
        
        
        cell.acceptDesignBtnInCell.isHidden = true
        cell.acceptProduceBtnInCell.isHidden = true
        cell.quotePriceBtnInCell.isHidden = true
        cell.shippingBtnInCell.isHidden = true
        
        cell.acceptDesignBtnInCell.addTarget(self, action: #selector(acceptDesignBtnClicked), for: .touchUpInside)
        cell.quotePriceBtnInCell.addTarget(self, action: #selector(quotePriceBtnClicked), for: .touchUpInside)
        cell.acceptProduceBtnInCell.addTarget(self, action: #selector(acceptProduceBtnClicked), for: .touchUpInside)
        cell.shippingBtnInCell.addTarget(self, action: #selector(shippingBtnClicked), for: .touchUpInside)
        
        cell.acceptDesignBtnInCell.tag = indexPath.row
        cell.quotePriceBtnInCell.tag = indexPath.row
        cell.acceptProduceBtnInCell.tag = indexPath.row
        cell.shippingBtnInCell.tag = indexPath.row
        
        switch _roleType {
        case 1:
            print("RoleType 为 1")
        case 2:
            // print("RoleType 为 2")
            //设置师角色，并且订单状态为2
//            if (statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "designreceivestate") as? Int == nil{
//                print("hello")
//            }
            // let designreceiveStateObjec = (statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "designreceivestate") as? NSDictionary
            if (statusObjects.value(forKey: "designreceivestate") as! NSDictionary).value(forKey: "code")  as! Int == 0{
                cell.acceptDesignBtnInCell.isHidden = false
            }
//            if orderInfoObjects.value(forKey: "orderid") as! String  == "205176634213032"{
//                print("hellp")
//            }
            
            //设置设计费显示
            if priceInfoObjects.value(forKey: "designprice") as? Float == nil{
                cell.priceLabel.text = "¥8.0"
            }else{
                cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "designprice") as! Float)0"
            }
        case 3:
            //  print("RoleType 为 3")
            //支付状态
            let paystate = (statusObjects.value(forKey: "payoffstate") as! NSDictionary).value(forKey: "code") as! Int
            //支付之前，显示报价按钮
//            if orderInfoObjects.value(forKey: "orderid") as! String == "205176654690393" {
//                print("paystate = \(paystate)")
//            }
            if paystate < 1{
                cell.quotePriceBtnInCell.isHidden = false
            }else{
                cell.quotePriceBtnInCell.isHidden = true
            }
            //分配生产之前，价格显示报价价格 //设置自己的报价
            if ((statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int) < 7{
               // cell.quotePriceBtnInCell.isHidden = false
                
                if priceInfoObjects.value(forKey: "returnprice") as? Float == nil{
                    cell.priceLabel.text = "¥0.00"
                }else{
                    cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
                }
            }else{
                //订单支付之后，如果报过价格，价格显示报价价格否则显示finlprice
                if priceInfoObjects.value(forKey: "returnprice") as? Float == nil || priceInfoObjects.value(forKey: "returnprice") as? Float == 0.0{
                    if priceInfoObjects.value(forKey: "finalprice") as? Float == nil{
                        cell.priceLabel.text = "¥0.0"
                    }else{
                        cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Float)0"
                    }
                    //cell.priceLabel.text = "¥0.00"
                }else{
                    cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
                }
            }
            
            // 接受生产按钮显示控制
            //订单状态为7表示需要接受生产
            if (statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int == 7{
                cell.acceptProduceBtnInCell.isHidden = false
            }
            
            //订单在生产中，允许上传物流
            if (statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int == 8{
                cell.shippingBtnInCell.isHidden = false
                cell.orderIDValue.isHidden = false
                cell.orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as! String
                cell.productSize.isHidden = true
                cell.productTypeAndMaterialInCell.frame = cell.productSize.frame
            }else{
                cell.orderIDValue.isHidden = true
                cell.productSize.isHidden = false
                cell.productTypeAndMaterialInCell.frame = CGRect(x: 5, y: cell.frame.width - 5, width: 100, height: 20)
            }
            
            if priceInfoObjects.value(forKey: "mindprice") as? Float != nil && priceInfoObjects.value(forKey: "mindprice") as? Float != 0.0{
                if priceInfoObjects.value(forKey: "returnprice") as? Float != nil && priceInfoObjects.value(forKey: "returnprice") as? Float != 0.0{
                    if priceInfoObjects.value(forKey: "returnprice") as! Float > priceInfoObjects.value(forKey: "mindprice") as! Float{
                        cell.statusImageView.isHidden = false
                    }else{
                        cell.statusImageView.isHidden = true
                    }
                }else{
                    cell.statusImageView.isHidden = true
                }
            }else{
                cell.statusImageView.isHidden = true
            }
            
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

        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if DEBUG
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        #else
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        #endif
        
        //获取用户信息
        
        let userInfos = getCurrentUserInfo()
//        if userInfos.count == 0{
//            _roleType = 1
//            _userid = "000100101"
//            _token = "1102312312"
//        }else{
            _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
            _userid = userInfos.value(forKey: "userid") as? String
            _token = userInfos.value(forKey: "token") as? String
       // }
        if _orderlistTye == .allOrderCategory{
            StartLoadingAnimation()
            DispatchQueue.global().async {
            self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistTye)
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.StartLoadingAnimation()
                DispatchQueue.global().async {
                    self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistTye)
                }
            }
        }

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page = 1
            self.orderArray.removeAll()
            self.orderCreateTimes.removeAll()
            self.orderCreateTimeArray.removeAll()
            self.loadOrderDataFromServer(pages: 1, categoryType: self._orderlistTye)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page, categoryType: self._orderlistTye)
                self.AllOrdersCollectionView.reloadData()
                self.AllOrdersCollectionView.es.stopLoadingMore()
            }else{
                self.AllOrdersCollectionView.es.noticeNoMoreData()
                
            }
        }
    }
    
    @objc func acceptDesignBtnClicked(_ button:UIButton){
        print("点击了接受设计按钮")
        selectedIndex = button.tag
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        
        
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let customID = orderInfoObjects.value(forKey: "customid") as! String
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
    }
    
    @objc func quotePriceBtnClicked(_ button:UIButton){
        print("点击了报价按钮")
        
        selectedIndex = button.tag
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        
        
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let customID = orderInfoObjects.value(forKey: "customid") as! String
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
    }
    @objc func acceptProduceBtnClicked(_ button:UIButton){
        print("点击了接受生产按钮")
        selectedIndex = button.tag
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        
        
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let customID = orderInfoObjects.value(forKey: "customid") as! String
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
    }
    @objc func shippingBtnClicked(_ button:UIButton){
        print("点击了发货按钮")
        selectedIndex = button.tag
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        
        
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        let customID = orderInfoObjects.value(forKey: "customid") as! String
        let goodsID = orderInfoObjects.value(forKey: "goodsid") as! String
        
        let shippingView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 363 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        shippingView.popupVC = popVC
        shippingView._orderID = orderID
        shippingView._customID = customID
        shippingView._goodsID = goodsID
        
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
        for task in AllOrdersViewController.requestCacheArr{
            task.cancel()
        }
        AllOrdersViewController.requestCacheArr.removeAll()
        
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
        var requestURL:String = ""
        
        
        switch categoryType {
        case orderListCategoryType.allOrderCategory:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfAllOrdersDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfAllOrders") as! String
            #endif
        case orderListCategoryType.notQuotePriceYetOrderCategory:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfNotQuoteYetDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfNotQuoteYet") as! String
            #endif
        case orderListCategoryType.alreadyQuotedOderCategory:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfAlreadyQuoteDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfAlreadyQuote") as! String
            #endif
        case orderListCategoryType.waitForAcceptProduceOrderCategory:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfWaitForProduceDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfWaitForProduce") as! String
            #endif
        case orderListCategoryType.producingOrderCategory:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfProducingDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfProducing") as! String
            #endif
        default:
            #if DEBUG
            requestURL = apiAddresses.value(forKey: "orderListOfAllOrdersDebug") as! String
            #else
            requestURL = apiAddresses.value(forKey: "orderListOfAllOrders") as! String
            #endif
        }
        

        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["userid"] =  _userid
        params["roletype"] = _roleType
        params["workflow"] = 18 // 全部订单
        params["searchday"] = 30
        params["fromtime"] = "2016"
        params["totime"] = "2018"
        params["ordernumofsheet"] = 5
        params["ordersheet"] = pages
        params["ranktype"] = 1
        params["inorder"] = 0
        params["token"] = _token
        if _roleType == 2{
            params["mark"] = 1 // 1时间升序
            params["rushorders"] = 1
        }


        let dataRequest = Alamofire.request(requestURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            if orderListCategoryType.producingOrderCategory == categoryType  {
                print("hello")
            }
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    if json.count == 3 {
                        self.orderCount = json["ordersummary","returnum"].int!//获取订单数
                        self.totalPageCount = json["ordersummary","totalnum"].int!/self.orderCount
                        for item in json["ordersummary","orderarray"].array! {
                            let restoreItem = item.dictionaryObject as! NSDictionary
                            self.orderArray.append(restoreItem)
                            //添加订单时间字典
                            var tempTime = (restoreItem.value(forKey: "orderinfo") as! NSDictionary).value(forKey: "createtime") as! String
                            self.orderCreateTimes.append(tempTime)
                            //self.orderCreateTimeArray.
                        }
                        if !self.view.subviews.contains(self.AllOrdersCollectionView) {
                            self.view.addSubview(self.AllOrdersCollectionView)
                            self.StopLoadingAnimation()
                        }
                        self.AllOrdersCollectionView.reloadData()
                        self.AllOrdersCollectionView.es.stopPullToRefresh()
                    }else{
                        if self.page == 1{
                            self.StopLoadingAnimation()
                            self.emytyAreaShowingLabel(withRetry: true)
                        }else{
                            self.AllOrdersCollectionView.es.noticeNoMoreData()
                        }
                    }
                }
            case false:
                self.AllOrdersCollectionView.es.stopPullToRefresh()
                if self.view.subviews.contains(self.AllOrdersCollectionView) {
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
            }
        }
        AllOrdersViewController.requestCacheArr.append(dataRequest)
    }
    
    @objc func retryBtnInViewClicked(){
        orderArray.removeAll()
        orderCreateTimes.removeAll()
        orderCreateTimeArray.removeAll()
        loadOrderDataFromServer(pages: 1, categoryType: _orderlistTye)
    }

    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        self.view.backgroundColor = UIColor.white
        //从datacore获取用户数据
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询到偏移量
        fetchRequest.returnsObjectsAsFaults = false
        
        // 设置查询条件
        let predicate = NSPredicate(format: "id = '1'")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            //遍历查询结果
            for info in fetchedObjects{
                self._roleType = Int(info.roleType)
                try managedObjectContext.save()
            }
        } catch  {
            fatalError("获取失败")
        }
        if _roleType == 0{
            emytyAreaShowingLabel()
        }
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

}
