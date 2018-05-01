//
//  TastsViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 03/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import PagingMenuController

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    
    //待处理任务视图
    private let waitForHandleTaskListVC = waitForHandleTaskListViewController()
    //我的发布任务视图
    private let mineCreationTaskListVC = MineCreationTaskListViewController()
    //已完成子视图
    private let finishedTaskListVC = FinishedTaskListViewController()
    
    var backgroundColor: UIColor = UIColor.backgroundColors(color: .white) // 设置菜单栏底色
    
    //组件类型
    fileprivate var componentType: ComponentType{
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [waitForHandleTaskListVC,mineCreationTaskListVC,finishedTaskListVC]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(),MenuItem3()]
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
            return .text(title: MenuItemText(text: "待处理", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "我的发布", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    
    //第3个菜单项
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已完成", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
   
}

class TastsViewController: UIViewController { // UIViewController

    
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
        
        let titleBarView:UIView = UIView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
        let titleBarTitle:UILabel = UILabel.init(frame: CGRect(x: kWidth/2 - 86, y: 10, width: 172, height: 25))
        let createNewTaskBtn:UIButton = UIButton.init(type: .custom)
        
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red) // 红色主色调
        titleBarTitle.textColor = UIColor.titleColors(color: .white)
        titleBarTitle.textAlignment = .center
        titleBarTitle.font = UIFont.systemFont(ofSize: 18)
        titleBarTitle.text = "任务列表"
        
        createNewTaskBtn.frame = CGRect(x: kWidth - 67, y: 10, width: 62, height: 22)
        createNewTaskBtn.setTitle("新建", for: .normal)
        createNewTaskBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createNewTaskBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        createNewTaskBtn.setTitleColor(UIColor.clear, for: .highlighted) // .hightlighted 。 点击后离开的效果
        createNewTaskBtn.titleLabel?.textAlignment = .right
        createNewTaskBtn.addTarget(self, action: #selector(createNewtaskBtnClicked), for: .touchUpInside)
        
        self.view.addSubview(titleBarView)
        titleBarView.addSubview(titleBarTitle)
        titleBarView.addSubview(createNewTaskBtn)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //设置状态栏颜色
        setStatusBarBackgroundColor(color: .titleColors(color: .red))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func createNewtaskBtnClicked(){
        print("新建订单按钮点击了")
        let newTaskViewVC = NewTaskViewController()
        //设置跳转带navigation controller的跳转
        let nav = UINavigationController(rootViewController: newTaskViewVC)
        self.present(nav, animated: true, completion: nil)
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
