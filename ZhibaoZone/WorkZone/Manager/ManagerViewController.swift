//
//  ManagerViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import PagingMenuController

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //角色
    var managerVC = TabBarController(royeType: 4)
    
    //转接生产单
    private let switchProduceOrderVC = SwitchOrderViewController(with: switchOrderType.producingOrder)
    //转接设计单
    private let switchDesignOrderVC = SwitchOrderViewController(with: switchOrderType.designingOrder)
    
    var backgroundColor: UIColor = UIColor.backgroundColors(color: .white) // 设置菜单栏底色
    
    //lazy loading页面数量
    var lazyLoadingPage: LazyLoadingPage = .three
    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        switchDesignOrderVC.managerVCObject = managerVC
        switchProduceOrderVC.managerVCObject = managerVC
        return [switchProduceOrderVC,switchDesignOrderVC]
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
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 45, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
        }
        
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            //return .text(title: MenuItemText(text: "全部"))
            return .text(title: MenuItemText(text: "生产单管理", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "设计单管理", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
}

class ManagerViewController: UIViewController {

    lazy var _tabBarVC = TabBarController(royeType: 4)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.barTintColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "转接订单"
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        
        //添加左侧
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        
        //分页菜单配置
        var options = PagingMenuOptions()
        options.managerVC = _tabBarVC
        
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
        //print("分页显示出来了")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
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
