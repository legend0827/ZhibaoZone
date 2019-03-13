//
//  pamaterSettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class pamaterSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var _parameterType:parameterSettingType = .CSCreateOrderSetting
    
    lazy var titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
    
    var _paramterSettingDic:NSMutableDictionary = NSMutableDictionary()
    var _savedParameterSettingDic:NSMutableDictionary = NSMutableDictionary()
    //双重确认
    lazy var doubleCheckPopUpWindow:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 20, y: 111 + heightChangeForiPhoneXFromTop, width: kWidth - 40, height: 393/335 * (kWidth - 40)))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        //确定提交
        let updateImidiatelyBtn:UIButton = UIButton.init(frame: CGRect(x: 20, y: tempView.frame.height - 55, width: (tempView.frame.width - 55)/2, height: 40))
        updateImidiatelyBtn.layer.cornerRadius = 2
        updateImidiatelyBtn.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        updateImidiatelyBtn.setTitle("确定提交", for: .normal)
        updateImidiatelyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        updateImidiatelyBtn.setTitleColor(UIColor.lineColors(color: .white), for: .normal)
        updateImidiatelyBtn.addTarget(self, action: #selector(confirmSubmitParameterClicked), for: .touchUpInside)
        
        tempView.addSubview(updateImidiatelyBtn)
        //取消按钮
        let cancelUpdateBtn:UIButton = UIButton.init(frame: CGRect(x: tempView.frame.width/2 + 7.5, y: tempView.frame.height - 55, width: (tempView.frame.width - 55)/2, height: 40))
        cancelUpdateBtn.layer.cornerRadius = 2
        cancelUpdateBtn.layer.backgroundColor = UIColor.lineColors(color: .white).cgColor
        cancelUpdateBtn.layer.borderColor = UIColor.lineColors(color: .grayLevel2).cgColor
        cancelUpdateBtn.layer.borderWidth = 0.5
        cancelUpdateBtn.setTitle("取消", for: .normal)
        cancelUpdateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelUpdateBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelUpdateBtn.addTarget(self, action: #selector(cancelUpdateClicked), for: .touchUpInside)
        
        let beforeUpdate:UILabel = UILabel.init(frame: CGRect(x: 164, y: 20, width: 60, height: 21))
        beforeUpdate.textAlignment = .left
        beforeUpdate.text = "更改前"
        beforeUpdate.textColor = UIColor.titleColors(color: .gray)
        beforeUpdate.font  = UIFont.systemFont(ofSize: 15)
        
        tempView.addSubview(beforeUpdate)
    
        let afterUpdate:UILabel = UILabel.init(frame: CGRect(x: tempView.frame.width - 80, y: 20, width: 60, height: 21))
        afterUpdate.textAlignment = .right
        afterUpdate.text = "更改后"
        afterUpdate.textColor = UIColor.titleColors(color: .darkGray)
        afterUpdate.font  = UIFont.systemFont(ofSize: 15)
        
        tempView.addSubview(afterUpdate)
        
        let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 56.5, width: tempView.frame.width - 40, height: 0.5))
        seperateLine.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(seperateLine)
        
        tempView.layer.cornerRadius = 6
        tempView.addSubview(cancelUpdateBtn)
        tempView.addSubview(doubleCheckTitle)
        tempView.isUserInteractionEnabled = true
        return tempView
    }()
    
    //更新提示窗口
    lazy var doubleCheckNoticeBGView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempView.backgroundColor = UIColor.clear
        
        //灰色窗口
        let bgimg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        bgimg.image = UIImage(named: "blurBgViewgreyimg")
        tempView.addSubview(bgimg)
        
        tempView.addSubview(doubleCheckPopUpWindow)
        
        return tempView
    }()
    
    
