//
//  PopUpsPortialViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/18.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class PopUpsPortialViewController: UIViewController {
 //   var appDelegate:AppDelegate?
    //定义毛玻璃灰层
    lazy var grayLayer:UIView = {
        //y= 64表示要显示上方的切换按钮
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.4
        return tempView
    }()
    
//    init(with appdelegate:AppDelegate){
//        super.init(nibName: nil, bundle: nil)
//        appDelegate = appdelegate
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置横屏
     //   appDelegate!.blockRotation = true
        UIApplication.shared.isStatusBarHidden = true
        self.view.backgroundColor = .clear
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //设置横屏
      //  let value = UIInterfaceOrientation.landscapeRight.rawValue
      //  UIDevice.current.setValue(value, forKey: "orientation")
        UIApplication.shared.isStatusBarHidden = true
        setStatusBarBackgroundColor(color: .clear)
        setStatusBarHiden(toHidden: true, ViewController: self)
        
    }

}
