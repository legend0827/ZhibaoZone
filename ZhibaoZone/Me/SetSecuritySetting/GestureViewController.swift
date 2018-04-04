//
//  GestureViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 15/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

enum GestureViewControllerType: Int {
    case setting = 1
    case login
    case resetGesture
}

enum buttonTag: Int {
    case rest = 1
    case manager
    case forget
}

class GestureViewController: UIViewController {
    
    ///SecuritySettingVC
    var securityVC = SecuritySettingViewController()
    /// VerifyGestureVC
    var verifyGestureVC = GestureVerifyViewController()
    /// LoginPage
    var loginVC = ViewController()

    /// 控制器的来源类型:设置密码、登录
    var type:GestureViewControllerType?
    
    /// 绘制解锁界面准备好时，提示文字
    var gestureTextBeforeSet = "绘制解锁图案"
    
    /// 重置按钮
    fileprivate var resetBtn: UIButton?
    
    /// 提示Label
    fileprivate var msgLabel: LockLabel?
    
    /// 解锁界面
    fileprivate  var lockView: CircleView?
    
    /// infoView
    fileprivate var infoView: CircleInfoView?
    
    let navigationBarInGestureView:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 27, width: UIScreen.main.bounds.width, height: 45))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white//clear
        
        //1.界面相同部分生成器
        setupSameUI()
        
        //2.界面不同部分生成器
        setupDifferentUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if self.type == GestureViewControllerType.login {
            navigationController?.isNavigationBarHidden = true
        }
        
        //进来先清空存储的第一个密码
        CircleView.saveGesture(nil, key: gestureOneSaveKey)
    }
    
    
    func setupSameUI(){
        
        //创建导航栏右边按钮
        
        navigationBarInGestureView.isHidden = false
        navigationBarInGestureView.backgroundColor = UIColor.white
        navigationBarInGestureView.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "绘制手势密码"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let rightButton = itemWithTile("重绘", target: self, action: #selector(GestureViewController.didClickBtn(_:)), tag: buttonTag.rest.rawValue)
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        navItem.setRightBarButton(rightButton, animated: false)
        navItem.setLeftBarButton(leftButton, animated: false)
        
        navigationBarInGestureView.pushItem(navItem, animated: false)
        view.addSubview(navigationBarInGestureView)
        
        //解锁界面
        let lockView = CircleView()
        lockView.delegate = self
        self.lockView = lockView
        view.addSubview(lockView)
        
        let msgLabel = LockLabel.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 14))
        msgLabel.center = CGPoint(x: kScreenW/2, y: lockView.frame.minY - 30) // -30
        if type == GestureViewControllerType.login {
            msgLabel.center = CGPoint(x: kScreenW/2, y: lockView.frame.minY )
        }
        
        self.msgLabel = msgLabel
        
        view.addSubview(msgLabel)
        
    }
    //关闭
    @objc func cancelBtnClicked(){
        if type == GestureViewControllerType.resetGesture{
            verifyGestureVC.presentActionType = "dismissFromSetting"
            verifyGestureVC.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }else if type == GestureViewControllerType.login {
            loginVC.presentType = "dismissing"
            loginVC.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    //MARK:- 创建UIBarButtonItem
    
    func itemWithTile(_ title: NSString,target: AnyObject,action: Selector,tag: NSInteger) -> UIBarButtonItem{
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle(title as String, for: UIControlState())
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.tag = tag
        button.contentHorizontalAlignment = .right
        button.isHidden = true
        button.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: UIControlState())
        self.resetBtn = button
        
        return UIBarButtonItem(customView: button)
    }
    
    func setupDifferentUI() {
        
        switch self.type! {
        case GestureViewControllerType.setting:
            setupSubViewsSettingVc()
            break
        case GestureViewControllerType.login:
            setupSubViewsLoginVc()
            break
        case GestureViewControllerType.resetGesture:
            setupSubViewsSettingVc()
            break
        }
    }
    
    //MARK: -设置手势密码界面
    func setupSubViewsSettingVc() {
        
        self.lockView?.type = CircleViewType.circleViewTypeSetting
        
        title = "设置手势密码"
        
        self.msgLabel?.showNormalMag(gestureTextBeforeSet as NSString)
        
        let infoView = CircleInfoView()
        infoView.frame = CGRect(x: 0, y: 0, width: CircleRadius * 2 * 0.6, height: CircleRadius * 2 * 0.6)
        
        infoView.center = CGPoint(x: kScreenW/2, y: self.msgLabel!.frame.minY - infoView.frame.height/2 - 10)
        self.infoView = infoView
        view.addSubview(infoView)  
    }
    
    //MARK: - 登录手势密码
    func setupSubViewsLoginVc() {
        self.lockView?.type = CircleViewType.circleViewTypeLogin
        
        //头像
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
//        imageView.center = CGPoint(x: kScreenW/2, y: kScreenH/5)
//        imageView.image = UIImage(named: "head")
//        view.addSubview(imageView)
        
        let userNameLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: 180, width: 200, height: 20))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 150, y: 205, width: 300, height: 20))
        
        let userInfo = getUserAccountInfo() // 0.userName 1. nikeName
        let userName = userInfo.1
        let userAccount = userInfo.0
        if userName == "_NONE"{
            userNameLabel.text = "用户名不存在"
        }else{
            userNameLabel.text = userName
        }
        var accountID = ""
        userNameLabel.textAlignment = .center
        if userAccount == "_NONE" {
            accountID = "用户账号不存在"
        }else{
            accountID = userAccount
        }
        //let tailIndex = accountID.index(accountID.startIndex, offsetBy: accountID.lengthOfBytes(using: .utf8) - 3)
        //let aheadIndex = accountID.index(accountID.startIndex, offsetBy: 3)
        userAccountLabel.text = accountID//"\(accountID.substring(to:aheadIndex))*****\(accountID.substring(from: tailIndex))"
        userAccountLabel.textAlignment = .center
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 15) //systemFont(ofSize: 15)
        userAccountLabel.font = UIFont.systemFont(ofSize: 15)
        
        //userAccountID.font = UIFont.systemFont(ofSize: 15)
        
        
        let iconLocale:CGRect = CGRect(x: UIScreen.main.bounds.width/2 - 65.0/2, y: 100, width: 65.0, height: 65.0)
        let avatar = createIcon(imageSize: 65.0, locale: iconLocale, iconShape: AvatarShape.AvatarShapeTypeRound)
        view.addSubview(avatar)
        view.addSubview(userNameLabel)
        view.addSubview(userAccountLabel)
        
        //登录其它账户
        let rightBtn = UIButton(type: UIButtonType.custom)
        
        creatButton(rightBtn, frame: CGRect(x: kScreenW/2 - CircleViewEdgeMargin - 20, y: kScreenH - 60, width: kScreenW/2, height: 20), titlr: "登录其他账户", alignment: UIControlContentHorizontalAlignment.right, tag: buttonTag.forget.rawValue)
        
        
        
    }
    
    //MARK: - 创建Button
    func creatButton(_ btn: UIButton,frame: CGRect,titlr: NSString,alignment: UIControlContentHorizontalAlignment,tag: NSInteger) {
        btn.frame = frame
        btn.tag = tag
        btn.setTitle(titlr as String, for: UIControlState())
        btn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: UIControlState())
        btn.contentHorizontalAlignment = alignment
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(GestureViewController.didClickBtn(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn)
        
    }
    
    @objc func didClickBtn(_ sender:UIButton){
        
        switch sender.tag {
        case buttonTag.rest.rawValue:
            //1.隐藏按钮
            self.resetBtn?.isHidden = true
            
            //2.infoView取消选中
            infoViewDeselectedSubviews()
            
            //3.msgLabel提示文字复位
            self.msgLabel?.showNormalMag(gestureTextBeforeSet as NSString)
            
            //4.清除之前存储的密码
            CircleView.saveGesture(nil, key: gestureOneSaveKey)
            break
        case buttonTag.manager.rawValue:
            print("点击了手势管理密码按钮")
            break
        case buttonTag.forget.rawValue:
            print("点击了登录其他账户按钮")
            loginVC.presentType = "dismissing"
            loginVC.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
    
    //MARK: - 让infoView对应按钮取消选中
    func infoViewDeselectedSubviews() {
        
        ((self.infoView?.subviews)! as NSArray).enumerateObjects({ (obj, idx, stop) in
            
            (obj as! Circle).state = CircleState.circleStateNormal
        })
        
    }
}

extension GestureViewController: CircleViewDelegate {
    
    func circleViewConnectCirclesLessThanNeedWithGesture(_ view: CircleView, type: CircleViewType, gesture: String) {
        
        //swift 很奇葩
        guard CircleView.getGestureWithKey(gestureOneSaveKey) != nil else {
            self.msgLabel?.showWarnMsgAndShake("最少连接\(CircleSetCountLeast)点,请重新输入")
            return
        }
        
        let gestureOne = CircleView.getGestureWithKey(gestureOneSaveKey)! as NSString
        
        //看是否存在第一个密码
        if gestureOne.length > 0 {
            self.resetBtn?.isHidden = false
            self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgainError)
        } else {
            print("密码长度不合格\(gestureOne.length)")
            self.msgLabel?.showWarnMsgAndShake(gestureTextConnectLess as String)
        }
        
        
    }
    
    func circleViewdidCompleteSetFirstGesture(_ view: CircleView, type: CircleViewType, gesture: String) {
        
        print("获取第一个手势密码\(gesture)")
        
        self.msgLabel?.showWarnMsg(gestureTextDrawAgain)
        //infoView展示对应选中的圆
        infoViewSelectedSubviewsSameAsCircleView(view)
    }
    
    
    
    func circleViewdidCompleteSetSecondGesture(_ view: CircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        print("获得第二个手势密码\(gesture)")
        
        if result {
            print("两次手势匹配！可以进行本地化保存了")
            self.msgLabel?.showWarnMsg(gestureTextSetSuccess)
            CircleView.saveGesture(gesture, key: gestureFinalSaveKey)
            securityVC.switchForSecurity.isOn = true
            if self.type == GestureViewControllerType.resetGesture{
                verifyGestureVC.presentActionType = "dismissFromSetting"
                verifyGestureVC.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            print("两次手势不匹配")
            self.msgLabel?.showWarnMsgAndShake(gestureTextDrawAgainError)
            self.resetBtn?.isHidden = false
        }
        
    }
    
    func circleViewdidCompleteLoginGesture(_ view: CircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        
        //此时的type有两种情况 Login or verify
        if type == CircleViewType.circleViewTypeLogin {
            if result {
                print("登录成功!")
                let userinfos = getCurrentUserInfo()
                let roleType = Int(userinfos.value(forKey: "roletype") as! String)
                let tabbar = TabBarController(royeType: roleType!)
                let appDelegate = AppDelegate()
                appDelegate.window?.rootViewController = tabbar
                self.present(tabbar, animated: true, completion: nil)
        
            } else {
                print("密码错误")
                self.msgLabel?.showWarnMsgAndShake(gestureTextGestureVerifyError)
            }
        } else  if type == CircleViewType.circleViewTypeVerify {
            if result {
                print("验证成功，跳转到设置手势界面")
            } else {
                print("原手势密码输入错误!")
            }
            
        }
    }
    
    
    //MARK: - 相关方法
    
    func infoViewSelectedSubviewsSameAsCircleView(_ circleView: CircleView){
        for circle: Circle in circleView.subviews as! [Circle] {
            
            if circle.state == CircleState.circleStateSelected || circle.state == CircleState.circleStateLastOneSelected {
                for infoCircle:Circle in self.infoView?.subviews as! [Circle]{
                    if infoCircle.tag == circle.tag {
                        infoCircle.state = CircleState.circleStateSelected
                    }
                }
            }
            
        }
    }
    

}
