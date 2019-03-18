//
//  ViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController,UITextFieldDelegate {
    
    //用户密码输入框
    var txtUser:UITextField!
    var txtPwd:UITextField!
    var repeatTxtPwd:UITextField!
    var needsAutoLogin:Bool = true
    //使用手势登录按钮
    let useGestureLoginBtn:UIButton = UIButton.init(type: .system)
    
    //注册按钮
    let registerOrLoginBtn:UIButton = UIButton.init(type: .system)

    let privatePolicyBtn:UIButton = UIButton.init(type: .system)
    //注册还是登录
    var isToLogin = true
    
    ///页面显示效果
    var presentType = "presenting" /// presenting, 显示. dismissing, 不显示
    
    //登录按钮
    var SubmitBtn:UIButton!
    
    //当前使用的用户名
    var presentUsername = ""
   
    //添加的fadeStatusBarView
    var faceStatusBarView:[UIView] = []
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    //更新提示窗口
    lazy var updateNoticeBGView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempView.backgroundColor = UIColor.clear
        
        //灰色窗口
        let bgimg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        bgimg.image = UIImage(named: "blurBgViewgreyimg")
        tempView.addSubview(bgimg)
        
        return tempView
    }()
    
    lazy var updateNoticeWindows:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: 30, y: 157, width: kWidth - 60, height: 360/315 * (kWidth - 60)))
        tempView.image = UIImage(named: "updatebgimg-zh")
        
        //立即更新按钮
        let updateImidiatelyBtn:UIButton = UIButton.init(frame: CGRect(x: 20, y: 305, width: (kWidth - 115)/2, height: 40))
        updateImidiatelyBtn.layer.cornerRadius = 2
        updateImidiatelyBtn.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        updateImidiatelyBtn.setTitle("去更新", for: .normal)
        updateImidiatelyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        updateImidiatelyBtn.setTitleColor(UIColor.lineColors(color: .white), for: .normal)
        updateImidiatelyBtn.addTarget(self, action: #selector(updateAppClicked), for: .touchUpInside)
        
        tempView.addSubview(updateImidiatelyBtn)
        //取消更新按钮
        let cancelUpdateBtn:UIButton = UIButton.init(frame: CGRect(x: 35 + (kWidth - 115)/2, y: 305, width: (kWidth - 115)/2, height: 40))
        cancelUpdateBtn.layer.cornerRadius = 2
        cancelUpdateBtn.layer.backgroundColor = UIColor.lineColors(color: .white).cgColor
        cancelUpdateBtn.layer.borderColor = UIColor.lineColors(color: .grayLevel2).cgColor
        cancelUpdateBtn.layer.borderWidth = 0.5
        cancelUpdateBtn.setTitle("取消", for: .normal)
        cancelUpdateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelUpdateBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelUpdateBtn.addTarget(self, action: #selector(cancelUpdateClicked), for: .touchUpInside)
        
        tempView.addSubview(cancelUpdateBtn)
        tempView.isUserInteractionEnabled = true
        return tempView
    }()
    
    
    lazy var fadeStatusBarBackgroundView:UIView = {
        let tempView = UIView.init(frame: UIApplication.shared.statusBarView?.frame ?? .zero)
        tempView.backgroundColor = UIColor.black
        tempView.alpha = 0.5
        return tempView
    }()
    
    lazy var updateLogTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 99, width: 200, height: 33))
        tempLabel.text = "版本更新内容"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 17)
        return tempLabel
    }()
    
    lazy var updateLogContent:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 130, width: 200, height: 156))
        tempLabel.text = "版本更新内容"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .left
        tempLabel.numberOfLines = 9
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.contentMode = .topLeft
        return tempLabel
    }()
    
    //重复密码下的分界线
    let seperateLineUnderRepeatPassword: UIView = UIView.init(frame: CGRect(x: 25, y: 338 + heightChangeForiPhoneXFromTop, width: kWidth - 50, height: 1))
    let titleBarTitle:UILabel = UILabel.init(frame: CGRect(x: kWidth/2 - 20, y: 10, width: 40, height: 25))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarHiden(toHidden: false, ViewController: self)
        setStatusBarBackgroundColor(color: .backgroundColors(color: .clear))
        
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        let welcomeLabel:UILabel = UILabel.init(frame: CGRect(x: 33, y: 94 + heightChangeForiPhoneXFromTop, width: 166, height: 30))
        welcomeLabel.text = "欢迎您"
        welcomeLabel.textAlignment = .left
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        welcomeLabel.textColor = UIColor.titleColors(color: .black)
        //self.view.addSubview(welcomeLabel)
        
        let titleBarView:UIView = UIView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
        
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .clear) // 红色主色调
        titleBarTitle.textColor = UIColor.titleColors(color: .black)
        titleBarTitle.textAlignment = .center
        titleBarTitle.font = UIFont.boldSystemFont(ofSize: 17)
        if isToLogin{
            titleBarTitle.text = "登录"
        }else{
            titleBarTitle.text = "注册"
        }
        self.view.addSubview(titleBarView)
        titleBarView.addSubview(titleBarTitle)

        privatePolicyBtn.setTitle("查看隐私政策", for: .normal)
        privatePolicyBtn.frame = CGRect(x: 20, y: kHight - 80 - heightChangeForiPhoneXFromBottom, width: kWidth - 40, height: 17)
        privatePolicyBtn.contentVerticalAlignment = .center
        privatePolicyBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        //privatePolicyBtn.titleLabel?.font =
        privatePolicyBtn.addTarget(self, action: #selector(privatepolicybtnClicked), for: .touchUpInside)
        self.view.addSubview(privatePolicyBtn)
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x:25, y:100 + heightChangeForiPhoneXFromTop, width:kWidth - 60, height:44))
        txtUser.delegate = self
       // txtUser.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 54, height: 44))
        //txtUser.leftViewMode = UITextFieldViewMode.always
        //txtUser.layer.backgroundColor = UIColor.gray.cgColor
        txtUser.attributedPlaceholder = NSAttributedString(string: "请输入邮箱/手机号")
        txtUser.clearButtonMode = UITextFieldViewMode.always
        txtUser.keyboardType = UIKeyboardType.alphabet
        txtUser.returnKeyType = UIReturnKeyType.next
        
        let seperateLineUnderUserName: UIView = UIView.init(frame: CGRect(x: 25, y: 208 - 64 + heightChangeForiPhoneXFromTop , width: kWidth - 50, height: 1))
        seperateLineUnderUserName.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        self.view.addSubview(seperateLineUnderUserName)

        
        //用户名输入框左侧图标
        let imgUser = UIImageView(frame: CGRect(x: 11, y: 6, width: 24, height: 24))
        imgUser.image = UIImage(named:"iconfont-user")
       // txtUser.leftView!.addSubview(imgUser)
        self.view.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x:25, y:225 - 64 + heightChangeForiPhoneXFromTop , width:kWidth - 60, height:44))
        txtPwd.delegate = self
        //txtPwd.layer.backgroundColor = UIColor.gray.cgColor
        txtPwd.isSecureTextEntry = true
       // txtPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 54, height: 44))
       // txtPwd.leftViewMode = UITextFieldViewMode.always
        txtPwd.placeholder = "请输入密码"
        txtPwd.clearButtonMode = UITextFieldViewMode.always
        txtPwd.keyboardType = UIKeyboardType.alphabet
        txtPwd.returnKeyType = UIReturnKeyType.done
        
        let seperateLineUnderPassword: UIView = UIView.init(frame: CGRect(x: 25, y: 269 - 64 + heightChangeForiPhoneXFromTop , width: kWidth - 50, height: 1))
        seperateLineUnderPassword.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        self.view.addSubview(seperateLineUnderPassword)

        //重复密码输入框
        repeatTxtPwd = UITextField(frame:CGRect(x:25, y:289 - 64 + heightChangeForiPhoneXFromTop, width:kWidth - 60, height:44))
        repeatTxtPwd.delegate = self
        repeatTxtPwd.isSecureTextEntry = true
        //repeatTxtPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 54, height: 44))
       // repeatTxtPwd.leftViewMode = UITextFieldViewMode.always
        //repeatTxtPwd.layer.backgroundColor = UIColor.gray.cgColor
        repeatTxtPwd.placeholder = "请再次输入密码"
        repeatTxtPwd.clearButtonMode = UITextFieldViewMode.always
        repeatTxtPwd.keyboardType = UIKeyboardType.alphabet
        repeatTxtPwd.returnKeyType = UIReturnKeyType.done
        repeatTxtPwd.isHidden = true
        
        seperateLineUnderRepeatPassword.frame = CGRect(x: 25, y: 333 - 64 + heightChangeForiPhoneXFromTop, width: kWidth - 50, height: 1)
        seperateLineUnderRepeatPassword.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLineUnderRepeatPassword.isHidden = true
        self.view.addSubview(seperateLineUnderRepeatPassword)

        
        //密码输入框左侧图标
        let imgPwd = UIImageView(frame: CGRect(x: 13, y: 7, width: 19, height: 24))
        imgPwd.image = UIImage(named:"iconfont-password")
       // txtPwd.leftView!.addSubview(imgPwd)
        
        //重复密码输入框左侧图标
        let imgRepatePwd = UIImageView(frame: CGRect(x: 13, y: 7, width: 19, height: 24))
        imgRepatePwd.image = UIImage(named:"iconfont-password")
       // repeatTxtPwd.leftView!.addSubview(imgRepatePwd)
        
        self.view.addSubview(txtPwd)
        self.view.addSubview(repeatTxtPwd)
        // Do any additional setup after loading the view, typically from a nib.
        
        //设置登录按钮
        SubmitBtn = UIButton.init(type: UIButtonType.system)
        SubmitBtn.frame = CGRect(x:25, y:362 + heightChangeForiPhoneXFromTop, width:kWidth - 50, height: 45)
        SubmitBtn.layer.borderColor = UIColor.clear.cgColor
        SubmitBtn.layer.cornerRadius = 2
        SubmitBtn.layer.borderWidth = 0.5
        SubmitBtn.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        
        if isToLogin{
            SubmitBtn.setTitle("登录", for: UIControlState.normal)
        }else{
            SubmitBtn.setTitle("注册", for: UIControlState.normal)
        }
        SubmitBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        self.view.addSubview(SubmitBtn)
        SubmitBtn.addTarget(self, action: #selector(SubmitBtnClick), for: UIControlEvents.touchUpInside)
        
        
        //显示注册按钮
        registerOrLoginBtn.frame = CGRect(x: kWidth - 185, y: 284 - 64 + heightChangeForiPhoneXFromTop, width: 160, height: 20)
        registerOrLoginBtn.setTitle("还没有账号？点此注册", for: .normal)
        registerOrLoginBtn.titleLabel?.textAlignment = .right
        registerOrLoginBtn.contentHorizontalAlignment = .right
        registerOrLoginBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: UIControlState())
        registerOrLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerOrLoginBtn.addTarget(self, action: #selector(switchLoginOrRegisterBtnClicked), for: UIControlEvents.touchUpInside)
        self.view.addSubview(registerOrLoginBtn)
        //自动填充以前登录过的账号
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询到偏移量
        fetchRequest.returnsObjectsAsFaults = false

        
        // 设置查询条件
        let predicate = NSPredicate(format: "id = '1'")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            //遍历查询结果
            for info in fetchedObjects{
                //更新数据
                self.txtUser.text =  info.userName
                self.presentUsername = info.userName!
            }
        } catch  {
            fatalError("获取失败")
        }
        appUpdateCheck()
        
        initSettings()

    }
    
    @objc func switchLoginOrRegisterBtnClicked(){
        if isToLogin{
            titleBarTitle.text = "注册"
            isToLogin = false // 切换成注册
            repeatTxtPwd.isHidden = false
            SubmitBtn.setTitle("注册", for: .normal)
            registerOrLoginBtn.setTitle("已有账号？去登录", for: .normal)
            registerOrLoginBtn.frame = CGRect(x: kWidth - 185, y: 338 - 64 + heightChangeForiPhoneXFromTop, width: 160, height: 20)//CGRect(x: 25, y: 308, width: 140, height: 22)
            SubmitBtn.frame = CGRect(x:25, y:362 + heightChangeForiPhoneXFromTop, width:kWidth - 50, height: 44)
            useGestureLoginBtn.isHidden = true
            txtUser.text = ""
            txtPwd.text = ""
            seperateLineUnderRepeatPassword.isHidden = false
            
        }else{
            titleBarTitle.text = "登录"
            isToLogin = true //切换成登录
            repeatTxtPwd.isHidden = true
            SubmitBtn.setTitle("登录", for: .normal)
            registerOrLoginBtn.setTitle("还没有账号？点此注册", for: .normal)
            registerOrLoginBtn.frame = CGRect(x: kWidth - 185, y: 284 - 64 + heightChangeForiPhoneXFromTop, width: 160, height: 20)// CGRect(x: 0, y: 254, width: 200, height: 22)
            SubmitBtn.frame = CGRect(x:25, y:362 + heightChangeForiPhoneXFromTop, width:kWidth - 50, height: 44)
            useGestureLoginBtn.isHidden = false
            useGestureLoginBtn.frame = CGRect(x: 25, y: 284 - 64 + heightChangeForiPhoneXFromTop, width: 100, height: 22)
            txtUser.text = presentUsername
            seperateLineUnderRepeatPassword.isHidden = true
        }
    }
    //返回按钮的响应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtPwd.isFirstResponder {
            SubmitBtnClick()
        }else{
            txtPwd.becomeFirstResponder()
        }
        return true
    }
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
    {
        //自定义键盘按钮
        let topView = UIToolbar()
//        let topView = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        self.txtPwd.inputAccessoryView = topView
        self.txtUser.inputAccessoryView = topView
        self.repeatTxtPwd.inputAccessoryView = topView
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
        repeatTxtPwd.resignFirstResponder()

    }
    
    func initSettings(){
        //初始化报价设置
        saveWeightToCoreData(value:10,parameter: "quotePriceWeight")
        //初始化消息提醒设置
        saveWeightToCoreData(value:100,parameter: "msgVoiceAlertFrequencyWeight")
        //初始化设置的值
        initMSGAlertSettings()
    }
    @objc func SubmitBtnClick() {
        //收起键盘
        self.view.endEditing(true)
        SubmitBtn.isEnabled = false
        
        
        let loginUser = User()
        let usernameText = txtUser.text
        let passwrdText = txtPwd.text
        let repeatPwdText = repeatTxtPwd.text
        if !(usernameText?.isEmpty)! && !(passwrdText?.isEmpty)! {
            if isToLogin{
                let hub = pleaseWait()
                loginUser.Login(username: usernameText!, password: passwrdText!,view:self,hub:hub)
            }else{
                //注册的功能
                if (repeatPwdText?.isEmpty)!{
                    greyLayerPrompt.show(text: "用户名和密码不能为空")
                }else if !validateString(string: usernameText!, validateType: .EMAIL) && !validateString(string: usernameText!, validateType: .CNPHONENUM) {
                    greyLayerPrompt.show(text: "请输入有效的邮箱或手机号")
                }else if passwrdText == repeatPwdText{
                    if (passwrdText?.lengthOfBytes(using: .utf8))! < 6{
                        greyLayerPrompt.show(text: "请输入6位以上的密码")
                    }else{
                        //走注册的功能
                        let hub = pleaseWait()
                        loginUser.registerAccount(username: usernameText!, password: passwrdText!, view: self, hub: hub)
                    }
                }else{
                    greyLayerPrompt.show(text: "两次输入的密码不一致，请重新输入")
                }
            }
        }else{
            greyLayerPrompt.show(text: "用户名和密码不能为空")
        }
        SubmitBtn.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarHiden(toHidden: false, ViewController: self)
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
    }
    override func viewDidAppear(_ animated: Bool) {
        setStatusBarHiden(toHidden: false, ViewController: self)
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        //返回值，前一个是已设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
        
        let result = checkSecuritySetting().1
        
        if result && checkSecuritySetting().0{  // 如果设置了手势登录（true)，并且是开着的(true)
            
            useGestureLoginBtn.frame = CGRect(x: 25, y: 284 + heightChangeForiPhoneXFromTop, width: 100, height: 22)
            useGestureLoginBtn.setTitle("使用手势登录", for: UIControlState())
            useGestureLoginBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: UIControlState())
            useGestureLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            useGestureLoginBtn.addTarget(self, action: #selector(useGestureBtnClicked), for: UIControlEvents.touchUpInside)
            self.view.addSubview(useGestureLoginBtn)
        }
        
        if result && presentType == "presenting"{
            let gestureVC = GestureViewController()
            gestureVC.loginVC = self
            gestureVC.type = GestureViewControllerType.login
            gestureVC.gestureTextBeforeSet = "手势登录"
            self.present(gestureVC, animated: false, completion: nil)
        }
        
        
    }
    
    @objc func cancelUpdateClicked(){
        updateNoticeBGView.removeFromSuperview()
        if faceStatusBarView.count != 0{
            faceStatusBarView[0].removeFromSuperview()
            faceStatusBarView.removeAll()
        }
    }
    @objc func updateAppClicked(){
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/cn/app/custommallzone/id1359714034?l=en&mt=8")!, completionHandler: nil)
    }
    @objc func useGestureBtnClicked(){
        //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
        let result = checkSecuritySetting().1
        if result {
            let gestureVC = GestureViewController()
            gestureVC.loginVC = self
            gestureVC.type = GestureViewControllerType.login
            gestureVC.gestureTextBeforeSet = "手势登录"
            self.present(gestureVC, animated: true, completion: nil)
        }else{
            greyLayerPrompt.show(text: "未开启手势登录，请使用密码登录")
        }
    }
    
    func validateString(string: String,validateType:validateType) -> Bool {
        var validateRegex = ""
        if validateType == .EMAIL{
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            validateRegex = emailRegex
        }else if validateType == .CNPHONENUM{
            let ChinaPhoneRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
            validateRegex = ChinaPhoneRegex
        }else if validateType == .CNIDCARD{
            let ChinaIDCardRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
            validateRegex = ChinaIDCardRegex
        }else{
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            validateRegex = emailRegex
        }
        let RegexTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", validateRegex)
        return RegexTest.evaluate(with: string)
    }
    @objc func privatepolicybtnClicked(){
        let privacyVC = PrivacyPolicyAgreementViewController()
        //privacyVC.loginVC = self
        self.present(privacyVC, animated: true, completion: nil)
    }
    
    func checkAddtionalAccountOrAutoLogin(){
        //检查是否已经登录过账号
        let dataOperator = CoreDataOperation()
        let isAccountAvailable = dataOperator.checkAccountAvaiable(forAddtional: false) // 检查附属账号是否可用
        
        if isAccountAvailable && needsAutoLogin {
            needsAutoLogin = true //下次自动登录
            let userinfo = getCurrentUserInfo()
            let username = userinfo.value(forKey: "username") as! String
            let password = userinfo.value(forKey: "password") as! String
            
            let hub = pleaseWait()
            let loginUser = User()
            loginUser.Login(username: username, password: password,view:self,hub:hub)
        }
    }
    
    fileprivate func appUpdateCheck(){
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "appUpdateCheckAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "appUpdateCheckAPI") as! String
        #endif
        
        var buildId = "0"
        let infoDictionary = Bundle.main.infoDictionary
        if infoDictionary != nil{
            buildId = (infoDictionary! as NSDictionary).value(forKey: "CFBundleVersion") as! String
        }
        
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["build"] =  buildId
        params["platform"] = "iOS"
        
        
        let defs = UserDefaults.standard
        let languages:[String] = defs.object(forKey: "AppleLanguages") as! [String]//获取系统支持的所有语言集合
        let preferredLanguage = languages.first//集合第一个元素为当前语言
        if (preferredLanguage?.contains("en"))! {
            params["language"] = "en_US"
        }else{
            params["language"] = "zh_CN"
        }
        
        _ = Alamofire.request(newTaskUpdateURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                            //already up to date
                            self.checkAddtionalAccountOrAutoLogin()
                        }else if statusCode == 201{
                            //needsUpdate
                            let alertLevel = json["data","alertLevel"].int!
                            if alertLevel <= 3{
                                self.view.addSubview(self.updateNoticeBGView)
                                UIApplication.shared.statusBarView?.addSubview(self.fadeStatusBarBackgroundView)
                                self.faceStatusBarView.removeAll()
                                self.faceStatusBarView.append(self.fadeStatusBarBackgroundView)
                                self.updateNoticeBGView.addSubview(self.updateNoticeWindows)
                                
                                let updateLogTitle = json["data","logTitle"].string
                                let updateLogContent = json["data","commonUpdateLog"].string
                                let language = json["data","language"].string!
                                if language == "en_US"{
                                    self.updateNoticeWindows.image = UIImage(named: "updatebgimg-en")
                                }else{
                                    self.updateNoticeWindows.image = UIImage(named: "updatebgimg-zh")
                                }
                                self.updateLogTitle.text = updateLogTitle
                                self.updateLogContent.text = updateLogContent
                                self.updateNoticeWindows.addSubview(self.updateLogTitle)
                                self.updateNoticeWindows.addSubview(self.updateLogContent)
                                
                            }else{
                                self.checkAddtionalAccountOrAutoLogin()
                            }
                        }else{
                            print("获取失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            // greyLayerPrompt.show(text: "获取失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        //  greyLayerPrompt.show(text: "程序错误. Code:1")
                        print("检查更新失败")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }

}



//获取用户信息
func getUserAccountInfo()->(String,String){
    //获取管理的数据上下文，对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
    //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
    //        fetchRequest.fetchOffset = 0 //查询到偏移量
    fetchRequest.returnsObjectsAsFaults = false
    
    
    // 设置查询条件
    let predicate = NSPredicate(format: "id = '1'")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
        
        //遍历查询结果
        for info in fetchedObjects{
            //更新数据
            return (info.userName!,info.nickName!)
        }
    } catch  {
        fatalError("获取失败")
    }
    return ("_NONE","_NONE")
}

extension UIApplication{
    var statusBarView:UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



