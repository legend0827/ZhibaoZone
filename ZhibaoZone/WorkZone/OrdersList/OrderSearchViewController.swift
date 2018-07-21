 //
//  OrderSearchViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class OrderSearchViewController: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //搜索类型
    var _searchModel:searchContentsType = .orderidOnly
    //角色类型
    var _roleType:Int = 3
    let searchBar:UITextField = UITextField.init(frame: CGRect(x: 15, y: 8, width: kWidth - 85 , height: 28))
    let titleBarBackground:UIView = UIView.init(frame: CGRect(x: 0, y: 20+heightChangeForiPhoneXFromTop, width: kWidth, height: 45))
    let cancelSearchBtn:UIButton = UIButton.init(frame: CGRect(x: kWidth - 55, y: 12, width: 40, height: 22))
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    //用户角色信息
    var _userid:String?
    var _token:String?
    
    var orderCount = 0//订单数目
    var orderArray:[NSDictionary] = []
    var page: Int = 1
    var totalPageCount: Int = 1
    var selectorParamters = [Int:String]()
    
    //选择的订单的index
    var selectedIndex = 0
    
    //搜索字符
    var searchText = ""
    
    //tabbarController
    var tabbarObject = TabBarController(royeType: 3)
    //加载中的动画集合
    var theLoadingViewNeedsToBeKill:[UIView] = []
    
    let CELL_ID = "cell_id";
    
    lazy var orderSearchCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kWidth ,height: 202)  //设置item尺寸
        layout.minimumLineSpacing = 0  //上下间隔
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 15, bottom: 5, right: 15)            //section四周的缩进
        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 68+heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 70),collectionViewLayout:layout)
        tempCollectionView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.isScrollEnabled = true // 允许拖动
        tempCollectionView.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        tempCollectionView.register(OrderSearchCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        return tempCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let promptLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 100, width: kWidth-40, height: 22))