//    lazy var fadeStatusBarBackgroundView:UIView = {
//        let tempView = UIView.init(frame: UIApplication.shared.statusBarView?.frame ?? .zero)
//        tempView.backgroundColor = UIColor.black
//        tempView.alpha = 0.5
//        return tempView
//    }()
    
    lazy var doubleCheckTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: 200, height: 21))
        tempLabel.text = "客服限制接单配置"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        return tempLabel
    }()
    
    lazy var saveParameterBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: kHight - 60 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 60 + heightChangeForiPhoneXFromBottom))
        button.setTitle("", for: .normal)
        button.isEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 0, y: 18, width: kWidth, height: 24))
        title.text = "保存配置"
        title.textAlignment = .center
        title.textColor =  UIColor.titleColors(color: .white)
        title.font = UIFont.systemFont(ofSize: 17)
        button.addSubview(title)
        
        button.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        button.addTarget(self, action: #selector(saveParameterBtnClicked), for: .touchUpInside)
        return button
    }()
    lazy var paraterSettingListTable:UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - heightChangeForiPhoneXFromBottom - heightChangeForiPhoneXFromTop - 64))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        return table
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch _parameterType {
        case .CSCreateOrderSetting:
            return 4
            //print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
           // print("经理跟单配置")
            return 2
        case .DSDistributeOrderSetting:
          //  print("设计派单跟单配置")
            return 7
        case .DSHangUpSetting:
           // print("设计师派单配置")
            return 1
        case .DSDesignFeeSetting:
           // print("设计费配置")
            return 6
        default:
           // print("客服新建订单限制配置")
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parameterSettingListTableViewCell.customCell(tableView: paraterSettingListTable)
        cell.selectionStyle = .none
        cell.fatherObject = self
        cell.parameterSetting = _parameterType
        switch _parameterType {
        case .CSCreateOrderSetting:
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "参考转化率时间范围(天)"
                cell.parameterValue.placeholder = "1 - 999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMaxValue = 999
                cell.textFieldMinValue = 1
                if let servicer_conversionRate_timeRange = _paramterSettingDic.value(forKey: "servicer_conversionRate_timeRange") as? Int{
                    cell.parameterValue.text = "\(servicer_conversionRate_timeRange)"
                }
                
            case 1:
                cell.titleLabel.text = "参考转化率默认值(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let servicer_conversionRate_default = _paramterSettingDic.value(forKey: "servicer_conversionRate_default") as? Double{
                    cell.parameterValue.text = "\(servicer_conversionRate_default * 100)"
                }
            case 2:
                cell.titleLabel.text = "新建订单最大数(达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "12"
                cell.textFieldDefaultValue = 12
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let servicer_createLimit_reachedLimit = _paramterSettingDic.value(forKey: "servicer_createLimit_reachedLimit") as? Int{
                    cell.parameterValue.text = "\(servicer_createLimit_reachedLimit)"
                }
            case 3:
                cell.titleLabel.text = "新建订单最大数(不达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let servicer_createLimit_unreachedLimit = _paramterSettingDic.value(forKey: "servicer_createLimit_unreachedLimit") as? Int{
                    cell.parameterValue.text = "\(servicer_createLimit_unreachedLimit)"
                }
            default:
                cell.titleLabel.text = "参考转化率时间范围(天)"
                cell.parameterValue.placeholder = "1 - 999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 999
            }
        //print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
            // print("经理跟单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "待跟大单时间范围(小时)"
                cell.parameterValue.placeholder = "1 - 9999"
                cell.parameteUnit.text = "时"
                cell.parameterValue.text = "24"
                cell.textFieldDefaultValue = 24
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 9999
                if let manager_follow_timeRange = _paramterSettingDic.value(forKey: "manager_follow_timeRange") as? Double{
                    cell.parameterValue.text = "\(Int(manager_follow_timeRange * 24))"
                }
            case 1:
                cell.titleLabel.text = "待跟大单选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "5"
                cell.textFieldDefaultValue = 5
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let manager_follow_top = _paramterSettingDic.value(forKey: "manager_follow_top") as? Double{
                    cell.parameterValue.text = "\(manager_follow_top * 100)"
                }
            default:
                cell.titleLabel.text = "待跟大单时间范围(天)"
                cell.parameterValue.placeholder = "1 - 9999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "24"
                cell.textFieldDefaultValue = 24
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 9999
            }
        case .DSDistributeOrderSetting:
            //  print("设计派单跟单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "设计派单轮换时间(秒)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "秒"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let design_dispatch_timeInterval = _paramterSettingDic.value(forKey: "design_dispatch_timeInterval") as? Int{
                    cell.parameterValue.text = "\(design_dispatch_timeInterval)"
                }
            case 1:
                cell.titleLabel.text = "设计权重-设计单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_designNum = _paramterSettingDic.value(forKey: "design_weight_designNum") as? Int{
                    cell.parameterValue.text = "\(design_weight_designNum)"
                }
            case 2:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_modifyNum = _paramterSettingDic.value(forKey: "design_weight_modifyNum") as? Int{
                    cell.parameterValue.text = "\(design_weight_modifyNum)"
                }
            case 3:
                cell.titleLabel.text = "设计权重-出图时间权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_averageDesignTime = _paramterSettingDic.value(forKey: "design_weight_averageDesignTime") as? Int{
                    cell.parameterValue.text = "\(design_weight_averageDesignTime)"
                }
            case 4:
                cell.titleLabel.text = "设计权重-拒单率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_refuseRate = _paramterSettingDic.value(forKey: "design_weight_refuseRate") as? Int{
                    cell.parameterValue.text = "\(design_weight_refuseRate)"
                }
            case 5:
                cell.titleLabel.text = "设计权重-定稿率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_adoptRate = _paramterSettingDic.value(forKey: "design_weight_adoptRate") as? Int{
                    cell.parameterValue.text = "\(design_weight_adoptRate)"
                }
            case 6:
                cell.titleLabel.text = "设计师选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let design_dispatch_topWeight = _paramterSettingDic.value(forKey: "design_dispatch_topWeight") as? Double{
                    cell.parameterValue.text = "\(design_dispatch_topWeight * 100)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            }
        case .DSHangUpSetting:
            // print("设计师派单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "最少保证在线设计师数(人)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "人"
                cell.parameterValue.text = "3"
                cell.textFieldDefaultValue = 3
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designer_onlineLimit = _paramterSettingDic.value(forKey: "designer_onlineLimit") as? Int{
                    cell.parameterValue.text = "\(designer_onlineLimit)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            }
        case .DSDesignFeeSetting:
            // print("设计费配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "设计费默认值(元)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_default = _paramterSettingDic.value(forKey: "designFee_default") as? Int{
                    cell.parameterValue.text = "\(designFee_default)"
                }
            case 1:
                cell.titleLabel.text = "设计费默认比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designFee_set_default = _paramterSettingDic.value(forKey: "designFee_set_default") as? Double{
                    cell.parameterValue.text = "\(designFee_set_default * 100)"
                }
            case 2:
                cell.titleLabel.text = "引导费比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designGuideFee_set_default = _paramterSettingDic.value(forKey: "designGuideFee_set_default") as? Double{
                    cell.parameterValue.text = "\(designGuideFee_set_default * 100)"
                }
            case 3:
                cell.titleLabel.text = "设计费最大值取值比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "20"
                cell.textFieldDefaultValue = 20
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designFee_set_defaultMaxValue = _paramterSettingDic.value(forKey: "designFee_set_defaultMaxValue") as? Double{
                    cell.parameterValue.text = "\(designFee_set_defaultMaxValue * 100)"
                }
            case 4:
                cell.titleLabel.text = "设计费最大值"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_Max = _paramterSettingDic.value(forKey: "designFee_Max") as? Int{
                    cell.parameterValue.text = "\(designFee_Max)"
                }
            case 5:
                cell.titleLabel.text = "设计费最小值"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_Min = _paramterSettingDic.value(forKey: "designFee_Min") as? Int{
                    cell.parameterValue.text = "\(designFee_Min)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            }
        default:
            print("Will Never Execute")
            
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .white)
        navBar.barTintColor = UIColor.backgroundColors(color: .white)
        navBar.isTranslucent = false //关闭模糊效果
        
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        
        //添加左侧
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        setupUI(with: _parameterType)
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI(with parameterType:parameterSettingType){
        switch parameterType {
        case .CSCreateOrderSetting:
            print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
            print("经理跟单配置")
        case .DSDistributeOrderSetting:
            print("设计派单跟单配置")
        case .DSHangUpSetting:
            print("设计师派单配置")
        case .DSDesignFeeSetting:
            print("设计费配置")
        default:
            print("客服新建订单限制配置")
        }
        _paramterSettingDic["servicer_conversionRate_timeRange"] = 30
        self.view.addSubview(paraterSettingListTable)
        self.view.addSubview(saveParameterBtn)
    }
    @objc func saveParameterBtnClicked(){
        self.view.addSubview(self.doubleCheckNoticeBGView)
        saveParameterBtn.becomeFirstResponder()
        print("\(_paramterSettingDic)")
//        UIApplication.shared.statusBarView?.addSubview(self.fadeStatusBarBackgroundView)
//        self.faceStatusBarView.removeAll()
       // self.faceStatusBarView.append(self.fadeStatusBarBackgroundView)
    }

    @objc func cancelUpdateClicked(){
        self.doubleCheckNoticeBGView.removeFromSuperview()
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func confirmSubmitParameterClicked(){
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
                        let dic = json["data"].dictionaryObject as! NSMutableDictionary
                        self._paramterSettingDic = dic
                        self._savedParameterSettingDic = dic
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        print("获取参数失败")
                    }
                }
            case false:
                print("获取列表失败")
                greyLayerPrompt.show(text: "获取参数失败,请返回上一页再试,请重试")
            }
        }
    }
    fileprivate func checkAndTransferDataBeforeSave(){
        for key in _paramterSettingDic.allKeys{
           // let value as
        }
    }
    //初始化页面
    fileprivate func initParameter(for parameterType:parameterSettingType){
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
                        let dic = json["data"].dictionaryObject as! NSMutableDictionary
                        self._paramterSettingDic = dic
                        self._savedParameterSettingDic = dic
                        self.saveParameterBtn.isEnabled = true
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        self.saveParameterBtn.isEnabled = false
                        print("获取参数失败")
                    }
                }
            case false:
                print("获取列表失败")
                greyLayerPrompt.show(text: "获取参数失败,请返回上一页再试,请重试")
                self.saveParameterBtn.isEnabled = false
            }
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


