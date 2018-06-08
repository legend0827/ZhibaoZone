//
//  WorkZoneViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit
import CoreData
import PagingMenuController
import Photos
import Alamofire
import QCloudCOSXML
import QCloudCore
import AudioToolbox

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //订单子视图
    private let ordersVC = OrdersViewController()
    //任务子视图
    private let TaskVC = TastsViewController()

    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    

    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [ordersVC, TaskVC]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), horizontalPadding: 0, verticalPadding: 0)
        }

    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "订单"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "任务"))
        }
    }
}

class WorkZoneViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
     //系统声音播放
    var isPlaying = false
    var isTheAlertPlayed = false
    
    
    
    //获取消息列表
    var timerForMessageList:Timer!
    var messagesList:[NSDictionary] = []
    var previewsMessagesIDList:[String] = []
    var currentMessagesIDList:[String] = []
    var currentMessagesTypeList:[Int] = []
    var isNeedsAlert = true
    var getMessagesCount = 0
    
    //消息按钮
    let messageBtnLayer:UIView = UIView.init()
    let messageListBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: -5, y: -5, width: 25, height: 25))


    var theChildViewNeedToClose:[UIView] = []
    //var
    let messageListPopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 350)/2, y: UIScreen.main.bounds.height, width: 350, height: 500))
    
    
    //定义毛玻璃灰层
    lazy var grayLayer:UIView = {
        //y= 64表示要显示上方的切换按钮
        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempView.backgroundColor = UIColor.gray
        tempView.alpha = 0.2
        return tempView
    }()
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        if taskDetailTextView.isFirstResponder {
//            return UIStatusBarStyle.lightContent
//        }
//        return UIStatusBarStyle.default
//    }
//    //动画提交
//    override func viewDidAppear(_ animated: Bool) {
//        addSacleAnimation(animatedView: messageBtnLayer)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
       
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 15 //64
        pagingMenuController.view.frame.size.height -= 15
        
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)
        
        
        //var tempOrderVC = OrdersViewController()
        let tempOrderVC = options.pagingControllers[0] as! OrdersViewController
        //tempOrderVC.workZoneVCObject = self
        
        let circleViewBtn = UIButton.init(type: UIButtonType.custom)

        //iPhone X设备处理
        if UIDevice.current.isX(){
            circleViewBtn.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 155 , width: 60, height: 60)
            messageListBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 215 , width: 50, height: 50)
            messageBtnLayer.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 220 , width: 60, height: 60)
        }else{
            circleViewBtn.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 120 , width: 60, height: 60)
            messageListBtn.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 180 , width: 50, height: 50)
            messageBtnLayer.frame = CGRect(x: UIScreen.main.bounds.width - 85, y: UIScreen.main.bounds.height - 185 , width: 60, height: 60)
        }
 
        
        
        messageBtnLayer.backgroundColor = UIColor.white// #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        messageBtnLayer.layer.cornerRadius = 30
        messageBtnLayer.layer.shadowOffset = CGSize(width: 2, height: 2)
        messageBtnLayer.layer.shadowOpacity = 0.8
        messageBtnLayer.layer.shadowColor = UIColor.black.cgColor
        
        messageListBtn.backgroundColor = UIColor.white
        messageListBtn.layer.cornerRadius = 25

        messageListBtn.addTarget(self, action: #selector(messageListBtnClicked), for: UIControlEvents.touchUpInside)
        //用户名输入框左侧图标
        let msgListImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        msgListImg.image = UIImage(named:"messagelisticon")
        //let plusImg:UIImage = UIImage.init(named: "plus-white")!
        self.view.addSubview(messageBtnLayer)
        self.view.addSubview(messageListBtn)
        //messageBtnLayer.addSubview(messageListBtn)
        messageListBtn.addSubview(msgListImg)
        
        messageCountLabel.backgroundColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        messageCountLabel.layer.cornerRadius = 12.5
        messageCountLabel.text = "\(messagesList.count)"
        messageCountLabel.textColor = UIColor.white
        messageCountLabel.textAlignment = .center
        messageCountLabel.clipsToBounds = true // 对Label切角度
        
        messageListBtn.addSubview(messageCountLabel)
        
        if messagesList.count == 0{
            messageBtnLayer.isHidden = true
            messageListBtn.isHidden = true
        }else{
            messageBtnLayer.isHidden = false
            messageListBtn.isHidden = false
        }
//        newTaskTableView.keyboardDismissMode = .interactive
//        orderIDTextField.keyboardType = .numberPad
}
//    //消息列表动画
//    private func addSacleAnimation(animatedView:UIView){
//
//        DispatchQueue.global(qos: .background).sync {
//            animatedView.layer.removeAllAnimations()
//            let animate = CABasicAnimation(keyPath: "transform.scale")
//            animate.fromValue = 1
//            animate.toValue = 0.9
//            animate.repeatCount = HUGE
//            animate.duration = 1
//            animate.autoreverses = true
//            animate.isRemovedOnCompletion = true //动画播放不停止
//            animatedView.layer.add(animate, forKey: nil)
//        }
//    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func messageListBtnClicked(){
       let messageListVC = MessageListViewController()
        messageListVC.messagesList = messagesList
        messageListVC.workZoneVC = self
        messageListVC.getMessagesCount = getMessagesCount
        
        self.present(messageListVC, animated: true, completion: nil)
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
