//
//  SwitchOrderViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/17.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class SwitchOrderViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    
    //转接订单类型
    var _pagingType:switchOrderType = .designingOrder
    
    var timer:Timer!
    
    //加载中的动画集合
    var theLoadingViewNeedsToBeKill:[UIView] = []
    //订单总数
    var orderAmount:UILabel = UILabel.init()
    //查看列表按钮
    var checkListBtn:UIButton = UIButton.init(type: .custom)
    //搜索出的订单数量
    var orderCount:Int = 0
    var theOrderToSwitch:Int = 0
    //用户账号的数量
    var accountCount:Int = 0
    //生产单列表数
    var checkListCount:Int = 0
    var checkList:[NSDictionary] = []
    
    //搜索出的订单列表
    var searchResultList:[NSDictionary] = []
    var translist:[NSArray] = []
    var selectedIndex:Int = 0
    //弹窗类型
    var isToCheckList = false
    
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    //转接的生产费用
    lazy var newProducePriceTextField:UITextField = {
       let tempTextField = UITextField.init(frame: CGRect(x: 158, y: 10, width: kWidth - 158, height: 32))
        tempTextField.keyboardType = .decimalPad
        tempTextField.placeholder = "请输入给新车间的生产费"
        tempTextField.delegate = self
        tempTextField.font = UIFont.systemFont(ofSize: 16)
        return tempTextField
    }()
    lazy var newProducePriceLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 200, height: 22))
        tempLabel.text = "生产费用(元）:"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    //转接的生产工期
    lazy var newProducePeriodTextField:UITextField = {
        let tempTextField = UITextField.init(frame: CGRect(x: 158, y: 15, width: kWidth - 158, height: 32))
        tempTextField.keyboardType = .numberPad
        tempTextField.delegate = self
        tempTextField.placeholder = "请输入给新车间的生产工期"
        tempTextField.font = UIFont.systemFont(ofSize: 16)
        return tempTextField
    }()
    lazy var newProducePeriodLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 200, height: 22))
        tempLabel.text = "生产工期(天）:"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
    //提示文字
    lazy var noticeOfEmpty:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 40, width: kWidth - 40, height: 25))
        tempLabel.text = "无相关信息"
        
        let tempLine1:UIView = UIView.init(frame: CGRect(x: 30, y: 12, width: 90, height: 0.5))
        tempLine1.backgroundColor = UIColor.titleColors(color: .lightGray)
        tempLabel.addSubview(tempLine1)
        
        let tempLine2:UIView = UIView.init(frame: CGRect(x: tempLabel.frame.width - 120, y: 12, width: 90, height: 0.5))
        tempLine2.backgroundColor = UIColor.titleColors(color: .lightGray)
        tempLabel.addSubview(tempLine2)
        
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        return tempLabel
    }()
    
    
    //核对标题
    lazy var doubleConfirmTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: kWidth - 80, height: 25))
        tempLabel.text = "转接信息核对"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 18)
        return tempLabel
    }()
    
    //订单图
    lazy var orderImage:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: 20, y: 60, width: 80, height: 80))
        tempView.layer.cornerRadius = 6
        tempView.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
        tempView.layer.borderWidth = 0.5
        tempView.layer.masksToBounds = true
        tempView.image = UIImage(named: "defualt-design-pic")
        return tempView
    }()
    //订单号
    lazy var orderIDLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 120, y: 60, width: kWidth - 140, height: 22))
        tempLabel.text = "订单号: 12020010122211"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    //更新前
    lazy var beforeSwitch:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 160, width: 48, height: 22))
        tempLabel.text = "前车间"
        tempLabel.textColor = UIColor.titleColors(color: .darkGray)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.layer.cornerRadius = 2
        tempLabel.layer.borderWidth = 0.5
        tempLabel.layer.borderColor = UIColor.lineColors(color: .darkGray).cgColor
        return tempLabel
    }()
    //更新后
    lazy var afterSwitch:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 264, width: 48, height: 22))
        tempLabel.text = "新车间"
        tempLabel.textColor = UIColor.titleColors(color: .red)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.layer.cornerRadius = 2
        tempLabel.layer.borderWidth = 0.5
        tempLabel.layer.borderColor = UIColor.lineColors(color: .red).cgColor
        return tempLabel
    }()
    //前账号
    lazy var beforeAccount:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 80, y: 160, width: kWidth - 140, height: 22))
        tempLabel.text = "车间1(1020201020202)"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    //前费用/工期
    lazy var beforePriceAndPeriod:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 80, y: 190, width: kWidth - 140, height: 22))
        tempLabel.text = "产品费/工期: ¥-/-天"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    //转接图标
    lazy var downArrow:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: (kWidth - 70)/2, y: 224, width: 30, height: 24.7))
        tempView.image = UIImage(named: "downarrowimg")
        return tempView
    }()
    
    //后账号：
    lazy var afterAccount:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 80, y: 264, width: kWidth - 140, height: 22))
        tempLabel.text = "车间2(00019929291)"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    //前费用/工期
    lazy var afterPriceAndPeriod:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 80, y: 296, width: kWidth - 140, height: 22))
        tempLabel.text = "生产费/工期: ¥-/-天"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
    //核对准确
    lazy var confirmSwitchBtn:UIButton = {
        let tempBtn = UIButton.init(frame: CGRect(x: 20, y: 338, width: kWidth - 80, height: 40))
        tempBtn.setTitle("我已核对，确认转接", for: .normal)
        tempBtn.layer.cornerRadius = 6
        tempBtn.layer.masksToBounds = true
        tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        tempBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        tempBtn.setBackgroundImage(UIImage(named: "saveconfirmbgimg"), for: .normal)
        tempBtn.addTarget(self, action: #selector(confirmToSwitchClicked), for: .touchUpInside)
        return tempBtn
    }()
    lazy var managerVCObject = TabBarController(royeType: 4)
    //弹窗灰层
    lazy var blurView = showBlurEffect()
    lazy var grayLayer:UIView = {
        let tempLayer = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempLayer.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.4)
        return tempLayer
    }()
    
    //选择账号的弹窗
    lazy var selectionBgView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: kHight, width: kWidth, height: kHight - 168 - heightChangeForiPhoneXFromTop)) //208 + heightChangeForiPhoneXFromTop
        tempView.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        tempView.layer.cornerRadius = 20
        return tempView
    }()
    //转接核对页面
    lazy var switchDoubleCheckBgView:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 40, height: (kWidth - 40)*325/325)) //208 + heightChangeForiPhoneXFromTop
        tempView.image = UIImage(named: "doublecheckbgimg")
        tempView.isUserInteractionEnabled = true
        //tempView.layer.cornerRadius = 0
        return tempView
    }()
    let closeBtnOfSavePreview:UIButton = UIButton.init(type: .custom)
    
    let confirmSelection:UIButton = UIButton.init(type: .custom)
    let cancelSelection:UIButton = UIButton.init(type: .custom)
    let selectionTitle:UILabel = UILabel.init()
    //搜索输入框
    lazy var searchOrderTextFiled:UITextField = {
        let tempTextFiled = UITextField.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tempTextFiled.textAlignment = .center
        tempTextFiled.delegate = self
        tempTextFiled.background = UIImage(named: "searchorderbgimg")
        tempTextFiled.layer.masksToBounds = true
        tempTextFiled.layer.cornerRadius = 6
        tempTextFiled.keyboardType = .numbersAndPunctuation
        tempTextFiled.returnKeyType = .search
        tempTextFiled.enablesReturnKeyAutomatically = true
        return tempTextFiled
    }()
    
    //搜索出的订单号
    lazy var orderListTable:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 153, width: kWidth, height: kHight - 315 - heightChangeForiPhoneXFromBottom), style: .grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        tempTableView.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        tempTableView.estimatedSectionHeaderHeight = 0
        tempTableView.estimatedSectionFooterHeight = 0
