//
//  OrdersViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 03/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreData
import PagingMenuController

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //全部订单子视图
    private let allOrdersVC = AllOrdersViewController()
    //待报价子视图
    private let notQuoteYetVC = NotQuoteYetViewController()
    //已报价子视图
    private let quoteAlreadyVC = QuoteAlreadyViewController()
    //待接受生产子视图
    private let waitForProduceVC = WaitForAccpetProduceViewController()
    //生产中子视图
    private let producingVC = ProducingViewController()
    
    var backgroundColor: UIColor = UIColor.backgroundColors(color: .white) // 设置菜单栏底色

    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [allOrdersVC,notQuoteYetVC,quoteAlreadyVC,waitForProduceVC,producingVC]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(),MenuItem3(),MenuItem4(),MenuItem5()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 0, verticalPadding: 0)
        }
        
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            //return .text(title: MenuItemText(text: "全部"))
            return .text(title: MenuItemText(text: "全部", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "未报价", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第3个菜单项
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已报价", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第4个菜单项
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第5个菜单项
    fileprivate struct MenuItem5: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待发货", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
}

class OrdersViewController:UIViewController,UITextFieldDelegate {
    var _roleType = 1
    
    //标题栏背景
    let titleBarView:UIView = UIView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
    //扫描二维码按钮
    let scanQRCodeBtn:UIButton = UIButton.init(type: .custom)
    //订单列表的搜素栏
    //let searchBarInOrders:UISearchBar = UISearchBar.init(frame: CGRect(x: 52, y: 5, width:kWidth - 104, height: 28))
    let searchBarInOrders:UIView = UIView.init(frame: CGRect(x: 52, y: 8, width:kWidth - 104, height: 28))
    //消息按钮
    let messageListBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置状态栏颜色
        setStatusBarBackgroundColor(color: .titleColors(color: .red))
        
        /// 菜单栏配置
        
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 28 //(4 + heightChangeForiPhoneXFromTop)*3
        pagingMenuController.view.frame.size.height -= 5

        if UIDevice.current.isX(){
            heightChangeForiPhoneXFromTop = 24.0
            pagingMenuController.view.frame.origin.y += 56
        }else{
            heightChangeForiPhoneXFromTop = 0.0
            pagingMenuController.view.frame.origin.y += 32//5
        }
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)

        titleBarView.frame = CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44)
        scanQRCodeBtn.frame = CGRect(x: 20, y: 11, width: 22, height: 22)
        messageListBtn.frame = CGRect(x: kWidth - 42, y: 11, width: 22, height: 22)
        searchBarInOrders.frame = CGRect(x: 52, y: 8, width:kWidth - 104, height: 28)
        //为搜索框添加点击事件
        let gestureRecognizerOfSearach = UITapGestureRecognizer(target: self, action:#selector(searchBarTaped))
        titleBarView.addGestureRecognizer(gestureRecognizerOfSearach)
        
        //顶部titlebar显示
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red) // 红色主色调
        
        //设置扫描二维码按钮样式
        scanQRCodeBtn.addTarget(self, action: #selector(scanQRCodeBtnClicked), for: UIControlEvents.touchUpInside)
        let qrcodeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        qrcodeImg.image =  UIImage(named:"scanqrcodeicon")//  UIImage(named:"messagelisticon")
        self.view.addSubview(scanQRCodeBtn)
        scanQRCodeBtn.addSubview(qrcodeImg)
        
        //设置消息按钮样式和响应
        messageListBtn.addTarget(self, action: #selector(messageListBtnClicked), for: UIControlEvents.touchUpInside)
        let msgListImg = UIImageView(frame: CGRect(x: 0, y: 3, width: 22, height: 18))
        msgListImg.image =  UIImage(named:"messagelisticon")
        self.view.addSubview(messageListBtn)
        messageListBtn.addSubview(msgListImg)
        
        //设置搜索栏
        searchBarInOrders.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0)
        searchBarInOrders.layer.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0).cgColor
        searchBarInOrders.layer.cornerRadius = 6
        let searchBarHintText:UILabel = UILabel.init(frame: CGRect(x: searchBarInOrders.frame.width/2 - 50, y: 0, width: 100, height: 28))
        searchBarHintText.text = "搜索订单号"
        searchBarHintText.textAlignment = .center
        searchBarHintText.textColor = UIColor.titleColors(color: .white)
        searchBarHintText.font = UIFont.systemFont(ofSize: 14)
        let searchIconImg = UIImageView(frame: CGRect(x: searchBarInOrders.frame.width/2 - 55, y: 7, width: 14, height: 14))
        searchIconImg.image =  UIImage(named:"searchicon")
        searchBarInOrders.addSubview(searchIconImg)
        searchBarInOrders.addSubview(searchBarHintText)

        self.view.addSubview(titleBarView)
        titleBarView.addSubview(scanQRCodeBtn)
        titleBarView.addSubview(searchBarInOrders)
        titleBarView.addSubview(messageListBtn)
        
        
    }
    
    @objc func searchBarTaped(){
        print("点击了搜索区域")
        
        setStatusBarBackgroundColor(color: .clear)
        titleBarView.backgroundColor = UIColor.clear
        searchBarInOrders.backgroundColor = UIColor.clear
        
        if _roleType == 1{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidAndWangWangID)
            self.present(searchOrderVC, animated: true, completion: nil)
        }else{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidOnly)
            self.present(searchOrderVC, animated: true, completion: nil)
        }
    }
    @objc func scanQRCodeBtnClicked(){
        print("扫描二维码按钮点击了")
    }
    @objc func messageListBtnClicked(){
        print("消息列表按钮点击了")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        setStatusBarBackgroundColor(color: .clear)
//        titleBarView.backgroundColor = UIColor.clear
//        searchBarInOrders.backgroundColor = UIColor.clear
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.titleColors(color: .red))
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red)
        searchBarInOrders.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0)
        
        //self.view.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        let userinfos = getCurrentUserInfo()
        _roleType = Int(userinfos.value(forKey: "roletype") as! String)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

func getQuotePriceWeight() -> Int{
    var Weight = 1
    //从datacore获取用户数据
    //获取管理的数据上下文，对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<ParameterSettings>(entityName:"ParameterSettings")

    fetchRequest.returnsObjectsAsFaults = false
    
    // 设置查询条件
    let predicate = NSPredicate(format: "id = '1'")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
        
        //遍历查询结果
        for info in fetchedObjects{
            //更新数据
            //设置获取全部订单参数组
            Weight = Int(info.quotePriceWeight)
            
        }
    } catch  {
        fatalError("获取失败")
    }
    return Weight
}

func getMsgVoiceAlertFrequencyWeight() -> Int{
    var Weight = 1
    //从datacore获取用户数据
    //获取管理的数据上下文，对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<ParameterSettings>(entityName:"ParameterSettings")
    
    fetchRequest.returnsObjectsAsFaults = false
    
    // 设置查询条件
    let predicate = NSPredicate(format: "id = '1'")
    fetchRequest.predicate = predicate
    
    //查询操作
    do {
        let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
        
        //遍历查询结果
        for info in fetchedObjects{
            //更新数据
            //设置获取全部订单参数组
            Weight = Int(info.msgVoiceAlertFrequencyWeight)
            
        }
    } catch  {
        fatalError("获取失败")
    }
    return Weight
}
