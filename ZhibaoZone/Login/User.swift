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
    
    override init() {
        _username = "anonymous"
        _password = "anouymous"
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
                                view.successNotice("登录成功", autoClear: true)
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