//        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        return tempTableView
    }()
    
    //账号list table
    lazy var userAccountTable:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 65, width: kWidth, height: 454), style: .grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        tempTableView.separatorColor = UIColor.titleColors(color: .darkGray)
//        tempTableView.separatorInset = .zero
//        tempTableView.layoutMargins = .zero
        tempTableView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempTableView.estimatedSectionHeaderHeight = 0
        tempTableView.estimatedSectionFooterHeight = 0
       // tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        return tempTableView
    }()
    let searchHintText:UIImageView = UIImageView.init()
    
    init(with pagingType:switchOrderType) {
        super.init(nibName: nil, bundle: nil)
        _pagingType = pagingType
       
        let backgoundView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 153))
        backgoundView.image = UIImage(named: "backimgwithshandowimg")
        backgoundView.isUserInteractionEnabled = true
        self.view.addSubview(backgoundView)
        
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        let temview:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 12))
        temview.backgroundColor = UIColor.backgroundColors(color: .white)
        self.view.addSubview(temview)
        
        let titleOfOrdersSummary:UILabel = UILabel.init(frame: CGRect(x: 20, y: 12, width: 200, height: 22))
        titleOfOrdersSummary.textColor = UIColor.titleColors(color: .darkGray)
        titleOfOrdersSummary.font = UIFont.systemFont(ofSize: 18)
        if pagingType == .producingOrder{
            titleOfOrdersSummary.text = "待接受生产订单总数"
        }else{
            titleOfOrdersSummary.text = "待接受设计订单总数"
        }
        backgoundView.addSubview(titleOfOrdersSummary)
        
        orderAmount.frame = CGRect(x: 20, y: titleOfOrdersSummary.frame.maxY + 11, width: 200, height: 20)
        orderAmount.textColor = UIColor.titleColors(color: .black)
        orderAmount.textAlignment = .left
        orderAmount.text = "0"
        orderAmount.font = UIFont.systemFont(ofSize: 16)
        backgoundView.addSubview(orderAmount)
        
        checkListBtn.frame = CGRect(x: kWidth - 88, y: titleOfOrdersSummary.frame.maxY + 11, width: 78, height: 20)
        checkListBtn.setTitle("查看列表", for: .normal)
        checkListBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        checkListBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        checkListBtn.contentHorizontalAlignment = .left
        checkListBtn.addTarget(self, action: #selector(CheckOrdersClicked), for: .touchUpInside)
        
        let arrowImg:UIImageView = UIImageView.init(frame: CGRect(x: checkListBtn.frame.width - 14, y: 3, width: 14, height: 14))
        arrowImg.image = UIImage(named: "right-arrow")
        checkListBtn.addSubview(arrowImg)
        backgoundView.addSubview(checkListBtn)
        
        searchOrderTextFiled.frame = CGRect(x: 0, y: orderAmount.frame.maxY + 11, width: kWidth, height: 56)
        backgoundView.addSubview(searchOrderTextFiled)
        
        searchHintText.frame = CGRect(x: (searchOrderTextFiled.frame.width - 157)/2, y: 20, width: 157, height: 14)
        searchHintText.image = UIImage(named: "searchhintimg")
        searchOrderTextFiled.addSubview(searchHintText)
        
        orderListTable.addSubview(noticeOfEmpty)
        self.view.addSubview(orderListTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateStatistic), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let attributeString = NSAttributedString(string: "搜索需要转接的订单号", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .gray)])
        searchOrderTextFiled.attributedPlaceholder = attributeString
        
        searchHintText.isHidden = true
        
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(closeKeyboard))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        textField.inputAccessoryView = topView
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //view.end
        searchOrderTextFiled.resignFirstResponder()
       //self.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchOrderTextFiled.text == nil || searchOrderTextFiled.text == ""{
            let attributeString = NSAttributedString(string: "", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .gray)])
            searchOrderTextFiled.attributedPlaceholder = attributeString
            searchHintText.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchOrderTextFiled.resignFirstResponder()
        print("search button clicked")
        if _pagingType == .producingOrder{
            searchForSwitchOrders(for: 3)
        }else{
            searchForSwitchOrders(for: 2)
        }
        return true
    }
    @objc func closeKeyboard(){
        searchOrderTextFiled.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(orderListTable){
            return orderCount
        }else{
            if isToCheckList{
                return checkListCount
            }else{
                accountCount = translist[theOrderToSwitch].count
                return accountCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(orderListTable){
            let cell = switchOrderListTableViewCell.customCell(tableView: orderListTable)
            cell.selectionStyle = .none
            //设置数据
            let orderObject = searchResultList[indexPath.row]
            
            if (orderObject.value(forKey: "email") as! String) == nil{
                let account = orderObject.value(forKey: "mobilePhone") as! String
            }else{
                let account = orderObject.value(forKey: "email") as! String
            }
            let designername = orderObject.value(forKey: "disignername") as! String
            let custommerid = orderObject.value(forKey: "wangid") as! String
            let orderid = orderObject.value(forKey: "orderid") as! String
            let servicename = orderObject.value(forKey: "servicername") as! String
            let workshopname = orderObject.value(forKey: "workshopname") as! String
            let producePrice = orderObject.value(forKey: "producePrice") as! Double
           // translist = orderObject.value(forKey: "translist") as! [NSDictionary]
            
            cell.customernikeNameLabel.text = "客服: " + servicename
            cell.fnikeNameLabel.text = "车间: " + workshopname
            cell.dnikeNameLabel.text = "方案师: " + designername
            cell.orderIDLabel.text = "订单号: " + orderid
            cell.wangwangIDLabel.text = "旺旺号: " + custommerid
            
            //生产订单转接，增加产品费
            if _pagingType == .producingOrder{
                cell.producePriceLabel.frame = CGRect(x: cell.orderImage.frame.maxX + 20, y: cell.orderIDLabel.frame.maxY + 1, width: 200, height: 20)
                cell.customernikeNameLabel.frame = CGRect(x: cell.orderImage.frame.maxX + 20, y: cell.producePriceLabel.frame.maxY + 1, width: 200, height: 20)
                cell.wangwangIDLabel.frame = CGRect(x: cell.orderImage.frame.maxX + 20, y: cell.customernikeNameLabel.frame.maxY + 1, width: 200, height: 20)
                let orignalText = NSMutableAttributedString(string: "产品费: ¥" + String(producePrice))
                //产品费
                let range = orignalText.string.range(of: "¥" + String(producePrice))
                let nsRange = orignalText.string.nsRange(from: range!)
                orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: nsRange)
                cell.producePriceLabel.attributedText = orignalText
            }
            //获取订单图片
            if orderObject.value(forKey: "smallGoodsImage") as? String == nil{ // 图片字段为空
                cell.orderImage.image = UIImage(named:"defualt-design-pic")
            }else{
                let imageURLString:String = "\(downloadURLHeaderForThumbnail)\(orderObject.value(forKey: "smallGoodsImage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    cell.orderImage.image = image//  UIImage(image:image)
                }catch{
                    let imageURLString:String = "\(downloadURLHeader)\(orderObject.value(forKey: "smallGoodsImage") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        cell.orderImage.image = image//  UIImage(image:image)
                    }catch{
                        print(error)
                    }
                    print("无缩略图")
                }
                
            }
            
            cell.switchBtn.tag = indexPath.row
            cell.switchBtn.addTarget(self, action: #selector(switchOrderClicked), for: .touchUpInside)
            return cell
        }else{
            let cell = accountListTableViewCell.customCell(tableView: userAccountTable)
            //设置数据
            if !isToCheckList {
                let transferObject = translist[theOrderToSwitch]
                if _pagingType == .producingOrder{
                    //增加生产费和生产周期选项
                    if (transferObject[indexPath.row] as! NSDictionary).value(forKey: "price") as! Double == 0.0{
                        cell.nikeNameLabel.text = "\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "nickName") as! String)(¥- / - 天))"
                    }else{
                        cell.nikeNameLabel.text = "\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "nickName") as! String)( ¥\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "price") as! Double) / \((transferObject[indexPath.row] as! NSDictionary).value(forKey: "days") as! Int) 天))"
                    }
                }else{
                    if ((transferObject[indexPath.row] as! NSDictionary).value(forKey: "email") as! String) == ""{
                        cell.nikeNameLabel.text = "\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "nickName") as! String)(\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "phone") as! String))"
                    }else{
                        cell.nikeNameLabel.text = "\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "nickName") as! String)(\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "email") as! String))"
                    }
                    cell.nikeNameLabel.text = "\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "nickName") as! String)(\((transferObject[indexPath.row] as! NSDictionary).value(forKey: "id") as! Int))"
                }
                

            }else{
                let listObject = checkList[indexPath.row]
                cell.checkListOrdersCount.text = "\(listObject.value(forKey: "num") as! Int)"
                cell.nikeNameLabel.text = listObject.value(forKey: "nickName") as! String
            }
            if indexPath.row == 0{
                cell.seperatorLine.isHidden = true
            }else{
                cell.seperatorLine.isHidden = false
            }
            cell.selectionStyle = .none
            cell.checkBoxBtn.addTarget(self, action: #selector(checkBoxChanged), for: .touchUpInside)
            cell.checkBoxBtn.tag = indexPath.row
            if indexPath.row == selectedIndex{
                cell.checkBoxBtn.setImage(UIImage(named: "checkbox-checked"), for: .normal)
            }else{
                cell.checkBoxBtn.setImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
            }
            
            if isToCheckList{
                cell.checkBoxBtn.isHidden = true
                cell.checkListOrdersCount.isHidden = false
            }else{
                cell.checkBoxBtn.isHidden = false
                cell.checkListOrdersCount.isHidden = true
            }
            return cell
        }
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if cell.responds(to:#selector(setter: UIView.layoutMargins)) {
//            cell.layoutMargins = UIEdgeInsets.zero
//        }
//        if cell.responds(to:#selector(setter: UITableViewCell.separatorInset)) {
//            cell.separatorInset = UIEdgeInsets.zero
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(orderListTable){
            return 190
        }else{
            return 52
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 0.01))
//        return tempView
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 0.01))
//        return tempView
//    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.isEqual(orderListTable){
            return 30.0
        }else{
            return 0.01
        }
        //return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @objc func switchOrderClicked(_ button:UIButton){
        let index = button.tag
        
        theOrderToSwitch = index // 设置待转出订单
        isToCheckList = false
        
        userAccountTable.reloadData()
        confirmSelection.frame = CGRect(x: kWidth - 220, y: 20, width: 200, height: 22)
        confirmSelection.setTitle("确定", for: .normal)
        confirmSelection.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        confirmSelection.contentHorizontalAlignment = .right
        confirmSelection.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmSelection.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        
        cancelSelection.frame = CGRect(x: 20, y: 20, width: 200, height: 22)
        cancelSelection.setTitle("取消", for: .normal)
        cancelSelection.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelSelection.contentHorizontalAlignment = .left
        cancelSelection.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelSelection.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        
        selectionTitle.frame = CGRect(x: 20, y: 20, width: kWidth - 40, height: 25)
        selectionTitle.textAlignment = .center
        selectionTitle.textColor = UIColor.backgroundColors(color: .black)
        selectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        selectionTitle.text = "请选转接的方案师"
        userAccountTable.frame = CGRect(x: 0, y: 65, width: kWidth, height: selectionBgView.frame.height - 85 - heightChangeForiPhoneXFromBottom)
       
        if _pagingType == .producingOrder{
            selectionTitle.text = "请选转接的车间"
            let NewPriceBG:UIView = UIView.init(frame: CGRect(x: 0, y: 65, width: kWidth, height: 106))
            NewPriceBG.backgroundColor = UIColor.backgroundColors(color: .white)
            selectionBgView.addSubview(NewPriceBG)
            
            let seperateLine1:UIView  = UIView.init(frame: CGRect(x: 15, y: 53, width: kWidth - 30, height: 0.5))
            seperateLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
            NewPriceBG.addSubview(seperateLine1)
            
            newProducePeriodTextField.frame = CGRect(x: 158, y: seperateLine1.frame.maxY + 10, width: kWidth - 158, height: 32)
            newProducePeriodLabel.frame = CGRect(x: 20, y: seperateLine1.frame.maxY + 15, width: 200, height: 22)
            
//            let seperateLine2:UIView  = UIView.init(frame: CGRect(x: 15, y: seperateLine1.frame.maxY + 53, width: kWidth - 30, height: 0.5))
//            seperateLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
//            NewPriceBG.addSubview(seperateLine2)
            
            NewPriceBG.addSubview(newProducePriceLabel)
            NewPriceBG.addSubview(newProducePeriodLabel)
            NewPriceBG.addSubview(newProducePriceTextField)
            NewPriceBG.addSubview(newProducePeriodTextField)
            
            let hint:UILabel = UILabel.init(frame: CGRect(x: 20, y: NewPriceBG.frame.maxY + 20, width: 200, height: 22))
            hint.text = "接受订单车间:"
            hint.textColor = UIColor.titleColors(color: .gray)
            hint.font = UIFont.systemFont(ofSize: 16)
            selectionBgView.addSubview(hint)
            
            userAccountTable.frame = CGRect(x: 0, y: 217, width: kWidth, height: selectionBgView.frame.height - 237 - heightChangeForiPhoneXFromBottom)
        }
        
        
        selectionBgView.addSubview(userAccountTable)
        selectionBgView.addSubview(confirmSelection)
        selectionBgView.addSubview(cancelSelection)
        selectionBgView.addSubview(selectionTitle)
        
        blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(selectionBgView)
        managerVCObject.view.addSubview(blurView)
        
        userAccountTable.reloadData()
        setStatusBarHiden(toHidden: true, ViewController: managerVCObject)
        UIView.animate(withDuration: 0.3) {
            self.selectionBgView.transform = CGAffineTransform(translationX: 0, y:  -kHight + 188 + heightChangeForiPhoneXFromTop) // 208 + heightChangeForiPhoneXFromTop
        }
    }
    
    @objc func CheckOrdersClicked(_ button:UIButton){
        
        let index = button.tag
        isToCheckList = true
        //theOrderToSwitch = index // 设置待转出订单
        
//        confirmSelection.frame = CGRect(x: kWidth - 220, y: 20, width: 200, height: 22)
//        confirmSelection.setTitle("确定", for: .normal)
//        confirmSelection.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        confirmSelection.contentHorizontalAlignment = .right
//        confirmSelection.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        cancelSelection.frame = CGRect(x: kWidth - 220, y: 20, width: 200, height: 22)
        cancelSelection.setTitle("确定", for: .normal)
        cancelSelection.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelSelection.contentHorizontalAlignment = .right
        cancelSelection.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelSelection.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        
        selectionTitle.frame = CGRect(x: 20, y: 20, width: kWidth - 40, height: 25)
        selectionTitle.textAlignment = .center
        selectionTitle.textColor = UIColor.backgroundColors(color: .black)
        selectionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        if _pagingType == .producingOrder{
            selectionTitle.text = "待接受生产列表"
        }else{
            selectionTitle.text = "待接受设计列表"
        }
        
        
        userAccountTable.frame = CGRect(x: 0, y: 65, width: kWidth, height: selectionBgView.frame.height - 85 - heightChangeForiPhoneXFromBottom)
        
        selectionBgView.addSubview(userAccountTable)
        //selectionBgView.addSubview(confirmSelection)
        selectionBgView.addSubview(cancelSelection)
        selectionBgView.addSubview(selectionTitle)
        
        blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(selectionBgView)
        managerVCObject.view.addSubview(blurView)
        userAccountTable.reloadData()
        setStatusBarHiden(toHidden: true, ViewController: managerVCObject)
        UIView.animate(withDuration: 0.3) {
            self.selectionBgView.transform = CGAffineTransform(translationX: 0, y:  -kHight + 188 + heightChangeForiPhoneXFromTop) // 208 + heightChangeForiPhoneXFromTop
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.isEqual(userAccountTable) && !isToCheckList else {
            print("No need to check")
            return
        }
        
        if tableView.isEqual(userAccountTable){
            selectedIndex = indexPath.row
            tableView.reloadData()
        }
    }
    
    @objc func cancelBtnClicked(){
        setStatusBarHiden(toHidden: false, ViewController: managerVCObject)
        
        UIView.animate(withDuration: 0.3) {
            self.selectionBgView.transform = CGAffineTransform(translationX: 0, y:  0) // 208 + heightChangeForiPhoneXFromTop
        }
        blurView.removeFromSuperview()
    }
    @objc func checkBoxChanged(_ button:UIButton){
        selectedIndex = button.tag
        userAccountTable.reloadData()
    }
    
    @objc func confirmClicked(){
        
        if newProducePriceTextField.text == "" || newProducePriceTextField.text == "0" {
            greyLayerPrompt.show(text: "转接金额不能为空或为0")
            return
        }
        if newProducePeriodTextField.text == "" || newProducePeriodTextField.text == "0" {
            greyLayerPrompt.show(text: "转接工期不能为空或为0")
            return
        }
        
        cancelBtnClicked()
        //设置数据
        let orderObject = searchResultList[theOrderToSwitch]
        let orderid = orderObject.value(forKey: "orderid") as! String
        // translist = orderObject.value(forKey: "translist") as! [NSDictionary]
        var account = ""
        if (orderObject.value(forKey: "email") as? String) == nil{
            account = orderObject.value(forKey: "mobilePhone") as! String
        }else{
            account = orderObject.value(forKey: "email") as! String
        }
        let designername = orderObject.value(forKey: "disignername") as! String
        let workshopname = orderObject.value(forKey: "workshopname") as! String
        
        
        let lists = translist[theOrderToSwitch]
        var newAccont = ""
        if ((lists[selectedIndex] as! NSDictionary).value(forKey: "email") as! String) == nil{
            newAccont = (lists[selectedIndex] as! NSDictionary).value(forKey: "phone") as! String
        }else{
            newAccont = (lists[selectedIndex] as! NSDictionary).value(forKey: "email") as! String
        }
        let newName = (lists[selectedIndex] as! NSDictionary).value(forKey: "nickName") as! String
        var oldAccount = ""
        if _pagingType == .producingOrder{
            oldAccount = workshopname
        }else{
            oldAccount = designername
        }
        if oldAccount == ""{
            beforeAccount.text = "-"
        }else{
            beforeAccount.text = oldAccount + "(\(account))"
        }
        afterAccount.text =  newName + "(\(newAccont))"
        orderIDLabel.text = "订单号: " + orderid
        //获取订单图片
        if orderObject.value(forKey: "smallGoodsImage") as? String == nil{ // 图片字段为空
            orderImage.image = UIImage(named:"defualt-design-pic")
        }else{
            let imageURLString:String = "\(downloadURLHeaderForThumbnail)\(orderObject.value(forKey: "smallGoodsImage") as! String)"
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage.gif(data:data)
                orderImage.image = image//  UIImage(image:image)
            }catch{
                let imageURLString:String = "\(downloadURLHeader)\(orderObject.value(forKey: "smallGoodsImage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    orderImage.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
                print("无缩略图")
            }
            
        }
        
        switchDoubleCheckBgView.addSubview(doubleConfirmTitle)
        switchDoubleCheckBgView.addSubview(downArrow)
        switchDoubleCheckBgView.addSubview(orderImage)
        switchDoubleCheckBgView.addSubview(orderIDLabel)
        switchDoubleCheckBgView.addSubview(beforeSwitch)
        switchDoubleCheckBgView.addSubview(afterSwitch)
        switchDoubleCheckBgView.addSubview(beforeAccount)
        switchDoubleCheckBgView.addSubview(afterAccount)
        switchDoubleCheckBgView.addSubview(confirmSwitchBtn)
        if _pagingType == .producingOrder {
            switchDoubleCheckBgView.frame =  CGRect(x: 20, y: 0, width: kWidth - 40, height: (kWidth - 40)*325/325 + 80) //208 + heightChangeForiPhoneXFromTop
            switchDoubleCheckBgView.addSubview(beforePriceAndPeriod)
            switchDoubleCheckBgView.addSubview(afterPriceAndPeriod)
            var oldProducePrice = ""
            if orderObject.value(forKey: "producePrice") as? Double == 0.0{
                oldProducePrice = "-"
            }else{
                oldProducePrice = String(orderObject.value(forKey: "producePrice") as! Double)
            }
            let newProducePrice = newProducePriceTextField.text!
            let newProducePeriod = newProducePeriodTextField.text!
           
            beforePriceAndPeriod.text = "产品费/工期: ¥\(oldProducePrice) / - 天"
            afterPriceAndPeriod.text = "生产费/工期: ¥\(newProducePrice) / \(newProducePeriod) 天"
            
            beforeSwitch.text = "前车间"
            afterSwitch.text = "新车间"
        }else{
            beforeSwitch.text = "前设计"
            afterSwitch.text = "新设计"
        }
        
        closeBtnOfSavePreview.setImage(UIImage(named: "closeofsavepreimg"), for: .normal)
        closeBtnOfSavePreview.frame = CGRect(x: (kWidth - 28)/2, y: 0, width: 28, height: 28) //switchDoubleCheckBgView.frame.maxY + 10
        closeBtnOfSavePreview.addTarget(self, action: #selector(closeLayerClicked), for: .touchUpInside)
        
        blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(switchDoubleCheckBgView)
        grayLayer.addSubview(closeBtnOfSavePreview)
        managerVCObject.view.addSubview(blurView)
        setStatusBarHiden(toHidden: true, ViewController: managerVCObject)
        UIView.animate(withDuration: 0.3) {
            self.switchDoubleCheckBgView.transform = CGAffineTransform(translationX: 0, y: 160)
            self.closeBtnOfSavePreview.transform = CGAffineTransform(translationX: 0, y: 195 + self.switchDoubleCheckBgView.frame.height)
        }
    }
    
    @objc func closeLayerClicked(){
        
        setStatusBarHiden(toHidden: false, ViewController: self)
        
        UIView.animate(withDuration: 0.3) {
            self.switchDoubleCheckBgView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.closeBtnOfSavePreview.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        blurView.removeFromSuperview()
        grayLayer.removeFromSuperview()
        switchDoubleCheckBgView.removeFromSuperview()
        closeBtnOfSavePreview.removeFromSuperview()
    }
    
    @objc func getStatisticOfOrders(for role:Int){
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
        header["token"] = token
        params["status"] = role
        
            #if DEBUG
            let requestUrl = apiAddresses.value(forKey: "managerGetOrderListAPIDebug") as! String
            #else
            let requestUrl = apiAddresses.value(forKey: "managerGetOrderListAPI") as! String
            #endif
        
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        //正常
                        let workshoplist = json["data"].array!
                        if workshoplist.count == 0{
                            self.orderAmount.text = "0"
                            self.checkListCount = 0
                        }else{
                            
                            let numberDic = workshoplist[0].dictionaryObject as! NSDictionary
                            self.orderAmount.text = String(numberDic.value(forKey: "allnum") as! Int)
                            self.checkList.removeAll()
                            for item in workshoplist{
                                let dicObject = item.dictionaryObject
                                self.checkList.append(dicObject! as NSDictionary)
                            }
                            self.checkListCount = self.checkList.count
                        }
//                        //let numberOfOrder = json["data","totalnum"].int!
//                        if numberOfOrder == 0{
//                            self.orderAmount.text = "0"
//                            self.checkListCount = 0
//                        }else{
//
//                        }
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                      //  greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        autoLogin(viewControler: self)
                        //LogoutMission(viewControler: self)
                    }else{
                        //异常
                    }
                    
                }
            case false:
                print("获取列表失败")
                //greyLayerPrompt.show(text: "清空失败,请重试")
            }
        }
    }
    @objc func confirmToSwitchClicked(){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        let orderObject = searchResultList[theOrderToSwitch]
        let orderid = orderObject.value(forKey: "orderid") as! String
        let lists = translist[theOrderToSwitch] as! NSArray
        let newID = (lists[selectedIndex] as! NSDictionary).value(forKey: "id") as! Int
        
        var role = 3
        if _pagingType == .designingOrder{
            role = 2
        }
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        params["id"] = newID
        header["token"] = token
        params["orderid"] = orderid
        params["producePrice"] = newProducePriceTextField.text!
        params["duration"] = newProducePeriodTextField.text!
        
            #if DEBUG
            let requestUrl = apiAddresses.value(forKey: "switchOrderAPIDebug") as! String
            #else
            let requestUrl = apiAddresses.value(forKey: "switchOrderAPI") as! String
            #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    let statusMsg = json["message"].string!
                    if statusCode == 200{
                        greyLayerPrompt.show(text: statusMsg)
                        self.searchForSwitchOrders(for: role)
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                        autoLogin(viewControler: self)
                    }else {
                        greyLayerPrompt.show(text: statusMsg)
                    }
                    
                }
            case false:
                greyLayerPrompt.show(text: "转出失败,请重试")
            }
            print("data reload")
        }
        self.closeLayerClicked()
        self.cancelBtnClicked()
    }
    @objc func searchForSwitchOrders(for role:Int){
        guard searchOrderTextFiled.text != nil && searchOrderTextFiled.text != "" else {
            greyLayerPrompt.show(text: "请输入有效的输入字符")
            return
        }
        StartLoadingAnimation()
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        params["roletype"] = role
        header["token"] = token
        params["orderid"] = searchOrderTextFiled.text!
        
        var requestUrl:String = ""
        if roletype == "4" {
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "switchOrderSearchAPIDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "switchOrderSearchAPI") as! String
            #endif
        }
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        //正常
                        let orderList = json["data"].array!
                        
                        self.searchResultList.removeAll()
                        self.translist.removeAll()
                        if orderList.count != 0{
                            for item in orderList{
                                let dicObject = item.dictionaryObject
                                self.searchResultList.append(dicObject! as NSDictionary)
                               //拉取可接受的车间列表
                                let orderid = (dicObject! as NSDictionary).value(forKey: "orderid") as! String
                                self.getTransList(for: role, By: orderid, token: token!)
                            }
                            
                            self.orderCount  = self.searchResultList.count
                            self.noticeOfEmpty.isHidden = true
                            self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                        }else{
                            self.orderCount  = self.searchResultList.count
                            greyLayerPrompt.show(text: "未搜索到相关订单")
                            self.noticeOfEmpty.isHidden = false
                            self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                        }
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                        autoLogin(viewControler: self)
                    }else {
                        
                    }
                    
                }
            case false:
                print("获取列表失败")
                self.noticeOfEmpty.isHidden = false
                self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                //greyLayerPrompt.show(text: "清空失败,请重试")
            }
            self.orderListTable.reloadData()
            print("data reload")
            self.StopLoadingAnimation()
        }
    }
    
    func getTransList(for role:Int, By orderid:String, token token:String){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        params["roletype"] = role
        header["token"] = token
        params["orderid"] = orderid
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "translistGetAPIDehug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "translistGetAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        //正常
                        let userList = json["data"].arrayObject! as NSArray
                        self.translist.append(userList)
//                        if userList.count != 0{
//                            for item in userList{
//                                let dicObject = item.dictionaryObject
//                                self.translist.append((dicObject! as NSDictionary).value(forKey: "translist") as! NSArray)
//                            }
//                            self.orderCount  = self.searchResultList.count
//                            self.noticeOfEmpty.isHidden = true
//                            self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
//                        }else{
//                            self.orderCount  = self.searchResultList.count
//                            greyLayerPrompt.show(text: "未搜索到相关订单")
//                            self.noticeOfEmpty.isHidden = false
//                            self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
//                        }
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                    }else {
                        
                    }
                    
                }
            case false:
                print("获取列表失败")
              //  self.noticeOfEmpty.isHidden = false
              //  self.orderListTable.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                //greyLayerPrompt.show(text: "清空失败,请重试")
            }
//            self.orderListTable.reloadData()
//            print("data reload")
//            self.StopLoadingAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if _pagingType == .producingOrder{
            getStatisticOfOrders(for: 3)
        }else{
            getStatisticOfOrders(for: 2)
        }
    }
    @objc func updateStatistic(){
        if _pagingType == .producingOrder{
            getStatisticOfOrders(for: 3)
        }else{
            getStatisticOfOrders(for: 2)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
