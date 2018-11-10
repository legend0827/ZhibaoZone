//
//  RechargeAgreementViewController.swift
//  PetsShow
//
//  Created by Kevin on 2018/6/20.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class PrivacyPolicyAgreementViewController: UIViewController {
    let scrollView:UIScrollView = UIScrollView.init()
    let agreementArticle:UIImageView = UIImageView.init()
  //  var loginVC = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarHiden(toHidden: false, ViewController: self)
        setStatusBarBackgroundColor(color: .backgroundColors(color: .purple))
        self.view.backgroundColor = UIColor.backgroundColors(color: .purple)// UIColor.backgroundColors(color: .)
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:19 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .purple)
        navBar.barTintColor = UIColor.backgroundColors(color: .purple)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "隐私协议"
        titleLabel.textColor = UIColor.titleColors(color: .white)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .white)
        
        //去除导航栏下方的横线
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        //4817/2275
        agreementArticle.frame = CGRect(x: 0, y: 0, width: kWidth, height: 1977/414 * kWidth)
        agreementArticle.image = UIImage(named: "agreementArticleimg-zh")
        scrollView.frame = CGRect(x: 0, y: 66 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 66 - heightChangeForiPhoneXFromTop)
        scrollView.contentSize = CGSize(width: kWidth, height: 1977/414 * kWidth)
        scrollView.addSubview(agreementArticle)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
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
