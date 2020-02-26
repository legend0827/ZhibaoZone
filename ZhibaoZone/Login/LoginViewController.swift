//
//  LoginViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2020/1/13.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var loginView = DemoView()
    //取消下次自动登录
    var isAutoLoginEnabled:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let myView = DemoView.newInstance()
        
        myView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 50, height: self.view.frame.height-340)
        let positionOfView = CGPoint(x: self.view.center.x, y: self.view.center.y - 140)
        myView?.center = positionOfView
        //myView?.center = self.view.center
        
        if myView != nil {
            self.view.addSubview(myView!)
        }
        let privatePolicyBtn:UIButton = UIButton.init(type: .system)
        
        privatePolicyBtn.setTitle("查看隐私政策", for: .normal)
        privatePolicyBtn.frame = CGRect(x: 20, y: kHight - 80 - heightChangeForiPhoneXFromBottom, width: kWidth - 40, height: 17)
        privatePolicyBtn.contentVerticalAlignment = .center
        privatePolicyBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        //privatePolicyBtn.titleLabel?.font =
        privatePolicyBtn.addTarget(self, action: #selector(privatepolicybtnClicked), for: .touchUpInside)
        self.view.addSubview(privatePolicyBtn)
        // Do any additional setup after loading the view.
    }

    @objc func privatepolicybtnClicked(){
        let privacyVC = PrivacyPolicyAgreementViewController()
        self.present(privacyVC, animated: true, completion: nil)
    }

    
    func checkAddtionalAccountOrAutoLogin(){
        //检查是否已经登录过账号
        let dataOperator = CoreDataOperation()
        let isAccountAvailable = dataOperator.checkAccountAvaiable(forAddtional: false) // 检查附属账号是否可用
        
        if isAccountAvailable && isAutoLoginEnabled {
            isAutoLoginEnabled = true //下次自动登录
            let userinfo = getCurrentUserInfo()
            let username = userinfo.value(forKey: "username") as! String
            let password = userinfo.value(forKey: "password") as! String
            
            let hub = pleaseWait()
            let loginUser = User()
            loginUser.Login(username: username, password: password,view:self,hub:hub)
        }
    }
}
