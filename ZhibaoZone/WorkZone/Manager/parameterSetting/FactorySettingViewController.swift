//
//  FactorySettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/9/5.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class FactorySettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = autoReciveOrderCell
            return cell
        case 1:
            let cell = forbidQuoteCell
            return cell
        case 2:
            let cell = limitAcceptOrderCountCell
            if isUnlimitCount{
                limitCountTextFiled.isHidden = true
                hintOfCount.isHidden = true
            }else{
                //limitCountTextFiled.text = "\(isLimit)"
                limitCountTextFiled.isHidden = false
                hintOfCount.isHidden = false
            }
            return cell
        case 3:
            let cell = limitAcceptOrderAmountCell
            if isUnlimitAmount{
                limitAmountTextFiled.isHidden = true
                hintOfAmount.isHidden = true
               
            }else{
               // limitAmountTextFiled.text = "\(isLimit)"
                limitAmountTextFiled.isHidden = false
                hintOfAmount.isHidden = false
            }
            return cell
        default:
            let cell = autoReciveOrderCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,1:
            return 61.0
        case 2:
            if isUnlimitCount{
                return 61.0
            }else{
                return 122.0
            }
        case 3:
            if isUnlimitAmount{
                return 61.0
            }else{
                return 122.0
            }
        default:
            return 61.0
        }
    }
    
    //定义变量
    var isUnlimitCount:Bool = true
    var isUnlimitAmount:Bool = true
    
    //FacotoryListVC
    var factoryListVC = FactoryListSettingViewController()

    //自主接单
    lazy var autoReciveOrderCell:UITableViewCell = {
        let tempCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 61))
        let title = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 21))
        title.text = "自主接单"
        title.textColor = UIColor.titleColors(color: .black)
        title.font = UIFont.systemFont(ofSize: 15)
        tempCell.contentView.addSubview(title)
        
        tempCell.selectionStyle = .none
        tempCell.addSubview(autoReciveOrderSwitchBtn)
        return tempCell
    }()
    
    lazy var autoReciveOrderSwitchBtn:UISwitch = {
        let switchBtn = UISwitch.init(frame: CGRect(x: kWidth - 66, y: 15, width: 51, height: 31))
        switchBtn.isOn = false
        switchBtn.tag = 1
        switchBtn.addTarget(self, action: #selector(switchBtnValueChanged), for: .valueChanged)
        return switchBtn
    }()
    //限制报价/议价(竞价除外)
    lazy var forbidQuoteCell:UITableViewCell = {
        let tempCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 61))
        let title = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 21))
        title.text = "限制报价/议价(竞价除外)"
        title.textColor = UIColor.titleColors(color: .black)
        title.font = UIFont.systemFont(ofSize: 15)
        tempCell.contentView.addSubview(title)
        
        tempCell.selectionStyle = .none
        
        tempCell.addSubview(forbidQuoteCellSwitchBtn)
        return tempCell
    }()
    
    lazy var forbidQuoteCellSwitchBtn:UISwitch = {
        let switchBtn = UISwitch.init(frame: CGRect(x: kWidth - 66, y: 15, width: 51, height: 31))
        switchBtn.isOn = false
        switchBtn.tag = 2
        switchBtn.addTarget(self, action: #selector(switchBtnValueChanged), for: .valueChanged)
        return switchBtn
    }()
    //限制接单数量
    let hintOfCount = UILabel.init(frame: CGRect(x: kWidth - 215, y: 75, width: 200, height: 21))
    lazy var limitAcceptOrderCountCell:UITableViewCell = {
        let tempCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 61))
        let title = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 21))
        title.text = "限制接单数量"
        title.textColor = UIColor.titleColors(color: .black)
        title.font = UIFont.systemFont(ofSize: 15)
        tempCell.contentView.addSubview(title)
        
        hintOfCount.text = "单/天"
        hintOfCount.textColor = UIColor.titleColors(color: .black)
        hintOfCount.font = UIFont.systemFont(ofSize: 15)
        hintOfCount.textAlignment = .right
        hintOfCount.isHidden = true
        tempCell.contentView.addSubview(hintOfCount)
        
        tempCell.addSubview(limitCountTextFiled)
        limitCountTextFiled.isHidden = true
        
        tempCell.selectionStyle = .none
        
        tempCell.addSubview(limitAcceptOrderCountCellSwitchBtn)
        return tempCell
    }()
    
    lazy var limitAcceptOrderCountCellSwitchBtn:UISwitch = {
        let switchBtn = UISwitch.init(frame: CGRect(x: kWidth - 66, y: 15, width: 51, height: 31))
        switchBtn.isOn = false
        switchBtn.tag = 3
        switchBtn.addTarget(self, action: #selector(switchBtnValueChanged), for: .valueChanged)
        return switchBtn
    }()
    
    lazy var limitCountTextFiled:UITextField = {
        let tempTextFiled = UITextField.init(frame: CGRect(x: 15, y: 66, width: kWidth - 76, height: 39))
        tempTextFiled.placeholder = "0 - 9999"
        tempTextFiled.tag = 100
        tempTextFiled.textAlignment = .right
        tempTextFiled.keyboardType = .numberPad
        tempTextFiled.textColor = UIColor.titleColors(color: .black)
        tempTextFiled.font = UIFont.systemFont(ofSize: 15)
        tempTextFiled.delegate = self
        return tempTextFiled
    }()
    
    
    //限制接单金额
    let hintOfAmount = UILabel.init(frame: CGRect(x: kWidth - 215, y: 75, width: 200, height: 21))
    lazy var limitAcceptOrderAmountCell:UITableViewCell = {
        let tempCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 61))
        let title = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 21))
        title.text = "限制接单金额"
        title.textColor = UIColor.titleColors(color: .black)
        title.font = UIFont.systemFont(ofSize: 15)
        tempCell.contentView.addSubview(title)
        
        
        hintOfAmount.text = "元/天"
        hintOfAmount.textColor = UIColor.titleColors(color: .black)
        hintOfAmount.font = UIFont.systemFont(ofSize: 15)
        hintOfAmount.textAlignment = .right
        hintOfAmount.isHidden = true
        tempCell.contentView.addSubview(hintOfAmount)
        
        tempCell.addSubview(limitAmountTextFiled)
        limitAmountTextFiled.isHidden = true
        
        tempCell.selectionStyle = .none
        
        tempCell.addSubview(limitAcceptOrderAmountCellSwitchBtn)
        return tempCell
    }()
    
    lazy var limitAcceptOrderAmountCellSwitchBtn:UISwitch = {
        let switchBtn = UISwitch.init(frame: CGRect(x: kWidth - 66, y: 15, width: 51, height: 31))
        switchBtn.isOn = false
        switchBtn.tag = 4
        switchBtn.addTarget(self, action: #selector(switchBtnValueChanged), for: .valueChanged)
        return switchBtn
    }()
    lazy var limitAmountTextFiled:UITextField = {
        let tempTextFiled = UITextField.init(frame: CGRect(x: 15, y: 66, width: kWidth - 76, height: 39))
        tempTextFiled.placeholder = "0 - 99999999"
        tempTextFiled.textAlignment = .right
        tempTextFiled.delegate = self
        tempTextFiled.tag = 101
        tempTextFiled.keyboardType = .numberPad
        tempTextFiled.textColor = UIColor.titleColors(color: .black)
        tempTextFiled.font = UIFont.systemFont(ofSize: 15)
        return tempTextFiled
    }()

    //保存参数配置按钮
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
    
    init(factoryInfos:NSDictionary,factoryVC:FactoryListSettingViewController) {
        super.init(nibName: nil, bundle: nil)
        factoryData = factoryInfos
        factoryListVC = factoryVC
       // self.view.addSubview(factoryListTableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //车间列表数据
    var factoryData:NSDictionary = [:]
    //记录的需要移除的Views
    var theViewNeedToBeKill:[UIView] = []
    //车间列表
    lazy var factoryListTableView:UITableView = {
        //height -77 调好的
        //var heightOfTableView = UIScreen.main.bounds.height - 62
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (64 + heightChangeForiPhoneXFromTop)), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempTableView.isScrollEnabled = true
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 100
        tempTableView.separatorStyle = .singleLine//.none
        tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel3)
        return tempTableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
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
        titleLabel.text = factoryData.value(forKey: "nickName") as! String
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
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
        // Do any additional setup after loading the view.
        
        self.view.addSubview(factoryListTableView)
        self.view.addSubview(saveParameterBtn)
        
        var isLimit = factoryData.value(forKey: "invalid") as! Int
        if isLimit == 0{
            autoReciveOrderSwitchBtn.isOn = false
        }else{
            autoReciveOrderSwitchBtn.isOn = true
        }
        
        isLimit = factoryData.value(forKey: "quoteEnabled") as! Int
        if isLimit == 0{
            forbidQuoteCellSwitchBtn.isOn = true
        }else{
            forbidQuoteCellSwitchBtn.isOn = false
        }
        isLimit = factoryData.value(forKey: "numlimit") as! Int
        if isLimit == -1{
            limitAcceptOrderCountCellSwitchBtn.isOn = false
            isUnlimitCount = true
        }else{
            isUnlimitCount = false
            limitAcceptOrderCountCellSwitchBtn.isOn = true
            limitCountTextFiled.text = "\(isLimit)"
            limitCountTextFiled.isHidden = false
            hintOfCount.isHidden = false
        }
        isLimit = factoryData.value(forKey: "amountlimit") as! Int
        if isLimit == -1{
            limitAcceptOrderAmountCellSwitchBtn.isOn = false
            isUnlimitAmount = true
        }else{
            isUnlimitAmount = false
            limitAcceptOrderAmountCellSwitchBtn.isOn = true
            limitAmountTextFiled.text = "\(isLimit)"
            limitAmountTextFiled.isHidden = false
            hintOfAmount.isHidden = false
        }
        factoryListTableView.reloadData()
        // Do any additional setup after loading the view.
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        var currentValue:Int64 = 0
        //limitCountTextFiled
        if limitCountTextFiled.text != nil &&  limitCountTextFiled.text != ""{
            currentValue = Int64(limitCountTextFiled.text ?? "0")!
        }
        if currentValue >= 0 && currentValue <= 9999{
            print("正确值")
        }else{
            limitCountTextFiled.text = "\(factoryData.value(forKey: "numlimit") as! Int)"
            greyLayerPrompt.show(text: "参数值超限")
        }
        
        //limitAmountTextFiled
        if limitAmountTextFiled.text != nil &&  limitAmountTextFiled.text != ""{
            currentValue = Int64(limitAmountTextFiled.text ?? "0")!
        }
        if currentValue >= 0 && currentValue <= 99999999{
            print("正确值")
        }else{
            limitAmountTextFiled.text = "\(factoryData.value(forKey: "amountlimit") as! Int)"
            greyLayerPrompt.show(text: "参数值超限")
        }
        
        limitCountTextFiled.resignFirstResponder()
        limitAmountTextFiled.resignFirstResponder()
        
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func switchBtnValueChanged(_ uiSwitch:UISwitch){
        let selectedIndex = uiSwitch.tag
        switch selectedIndex {
        case 1,2:
            print("selected")
        case 3:
            if uiSwitch.isOn{
                isUnlimitCount = false
                hintOfCount.isHidden = false
                limitCountTextFiled.isHidden = false
            }else{
                isUnlimitCount = true
                hintOfCount.isHidden = true
                limitCountTextFiled.isHidden = true
                limitCountTextFiled.text = "\(factoryData.value(forKey: "numlimit") as! Int)"
            }
            
            factoryListTableView.reloadData()
        case 4:
            if uiSwitch.isOn{
                isUnlimitAmount = false
                hintOfAmount.isHidden = false
                limitAmountTextFiled.isHidden = false
            }else{
                isUnlimitAmount = true
                hintOfAmount.isHidden = true
                limitAmountTextFiled.isHidden = true
                limitAmountTextFiled.text = "\(factoryData.value(forKey: "amountlimit") as! Int)"
            }
            factoryListTableView.reloadData()
        default:
            print("selected")
        }
    }
    
    @objc func saveParameterBtnClicked(){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        let userId = userInfos.value(forKey: "userid") as? String
        guard userId == "10000005" || userId == "10000029" || userId == "10000190" else {
            greyLayerPrompt.show(text: "您没有修改参数权限")
            return
        }
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        
        if autoReciveOrderSwitchBtn.isOn{
            params["invalid"] = 1
        }else{
            params["invalid"] = 0
        }
        
        if limitAcceptOrderCountCellSwitchBtn.isOn{
            guard (limitCountTextFiled.text != "" && limitCountTextFiled.text != nil) else {
                greyLayerPrompt.show(text: "限制接单数量不能为空")
                return
            }
            params["numlimit"] = limitCountTextFiled.text
        }else{
            params["numlimit"] = -1
        }
        if limitAcceptOrderAmountCellSwitchBtn.isOn{
            guard (limitAmountTextFiled.text != "" && limitAmountTextFiled.text != nil) else {
                greyLayerPrompt.show(text: "限制接单金额不能为空")
                return
            }
            params["amountlimit"] = limitAmountTextFiled.text
        }else{
            params["amountlimit"] = -1
        }
        
        
        if forbidQuoteCellSwitchBtn.isOn{
            params["quoteEnabled"] = 0
        }else{
            params["quoteEnabled"] = 1
        }
        
        params["workShopId"] = factoryData.value(forKey: "workshopId") as! Int
        
        header["token"] = token
        
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "setFactorySettingAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "setFactorySettingAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        greyLayerPrompt.show(text: "参数保存成功")
                        self.factoryListVC.loadListData()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
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
