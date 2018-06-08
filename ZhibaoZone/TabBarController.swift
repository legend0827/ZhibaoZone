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
    init(royeType:Int){
        super.init(nibName: nil, bundle: nil)
        
        _roleType = royeType

        //let workZoneVC = WorkZoneViewController()
//        lazy var orderVC:OrdersViewController = {
//            return OrdersViewController()
//        }()
        let orderVC = OrdersViewController()
        let taskVC = TastsViewController()
        let meVC = MeViewController()
        let normalUserVC = normalUserViewController()
        let quotepriceVC = QuotePriceViewController()
        
        orderVC._tabBarVC = self
        
        let item1PositonX = kWidth/6 + 5
        redDot.frame = CGRect(x:item1PositonX , y: tabBar.frame.minY + 3 - heightChangeForiPhoneXFromBottom, width: 12, height: 12)
        
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
        taskVC.tabBarItem.image = UIImage(named: "tasksicon")
        taskVC.tabBarItem.selectedImage = UIImage(named: "tasksiconselected")
        meVC.tabBarItem.image = UIImage(named:"accounticon")
        meVC.tabBarItem.selectedImage = UIImage(named: "accounticonselected")
        normalUserVC.tabBarItem.image = UIImage(named:"homeicon")
        quotepriceVC.tabBarItem.selectedImage = UIImage(named: "quotepriceiconselected")
        quotepriceVC.tabBarItem.image = UIImage(named: "quotepriceicon")
        
        orderVC.tabBarItem.title = "订单"
        taskVC.tabBarItem.title = "任务"
        meVC.tabBarItem.title = "我的"
        quotepriceVC.tabBarItem.title = "估价"
        normalUserVC.tabBarItem.title = "首页"
        
        if _roleType == 0{
            self.viewControllers = [normalUserVC,meVC]
        }else if _roleType == 2 || _roleType == 3{
            self.viewControllers = [orderVC,taskVC,meVC]
        }else{
            self.viewControllers = [quotepriceVC,taskVC,meVC]
        }
        self.tabBar.tintColor = UIColor.iconColors(color: .red)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(redDot)
      //  getMessageList()
       // tabBar.bringSubview(toFront: redDot)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        redDot.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
