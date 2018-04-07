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
    
    //使用手势登录按钮
    let useGestureLoginBtn:UIButton = UIButton.init(type: .system)
    
    //注册按钮
    let registerOrLoginBtn:UIButton = UIButton.init(type: .system)

    //注册还是登录
    var isToLogin = true
    
    ///页面显示效果
    var presentType = "presenting" /// presenting, 显示. dismissing, 不显示
    
    //登录按钮
    var SubmitBtn:UIButton!
    
    //当前使用的用户名
    var presentUsername = ""
    //登录背景框
    let vLogin =  UIView(frame:CGRect(x:15, y:200, width:UIScreen.main.bounds.size.width - 30, height:160))
    //左手离脑袋的距离
    var offsetLeftHand:CGFloat = 60
    
    //左手图片,右手图片(遮眼睛的)
    var imgLeftHand:UIImageView!
    var imgRightHand:UIImageView!
    
    //左手图片,右手图片(圆形的)
    var imgLeftHandGone:UIImageView!
    var imgRightHandGone:UIImageView!
    
    //登录框状态
    var showType:LoginShowType = LoginShowType.NONE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //获取屏幕尺寸
        let mainSize = UIScreen.main.bounds.size
        //猫头鹰头部
        let imgLogin =  UIImageView(frame:CGRect(x:mainSize.width/2-211/2, y:100, width:211, height:109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        self.view.addSubview(imgLogin)
        
        //猫头鹰左手(遮眼睛的)
        let rectLeftHand = CGRect(x:61 - offsetLeftHand, y:90, width:40, height:65)
        imgLeftHand = UIImageView(frame:rectLeftHand)
        imgLeftHand.image = UIImage(named:"owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand)
        
        //猫头鹰右手(遮眼睛的)
        let rectRightHand = CGRect(x:imgLogin.frame.size.width / 2 + 60, y:90, width:40, height:65)
        imgRightHand = UIImageView(frame:rectRightHand)
        imgRightHand.image = UIImage(named:"owl-login-arm-right")
        imgLogin.addSubview(imgRightHand)
        
        //登录框背景
        
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        self.view.addSubview(vLogin)
        
        //猫头鹰左手(圆形的)
        let rectLeftHandGone = CGRect(x:mainSize.width / 2 - 100,
                                      y:vLogin.frame.origin.y - 22, width:40, height:40)
        imgLeftHandGone = UIImageView(frame:rectLeftHandGone)
        imgLeftHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgLeftHandGone)
        
        //猫头鹰右手(圆形的)
        let rectRightHandGone = CGRect(x:mainSize.width / 2 + 62,
                                       y:vLogin.frame.origin.y - 22, width:40, height:40)
        imgRightHandGone = UIImageView(frame:rectRightHandGone)
        imgRightHandGone.image = UIImage(named:"icon_hand")
        self.view.addSubview(imgRightHandGone)
        

        
        //用户名输入框
        txtUser = UITextField(frame:CGRect(x:30, y:30, width:vLogin.frame.size.width - 60, height:44))
        txtUser.delegate = self
        txtUser.layer.cornerRadius = 5
        txtUser.layer.borderColor = UIColor.lightGray.cgColor
        txtUser.layer.borderWidth = 0.5
        txtUser.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser.leftViewMode = UITextFieldViewMode.always
        txtUser.attributedPlaceholder = NSAttributedString(string: "请输入邮箱/手机号")
        txtUser.clearButtonMode = UITextFieldViewMode.always
        txtUser.keyboardType = UIKeyboardType.alphabet
        txtUser.returnKeyType = UIReturnKeyType.next
        
        //用户名输入框左侧图标
        let imgUser = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named:"iconfont-user")
        txtUser.leftView!.addSubview(imgUser)
        vLogin.addSubview(txtUser)
        
        //密码输入框
        txtPwd = UITextField(frame:CGRect(x:30, y:90, width:vLogin.frame.size.width - 60, height:44))
        txtPwd.delegate = self
        txtPwd.layer.cornerRadius = 5
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd.layer.borderWidth = 0.5
        txtPwd.isSecureTextEntry = true
        txtPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd.leftViewMode = UITextFieldViewMode.always
        txtPwd.placeholder = "请输入密码"
        txtPwd.clearButtonMode = UITextFieldViewMode.always
        txtPwd.keyboardType = UIKeyboardType.alphabet
        txtPwd.returnKeyType = UIReturnKeyType.done
        
        
        //重复密码输入框
        repeatTxtPwd = UITextField(frame:CGRect(x:30, y:150, width:vLogin.frame.size.width - 60, height:44))
        repeatTxtPwd.delegate = self
        repeatTxtPwd.layer.cornerRadius = 5
        repeatTxtPwd.layer.borderColor = UIColor.lightGray.cgColor
        repeatTxtPwd.layer.borderWidth = 0.5
        repeatTxtPwd.isSecureTextEntry = true
        repeatTxtPwd.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        repeatTxtPwd.leftViewMode = UITextFieldViewMode.always
        repeatTxtPwd.placeholder = "请再次输入密码"
        repeatTxtPwd.clearButtonMode = UITextFieldViewMode.always
        repeatTxtPwd.keyboardType = UIKeyboardType.alphabet
        repeatTxtPwd.returnKeyType = UIReturnKeyType.done
        repeatTxtPwd.isHidden = true
        
        
        //密码输入框左侧图标
        let imgPwd = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named:"iconfont-password")
        txtPwd.leftView!.addSubview(imgPwd)
        
        //重复密码输入框左侧图标
        let imgRepatePwd = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgRepatePwd.image = UIImage(named:"iconfont-password")
        repeatTxtPwd.leftView!.addSubview(imgRepatePwd)
        
        vLogin.addSubview(txtPwd)
        vLogin.addSubview(repeatTxtPwd)
        // Do any additional setup after loading the view, typically from a nib.
        
        //设置登录按钮
        SubmitBtn = UIButton.init(type: UIButtonType.system)
        SubmitBtn.frame = CGRect(x:45, y:380, width:vLogin.frame.size.width - 60, height: 44)
        SubmitBtn.layer.borderColor = UIColor.lightGray.cgColor
        SubmitBtn.layer.cornerRadius = 5
        SubmitBtn.layer.borderWidth = 0.5
        SubmitBtn.layer.backgroundColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        if isToLogin{
            SubmitBtn.setTitle("登录", for: UIControlState.normal)
        }else{
            SubmitBtn.setTitle("注册", for: UIControlState.normal)
        }
        SubmitBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        self.view.addSubview(SubmitBtn)
        SubmitBtn.addTarget(self, action: #selector(SubmitBtnClick), for: UIControlEvents.touchUpInside)
        
        
        //显示注册按钮
        registerOrLoginBtn.frame = CGRect(x: 0, y: 444, width: 200, height: 22)
        registerOrLoginBtn.setTitle("还没有账号？点此注册", for: .normal)
        registerOrLoginBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: UIControlState())
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
        
        initSettings()

    }
    @objc func switchLoginOrRegisterBtnClicked(){
        if isToLogin{
            isToLogin = false // 切换成注册
            repeatTxtPwd.isHidden = false
            SubmitBtn.setTitle("注册", for: .normal)
            registerOrLoginBtn.setTitle("已有账号？去登录", for: .normal)
            registerOrLoginBtn.frame = CGRect(x: 15, y: 504, width: 140, height: 22)
            SubmitBtn.frame = CGRect(x:45, y:440, width:vLogin.frame.size.width - 60, height: 44)
            vLogin.frame = CGRect(x:15, y:200, width:UIScreen.main.bounds.size.width - 30, height:210)
            useGestureLoginBtn.frame = CGRect(x: UIScreen.main.bounds.width - 120, y: 504, width: 100, height: 22)
            txtUser.text = ""
        }else{
            isToLogin = true //切换成登录
            repeatTxtPwd.isHidden = true
            SubmitBtn.setTitle("登录", for: .normal)
            registerOrLoginBtn.setTitle("还没有账号？点此注册", for: .normal)
            registerOrLoginBtn.frame = CGRect(x: 0, y: 444, width: 200, height: 22)
            SubmitBtn.frame = CGRect(x:45, y:380, width:vLogin.frame.size.width - 60, height: 44)
            vLogin.frame = CGRect(x:15, y:200, width:UIScreen.main.bounds.size.width - 30, height:160)
            useGestureLoginBtn.frame = CGRect(x: UIScreen.main.bounds.width - 120, y: 444, width: 100, height: 22)
            txtUser.text = presentUsername
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
        //如果当前是用户名输入
        if textField.isEqual(txtUser){
            if (showType != LoginShowType.PASS)
            {
                showType = LoginShowType.USER
                return
            }
            showType = LoginShowType.USER
            
            //播放不遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x:self.imgLeftHand.frame.origin.x - self.offsetLeftHand,
                    y:self.imgLeftHand.frame.origin.y + 30,
                    width:self.imgLeftHand.frame.size.width, height:self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x:self.imgRightHand.frame.origin.x + 48,
                    y:self.imgRightHand.frame.origin.y + 30,
                    width:self.imgRightHand.frame.size.width, height:self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x:self.imgLeftHandGone.frame.origin.x - 70,
                    y:self.imgLeftHandGone.frame.origin.y, width:40, height:40)
                self.imgRightHandGone.frame = CGRect(
                    x:self.imgRightHandGone.frame.origin.x + 30,
                    y:self.imgRightHandGone.frame.origin.y, width:40, height:40)
            })
        }
            //如果当前是密码名输入
        else if textField.isEqual(txtPwd)||textField.isEqual(repeatTxtPwd){
            if (showType == LoginShowType.PASS)
            {
                showType = LoginShowType.PASS
                return
            }
            showType = LoginShowType.PASS
            
            //播放遮眼动画
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.imgLeftHand.frame = CGRect(
                    x:self.imgLeftHand.frame.origin.x + self.offsetLeftHand,
                    y:self.imgLeftHand.frame.origin.y - 30,
                    width:self.imgLeftHand.frame.size.width, height:self.imgLeftHand.frame.size.height)
                self.imgRightHand.frame = CGRect(
                    x:self.imgRightHand.frame.origin.x - 48,
                    y:self.imgRightHand.frame.origin.y - 30,
                    width:self.imgRightHand.frame.size.width, height:self.imgRightHand.frame.size.height)
                self.imgLeftHandGone.frame = CGRect(
                    x:self.imgLeftHandGone.frame.origin.x + 70,
                    y:self.imgLeftHandGone.frame.origin.y, width:0, height:0)
                self.imgRightHandGone.frame = CGRect(
                    x:self.imgRightHandGone.frame.origin.x - 30,
                    y:self.imgRightHandGone.frame.origin.y, width:0, height:0)
            })
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        //返回值，前一个是已设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
        let result = checkSecuritySetting().1
        
        if result && checkSecuritySetting().0{  // 如果设置了手势登录（true)，并且是开着的(true)
            useGestureLoginBtn.frame = CGRect(x: UIScreen.main.bounds.width - 120, y: 444, width: 100, height: 22)
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
    
}
//数据验证格式
enum validateType {
    case EMAIL
    case CNPHONENUM
    case CNIDCARD
}
//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
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

