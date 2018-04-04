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

let avatars:NSDictionary = [
    "1":"default1",
    "2":"default2",
    "3":"default3",
    "4":"default4",
    "5":"default5",
    "6":"default6",
    "7":"default7",
    "8":"default8",
    "9":"default9",
    "10":"default10"
]

enum AvatarShape: String {
    /// 圆角正方形
    case AvatarShapeTypeSquareWithRadius = "Radius"
    /// 圆形
    case AvatarShapeTypeRound 
    /// 正方形
    case AvatarShapeTypeSquare
    
}

//创建头像方法
func createIcon(imageSize:CGFloat,locale:CGRect,iconShape:AvatarShape) -> UIView {
    let photo = UIImageView()
    //随机取头像
    let avatarIndex = Int(arc4random()%10+1)
    print(avatarIndex)
    let image = UIImage(named:avatars.value(forKey: String(avatarIndex)) as! String)
    
    photo.bounds = CGRect(x:(UIScreen.main.bounds.width - imageSize)/2,y:(UIScreen.main.bounds.height-imageSize)/2-122,width:imageSize,height:imageSize)
    photo.frame = locale
    
    // 设置图片的外围圆框*
    photo.layer.masksToBounds = true
    photo.layer.borderColor = UIColor.white.cgColor
    photo.layer.borderWidth = 2
    
    // 用设置圆角的方法设置圆形
    switch iconShape {
    case .AvatarShapeTypeSquare:
        photo.layer.cornerRadius =  0
    case .AvatarShapeTypeRound:
        photo.layer.cornerRadius =  photo.bounds.height/2
        photo.layer.borderColor = UIColor.colorWithRgba(240, g: 240, b: 240, a: 1).cgColor
    case .AvatarShapeTypeSquareWithRadius:
        var cornerRadius = photo.bounds.height/6
        if cornerRadius >= 10{
            cornerRadius = 10
        }
        photo.layer.cornerRadius =  cornerRadius
        
    default:
        var cornerRadius = photo.bounds.height/6
        if cornerRadius >= 10{
            cornerRadius = 10
        }
        photo.layer.cornerRadius =  cornerRadius
    }
    
    photo.image = image
    return photo
}

class MeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    //
    var tableView:UITableView?
    
    var nameBannerCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
    var RoleTypeCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var SetQuickAccessPermitCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var SetParametersCell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    var RoleType = 0 // 定义角色
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableViewStyle.grouped)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        tableView?.estimatedRowHeight = 0;
        tableView?.estimatedSectionHeaderHeight = 0;
        tableView?.estimatedSectionFooterHeight = 0;
        
        nameBannerCell.backgroundColor = UIColor.white
        SetQuickAccessPermitCell.backgroundColor = UIColor.white
        RoleTypeCell.backgroundColor = UIColor.white
        self.view.backgroundColor = #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        tableView?.backgroundColor = #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.bounces = true
        
        //设置登录按钮
        let LogoutBtn:UIButton = UIButton.init(type: UIButtonType.system)
        if UIDevice.current.isX() {
            LogoutBtn.frame = CGRect(x:45, y:UIScreen.main.bounds.height-191, width:UIScreen.main.bounds.width - 90, height: 44)
        }else{
            LogoutBtn.frame = CGRect(x:45, y:UIScreen.main.bounds.height-130, width:UIScreen.main.bounds.width - 90, height: 44)
        }
        LogoutBtn.layer.borderColor = UIColor.lightGray.cgColor
        LogoutBtn.layer.cornerRadius = 5
        LogoutBtn.layer.borderWidth = 0.5
        LogoutBtn.layer.backgroundColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        LogoutBtn.setTitle("登出", for: UIControlState.normal)
        LogoutBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        
        tableView?.addSubview(LogoutBtn)
        LogoutBtn.addTarget(self, action: #selector(LogoutBtnClick), for: UIControlEvents.touchUpInside)

        //登出按钮左侧图标
        let imgLogout = UIImageView(frame: CGRect(x: 5, y: (44-30)/2, width: 30, height: 30))
        imgLogout.image = UIImage(named:"logouticon-white")
        LogoutBtn.addSubview(imgLogout)
        //emytyAreaShowingLabel()
        createNameBanner()
        createRoleBanner()
        createUnlockBanner()
        createSetBanner()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 88
        }else {
            return 44
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
            RoleTypeCell.alpha = 1.0
            RoleTypeCell.selectionStyle = UITableViewCellSelectionStyle.none
            return RoleTypeCell
        }else if (indexPath.section == 2){
            SetQuickAccessPermitCell.alpha = 1.0
            SetQuickAccessPermitCell.selectionStyle = UITableViewCellSelectionStyle.none
            return SetQuickAccessPermitCell
        }else if (indexPath.section == 3){
            //参数设置
            SetParametersCell.alpha = 1.0
            SetParametersCell.selectionStyle = UITableViewCellSelectionStyle.none
            return SetParametersCell
        }else{
            RoleTypeCell.alpha = 1.0
            RoleTypeCell.selectionStyle = UITableViewCellSelectionStyle.none
            return RoleTypeCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let securitySettingsVC = SecuritySettingViewController()
            securitySettingsVC.MeVC = self
            self.present(securitySettingsVC, animated: true, completion: nil)
        }else if indexPath.section == 3 {
            let setParamtersVC = SetParamtersViewController(roleType: RoleType)
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
        let unlockHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 200, height: 44))
        unlockHitTitleLabel.text = "安全设置"
        unlockHitTitleLabel.font = UIFont.systemFont(ofSize: 15)
        unlockHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 30, y: 8, width: 30, height: 30))

        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:8,width:15,height:15)
        
        SetQuickAccessPermitCell.addSubview(imageViewOfArrow)
        SetQuickAccessPermitCell.addSubview(unlockHitTitleLabel)
        tableView?.addSubview(SetQuickAccessPermitCell)
    }
    
    
    func createSetBanner(){
        let parameterHitTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 200, height: 44))
        parameterHitTitleLabel.text = "参数设置"
        parameterHitTitleLabel.font = UIFont.systemFont(ofSize: 15)
        parameterHitTitleLabel.textAlignment = .left
        
        let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 30, y: 8, width: 30, height: 30))
        
        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:8,width:15,height:15)
        
        SetParametersCell.addSubview(imageViewOfArrow)
        SetParametersCell.addSubview(parameterHitTitleLabel)
        tableView?.addSubview(SetParametersCell)
    }
    func createRoleBanner() {
        
        let roleNameLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 200, height: 44))
        let roleStringLabel:UILabel = UILabel.init(frame: CGRect(x: 93, y: 0, width: 200, height: 44))
        
        roleNameLabel.text = "用户身份:"
        roleNameLabel.font = UIFont.systemFont(ofSize: 15)
        roleNameLabel.textAlignment = .left
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            for info in fetchResult {
                if info.roleType == 0{
                    //0 普通用户 1 客服 2 设计师 3 工厂
                    roleStringLabel.text = "制宝会员"
                    RoleType = 0
                }else if info.roleType == 1{
                    //0 普通用户 1 客服 2 设计师 3 工厂
                    roleStringLabel.text = "制宝客户服务"
                    RoleType = 1
                }else if info.roleType == 2{
                    //0 普通用户 1 客服 2 设计师 3 工厂
                    roleStringLabel.text = "制宝方案设计师"
                    RoleType = 2
                }else if info.roleType == 3{
                    //0 普通用户 1 客服 2 设计师 3 工厂
                    roleStringLabel.text = "合作生产车间"
                    RoleType = 3
                }else {
                    //0 普通用户 1 客服 2 设计师 3 工厂
                    roleStringLabel.text = "制宝会员"
                    RoleType = 0
                }
            }
        } catch {
            print("获取数据失败\(error)")
        }
        roleStringLabel.font = UIFont.systemFont(ofSize: 15)
        roleStringLabel.textColor = UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        roleStringLabel.textAlignment = .left
        
        RoleTypeCell.addSubview(roleNameLabel)
        RoleTypeCell.addSubview(roleStringLabel)

        tableView?.addSubview(RoleTypeCell)
    }
    func createNameBanner (){
        
        //设置名片的用户名
        
        let userNameLabel:UILabel = UILabel.init(frame: CGRect(x: 105, y: (65/2)-13, width: UIScreen.main.bounds.width-105-40 , height: 40))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: 105, y: (65/2)+17, width: UIScreen.main.bounds.width-105-40 , height: 30))
        let userAccountID:UILabel = UILabel.init(frame: CGRect(x: 158, y: (65/2)+17, width: UIScreen.main.bounds.width-105-40 , height: 30))
        
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        fetchRequest.returnsObjectsAsFaults = false
        // 设置查询条件
        let predicate = NSPredicate(format: "id = 1")
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try context.fetch(fetchRequest)
            for info in fetchResult {
                userNameLabel.text = info.nickName
                userAccountID.text = String(info.userId)
            }
        } catch {
            print("获取数据失败\(error)")
        }
        //设置用户名片的头像
        let locale = CGRect(x:20, y:12, width:65.0, height:65.0)
        let avatar = createIcon(imageSize: 65.0, locale: locale, iconShape: AvatarShape.AvatarShapeTypeSquareWithRadius)
        nameBannerCell.addSubview(avatar)

        //设置昵称
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        //设置账号标签
        userAccountLabel.text = "用户ID:"
        userAccountLabel.font = UIFont.systemFont(ofSize: 15)
        userAccountLabel.textAlignment = .left
        
        //设置账号
        //userAccountID.text = "ltq@163.com"
        userAccountID.font = UIFont.systemFont(ofSize: 15)
        userAccountID.textColor = UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)
        userAccountID.textAlignment = .left
        
        //设置名版
        
        
        nameBannerCell.addSubview(userNameLabel)
        nameBannerCell.addSubview(userAccountLabel)
        nameBannerCell.addSubview(userAccountID)
        
        tableView?.addSubview(nameBannerCell)
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


