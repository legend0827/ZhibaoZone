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
    
    var _roleType = 0 // 定义角色
    var _accountID = "1000000"// 定义用户ID
    var _accountNickName = "张三"// 用户昵称
    
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
        
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        // let token = userInfos.value(forKey: "token") as? String
        
        let userInfo = getUserAccountInfo() // 0.userName 1. nikeName
        //   let userAccount = userInfo.0
        let userName = userInfo.1
        
        _roleType = Int(roletype!)!
        _accountID = userid!
        _accountNickName = userName
        
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
        let imgLogout = UIImageView(frame: CGRect(x: 5, y: (44-30)/2, width: 30, height: 30))
        imgLogout.image = UIImage(named:"logouticon-white")
        LogoutBtn.addSubview(imgLogout)
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
        return 6
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
        let appDelegate = AppDelegate()
        
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
        
        let iconImageview:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: 18, width: 24, height: 18))
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
        
        version.text = "V2.0.4"
        version.font = UIFont.systemFont(ofSize: 14)
        version.textColor = UIColor.titleColors(color: .gray)
        version.textAlignment = .right
        
        //设置账号
        
        versionCell.addSubview(iconImageview)
        versionCell.addSubview(userAccountLabel)
        versionCell.addSubview(version)
        
        tableView?.addSubview(versionCell)
        


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


