//
//  SystemManagementViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class SystemManagementViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {

    lazy var _tabBarVC:TabBarController = {
        let hasStatistic = UserDefaults.standard.value(forKey: "hasStatistic") as! Bool
        let hasWorkZone = UserDefaults.standard.value(forKey: "hasWorkZone") as! Bool
        let hasManager = UserDefaults.standard.value(forKey: "hasManager") as! Bool
        let roleType = UserDefaults.standard.value(forKey: "currentRoleType") as! Int
        return TabBarController(roleType: roleType, hasManager: hasManager, hasWorkZone: hasWorkZone, hasStatistic: hasStatistic)
    }()
    
    lazy var scrollBackgroundView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - heightChangeForiPhoneXFromBottom - 49))
        tempScrollView.contentSize = CGSize(width: kWidth, height: 630 )
        //backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height )
        //  tempScrollView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempScrollView.delegate = self
        //tempScrollView.delegate = self
        tempScrollView.isDirectionalLockEnabled = true
        tempScrollView.isScrollEnabled = true
        tempScrollView.showsHorizontalScrollIndicator = false
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.setContentOffset(CGPoint(x: 0, y: 20),animated: true)// (10, 20), animated: false)
        tempScrollView.scrollRectToVisible(CGRect(x:0, y:0, width:100, height:300), animated: false)
        tempScrollView.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        return tempScrollView
    }()
    
    lazy var waitForAcceptProduceCount:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 95, width: (kWidth - 37)/2 - 40, height: 29))
        tempLabel.textColor = UIColor.lineColors(color: .lightOrange)
        tempLabel.text = "22000"
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 24)
        return tempLabel
    }()
    
    lazy var waitForAcceptDesignCount:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 95, width: (kWidth - 37)/2 - 40, height: 29))
        tempLabel.textColor = UIColor.lineColors(color: .lightOrange)
        tempLabel.text = "22000"
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont.systemFont(ofSize: 24)
        return tempLabel
    }()
    
    lazy var transferOrderBoardView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 96, width: kWidth, height: 220))
        
        let produceOrderView:UIView = UIView.init(frame: CGRect(x: 13, y: 13, width: (kWidth - 37)/2, height: 195))
        produceOrderView.layer.cornerRadius = 4
        produceOrderView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
        produceOrderView.layer.borderWidth = 0.5
        
        let titleImageOfProduce:UIImageView = UIImageView.init(frame: CGRect(x: ((kWidth - 37)/2 - 40)/2, y: 20, width: 40, height: 40))
        titleImageOfProduce.image = UIImage(named: "factoryordericonimg")
        produceOrderView.addSubview(titleImageOfProduce)
        
        let titleOfProduce:UILabel = UILabel.init(frame: CGRect(x: 20, y: 70, width: (kWidth - 37)/2 - 40, height: 21))
        titleOfProduce.text = "待接受生产订单数"
        titleOfProduce.textAlignment = .center
        titleOfProduce.font = UIFont.systemFont(ofSize: 15)
        titleOfProduce.textColor = UIColor.titleColors(color: .black)
        
        produceOrderView.addSubview(titleOfProduce)
        produceOrderView.addSubview(waitForAcceptProduceCount)
        
        let jumpButtonOfProduce:UIButton = UIButton.init(frame: CGRect(x: 40, y: 152, width: (kWidth - 37)/2 - 80, height: 28))
        jumpButtonOfProduce.setTitle("查看", for: .normal)
        jumpButtonOfProduce.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        jumpButtonOfProduce.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        jumpButtonOfProduce.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jumpButtonOfProduce.layer.cornerRadius = 2
        jumpButtonOfProduce.addTarget(self, action: #selector(jumpToSwitchOrder), for: .touchUpInside)
        
        produceOrderView.addSubview(jumpButtonOfProduce)
        
        let designOrderView:UIView = UIView.init(frame: CGRect(x: kWidth/2 + 6.5  , y: 13, width: (kWidth - 37)/2, height: 195))
        designOrderView.layer.cornerRadius = 4
        designOrderView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
        designOrderView.layer.borderWidth = 0.5
        
        let titleImageOfDesign:UIImageView = UIImageView.init(frame: CGRect(x: ((kWidth - 37)/2 - 40)/2, y: 20, width: 40, height: 40))
        titleImageOfDesign.image = UIImage(named: "designordericonimg")
        designOrderView.addSubview(titleImageOfDesign)
        
        let titleOfDesign:UILabel = UILabel.init(frame: CGRect(x: 20, y: 70, width: (kWidth - 37)/2 - 40, height: 21))
        titleOfDesign.text = "待接受设计订单数"
        titleOfDesign.textAlignment = .center
        titleOfDesign.font = UIFont.systemFont(ofSize: 15)
        titleOfDesign.textColor = UIColor.titleColors(color: .black)
        
        designOrderView.addSubview(titleOfDesign)
        designOrderView.addSubview(waitForAcceptDesignCount)
        
        let jumpButtonOfDesign:UIButton = UIButton.init(frame: CGRect(x: 40, y: 152, width: (kWidth - 37)/2 - 80, height: 28))
        jumpButtonOfDesign.setTitle("查看", for: .normal)
        jumpButtonOfDesign.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        jumpButtonOfDesign.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jumpButtonOfDesign.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        jumpButtonOfDesign.layer.cornerRadius = 2
        jumpButtonOfDesign.addTarget(self, action: #selector(jumpToSwitchOrder), for: .touchUpInside)
        
        designOrderView.addSubview(jumpButtonOfDesign)
        
        tempView.addSubview(produceOrderView)
        tempView.addSubview(designOrderView)
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    
    lazy var transferOrderTitleBar:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 44, width: kWidth, height: 52))
        
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 18, width: 4, height: 16))
        tempImageView.image  = UIImage(named: "orangedotimg")
        tempView.addSubview(tempImageView)
        
        tempView.isUserInteractionEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 29, y: 15, width: 200, height: 21))
        title.text = "转接订单"
        title.font = UIFont.systemFont(ofSize: 15)
        tempView.addSubview(title)
        
        let hint:UILabel = UILabel.init(frame: CGRect(x: kWidth - 229, y: 15, width: 200, height: 21))
        hint.text = "转接订单"
        hint.textAlignment = .right
        hint.textColor = UIColor.titleColors(color: .gray)
        hint.font = UIFont.systemFont(ofSize: 13)
        tempView.addSubview(hint)
        
        let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 29, y: 19, width: 14, height: 14))
        rightArrow.image = UIImage(named:"right-arrow")
        //rightArrow.bounds = CGRect(x:kWidth - 30,y:21,width:5,height:9)
        tempView.addSubview(rightArrow)
        
        let line:UIView = UIView.init(frame: CGRect(x: 0, y: 51.5, width: kWidth, height: 0.5))
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(line)
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jumpToSwitchOrder))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        tempView.addGestureRecognizer(singleTap)
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    
    lazy var customerManageTitleBar:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 100, width: kWidth, height: 52))
        
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 18, width: 4, height: 16))
        tempImageView.image  = UIImage(named: "orangedotimg")
        tempView.addSubview(tempImageView)
        
        tempView.isUserInteractionEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 29, y: 15, width: 200, height: 21))
        title.text = "客户管理"
        title.font = UIFont.systemFont(ofSize: 15)
        tempView.addSubview(title)
        
        let hint:UILabel = UILabel.init(frame: CGRect(x: kWidth - 229, y: 15, width: 200, height: 21))
        hint.text = "客户绑定"
        hint.textAlignment = .right
        hint.textColor = UIColor.titleColors(color: .gray)
        hint.font = UIFont.systemFont(ofSize: 13)
        tempView.addSubview(hint)
        
        let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 29, y: 19, width: 14, height: 14))
        rightArrow.image = UIImage(named:"right-arrow")
        //rightArrow.bounds = CGRect(x:kWidth - 30,y:21,width:5,height:9)
        tempView.addSubview(rightArrow)
        
        let line:UIView = UIView.init(frame: CGRect(x: 0, y: 51.5, width: kWidth, height: 0.5))
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(line)
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jumpToCustomerManagement))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        tempView.addGestureRecognizer(singleTap)
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    lazy var factorySettingTitleBar:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 156, width: kWidth, height: 52))
        
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 18, width: 4, height: 16))
        tempImageView.image  = UIImage(named: "orangedotimg")
        tempView.addSubview(tempImageView)
        
        tempView.isUserInteractionEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 29, y: 15, width: 200, height: 21))
        title.text = "车间配置"
        title.font = UIFont.systemFont(ofSize: 15)
        tempView.addSubview(title)
        
        let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 29, y: 19, width: 14, height: 14))
        rightArrow.image = UIImage(named:"right-arrow")
        //rightArrow.bounds = CGRect(x:kWidth - 30,y:21,width:5,height:9)
        tempView.addSubview(rightArrow)
        
        let line:UIView = UIView.init(frame: CGRect(x: 0, y: 51.5, width: kWidth, height: 0.5))
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(line)
        
        let hint:UILabel = UILabel.init(frame: CGRect(x: kWidth - 229, y: 15, width: 200, height: 21))
        hint.text = "参数配置"
        hint.textAlignment = .right
        hint.textColor = UIColor.titleColors(color: .gray)
        hint.font = UIFont.systemFont(ofSize: 13)
        tempView.addSubview(hint)
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jumpToFactoryManagement))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        tempView.addGestureRecognizer(singleTap)
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    
    
    lazy var systemParamSettingTitleBar:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 212, width: kWidth, height: 52))
        
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 18, width: 4, height: 16))
        tempImageView.image  = UIImage(named: "orangedotimg")
        tempView.addSubview(tempImageView)
        
        tempView.isUserInteractionEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 29, y: 15, width: 200, height: 21))
        title.text = "参数配置"
        title.font = UIFont.systemFont(ofSize: 15)
        tempView.addSubview(title)
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    
    
    lazy var parameterSettingTableView:UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 268, width: kWidth, height: kHight - 268 - heightChangeForiPhoneXFromBottom))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.backgroundColors(color: .white)
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        return table
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parameterSettingTableViewCell.customCell(tableView: parameterSettingTableView)
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "客服限制接单"
        case 1:
            cell.titleLabel.text = "经理跟单"
        case 2:
            cell.titleLabel.text = "设计派单"
        case 3:
            cell.titleLabel.text = "设计师挂起"
        case 4:
            cell.titleLabel.text = "设计费"
        case 5:
            cell.titleLabel.text = "自动报价"
        default:
            cell.titleLabel.text = "客服限制接单"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parameterSettingVC = pamaterSettingViewController()
        parameterSettingVC.modalPresentationStyle = .fullScreen
        switch indexPath.row {
        case 0:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "客服限制接单"
            parameterSettingVC._parameterType = .CSCreateOrderSetting
        case 1:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "经理跟单"
            parameterSettingVC._parameterType = .MGFollowOrderSetting
        case 2:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "设计派单"
            parameterSettingVC._parameterType = .DSDistributeOrderSetting
        case 3:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "设计师挂起"
            parameterSettingVC._parameterType = .DSHangUpSetting
        case 4:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "设计费"
            parameterSettingVC._parameterType = .DSDesignFeeSetting
        case 5:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "自动报价"
            parameterSettingVC._parameterType = .AutoPricingSetting
        default:
            print("index Row at \(indexPath.row) selected")
            parameterSettingVC.titleLabel.text = "客服限制接单"
            parameterSettingVC._parameterType = .CSCreateOrderSetting
        }
        self.present(parameterSettingVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
        let titleBar:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 44))
        titleBar.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 10, width: kWidth, height: 25))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = "事物处理"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.titleColors(color: .black)
        titleBar.addSubview(titleLabel)
        self.view.addSubview(scrollBackgroundView)
        scrollBackgroundView.addSubview(transferOrderTitleBar)
        scrollBackgroundView.addSubview(systemParamSettingTitleBar)
        scrollBackgroundView.addSubview(factorySettingTitleBar)
        scrollBackgroundView.addSubview(titleBar)
        scrollBackgroundView.addSubview(customerManageTitleBar)
       // scrollBackgroundView.addSubview(transferOrderBoardView)
        scrollBackgroundView.addSubview(parameterSettingTableView)
        
        self.getStatisticOfOrders(for: 2)
        self.getStatisticOfOrders(for: 3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    
    @objc func jumpToSwitchOrder(){
        let managerVC = ManagerViewController()
        managerVC._tabBarVC = self._tabBarVC
        managerVC.modalPresentationStyle = .fullScreen
        self.present(managerVC, animated: true, completion: nil)
    }
    
    @objc func jumpToCustomerManagement(){
        let customManageVC = CustomerManageViewController()
        customManageVC.modalPresentationStyle = .fullScreen
        self.present(customManageVC, animated: true, completion:  nil)
    }
    
    @objc func jumpToFactoryManagement(){
        let factorySettingListVC = FactoryListSettingViewController()
        factorySettingListVC.modalPresentationStyle = .fullScreen
        self.present(factorySettingListVC, animated: true, completion:  nil)
    }
    
    fileprivate func getStatisticOfOrders(for role:Int){
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
                            if role == 2{
                                self.waitForAcceptDesignCount.text = "0"
                            }else{
                                self.waitForAcceptProduceCount.text = "0"
                            }
                            
                          //  self.checkListCount = 0
                        }else{
                            
                            let numberDic = workshoplist[0].dictionaryObject as! NSDictionary
                            
                            if role == 2{
                                self.waitForAcceptDesignCount.text = String(numberDic.value(forKey: "allnum") as! Int)
                            }else{
                                self.waitForAcceptProduceCount.text = String(numberDic.value(forKey: "allnum") as! Int)
                            }
                            
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
}

//extension SystemManagementViewController{
//
//}
