//
//  RegisterView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2020/1/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class RegisterView: UIView {

    @IBOutlet weak var PwdIcon: UIImageView!
    @IBOutlet weak var RepeatPwdIcon: UIImageView!
    @IBOutlet weak var PwdSepeatorLine: UIImageView!
    @IBOutlet weak var RepeatPwdSepeatorLine: UIImageView!
    @IBOutlet weak var PwdTextField: UITextField!
    @IBOutlet weak var RepeatPwdTextField: UITextField!
    //登陆页面代理
    lazy var demoViewDelegate = DemoView()
    
    @IBAction func BackToLoginClicked(_ sender: Any) {
        self.removeFromSuperview()
        demoViewDelegate.backToLogin()
        demoViewDelegate.isRegisterModel = false
    }
    @IBAction func ReturnButtonClicked(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func ConfiirmRegisterClicked(_ sender: Any) {
        
    }
    
    //输入框选中和离框效果
    @IBAction func PwdFieldFocus(_ sender: Any) {
        PwdIcon.isHighlighted = true
        PwdSepeatorLine.isHighlighted = true
    }
    @IBAction func PwdFieldDissSelected(_ sender: Any) {
        PwdIcon.isHighlighted = false
        PwdSepeatorLine.isHighlighted = false
    }
    @IBAction func RepeatPwdFieldFocus(_ sender: Any) {
        RepeatPwdIcon.isHighlighted = true
        RepeatPwdSepeatorLine.isHighlighted = true
    }
    @IBAction func RepeatPwdFieldDissSelected(_ sender: Any) {
        RepeatPwdIcon.isHighlighted = false
        RepeatPwdSepeatorLine.isHighlighted = false
    }
    
}
