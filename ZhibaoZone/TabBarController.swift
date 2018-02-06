//
//  TabBarController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workZoneVC = WorkZoneViewController()
        let meVC = MeViewController()

        workZoneVC.tabBarItem.image = UIImage(named:"workzoneicon")
        meVC.tabBarItem.image = UIImage(named:"accounticon")


        workZoneVC.tabBarItem.title = "工作台"
        meVC.tabBarItem.title = "我的"

        self.viewControllers = [workZoneVC,meVC]
        self.tabBar.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
//
        
        // Do any additional setup after loading the view.
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
