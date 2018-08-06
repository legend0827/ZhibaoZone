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

    var tableView:UITableView?
    var nameBannerCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: -33, width: UIScreen.main.bounds.width, height: 88))
    var accountIDCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var RoleTypeCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var SetQuickAccessPermitCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var SetParametersCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var versionCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var switchAccountCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
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
        tempView.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
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
//        tempView.layer.shadowColor = UIColor.lineColors(color: .lightGray).cgColor
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
//        tempView.layer.shadowColor = UIColor.lineColors(color: .lightGray).cgColor
//        tempView.layer.shadowOffset = CGSize(width: 1, height: 3)
        return tempView
    }()
    lazy var producerName:UILabel = UILabel.init()
    
    lazy var closeLayerBtn:UIButton = UIButton.init(type: .custom)
    lazy var switchAccountTitle:UILabel = UILabel.init()
    
    lazy var switchAccountBtn:UIButton = {
        let tempBtn = UIButton.init(frame: CGRect(x: kWidth - 121, y: 0, width: 106, height: 44)) // 44
        tempBtn.setTitle("切换车间", for: .normal)
        tempBtn.addTarget(self, action: #selector(switchAccountBtnClicked), for: .touchUpInside)
        tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempBtn.contentHorizontalAlignment = .right
        tempBtn.contentVerticalAlignment = .center
        tempBtn.setTitleColor(UIColor.titleColors(color: .red), for: .normal)
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
        setStatusBarBackgroundColor(color: .clear)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 改成白色字体
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let MeBackgroundImageView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 100 + heightChangeForiPhoneXFromTop))
        MeBackgroundImageView.image = UIImage(named: "meBackgroundImg")
        self.view.addSubview(MeBackgroundImageView)
        
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
        
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableViewStyle.grouped)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        tableView?.estimatedRowHeight = 0;
        tableView?.estimatedSectionHeaderHeight = 0;
        tableView?.estimatedSectionFooterHeight = 0;
        
        nameBannerCell.backgroundColor = UIColor.clear
        accountIDCell.backgroundColor = UIColor.clear
        SetQuickAccessPermitCell.backgroundColor = UIColor.clear
        RoleTypeCell.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        tableView?.backgroundColor = UIColor.clear// #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.bounces = true
        tableView?.separatorStyle = .singleLine
        
        //设置登录按钮
        let LogoutBtn:UIButton = UIButton.init(type: UIButtonType.system)
        if UIDevice.current.isX() {
            LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-201, width:UIScreen.main.bounds.width - 40, height: 45)
        }else{
            LogoutBtn.frame = CGRect(x:20, y:UIScreen.main.bounds.height-140, width:UIScreen.main.bounds.width - 40, height: 45)
        }
//        LogoutBtn.layer.borderColor = UIColor.lightGray.cgColor
        LogoutBtn.layer.cornerRadius = 6
