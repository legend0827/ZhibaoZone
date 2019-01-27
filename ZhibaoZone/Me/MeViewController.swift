//
//  MeViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData
import Alamofire



class MeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //用户信息支持表
    lazy var userInfoTableView:UITableView = {
        let initTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - heightChangeForiPhoneXFromBottom - 50), style: UITableViewStyle.grouped)
        
        initTableView.dataSource = self
        initTableView.delegate = self
        initTableView.estimatedRowHeight = 0;
        initTableView.estimatedSectionHeaderHeight = 0;
        initTableView.estimatedSectionFooterHeight = 0;
        
        initTableView.backgroundColor = UIColor.clear// #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        initTableView.showsVerticalScrollIndicator = false
        initTableView.bounces = true
        initTableView.separatorStyle = .singleLine
        initTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        initTableView.tableFooterView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        initTableView.contentInset = .zero
        initTableView.rowHeight = UITableViewAutomaticDimension
        
       // initTableView.contentInsetAdjustmentBehavior = .never

        return initTableView
    }()
    
    //用户信息Cell
    var nameBannerCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 128))
    var accountIDCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var RoleTypeCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var SetQuickAccessPermitCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var SetParametersCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var versionCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var invoiceCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var switchAccountCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    var logoutAccountCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 58))
    let LogoutBtn:UIButton = UIButton.init(type: UIButtonType.system)
    lazy var _tabBarVC = TabBarController(royeType: 4)
    //弹窗灰层
    lazy var blurView = showBlurEffect()
    lazy var grayLayer:UIView = {
        let tempLayer = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempLayer.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.4)
        return tempLayer
    }()
    
    //选择账号的弹窗
    lazy var switchAccountBgView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: kHight, width: kWidth, height:380 + heightChangeForiPhoneXFromBottom)) //208 + heightChangeForiPhoneXFromTop
        tempView.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        tempView.layer.cornerRadius = 20
        return tempView
    }()
    //白板
    lazy var switchAccountWhiteBoardView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 65, width: kWidth, height: 315)) //208 + heightChangeForiPhoneXFromTop
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        let title:UILabel = UILabel.init(frame: CGRect(x: 0, y: 17, width: kWidth, height: 20))
        title.text = "点击账户头像进行切换"
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.titleColors(color: .darkGray)
        tempView.addSubview(title)
        return tempView
    }()
    //当前账号标记
    lazy var currentAccountLabel:UIView = {
        let tempView = UIView.init(frame: CGRect(x: kWidth/4 - 39, y: 249, width: 78, height: 20))
        
        let roundDot = UIView.init(frame: CGRect(x: 4, y: 4, width: 12, height: 12))
        roundDot.backgroundColor = UIColor.colorWithRgba(255, g: 177, b: 177, a: 1.0)
        roundDot.layer.cornerRadius = 6
        tempView.addSubview(roundDot)
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 78, height: 20))
        title.text = "当前帐户"
        title.textAlignment = .right
        title.font = UIFont.systemFont(ofSize: 14)
        tempView.addSubview(title)
        
        return tempView
    }()
    
    //经理头像+昵称
    lazy var managerAvatar:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: kWidth/4 - 59, y: 67, width: 118, height: 118))
        tempView.image = UIImage(named: "manageravatarimg")
        tempView.layer.cornerRadius = 6
        tempView.layer.masksToBounds = true
        tempView.isUserInteractionEnabled = true
//        tempView.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
//        tempView.layer.borderWidth = 0.5
        tempView.tag = 1
//        tempView.layer.shadowColor = UIColor.lineColors(color: .grayLevel3).cgColor
//        tempView.layer.shadowOffset = CGSize(width: 1, height: 3)
        return tempView
    }()
    lazy var managerName:UILabel = UILabel.init()
    //车间1头像+昵称
    lazy var producerAvatar:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: kWidth*3/4 - 59, y: 67, width: 118, height: 118))
        tempView.image = UIImage(named: "produceravatarimg")
        tempView.layer.cornerRadius = 6
        tempView.layer.masksToBounds = true
        tempView.isUserInteractionEnabled = true
//        tempView.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
//        tempView.layer.borderWidth = 0.5
        tempView.tag = 2
