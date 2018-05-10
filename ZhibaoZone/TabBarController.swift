//
//  TabBarController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
			
class TabBarController: UITabBarController {
    var _roleType = 0

    //初始化
    init(royeType:Int){
        super.init(nibName: nil, bundle: nil)
        
        _roleType = royeType

        //let workZoneVC = WorkZoneViewController()
        let orderVC = OrdersViewController()
        let taskVC = TastsViewController()
        let meVC = MeViewController()
        let normalUserVC = normalUserViewController()
        
        orderVC.tabBarItem.image = UIImage(named: "ordersicon")
        orderVC.tabBarItem.selectedImage = UIImage(named: "ordersiconselected")
        taskVC.tabBarItem.image = UIImage(named: "tasksicon")
        taskVC.tabBarItem.selectedImage = UIImage(named: "tasksiconselected")
        meVC.tabBarItem.image = UIImage(named:"accounticon")
        meVC.tabBarItem.selectedImage = UIImage(named: "accounticonselected")
        normalUserVC.tabBarItem.image = UIImage(named:"homeicon")
        
        orderVC.tabBarItem.title = "订单"
        taskVC.tabBarItem.title = "任务"
        meVC.tabBarItem.title = "我的"
        normalUserVC.tabBarItem.title = "首页"
        
        if _roleType == 0{
            self.viewControllers = [normalUserVC,meVC]
        }else{
            self.viewControllers = [orderVC,taskVC,meVC]
        }
        self.tabBar.tintColor = UIColor.iconColors(color: .red)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
    
    func createNewTask(){
       // self.view.backgroundColor = UIColor.green
        let tempView:UIView = UIView.init(frame: CGRect(x: 0, y: 20, width: kWidth, height: kHight))
        tempView.backgroundColor = UIColor.green
        self.view.addSubview(tempView)
        
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
