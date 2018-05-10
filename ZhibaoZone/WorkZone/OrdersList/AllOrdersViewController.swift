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

class AllOrdersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    var downloadURLHeader = ""
    
    //用户角色信息
    var _userid:String?
    var _token:String?
    
    var _roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    var page: Int = 1
    var totalPageCount: Int = 1
    var selectorParamters = [Int:String]()
    var theChildViewNeedToClose:[UIView] = []
    
    //订单详情
    var isOrderDetailsGets = false
    //订单详情：
    var orderDetail:[NSDictionary] = []
    
    //定价
    var memoPictures:[UIImage] = []
    //参考图类型
    var previewTypes:[String] = []
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
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - 205),collectionViewLayout:layout)
        tempCollectionView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.isScrollEnabled = true // 允许拖动
        tempCollectionView.register(OrdersCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        return tempCollectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! OrdersCollectionViewCell
        
        let dictionaryObjectInOrderArray = orderArray[indexPath.row]
        let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray.value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        let priceInfoObjects = dictionaryObjectInOrderArray.value(forKey: "price") as! NSDictionary
        
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
        
        switch _roleType {
        case 1:
            print("RoleType 为 1")
        case 2:
            // print("RoleType 为 2")
            //设置师角色，并且订单状态为2
            if (statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int == 2{
                cell.acceptDesignBtnInCell.isHidden = false
            }
            
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
            if paystate < 1{
                cell.quotePriceBtnInCell.isHidden = false
            }
            //分配生产之前，价格显示报价价格 //设置自己的报价
            if ((statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int) <= 7{
                cell.quotePriceBtnInCell.isHidden = false
                
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

//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
//
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
        
        StartLoadingAnimation()
        DispatchQueue.global().async {
            self.loadOrderDataFromServer(pages: 1, categoryType: .allOrderCategory)
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
            self.loadOrderDataFromServer(pages: 1, categoryType: .allOrderCategory)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page, categoryType: .allOrderCategory)
                self.AllOrdersCollectionView.reloadData()
                self.AllOrdersCollectionView.es.stopLoadingMore()
            }else{
                self.AllOrdersCollectionView.es.noticeNoMoreData()
                
            }
        }
    }
    
    @objc func acceptDesignBtnClicked(){
        print("点击了接受设计按钮")
    }
    @objc func quotePriceBtnClicked(){
        print("点击了报价按钮")
        let quotePriceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight))
        quotePriceView.createViewWithActionType(ActionType: .quotePrice)
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        quotePriceView.popupVC = popVC
        quotePriceView._orderID = 传入订单号
        quotePriceView._customID = 传入定制号
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(quotePriceView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    @objc func acceptProduceBtnClicked(){
        print("点击了接受生产按钮")
    }
    @objc func shippingBtnClicked(){
        print("点击了发货按钮")
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
        #if DEBUG
        requestURL = apiAddresses.value(forKey: "orderListOfAllOrdersDebug") as! String
        #else
        requestURL = apiAddresses.value(forKey: "orderListOfAllOrders") as! String
        #endif
        
        
        
        
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

        let dataRequest = Alamofire.request(requestURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
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
    
//    // 加载报价所需数据
//    func showBlurViewData(){
//
//        var maxPrice = 5000.0
//        var currentValue:Float = 0.0
//
//        //设置客户心理价(预算）
//        var mindPrice:Float = 0.0
//        var quotePriceOfFactory:Float = 0.0
//        let userInfo = getCurrentUserInfo()
//        roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
//        //let roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
//
//        let dictionaryObjectInOrderArray = orderDetail
//        let priceInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "price") as! NSDictionary
//        let statusObjects = dictionaryObjectInOrderArray[2].value(forKey: "state") as! NSDictionary
//        let goodsInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "goodsinfo") as! NSDictionary
//        let orderInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "orderinfo") as! NSDictionary
//
//        let orderaddinfos = dictionaryObjectInOrderArray[1]
//
//        let accessoriesObject = goodsInfoObjects.value(forKey: "accessoriesname")
//        let colorObject = goodsInfoObjects.value(forKey: "color")
//        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary
//
//        //附件图片数目
//        var attachImageCount:Int = 0
//        //设计师图递增
//        if roleType == 2{
//            memoPictures.removeAll()
//            previewTypes.removeAll()
//            if orderaddinfos.value(forKey: "imageurl1") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//            }
//            if orderaddinfos.value(forKey: "imageurl2") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//
//            }
//            if orderaddinfos.value(forKey: "imageurl3") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//            }
//        }
//        //工厂图递增
//        if roleType == 3{
//            memoPictures.removeAll()
//            previewTypes.removeAll()
//            if orderaddinfos.value(forKey: "fimageurl1") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//            }
//            if orderaddinfos.value(forKey: "fimageurl2") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//            }
//            if orderaddinfos.value(forKey: "fimageurl3") as? String != nil {
//                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    memoPictures.append(image!)
//                    previewTypes.append("public.image")
//                    attachImageCount += 1
//                }catch{
//                    print(error)
//                }
//            }
//
//            //没有一张工厂的参考图
//            if attachImageCount == 0{
//                if orderaddinfos.value(forKey: "imageurl1") as? String != nil {
//                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let image = UIImage.gif(data:data)
//                        memoPictures.append(image!)
//                        previewTypes.append("public.image")
//                        attachImageCount += 1
//                    }catch{
//                        print(error)
//                    }
//                }
//                if orderaddinfos.value(forKey: "imageurl2") as? String != nil {
//                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let image = UIImage.gif(data:data)
//                        memoPictures.append(image!)
//                        previewTypes.append("public.image")
//                        attachImageCount += 1
//                    }catch{
//                        print(error)
//                    }
//                }
//                if orderaddinfos.value(forKey: "imageurl3") as? String != nil {
//                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let image = UIImage.gif(data:data)
//                        memoPictures.append(image!)
//                        previewTypes.append("public.image")
//                        attachImageCount += 1
//                    }catch{
//                        print(error)
//                    }
//                }
//            }
//        }
//
//        orderDefaultPicLayer.removeFromSuperview()
//        for subview in orderDefaultPic.subviews{
//            subview.removeFromSuperview()
//        }
//
//        if attachImageCount != 0{
//
//            orderDefaultPic.addSubview(orderDefaultPicLayer)
//            for i in 1...attachImageCount{
//                //附件数目小红点
//                var positionX = 0
//                var fistPositon = 35
//                if attachImageCount == 2{
//                    positionX = i*(30/(attachImageCount+1))
//                    fistPositon = 35
//                }else{
//                    positionX = i*(40/(attachImageCount+1))
//                    fistPositon = 30
//                }
//                let imageCountLabel:UILabel = UILabel.init(frame: CGRect(x: fistPositon + positionX, y: 87, width: 5, height: 5))
//                imageCountLabel.backgroundColor = UIColor.white
//                imageCountLabel.layer.cornerRadius = 2.5
//                //imageCountLabel.text = "\(attachImageCount)"
//                imageCountLabel.textColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
//                imageCountLabel.textAlignment = .center
//                imageCountLabel.clipsToBounds = true // 对Label切角度
//
//                orderDefaultPic.addSubview(imageCountLabel)
//            }
//            orderDefaultPic.isUserInteractionEnabled = true
//
//            let tapSingle=UITapGestureRecognizer(target:self,
//                                                 action:#selector(imageViewTap(_:)))
//            tapSingle.numberOfTapsRequired = 1
//            tapSingle.numberOfTouchesRequired = 1
//
//            orderDefaultPic.addGestureRecognizer(tapSingle)
//        }
//
//
//        //设置图片
//        if roleType == 2 {
//            var imageURLString:String = ""
//            if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
//                if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
//                    if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
//                        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
//                    }else{
//                        //第三张图不为空
//                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
//                        let url = URL(string: imageURLString)!
//                        do{
//                            let data = try Data.init(contentsOf: url)
//                            let image = UIImage.gif(data:data)
//                            orderDefaultPic.image = image//  UIImage(image:image)
//                        }catch{
//                            print(error)
//                        }
//                    }
//                }else{
//                    //第二不为空
//                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let image = UIImage.gif(data:data)
//                        orderDefaultPic.image = image//  UIImage(image:image)
//                    }catch{
//                        print(error)
//                    }
//                }
//            }else{
//                //第一张图不为空
//                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    orderDefaultPic.image = image//  UIImage(image:image)
//                }catch{
//                    print(error)
//                }
//            }
//        }else if roleType == 3{
//            var imageURLString:String = ""
//            if orderaddinfos.value(forKey: "fimageurl1") as? String == nil {
//                if orderaddinfos.value(forKey: "fimageurl2") as? String == nil {
//                    if orderaddinfos.value(forKey: "fimageurl3") as? String == nil {
//                        //三张工厂参考图都为空，加载设计参考图
//                        if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
//                            if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
//                                if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
//                                    orderDefaultPic.image = UIImage(named:"defualt-design-pic")
//                                }else{
//                                    //第三张图不为空
//                                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
//                                    let url = URL(string: imageURLString)!
//                                    do{
//                                        let data = try Data.init(contentsOf: url)
//                                        let image = UIImage.gif(data:data)
//                                        orderDefaultPic.image = image//  UIImage(image:image)
//                                    }catch{
//                                        print(error)
//                                    }
//                                }
//                            }else{
//                                //第二不为空
//                                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
//                                let url = URL(string: imageURLString)!
//                                do{
//                                    let data = try Data.init(contentsOf: url)
//                                    let image = UIImage.gif(data:data)
//                                    orderDefaultPic.image = image//  UIImage(image:image)
//                                }catch{
//                                    print(error)
//                                }
//                            }
//                        }else{
//                            //第一张图不为空
//                            imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
//                            let url = URL(string: imageURLString)!
//                            do{
//                                let data = try Data.init(contentsOf: url)
//                                let image = UIImage.gif(data:data)
//                                orderDefaultPic.image = image//  UIImage(image:image)
//                            }catch{
//                                print(error)
//                            }
//                        }
//                    }else{
//                        //第三张图不为空
//                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
//                        let url = URL(string: imageURLString)!
//                        do{
//                            let data = try Data.init(contentsOf: url)
//                            let image = UIImage.gif(data:data)
//                            orderDefaultPic.image = image//  UIImage(image:image)
//                        }catch{
//                            print(error)
//                        }
//                    }
//                }else{
//                    //第二不为空
//                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
//                    let url = URL(string: imageURLString)!
//                    do{
//                        let data = try Data.init(contentsOf: url)
//                        let image = UIImage.gif(data:data)
//                        orderDefaultPic.image = image//  UIImage(image:image)
//                    }catch{
//                        print(error)
//                    }
//                }
//            }else{
//                //第一张图不为空
//                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
//                let url = URL(string: imageURLString)!
//                do{
//                    let data = try Data.init(contentsOf: url)
//                    let image = UIImage.gif(data:data)
//                    orderDefaultPic.image = image//  UIImage(image:image)
//                }catch{
//                    print(error)
//                }
//            }
//        }else{
//            orderDefaultPic.image = UIImage(named:"defualt-design-pic")
//        }
//
//
//        orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
//        orderID.text = orderInfoObjects.value(forKey: "orderid") as? String
//        productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsclass") as? String
//
//        var tempMakeStyleValue = ""
//        var texturenameValue = ""
//        if goodsInfoObjects.value(forKey: "texturename") as? String != nil{
//            texturenameValue = goodsInfoObjects.value(forKey: "texturename") as! String
//            tempMakeStyleValue += texturenameValue
//        }
//
//        var colorValue = ""
//        if colorObject as? String != nil {
//            colorValue = colorObject as! String
//            tempMakeStyleValue += ",\(colorValue)"
//        }
//        var shapeVlaue = ""
//        if goodsInfoObjects.value(forKey: "shape") as? String != nil{
//            shapeVlaue = goodsInfoObjects.value(forKey: "shape") as! String
//            tempMakeStyleValue += ",\(shapeVlaue)"
//        }
//
//        var technologyValue = ""
//        if goodsInfoObjects.value(forKey: "technology") as? String != nil{
//            technologyValue = goodsInfoObjects.value(forKey: "technology") as! String
//            tempMakeStyleValue += ",\(technologyValue)"
//        }
//
//        makeStyleValue.text = tempMakeStyleValue
//        accessoriesValue.text = accessoriesObject as? String
//
//        //设置产品数目
//        if goodsInfoObjects.value(forKey: "number") as? Int != nil{
//            orderCountValue.text = "\(goodsInfoObjects.value(forKey: "number") as! Int)" //"1000"
//        }else{
//            orderCountValue.text = ""
//        }
//
//        if sizeObject.value(forKey: "height") as? Float != nil {
//            productSizeOfHeightValue.text = "\(sizeObject.value(forKey: "height")as! Float)"
//        }else{
//            productSizeOfHeightValue.text = ""
//        }
//
//        if sizeObject.value(forKey: "width") as? Float != nil {
//            productSizeOfWidthValue.text = "\(sizeObject.value(forKey: "width")as! Float)"
//        }else{
//            productSizeOfWidthValue.text = ""
//        }
//
//        if sizeObject.value(forKey: "length") as? Float != nil {
//            productSizeOfLengthValue.text = "\(sizeObject.value(forKey: "length")as! Float)"
//        }else{
//            productSizeOfLengthValue.text = ""
//        }
//
//
//
//        //优先客户心理价，再估价，再系统估价
//        if priceInfoObjects.value(forKey: "mindprice") as? Float == nil || priceInfoObjects.value(forKey: "mindprice") as! Float == 0.0{
//            maxPrice = 5000.0
//        }else{
//            maxPrice = Double((priceInfoObjects.value(forKey: "mindprice") as! Float)*3)
//        }
//
//        //设置上次报价
//        if priceInfoObjects.value(forKey: "returnprice") as? Float == nil{
//            quotePriceAtLastTimeValue.text = "¥0.00"
//        }else{
//            quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
//            quotePriceOfFactory = priceInfoObjects.value(forKey: "returnprice") as! Float
//            currentValue = Float(priceInfoObjects.value(forKey: "returnprice") as! Float)
//
//        }
//        //设置订单金额（工厂接受生产时显示）
//        if roleType == 3 && (statusObjects.value(forKey:"orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int == 7{//接受生产
//            if priceInfoObjects.value(forKey: "finalprice") as? Float == nil{
//                quotePriceAtLastTimeValue.text = "¥0.00"
//            }else{
//                quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Float)0"
//                quotePriceOfFactory = priceInfoObjects.value(forKey: "finalprice") as! Float
//                currentValue = Float(priceInfoObjects.value(forKey: "finalprice") as! Float)
//            }
//        }
//
//        if priceInfoObjects.value(forKey: "mindprice") as? Float == nil{
//            customerPriceValue.text = "¥0.00"
//        }else{
//            customerPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Float)0"
//            mindPrice = priceInfoObjects.value(forKey: "mindprice") as! Float
//        }
//
//        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
//        if mindPrice != 0.0 {
//            if roleType != 1{
//                if roleType == 3 && (mindPrice < quotePriceOfFactory){
//                    if (statusObjects.value(forKey:"payoffstate") as! NSDictionary).value(forKey: "code") as! Int == 1{
//                        customerPriceLabel.isHidden = true
//                        customerPriceValue.isHidden = true
//                    }else{
//                        customerPriceLabel.isHidden = false
//                        customerPriceValue.isHidden = false
//                    }
//                }else{
//                    customerPriceLabel.isHidden = true
//                    customerPriceValue.isHidden = true
//                }
//            }else{
//                customerPriceLabel.isHidden = false
//                customerPriceValue.isHidden = false
//            }
//        }else{
//            customerPriceLabel.isHidden = true
//            customerPriceValue.isHidden = true
//        }
//
//        currentValueOnSliderTextField.text = "\(currentValue)"
//        quotePriceSlideBar.maximumValue = Float(maxPrice)
//        quotePriceSlideBar.setValue(currentValue, animated: true)
//        quotePriceSlideBarRightLabel.text = "¥\(maxPrice)0"
//        quotePriceSlideBarMidLabel.text = "¥\(maxPrice/2)0"
//        quotePriceSlideBarLeftLabel.text = "¥0.00"
//
//        if roleType == 2{
//            //加载设计备注信息
//            var designMemoInfo = orderaddinfos.value(forKey: "remarks") as? String
//            if designMemoInfo == nil{
//                designMemoInfo = "无备注信息"
//            }else{
//                designMemoInfo = orderaddinfos.value(forKey: "remarks") as! String
//            }
//            orderMemosForDesignOrProducer.text = designMemoInfo
//
//            designFeeValue.text =  "¥\(priceInfoObjects.value(forKey: "designprice") as! Float)0"
//        }else if roleType == 3{
//            //加载工厂备注信息
//            var factoryMemoInfo = orderaddinfos.value(forKey: "fremarks") as? String
//            if factoryMemoInfo == nil{
//                factoryMemoInfo = "无备注信息"
//            }else{
//                factoryMemoInfo = orderaddinfos.value(forKey: "fremarks") as! String
//            }
//            orderMemosForDesignOrProducer.text = factoryMemoInfo
//        }else{
//            orderMemosForDesignOrProducer.text = "没有备注"
//        }
//        //加载完订单后，需要讲isOrderDetailsGets重置成false
//        isOrderDetailsGets = false
//    }
//
//    //显示报价窗口
//    func showBlurPopView(operaType:String){
//
//        var maxPrice = 5000.0
//        var currentValue:Float = 0.0
//
//        //mark  3 字 y = 60, 4字 y = 75
//        let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 150, y: 50, width: 200, height: 30))
//
//        //产品类型
//        let productTypeNameLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 175, width: 100, height: 30))
//        //工艺
//        let makeStyleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 200, width: 200, height: 30))
//        //附件
//        let accessoriesLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 225, width: 100, height: 30))
//
//        //订购数目
//        let orderCountLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 75, width: 100, height: 30))
//        //产品尺寸
//        //长
//        // x: 190
//        let productSizeOfLengthLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 100, width: 100, height: 30))
//        //宽
//        let productSizeOfWidthLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 100, width: 100, height: 30))
//        //高
//        let productSizeOfHeightLabel:UILabel = UILabel.init(frame: CGRect(x: 250, y: 100, width: 100, height: 30))
//        //圆形产品尺寸提示
//        let productSizeHintLabel:UILabel = UILabel.init(frame:CGRect(x: 130, y: 150, width: 200, height: 30))
//
//        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
//        orderDefaultPicLayer.backgroundColor = UIColor.gray
//        orderDefaultPicLayer.alpha = 0.4
//
//        orderDefaultPic.layer.borderColor = UIColor.gray.cgColor
//        orderDefaultPic.layer.borderWidth = 1
//        orderDefaultPic.layer.cornerRadius = 5
//
//        orderDefaultPicLayer.layer.borderColor = UIColor.clear.cgColor
//        orderDefaultPicLayer.layer.borderWidth = 1
//        orderDefaultPicLayer.layer.cornerRadius = 5
//
//        orderTimeLabel.text = "2017-10-16 09:00:00"
//        orderTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        orderTimeLabel.textColor = UIColor.gray
//
//        orderIDLabel.text = "订单号:"
//        orderIDLabel.font = UIFont.systemFont(ofSize: 13)
//        orderIDLabel.textColor = UIColor.gray
//
//        orderID.text = "000000000000000"
//        orderID.font = UIFont.systemFont(ofSize: 13)
//        orderID.textColor = UIColor.black
//
//        productTypeNameLabel.text = "产品类型:"
//        productTypeNameLabel.font = UIFont.systemFont(ofSize: 13)
//        productTypeNameLabel.textColor = UIColor.gray
//        productTypeNameValue.text = "..."
//        productTypeNameValue.font = UIFont.systemFont(ofSize: 14)
//        productTypeNameValue.textColor = UIColor.black
//
//
//        let tempMakeStyleValue = "..."
//        let texturenameValue = "..."
//        let colorValue = "..."
//        let shapeVlaue = "..."
//        let technologyValue = "..."
//
//        makeStyleLabel.text = "工艺:"
//        makeStyleLabel.font = UIFont.systemFont(ofSize: 13)
//        makeStyleLabel.textColor = UIColor.gray
//        makeStyleValue.text = tempMakeStyleValue
//        makeStyleValue.font = UIFont.systemFont(ofSize: 14)
//        makeStyleValue.textColor = UIColor.black
//
//        accessoriesLabel.text = "附件:"
//        accessoriesLabel.font = UIFont.systemFont(ofSize: 13)
//        accessoriesLabel.textColor = UIColor.gray
//        accessoriesValue.text = "..."
//        accessoriesValue.font = UIFont.systemFont(ofSize: 14)
//        accessoriesValue.textColor = UIColor.black
//
//        orderCountLabel.text = "数量"
//        orderCountLabel.font = UIFont.systemFont(ofSize: 13)
//        orderCountLabel.textColor = UIColor.gray
//
//        //设置产品数目
//        orderCountValue.text = "0" //"1000"
//
//        orderCountValue.font = UIFont.systemFont(ofSize: 14)
//        orderCountValue.textColor = UIColor.black
//
//        productSizeOfHeightLabel.text = "高(mm)"
//        productSizeOfHeightLabel.font = UIFont.systemFont(ofSize: 13)
//        productSizeOfHeightLabel.textColor = UIColor.gray
//        productSizeOfHeightValue.text = "0"
//
//        productSizeOfHeightValue.font = UIFont.systemFont(ofSize: 14)
//        productSizeOfHeightValue.textColor = UIColor.black
//
//        productSizeOfWidthLabel.text = "宽(mm) x"
//        productSizeOfWidthLabel.font = UIFont.systemFont(ofSize: 13)
//        productSizeOfWidthLabel.textColor = UIColor.gray
//        productSizeOfWidthValue.text = "0"
//        productSizeOfWidthValue.font = UIFont.systemFont(ofSize: 14)
//        productSizeOfWidthValue.textColor = UIColor.black
//
//        productSizeOfLengthLabel.text = "长(mm) x"
//        productSizeOfLengthLabel.font = UIFont.systemFont(ofSize: 13)
//        productSizeOfLengthLabel.textColor = UIColor.gray
//        productSizeOfLengthValue.text = "0"
//
//        productSizeOfLengthValue.font = UIFont.systemFont(ofSize: 14)
//        productSizeOfLengthValue.textColor = UIColor.black
//
//        productSizeHintLabel.text = "圆形产品直径参考长度（或宽度）值"
//        productSizeHintLabel.textColor = UIColor.gray
//        productSizeHintLabel.font = UIFont.systemFont(ofSize: 10)
//
//
//        //设置客户心理价(预算）
//        var mindPrice = 0
//        var quotePriceOfFactory = 0
//        let userInfo = getCurrentUserInfo()
//        roleType = Int(userInfo.value(forKey: "roletype")as! String) as! Int
//
//        let quotePriceAtLastTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 295, width: 200, height: 44))
//        quotePriceAtLastTimeLabel.text = "上次报价:"
//        quotePriceAtLastTimeLabel.textColor = UIColor.gray
//        quotePriceAtLastTimeLabel.font = UIFont.systemFont(ofSize: 14)
//        //设置上次报价
//        quotePriceAtLastTimeValue.text = "¥0.00"
//        quotePriceOfFactory = 0
//
//        quotePriceAtLastTimeValue.textColor = UIColor.orange
//        quotePriceAtLastTimeValue.font = UIFont.systemFont(ofSize: 16)
//
//        customerPriceLabel.text = "预算:"
//        customerPriceLabel.textColor = UIColor.gray
//        customerPriceLabel.font = UIFont.systemFont(ofSize: 14)
//
//        customerPriceValue.text = "¥0.00"
//        customerPriceValue.textColor = UIColor.orange
//        customerPriceValue.font = UIFont.systemFont(ofSize: 16)
//
//
//        let quotePriceCurrentLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 335, width: 200, height: 44))
//        quotePriceCurrentLabel.text = "设置当前报价:"
//        quotePriceCurrentLabel.textColor = UIColor.gray
//        quotePriceCurrentLabel.font = UIFont.systemFont(ofSize: 14)
//
//        let produceTimeCostLabel:UILabel = UILabel.init(frame: CGRect(x: 211, y: 335, width: 200, height: 44))
//        produceTimeCostLabel.text = "工期:"
//        produceTimeCostLabel.textColor = UIColor.gray
//        produceTimeCostLabel.font = UIFont.systemFont(ofSize: 14)
//
//        let produceTimeCostHintLabel:UILabel = UILabel.init(frame: CGRect(x: 311, y: 335, width: 200, height: 44))
//        produceTimeCostHintLabel.text = "天"
//        produceTimeCostHintLabel.textColor = UIColor.gray
//        produceTimeCostHintLabel.font = UIFont.systemFont(ofSize: 14)
//
//
//        quotePriceSlideBar.maximumValue = Float(maxPrice)
//        quotePriceSlideBar.minimumValue = 0.0
//        quotePriceSlideBar.isContinuous = true
//        quotePriceSlideBar.setValue(currentValue, animated: true)
//
//        quotePriceSlideBarRightLabel.text = "¥\(maxPrice)0"
//        quotePriceSlideBarRightLabel.textColor = UIColor.orange
//        quotePriceSlideBarRightLabel.font = UIFont.systemFont(ofSize: 10)
//        quotePriceSlideBarRightLabel.textAlignment = .right
//
//
//        quotePriceSlideBarMidLabel.text = "¥\(maxPrice/2)0"
//        quotePriceSlideBarMidLabel.textColor = UIColor.orange
//        quotePriceSlideBarMidLabel.font = UIFont.systemFont(ofSize: 10)
//        quotePriceSlideBarMidLabel.textAlignment = .center
//
//        quotePriceSlideBarLeftLabel.text = "¥0.00"
//        quotePriceSlideBarLeftLabel.textColor = UIColor.orange
//        quotePriceSlideBarLeftLabel.font = UIFont.systemFont(ofSize: 10)
//
//        quotePriceSlideBar.addTarget(self, action: #selector(quotePriceSliderBarValueChanged(_:)), for: .valueChanged)
//
//        currentValueOnSliderTextField.font = UIFont.systemFont(ofSize: 16)
//
//
//        blurPopView.backgroundColor = UIColor.white
//        blurPopView.layer.cornerRadius = 15
//
//
//        //分割线view for 订单信息
//        let seperateLineForOrderInfoView: UIView = UIView.init(frame: CGRect(x: 25, y: 30, width: 300, height: 1))
//        seperateLineForOrderInfoView.backgroundColor = UIColor.gray
//
//        let titleLabelOnLineForOrderInfoView:UILabel = UILabel.init(frame: CGRect(x: 135, y: 15, width: 80, height: 30))
//        titleLabelOnLineForOrderInfoView.text = "订单信息"
//        titleLabelOnLineForOrderInfoView.font = UIFont.systemFont(ofSize: 14)
//        titleLabelOnLineForOrderInfoView.textAlignment = .center
//        titleLabelOnLineForOrderInfoView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
//        titleLabelOnLineForOrderInfoView.backgroundColor = UIColor.white
//
//        //分割线view
//        let seperateLineView: UIView = UIView.init(frame: CGRect(x: 25, y: 280, width: 300, height: 1))
//        seperateLineView.backgroundColor = UIColor.gray
//        let titleLabelOnLineView:UILabel = UILabel.init(frame: CGRect(x: 155, y: 265, width: 40, height: 30))
//        titleLabelOnLineView.text = "报价"
//        titleLabelOnLineView.font = UIFont.systemFont(ofSize: 14)
//        titleLabelOnLineView.textAlignment = .center
//        titleLabelOnLineView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
//        titleLabelOnLineView.backgroundColor = UIColor.white
//
//        //关闭按钮
//        let closeQuotePriceBtn:UIButton = UIButton.init(type: .system)
//        closeQuotePriceBtn.frame = CGRect(x: 305, y: 5, width: 40, height: 40)
//        closeQuotePriceBtn.layer.backgroundColor = UIColor.white.cgColor
//        closeQuotePriceBtn.layer.cornerRadius = 20
//        let iconImage = UIImage(named:"close-red")?.withRenderingMode(.alwaysOriginal)
//        closeQuotePriceBtn.setImage(iconImage, for: UIControlState.normal)
//        //closeQuotePriceBtn.adjustsImageWhenHighlighted = false
//        closeQuotePriceBtn.addTarget(self, action: #selector(closeQuotePriceView), for: .touchUpInside)
//
//        //报价按钮
//        let confirmQuotePriceBtn:UIButton = UIButton.init(type: .system)
//        confirmQuotePriceBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
//        confirmQuotePriceBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
//        confirmQuotePriceBtn.layer.cornerRadius = 5
//        confirmQuotePriceBtn.setTitle("提交报价", for: .normal)
//        confirmQuotePriceBtn.setTitleColor(UIColor.white, for: .normal)
//
//        //设置或权重
//        setQuotePriceWeightBtn.frame = CGRect(x: -5, y: 437, width: 120, height: 40)
//        setQuotePriceWeightBtn.setTitle("调整报价精度", for: .normal)
//        setQuotePriceWeightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        setQuotePriceWeightBtn.titleLabel?.textAlignment = .left
//        setQuotePriceWeightBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
//        setQuotePriceWeightBtn.addTarget(self, action: #selector(setQuotePriceWeight), for: .touchUpInside)
//
//        //接受设计按钮
//        let accpetDesignBtn:UIButton = UIButton.init(type: .system)
//        accpetDesignBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
//        accpetDesignBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
//        accpetDesignBtn.layer.cornerRadius = 5
//        accpetDesignBtn.setTitle("接受设计", for: .normal)
//        accpetDesignBtn.setTitleColor(UIColor.white, for: .normal)
//
//        //接受生产按钮
//        let accpetProduceBtn:UIButton = UIButton.init(type: .system)
//        accpetProduceBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
//        accpetProduceBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
//        accpetProduceBtn.layer.cornerRadius = 5
//        accpetProduceBtn.setTitle("开始生产", for: .normal)
//        accpetProduceBtn.setTitleColor(UIColor.white, for: .normal)
//
//
//        confirmQuotePriceBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
//        accpetDesignBtn.addTarget(self, action: #selector(confirmAcceptDesignBtnClicked), for: .touchUpInside)
//        accpetProduceBtn.addTarget(self, action: #selector(confirmAcceptProduceBtnClicked), for: .touchUpInside)
//
//        currentValueOnSliderTextField.text = "\(currentValue)"
//
//        let orderMemosForDesignOrProducerLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 320, width: 200, height: 44))
//        orderMemosForDesignOrProducerLabel.textColor = UIColor.gray
//        orderMemosForDesignOrProducerLabel.font = UIFont.systemFont(ofSize: 14)
//        orderMemosForDesignOrProducerLabel.text = "设计备注"
//
//        //quotePriceSlideBarLeftLabel.text = "¥0.00"
//        designFeeValue.textColor = UIColor.orange
//        designFeeValue.font = UIFont.systemFont(ofSize: 16)
//        designFeeValue.text = ""
//
//        orderMemosForDesignOrProducer.text = ""
//        //根据身份判断显示字段和隐藏字段
//        if roleType == 2 {
//            //设计师角色
//            accpetDesignBtn.isHidden = false
//            accpetProduceBtn.isHidden = true
//            confirmQuotePriceBtn.isHidden = true
//            setQuotePriceWeightBtn.isHidden = true
//
//            //隐藏数量字段
//            orderCountLabel.isHidden = true
//            orderCountValue.isHidden = true
//            //高度（厚度）隐藏
//            productSizeOfHeightValue.isHidden = true
//            productSizeOfWidthLabel.text = "宽(mm)"
//            productSizeOfHeightLabel.isHidden = true
//
//            //调整长*宽显示位置
//            productSizeOfHeightLabel.frame = CGRect(x: 250, y: 75, width: 100, height: 30)
//            productSizeOfWidthLabel.frame = CGRect(x: 190, y: 75, width: 100, height: 30)
//            productSizeOfLengthLabel.frame = CGRect(x: 130, y: 75, width: 100, height: 30)
//            productSizeHintLabel.frame = CGRect(x: 130, y: 125, width: 200, height: 30)
//
//            productSizeOfHeightValue.frame = CGRect(x: 250, y: 100, width: 100, height: 30)
//            productSizeOfWidthValue.frame = CGRect(x: 190, y: 100, width: 100, height: 30)
//            productSizeOfLengthValue.frame = CGRect(x: 130, y: 100, width: 100, height: 30)
//
//
//
//            //隐藏上次报价，预算，当前报价，工期，拖动条等
//            quotePriceAtLastTimeLabel.isHidden = true
//            quotePriceAtLastTimeValue.isHidden = true
//            customerPriceLabel.isHidden = true
//            customerPriceValue.isHidden = true
//            quotePriceCurrentLabel.isHidden = true
//            currentValueOnSliderTextField.isHidden = true
//            produceTimeCostLabel.isHidden = true
//            produceTimeCostHintLabel.isHidden = true
//            produceTimeCostTextField.isHidden = true
//            quotePriceSlideBar.isHidden = true
//            quotePriceSlideBarMidLabel.isHidden = true
//            quotePriceSlideBarLeftLabel.isHidden = true
//            quotePriceSlideBarRightLabel.isHidden = true
//
//
//            //文案调整
//            titleLabelOnLineView.text = "设计备注"
//            titleLabelOnLineView.frame = CGRect(x: 135, y: 265, width: 80, height: 30)
//
//            let designFeeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 285, width: 200, height: 44))
//            designFeeLabel.textColor = UIColor.gray
//            designFeeLabel.font = UIFont.systemFont(ofSize: 14)
//            designFeeLabel.text = "设计费"
//
//            designFeeValue.isHidden = false
//            orderMemosForDesignOrProducerLabel.isHidden = false
//            orderMemosForDesignOrProducer.isHidden = false
//
//            blurPopView.addSubview(designFeeLabel)
//
//        }else if roleType == 3{
//            produceTimeCostTextField.text = ""
//            //显示数量字段
//            orderCountLabel.isHidden = false
//            orderCountValue.isHidden = false
//
//            //高度（厚度）隐藏
//            productSizeOfHeightValue.isHidden = false
//            productSizeOfWidthLabel.text = "宽(mm) x"
//            productSizeOfHeightLabel.isHidden = false
//
//            //隐藏设计费
//            designFeeValue.isHidden = true
//
//            orderMemosForDesignOrProducerLabel.text = "生产备注"
//
//            //工厂角色
//            if operaType == "quotePrice"{
//                accpetDesignBtn.isHidden = true
//                accpetProduceBtn.isHidden = true
//                confirmQuotePriceBtn.isHidden = false
//                setQuotePriceWeightBtn.isHidden = false
//
//                //文案调整
//                titleLabelOnLineView.text = "报价"
//
//                //显示上次报价，预算，当前报价，工期，拖动条等
//                quotePriceAtLastTimeLabel.isHidden = false
//                quotePriceAtLastTimeValue.isHidden = false
//                customerPriceLabel.isHidden = false
//                customerPriceValue.isHidden = false
//                quotePriceCurrentLabel.isHidden = false
//                currentValueOnSliderTextField.isHidden = false
//                produceTimeCostLabel.isHidden = false
//                produceTimeCostHintLabel.isHidden = false
//                produceTimeCostTextField.isHidden = false
//                produceTimeCostLabel.frame = CGRect(x: 211, y: 335, width: 200, height: 44)
//                produceTimeCostHintLabel.frame = CGRect(x: 311, y: 335, width: 200, height: 44) //335
//                produceTimeCostTextField.frame = CGRect(x: 250, y: 342, width: 56, height: 30) // 342
//                quotePriceSlideBar.isHidden = false
//                quotePriceSlideBarMidLabel.isHidden = false
//                quotePriceSlideBarLeftLabel.isHidden = false
//                quotePriceSlideBarRightLabel.isHidden = false
//
//                orderMemosForDesignOrProducerLabel.isHidden = true
//                orderMemosForDesignOrProducer.isHidden = true
//
//            }else if operaType == "acceptProduce"{
//                accpetDesignBtn.isHidden = true
//                accpetProduceBtn.isHidden = false
//                confirmQuotePriceBtn.isHidden = true
//                setQuotePriceWeightBtn.isHidden = true
//
//                //显示上次报价，预算，当前报价，工期，拖动条等
//                quotePriceAtLastTimeLabel.isHidden = false
//                quotePriceAtLastTimeLabel.text = "订单金额"
//                quotePriceAtLastTimeValue.isHidden = false
//                customerPriceLabel.isHidden = true
//                customerPriceValue.isHidden = true
//                quotePriceCurrentLabel.isHidden = true
//                currentValueOnSliderTextField.isHidden = true
//                produceTimeCostLabel.isHidden = false
//                produceTimeCostHintLabel.isHidden = false
//                produceTimeCostTextField.isHidden = false
//                produceTimeCostLabel.frame = CGRect(x: 211, y: 295, width: 200, height: 44)
//                produceTimeCostHintLabel.frame = CGRect(x: 311, y: 295, width: 200, height: 44) //335
//                produceTimeCostTextField.frame = CGRect(x: 250, y: 302, width: 56, height: 30) // 342
//                quotePriceSlideBar.isHidden = true
//                quotePriceSlideBarMidLabel.isHidden = true
//                quotePriceSlideBarLeftLabel.isHidden = true
//                quotePriceSlideBarRightLabel.isHidden = true
//
//                orderMemosForDesignOrProducerLabel.isHidden = false
//                orderMemosForDesignOrProducer.isHidden = false
//
//                //文案调整
//                titleLabelOnLineView.text = "订单备注"
//                titleLabelOnLineView.frame = CGRect(x: 135, y: 265, width: 80, height: 30)
//
//            }else{
//                //其他角色
//                accpetDesignBtn.isHidden = true
//                accpetProduceBtn.isHidden = true
//                confirmQuotePriceBtn.isHidden = true
//                print("error type")
//            }
//        }else {
//            //其他角色
//            accpetDesignBtn.isHidden = true
//            accpetProduceBtn.isHidden = true
//            confirmQuotePriceBtn.isHidden = true
//            print("error roleType")
//        }
//
//        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
//        customerPriceLabel.isHidden = true
//        customerPriceValue.isHidden = true
//
//
//        blurPopView.addSubview(designFeeValue)
//        blurPopView.addSubview(orderMemosForDesignOrProducer)
//        blurPopView.addSubview(orderMemosForDesignOrProducerLabel)
//
//
//        blurPopView.addSubview(accpetDesignBtn)
//        blurPopView.addSubview(setQuotePriceWeightBtn)
//        blurPopView.addSubview(accpetProduceBtn)
//        blurPopView.addSubview(produceTimeCostHintLabel)
//        blurPopView.addSubview(produceTimeCostLabel)
//        blurPopView.addSubview(produceTimeCostTextField)
//        blurPopView.addSubview(orderDefaultPic)
//        blurPopView.addSubview(orderTimeLabel)
//        blurPopView.addSubview(orderIDLabel)
//        blurPopView.addSubview(orderID)
//        blurPopView.addSubview(productTypeNameLabel)
//        blurPopView.addSubview(productTypeNameValue)
//        blurPopView.addSubview(makeStyleLabel)
//        blurPopView.addSubview(makeStyleValue)
//        blurPopView.addSubview(accessoriesLabel)
//        blurPopView.addSubview(accessoriesValue)
//        blurPopView.addSubview(orderCountLabel)
//        blurPopView.addSubview(orderCountValue)
//        blurPopView.addSubview(productSizeOfWidthLabel)
//        blurPopView.addSubview(productSizeOfWidthValue)
//        blurPopView.addSubview(productSizeOfLengthLabel)
//        blurPopView.addSubview(productSizeOfLengthValue)
//        blurPopView.addSubview(productSizeOfHeightLabel)
//        blurPopView.addSubview(productSizeOfHeightValue)
//        blurPopView.addSubview(productSizeHintLabel)
//        blurPopView.addSubview(quotePriceCurrentLabel)
//        blurPopView.addSubview(quotePriceAtLastTimeValue)
//        blurPopView.addSubview(quotePriceAtLastTimeLabel)
//        blurPopView.addSubview(customerPriceLabel)
//        blurPopView.addSubview(customerPriceValue)
//
//        blurPopView.addSubview(currentValueOnSliderTextField)
//        blurPopView.addSubview(quotePriceSlideBar)
//        blurPopView.addSubview(quotePriceSlideBarLeftLabel)
//        blurPopView.addSubview(quotePriceSlideBarMidLabel)
//        blurPopView.addSubview(quotePriceSlideBarRightLabel)
//        blurPopView.addSubview(seperateLineView)
//        blurPopView.addSubview(titleLabelOnLineView)
//        blurPopView.addSubview(seperateLineForOrderInfoView)
//        blurPopView.addSubview(titleLabelOnLineForOrderInfoView)
//        blurPopView.addSubview(closeQuotePriceBtn)
//        blurPopView.addSubview(confirmQuotePriceBtn)
//
//        blurPopView.backgroundColor = UIColor.white
//        blurPopView.layer.cornerRadius = 15
//
//        theChildViewNeedToClose.removeAll()
//
//        if roleType == 2 {
//            //设计师角色
//            let blurView = showBlurEffect(text: "接受设计")
//            workZoneVCObject.view.addSubview(blurView)
//            theChildViewNeedToClose.append(blurView)
//
//        }else if roleType == 3{
//            //工厂角色
//            if operaType == "quotePrice"{
//                let blurView = showBlurEffect(text: "订单报价")
//                workZoneVCObject.view.addSubview(blurView)
//                theChildViewNeedToClose.append(blurView)
//
//            }else if operaType == "acceptProduce"{
//                let blurView = showBlurEffect(text: "接受生产")
//                workZoneVCObject.view.addSubview(blurView)
//                theChildViewNeedToClose.append(blurView)
//            }else{
//                print("error type")
//            }
//        }else {
//            //其他角色
//            accpetDesignBtn.isHidden = true
//            accpetProduceBtn.isHidden = true
//            confirmQuotePriceBtn.isHidden = true
//            print("error roleType")
//        }
//
//
//        workZoneVCObject.view.addSubview(grayLayer)
//        workZoneVCObject.view.addSubview(blurPopView)
//
//
//        UIView.animate(withDuration: 0.3, animations: {()->Void in
//            self.blurPopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))
//        })
//
//
//        theChildViewNeedToClose.append(grayLayer)
//        theChildViewNeedToClose.append(blurPopView)
//    }
//
   

//    //创建毛玻璃效果
//    func showBlurEffect(text:String) -> UIVisualEffectView {
//        //创建一个模糊效果
//        let blurEffect = UIBlurEffect(style: .light)
//        //创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height )
//        let label = UILabel(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 100))
//        label.text = text
//        label.font = UIFont.systemFont(ofSize: 30)
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.textColor = UIColor.black
//        blurView.contentView.addSubview(label)
//        // blurView.contentView.addSubview(closeBtn)
//        return blurView
//    }
//
//
    
    @objc func retryBtnInViewClicked(){
        orderArray.removeAll()
        loadOrderDataFromServer(pages: 1, categoryType: .allOrderCategory)
    }

    override func viewWillAppear(_ animated: Bool) {        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
