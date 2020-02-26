//
//  DemoView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2020/1/13.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class DemoView: UIView {

    @IBOutlet weak var passwordSeperator: UIImageView!
    @IBOutlet weak var mobileSeperator: UIImageView!
    @IBOutlet weak var UserNameTextFiled: UITextField!
    @IBOutlet weak var PasswordTextFiled: UITextField!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var userNameIcon: UIImageView!
    @IBOutlet weak var switchLoginTypeButton: UIButton!
    @IBOutlet weak var SMSCodeTextFiled: UITextField!
    @IBOutlet weak var GetSMSCodeButton: UIButton!
    @IBOutlet weak var SMSCodeIcon: UIImageView!
    @IBOutlet weak var SMSCodeSeperator: UIImageView!
    @IBOutlet weak var verifyStatusIcon: UIImageView!
    @IBOutlet weak var verificationCodeTextFielld: UITextField!
    @IBOutlet weak var verficationCodeImage: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    
    //全局变量
    var mobileNumber:String = ""
    var passwordNumber:String = ""
    var isLoginWithPassword:Bool = true
    var verificationCodeImage:UIImage?
    var SessionUUID:String = ""
    var timer:Timer?
    var counter:Int = 60
    //注册模式
    var isRegisterModel:Bool = false
    
    var loadingSubViews:[UIView] = []
    
    //图形验证码验证
    var isVerificationCodeLegal = false
    func isMobilePhoneLegal(mobile phone:String) -> Bool {
        return (phone.length() == 11) ? true : false
    }
    //短信验证码合法性
    var isSMSCodeLegal:Bool {
        return (SMSCodeTextFiled.text?.length() ?? 0 == 6) ? true : false
    }
    
    var isPasswordLegal:Bool {
        return  (PasswordTextFiled.text?.length() ?? 0 >= 6 && PasswordTextFiled.text?.length() ?? 0 <= 20) ? true : false
    }
    
    @IBAction func userNameFieldFocus(_ sender: UITextField) {
        mobileSeperator.isHighlighted = true
        userNameIcon.isHighlighted = true
        
    }
    @IBAction func passwordFieldFocus(_ sender: UITextField) {
        passwordSeperator.isHighlighted = true
        passwordIcon.isHighlighted = true
        verifyStatusIcon.isHidden = true
    }
    
    @IBAction func SMSCodeFieldFocus(_ sender: Any) {
        SMSCodeSeperator.isHighlighted = true
        SMSCodeIcon.isHighlighted = true
    }
    
    @IBAction func userNameFieldDisselected(_ sender: UITextField) {
        mobileSeperator.isHighlighted = false
        userNameIcon.isHighlighted = false
        
        //去除手机号的首尾空格、并且去除格式化的手机空格
        mobileNumber = UserNameTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    @IBAction func verificationCodeFieldDissselected(_ sender: Any) {
        let verificationCode = verificationCodeTextFielld.text ?? ""
        verifyImageCode(UUID: SessionUUID, verificationCode: verificationCode)
    }
    @IBAction func passwordFieldDisselected(_ sender: UITextField) {
        passwordSeperator.isHighlighted = false
        passwordIcon.isHighlighted = false
    }
    
    @IBAction func SMSCodeFieldDissSelected(_ sender: Any) {
        SMSCodeSeperator.isHighlighted = false
        SMSCodeIcon.isHighlighted = false
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        guard isMobilePhoneLegal(mobile: mobileNumber) else {
            greyLayerPrompt.show(text: "手机号不合法")
            return
        }
        
        if isRegisterModel {
            //下一步
            guard isSMSCodeLegal else {
                greyLayerPrompt.show(text: "请输入有效的短信验证码")
                return
            }
             
            guard isVerificationCodeLegal else {
                greyLayerPrompt.show(text: "图形验证码错误")
                return
            }
             let verficationCode = verificationCodeTextFielld.text ?? ""
             let SMSCode = SMSCodeTextFiled.text ?? ""
            
            registerNextStep(mobile: mobileNumber, verificationCode: verficationCode, SMSCode: SMSCode)
        }else{
            if isLoginWithPassword {
                guard isPasswordLegal else {
                    greyLayerPrompt.show(text: "密码输入不合法")
                    return
                }
                
                let password = PasswordTextFiled.text ?? ""
                //账号密码登录
                login(mobile: mobileNumber, password: password)
                
            }else{
                guard isSMSCodeLegal else {
                           greyLayerPrompt.show(text: "请输入有效的短信验证码")
                           return
               }
                
               guard isVerificationCodeLegal else {
                   greyLayerPrompt.show(text: "图形验证码错误")
                   return
               }
                let verficationCode = verificationCodeTextFielld.text ?? ""
                let SMSCode = SMSCodeTextFiled.text ?? ""
                
                //短信验证码登录
                login(mobile: mobileNumber, verificationCode: verficationCode, SMSCode: SMSCode)
            }
        }

    }
    
    //注册第二步页面返回登陆
    func backToLogin(){
        //恢复到原登陆页面
        switchLoginTypeButton.isHidden = false
        submitButton.setTitle("登陆", for: .normal)
        RegisterButton.setTitle("还没有账号？点此注册", for: .normal)
        
        if isLoginWithPassword {
            //恢复到账号密码登陆页面
            verficationCodeImage.isHidden = true
            verificationCodeTextFielld.isHidden = true
            PasswordTextFiled.isHidden = false
            SMSCodeIcon.isHidden = true
            GetSMSCodeButton.isHidden = true
            SMSCodeTextFiled.isHidden = true
            SMSCodeSeperator.isHidden = true
            verifyStatusIcon.isHidden = true
               
            switchLoginTypeButton.setTitle("短信验证码登录", for: .normal)
            TitleLabel.text = "账号密码登录"

            let moveUp = CGAffineTransform(translationX: 0, y: 0)
            submitButton.transform = moveUp
            switchLoginTypeButton.transform = moveUp
            RegisterButton.transform = moveUp
        }else{
            TitleLabel.text = "短信验证登录"
        }
    }
    @IBAction func RegisterButtonClicked(_ sender: Any) {

        if isRegisterModel {
            //恢复到原登陆页面
            switchLoginTypeButton.isHidden = false
            submitButton.setTitle("登陆", for: .normal)
            RegisterButton.setTitle("还没有账号？点此注册", for: .normal)
            
            if isLoginWithPassword {
                //恢复到账号密码登陆页面
                verficationCodeImage.isHidden = true
                verificationCodeTextFielld.isHidden = true
                PasswordTextFiled.isHidden = false
                SMSCodeIcon.isHidden = true
                GetSMSCodeButton.isHidden = true
                SMSCodeTextFiled.isHidden = true
                SMSCodeSeperator.isHidden = true
                verifyStatusIcon.isHidden = true
                   
                switchLoginTypeButton.setTitle("短信验证码登录", for: .normal)
                TitleLabel.text = "账号密码登录"

                let moveUp = CGAffineTransform(translationX: 0, y: 0)
                submitButton.transform = moveUp
                switchLoginTypeButton.transform = moveUp
                RegisterButton.transform = moveUp
            }else{
                TitleLabel.text = "短信验证登录"
            }
            
        }else{
            //切换到注册模式
            switchLoginTypeButton.isHidden = true
            submitButton.setTitle("下一步", for: .normal)
            RegisterButton.setTitle("已有账号？返回登陆", for: .normal)
            TitleLabel.text = "注册"

            if isLoginWithPassword {
                //恢复到账号密码登陆页面
                getVerificationImage()
                verficationCodeImage.isHidden = false
                verificationCodeTextFielld.isHidden = false
                PasswordTextFiled.isHidden = true
                SMSCodeIcon.isHidden = false
                GetSMSCodeButton.isHidden = false
                SMSCodeTextFiled.isHidden = false
                SMSCodeSeperator.isHidden = false

                if timer == nil{
                    GetSMSCodeButton.isEnabled = true
                }

                switchLoginTypeButton.setTitle("账号密码登录", for: .normal)
                let moveDown = CGAffineTransform(translationX: 0, y: 70)
                submitButton.transform = moveDown
                switchLoginTypeButton.transform = moveDown
                RegisterButton.transform = moveDown
                
            }
        }
        
        //切换注册模式
        isRegisterModel = !isRegisterModel
    }
    
    @IBAction func SendSMSCodeButtonClicked(_ sender: Any) {
        SendSMSCode(UUID: self.SessionUUID, verificationCode: self.verificationCodeTextFielld.text ?? "", mobilePhone: mobileNumber)
    }
    @IBAction func changeVerificationCode(_ sender: Any) {
        getVerificationImage()
    }
    
    @IBAction func switchLoginTypeClicked(_ sender: Any) {
        if isLoginWithPassword {
            getVerificationImage()
            verficationCodeImage.isHidden = false
            verificationCodeTextFielld.isHidden = false
            PasswordTextFiled.isHidden = true
            SMSCodeIcon.isHidden = false
            GetSMSCodeButton.isHidden = false
            SMSCodeTextFiled.isHidden = false
            SMSCodeSeperator.isHidden = false
            
            if timer == nil{
                GetSMSCodeButton.isEnabled = true
            }
            
            switchLoginTypeButton.setTitle("账号密码登录", for: .normal)
            TitleLabel.text = "短信验证登录"
            let moveDown = CGAffineTransform(translationX: 0, y: 70)
            submitButton.transform = moveDown
            switchLoginTypeButton.transform = moveDown
            RegisterButton.transform = moveDown
            //CGAffineTransform(translationX: 0, y: 60)
            
        }else{
            verficationCodeImage.isHidden = true
            verificationCodeTextFielld.isHidden = true
            PasswordTextFiled.isHidden = false
            SMSCodeIcon.isHidden = true
            GetSMSCodeButton.isHidden = true
            SMSCodeTextFiled.isHidden = true
            SMSCodeSeperator.isHidden = true
            verifyStatusIcon.isHidden = true
            
            switchLoginTypeButton.setTitle("短信验证码登录", for: .normal)
            TitleLabel.text = "账号密码登录"

            let moveUp = CGAffineTransform(translationX: 0, y: 0)
            submitButton.transform = moveUp
            switchLoginTypeButton.transform = moveUp
            RegisterButton.transform = moveUp
        }
        self.updateConstraints()
        
        isLoginWithPassword = !isLoginWithPassword
    }
    
    
    
    class func newInstance() -> DemoView? {
        
        
        let nibView = Bundle.main.loadNibNamed("DemoView", owner: nil, options: nil)
        
        if let view = nibView?.first as? DemoView {
            return view
        }else{
            return nil
        }
    }
    
    
    override func layoutSubviews() {
       // self.submitButton.titleLabel?.highlightedTextColor = UIColor.white
    }

    
    //发送短信验证码倒计时
    @objc func updateSendSMSCodeButton(){
        self.GetSMSCodeButton.setTitle("重新发送(\(counter))", for: .disabled)
        self.GetSMSCodeButton.backgroundColor = UIColor.lineColors(color: .grayLevel1)
        self.GetSMSCodeButton.isEnabled = false
        counter -= 1
        if self.counter == 0 {
            self.GetSMSCodeButton.backgroundColor = UIColor.backgroundColors(color: .lightOrange)
            self.GetSMSCodeButton.isEnabled = true
            //停止timer
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    

    func login(mobile phone:String, password pwd:String){
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["mobile"] = phone
        params["password"] = pwd
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "loginWithPhoneAndPwdAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "loginWithPhoneAndPwdAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    let msg = json["message"].string!
                    switch code {
                    case 200:
                      //  greyLayerPrompt.show(text: msg)
                        let token = json["data","token"].string!
                        let nickName = json["data","nickName"].string!
                        let accountId = json["data","accountId"].string!
                        let userAvatar = json["data","userAvatar"].stringValue
                        
                        self.loginMissionQueue(mobilePhone: phone, password: pwd, token: token, UserName: nickName, AccountID: accountId, Avatar: userAvatar)
                        
                    case 205:
                        greyLayerPrompt.show(text: msg)
                        print("账号密码不匹配")
                    case 210:
                        greyLayerPrompt.show(text: msg)
                        print("您已被禁止登陆，请联系客户经理")
                    default:
                        greyLayerPrompt.show(text: msg)
                        print("其他错误")
                    }
                }
            case false:
                print("验证图形验证码时出错")

            }
        }
    }
    
    func login(mobile phone:String, verificationCode code:String, SMSCode SMS:String){
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["mobile"] = phone
        params["smsCaptcha"] = SMS
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "loginWithSMSCodeAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "loginWithSMSCodeAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    let msg = json["message"].string!
                    switch code {
                       case 200:
                          // greyLayerPrompt.show(text: msg)
                           let token = json["data","token"].string!
                           let nickName = json["data","nickName"].string!
                           let accountId = json["data","accountId"].string!
                           let userAvatar = json["data","userAvatar"].stringValue
                           
                           //保存登录状态
                           self.loginMissionQueue(mobilePhone: phone, password: "", token: token, UserName: nickName, AccountID: accountId, Avatar: userAvatar)
                           
                           let isPasswordSettled = json["data","isPassword"].stringValue
                           if isPasswordSettled == "0"{
                            //设置登录密码
                                let nibView = Bundle.main.loadNibNamed("RegisterView", owner: nil, options: nil)
                                        
                                if let view = nibView?.first as? RegisterView {
                                    view.frame = CGRect(x: -25, y: -70, width: self.frame.width, height: self.frame.height)
                                    view.center = self.center
                                    view.demoViewDelegate = self
                                    view.mobilePhone = self.mobileNumber
                                    view.isForSettingPassword = true
                                    view.switchRegisterModelTo(SettingPassword: true)
                                    
                                    if let superView = self.superview {
                                        superView.addSubview(view)
                                    }else{
                                        self.addSubview(view)
                                    }
                                    
                                }
                           }
                           print("登陆成功")
                       case 202:
                           greyLayerPrompt.show(text: msg)
                           print("验证码过期或错误")
                        case 208:
                            greyLayerPrompt.show(text: msg)
                            print("账号未注册")
                       case 210:
                           greyLayerPrompt.show(text: msg)
                           print("您已被禁止登陆，请联系客户经理")
                       default:
                           greyLayerPrompt.show(text: msg)
                           print("其他错误")
                    }
                    
                }
            case false:
                print("验证图形验证码时出错")

            }
        }
    }
    
    func registerNextStep(mobile phone:String, verificationCode code:String, SMSCode SMS:String){
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["mobile"] = phone
        params["smsCaptcha"] = SMS
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "registerNextStepAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "registerNextStepAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    let msg = json["message"].string!
                    switch code {
                       case 200:
                       let nibView = Bundle.main.loadNibNamed("RegisterView", owner: nil, options: nil)
                                  
                          if let view = nibView?.first as? RegisterView {
                              view.frame = CGRect(x: -25, y: -70, width: self.frame.width, height: self.frame.height)
                              view.center = self.center
                              view.demoViewDelegate = self
                              view.mobilePhone = self.mobileNumber
                              view.isForSettingPassword = false
                              view.switchRegisterModelTo(SettingPassword: false)
                              
                              if let superView = self.superview {
                                  superView.addSubview(view)
                              }else{
                                  self.addSubview(view)
                              }
                              
                          }
                       case 202:
                           greyLayerPrompt.show(text: msg)
                           print("验证码过期或错误")
                        case 204:
                            greyLayerPrompt.show(text: msg)
                            print("手机号已注册")
                       case 203:
                           greyLayerPrompt.show(text: msg)
                           print("错误")
                       default:
                           greyLayerPrompt.show(text: msg)
                           print("其他错误")
                    }
                    
                }
            case false:
                print("验证图形验证码时出错")

            }
        }
    }
    
    func getVerificationImage() {
        
        let params:NSMutableDictionary = NSMutableDictionary()
            
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            
            let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
            #if DEBUG
            let URL:String = apiAddresses.value(forKey: "getIdentifingCodeAPIDebug") as! String
            #else
            let URL:String = apiAddresses.value(forKey: "getIdentifingCodeAPI") as! String
            #endif
            //发起请求
            Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
                (responseObject) in
                switch responseObject.result.isSuccess{
                case true:
                    if let value = responseObject.result.value{
                        let json = JSON(value)
                        self.SessionUUID = json["data","uuid"].string!
                        self.getVerificationCode(UUID: self.SessionUUID)
                    }
                    self.verificationCodeImage = UIImage(data: responseObject.data!)
                case false:
                    print("获取UUID失败")
                   
                }
            }
        }



    func getVerificationCode(UUID uuid:String) {
        let params:NSMutableDictionary = NSMutableDictionary()
        params["uuid"] = uuid
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "getverifyCodeAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "getverifyCodeAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                self.verficationCodeImage.setImage(UIImage(data: responseObject.data!), for: .normal)
            case false:
                print("获取验证码失败")

            }
        }
    }
    
    //验证图形验证码
    func verifyImageCode(UUID uuid:String, verificationCode code: String) {
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["uuid"] = uuid
        params["captcha"] = code
        
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "verifyCodeAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "verifyCodeAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    if code == 200 {
                        self.verifyStatusIcon.isHidden = false
                        self.verifyStatusIcon.isHighlighted = false
                        self.isVerificationCodeLegal = true
                       // print("图形验证码验证成功")
                    }else{
                       // print("图形验证码验证失败")
                        self.verifyStatusIcon.isHidden = false
                        self.verifyStatusIcon.isHighlighted = true
                        self.isVerificationCodeLegal = false
                    }
                }
            case false:
                print("验证图形验证码时出错")
                self.verifyStatusIcon.isHidden = false
                self.verifyStatusIcon.isHighlighted = true
                self.isVerificationCodeLegal = false

            }
        }
    }

    func SendSMSCode(UUID uuid:String, verificationCode code: String, mobilePhone phone:String) {
        
        //手机号有效性验证
        guard isMobilePhoneLegal(mobile: phone) else {
            greyLayerPrompt.show(text: "手机号不合法")
            return
        }
        
        guard isVerificationCodeLegal else {
            greyLayerPrompt.show(text: "验证码错误")
            return
        }
        let params:NSMutableDictionary = NSMutableDictionary()
        params["captcha"] = code
        params["uuid"] = uuid
        params["mobile"] = phone
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "sendSMSCodeAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "sendSMSCodeAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                print("发送短信验证码成功")
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateSendSMSCodeButton), userInfo: nil, repeats: true)
            case false:
                print("发送短信验证码失败")

            }
        }
    }
    
    func loginMissionQueue(mobilePhone phone:String,password pwd:String,token token:String,UserName nickName:String, AccountID accountId:String, Avatar userAvatar:String){
        let dataOperator = CoreDataOperation()
        
        //保存token到Core Data
        dataOperator.saveToken(token: token)
        //保存账户信息
        dataOperator.saveAccountInfo(userName: phone, nickName: nickName, userId: accountId, password: pwd)
        
        //同步用户的头像
        UserDefaults.standard.set(userAvatar, forKey: "currentUserAvatar")
        UserDefaults.standard.set(0, forKey: "currentRoleType")
        UserDefaults.standard.set(token, forKey: "currentToken")
        UserDefaults.standard.synchronize()
        
        ShowLoading()
        
        getTenement(Token: token)
    }
    
    func loginMissionQueue(password pwd:String,Token token:String){
           let dataOperator = CoreDataOperation()
            //保存账户信息
           dataOperator.saveAccountInfo(password: pwd)
           
           ShowLoading()
           
           getTenement(Token: token)
       }
    
    func getTenement(Token token:String) {
        let params:NSMutableDictionary = NSMutableDictionary()
        //定义请求参数
        var header:HTTPHeaders  = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        header["roleType"] = "0"
        header["tenementId"] = "18"
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "getTenementInfoAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "getTenementInfoAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers: header) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    if json.count == 0{
                        //普通用户
                        //跳转页面
                         let tabBar = TabBarController(royeType: 0)
                         //let appDelegate = AppDelegate()
                         let appDelegate = UIApplication.shared.delegate as! AppDelegate
                         appDelegate.window?.rootViewController = tabBar
                        // view.present(tabBar, animated: true, completion: nil)
                        let vc = self.getFirstViewController()
                        vc!.present(tabBar, animated: true, completion: {
                             //(finished) -> Void in
                            self.StopLoding()
                             print("load tab bar finished ")
                         })
                    }else{
                        //有租户的用户
                        let code = json["code"].int!
                        if code == 200 {
                            let tenementID = json["data","tenementId"].int!
                            UserDefaults.standard.set(tenementID, forKey: "currentTenementId")
                            UserDefaults.standard.synchronize()
                            self.getCurrentRole(Token: token, TenementID: tenementID,systemType: 2)
                        }else{
                            print("图形验证码验证失败")
                        }
                    }
                }
            case false:
                print("发送短信验证码失败")

            }
        }
    }
    
    func getCurrentRole(Token token:String,TenementID id:Int,systemType system:Int){
        
            let params:NSMutableDictionary = NSMutableDictionary()
           //定义请求参数
           var header:HTTPHeaders  = NSMutableDictionary() as! HTTPHeaders
           header["token"] = token
           
           header["tenementId"] = "\(id)"
           header["roleType"] = "0"
           
           params["systemType"] = "\(system)"
           
           let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
           let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
           
           let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
           #if DEBUG
           let URL:String = apiAddresses.value(forKey: "getCurrentRoleAPIDebug") as! String
           #else
           let URL:String = apiAddresses.value(forKey: "getCurrentRoleAPI") as! String
           #endif
           //发起请求
           Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers: header) .responseData {
               (responseObject) in
               switch responseObject.result.isSuccess{
               case true:
                   if let value = responseObject.result.value{
                       let json = JSON(value)
                       let code = json["code"].int!
                       if code == 200 {
                           let currentRoleId = json["data","roleId"].int!
                           let currentRoleType = json["data","roleType"].int!
                           UserDefaults.standard.set(currentRoleId, forKey: "currentRoleId")
                           UserDefaults.standard.set(currentRoleType, forKey: "currentRoleType")
                           UserDefaults.standard.synchronize()
                           //获取用户系统
                           self.getTopNav(Token: token, TenementId: id, RoleType: currentRoleType)
                       }else{
                           print("图形验证码验证失败")
                       }
                   }
               case false:
                   print("发送短信验证码失败")

               }
           }
    }
    
    func getTopNav(Token token:String,TenementId id:Int,RoleType roleType:Int) {
        let params:NSMutableDictionary = NSMutableDictionary()
        //定义请求参数
        var header:HTTPHeaders  = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        
        header["tenementId"] = "\(id)"
        header["roleType"] = "\(roleType)"
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "getTopNavAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "getTopNavAPI") as! String
        #endif
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers: header) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    if code == 200 {
                        
                        var tempArray:[NSDictionary] = []
                        
                        for item in json["data"].array!{
                            let dictonaryObject = item.dictionaryObject! as NSDictionary
                            tempArray.append(dictonaryObject)
                        }
                        
                        let isWorkShopAvaiable = self.isWorkShopAvaiable(Json: tempArray)
                        if isWorkShopAvaiable {
                            print("system avaiable")
                        }else{
                            //普通用户
                            //跳转页面
                             let tabBar = TabBarController(royeType: 0)
                             //let appDelegate = AppDelegate()
                             let appDelegate = UIApplication.shared.delegate as! AppDelegate
                             appDelegate.window?.rootViewController = tabBar
                            // view.present(tabBar, animated: true, completion: nil)
                            let vc = self.getFirstViewController()
                            vc!.present(tabBar, animated: true, completion: {
                                 //(finished) -> Void in
                                self.StopLoding()
                                 print("load tab bar finished ")
                             })
                        }
                    }else{
                        print("图形验证码验证失败")
                    }
                }
            case false:
                print("发送短信验证码失败")

            }
        }
    }
    
    //检测工作台页面是否可用
    func isWorkShopAvaiable(Json data:[NSDictionary]) -> Bool{
        guard data.count != 0 else {
            return false
        }
        
        for item in data{
            if item.value(forKey: "id") as! Int == 1001 {
                let subsystem = item.value(forKey: "subsystem") as! NSArray
                if subsystem.count == 0{
                    return false
                }else{
                    for sub in subsystem{
                        let subObject = sub as! NSDictionary
                        if subObject.value(forKey: "id") as! Int == 1003{
                            return true
                        }
                    }
                    return false
                }
            }
        }
        return false
    }
    
    func ShowLoading(){
        StopLoding()
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
        noticeWhenLoadingData.text = "加载中，请稍侯..."
        noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
        noticeWhenLoadingData.textColor = UIColor.gray
        noticeWhenLoadingData.textAlignment = .center
        //loading动画
        var images:[UIImage] = []
        for i in 0...27{
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named:imagePath)!
            images.append(image)
        }
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        
        let vc = self.getFirstViewController()
        let view = UIView.init(frame: vc!.view.frame)
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        vc!.view.addSubview(view)
        
        
        view.addSubview(imageView)
        view.addSubview(noticeWhenLoadingData)
        
        loadingSubViews.removeAll()
        loadingSubViews.append(imageView)
        loadingSubViews.append(noticeWhenLoadingData)
    }
    
    func StopLoding(){
        for item in loadingSubViews{
            item.removeFromSuperview()
        }
        loadingSubViews.removeAll()
    }
}


