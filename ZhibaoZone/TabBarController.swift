//
//  TabBarController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AVFoundation
import AudioToolbox

class TabBarController: UITabBarController {
    var _roleType = 0
    let redDot:UIView = UIView.init(frame: CGRect(x: 25, y:15, width: 12, height: 12))
    
    //初始化
    init(roleType:Int,hasManager:Bool,hasWorkZone:Bool,hasStatistic:Bool){
        super.init(nibName: nil, bundle: nil)
        
        _roleType = roleType

        let orderVC = OrdersViewController()
        let meVC = MeViewController()
        let normalUserVC = normalUserViewController()
        let quotepriceVC = QuotePriceViewController()
        let enterpriseVC = SystemManagementViewController()
        let emplyerVC = EmplpyerDailyUpdateViewController()
        let statisticVC = StatisticSummaryViewController()
        orderVC._tabBarVC = self
        enterpriseVC._tabBarVC = self
        
        let item1PositonX = kWidth/6 + 5
        redDot.frame = CGRect(x:item1PositonX + 30 , y: tabBar.frame.minY + 3 - heightChangeForiPhoneXFromBottom, width: 12, height: 12)
        
        let myLayer = CALayer()
        myLayer.bounds = CGRect.init(x: 0, y: 0, width: 12, height: 12)
        //设置层的位置
        myLayer.position = CGPoint.init(x: 6, y: 6)
        //这里用的是UIImage的CGImage属性，是一种CGImageRef类型的数据
        myLayer.contents = UIImage.init(named: "reddoticon")?.cgImage
        myLayer.cornerRadius  = 6
        myLayer.masksToBounds = true
        redDot.layer.addSublayer(myLayer)

        redDot.layer.cornerRadius  = 6
        redDot.layer.borderColor = UIColor.backgroundColors(color: .white).cgColor
        redDot.layer.borderWidth = 1
        redDot.layer.masksToBounds = true
        redDot.isHidden = true
       
        
        orderVC.tabBarItem.image = UIImage(named: "ordersicon")
        orderVC.tabBarItem.selectedImage = UIImage(named: "ordersiconselected")
        orderVC.tabBarItem.title = "订单"

        
        meVC.tabBarItem.image = UIImage(named:"accounticon")
        meVC.tabBarItem.selectedImage = UIImage(named: "accounticon-selected")
        meVC.tabBarItem.title = "我的"
        
        normalUserVC.tabBarItem.image = UIImage(named:"homeicon")
        normalUserVC.tabBarItem.selectedImage = UIImage(named: "homeicon-selected")
        normalUserVC.tabBarItem.title = "首页"
        
        quotepriceVC.tabBarItem.selectedImage = UIImage(named: "quotepriceiconselected")
        quotepriceVC.tabBarItem.image = UIImage(named: "quotepriceicon")
        quotepriceVC.tabBarItem.title = "估价"
        
        enterpriseVC.tabBarItem.image = UIImage(named: "managericon")
        enterpriseVC.tabBarItem.selectedImage = UIImage(named: "managericon-selected")
        enterpriseVC.tabBarItem.title = "管理"

        emplyerVC.tabBarItem.image = UIImage(named:"homeicon")
        emplyerVC.tabBarItem.selectedImage = UIImage(named: "homeicon-selected")
        emplyerVC.tabBarItem.title = "首页"

        statisticVC.tabBarItem.image = UIImage(named: "managericon")
        statisticVC.tabBarItem.selectedImage = UIImage(named: "managericon-selected")
        statisticVC.tabBarItem.title = "统计"
        
        switch _roleType {
        case 0:
            //"普通用户"
            self.viewControllers = [emplyerVC,meVC]
        case 3,4,9:
            //3: "企业管理员"。4://"管理员" 9: 业务经理
            if hasWorkZone {
                //企业管理员有订单管理权限
                if hasStatistic {
                    //统计权限
                    self.viewControllers = [statisticVC,orderVC,enterpriseVC,meVC]
                }else{
                    self.viewControllers = [orderVC,enterpriseVC,meVC]
                }
            }else{
                self.viewControllers = [enterpriseVC,meVC]
            }
        case 6:
            // "客服"
            if hasManager {
                //拥有管理员权限的客服
                self.viewControllers = [enterpriseVC,meVC]
            }else{
                self.viewControllers = [emplyerVC,meVC]
            }
        case 7,8:
            // 7:"方案师" 8:供应商
            if hasManager {
                self.viewControllers = [orderVC,enterpriseVC,meVC]
            }else{
                self.viewControllers = [orderVC,meVC]
            }
        default:
            // "普通用户"
            self.viewControllers = [emplyerVC,meVC]
        }
        
        self.tabBar.tintColor = UIColor.iconColors(color: .red)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(redDot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        redDot.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