//        tempView.layer.shadowColor = UIColor.lineColors(color: .grayLevel3).cgColor
//        tempView.layer.shadowOffset = CGSize(width: 1, height: 3)
        return tempView
    }()
    lazy var producerName:UILabel = UILabel.init()
    
    lazy var closeLayerBtn:UIButton = UIButton.init(type: .custom)
    lazy var switchAccountTitle:UILabel = UILabel.init()
    
    lazy var switchAccountBtn:UIButton = {
        let tempBtn = UIButton.init(frame: CGRect(x: kWidth - 126, y: 0, width: 106, height: 44)) // 44
        tempBtn.setTitle("切换车间", for: .normal)
        tempBtn.addTarget(self, action: #selector(switchAccountBtnClicked), for: .touchUpInside)
        tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempBtn.contentHorizontalAlignment = .right
        tempBtn.contentVerticalAlignment = .center
        tempBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        
        let switchicon:UIImageView = UIImageView.init(frame: CGRect(x: 30, y: 16, width: 16, height: 12))
        switchicon.image = UIImage(named: "switchiconimg")
        tempBtn.addSubview(switchicon)
        
        return tempBtn
    }()
    //当前登录用户的信息
    var _roleType = 0 // 定义角色
    var _accountID = "1000000"// 定义用户ID
    var _accountNickName = "张三"// 用户昵称
    var _password = ""
    var _token = ""
    var addtionalAccountAvailable = false
    //附属账号的信息
    var _addtionalRoleType = 0
    var _addtionalAccountID = "10000000"
    var _addtionalNikeName = "张三"
    var _addtionalPassword = ""
    var _addtionalToken = ""
    
    override func viewWillAppear(_ animated: Bool) {
        //设置状态栏背景色
        setStatusBarBackgroundColor(color: .white)
        setStatusBarHiden(toHidden: false, ViewController: self)
       // setStatusBarBackgroundColor(color: .white)
       // UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 改成白色字体
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        //获取当前用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as! String
        let userid = userInfos.value(forKey: "userid") as! String
        let token = userInfos.value(forKey: "token") as! String
        let userName = userInfos.value(forKey: "nikename") as! String
        let password = userInfos.value(forKey: "password") as! String
        
        _roleType = Int(roletype)!
        _accountID = userid
        _accountNickName = userName
        _password = password
        _token = token
        
        //检查附属账号信息
        setupAddtionalAccountInfos()
        
        self.view.addSubview(userInfoTableView)
        
        nameBannerCell.backgroundColor = UIColor.clear
        accountIDCell.backgroundColor = UIColor.clear
        SetQuickAccessPermitCell.backgroundColor = UIColor.clear
        RoleTypeCell.backgroundColor = UIColor.clear
        
        createNameBanner()
        createAccountBanner()
        createRoleBanner()
        createUnlockBanner()
        createSetBanner()
        createVersionBanner()
        if _roleType != 3 && _roleType != 0{
            createInvoiceBanner()
        }
    }
    
    func setupAddtionalAccountInfos(){
        //附属账号信息
        let dataOperator = CoreDataOperation()
        addtionalAccountAvailable = dataOperator.checkAccountAvaiable(forAddtional: true) // 检查附属账号是否可用
        if addtionalAccountAvailable {
            let addtionalUserInfos = getAddtionalUserInfo()
            _addtionalRoleType = Int(addtionalUserInfos.value(forKey: "roletype") as! String)!
            _addtionalAccountID = addtionalUserInfos.value(forKey: "username") as! String
            _addtionalNikeName = addtionalUserInfos.value(forKey: "nikename") as! String
            _addtionalToken = addtionalUserInfos.value(forKey: "token") as! String
            _addtionalPassword = addtionalUserInfos.value(forKey: "password") as! String
        }else{
            //TODO: 附属账号不可用
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 88
        }else {
            return 58
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if _roleType == 3 || _roleType == 0{
            return 8
        }else{
            return 9
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        if(indexPath.section == 0){
            nameBannerCell.alpha = 1.0
            nameBannerCell.selectionStyle = UITableViewCellSelectionStyle.none
            return nameBannerCell
        }else if(indexPath.section == 1){
            accountIDCell.alpha = 1.0
            accountIDCell.selectionStyle = UITableViewCellSelectionStyle.none
            return accountIDCell
        }else if (indexPath.section == 2){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            RoleTypeCell.addSubview(seperateLine)
            
            RoleTypeCell.alpha = 1.0
            RoleTypeCell.selectionStyle = UITableViewCellSelectionStyle.none
            return RoleTypeCell
        }else if (indexPath.section == 3){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            SetQuickAccessPermitCell.addSubview(seperateLine)
            
            SetQuickAccessPermitCell.alpha = 1.0
            SetQuickAccessPermitCell.selectionStyle = UITableViewCellSelectionStyle.none
            return SetQuickAccessPermitCell
        }else if (indexPath.section == 4){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            SetParametersCell.addSubview(seperateLine)
            
            //参数设置
            SetParametersCell.alpha = 1.0
            SetParametersCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return SetParametersCell
        }else if (indexPath.section == 5){ // 发票
            if _roleType == 3 || _roleType == 0{
                //设置分割线
                let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
                seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                
                versionCell.addSubview(seperateLine)
                
                //参数设置
                versionCell.alpha = 1.0
                versionCell.selectionStyle = UITableViewCellSelectionStyle.none
                
                //设置分割线
                let seperateLineBottom:UIView = UIView.init(frame: CGRect(x: 20, y: 60, width: kWidth - 30, height: 1))
                seperateLineBottom.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                versionCell.addSubview(seperateLineBottom)
                return versionCell
            }
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            
            invoiceCell.addSubview(seperateLine)
            
            //参数设置
            invoiceCell.alpha = 1.0
            invoiceCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            //设置分割线
            let seperateLineBottom:UIView = UIView.init(frame: CGRect(x: 20, y: 60, width: kWidth - 30, height: 1))
            seperateLineBottom.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
           // invoiceCell.addSubview(seperateLineBottom)
            return invoiceCell
        }
        else if (indexPath.section == 6){
            if _roleType == 3 || _roleType == 0{
                switchAccountCell.alpha = 1.0
                switchAccountCell.selectionStyle = .none
                //            if !addtionalAccountAvailable{
                //                switchAccountBtn.isHidden = true
                //            }else{
                if _roleType == 4{
                    switchAccountBtn.isHidden = false
                    switchAccountBtn.setTitle("切换车间", for: .normal)
                }else{
                    if _accountID == "10000013" && addtionalAccountAvailable {
                        switchAccountBtn.setTitle("切换经理", for: .normal)
                        switchAccountBtn.isHidden = false
                    }else{
                        switchAccountBtn.isHidden = true
                    }
                }
                // }
                switchAccountCell.addSubview(switchAccountBtn)
                return switchAccountCell
            }
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            
            versionCell.addSubview(seperateLine)
            
            //参数设置
            versionCell.alpha = 1.0
            versionCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            //设置分割线
            let seperateLineBottom:UIView = UIView.init(frame: CGRect(x: 20, y: 60, width: kWidth - 30, height: 1))
            seperateLineBottom.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            versionCell.addSubview(seperateLineBottom)
            return versionCell
            
        }else if indexPath.section == 7{
            if _roleType == 3 || _roleType == 0{
                //设置登录按钮
                LogoutBtn.frame = CGRect(x: 20, y: 0, width: kWidth - 40, height: 50)
                //
                //            if UIDevice.current.isX() {
                //                LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-151, width:UIScreen.main.bounds.width - 40, height: 45)
                //            }else{
                //                LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-90, width:UIScreen.main.bounds.width - 40, height: 45)
                //            }
                //        LogoutBtn.layer.borderColor = UIColor.lightGray.cgColor
                LogoutBtn.layer.cornerRadius = 4
                //        LogoutBtn.layer.borderWidth = 0.5
                LogoutBtn.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
                LogoutBtn.setTitle("退出", for: UIControlState.normal)
                LogoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                LogoutBtn.setTitleColor(UIColor.titleColors(color: .black), for: UIControlState.normal)
                LogoutBtn.setTitleColor(UIColor.clear, for: UIControlState.highlighted)
                
                //  initTableView.addSubview(LogoutBtn)
                
                LogoutBtn.addTarget(self, action: #selector(LogoutBtnClick), for: UIControlEvents.touchUpInside)
                tableView.addSubview(logoutAccountCell)
                logoutAccountCell.addSubview(LogoutBtn)
                return logoutAccountCell
            }
            switchAccountCell.alpha = 1.0
            switchAccountCell.selectionStyle = .none
//            if !addtionalAccountAvailable{
//                switchAccountBtn.isHidden = true
//            }else{
                if _roleType == 4{
                    switchAccountBtn.isHidden = false
                    switchAccountBtn.setTitle("切换车间", for: .normal)
                }else{
                    if _accountID == "10000013" && addtionalAccountAvailable {
                        switchAccountBtn.setTitle("切换经理", for: .normal)
                        switchAccountBtn.isHidden = false
                    }else{
                        switchAccountBtn.isHidden = true
                    }
                }
           // }
            switchAccountCell.addSubview(switchAccountBtn)
            return switchAccountCell
        }else if indexPath.section == 8{
            //设置登录按钮
            LogoutBtn.frame = CGRect(x: 20, y: 0, width: kWidth - 40, height: 50)
//
//            if UIDevice.current.isX() {
//                LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-151, width:UIScreen.main.bounds.width - 40, height: 45)
//            }else{
//                LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-90, width:UIScreen.main.bounds.width - 40, height: 45)
//            }
            //        LogoutBtn.layer.borderColor = UIColor.lightGray.cgColor
            LogoutBtn.layer.cornerRadius = 4
            //        LogoutBtn.layer.borderWidth = 0.5
            LogoutBtn.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
            LogoutBtn.setTitle("退出", for: UIControlState.normal)
            LogoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            LogoutBtn.setTitleColor(UIColor.titleColors(color: .black), for: UIControlState.normal)
            LogoutBtn.setTitleColor(UIColor.clear, for: UIControlState.highlighted)
            
            //  initTableView.addSubview(LogoutBtn)
            
            LogoutBtn.addTarget(self, action: #selector(LogoutBtnClick), for: UIControlEvents.touchUpInside)
            tableView.addSubview(logoutAccountCell)
            logoutAccountCell.addSubview(LogoutBtn)
            return logoutAccountCell
        } else{
            RoleTypeCell.alpha = 1.0
            RoleTypeCell.selectionStyle = UITableViewCellSelectionStyle.none
            return RoleTypeCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let securitySettingsVC = SecuritySettingViewController()
            securitySettingsVC.MeVC = self
            self.present(securitySettingsVC, animated: true, completion: nil)
        }else if indexPath.section == 4 {
            let setParamtersVC = SetParamtersViewController(roleType: _roleType)
            setParamtersVC.MeVC = self
            self.present(setParamtersVC, animated: true, completion: nil)
        }else if indexPath.section == 5{
            if _roleType == 1 || _roleType == 2 || _roleType == 4 || _roleType == 5{
                let invoiceVC = invoiceViewController()
                self.present(invoiceVC, animated: true, completion: nil)
            }
        }
    }
    
    @objc func searchBtbClicked(){
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 40
        }else{
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createUnlockBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 22, y: 19, width: 17, height: 20))
        let unlockHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 19, width: 200, height: 21))
        
        //设置icon
        iconImageview.image = UIImage(named: "usersecuritysettingicon")
        
        unlockHitTitleLabel.text = "安全设置"
        unlockHitTitleLabel.font = UIFont.systemFont(ofSize: 15)
        unlockHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 25, y: 25, width: 5, height: 9))

        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:8,width:5,height:9)
        
        SetQuickAccessPermitCell.addSubview(iconImageview)
        SetQuickAccessPermitCell.addSubview(imageViewOfArrow)
        SetQuickAccessPermitCell.addSubview(unlockHitTitleLabel)
        userInfoTableView.addSubview(SetQuickAccessPermitCell)
    }
    
    
    func createSetBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 19, width: 20, height: 20))
        let parameterHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 19, width: 200, height: 21))
        //设置icon
        iconImageview.image = UIImage(named: "userparasettingicon")
        
        parameterHitTitleLabel.text = "参数设置"
        parameterHitTitleLabel.font = UIFont.systemFont(ofSize: 15)
        parameterHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 25, y: 25, width: 5, height: 9))
        
        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y: 8,width:5,height:9)
        
        SetParametersCell.addSubview(iconImageview)
        SetParametersCell.addSubview(imageViewOfArrow)
        SetParametersCell.addSubview(parameterHitTitleLabel)
        userInfoTableView.addSubview(SetParametersCell)
    }
    func createRoleBanner() {
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 22, width: 20, height: 15))
        let roleNameLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 19, width: 200, height: 21))
        let roleStringLabel:UILabel = UILabel.init(frame: CGRect(x: kWidth - 247, y: 20, width: 200, height: 18))
        
        //设置icon
        iconImageview.image = UIImage(named: "userroleicon")

        roleNameLabel.text = "用户身份"
        roleNameLabel.font = UIFont.systemFont(ofSize: 15)
        roleNameLabel.textAlignment = .left
    
        if _roleType == 0{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝会员"
        }else if _roleType == 1{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "客服"
        }else if _roleType == 2{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "方案师"
        }else if _roleType == 3{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制造商"
        }else if _roleType == 4{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "客服经理"
        }else if _roleType == 5{
            roleStringLabel.text = "公司员工"
        }else {
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝会员"
        }
        
        roleStringLabel.font = UIFont.systemFont(ofSize: 13)
        roleStringLabel.textColor = UIColor.titleColors(color: .darkGray)
        roleStringLabel.textAlignment = .right
        
        RoleTypeCell.addSubview(iconImageview)
        RoleTypeCell.addSubview(roleNameLabel)
        RoleTypeCell.addSubview(roleStringLabel)

        userInfoTableView.addSubview(RoleTypeCell)
    }
    func createAccountBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 18, width: 20, height: 20))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 19, width: 200, height: 21))
        let userAccountID:UILabel =  UILabel.init(frame: CGRect(x: kWidth - 247, y: 20, width: 200, height: 18))
        
        //设置icon
        iconImageview.image = UIImage(named: "useridicon")
        //设置账号标签
        userAccountLabel.text = "用户ID"
        userAccountLabel.font = UIFont.systemFont(ofSize: 15)
        userAccountLabel.textAlignment = .left
        
        //设置账号
        userAccountID.text = _accountID
        userAccountID.font = UIFont.systemFont(ofSize: 13)
        userAccountID.textColor = UIColor.titleColors(color: .darkGray)
        userAccountID.textAlignment = .right
        
        accountIDCell.addSubview(iconImageview)
        accountIDCell.addSubview(userAccountLabel)
        accountIDCell.addSubview(userAccountID)
        
        userInfoTableView.addSubview(accountIDCell)

    }
    
    //设置用户名面板
    func createNameBanner(){
        
        //设置名片的用户名
        let userNameLabel:UILabel = UILabel.init(frame: CGRect(x: 88, y: 49 , width: 300 , height: 30))
        userNameLabel.textAlignment = .natural
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        userNameLabel.text = _accountNickName
        
        //设置用户名片的头像
        let locale = CGRect(x:20 , y: 40, width:48.0, height:48.0)
        let avatar = createIcon(imageSize: 48.0, locale: locale, iconShape: AvatarShape.AvatarShapeTypeRound)
        nameBannerCell.addSubview(avatar)

        let seperateLine:UIView = UIView.init(frame: CGRect(x: 0, y: 123, width: kWidth, height: 5))
        seperateLine.backgroundColor = UIColor.lineColors(color: .grayLevel5)
        nameBannerCell.addSubview(seperateLine)
        //设置名版
        nameBannerCell.addSubview(userNameLabel)
        userInfoTableView.addSubview(nameBannerCell)
    }
    //设置版本号
    func createVersionBanner(){
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 20, width: 20, height: 18))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 20, width: 200, height: 21))
        let version:UILabel =  UILabel.init(frame: CGRect(x: kWidth - 247 , y: 20, width: 200, height: 18))
        
        //设置icon©
        iconImageview.image = UIImage(named: "versionicon")
        //设置账号标签
        userAccountLabel.text = "关于制宝"
        userAccountLabel.font = UIFont.systemFont(ofSize: 15)
        userAccountLabel.textAlignment = .left
        
        version.text = "V2.2.13"
        version.font = UIFont.systemFont(ofSize: 13)
        version.textColor = UIColor.titleColors(color: .gray)
        version.textAlignment = .right
        
        //设置账号
        
        versionCell.addSubview(iconImageview)
        versionCell.addSubview(userAccountLabel)
        versionCell.addSubview(version)
        
        userInfoTableView.addSubview(versionCell)
        
    }

    func createInvoiceBanner(){
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 19, width: 20, height: 20))
        let invoiceNameLabel:UILabel = UILabel.init(frame: CGRect(x: 60, y: 18, width: 200, height: 21))
        //let version:UILabel =  UILabel.init(frame: CGRect(x: 20, y: 8, width: kWidth - 40, height: 44))
        
        //设置icon
        iconImageview.image = UIImage(named: "invoiceiconimg")
        //设置账号标签
        invoiceNameLabel.text = "开票信息"
        invoiceNameLabel.font = UIFont.systemFont(ofSize: 15)
        invoiceNameLabel.textAlignment = .left
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 25, y: 25, width: 5, height: 9))
        
        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y: 8,width:5,height:9)
        //设置账号
        invoiceCell.addSubview(imageViewOfArrow)
        invoiceCell.addSubview(iconImageview)
        invoiceCell.addSubview(invoiceNameLabel)
      //  versionCell.addSubview(version)
        
        userInfoTableView.addSubview(invoiceCell)
        
    }
    
    @objc func LogoutBtnClick(){
        LogoutMission(viewControler: self)
    }
    
    @objc func switchAccountBtnClicked(){
        print("切换账号按钮点击了")
        _tabBarVC.view.addSubview(blurView)
        blurView.contentView.addSubview(grayLayer)
        grayLayer.addSubview(switchAccountBgView)
        
        closeLayerBtn.frame = CGRect(x: kWidth - 220, y: 20, width: 200, height: 22)
        closeLayerBtn.setTitle("取消", for: .normal)
        closeLayerBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        closeLayerBtn.contentHorizontalAlignment = .right
        closeLayerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        closeLayerBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        
        switchAccountTitle.frame = CGRect(x: 20, y: 20, width: kWidth - 40, height: 25)
        switchAccountTitle.textAlignment = .center
        switchAccountTitle.textColor = UIColor.backgroundColors(color: .black)
        switchAccountTitle.font = UIFont.boldSystemFont(ofSize: 18)
        switchAccountTitle.text = "切换账号"
        
        managerName.frame = CGRect(x: 0, y: 197, width: kWidth/2, height: 22)
        managerName.textAlignment = .center
        managerName.font = UIFont.systemFont(ofSize: 16)
        managerName.textColor = UIColor.titleColors(color: .black)
        
        producerName.frame = CGRect(x: kWidth/2, y: 197, width: kWidth/2, height: 22)
        producerName.text = "车间1"
        producerName.textAlignment = .center
        producerName.font = UIFont.systemFont(ofSize: 16)
        producerName.textColor = UIColor.titleColors(color: .black)
        
        if addtionalAccountAvailable {
            producerAvatar.image = UIImage(named: "produceravatarimg")
        }else{
            producerAvatar.image = UIImage(named: "addtionalneedssetimg")
        }
        
        switchAccountWhiteBoardView.frame = CGRect(x: 0, y: 65, width: kWidth, height: switchAccountBgView.frame.height - 65)
        
        if _roleType == 4{
            currentAccountLabel.frame = CGRect(x: (kWidth/2 - 78)/2, y: 249, width: 78, height: 20)
            managerName.text = _accountNickName
        }else{
            currentAccountLabel.frame = CGRect(x: kWidth*3/4 - 39, y: 249, width: 78, height: 20)
            managerName.text = _addtionalNikeName
//            print("_addtionalNikeName\(_addtionalNikeName)")
//            print("managerName\(managerName.text)")
        }
        
        let tapOnProducer = UITapGestureRecognizer(target: self, action: #selector(singleTapOnAvatar(_:)))
        tapOnProducer.numberOfTapsRequired = 1
        tapOnProducer.numberOfTouchesRequired = 1
        
        let tapOnManager = UITapGestureRecognizer(target: self, action: #selector(singleTapOnAvatar(_:)))
        tapOnManager.numberOfTapsRequired = 1
        tapOnManager.numberOfTouchesRequired = 1
        
        managerAvatar.addGestureRecognizer(tapOnManager)
        producerAvatar.addGestureRecognizer(tapOnProducer)
        
        switchAccountBgView.addSubview(closeLayerBtn)
        switchAccountBgView.addSubview(switchAccountTitle)
        switchAccountBgView.addSubview(switchAccountWhiteBoardView)
        switchAccountWhiteBoardView.addSubview(currentAccountLabel)
        switchAccountWhiteBoardView.addSubview(managerName)
        switchAccountWhiteBoardView.addSubview(managerAvatar)
        switchAccountWhiteBoardView.addSubview(producerName)
        switchAccountWhiteBoardView.addSubview(producerAvatar)
        
        setStatusBarHiden(toHidden: true, ViewController: _tabBarVC)
        UIView.animate(withDuration: 0.3) {
            self.switchAccountBgView.transform = CGAffineTransform(translationX: 0, y:  -380 - heightChangeForiPhoneXFromBottom) // 208 + heightChangeForiPhoneXFromTop
        }
        
    }
    
    @objc func cancelBtnClicked(){
        
        setStatusBarHiden(toHidden: false, ViewController: self)
        UIView.animate(withDuration: 0.3) {
            self.switchAccountBgView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        blurView.removeFromSuperview()
        grayLayer.removeFromSuperview()
    }
    func updateAddtionalAcountInfos(){
        //附属账号信息
        let dataOperator = CoreDataOperation()
        addtionalAccountAvailable = dataOperator.checkAccountAvaiable(forAddtional: true) // 检查附属账号是否可用
        if addtionalAccountAvailable {
            let addtionalUserInfos = getAddtionalUserInfo()
            _addtionalRoleType = Int(addtionalUserInfos.value(forKey: "roletype") as! String)!
            _addtionalAccountID = addtionalUserInfos.value(forKey: "username") as! String
            _addtionalNikeName = addtionalUserInfos.value(forKey: "nikename") as! String
            _addtionalToken = addtionalUserInfos.value(forKey: "token") as! String
            _addtionalPassword = addtionalUserInfos.value(forKey: "password") as! String
        }else{
            //TODO: 附属账号不可用
        }
    }
    @objc func singleTapOnAvatar(_ gesture:UITapGestureRecognizer){
        let index = gesture.view?.tag as! Int
        print("pressed on \(index)")
        if index == 2 && !addtionalAccountAvailable{
            let verifyVC = VerifyPasswordViewController()
            verifyVC.meVC = self
            self.present(verifyVC, animated: true, completion: nil)
        }else{
            if (index == 1 && _roleType == 4) || (index == 2 && _accountID == "10000013"){
                cancelBtnClicked()
                greyLayerPrompt.show(text: "选择当前账户,不必切换")
            }else{
                print("需要切换账户")
                if index == 1{
                    let alert = UIAlertController(title: "确认切换", message: "确认切换到经理账号?", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "切换", style: .default) { (action) in
                        print("点击了确定")
                        //解绑当前账户的devicetoken
                        let deviceToken = UserDefaults.standard.value(forKey: "myDeviceToken")
                        if deviceToken != nil{
                            updatesDeviceToken(withDeviceToken: deviceToken as! String, user: self._accountID, toBind: false)
                        }
                        
                        setStatusBarHiden(toHidden: false, ViewController: self)
                        let lgoinUser = User()
                        let hub = self.pleaseWait()
                        lgoinUser.isSwitching = true
                        lgoinUser._nikeName = self._addtionalNikeName
                        lgoinUser.Login(username: self._addtionalAccountID, password: self._addtionalPassword,view:self,hub:hub)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    print("切换到经理")
                }else{
                    let alert = UIAlertController(title: "确认切换", message: "确认切换到车间账号?", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let confirmAction = UIAlertAction(title: "切换", style: .default) { (action) in
                        setStatusBarHiden(toHidden: false, ViewController: self)
                        print("点击了确定")
                        //解绑当前账户的devicetoken
                        let deviceToken = UserDefaults.standard.value(forKey: "myDeviceToken")
                        if deviceToken != nil{
                            updatesDeviceToken(withDeviceToken: deviceToken as! String, user: self._accountID, toBind: false)
                        }
                        
                        let lgoinUser = User()
                        let hub = self.pleaseWait()
                        lgoinUser.isSwitching = true
                        lgoinUser._nikeName = self._addtionalNikeName
                        lgoinUser.Login(username: self._addtionalAccountID, password: self._addtionalPassword,view:self,hub:hub)
                    }
                    alert.addAction(cancelAction)
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    print("切换到车间")
                }
            }
        }
    }
}


