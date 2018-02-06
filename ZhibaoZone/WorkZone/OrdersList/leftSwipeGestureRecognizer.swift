//
//  OrdersViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 03/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();

    var roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    var page: Int = 1
    var totalPageCount: Int = 1
    var selectorParamters = [Int:String]()

    //高度随角色和业务改变
    var theFooterViewHeightNeedChangeScale:Int = 0


    let WaitForDealingModelLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: 200, height: 30))
    let SwitchModelBtn:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70 , y: 10, width: 60, height: 30))
    
    lazy var currentValueOnSliderTextField:UITextField = {
        var tempSliderTextField = UITextField.init(frame: CGRect(x: 15, y: 100, width: 200, height: 30))
        return tempSliderTextField
    }()
    //定义灰层
    lazy var grayLayer:UIView = {
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.4
        return tempView
    }()
    
    lazy var AllOrdersTableView:UITableView = {
        //height -77 调好的
        var heightOfTableView = UIScreen.main.bounds.height - 96
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        return tempTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if roleType != 0 {
        //加载订单数据
        SwitchModelBtn.isOn = false
        SwitchModelBtn.addTarget(self, action: #selector(swithValueChanged), for: .valueChanged)
        WaitForDealingModelLabel.text = "仅显示待处理"
        WaitForDealingModelLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.view.addSubview(WaitForDealingModelLabel)
        self.view.addSubview(SwitchModelBtn)
        
        AllOrdersTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        AllOrdersTableView.isScrollEnabled = true
        AllOrdersTableView.rowHeight = UITableViewAutomaticDimension
        AllOrdersTableView.estimatedRowHeight = 300
        AllOrdersTableView.separatorStyle = .none//
        AllOrdersTableView.separatorColor = UIColor.clear// UIColor.clear
        //调试设计师
        loadOrderDataFromServer(pages: 1)
        
            //添加下拉刷新
            //addPullToRefresh(animator: header)
            AllOrdersTableView.es.addPullToRefresh {
                [weak self] in
                self?.refresh()
            }
            //添加上拉加载
                //addInfiniteScrolling(animator: footer)
            AllOrdersTableView.es.addInfiniteScrolling {
                [weak self] in
                self?.loadMore()
            }
        }
    }
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page = 1
            self.orderArray.removeAll()
            self.loadOrderDataFromServer(pages:self.page)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page)
                self.AllOrdersTableView.reloadData()
                self.AllOrdersTableView.es.stopLoadingMore()
            }else{
                self.AllOrdersTableView.es.noticeNoMoreData()

            }
        }
    }
    @objc func swithValueChanged(){
        orderArray.removeAll()
        AllOrdersTableView.removeFromSuperview()
        loadOrderDataFromServer(pages: 1)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrdersTableViewCell.customCell(tableView: AllOrdersTableView)
        cell.settingRoleTypeForCell(roleType: roleType,rowLocate:indexPath.row)
        
        if indexPath.row == 0{
            while cell.contentView.viewWithTag(65) != nil{
                cell.contentView.viewWithTag(65)?.removeFromSuperview()
            }//  view.tag = 65 //65分割线
        }
        if  indexPath.row >= orderArray.count{
            print("indexPath.row = \(indexPath.row), But orderArry.count = \(orderArray.count)")
        }
        let dictionaryObjectInOrderArray = orderArray[indexPath.row]
        let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray.value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        let priceInfoObjects = dictionaryObjectInOrderArray.value(forKey: "price") as! NSDictionary

        let accessoriesObject = goodsInfoObjects.value(forKey: "accessoriesname")
        let colorObject = goodsInfoObjects.value(forKey: "color")

        cell.orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        cell.orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
        cell.orderID.text = orderInfoObjects.value(forKey: "orderid") as? String
        cell.productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsname") as? String

        var makeStyleValue = ""
        var texturenameValue = ""
        if goodsInfoObjects.value(forKey: "texturename") as? String != nil{
            texturenameValue = goodsInfoObjects.value(forKey: "texturename") as! String
            makeStyleValue += texturenameValue
        }

        var colorValue = ""
        if colorObject as? String != nil {
            colorValue = colorObject as! String
            makeStyleValue += ",\(colorValue)"
        }
        var shapeVlaue = ""
        if goodsInfoObjects.value(forKey: "shape") as? String != nil{
            shapeVlaue = goodsInfoObjects.value(forKey: "shape") as! String
            makeStyleValue += ",\(shapeVlaue)"
        }

        var technologyValue = ""
        if goodsInfoObjects.value(forKey: "technology") as? String != nil{
            technologyValue = goodsInfoObjects.value(forKey: "technology") as! String
            makeStyleValue += ",\(technologyValue)"
        }
        cell.makeStyleValue.text = makeStyleValue//"锌合金,3D开模,滴胶,镀金色,还有几个字可以处理 "
        cell.accessoriesValue.text = accessoriesObject as? String//"蝴蝶扣"
        //设置产品数目
        if goodsInfoObjects.value(forKey: "number") as? Int != nil{
            cell.orderCountValue.text = "\(goodsInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            cell.orderCountValue.text = "" //"1000"
        }

        //设置产品尺寸
        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary
        if sizeObject.value(forKey: "length") as? Int != nil {
            cell.productSizeOfLengthValue.text = "\(sizeObject.value(forKey: "length")as! Int)"
        }else{
            cell.productSizeOfLengthValue.text = ""
        }

        if sizeObject.value(forKey: "width") as? Int != nil {
            cell.productSizeOfWidthValue.text = "\(sizeObject.value(forKey: "width")as! Int)"
        }else{
            cell.productSizeOfWidthValue.text = ""
        }

        if sizeObject.value(forKey: "height") as? Int != nil {
            cell.productSizeOfHeightValue.text = "\(sizeObject.value(forKey: "height")as! Int)"
        }else{
            cell.productSizeOfHeightValue.text = ""
        }

        //设置设计费
        if priceInfoObjects.value(forKey: "designprice") as? Int == nil{
            cell.designPriceValue.text = "¥18.00"
        }else{
            cell.designPriceValue.text = "¥\(priceInfoObjects.value(forKey: "designprice") as! Int).00"
        }
        //设置客户心理价
        if priceInfoObjects.value(forKey: "mindprice") as? Int == nil{
            cell.custoerPriceValue.text = "¥0.00"
        }else{
            cell.custoerPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Int).00"
        }
        //设置订单总价
        if priceInfoObjects.value(forKey: "finalprice") as? Int == nil{
            cell.orderTotalPrice.text = "¥0.00"
        }else{
            cell.orderTotalPrice.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Int).00"
        }
        //设置报价
        if priceInfoObjects.value(forKey: "returnprice") as? Int == nil{
            cell.returnPrinceValue.text = "¥0.00"
        }else{
            cell.returnPrinceValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Int).00"
        }

        cell.orderStatusValue.text = (statusObjects.value(forKey: "ordersheetstate") as! NSDictionary).value(forKey: "msg") as? String//"生产中"
        
        //是设计师，并且订单状态为2 的，显示接受设计按钮
        cell.acceptDesignOrderBtn.isHidden = true
        if roleType == 2 && ((statusObjects.value(forKey: "designreceivestate") as! NSDictionary).value(forKey: "code") as! Int == 2){
            cell.acceptDesignOrderBtn.isHidden = false
            cell.acceptDesignOrderBtn.addTarget(self, action: #selector(acceptDesignBtnClicked), for: .touchUpInside)

        }
        //是工厂角色，并且订单状态为1,2,3,4,5,6 的，显示报价按钮
        cell.quotePriceBtn.isHidden = true
        let acceptOrderFalg:[Int] = [1,2,3,4,5,6]
        if roleType == 3 && (acceptOrderFalg.contains(((statusObjects.value(forKey: "ordersheetstate") as! NSDictionary).value(forKey: "code") as! Int))){
            cell.quotePriceBtn.isHidden = false
            //设置调用带参数的方法
            //let methodA = #selector(quotePriceBtnClicked as (IndexPath) -> ())
            selectorParamters[indexPath.row] = "\(indexPath.row)"
            //selectorParamters  ("\(indexPath.row)", forKey: "\(indexPath.row)")
            cell.quotePriceBtn.tag = indexPath.row//value(forKey: <#T##String#>)
            cell.quotePriceBtn.addTarget(self, action:#selector(quotePriceBtnClicked), for: .touchUpInside)
        }
        //是工厂，并且订单状态为7 的，显示开始生产按钮
        cell.acceptProduceOrderBtn.isHidden = true
        if roleType == 2 && ((statusObjects.value(forKey: "ordersheetstate") as! NSDictionary).value(forKey: "code") as? String == "7"){
            cell.acceptProduceOrderBtn.isHidden = false
            cell.acceptProduceOrderBtn.addTarget(self, action: #selector(acceptProduceBtnClicked), for: .touchUpInside)

        }
        
        cell.designStatusValue.text = (statusObjects.value(forKey: "designstate") as! NSDictionary).value(forKey: "msg") as? String//"已设计"
        cell.returnPriceStatusValue.text = (statusObjects.value(forKey: "quotestate") as! NSDictionary).value(forKey: "msg") as? String//"已报价"
        cell.paymentStatusValue.text = (statusObjects.value(forKey: "payoffstate") as! NSDictionary).value(forKey: "msg") as? String//"已付款"
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dictionaryObjectInOrderArray = orderArray[indexPath.row]
        let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        var changeHeightFlags:CGFloat = 280
        let ordersWhichNeedToChangeHeight:[Int] = [1,2,3,4,5,6]
        //是设计师，并且订单状态为2 的，显示接受设计按钮
        if roleType == 2 && ((statusObjects.value(forKey: "designreceivestate") as! NSDictionary).value(forKey: "code") as! Int == 2){
            changeHeightFlags = 320
        }
        
        //是工厂角色，并且订单状态为1,2,3,4,5,6 的，显示报价按钮
        if roleType == 3 && ((ordersWhichNeedToChangeHeight.contains((statusObjects.value(forKey: "ordersheetstate") as! NSDictionary).value(forKey: "code") as! Int))){
            changeHeightFlags = 320
        }
        //是工厂，并且订单状态为7 的，显示开始生产按钮
        if roleType == 3 && ((statusObjects.value(forKey: "ordersheetstate") as! NSDictionary).value(forKey: "code") as! Int == 7){
            changeHeightFlags = 320
        }
        if roleType == 1{
            changeHeightFlags = 280
        }
        
        theFooterViewHeightNeedChangeScale = Int(changeHeightFlags)

        return changeHeightFlags
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1//CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        return view
    }
    
    func loadOrderDataFromServer(pages:Int) {
        //去除未完成的数据请求
        for task in OrdersViewController.requestCacheArr{
            task.cancel()
        }
        OrdersViewController.requestCacheArr.removeAll()
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
        if !self.view.subviews.contains(AllOrdersTableView) {
            self.view.addSubview(imageView)
            self.view.addSubview(noticeWhenLoadingData)
        }
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        var allOrdersURL:String = ""
        #if DEBUG
            if SwitchModelBtn.isOn {
                allOrdersURL = apiAddresses.value(forKey: "orderListOfNeedHandleDebug") as! String
            }else{
                allOrdersURL = apiAddresses.value(forKey: "orderListOfAllOrdersDebug") as! String
            }
        #else
            if SwitchModelBtn.isOn {
                allOrdersURL = apiAddresses.value(forKey: "orderListOfNeedHandle") as! String
                
            }else{
                allOrdersURL = apiAddresses.value(forKey: "orderListOfAllOrders") as! String
            }
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
                //调试设计师
                params["roletype"] = info.roleType
                if SwitchModelBtn.isOn {
                    params["workflow"] = 19 // 待处理 19
                }else{
                    params["workflow"] = 18 // 待处理 19
                }
                params["searchday"] = 30
                params["fromtime"] = "2016"
                params["totime"] = "2018"
                params["ordernumofsheet"] = 5
                params["ordersheet"] = pages
                params["ranktype"] = 1
                params["inorder"] = 0
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
        
        let dataRequest = Alamofire.request(allOrdersURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            let json = JSON(responseObject.result.value)
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
                        if !self.view.subviews.contains(self.AllOrdersTableView) {
                            self.view.addSubview(self.AllOrdersTableView)
                            imageView.removeFromSuperview()
                            noticeWhenLoadingData.removeFromSuperview()
                        }
                        self.AllOrdersTableView.reloadData()
                            self.AllOrdersTableView.es.stopPullToRefresh()
                    }else{
                        if self.page == 1{
                            imageView.removeFromSuperview()
                            noticeWhenLoadingData.removeFromSuperview()
                            self.emytyAreaShowingLabel(withRetry: true)
                        }else{
                            self.AllOrdersTableView.es.noticeNoMoreData()
                        }
                    }
            }
            case false:
                    if self.view.subviews.contains(self.AllOrdersTableView) {
                        self.AllOrdersTableView.removeFromSuperview()
                    }else{
                        imageView.removeFromSuperview()
                        noticeWhenLoadingData.removeFromSuperview()
                    }
                    if responseObject.result.error?.localizedDescription != "cancelled" && responseObject.result.error?.localizedDescription as! String != "已取消"{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print(responseObject.result.error ?? "No result found")
                            greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
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
        OrdersViewController.requestCacheArr.append(dataRequest)
    }
    
    @objc func quotePriceBtnClicked(_ button:UIButton){
        
        grayLayer.removeGestureRecognizer(leftSwipeGestureRecognizer)
        let quotePriceSlideBar:UISlider = UISlider.init(frame: CGRect(x: 15, y: 200, width: 220, height: 30))
        
        var maxPrice = 5000.0
        var selectedIndex = 0
        var currentValue:Float = 0.0
        for row in selectorParamters.values{
            if row == "\(button.tag)"{
                selectedIndex = button.tag
            }
        }
        
        let dictionaryObjectInOrderArray = orderArray[selectedIndex]
        let priceInfoObjects = dictionaryObjectInOrderArray.value(forKey: "price") as! NSDictionary
        
        //优先客户心理价，再估价，再系统估价
        if priceInfoObjects.value(forKey: "mindprice") as? Int == nil{
            maxPrice = 5000.0
        }else{
            currentValue = Float(priceInfoObjects.value(forKey: "mindprice") as! Int)
            maxPrice = Double((priceInfoObjects.value(forKey: "mindprice") as! Int)*3)
        }

        
        quotePriceSlideBar.maximumValue = Float(maxPrice)
        quotePriceSlideBar.minimumValue = 0.0
        quotePriceSlideBar.isContinuous = true
        quotePriceSlideBar.setValue(currentValue, animated: true)
        quotePriceSlideBar.addTarget(self, action: #selector(quotePriceSliderBarValueChanged(_:)), for: .valueChanged)
        
        let quotePricePopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 250)/2, y: (UIScreen.main.bounds.height - 250)/2 - 100, width: 250, height: 300))
        quotePricePopView.backgroundColor = UIColor.white
        quotePricePopView.layer.cornerRadius = 5
        
        let titleOfQuotePrice:UILabel = UILabel.init(frame: CGRect(x:95 , y: 15, width: 200, height: 30))
        titleOfQuotePrice.text = "对订单报价\(selectedIndex)"
        titleOfQuotePrice.font = UIFont.boldSystemFont(ofSize: 16)
        titleOfQuotePrice.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        currentValueOnSliderTextField.text = "\(currentValue)"
        
        self.view.addSubview(grayLayer)
        
        quotePricePopView.addSubview(currentValueOnSliderTextField)
        quotePricePopView.addSubview(quotePriceSlideBar)
        quotePricePopView.addSubview(titleOfQuotePrice)
        self.view.addSubview(quotePricePopView)
    }
    @objc func quotePriceSliderBarValueChanged(_ slider:UISlider){
        currentValueOnSliderTextField.text = "\(slider.value)0"
    }
    @objc func acceptDesignBtnClicked(){
        print("接受设计按钮点击了")

    }
    @objc func acceptProduceBtnClicked(){
        print("开始生产按钮点击了")

    }
    
    @objc func retryBtnInViewClicked(){
        orderArray.removeAll()
        loadOrderDataFromServer(pages: page)
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
                self.roleType = Int(info.roleType)
                try managedObjectContext.save()
            }
        } catch  {
            fatalError("获取失败")
        }
        if roleType == 0{
            emytyAreaShowingLabel()
        }
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        //什么都没有
        let sizeOfNothing:Int = Int(UIScreen.main.bounds.width - 200)
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 200, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 20 , width: 200, height: 44))
        nothingToSHowLabel.text = "这里还什么都没有呢"
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
        let sizeOfNothing:Int = Int(UIScreen.main.bounds.width - 200)
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 200, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 20 , width: 200, height: 44))
        nothingToSHowLabel.text = "这里还什么都没有呢"
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        self.view.addSubview(nothingToShow)
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

