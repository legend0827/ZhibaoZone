//
//  GetOrders.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class Popup: NSObject {
    
//    //获取列表的页数
//    var _requstPages:Int
//    
//    //源VC = 0
//    var _sourceVC:UIViewController
//    
//    //分类类型
//    var _categoryType:orderListCategoryType
//    
//    //角色ID
//    var _roleType:Int
////
//    override init() {
//        //super.init()
//        //获取列表的页数
//        _requstPages = 1
//
//        //源VC
//         _sourceVC = AllOrdersViewController()
//
//        //分类类型
//        _categoryType = .allOrderCategory
//
//        //角色ID
//        _roleType = 3
//    }
    
    //订单数
    var orderCount = 0
    
    var totalPageCount = 1
    var orderArray:[NSDictionary] = []
    
    /////
    //订单相关数据获取
    ////
    
//
//
//    //获取订单详情数据
//   class func getOrderDetails(OrderID:String,CustomID:String){
//        let userAccountInfo = getCurrentUserInfo()
//        let userID = userAccountInfo.value(forKey: "userid")
//        let token = userAccountInfo.value(forKey: "token")
//        let roletype = userAccountInfo.value(forKey: "roletype") as? String
//
//        //获取列表
//        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
//        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
//        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
//        #if DEBUG
//        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetailsDebug") as! String
//        #else
//        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetails") as! String
//        #endif
//        //定义请求参数
//        let params:NSMutableDictionary = NSMutableDictionary()
//        params["userId"] =  userID
//        params["orderId"] =  OrderID
//        params["customId"] =  CustomID
//        params["roletype"] = roletype
//        params["token"] = token
//
//        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
//            (responseObject) in
//            switch responseObject.result.isSuccess{
//            case true:
//                if  let value = responseObject.result.value{
//                    let json = JSON(value)
//                    self.orderDetail.removeAll()
//
//                    let userinfoItem = json["userinfo"].dictionaryObject! as NSDictionary
//                    let orderaddinfoItem = json["orderaddinfo"].dictionaryObject! as NSDictionary
//                    let ordersummaryItem = json["ordersummary"].dictionaryObject! as NSDictionary
//                    let nicknameItem = json["nickname"].dictionaryObject! as NSDictionary
//                    let useraddressItem = json["useraddress"].dictionaryObject! as NSDictionary
//                    let designinfoItem = json["designinfo"].dictionaryObject! as NSDictionary
//                    self.orderDetail.append(userinfoItem)
//                    self.orderDetail.append(orderaddinfoItem)
//                    self.orderDetail.append(ordersummaryItem)
//                    self.orderDetail.append(nicknameItem)
//                    self.orderDetail.append(useraddressItem)
//                    self.orderDetail.append(designinfoItem)
//
//                    print("get order detail successed")
//                }
//                self.isOrderDetailsGets = true
//            case false:
//                print("get order detail failed")
//                self.isOrderDetailsGets = true
//            }
//        }
//    }
}
