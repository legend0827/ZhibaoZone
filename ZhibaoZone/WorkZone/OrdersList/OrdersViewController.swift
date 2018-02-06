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
import PagingMenuController

class OrdersViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    var downloadURLHeader = ""

    var roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    var page: Int = 1
    var totalPageCount: Int = 1
    var selectorParamters = [Int:String]()
    var theChildViewNeedToClose:[UIView] = []
    //接收workzone对象
    var workZoneVCObject = WorkZoneViewController()

    //高度随角色和业务改变
    var theFooterViewHeightNeedChangeScale:Int = 0


    let WaitForDealingModelLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: 200, height: 30))
    let SwitchModelBtn:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70 , y: 10, width: 60, height: 30))
    //y 最终等于110
    let quotePricePopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 350)/2, y: UIScreen.main.bounds.height, width: 350, height: 500))
    
    let quotePriceSlideBarRightLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    let quotePriceSlideBarMidLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 320, height: 30))
    let quotePriceSlideBarLeftLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 250, height: 30))
    
    lazy var quotePriceSlideBar:UISlider = {
        var tempSliderBar = UISlider.init(frame: CGRect(x: 15, y: 390, width: 320, height: 20))
        return tempSliderBar
    }()

    lazy var currentValueOnSliderTextField:UITextField = {
        //label值55，当前值62 差 7
        var tempSliderTextField = UITextField.init(frame: CGRect(x: 110, y: 342, width: 225, height: 30))
        tempSliderTextField.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempSliderTextField.layer.cornerRadius = 5
        tempSliderTextField.delegate = self
        return tempSliderTextField
    }()
    //定义毛玻璃灰层
    lazy var grayLayer:UIView = {
        //y= 64表示要显示上方的切换按钮
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.2
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if debug
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        #endif
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
            currentValueOnSliderTextField.keyboardType = .decimalPad
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

        if orderInfoObjects.value(forKey: "goodsimage") as? String == nil{
            cell.orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        }else{
            
            let imageURLString:String = "\(downloadURLHeader)\(orderInfoObjects.value(forKey: "goodsimage") as! String)" //"http://ww2.sinaimg.cn/bmiddle/632dab64jw1ehgcjf2rd5j20ak07w767.jpg";
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage(data: data)
                cell.orderDefaultPic.image = image//  UIImage(image:image)
            }catch{
                print(error)
            }
           
        }
        cell.orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
        cell.orderID.text = orderInfoObjects.value(forKey: "orderid") as? String
        cell.productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsclass") as? String

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
        cell.makeStyleValue.text = tempMakeStyleValue//"锌合金,3D开模,滴胶,镀金色,还有几个字可以处理 "
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
        var mindPrice = 0
        var quotePriceOfFactory = 0
        if priceInfoObjects.value(forKey: "mindprice") as? Int == nil{
            cell.custoerPriceValue.text = "¥0.00"
        }else{
            cell.custoerPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Int).00"
            mindPrice = priceInfoObjects.value(forKey: "mindprice") as! Int
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
            quotePriceOfFactory = priceInfoObjects.value(forKey: "returnprice") as! Int
        }
        
        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
        if (mindPrice > quotePriceOfFactory)&&(roleType == 3){
            cell.custoerPriceLabel.isHidden = true
            cell.custoerPriceValue.isHidden = true
        }else{
            cell.custoerPriceLabel.isHidden = false
            cell.custoerPriceValue.isHidden = false
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
            selectorParamters[indexPath.row] = "\(indexPath.row)"
            cell.quotePriceBtn.tag = indexPath.row
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
//    //响应手势识别
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touchedArea:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
//        let touchedPoint:CGPoint = (touches.first?.location(in: self.view))!
//
//        if touchedArea.contains(touchedPoint) {
//            print("touched the grey layer area")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.removeFromSuperview()
//        }
//    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        if (touch.view?.isDescendant(of: grayLayer))!{
//            return false
//        }
//        return true
//    }
    //点击报价按钮
    @objc func quotePriceBtnClicked(_ button:UIButton){
        
        //分割线view for 订单信息
        let seperateLineForOrderInfoView: UIView = UIView.init(frame: CGRect(x: 25, y: 30, width: 300, height: 1))
        seperateLineForOrderInfoView.backgroundColor = UIColor.gray
        
        let titleLabelOnLineForOrderInfoView:UILabel = UILabel.init(frame: CGRect(x: 135, y: 15, width: 80, height: 30))
        titleLabelOnLineForOrderInfoView.text = "订单信息"
        titleLabelOnLineForOrderInfoView.font = UIFont.systemFont(ofSize: 14)
        titleLabelOnLineForOrderInfoView.textAlignment = .center
        titleLabelOnLineForOrderInfoView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        titleLabelOnLineForOrderInfoView.backgroundColor = UIColor.white
        

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
       // let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray.value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        
        let accessoriesObject = goodsInfoObjects.value(forKey: "accessoriesname")
        let colorObject = goodsInfoObjects.value(forKey: "color")
        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary

        
        //mark  3 字 y = 60, 4字 y = 75
        let orderTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 50, width: 200, height: 30))
        let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 150, y: 50, width: 200, height: 30))
        let orderID:UILabel = UILabel.init(frame: CGRect(x: 198, y: 50, width: 150, height: 30))
        
        //参考图
        let orderDefaultPic: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 75, width: 100, height: 100))
        
        //产品类型
        let productTypeNameLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 175, width: 100, height: 30))
        let productTypeNameValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 175, width: 250, height: 30))
        //工艺
        let makeStyleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 200, width: 200, height: 30))
        let makeStyleValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 200, width: 280, height: 30))
        //附件
        let accessoriesLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 225, width: 100, height: 30))
        let accessoriesValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 225, width: 280, height: 30))
        
        //订购数目
        let orderCountLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 75, width: 100, height: 30))
        let orderCountValue:UILabel = UILabel.init(frame: CGRect(x: 160, y: 75, width: 100, height: 30))
        //产品尺寸
        //长
        // x: 190
        let productSizeOfLengthLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 100, width: 100, height: 30))
        let productSizeOfLengthValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))
        //宽
        let productSizeOfWidthLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 100, width: 100, height: 30))
        let productSizeOfWidthValue:UILabel = UILabel.init(frame: CGRect(x: 190, y: 125, width: 100, height: 30))
        //高
        let productSizeOfHeightLabel:UILabel = UILabel.init(frame: CGRect(x: 250, y: 100, width: 100, height: 30))
        let productSizeOfHeightValue:UILabel = UILabel.init(frame: CGRect(x: 250, y: 125, width: 100, height: 30))
        //圆形产品尺寸提示
        let productSizeHintLabel:UILabel = UILabel.init(frame:CGRect(x: 130, y: 150, width: 200, height: 30))
        
        //分割线view
        let seperateLineView: UIView = UIView.init(frame: CGRect(x: 25, y: 280, width: 300, height: 1))
        seperateLineView.backgroundColor = UIColor.gray
        let titleLabelOnLineView:UILabel = UILabel.init(frame: CGRect(x: 155, y: 265, width: 40, height: 30))
        titleLabelOnLineView.text = "报价"
        titleLabelOnLineView.font = UIFont.systemFont(ofSize: 14)
        titleLabelOnLineView.textAlignment = .center
        titleLabelOnLineView.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        titleLabelOnLineView.backgroundColor = UIColor.white
        
        
        //设置值
        let imageURLString:String = "\(downloadURLHeader)\(orderInfoObjects.value(forKey: "goodsimage") as! String)" //"http://ww2.sinaimg.cn/bmiddle/632dab64jw1ehgcjf2rd5j20ak07w767.jpg";
        let url = URL(string: imageURLString)!
        do{
            let data = try Data.init(contentsOf: url)
            let image = UIImage(data: data)
            orderDefaultPic.image = image//  UIImage(image:image)
        }catch{
            print(error)
        }
        orderDefaultPic.layer.borderColor = UIColor.gray.cgColor
        orderDefaultPic.layer.borderWidth = 1
        orderDefaultPic.layer.cornerRadius = 5
        
        orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
        orderTimeLabel.font = UIFont.systemFont(ofSize: 13)
        orderTimeLabel.textColor = UIColor.gray
        
        orderIDLabel.text = "订单号:"
        orderIDLabel.font = UIFont.systemFont(ofSize: 13)
        orderIDLabel.textColor = UIColor.gray
        
        orderID.text = orderInfoObjects.value(forKey: "orderid") as? String
        orderID.font = UIFont.systemFont(ofSize: 13)
        orderID.textColor = UIColor.black
        
        productTypeNameLabel.text = "产品类型:"
        productTypeNameLabel.font = UIFont.systemFont(ofSize: 13)
        productTypeNameLabel.textColor = UIColor.gray
        productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsclass") as? String
        productTypeNameValue.font = UIFont.systemFont(ofSize: 14)
        productTypeNameValue.textColor = UIColor.black

        
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


        makeStyleLabel.text = "工艺:"
        makeStyleLabel.font = UIFont.systemFont(ofSize: 13)
        makeStyleLabel.textColor = UIColor.gray
        makeStyleValue.text = tempMakeStyleValue
        makeStyleValue.font = UIFont.systemFont(ofSize: 14)
        makeStyleValue.textColor = UIColor.black
        
        accessoriesLabel.text = "附件:"
        accessoriesLabel.font = UIFont.systemFont(ofSize: 13)
        accessoriesLabel.textColor = UIColor.gray
        accessoriesValue.text = accessoriesObject as? String
        accessoriesValue.font = UIFont.systemFont(ofSize: 14)
        accessoriesValue.textColor = UIColor.black
        
        orderCountLabel.text = "数量"
        orderCountLabel.font = UIFont.systemFont(ofSize: 13)
        orderCountLabel.textColor = UIColor.gray
        
        //设置产品数目
        if goodsInfoObjects.value(forKey: "number") as? Int != nil{
            orderCountValue.text = "\(goodsInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            orderCountValue.text = ""
        }
        orderCountValue.font = UIFont.systemFont(ofSize: 14)
        orderCountValue.textColor = UIColor.black
        
        productSizeOfHeightLabel.text = "高(mm)"
        productSizeOfHeightLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfHeightLabel.textColor = UIColor.gray
        if sizeObject.value(forKey: "height") as? Int != nil {
            productSizeOfHeightValue.text = "\(sizeObject.value(forKey: "height")as! Int)"
        }else{
            productSizeOfHeightValue.text = ""
        }
        productSizeOfHeightValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfHeightValue.textColor = UIColor.black
        
        productSizeOfWidthLabel.text = "宽(mm) x"
        productSizeOfWidthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfWidthLabel.textColor = UIColor.gray
        
        if sizeObject.value(forKey: "width") as? Int != nil {
            productSizeOfWidthValue.text = "\(sizeObject.value(forKey: "width")as! Int)"
        }else{
            productSizeOfWidthValue.text = ""
        }
        productSizeOfWidthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfWidthValue.textColor = UIColor.black
        
        productSizeOfLengthLabel.text = "长(mm) x"
        productSizeOfLengthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfLengthLabel.textColor = UIColor.gray
        
        if sizeObject.value(forKey: "length") as? Int != nil {
            productSizeOfLengthValue.text = "\(sizeObject.value(forKey: "length")as! Int)"
        }else{
            productSizeOfLengthValue.text = ""
        }
        productSizeOfLengthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfLengthValue.textColor = UIColor.black
        
        productSizeHintLabel.text = "圆形产品直径参考长度（或宽度）值"
        productSizeHintLabel.textColor = UIColor.gray
        productSizeHintLabel.font = UIFont.systemFont(ofSize: 10)
        
        
        
        //优先客户心理价，再估价，再系统估价
        if priceInfoObjects.value(forKey: "mindprice") as? Int == nil{
            maxPrice = 5000.0
        }else{
            currentValue = Float(priceInfoObjects.value(forKey: "mindprice") as! Int)
            maxPrice = Double((priceInfoObjects.value(forKey: "mindprice") as! Int)*3)
        }

        //设置客户心理价(预算）
        var mindPrice = 0
        var quotePriceOfFactory = 0
        
        let quotePriceAtLastTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 295, width: 200, height: 44))
        quotePriceAtLastTimeLabel.text = "上次报价:"
        quotePriceAtLastTimeLabel.textColor = UIColor.gray
        quotePriceAtLastTimeLabel.font = UIFont.systemFont(ofSize: 14)
        let quotePriceAtLastTimeValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
        //设置上次报价
        if priceInfoObjects.value(forKey: "returnprice") as? Int == nil{
            quotePriceAtLastTimeValue.text = "¥0.00"
        }else{
            quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Int).00"
            quotePriceOfFactory = priceInfoObjects.value(forKey: "returnprice") as! Int
        }
        quotePriceAtLastTimeValue.textColor = UIColor.orange
        quotePriceAtLastTimeValue.font = UIFont.systemFont(ofSize: 16)

        let customerPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))
        customerPriceLabel.text = "预算:"
        customerPriceLabel.textColor = UIColor.gray
        customerPriceLabel.font = UIFont.systemFont(ofSize: 14)
        let customerPriceValue:UILabel = UILabel.init(frame: CGRect(x: 225, y: 295, width: 200, height: 44))
        if priceInfoObjects.value(forKey: "mindprice") as? Int == nil{
            customerPriceValue.text = "¥0.00"
        }else{
            customerPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Int).00"
            mindPrice = priceInfoObjects.value(forKey: "mindprice") as! Int
        }
        customerPriceValue.textColor = UIColor.orange
        customerPriceValue.font = UIFont.systemFont(ofSize: 16)
        
        
        let quotePriceCurrentLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 335, width: 200, height: 44))
        quotePriceCurrentLabel.text = "设置当前报价:"
        quotePriceCurrentLabel.textColor = UIColor.gray
        quotePriceCurrentLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
        if (mindPrice > quotePriceOfFactory)&&(roleType == 3){
            customerPriceLabel.isHidden = true
            customerPriceValue.isHidden = true
        }else{
            customerPriceLabel.isHidden = false
            customerPriceValue.isHidden = false
        }
        
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
        

        quotePricePopView.backgroundColor = UIColor.white
        quotePricePopView.layer.cornerRadius = 15
        
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
        confirmQuotePriceBtn.frame = CGRect(x: 305-110, y: 455, width: 120, height: 40)
        confirmQuotePriceBtn.layer.backgroundColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)//UIColor.white.cgColor
        confirmQuotePriceBtn.layer.cornerRadius = 5
        confirmQuotePriceBtn.setTitle("提交报价", for: .normal)
        confirmQuotePriceBtn.setTitleColor(UIColor.white, for: .normal)
        
        confirmQuotePriceBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
        
       
        
        currentValueOnSliderTextField.text = "\(currentValue)"
        
        quotePricePopView.addSubview(orderDefaultPic)
        quotePricePopView.addSubview(orderTimeLabel)
        quotePricePopView.addSubview(orderIDLabel)
        quotePricePopView.addSubview(orderID)
        quotePricePopView.addSubview(productTypeNameLabel)
        quotePricePopView.addSubview(productTypeNameValue)
        quotePricePopView.addSubview(makeStyleLabel)
        quotePricePopView.addSubview(makeStyleValue)
        quotePricePopView.addSubview(accessoriesLabel)
        quotePricePopView.addSubview(accessoriesValue)
        quotePricePopView.addSubview(orderCountLabel)
        quotePricePopView.addSubview(orderCountValue)
        quotePricePopView.addSubview(productSizeOfWidthLabel)
        quotePricePopView.addSubview(productSizeOfWidthValue)
        quotePricePopView.addSubview(productSizeOfLengthLabel)
        quotePricePopView.addSubview(productSizeOfLengthValue)
        quotePricePopView.addSubview(productSizeOfHeightLabel)
        quotePricePopView.addSubview(productSizeOfHeightValue)
        quotePricePopView.addSubview(productSizeHintLabel)
        quotePricePopView.addSubview(quotePriceCurrentLabel)
        quotePricePopView.addSubview(quotePriceAtLastTimeValue)
        quotePricePopView.addSubview(quotePriceAtLastTimeLabel)
        quotePricePopView.addSubview(customerPriceLabel)
        quotePricePopView.addSubview(customerPriceValue)

        
        quotePricePopView.addSubview(currentValueOnSliderTextField)
        quotePricePopView.addSubview(quotePriceSlideBar)
        quotePricePopView.addSubview(quotePriceSlideBarLeftLabel)
        quotePricePopView.addSubview(quotePriceSlideBarMidLabel)
        quotePricePopView.addSubview(quotePriceSlideBarRightLabel)
        quotePricePopView.addSubview(seperateLineView)
        quotePricePopView.addSubview(titleLabelOnLineView)
        quotePricePopView.addSubview(seperateLineForOrderInfoView)
        quotePricePopView.addSubview(titleLabelOnLineForOrderInfoView)
        quotePricePopView.addSubview(closeQuotePriceBtn)
        quotePricePopView.addSubview(confirmQuotePriceBtn)
        
        let blurView = showBlurEffect(text: "订单报价")

        workZoneVCObject.view.addSubview(grayLayer)
        workZoneVCObject.view.addSubview(blurView)
        workZoneVCObject.view.addSubview(quotePricePopView)
        
        
        UIView.animate(withDuration: 0.3, animations: {()->Void in
            self.quotePricePopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))
        })
        
        theChildViewNeedToClose.removeAll()
        
        theChildViewNeedToClose.append(grayLayer)
        theChildViewNeedToClose.append(blurView)
        theChildViewNeedToClose.append(quotePricePopView)
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
                if childViews.isEqual(self.quotePricePopView){
                    for quotePriveSubViews in self.quotePricePopView.subviews{
                        quotePriveSubViews.removeFromSuperview()
                    }
                }
            }
        })
    }
    
    @objc func confirmQuotePriceBtnClicked(){
        
        print("定价按钮点击了")
    }
    @objc func quotePriceSliderBarValueChanged(_ slider:UISlider){
        
        currentValueOnSliderTextField.text = "\(Int(slider.value)).00"
    }
    @objc func acceptDesignBtnClicked(){
        print("接受设计按钮点击了")

    }
    // 输入框的值发生变化
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentValueOnSliderTextField.resignFirstResponder()
        let sliderValue = currentValueOnSliderTextField.text
        if Float(sliderValue as! String)! > quotePriceSlideBar.maximumValue {
            quotePriceSlideBar.maximumValue = Float(sliderValue as! String)!
        }
        quotePriceSlideBar.setValue(Float(sliderValue as! String)!, animated: true)
        quotePriceSlideBarRightLabel.text = "¥\(quotePriceSlideBar.maximumValue)0"
        quotePriceSlideBarMidLabel.text = "¥\(quotePriceSlideBar.maximumValue/2)0"
        quotePriceSlideBarLeftLabel.text = "¥0.00"
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
                self.quotePricePopView.transform = CGAffineTransform(translationX: 0, y:-(UIScreen.main.bounds.height + 130)) //-(height+300)+200
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
                self.quotePricePopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))// -(height-35)+200  -632
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



