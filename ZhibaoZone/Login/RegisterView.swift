//
//  RegisterView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2020/1/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class RegisterView: UIView {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var PwdIcon: UIImageView!
    @IBOutlet weak var RepeatPwdIcon: UIImageView!
    @IBOutlet weak var PwdSepeatorLine: UIImageView!
    @IBOutlet weak var RepeatPwdSepeatorLine: UIImageView!
    @IBOutlet weak var PwdTextField: UITextField!
    @IBOutlet weak var RepeatPwdTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backToLoginBtn: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    //登陆页面代理
    lazy var demoViewDelegate = DemoView()
    
    //全局变量
    var mobilePhone:String = ""
    var isForSettingPassword = false
    var isPasswordLegal:Bool {
           let password = PwdTextField.text ?? ""
           let repeatPassword = RepeatPwdTextField.text ?? ""
           print("geting value")
           if  password == "" {
               greyLayerPrompt.show(text: "请输入密码")
               return false
           }else if repeatPassword != password {
               greyLayerPrompt.show(text: "密码和确认密码不一致")
               return false
           }
           return  true
    }
    @IBAction func BackToLoginClicked(_ sender: Any) {
        self.removeFromSuperview()
        demoViewDelegate.backToLogin()
        demoViewDelegate.isRegisterModel = false
    }
    @IBAction func ReturnButtonClicked(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func ConfiirmRegisterClicked(_ sender: Any) {
        let password = RepeatPwdTextField.text ?? ""
        guard isPasswordLegal else {
            return
        }
        if isForSettingPassword{
            let token = UserDefaults.standard.value(forKey: "currentToken") as! String
            settingLoginPassword(token: token, password: password)
        }else{
            setPassword(mobile: mobilePhone, password: password)
        }
    }
    
    //输入框选中和离框效果
    @IBAction func PwdFieldFocus(_ sender: Any) {
        PwdIcon.isHighlighted = true
        PwdSepeatorLine.isHighlighted = true
    }
    @IBAction func PwdFieldDissSelected(_ sender: Any) {
        PwdIcon.isHighlighted = false
        PwdSepeatorLine.isHighlighted = false
    }
    @IBAction func RepeatPwdFieldFocus(_ sender: Any) {
        RepeatPwdIcon.isHighlighted = true
        RepeatPwdSepeatorLine.isHighlighted = true
    }
    @IBAction func RepeatPwdFieldDissSelected(_ sender: Any) {
        RepeatPwdIcon.isHighlighted = false
        RepeatPwdSepeatorLine.isHighlighted = false
    }
    
    func switchRegisterModelTo(SettingPassword isSettingPassword:Bool){
        if isSettingPassword {
            TitleLabel.text = "设置登录密码"
            backButton.isHidden = true
            backToLoginBtn.isHidden = true
            RegisterButton.setTitle("设置密码", for: .normal)
        }else{
            TitleLabel.text = "注册"
            backButton.isHidden = false
            backToLoginBtn.isHidden = false
            RegisterButton.setTitle("注册", for: .normal)
        }
    }
    
    func settingLoginPassword(token token:String,password newPassword:String){
        let params:NSMutableDictionary = NSMutableDictionary()
        //定义请求参数
        var header:HTTPHeaders  = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        params["newPassword"] = newPassword
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let URL:String = apiAddresses.value(forKey: "loginToSetPasswordAPIDebug") as! String
        #else
            let URL:String = apiAddresses.value(forKey: "loginToSetPasswordAPI") as! String
        #endif
       
        //发起请求
        Alamofire.request(URL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseData {
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    let code = json["code"].int!
                    let msg = json["message"].string!
                    switch code {
                       case 200:
                        print("密码成功")
                        self.demoViewDelegate.loginMissionQueue(password: newPassword, Token: token)
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
    
    func setPassword(mobile phone:String, password pwd:String) {
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["mobile"] = phone
        params["password"] = pwd
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let URL:String = apiAddresses.value(forKey: "setPasswordAPIDebug") as! String
        #else
        let URL:String = apiAddresses.value(forKey: "setPasswordAPI") as! String
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
                        print("成功")
                        self.demoViewDelegate.login(mobile: phone, password: pwd)
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
}
