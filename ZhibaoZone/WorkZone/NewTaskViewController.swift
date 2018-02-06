//
//  NewTaskViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 07/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //灰层
        //self.view.frame = CGRect(x: 50, y: 50, width: UIScreen.main.bounds.width-10, height: UIScreen.main.bounds.height-200)
        self.view.backgroundColor = UIColor.clear
        view.isOpaque = false
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