//        promptLabel.text = "未进行搜索"
//        promptLabel.textColor = UIColor.titleColors(color: .lightGray)
//        promptLabel.textAlignment = .center
//        self.view.addSubview(promptLabel)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        setStatusBarBackgroundColor(color: .backgroundColors(color: .red))
        
        titleBarBackground.backgroundColor = UIColor.backgroundColors(color: .red)
       
        //设置搜索栏
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        searchBar.leftViewMode = UITextFieldViewMode.always
        searchBar.clearButtonMode = UITextFieldViewMode.always
        searchBar.returnKeyType = UIReturnKeyType.search
        searchBar.tintColor = UIColor.white
        searchBar.layer.cornerRadius = 6
        searchBar.textColor = UIColor.titleColors(color: .white)
        searchBar.backgroundColor = UIColor.lineColors(color: .red)
        
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.white]
        if _searchModel == .orderidOnly{
            searchBar.attributedPlaceholder = NSAttributedString(string: "输入订单号进行搜索", attributes: attributes)
        }else{
            searchBar.attributedPlaceholder = NSAttributedString(string: "输入旺旺号或订单号进行搜索", attributes: attributes)
        }
        //用户名输入框左侧图标
        let imgSearch = UIImageView(frame: CGRect(x: 7, y: 7, width: 14, height: 14))
        imgSearch.image = UIImage(named:"searchicon")
        searchBar.leftView!.addSubview(imgSearch)


        cancelSearchBtn.setTitle("取消", for: .normal)
        cancelSearchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelSearchBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        cancelSearchBtn.setTitleColor(UIColor.backgroundColors(color: .lightRed), for: .highlighted)
        cancelSearchBtn.addTarget(self, action: #selector(searchBarCancelButtonClicked), for: .touchUpInside)
      
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        self.view.addSubview(titleBarBackground)
        titleBarBackground.addSubview(searchBar)
        titleBarBackground.addSubview(cancelSearchBtn)
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
        
        
        
        //添加下拉刷新
        orderSearchCollectionView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        //添加上拉加载
        orderSearchCollectionView.es.addInfiniteScrolling {
            [weak self] in
            self?.loadMore()
        }
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page = 1
            self.orderArray.removeAll()
            self.loadOrderDataFromServer(pages: 1)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page)
                self.orderSearchCollectionView.reloadData()
                self.orderSearchCollectionView.es.stopLoadingMore()
            }else{
                self.orderSearchCollectionView.es.noticeNoMoreData()
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! OrderSearchCollectionViewCell
        
        let dictionaryObjectInOrderArray = orderArray[indexPath.row]
        let statusObjects = dictionaryObjectInOrderArray.value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray.value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
        let priceInfoObjects = dictionaryObjectInOrderArray.value(forKey: "price") as! NSDictionary
        
        //获取订单图片
        if orderInfoObjects.value(forKey: "goodsimage") as? String == nil{ // 图片字段为空
            cell.orderCellImageView.image = UIImage(named:"defualt-design-pic")
        }else{
            let imageURLString:String = "\(downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "goodsimage") as! String)"
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage.gif(data:data)
                cell.orderCellImageView.image = image//  UIImage(image:image)
            }catch{
                let imageURLString:String = "\(downloadURLHeader)\(orderInfoObjects.value(forKey: "goodsimage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    cell.orderCellImageView.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
                print("无缩略图")
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
        cell.orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as! String
        var createtime = orderInfoObjects.value(forKey: "createtime") as! String
        
        let offSetIndex = createtime.index(createtime.startIndex, offsetBy: 16)
        createtime = createtime.substring(to: offSetIndex)
        //删除头部2个字符
        for _ in 0..<2{
            createtime.removeFirst()
        }
        cell.orderTimeValue.text = createtime
        cell.productSize.text = sizeString
        
        cell.acceptDesignBtnInCell.isHidden = true
        cell.acceptProduceBtnInCell.isHidden = true
        cell.quotePriceBtnInCell.isHidden = true
        cell.shippingBtnInCell.isHidden = true
        cell.takePhotoForProductBtnInCell.isHidden = true
        cell.editOrderBtnInCell.isHidden = true
        
        cell.acceptDesignBtnInCell.addTarget(self, action: #selector(acceptDesignBtnClicked), for: .touchUpInside)
        cell.quotePriceBtnInCell.addTarget(self, action: #selector(quotePriceBtnClicked), for: .touchUpInside)
        cell.acceptProduceBtnInCell.addTarget(self, action: #selector(acceptProduceBtnClicked), for: .touchUpInside)
        cell.shippingBtnInCell.addTarget(self, action: #selector(shippingBtnClicked), for: .touchUpInside)
        cell.takePhotoForProductBtnInCell.addTarget(self, action: #selector(takePhotoBtnCliced), for: .touchUpInside)
        cell.editOrderBtnInCell.addTarget(self, action: #selector(editOrderParas), for: .touchUpInside)
        
        cell.acceptDesignBtnInCell.tag = indexPath.row
        cell.quotePriceBtnInCell.tag = indexPath.row
        cell.acceptProduceBtnInCell.tag = indexPath.row
        cell.shippingBtnInCell.tag = indexPath.row
        cell.takePhotoForProductBtnInCell.tag = indexPath.row
        cell.editOrderBtnInCell.tag = indexPath.row
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
            if ((statusObjects.value(forKey: "orderstate") as! NSDictionary).value(forKey: "orderstate") as! Int) <= 7{
                // cell.quotePriceBtnInCell.isHidden = false
                
                if priceInfoObjects.value(forKey: "returnprice") as? Float == nil{
                    cell.priceLabel.text = "¥0.00"
                }else{
                    cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
                }
            }else{
                //订单支付之后，如果报过价格，价格显示报价价格否则显示finlprice
                if priceInfoObjects.value(forKey: "returnprice") as? Float == nil || priceInfoObjects.value(forKey: "returnprice") as? Float == 0.0{
                    if priceInfoObjects.value(forKey: "finalprice") as? NSNumber == nil{
                        cell.priceLabel.text = "¥0.0"
                    }else{
                        cell.priceLabel.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! NSNumber)"
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
                cell.takePhotoForProductBtnInCell.isHidden = false
            }
            cell.orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as! String

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
            cell.editOrderBtnInCell.isHidden = false
        default:
            print("RoleType 为 default")
        }
        
        return cell
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.subviews.contains(orderSearchCollectionView){
            searchBar.resignFirstResponder()
            //searchBar.showsCancelButton = true
            return
        }
        searchText = searchBar.text!
        searchBar.resignFirstResponder()
        StartLoadingAnimation()
        orderArray.removeAll()
        orderSearchCollectionView.removeFromSuperview()
        DispatchQueue.global().async {
            self.loadOrderDataFromServer(pages: 1)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        print(newText)
        searchText = newText
        if newText.lengthOfBytes(using: .utf8) >= 3{
            StartLoadingAnimation()
            orderArray.removeAll()
            orderSearchCollectionView.removeFromSuperview()
            DispatchQueue.global().async {
                self.loadOrderDataFromServer(pages: 1)
            }
            
        }
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.lengthOfBytes(using: .utf8) >= 3{
            self.searchText = searchText
            //searchBar.resignFirstResponder()
            StartLoadingAnimation()
            orderArray.removeAll()
            orderSearchCollectionView.removeFromSuperview()
            DispatchQueue.global().async {
                self.loadOrderDataFromServer(pages: 1)
            }
            
        }
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
    @objc func editOrderParas(_ button:UIButton){
        print("点击了编辑参数按钮")
        let editOrderVC = EditOrderParameters()
        selectedIndex = button.tag
        
        editOrderVC.orderObject = orderArray[selectedIndex]
        editOrderVC.orderVCObject = self
        let nav = UINavigationController.init(rootViewController: editOrderVC)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func takePhotoBtnCliced(_ button:UIButton){
        print("点击了拍摄成品按钮在\(button.tag)")
        let uploadVC = UploadProductImageViewController()
        uploadVC.orderObject = orderArray[selectedIndex]
        let nav = UINavigationController.init(rootViewController: uploadVC)
        self.present(nav, animated: true, completion: nil)
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
        let acceptProduceView = ActionViewInOrder.init(frame: CGRect(x: 0, y: 363 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight))
        
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        acceptProduceView.popupVC = popVC
        acceptProduceView._orderID = orderID
        acceptProduceView._customID = customID
        
        acceptProduceView.createViewWithActionType(ActionType: .shippingProduct)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(acceptProduceView)
        
        self.present(popVC, animated: true, completion: nil)
    }
    
 

    init(searchModel:searchContentsType,roleType:Int) {
        super.init(nibName: nil, bundle: nil)
        _searchModel = searchModel
        _roleType = roleType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///获取订单概览数据
    func loadOrderDataFromServer(pages:Int) {
        //去除未完成的数据请求
        for task in OrderSearchViewController.requestCacheArr{
            task.cancel()
        }
        OrderSearchViewController.requestCacheArr.removeAll()
        
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
        requestURL = apiAddresses.value(forKey: "orderSearchDebug") as! String
        #else
        requestURL = apiAddresses.value(forKey: "orderSearch") as! String
        #endif

        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["userid"] =  _userid
        params["roletype"] = _roleType
        params["orderid"] = searchText
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
                        if !self.view.subviews.contains(self.orderSearchCollectionView) {
                            self.view.addSubview(self.orderSearchCollectionView)
                            self.StopLoadingAnimation()
                        }
                        self.orderSearchCollectionView.reloadData()
                        self.orderSearchCollectionView.es.stopPullToRefresh()
                    }else{
                        if self.page == 1{
                            self.StopLoadingAnimation()
                            self.emytyAreaShowingLabel(withRetry: false)
                        }else{
                            self.orderSearchCollectionView.es.noticeNoMoreData()
                        }
                    }
                }
            case false:
                self.orderSearchCollectionView.es.stopPullToRefresh()
                if self.view.subviews.contains(self.orderSearchCollectionView) {
                    self.orderSearchCollectionView.removeFromSuperview()
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
        OrderSearchViewController.requestCacheArr.append(dataRequest)
    }
    
    @objc func retryBtnInViewClicked(){
        orderArray.removeAll()
        loadOrderDataFromServer(pages: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        //titleBarView.backgroundColor = UIColor.backgroundColors(color: .red)
    }
    
    @objc func searchBarCancelButtonClicked() {
        
        self.view.window?.rootViewController = tabbarObject//TabBarController(royeType: _roleType)
//        self.view.window?.rootViewController?.dismiss(animated: true) {
//            self.removeFromParentViewController()
//            print("removed")
//        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
       // self.dismiss(animated: true, completion: nil)
    }

    func emytyAreaShowingLabel(withRetry:Bool) {
        //什么都没有
        let sizeOfNothing:Int = 180
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 100, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) + 120 , width: 200, height: 44))
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
