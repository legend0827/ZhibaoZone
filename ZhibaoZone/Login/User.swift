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
    var isAutoLoginFaled = false //自动登录失败了
    var isToAutoLogin = false
    override init() {
        _username = "anonymous"
        _password = "anouymous"
    }
    
    func verifyPassword(username:String,password:String,view:UIViewController,hub:UIWindow) {
        _username = username
        _password = password
        let params:NSMutableDictionary = NSMutableDictionary()
        params["mobilephone"] = self._username.lowercased()
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
        Alamofire.request(loginURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["code"].int!
                    let code = Int64(newcode)
                    switch code{
                    case 200:
                        print("登录成功")
                        result = true
                    case 100001:
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
                    default:
                        print("default")
                        greyLayerPrompt.show(text: "登录失败、服务器连接异常")
                        result = false
                    }
                    //登录成功，跳转首页
                    if result == true {
                        //新账号信息
                        //新账号信息
                        let nickName = json["data","nickName"].string ?? json["data","mickName"].string //如果没有找到nikeName，则使用mikeName
                        let newuserId = json["data","userId"].string
                        let userName = self._username
                        var newroleType = json["data","roleType"].int64
                        let token = json["data","token"].string
                       // self.getSystemParas(token: token!)
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == nil{
                            newroleType = 0
                        }
                        let roleType = Int64(newroleType!)
                        let userId = Int64(newuserId!)!
                        
                        self.getSystemParas(view: view, token: token!, roleType: Int(roleType), needsJump: false)

                        let dataOperator = CoreDataOperation()
                        dataOperator.saveAddtionalAccount(userName: userName, nickName: nickName!, userId: Int64(newuserId!)!, roleType: Int64(newroleType!), password: self._password)
                        dataOperator.saveAddtionalToken(token: token!) // token
                        if newuserId == "10000013" {
                            dataOperator.saveProducerOfManagerToken(token: token!)
                            dataOperator.saveProducerOfManager(userName: userName, nickName: nickName!, userId: Int64(newuserId!)!, roleType: Int64(newroleType!), password: self._password)
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
        params["mobilephone"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        params["loginip"] = getLocalIPAddressForCurrentWiFi()
        
        print("登录信息：\(params)")
        print("call Login")
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
        Alamofire.request(loginURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["code"].int!
                    let code = Int64(newcode)
                    switch code{
                    case 200:
                        print("登录成功")
                        result = true
                        self.isAutoLoginFaled = false
                    case 100001:
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
                        if self.isToAutoLogin{
                            self.isAutoLoginFaled = true
                        }else{
                            self.isAutoLoginFaled = false
                        }
                        
                    default:
                        print("default")
                        greyLayerPrompt.show(text: "登录失败、服务器连接异常")
                        result = false
                        if self.isToAutoLogin{
                            self.isAutoLoginFaled = true
                        }else{
                            self.isAutoLoginFaled = false
                        }
                    }
                    //登录成功，跳转首页
                    if result == true {
                        //新账号信息
                        let nickName = json["data","nickName"].string ?? json["data","mickName"].string //如果没有找到nikeName，则使用mikeName
                        let newuserId = json["data","userId"].string
                        let userName = self._username
                        var newroleType = json["data","roleType"].int64
                        let token = json["data","token"].string
                       
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == nil {
                            newroleType = 0
                        }
                        let roleType = newroleType
                        let userId = Int64(newuserId!)!
            
                        self.getSystemParas(view: view, token: token!, roleType: Int(roleType!), needsJump: true)

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
  
                            if newroleType == 4 {
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

                            if newroleType == 4 {
                                //新登录经理角色、写入车间1账号
                                let addnikename = "车间1"
                                let addaccount = "zbgc1@zhibao.com"
                                let addpassword = "zb1234"
                                
                                dataOperator.saveAddtionalAccount(userName: addaccount, nickName: addnikename, userId: 10000013, roleType: 3, password: addpassword)
                                dataOperator.saveAddtionalToken(token: "NOTSET") // token
                            }
                        }
                        
                        //记录最新登录的账号信息
                        dataOperator.saveAccountInfo(userName:userName,nickName:nickName!,userId:userId,roleType: roleType ?? 0,password: password)
                        dataOperator.saveToken(token: token!)
                        //如果登录的是车间1角色，同时保存到id为3到core data 里
                        if newuserId == "10000013" {
                            dataOperator.saveProducerOfManager(userName: userName, nickName: nickName!, userId: userId, roleType: roleType ?? 0, password: password)
                            dataOperator.saveProducerOfManagerToken(token: token!)
                        }
                        
                        print("login succeed")
                        hub.hide()
                        let deviceToken = UserDefaults.standard.object(forKey: "myDeviceToken")
                        if deviceToken != nil{
                            updatesDeviceToken(withDeviceToken: deviceToken as! String, user: newuserId!, toBind: true)
                        }
                        
                        DispatchQueue.global().async {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                                view.successNotice("登录成功", autoClear: true)
                            })
                        }
                        
                        
                        
                    }else{
                        hub.hide()
                        print("login failed")
                        if self.isAutoLoginFaled{
                            let loginVC = ViewController()
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            loginVC.needsAutoLogin = false
                            appDelegate.window?.rootViewController = loginVC
                            view.dismiss(animated: true, completion: nil)
                            //view.present(loginVC, animated: true, completion: nil)
                            
                        }
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
        
        print("call simleLogin")
        let params:NSMutableDictionary = NSMutableDictionary()
        params["mobilephone"] = self._username.lowercased()
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
        Alamofire.request(loginURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    print(json)
                    let newcode = json["code"].int!
                    let code = Int64(newcode)
                    switch code{
                    case 200:
                        print("登录成功")
                        result = true
                    case 100001:
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
                    default:
                        print("default")
                        greyLayerPrompt.show(text: "登录失败、服务器连接异常")
                        result = false
                    }
                    //登录成功，跳转首页
                    if result == true {
                        //新账号信息
                        let nickName = json["data","nickName"].string ?? json["data","mickName"].string //如果没有找到nikeName，则使用mikeName
                        let newuserId = json["data","userId"].string
                        let userName = self._username
                        var newroleType = json["data","roleType"].int64
                        let token = json["data","token"].string
                        
                        //如果newroleType返回空，则指定为普通用户；0
                        if newroleType == nil {
                            newroleType = 0
                        }
                        let roleType = Int64(newroleType!)
                        let userId = Int64(newuserId!)!
                        self.getSystemParas(view: view, token: token!, roleType: Int(roleType), needsJump: true)

                        
                        let dataOperator = CoreDataOperation()
                        //查询是不是已经有相似记录了
                        dataOperator.saveAccountInfo(userName:userName,nickName:nickName!,userId:userId,roleType: roleType,password: password)
                        dataOperator.saveToken(token: token!)
                        
                        //跳转页面
                        let tabBar = TabBarController(royeType: Int(roleType))
                        //let appDelegate = AppDelegate()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = tabBar
                       // view.present(tabBar, animated: true, completion: nil)
                        view.present(tabBar, animated: true, completion: {
                            //(finished) -> Void in
                            print("load tab bar finished ")
                        })
                        
                        
                        print("login succeed")
                        hub.hide()
                        let deviceToken = UserDefaults.standard.object(forKey: "myDeviceToken")
                        if deviceToken != nil{
                            updatesDeviceToken(withDeviceToken: deviceToken as! String, user: newuserId!, toBind: true)
                        }
                        
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
        params["mobilephone"] = self._username.lowercased()
        params["password"] = self._password
        //获取用户的IP
        //params["loginip"] = getLocalIPAddressForCurrentWiFi()
        params["roletype"] = "0"
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
                    let newcode = json["code"].int!
                    let code = Int64(newcode)
                    if code == 200{
                         result = true
                        print("注册成功")
                    }else{
                        result = false
                        let msg = json["message"].string!
                        greyLayerPrompt.show(text: msg)
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
    
    
    func getSystemParas(view:UIViewController,token:String,roleType:Int,needsJump:Bool){
        //获取用户信息
       // let userInfos = getCurrentUserInfo()
       // let token = userInfos.value(forKey: "token") as? String
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        var header:HTTPHeaders  = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        var requestUrl:String = ""
        #if DEBUG
        requestUrl = apiAddresses.value(forKey: "getSystemParamsDebug") as! String
        #else
        requestUrl = apiAddresses.value(forKey: "getSystemParams") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:HTTPMethod.get, parameters: nil,encoding: JSONEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["code"].int!
                    if statusObject == 200{
                        
                        //系统参数数据
                        var systemParama:[AnyObject] = []
                        //产品参数数据
                        let productParams:NSDictionary = json["data","flatRelation"].dictionaryObject! as NSDictionary
                        //写入订单状态表
                        let orderStatusParams:NSDictionary = json["data","orderStatus"].dictionaryObject! as NSDictionary
                        //写入Commands到命令参数表
                        let commandsParams:NSArray = json["data","commands"].arrayObject! as NSArray
                        
                        systemParama.append(productParams)
                        systemParama.append(orderStatusParams)
                        systemParama.append(commandsParams)
                        
                        let pfileOfSystemParas = Bundle.main.path(forResource: "config_systemParas", ofType: "plist")
                        //清除现有的文件列表
                        let emptyArray:NSArray = []
                        emptyArray.write(toFile: pfileOfSystemParas!, atomically: true)
                        
                        let array = NSArray(array: systemParama)
                        //let array = NSArray(array: productArray)
                        //将数组写入联系人列表
                        array.write(toFile: pfileOfSystemParas!, atomically: true)
                        print("file Path:\(pfileOfSystemParas)")
                        print("请求成功")
                        //getSystemParasFromPlist()
                        if needsJump{
                        //跳转页面
                            var tabBar = TabBarController(royeType: roleType)
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = tabBar
                            while (tabBar.presentedViewController != nil){
                                tabBar = tabBar.presentedViewController as! TabBarController
                            }
                            view.present(tabBar, animated: true, completion: nil)
                            //appDelegate?.window??.rootViewController?.present(tabBar, animated: true, completion: nil)
                            //view.present(tabBar, animated: true, completion: nil)
                        }
                        
                    }else{
                        
                        let errorMsg = json["message"].string!
                        print("获取数据失败，:\(errorMsg)")
                        // greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
            }
        }
    }
    
}

func updatesDeviceToken(withDeviceToken deviceToken:String, user userid:String, toBind isToBind:Bool){

    //获取列表
    let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
    let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
    let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
    //定义请求参数
    let params:NSMutableDictionary = NSMutableDictionary()
    params["userid"] = userid
    params["devicetoken"] = deviceToken
    var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
    
    let userinfos = getCurrentUserInfo()
    header["token"] = userinfos.value(forKey: "token") as! String
    
    var requestUrl:String = ""
    if isToBind {
        #if DEBUG
        requestUrl = apiAddresses.value(forKey: "binddevicetokenAPIDebug") as! String
        #else
        requestUrl = apiAddresses.value(forKey: "binddevicetokenAPI") as! String
        #endif
    }else{
        #if DEBUG
        requestUrl = apiAddresses.value(forKey: "unbinddevicetokenAPIDebug") as! String
        #else
        requestUrl = apiAddresses.value(forKey: "unbinddevicetokenAPI") as! String
        #endif
    }
    _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
        (responseObject) in
        switch responseObject.result.isSuccess{
        case true:
            if  let value = responseObject.result.value{
                let json = JSON(value)
                let statusObject = json["code"].int!
                if statusObject == 0{
                    print("绑定成功")
                }else{
                    print("绑定失败，code:\(statusObject)")
                }
            }
        case false:
            print("处理失败")
          //  greyLayerPrompt.show(text: "接受生产失败，请重试")
        }
    }
}


