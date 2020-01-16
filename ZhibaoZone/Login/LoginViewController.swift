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

    override func viewDidLoad() {
        super.viewDidLoad()

        let myView = DemoView.newInstance() // Bundle.main.loadNibNamed("DemoView", owner: nil, options: nil)?.first as? DemoView
        
        myView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-50, height: self.view.frame.height-140)
        myView?.center = self.view.center
        
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

}
