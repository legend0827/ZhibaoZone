//
//  CustomerManageViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/5/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class CustomerManageViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customerListArray.isEmpty{
            return 0
        }else{
            return customerListArray[section].count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if customerListArray.isEmpty{
            return 0
        }else{
            return customerListArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let wangwangID = (customerListArray[section])[0].value(forKey: "wangId") as! String
        
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 44))
        
        let wangwangIcon = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 16, height: 16))
        wangwangIcon.image = UIImage(named: "wangwangIconimg")
        
        tempView.addSubview(wangwangIcon)
        
        let wangwangIDLabel:UILabel = UILabel.init(frame: CGRect(x: 39, y: 12, width: 300, height: 21))
        wangwangIDLabel.font = UIFont.systemFont(ofSize: 15)
        wangwangIDLabel.text = wangwangID
        
        //已绑定 // 未绑定
        var isBinded = false
        for item in customerListArray[section] {
            let statusCode = item.value(forKey: "managerStat") as! Int
            if statusCode == 1{
                isBinded = true
            }
        }
        
        let bindingStatus:UILabel = UILabel.init(frame: CGRect(x: kWidth - 60, y: 14, width: 45, height: 15))
        bindingStatus.font = UIFont.systemFont(ofSize: 12)
        bindingStatus.textAlignment = .right
        if isBinded {
            bindingStatus.text = "已绑定"
            bindingStatus.textColor = UIColor.titleColors(color: .blue )
//            bindingStatus.layer.cornerRadius = 1
//            bindingStatus.layer.borderColor = UIColor.titleColors(color: .blue).cgColor
//            bindingStatus.layer.borderWidth = 0.5
//            bindingStatus.layer.backgroundColor = UIColor.titleColors(color: .blue).cgColor
        }else{
            bindingStatus.text = "未绑定"
            bindingStatus.textColor = UIColor.titleColors(color: .darkGray)
//            bindingStatus.layer.cornerRadius = 1
//            bindingStatus.layer.borderColor = UIColor.lineColors(color: .grayLevel2).cgColor
//            bindingStatus.layer.borderWidth = 0.5
//            bindingStatus.layer.backgroundColor = UIColor.lineColors(color: .grayLevel2).cgColor
        }
        
        tempView.addSubview(bindingStatus)
        
        
        tempView.addSubview(wangwangIDLabel)
        return tempView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init()
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerListTableViewCell.customCell(tableView: customerListTableView)
        cell.selectionStyle = .none
        
        let customerInfoDic = customerListArray[indexPath.section][indexPath.row]
        
        if let value = customerInfoDic.value(forKey: "shopName") as? String {
            cell.bindingShopValueLabel.text = value
        }else{
            cell.bindingShopValueLabel.text = "--"
        }
        
        if let value = customerInfoDic.value(forKey: "managerId") as? String {
            cell.adminValueLabel.text = value
        }else{
            cell.adminValueLabel.text = "--"
        }
        
        if let value = customerInfoDic.value(forKey: "phone") as? String {
            cell.mobileValueLabel.text = value
        }else{
            cell.mobileValueLabel.text = "--"
        }
        
        if let value = customerInfoDic.value(forKey: "wechatName") as? String {
            cell.nikeNameValueLabel.text = value
        }else{
            cell.nikeNameValueLabel.text = "--"
        }
        
        if let value = customerInfoDic.value(forKey: "wechatId") as? String {
            if value == ""{
                cell.wechatIDValueLabel.text = nil
            }else{
                cell.wechatIDValueLabel.text = value
            }
            
        }else{
            cell.wechatIDValueLabel.text = "--"
        }
        
        if let value = customerInfoDic.value(forKey: "updateTime") as? TimeInterval {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = .current
            let date = Date(timeIntervalSince1970: TimeInterval(value/1000))
            let dateString = dateFormatter.string(from: date)
            
            cell.updateTimeLabel.text =  dateString
        }else{
            cell.updateTimeLabel.text = "--"
        }
        
        if (customerInfoDic.value(forKey: "managerStat") as! Int) == 1{
            cell.bindingBtn.setTitle("解绑", for: .normal)
            cell.bindingBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            cell.bindingBtn.layer.borderColor = UIColor.lineColors(color: .grayLevel1).cgColor
            cell.bindingBtn.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        }else{
            cell.bindingBtn.setTitle("绑定", for: .normal)
            cell.bindingBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            cell.bindingBtn.layer.borderColor = UIColor.backgroundColors(color: .lightOrange).cgColor
            cell.bindingBtn.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        }
        
        var gestureSingleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bindingBtnClicked))
        gestureSingleTap.numberOfTapsRequired = 1
        cell.bindingBtn.addGestureRecognizer(gestureSingleTap)
        
        cell.wechatIDValueLabel.tag = indexPath.section * theMaxCol + indexPath.row
        cell.wechatIDValueLabel.delegate = self
        //cell.bindingBtn.addTarget(self, action: #selector(bindingBtnClicked), for: .touchUpInside)
        
        return cell
    }
    
    
    lazy var searchArea:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: kWidth, height: 100))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        
        clearSearchBtn.isHidden = true
        tempView.addSubview(searchAreaTitleLable)
        tempView.addSubview(clearSearchBtn)
        tempView.addSubview(oneKeyProceedBtn)
        tempView.addSubview(searchBar)
        
        return tempView
    }()
    
    lazy var searchBar:UITextField = {
        let tempSearchBar = UITextField.init(frame: CGRect(x: 15, y: 52, width: kWidth - 30, height: 34))
        
        tempSearchBar.delegate = self
        //tempSearchBar.background = UIImage(named: "searchorderbgimg")
        tempSearchBar.layer.masksToBounds = true
        tempSearchBar.layer.cornerRadius = 6
        tempSearchBar.keyboardType = .numbersAndPunctuation
        tempSearchBar.returnKeyType = .search
        tempSearchBar.enablesReturnKeyAutomatically = true
        tempSearchBar.font = UIFont.systemFont(ofSize: 13)
        
        let attributeString = NSAttributedString(string: "搜索旺旺号、微信昵称、微信号、手机号", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13),NSAttributedStringKey.foregroundColor:UIColor.lineColors(color: .grayLevel1)])
        tempSearchBar.attributedPlaceholder = attributeString
        tempSearchBar.textAlignment = .left
        
        tempSearchBar.leftView = UIView.init(frame: CGRect(x: 12, y: 9, width: 32, height: 32))
        tempSearchBar.leftViewMode = UITextFieldViewMode.always
        tempSearchBar.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
        
        let imgPwd = UIImageView(frame: CGRect(x: 13, y: 10, width: 14, height: 14))
        imgPwd.image = UIImage(named:"searchicon")
        
        tempSearchBar.addSubview(imgPwd)
        
        return tempSearchBar
    }()
    
    lazy var searchAreaTitleLable:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 14, width: 200, height: 24))
        tempLabel.text = "未绑定客户"
        tempLabel.font = UIFont.systemFont(ofSize: 17)
        return tempLabel
    }()
    
    lazy var oneKeyProceedBtn:UIButton = {
        let tempButton = UIButton.init(frame: CGRect(x: kWidth - 85, y: 16, width: 70, height: 21))
        tempButton.setTitle("一键处理", for: .normal)
        tempButton.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        tempButton.contentHorizontalAlignment = .right
        tempButton.addTarget(self, action: #selector(oneKeyProceedBtnClicked), for: .touchUpInside)
        return tempButton
    }()
    
    lazy var clearSearchBtn:UIButton = {
        let tempButton = UIButton.init(frame: CGRect(x: kWidth - 170, y: 16, width: 70, height: 21))
        tempButton.setTitle("清除搜索", for: .normal)
        tempButton.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        tempButton.contentHorizontalAlignment = .center
        tempButton.addTarget(self, action: #selector(clearSearchBtnClicked), for: .touchUpInside)
        return tempButton
    }()
    
 
    lazy var customerListTableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 164 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 144 - heightChangeForiPhoneXFromBottom), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //弹窗灰层
    lazy var blurView = showBlurEffect()
    lazy var grayLayer:UIView = {
        let tempLayer = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempLayer.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.4)
        return tempLayer
    }()
    
    
    //提示信息弹窗
    lazy var noticeBeforeOpreation:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 30, y: 270+heightChangeForiPhoneXFromTop, width: kWidth - 60, height: 221/315*(kWidth - 60)))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempView.layer.cornerRadius = 6
        
        tempView.addSubview(confirmBtn)
        tempView.addSubview(cancelBtn)
        tempView.addSubview(noticeTitleLable)
        tempView.addSubview(noticeContentLable)
        
        return tempView
    }()
    
    lazy var noticeTitleLable:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 33, y: 20, width: (kWidth - 126), height: 24))
        tempLabel.text = "一键处理"
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return tempLabel
    }()
    
    lazy var noticeContentLable:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 33, y: 57, width: (kWidth - 126), height: 84))
        tempLabel.text = "一键处理将自动绑定只有一个客户添加旺旺号，并且只有一个店铺购买记录的客户，包括可能尚未添加管理微信的用户，是否继续？"
        tempLabel.numberOfLines = 4
        tempLabel.textColor = UIColor.titleColors(color: .darkGray)
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        return tempLabel
    }()
    
    lazy var confirmBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 20, y: 221/315*(kWidth - 60) - 55 , width: (kWidth - 115)/2, height: 40))
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        button.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(confirmedBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: (kWidth - 60)/2 + 7.5, y: 221/315*(kWidth - 60) - 55, width: (kWidth - 115)/2, height: 40))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        button.layer.backgroundColor = UIColor.lineColors(color: .white).cgColor
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.lineColors(color: .grayLevel1).cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(operationCancelledClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var emptyContentArae:UIView = {
        let tempView = UIView.init(frame: CGRect(x: (kWidth - 101)/2, y: 303+heightChangeForiPhoneXFromTop, width: 101, height: 225))
        
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 101, height: 155))
        imageView.image = UIImage(named: "emptyareaimg")
        
        tempView.addSubview(imageView)
        tempView.addSubview(refreshBtn)
        
        return tempView
    }()
    
    lazy var refreshBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 185, width: 100, height: 32))
        button.setTitle("刷新", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        button.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        button.layer.cornerRadius = 2
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(refreshBtnClicked), for: .touchUpInside)
        return button
    }()
    
    ///变量定义
    var customerListArray:[[NSDictionary]] = [[]]
    var theMaxCol:Int = 0
    var theWeChatNeedToBeSave:NSMutableDictionary = [:]
    var theTextFieldEditing:UITextField = UITextField.init()
    var theKeyword:String = ""
    var theLoadingViewNeedsToBeKill:[UIView] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)

        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.barTintColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "客户管理"
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        let rightBarItem = UIBarButtonItem(title: "设置管理员号", style: .plain, target: self, action: #selector(setAdminAccountBtnClicked))
        rightBarItem.tintColor = UIColor.backgroundColors(color: .black)
        rightBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .normal)
        rightBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], for: .highlighted)
        
        //添加左侧
        navItem.setLeftBarButton(leftBarItem, animated: false)
        navItem.setRightBarButton(rightBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        self.view.addSubview(searchArea)
        self.view.addSubview(emptyContentArae)
        getCustomerList(with: theKeyword)
        // Do any additional setup after loading the view.
    }
    @objc func operationCancelledClicked(){
        blurView.removeFromSuperview()
    }
    
    @objc func confirmedBtnClicked(){
        blurView.removeFromSuperview()
        oneKeyProceed()
    }
    
    @objc func refreshBtnClicked(){
        getCustomerList(with: theKeyword)
    }
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func setAdminAccountBtnClicked(){
        let uploadAdminVC = uploadAdminInfoViewController()
        self.present(uploadAdminVC, animated: true, completion: nil)
    }
    
    @objc func bindingBtnClicked(sender:UITapGestureRecognizer){
        let tapLocation = sender.location(in: customerListTableView)
        let indexPath:IndexPath = self.customerListTableView.indexPathForRow(at: tapLocation)!
        theTextFieldEditing.resignFirstResponder()
        print("pressed button at \(indexPath.section) and row \(indexPath.row)")
        operationWeChatRecords(with: indexPath)
    }
    @objc func oneKeyProceedBtnClicked(){
        //显示体系信息，然后继续
        blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(noticeBeforeOpreation)
        //managerVCObject.view.addSubview(blurView)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(blurView)
    }
    
    @objc func clearSearchBtnClicked(){
        theKeyword = ""
        clearSearchBtn.isHidden = true
        searchBar.text = nil
        getCustomerList(with: "")
        searchAreaTitleLable.text = "未绑定客户"
    }
    
    func oneKeyProceed(){
        
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
        
        #if DEBUG
        let requestUrl =  apiAddresses.value(forKey: "bangdingOneKeyProceedAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "bangdingOneKeyProceedAPI") as! String
        #endif
        
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        let proceedCount = json["data"].int!
                        greyLayerPrompt.show(text: "处理成功，成功处理\(proceedCount)个客户")
                        self.getCustomerList(with: self.theKeyword)
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        //                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                            LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("报价失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "报价失败,请重试")
            }
        }
        
    }
    
    func operationWeChatRecords(with indexPath:IndexPath){
        
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
        
        if let value = theWeChatNeedToBeSave["\(indexPath.section * theMaxCol + indexPath.row)"] {
            params["wechatId"] = value
        }else{
            params["wechatId"] = ""
        }
        
        let dataObject = customerListArray[indexPath.section][indexPath.row]
        params["id"] = dataObject.value(forKey: "id")
        params["wangId"] = dataObject.value(forKey: "wangId")
        params["shopId"] = dataObject.value(forKey: "shopId")
        
        params["managerId"] = dataObject.value(forKey: "managerId")
        let binding = dataObject.value(forKey: "managerStat") as! Int
        if binding == 0 || binding == 2{
//            if binding == 2{
//                greyLayerPrompt.show(text: "改绑")
//            }
            params["operationType"] = 1
        }else{
            params["operationType"] = 2
        }
        
        #if DEBUG
        let requestUrl =  apiAddresses.value(forKey: "bangdingwechatAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "bangdingwechatAPI") as! String
        #endif
        
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        
                        greyLayerPrompt.show(text: "操作成功")
                        self.getCustomerList(with: self.theKeyword)
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        //                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                            LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("报价失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "报价失败,请重试")
            }
        }
        
    }

    func getCustomerList(with keyword:String){
        StartLoadingAnimation()
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
        params["page"] = 1
        params["size"] = 200//String(format: "%.2f", currentValueOfQuotePrice)
        if keyword != ""{
            params["keyword"] = keyword
        }
        
        #if DEBUG
        let requestUrl =  apiAddresses.value(forKey: "getBangdingwechatAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "getBangdingwechatAPI") as! String
        #endif
        
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        self.customerListArray.removeAll()
                        
                        if json["data","list"].count != 0 {
                            let arrayObject = json["data","list"].arrayObject
                            var currentWangWang = (arrayObject![0] as? NSDictionary)?.value(forKey: "wangId") as! String
                            var currentDicArrary:[NSDictionary] = []
                            
                            var index = 0
                            for item in json["data","list"].array! {
                                index += 1
                                if ((item.dictionaryObject! as? NSDictionary)?.value(forKey: "wangId") as! String) == currentWangWang {
                                    currentDicArrary.append((item.dictionaryObject! as NSDictionary))
                                }else{
                                    self.customerListArray.append(currentDicArrary)
                                    currentDicArrary.removeAll()
                                    currentDicArrary.append((item.dictionaryObject! as NSDictionary))
                                }
                                currentWangWang = ((item.dictionaryObject! as NSDictionary).value(forKey: "wangId") as! String)
                                
                                if index == json["data","list"].count {
                                    self.customerListArray.append(currentDicArrary)
                                }
                            }
                            if self.view.subviews.contains(self.customerListTableView){
                                
                            }else{
                                self.view.addSubview(self.customerListTableView)
                            }
                            self.theMaxCol = index
                            self.customerListTableView.reloadData()
                        }else{
                            self.theMaxCol = 0
                            if self.view.subviews.contains(self.customerListTableView){
                                self.customerListTableView.removeFromSuperview()
                            }
                        }
                        

                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        //                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                            LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("报价失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
                self.StopLoadingAnimation()
            case false:
                print("处理失败")
                self.theMaxCol = 0
                if self.view.subviews.contains(self.customerListTableView){
                    self.customerListTableView.removeFromSuperview()
                }
                greyLayerPrompt.show(text: "系统异常,请重试")
                self.StopLoadingAnimation()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let index = textField.tag
        print("the index pressed at \(index)")
        theTextFieldEditing = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        theTextFieldEditing.resignFirstResponder()
        if textField.isEqual(self.searchBar){
            if let value = theTextFieldEditing.text {
                theKeyword = theTextFieldEditing.text!
            }else{
                theKeyword = ""
            }
        }else{
            let index = textField.tag
            theWeChatNeedToBeSave["\(index)"] = theTextFieldEditing.text
        }
        print("the edit ended")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        theTextFieldEditing.resignFirstResponder()
        if textField.isEqual(self.searchBar){
            if let value = theTextFieldEditing.text {
                theKeyword = theTextFieldEditing.text!
            }else{
                theKeyword = ""
            }
        }
        getCustomerList(with: theKeyword)
        clearSearchBtn.isHidden = false
        searchAreaTitleLable.text = "检索的结果"
        return true
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