//        LogoutBtn.layer.borderWidth = 0.5
        LogoutBtn.layer.backgroundColor = UIColor.iconColors(color: .red).cgColor
        LogoutBtn.setTitle("退出", for: UIControlState.normal)
        LogoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        LogoutBtn.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        LogoutBtn.setTitleColor(UIColor.clear, for: UIControlState.highlighted)
        
        tableView?.addSubview(LogoutBtn)
            
        LogoutBtn.addTarget(self, action: #selector(LogoutBtnClick), for: UIControlEvents.touchUpInside)

        //登出按钮左侧图标
//        let imgLogout = UIImageView(frame: CGRect(x: 5, y: (44-30)/2, width: 30, height: 30))
//        imgLogout.image = UIImage(named:"logouticon-white")
//        LogoutBtn.addSubview(imgLogout)
        //emytyAreaShowingLabel()
        createNameBanner()
        createAccountBanner()
        createRoleBanner()
        createUnlockBanner()
        createSetBanner()
        createVersionBanner()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 88
        }else {
            return 44
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
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
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            accountIDCell.addSubview(seperateLine)
            
            accountIDCell.alpha = 1.0
            accountIDCell.selectionStyle = UITableViewCellSelectionStyle.none
            return accountIDCell
        }else if (indexPath.section == 2){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            RoleTypeCell.addSubview(seperateLine)
            
            RoleTypeCell.alpha = 1.0
            RoleTypeCell.selectionStyle = UITableViewCellSelectionStyle.none
            return RoleTypeCell
        }else if (indexPath.section == 3){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            SetQuickAccessPermitCell.addSubview(seperateLine)
            
            SetQuickAccessPermitCell.alpha = 1.0
            SetQuickAccessPermitCell.selectionStyle = UITableViewCellSelectionStyle.none
            return SetQuickAccessPermitCell
        }else if (indexPath.section == 4){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            SetParametersCell.addSubview(seperateLine)
            
            //参数设置
            SetParametersCell.alpha = 1.0
            SetParametersCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return SetParametersCell
        }else if (indexPath.section == 5){
            //设置分割线
            let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 0, width: kWidth - 30, height: 1))
            seperateLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            
            versionCell.addSubview(seperateLine)
            
            //参数设置
            versionCell.alpha = 1.0
            versionCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            //设置分割线
            let seperateLineBottom:UIView = UIView.init(frame: CGRect(x: 20, y: 60, width: kWidth - 30, height: 1))
            seperateLineBottom.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            versionCell.addSubview(seperateLineBottom)
            return versionCell
            
        }else if indexPath.section == 6{
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
        }else{
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
        }
    }
    
    @objc func searchBtbClicked(){
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }else if section == 1{
            return 40
        }else{
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func LogoutBtnClick(){
        //跳转页面
        let LoginVC = ViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        LoginVC.needsAutoLogin = false
        
        appDelegate.window?.rootViewController = LoginVC
        self.present(LoginVC, animated: true, completion: nil)
    }
    
    func createUnlockBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 22, y: 18, width: 20, height: 24))
        let unlockHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 64, y: 8, width: 200, height: 44))
        
        //设置icon
        iconImageview.image = UIImage(named: "usersecuritysettingicon")
        
        unlockHitTitleLabel.text = "安全设置"
        unlockHitTitleLabel.font = UIFont.systemFont(ofSize: 16)
        unlockHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 38, y: 15, width: 30, height: 30))

        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:8,width:18,height:18)
        
        SetQuickAccessPermitCell.addSubview(iconImageview)
        SetQuickAccessPermitCell.addSubview(imageViewOfArrow)
        SetQuickAccessPermitCell.addSubview(unlockHitTitleLabel)
        tableView?.addSubview(SetQuickAccessPermitCell)
    }
    
    
    func createSetBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 18, width: 24, height: 24))
        let parameterHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 64, y: 8, width: 200, height: 44))
        //设置icon
        iconImageview.image = UIImage(named: "userparasettingicon")
        
        parameterHitTitleLabel.text = "参数设置"
        parameterHitTitleLabel.font = UIFont.systemFont(ofSize: 16)
        parameterHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 38, y: 15, width: 30, height: 30))
        
        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y: 8,width:18,height:18)
        
        SetParametersCell.addSubview(iconImageview)
        SetParametersCell.addSubview(imageViewOfArrow)
        SetParametersCell.addSubview(parameterHitTitleLabel)
        tableView?.addSubview(SetParametersCell)
    }
    func createRoleBanner() {
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 21, width: 24, height: 18))
        let roleNameLabel:UILabel = UILabel.init(frame: CGRect(x: 64, y: 8, width: 200, height: 44))
        let roleStringLabel:UILabel = UILabel.init(frame: CGRect(x: 93+44, y: 8, width: 200, height: 44))
        
        //设置icon
        iconImageview.image = UIImage(named: "userroleicon")

        roleNameLabel.text = "用户身份:"
        roleNameLabel.font = UIFont.systemFont(ofSize: 16)
        roleNameLabel.textAlignment = .left
    
        if _roleType == 0{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝会员"
        }else if _roleType == 1{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝客户服务"
        }else if _roleType == 2{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝方案设计师"
        }else if _roleType == 3{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "合作生产车间"
        }else if _roleType == 4{
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "客服经理"
        }else {
            //0 普通用户 1 客服 2 设计师 3 工厂
            roleStringLabel.text = "制宝会员"
        }
        
        roleStringLabel.font = UIFont.systemFont(ofSize: 16)
        roleStringLabel.textColor = UIColor.titleColors(color: .darkGray)
        roleStringLabel.textAlignment = .left
        
        RoleTypeCell.addSubview(iconImageview)
        RoleTypeCell.addSubview(roleNameLabel)
        RoleTypeCell.addSubview(roleStringLabel)

        tableView?.addSubview(RoleTypeCell)
    }
    func createAccountBanner(){
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 18, width: 24, height: 24))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: 64, y: 8, width: 200, height: 44))
        let userAccountID:UILabel =  UILabel.init(frame: CGRect(x: 93+24, y: 8, width: 200, height: 44))
        
        //设置icon
        iconImageview.image = UIImage(named: "useridicon")
        //设置账号标签
        userAccountLabel.text = "用户ID:"
        userAccountLabel.font = UIFont.systemFont(ofSize: 16)
        userAccountLabel.textAlignment = .left
        
        //设置账号
        userAccountID.text = _accountID
        userAccountID.font = UIFont.systemFont(ofSize: 16)
        userAccountID.textColor = UIColor.titleColors(color: .darkGray)
        userAccountID.textAlignment = .left
        
        accountIDCell.addSubview(iconImageview)
        accountIDCell.addSubview(userAccountLabel)
        accountIDCell.addSubview(userAccountID)
        
        tableView?.addSubview(accountIDCell)

    }
    func createNameBanner (){
        
        //设置名片的用户名
        let userNameLabel:UILabel = UILabel.init(frame: CGRect(x: (kWidth-300)/2, y: 68 , width: 300 , height: 40))
        
        userNameLabel.text = _accountNickName
        
        //设置用户名片的头像
        let locale = CGRect(x:(kWidth - 65)/2 , y: 0, width:65.0, height:65.0)
        let avatar = createIcon(imageSize: 65.0, locale: locale, iconShape: AvatarShape.AvatarShapeTypeRound)
        nameBannerCell.addSubview(avatar)

        //设置昵称
        userNameLabel.textAlignment = .center
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        //设置名版
        nameBannerCell.addSubview(userNameLabel)
        tableView?.addSubview(nameBannerCell)
    }
    
    func createVersionBanner(){
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 18, width: 24, height: 24))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: 64, y: 8, width: 200, height: 44))
        let version:UILabel =  UILabel.init(frame: CGRect(x: 20, y: 8, width: kWidth - 40, height: 44))
        
        //设置icon
        iconImageview.image = UIImage(named: "versionicon")
        //设置账号标签
        userAccountLabel.text = "关于制宝"
        userAccountLabel.font = UIFont.systemFont(ofSize: 16)
        userAccountLabel.textAlignment = .left
        
        version.text = "V2.0.8"
        version.font = UIFont.systemFont(ofSize: 14)
        version.textColor = UIColor.titleColors(color: .gray)
        version.textAlignment = .right
        
        //设置账号
        
        versionCell.addSubview(iconImageview)
        versionCell.addSubview(userAccountLabel)
        versionCell.addSubview(version)
        
        tableView?.addSubview(versionCell)
        
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
            print("_addtionalNikeName\(_addtionalNikeName)")
            print("managerName\(managerName.text)")
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
            //TODO: 设置附属账号
            print("设置附属账号")
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


