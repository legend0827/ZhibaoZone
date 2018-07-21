//
//  Login.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire.Swift

class User: NSObject {
    var _username:String
    var _password:String
    var meVC = MeViewController()
    var verifyVC = VerifyPasswordViewController()
    var isSwitching = false // 判断是不是直接切换账号
    var _nikeName = "车间1"
    override init() {
        _username = "anonymous"
        _password = "anouymous"
    }
    
    func verifyPassword(username:String,password:String,view:UIViewController,hub:UIWindow) {
        _username = username
        _password = password
        let params:NSMutableDictionary = NSMutableDictionary()
        params["email"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        params["loginip"] = getLocalIPAddressForCurrentWiFi()
        
        print("登录信息：\(params)")
        var result = false
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddressDebug") as! String
        #else
        let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddress") as! String
        #endif
        //发起请求
        Alamofire.request(loginURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["status","code"].string
                    let code = Int64(newcode!)!
                    switch code{
                    case 0:
                        print("执行json")
                        result = true
                    case 1:
                        print("1")
                        result = true
                    case 2:
                        print("2")
                        result = true
                    case 3:
                        print("3")
                        result = true
                    case 4:
                        print("4")
                        result = false
                        greyLayerPrompt.show(text: "账号不存在")
                    case 5:
                        print("5")
                        result = false
                        greyLayerPrompt.show(text: "密码错误")
                    case 6:
                        print("6")
                        result = false
                    default:
                        print("default")
                        result = false
                    }
                    //登录成功，跳转首页
                    if result == true {
                        //新账号信息
                        let nickName = json["userinfo","nickname"].string
                        let newuserId = json["userinfo","userid"].string
                        let userName = self._username
                        var newroleType = json["userinfo","roletype"].string
                        let token = json["userinfo","token"].string
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == "null"{
                            newroleType = "0"
                        }
                        let roleType = Int64(newroleType!)!
                        let userId = Int64(newuserId!)!
                        
                        let dataOperator = CoreDataOperation()
                        dataOperator.saveAddtionalAccount(userName: userName, nickName: nickName!, userId: Int64(newuserId!)!, roleType: Int64(newroleType!)!, password: self._password)
                        dataOperator.saveAddtionalToken(token: token!) // token
                        if newuserId == "10000013" {
                            dataOperator.saveProducerOfManagerToken(token: token!)
                            dataOperator.saveProducerOfManager(userName: userName, nickName: nickName!, userId: Int64(newuserId!)!, roleType: Int64(newroleType!)!, password: self._password)
                        }
                        print("verify succeed")
                        hub.hide()
                        DispatchQueue.global().async {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                                view.successNotice("验证成功", autoClear: true)
                            })
                        }
                        self.meVC.updateAddtionalAcountInfos()
                        self.meVC.cancelBtnClicked()
                        self.verifyVC.cancelBtnClicked()
                    }else{
                        hub.hide()
                        print("vefify failed")
                    }
                }
            case false:
                print(responseObject.result.error ?? "No result found")
                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                hub.hide()
            }
        }
        print("返回结果")
    }
    
    // 登录方法
    func Login(username:String,password:String,view:UIViewController,hub:UIWindow) {
        _username = username
        _password = password
        
        let params:NSMutableDictionary = NSMutableDictionary()
        params["email"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        params["loginip"] = getLocalIPAddressForCurrentWiFi()
        
        print("登录信息：\(params)")
        var result = false
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
      
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddressDebug") as! String
        #else
            let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddress") as! String
        #endif
        //发起请求
        Alamofire.request(loginURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["status","code"].string
                    let code = Int64(newcode!)!
                    switch code{
                    case 0:
                        print("执行json")
                        result = true
                    case 1:
                        print("1")
                        result = true
                    // greyLayerPrompt.show(text: "用户已在线")
                    case 2:
                        print("2")
                        result = true
                    // greyLayerPrompt.show(text: "长时间未登录")
                    case 3:
                        print("3")
                        result = true
                        //greyLayerPrompt.show(text: "异地登录")
                    case 4:
                        print("4")
                        result = false
                        greyLayerPrompt.show(text: "账号不存在")
                    case 5:
                        print("5")
                        result = false
                        greyLayerPrompt.show(text: "密码错误")
                        
                        if self.isSwitching{
                            //直接切换账号时，如果密码错误
                            let verifyVC = VerifyPasswordViewController()
                            verifyVC._nikeName = self._nikeName
                            verifyVC._userAccount = self._username
                            verifyVC.meVC = self.meVC
                            self.meVC.present(verifyVC, animated: true, completion: nil)
                        }
                        
                    case 6:
                        print("6")
                        result = false
                    default:
                        print("default")
                        result = false
                    }
                    //登录成功，跳转首页
                    if result == true {
                        //新账号信息
                        let nickName = json["userinfo","nickname"].string
                        let newuserId = json["userinfo","userid"].string
                        let userName = self._username
                        var newroleType = json["userinfo","roletype"].string
                        let token = json["userinfo","token"].string
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == "null"{
                            newroleType = "0"
                        }
                        let roleType = Int64(newroleType!)!
                        let userId = Int64(newuserId!)!
            
                        let dataOperator = CoreDataOperation()
                        
                        let isAccountAvaiable = dataOperator.checkAccountAvaiable(forAddtional: false)
                        
                        //原账号信息
                        if isAccountAvaiable {
                            
                            let originlUserinfos = getCurrentUserInfo()
                            //原账号信息
                            let originalroleType = originlUserinfos.value(forKey: "roletype") as! String
                            let originaluserID = originlUserinfos.value(forKey: "userid") as! String
                            let originaluserName = originlUserinfos.value(forKey: "username") as! String
                            let originalnikeName = originlUserinfos.value(forKey: "nikename") as! String
                            let originalPWD = originlUserinfos.value(forKey: "password") as! String
                            let originaltoken = originlUserinfos.value(forKey: "token") as! String
  
                            if newroleType == "4" {
                                //新登录经理角色、写入车间1账号

                                var addnikename = "车间1"
                                var addaccount = "zbgc1@zhibao.com"
                                var addpassword = "zb1234"
                                
                                if originaluserID == "10000013"{
                                     addnikename = originalnikeName
                                     addaccount = originaluserName
                                     addpassword = originalPWD
                                }
                                dataOperator.saveAddtionalAccount(userName: addaccount, nickName: addnikename, userId: 10000013, roleType: 3, password: addpassword)
                                
                                if Int(originaluserID) == 10000013{ //上一个账号如果是车间1账号,则写入车间token
                                    dataOperator.saveAddtionalToken(token: originaltoken) // token
                                }else{
                                    //上一个账号不是车间1账号
                                    let isAddtionalAccountAvailable = dataOperator.checkAccountAvaiable(forAddtional: true)
                                    if isAddtionalAccountAvailable {
                                            let addtionalUserInfos = getProducerOfManagerInfo()// getAddtionalUserInfo()
                                            let token = addtionalUserInfos.value(forKey: "token") as! String
                                            let userid = addtionalUserInfos.value(forKey: "userid") as! String
                                            if userid == "10000013" {
                                                dataOperator.saveAddtionalToken(token: token)
                                            }
                                    }else{
                                            dataOperator.saveAddtionalToken(token: "NOTSET") // token
                                    }
                                    
                                }
                                
                            }else if newuserId == "10000013" && Int(originalroleType) == 4 {
                                //现在账号是车间，如果原账号是经理，则写入经理账号到特殊账号里
                                dataOperator.saveAddtionalAccount(userName: originaluserName, nickName: originalnikeName, userId: Int64(originaluserID)!, roleType: Int64(originalroleType)!, password: originalPWD)
                                dataOperator.saveAddtionalToken(token: originaltoken) // token
                            }
                        }else{

                            if newroleType == "4" {
                                //新登录经理角色、写入车间1账号
                                let addnikename = "车间1"
                                let addaccount = "zbgc1@zhibao.com"
                                let addpassword = "zb1234"
                                
                                dataOperator.saveAddtionalAccount(userName: addaccount, nickName: addnikename, userId: 10000013, roleType: 3, password: addpassword)
                                dataOperator.saveAddtionalToken(token: "NOTSET") // token
                            }
                        }
                        
                        //记录最新登录的账号信息
                        dataOperator.saveAccountInfo(userName:userName,nickName:nickName!,userId:userId,roleType: roleType,password: password)
                        dataOperator.saveToken(token: token!)
                        //如果登录的是车间1角色，同时保存到id为3到core data 里
                        if newuserId == "10000013" {
                            dataOperator.saveProducerOfManager(userName: userName, nickName: nickName!, userId: userId, roleType: roleType, password: password)
                            dataOperator.saveProducerOfManagerToken(token: token!)
                        }
                        
                        print("login succeed")
                        hub.hide()
                        let deviceToken = UserDefaults.standard.object(forKey: "myDeviceToken")
                        DispatchQueue.global().async {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                                view.successNotice("登录成功", autoClear: true)
                            })
                        }
                        
                        //跳转页面
                        let tabBar = TabBarController(royeType: Int(roleType))
                        let appDelegate = AppDelegate()
                        appDelegate.window?.rootViewController = tabBar
                        view.present(tabBar, animated: true, completion: nil)
                    }else{
                        hub.hide()
                        print("login failed")
                    }
                }
            case false:
                print(responseObject.result.error ?? "No result found")
                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                hub.hide()
            }
        }
        print("返回结果")        
    }
    
    func simpleLogin(username:String,password:String,view:UIViewController,hub:UIWindow){
        _username = username
        _password = password
        
        let params:NSMutableDictionary = NSMutableDictionary()
        params["email"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        params["loginip"] = getLocalIPAddressForCurrentWiFi()
        
        print("登录信息：\(params)")
        var result = false
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddressDebug") as! String
        #else
            let loginURL:String = apiAddresses.value(forKey: "loginInAPIAddress") as! String
        #endif
        //发起请求
        Alamofire.request(loginURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["status","code"].string
                    let code = Int64(newcode!)!
                    switch code{
                    case 0:
                        print("执行json")
                        result = true
                    case 1:
                        print("1")
                        result = true
                    // greyLayerPrompt.show(text: "用户已在线")
                    case 2:
                        print("2")
                        result = true
                    // greyLayerPrompt.show(text: "长时间未登录")
                    case 3:
                        print("3")
                        result = true
                    //greyLayerPrompt.show(text: "异地登录")
                    case 4:
                        print("4")
                        result = false
                        greyLayerPrompt.show(text: "账号不存在")
                    case 5:
                        print("5")
                        result = false
                        greyLayerPrompt.show(text: "密码错误")
                    case 6:
                        print("6")
                        result = false
                    default:
                        print("default")
                        result = false
                    }
                    //登录成功，跳转首页
                    if result == true {
                        let nickName = json["userinfo","nickname"].string
                        let newuserId = json["userinfo","userid"].string
                        let userName = self._username
                        var newroleType = json["userinfo","roletype"].string
                        let token = json["userinfo","token"].string
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == "null"{
                            newroleType = "0"
                        }
                        let roleType = Int64(newroleType!)!
                        let userId = Int64(newuserId!)!
                        let dataOperator = CoreDataOperation()
                        //查询是不是已经有相似记录了
                        dataOperator.saveAccountInfo(userName:userName,nickName:nickName!,userId:userId,roleType: roleType,password: password)
                        dataOperator.saveToken(token: token!)
                        
                        
                        //跳转页面
                        let tabBar = TabBarController(royeType: Int(roleType))
                        let appDelegate = AppDelegate()
                        appDelegate.window?.rootViewController = tabBar
                        view.present(tabBar, animated: true, completion: nil)
                        
                        
                        print("login succeed")
                        hub.hide()
                        let deviceToken = UserDefaults.standard.object(forKey: "myDeviceToken")
                        DispatchQueue.global().async {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                                view.successNotice("注册成功", autoClear: true)
                            })
                        }
                    }else{
                        hub.hide()
                        print("login failed")
                    }
                }
            case false:
                print(responseObject.result.error ?? "No result found")
                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                hub.hide()
            }
        }
    }
    
    func registerAccount(username:String,password:String,view:UIViewController,hub:UIWindow){
        _username = username
        _password = password
        
        let params:NSMutableDictionary = NSMutableDictionary()
        params["email"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        params["loginip"] = getLocalIPAddressForCurrentWiFi()
        
        print("登录信息：\(params)")
        var result = false
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
            let requestURL:String = apiAddresses.value(forKey: "registerAPIAddressDebug") as! String
        #else
            let requestURL:String = apiAddresses.value(forKey: "registerAPIAddress") as! String
        #endif
        //发起请求
        Alamofire.request(requestURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["status","code"].string
                    let code = Int64(newcode!)!
                    switch code{
                    case 0:
                        print("执行json")
                        result = true
                    case 1:
                        print("1")
                        result = false
                        greyLayerPrompt.show(text: "用户已存在,换个账号吧")
                    case 3:
                        print("3")
                        result = false
                        greyLayerPrompt.show(text: "注册失败,未知原因")
                    default:
                        print("default")
                        result = false
                    }
                    //注册成功，跳转首页
                    if result == true {
                        self.simpleLogin(username: self._username.lowercased(), password: password, view: view, hub: hub)
                    }else{
                        hub.hide()
                        print("register failed failed")
                    }
                }
            case false:
                print(responseObject.result.error ?? "No result found")
                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                hub.hide()
            }
        }
        print("返回结果")
    }
    //获取ip地址
    private func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
}


