//
//  GestureVerifyViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class GestureVerifyViewController: UIViewController,UITextFieldDelegate {
    
    var fatherVC = SecuritySettingViewController()
    /// 默认为验证手势
    var isToSetNewGesture:Bool = false
    
    var presentActionType = "presenting" // presentActionType: presenting显示， dismissFromSetting消失
    
    fileprivate var msgLabel:LockLabel?
    
    //导航条
    let navigationBarInResetGestureView:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 27, width: UIScreen.main.bounds.width, height: 45))
    //
    let passwordBox:UITextField = UITextField.init(frame: CGRect(x: 120, y: 328, width: UIScreen.main.bounds.width - 40, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)/// 解锁背景色
        let backView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)

        let nameBannerView:UIView = UIView.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 195))
        nameBannerView.backgroundColor = UIColor.white
        nameBannerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        nameBannerView.layer.shadowOpacity = 0.1
        nameBannerView.layer.shadowColor = UIColor.black.cgColor
        
        view.addSubview(nameBannerView)

        let passwordBannerView:UIView = UIView.init(frame: CGRect(x: 0, y: 323, width: UIScreen.main.bounds.width , height: 50))
        passwordBannerView.backgroundColor = UIColor.white
        passwordBannerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        passwordBannerView.layer.shadowOpacity = 0.1
        passwordBannerView.layer.shadowColor = UIColor.black.cgColor
        view.addSubview(passwordBannerView)
        
        self.title = "验证手势解锁"
        createUserIconInterface()

        passwordBox.delegate = self
        passwordBox.layer.cornerRadius = 5
        passwordBox.backgroundColor = UIColor.white
        passwordBox.isSecureTextEntry = true
        //字体大小
        passwordBox.attributedPlaceholder = NSAttributedString.init(string:"请输入该账号的密码", attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize:13)])
        passwordBox.clearButtonMode = UITextFieldViewMode.always
        passwordBox.keyboardType = UIKeyboardType.alphabet
        passwordBox.returnKeyType = UIReturnKeyType.continue
        let passwordHint:UILabel = UILabel.init(frame: CGRect(x: 25, y: 337, width: 60, height: 22))
        passwordHint.text = "验证密码"
        passwordHint.textAlignment = .center
        passwordHint.font = UIFont.systemFont(ofSize: 14)
        passwordHint.textColor = UIColor.lightGray
        view.addSubview(passwordHint)
        
        view.addSubview(passwordBox)
        
        //下一步按钮
        let verifyPasswordBtn:UIButton = UIButton.init(type: UIButtonType.system)
        verifyPasswordBtn.frame = CGRect(x:45, y:393, width:UIScreen.main.bounds.width - 90, height: 44)
       
        verifyPasswordBtn.layer.borderColor = UIColor.lightGray.cgColor
        verifyPasswordBtn.layer.cornerRadius = 5
        verifyPasswordBtn.layer.borderWidth = 0.5
        verifyPasswordBtn.layer.backgroundColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        verifyPasswordBtn.setTitle("下一步", for: UIControlState.normal)
        verifyPasswordBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControlState.normal)
        verifyPasswordBtn.addTarget(self, action: #selector(nextBtnClicked), for: UIControlEvents.touchUpInside)
        
        view.addSubview(verifyPasswordBtn)
        
        navigationBarInResetGestureView.isHidden = false
        navigationBarInResetGestureView.backgroundColor = UIColor.white
        navigationBarInResetGestureView.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "重置手势密码"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        //let rightButton =
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
       // navItem.setRightBarButton(rightButton, animated: false)
        navItem.setLeftBarButton(leftButton, animated: false)
        
        navigationBarInResetGestureView.pushItem(navItem, animated: false)
        view.addSubview(navigationBarInResetGestureView)
        

        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField)->Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        textField.inputAccessoryView = topView
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       passwordBox.resignFirstResponder()
    }
    //continue按钮的响应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if passwordBox.isFirstResponder {
            nextBtnClicked()
        }
        return true
    }
    //下一步按钮响应
    @objc func nextBtnClicked(){
        if passwordBox.text != "" {
            //验证密码
            let currentUserInfo = getCurrentUserInfo()
            let userPassword = currentUserInfo.value(forKey: "password") as! String
            if passwordBox.text == userPassword{
                let gesture = GestureViewController()
                gesture.type = GestureViewControllerType.resetGesture
                gesture.securityVC = fatherVC
                gesture.verifyGestureVC = self
                gesture.gestureTextBeforeSet = "绘制解锁图案"
                self.present(gesture, animated: true, completion: nil)
            }else{
                greyLayerPrompt.show(text: "密码错误")
            }
        }else{
            greyLayerPrompt.show(text: "请输入密码")
        }
    }
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    func createUserIconInterface(){
        let userNameLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: 230, width: 200, height: 20))
        let userAccountLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 150, y: 255, width: 300, height: 20))
        
        let userInfo = getUserAccountInfo() // 0.userName 1. nikeName
        let userName = userInfo.1
        let userAccount = userInfo.0
        if userName == "_NONE"{
            userNameLabel.text = "用户名不存在"
        }else{
            userNameLabel.text = userName
        }
        var accountID = ""
        userNameLabel.textAlignment = .center
        if userAccount == "_NONE" {
            accountID = "用户账号不存在"
        }else{
            accountID = userAccount
        }
        //let tailIndex = accountID.index(accountID.startIndex, offsetBy: accountID.lengthOfBytes(using: .utf8) - 3)
       //let aheadIndex = accountID.index(accountID.startIndex, offsetBy: 3)
        userAccountLabel.text = accountID//"\(accountID.substring(to:aheadIndex))*****\(accountID.substring(from: tailIndex))"
        userAccountLabel.textAlignment = .center
        userNameLabel.font = UIFont.boldSystemFont(ofSize: 15) //systemFont(ofSize: 15)
        userAccountLabel.font = UIFont.systemFont(ofSize: 15)

        //userAccountID.font = UIFont.systemFont(ofSize: 15)

        
        let iconLocale:CGRect = CGRect(x: UIScreen.main.bounds.width/2 - 75.0/2, y: 120, width: 75.0, height: 75.0)
        let avatar = createIcon(imageSize: 75.0, locale: iconLocale, iconShape: AvatarShape.AvatarShapeTypeRound)
        view.addSubview(avatar)
        view.addSubview(userNameLabel)
        view.addSubview(userAccountLabel)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if presentActionType == "dismissFromSetting" {
            self.dismiss(animated: true, completion: nil)
        }
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

extension GestureVerifyViewController:CircleViewDelegate{
    
    
    func circleViewdidCompleteLoginGesture(_ view: CircleView, type: CircleViewType, gesture: String, result: Bool) {
        
        if type == CircleViewType.circleViewTypeVerify {
            if result {
                print("验证成功")
                
                if isToSetNewGesture {
                    let gesture = GestureViewController()
                    gesture.type = GestureViewControllerType.setting
                    
                    navigationController?.pushViewController(gesture, animated: true)
                    
                } else {
                    navigationController?.popToRootViewController(animated: true)
                }
                
            } else {
                print("密码错误!")
                self.msgLabel?.showWarnMsg(gestureTextGestureVerifyError)
            }
        }
        
    }
    
    func circleViewdidCompleteSetFirstGesture(_ view: CircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewConnectCirclesLessThanNeedWithGesture(_ view: CircleView, type: CircleViewType, gesture: String) {
        
    }
    
    func circleViewdidCompleteSetSecondGesture(_ view: CircleView, type: CircleViewType, gesture: String, result: Bool) {
        
    }
    
}
