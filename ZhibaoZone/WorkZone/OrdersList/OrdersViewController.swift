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
import Photos
import Alamofire
import QCloudCOSXML
import QCloudCore
import AudioToolbox
import AVFoundation

private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //角色
    var roleTypeForController = 1
    //全部订单子视图
    private let allOrdersVC = AllOrdersViewController(orderlistTye: orderListCategoryType.allOrderCategory)
    //待报价子视图
    private let notQuoteYetVC = AllOrdersViewController(orderlistTye: orderListCategoryType.notQuotePriceYetOrderCategory)
    //已报价子视图
    private let quoteAlreadyVC = AllOrdersViewController(orderlistTye: orderListCategoryType.alreadyQuotedOderCategory)
    //待接受生产子视图
    private let waitForProduceVC = AllOrdersViewController(orderlistTye: orderListCategoryType.waitForAcceptProduceOrderCategory)
    //生产中子视图
    private let producingVC = AllOrdersViewController(orderlistTye: orderListCategoryType.producingOrderCategory)

    ///// 设计师
    //待接单
    private let waitForDesignVC = AllOrdersViewController(orderlistTye: orderListCategoryType.waitForDesignCategory)
    //待修改
    private let waitForModifyVC = AllOrdersViewController(orderlistTye: orderListCategoryType.waitForModifyCategory)
    //已定稿
    private let DesignConfirmedVC = AllOrdersViewController(orderlistTye: orderListCategoryType.DesigningCategory)
    
    var backgroundColor: UIColor = UIColor.backgroundColors(color: .white) // 设置菜单栏底色

    //lazy loading页面数量
    var lazyLoadingPage: LazyLoadingPage = .three
    //组件类型
    fileprivate var componentType: ComponentType{
        switch roleTypeForController {
        case 1:
            return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        case 2:
            return .all(menuOptions: MenuOptionsForDesign(), pagingControllers: pagingControllersForDesign)
        case 3:
            return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        case 4:
            return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        default:
            print("nothing")
        }
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllersForDesign: [UIViewController] {
        return [waitForDesignVC,waitForModifyVC,DesignConfirmedVC]
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
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 12, verticalPadding: 5) // 水平间距 0 ，垂直间距 0 
        }
        
    }
    
    //菜单配置项 - 设计
    fileprivate struct MenuOptionsForDesign: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem6(), MenuItem7(),MenuItem8()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 12, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
        }
        
    }
    //菜单配置项 - 经理
    fileprivate struct MenuOptionsForManager: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem6(), MenuItem7(),MenuItem8()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 2, color: UIColor.titleColors(color: .red), horizontalPadding: 12, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
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
    //第6个菜单项
    fileprivate struct MenuItem6: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第7个菜单项
    fileprivate struct MenuItem7: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待修改", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第8个菜单项
    fileprivate struct MenuItem8: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "设计中", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第9个菜单项
    fileprivate struct MenuItem9: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "咨询中", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
    //第10个菜单项
    fileprivate struct MenuItem10: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待支付", color: UIColor.titleColors(color: .black), selectedColor: UIColor.titleColors(color: .red), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.systemFont(ofSize: 16)))
        }
    }
}

class OrdersViewController:UIViewController,UITextFieldDelegate,UIScrollViewDelegate{
    
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
    lazy var _tabBarVC: TabBarController = {
        return TabBarController(royeType: 1)
    }()
    
//    let CELL_ID = "cell_id";
//
//    lazy var StatisticCollectionView:UICollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width:(kWidth - 50)/2,height: (kWidth - 50)/2 + 92)  //设置item尺寸
//        layout.minimumLineSpacing = 5  //上下间隔
//        layout.minimumInteritemSpacing = 5 //左右间隔
//        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)            //section四周的缩进
//        layout.scrollDirection = UICollectionViewScrollDirection.vertical  //滚动方向
//
//        let tempCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - 160 - heightChangeForiPhoneXFromBottom ),collectionViewLayout:layout) //
//        tempCollectionView.backgroundColor = UIColor.backgroundColors(color: .white)
//        tempCollectionView.delegate = self
//        tempCollectionView.dataSource = self
//        tempCollectionView.isScrollEnabled = true // 允许拖动
//        tempCollectionView.register(StatisticCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
//        // 注册一个headView
//        tempCollectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
//        return tempCollectionView
//    }()
//    //跟视图
//    var _tabBarVC = TabBarController(royeType: 1)
    
    //消息数目
    let messageCountBackLabel:UIView = UIView.init(frame: CGRect(x: 50, y: -5, width: 22, height: 16))
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 22, height: 16))
    
    //用户角色
    var _roleType = 1
    lazy var scrollBackView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempScrollView.contentSize = CGSize(width: kWidth, height: 667)
        //backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height )
        tempScrollView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempScrollView.delegate = self
        //tempScrollView.delegate = self
        tempScrollView.isDirectionalLockEnabled = true
        tempScrollView.isScrollEnabled = true
        tempScrollView.showsHorizontalScrollIndicator = false
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.setContentOffset(CGPoint(x: 0, y: 20),animated: true)// (10, 20), animated: false)
        tempScrollView.scrollRectToVisible(CGRect(x:0, y:0, width:100, height:300), animated: false)
        return tempScrollView
    }()
    //统计数字
    var AllOrderCount:UILabel = UILabel.init()
    var FinishedOrderCount:UILabel = UILabel.init()
    var InQuoteOrderCount:UILabel = UILabel.init()
    var InDesignOrderCount:UILabel = UILabel.init()
    var WaitForPayOrderCount:UILabel = UILabel.init()
    var WaitForProduceOrderCount:UILabel = UILabel.init()
    var ProducingOrderCount:UILabel = UILabel.init()
    var ShippingOrderCount:UILabel = UILabel.init()
    
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
        let userinfos = getCurrentUserInfo()
        _roleType = Int(userinfos.value(forKey: "roletype") as! String)!
        
        if _roleType == 4{
            setupUIForManager()
        }else{
            //每30秒获取一次消息列表
            getMessageList()//先获取一次
            timerForMessageList = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getMessageList), userInfo: nil, repeats: true)
            
            //分页菜单配置
            var options = PagingMenuOptions()
            options.roleTypeForController = _roleType
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
        }
        titleBarView.frame = CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44)
        scanQRCodeBtn.frame = CGRect(x: 20, y: 11, width: 62, height: 22)
        messageListBtn.frame = CGRect(x: kWidth - 82, y: 11, width: 62, height: 22)
        searchBarInOrders.frame = CGRect(x: 52, y: 8, width:kWidth - 104, height: 28)
        //为搜索框添加点击事件
        let gestureRecognizerOfSearach = UITapGestureRecognizer(target: self, action:#selector(searchBarTaped))
        searchBarInOrders.addGestureRecognizer(gestureRecognizerOfSearach)
        
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
        let msgListImg = UIImageView(frame: CGRect(x: 40, y: 1, width: 24, height: 20))
        msgListImg.image =  UIImage(named:"messagelisticon")
        self.view.addSubview(messageListBtn)
        
        
        
        messageCountBackLabel.layer.cornerRadius = 7
        messageCountBackLabel.clipsToBounds = true // 对Label切角度
        messageCountBackLabel.isHidden = true
        messageCountBackLabel.backgroundColor = UIColor.backgroundColors(color: .white)
        messageCountLabel.backgroundColor = UIColor.backgroundColors(color: .white)
//        let backLayer = CALayer()
//        backLayer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
//        backLayer.bounds  = CGRect(x: 0, y: 0, width: 22, height: 16)
//        backLayer.position = CGPoint(x: 11, y: 8)
//        messageCountBackLabel.layer.addSublayer(backLayer)
        messageCountLabel.layer.cornerRadius = 7
        messageCountLabel.text = "\(messagesList.count)"
        messageCountLabel.font = UIFont.systemFont(ofSize: 11)
        messageCountLabel.textColor = UIColor.titleColors(color: .red)
        messageCountLabel.textAlignment = .center
        messageCountLabel.clipsToBounds = true // 对Label切角度
        messageCountLabel.isHidden = false
        messageListBtn.addSubview(msgListImg)
        messageListBtn.addSubview(messageCountBackLabel)
        messageCountBackLabel.addSubview(messageCountLabel)
        
        
        
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
        titleBarView.addSubview(searchBarInOrders)
        titleBarView.addSubview(scanQRCodeBtn)
        titleBarView.addSubview(messageListBtn)

    }
    
    @objc func setupUIForManager(){
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        self.view.addSubview(scrollBackView)
        pullStatistics()
        let noticeOfSearch:UILabel = UILabel.init(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
        noticeOfSearch.text = "如果需要编辑订单参数，请搜索订单后进行操作"
        noticeOfSearch.textAlignment = .center
        noticeOfSearch.font = UIFont.systemFont(ofSize: 12)
        noticeOfSearch.textColor = UIColor.titleColors(color: .red)
        

        
        let titleOfPage:UILabel = UILabel.init(frame: CGRect(x: 15, y: noticeOfSearch.frame.maxY - 5, width: kWidth, height: 44))
        titleOfPage.text = "数据统计"
        titleOfPage.textColor = UIColor.titleColors(color: .black)
        titleOfPage.textAlignment = .left
        titleOfPage.font = UIFont.boldSystemFont(ofSize: 22)
        
        let dashLine:UIView = UIView.init(frame: CGRect(x: 15, y: titleOfPage.frame.maxY + 5, width: kWidth - 30, height: 1))
        //dashLine.image = UIImage(named: "dashlineimg")
        dashLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)// titleColors(color: .lightGray)
        
        let orderStatisticBoard1:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: dashLine.frame.maxY + 10, width: kWidth - 4, height: 120))
        orderStatisticBoard1.image = UIImage(named: "statisticboardbgimg")
        let seperateLine1:UIView = UIView.init(frame: CGRect(x: kWidth/2, y: 40, width: 0.5, height: orderStatisticBoard1.frame.height - 80))
        seperateLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        orderStatisticBoard1.addSubview(seperateLine1)
        //全部订单统计
        AllOrderCount.frame = CGRect(x: 20, y: 32, width: orderStatisticBoard1.frame.width/2 - 40, height: 33)
        AllOrderCount.textAlignment = .center
        AllOrderCount.textColor = UIColor.titleColors(color: .black)
        AllOrderCount.text = "0"
        AllOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let allorderLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 68, width: AllOrderCount.frame.width, height: 20))
        allorderLabel.text = "全部订单"
        allorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        allorderLabel.textAlignment = .center
        allorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard1.addSubview(AllOrderCount)
        orderStatisticBoard1.addSubview(allorderLabel)
        //已完成订单统计
        FinishedOrderCount.frame = CGRect(x: orderStatisticBoard1.frame.width/2 + 20, y: 32, width: orderStatisticBoard1.frame.width/2 - 40, height: 33)
        FinishedOrderCount.textAlignment = .center
        FinishedOrderCount.textColor = UIColor.titleColors(color: .black)
        FinishedOrderCount.text = "0"
        FinishedOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let finishedorderLabel:UILabel = UILabel.init(frame: CGRect(x: orderStatisticBoard1.frame.width/2 + 20, y: 68, width: FinishedOrderCount.frame.width, height: 20))
        finishedorderLabel.text = "已完成订单"
        finishedorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        finishedorderLabel.textAlignment = .center
        finishedorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard1.addSubview(FinishedOrderCount)
        orderStatisticBoard1.addSubview(finishedorderLabel)
        
        let orderStatisticBoard2:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: orderStatisticBoard1.frame.maxY - 15, width: kWidth - 4, height: 120))
        orderStatisticBoard2.image = UIImage(named: "statisticboardbgimg")
        let seperateLine2:UIView = UIView.init(frame: CGRect(x: kWidth/2, y: 40, width: 0.5, height: orderStatisticBoard2.frame.height - 80))
        seperateLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        orderStatisticBoard2.addSubview(seperateLine2)
        //咨询中的订单统计
        InQuoteOrderCount.frame = CGRect(x: 20, y: 32, width: orderStatisticBoard2.frame.width/2 - 40, height: 33)
        InQuoteOrderCount.textAlignment = .center
        InQuoteOrderCount.textColor = UIColor.titleColors(color: .black)
        InQuoteOrderCount.text = "0"
        InQuoteOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let inQuoteorderLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 68, width: InQuoteOrderCount.frame.width, height: 20))
        inQuoteorderLabel.text = "咨询中的订单"
        inQuoteorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        inQuoteorderLabel.textAlignment = .center
        inQuoteorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard2.addSubview(InQuoteOrderCount)
        orderStatisticBoard2.addSubview(inQuoteorderLabel)
        //设计中的订单统计
        InDesignOrderCount.frame = CGRect(x: orderStatisticBoard2.frame.width/2 + 20, y: 32, width: orderStatisticBoard2.frame.width/2 - 40, height: 33)
        InDesignOrderCount.textAlignment = .center
        InDesignOrderCount.textColor = UIColor.titleColors(color: .black)
        InDesignOrderCount.text = "0"
        InDesignOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let inDesignorderLabel:UILabel = UILabel.init(frame: CGRect(x: orderStatisticBoard2.frame.width/2 + 20, y: 68, width: InDesignOrderCount.frame.width, height: 20))
        inDesignorderLabel.text = "设计中的订单"
        inDesignorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        inDesignorderLabel.textAlignment = .center
        inDesignorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard2.addSubview(InDesignOrderCount)
        orderStatisticBoard2.addSubview(inDesignorderLabel)
        
        let orderStatisticBoard3:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: orderStatisticBoard2.frame.maxY - 15, width: kWidth - 4, height: 120))
        orderStatisticBoard3.image = UIImage(named: "statisticboardbgimg")
        let seperateLine3:UIView = UIView.init(frame: CGRect(x: kWidth/2, y: 40, width: 0.5, height: orderStatisticBoard3.frame.height - 80))
        seperateLine3.backgroundColor = UIColor.lineColors(color: .lightGray)
        orderStatisticBoard3.addSubview(seperateLine3)
        //待支付的订单统计
        WaitForPayOrderCount.frame = CGRect(x: 20, y: 32, width: orderStatisticBoard3.frame.width/2 - 40, height: 33)
        WaitForPayOrderCount.textAlignment = .center
        WaitForPayOrderCount.textColor = UIColor.titleColors(color: .black)
        WaitForPayOrderCount.text = "0"
        WaitForPayOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let waitForPayorderLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 68, width: WaitForPayOrderCount.frame.width, height: 20))
        waitForPayorderLabel.text = "待支付的订单"
        waitForPayorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        waitForPayorderLabel.textAlignment = .center
        waitForPayorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard3.addSubview(WaitForPayOrderCount)
        orderStatisticBoard3.addSubview(waitForPayorderLabel)
        //待生产的订单统计
        WaitForProduceOrderCount.frame = CGRect(x: orderStatisticBoard3.frame.width/2 + 20, y: 32, width: orderStatisticBoard3.frame.width/2 - 40, height: 33)
        WaitForProduceOrderCount.textAlignment = .center
        WaitForProduceOrderCount.textColor = UIColor.titleColors(color: .black)
        WaitForProduceOrderCount.text = "0"
        WaitForProduceOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let waitForProduceorderLabel:UILabel = UILabel.init(frame: CGRect(x: orderStatisticBoard3.frame.width/2 + 20, y: 68, width: WaitForProduceOrderCount.frame.width, height: 20))
        waitForProduceorderLabel.text = "待分配生产的订单"
        waitForProduceorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        waitForProduceorderLabel.textAlignment = .center
        waitForProduceorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard3.addSubview(WaitForProduceOrderCount)
        orderStatisticBoard3.addSubview(waitForProduceorderLabel)
        
        let orderStatisticBoard4:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: orderStatisticBoard3.frame.maxY - 15, width: kWidth - 4, height: 120))
        orderStatisticBoard4.image = UIImage(named: "statisticboardbgimg")
        let seperateLine4:UIView = UIView.init(frame: CGRect(x: kWidth/2, y: 40, width: 0.5, height: orderStatisticBoard4.frame.height - 80))
        seperateLine4.backgroundColor = UIColor.lineColors(color: .lightGray)
        orderStatisticBoard4.addSubview(seperateLine4)
        //生产中的订单统计
        ProducingOrderCount.frame = CGRect(x: 20, y: 32, width: orderStatisticBoard4.frame.width/2 - 40, height: 33)
        ProducingOrderCount.textAlignment = .center
        ProducingOrderCount.textColor = UIColor.titleColors(color: .black)
        ProducingOrderCount.text = "0"
        ProducingOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let producingorderLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 68, width: ProducingOrderCount.frame.width, height: 20))
        producingorderLabel.text = "生产中的订单"
        producingorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        producingorderLabel.textAlignment = .center
        producingorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard4.addSubview(ProducingOrderCount)
        orderStatisticBoard4.addSubview(producingorderLabel)
        //邮寄中的订单统计
        ShippingOrderCount.frame = CGRect(x: orderStatisticBoard4.frame.width/2 + 20, y: 32, width: orderStatisticBoard4.frame.width/2 - 40, height: 33)
        ShippingOrderCount.textAlignment = .center
        ShippingOrderCount.textColor = UIColor.titleColors(color: .black)
        ShippingOrderCount.text = "0"
        ShippingOrderCount.font = UIFont.boldSystemFont(ofSize: 24)
        
        let shippingorderLabel:UILabel = UILabel.init(frame: CGRect(x: orderStatisticBoard4.frame.width/2 + 20, y: 68, width: ShippingOrderCount.frame.width, height: 20))
        shippingorderLabel.text = "邮寄中的订单"
        shippingorderLabel.textColor = UIColor.titleColors(color: .darkGray)
        shippingorderLabel.textAlignment = .center
        shippingorderLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard4.addSubview(ShippingOrderCount)
        orderStatisticBoard4.addSubview(shippingorderLabel)
        
        scrollBackView.addSubview(noticeOfSearch)
        scrollBackView.addSubview(dashLine)
        scrollBackView.addSubview(titleOfPage)
        scrollBackView.addSubview(orderStatisticBoard1)
        scrollBackView.addSubview(orderStatisticBoard2)
        scrollBackView.addSubview(orderStatisticBoard3)
        scrollBackView.addSubview(orderStatisticBoard4)
    }
    
    @objc func searchBarTaped(){
        print("点击了搜索区域")
        
//        setStatusBarBackgroundColor(color: .clear)
//        titleBarView.backgroundColor = UIColor.clear
//        searchBarInOrders.backgroundColor = UIColor.clear
        
        if _roleType == 1{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidAndWangWangID, roleType: _roleType)
            searchOrderVC.tabbarObject = _tabBarVC
            self.present(searchOrderVC, animated: true, completion: nil)
        }else{
            let searchOrderVC = OrderSearchViewController(searchModel: .orderidOnly, roleType: _roleType)
            searchOrderVC.tabbarObject = _tabBarVC
            self.present(searchOrderVC, animated: true, completion: nil)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! StatisticCollectionViewCell
//        return cell
//    }
    
    @objc func scanQRCodeBtnClicked(){
        print("扫描二维码按钮点击了")
        let scanQRcodeVC = ScanCodeViewController(scanType: .qrCode)
        scanQRcodeVC.orderVCObject = self
        let nav = UINavigationController.init(rootViewController: scanQRcodeVC)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func messageListBtnClicked(){
        print("消息列表按钮点击了")
        let msgVC = MessageListViewController()
        msgVC.messagesList = messagesList
        //设置跳转带navigation controller的跳转
        let nav = UINavigationController(rootViewController: msgVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func pullStatistics(){
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
       
        
       // userid=10000005&token=a7562fe8-a7d0-40bb-a635-afe7d4523a2d&roletype=4
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        
        
        var requestUrl:String = ""
        if roletype == "4" {
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "statisticDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "statistic") as! String
            #endif
        }
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["status","code"].int!
                    if statusObject == 0{
                        var workFlows:[NSDictionary] = []
                        for item in json["workflow"].array!{
                            workFlows.append(item.dictionaryObject as! NSDictionary)
                        }
                        self.AllOrderCount.text = "\(workFlows[0].value(forKey: "num") as! Int)"
                        self.FinishedOrderCount.text = "\(workFlows[13].value(forKey: "num") as! Int)"
                        self.InQuoteOrderCount.text = "\(workFlows[2].value(forKey: "num") as! Int)"
                        self.InDesignOrderCount.text = "\((workFlows[3].value(forKey: "num") as! Int) + (workFlows[4].value(forKey: "num") as! Int))"
                        self.WaitForPayOrderCount.text = "\(workFlows[5].value(forKey: "num") as! Int)"
                        self.WaitForProduceOrderCount.text = "\(workFlows[6].value(forKey: "num") as! Int)"
                        self.ProducingOrderCount.text = "\(workFlows[7].value(forKey: "num") as! Int)"
                        self.ShippingOrderCount.text = "\(workFlows[8].value(forKey: "num") as! Int)"
                    }else{
                        print("获取数据失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
            }
        }
        print("接受生产按钮点击了")
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        setStatusBarBackgroundColor(color: UIColor.titleColors(color: .red))
        titleBarView.backgroundColor = UIColor.backgroundColors(color: .red)
        searchBarInOrders.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0)
        
        //self.view.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //获取消息列表
    @objc func getMessageList(){
        if _roleType != 2 && _roleType != 3{
            return
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                //获取列表
                
                let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
                let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
                let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
                #if DEBUG
                //            let newTaskUpdateURL:String = "http://192.168.1.102:8068/task/createTasklist.do"
                let newTaskUpdateURL:String = apiAddresses.value(forKey: "getMessagesListDebug") as! String
                #else
                let newTaskUpdateURL:String = apiAddresses.value(forKey: "getMessagesList") as! String
                #endif
                //定义请求参数
                let params:NSMutableDictionary = NSMutableDictionary()
                
                //从datacore获取用户数据
                //获取管理的数据上下文，对象
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                
                //声明数据的请求
                let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
                let fetchRequestOfToken = NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
                //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
                //        fetchRequest.fetchOffset = 0 //查询到偏移量
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequestOfToken.returnsObjectsAsFaults = false
                
                // 设置查询条件
                let predicate = NSPredicate(format: "id = '1'")
                fetchRequest.predicate = predicate
                
                // 设置查询条件
                let predicateOfToken = NSPredicate(format: "id = '1'")
                fetchRequestOfToken.predicate = predicateOfToken
                //查询操作
                do {
                    let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
                    
                    //遍历查询结果
                    for info in fetchedObjects{
                        //更新数据
                        //设置获取全部订单参数组
                        
                        params["userid"] =  info.userId
                        params["roletype"] = info.roleType
                        params["commandcode"] = 110
                        params["isnew"] = 0
                        try managedObjectContext.save()
                    }
                } catch  {
                    fatalError("获取失败")
                }
                
                //查询操作
                do {
                    let fetchedObjects = try managedObjectContext.fetch(fetchRequestOfToken)
                    
                    //遍历查询结果
                    for info in fetchedObjects{
                        //更新数据
                        //设置获取全部订单参数组
                        params["token"] = info.token
                        try managedObjectContext.save()
                    }
                } catch  {
                    fatalError("获取失败")
                }
                _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
                    (responseObject) in
                    switch responseObject.result.isSuccess{
                    case true:
                        if  let value = responseObject.result.value{
                            let json = JSON(value)
                            self.messagesList.removeAll()
                            if json["status","code"].int! == 0{
                                for item in json["msginfo"].array! {
                                    let restoreItem = item.dictionaryObject as! NSDictionary
                                    self.messagesList.append(restoreItem)
                                }
                                self.getMessagesCount = self.messagesList.count
                            }else if json["status","code"].int! == 1{
                                self.getMessagesCount = 0
                                self._tabBarVC.redDot.isHidden = true
                            }
                            if self.messagesList.count == 0{
                                self._tabBarVC.redDot.isHidden = true
                               // self.messageBtnLayer.isHidden = true
                                self.messageCountBackLabel.isHidden = true
                            }else{
                                self._tabBarVC.redDot.isHidden = false
                                //self.messageBtnLayer.isHidden = false
                                self.messageCountBackLabel.isHidden = false
                                if self.messagesList.count > 99{
                                    self.messageCountLabel.text = "99+"
                                }else{
                                    self.messageCountLabel.text = "\(self.messagesList.count)"
                                }
                                print("message count = \(self.messagesList.count)")
                                self.calculateWeatherNeedsAlert()
                            }
                        }
                    case false:
                        print("update failed")
                    }
                }
            })
        }
    }
    
    func calculateWeatherNeedsAlert()
    {
        var messageAlertArray:[Bool] = []
        print("begain to calculate")
        isNeedsAlert = false
        var AlertFrequencyValue = 0
        //var isTheAlertPlayedThisRound = false
        //遍历当前获取到的列表里的所有
        currentMessagesTypeList.removeAll()
        currentMessagesIDList.removeAll()
        for i in 0..<messagesList.count{
            let mSGType = messagesList[i].value(forKey: "msgtype") as! Int
            let mSGID = messagesList[i].value(forKey: "msgid") as! String
            currentMessagesTypeList.append(mSGType)
            currentMessagesIDList.append(mSGID)
        }
        for i in 0..<24{
            messageAlertArray.append(getMSGAlertSettings(index: i))
        }
        print("get Array finised")
        //第一次获取消息,直接判断是不是需要提醒
        if previewsMessagesIDList.count == 0{
            
            //遍历当前消息列表中的消息类型,以此得到是否需要提醒
            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
            for msgType in currentMessagesTypeList{
                let tempAlertTag = messageAlertArray[msgType] //getMSGAlertSettings(index: msgType)
                //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
            }
            
            //获取当前设置，决定是否需要提醒，以及提醒多少次
            let frequency = getMsgVoiceAlertFrequencyWeight()
            print(frequency)
            if frequency == 1{
                // 不提醒
                isNeedsAlert = false
                AlertFrequencyValue = 0
            }else if frequency == 10{
                //提醒一次
                //
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 1
            }else{
                //提醒多次
                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
                for msgType in currentMessagesTypeList{
                    let tempAlertTag = messageAlertArray[msgType]//getMSGAlertSettings(index: msgType)
                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
                }
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 10
            }
            
            //将当前获取的列表替换到上次的列表中，以便下次比对
            previewsMessagesIDList.removeAll()
            previewsMessagesIDList = currentMessagesIDList
        }else{ //不是第一次获取消息了
            var itemID = 0
            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
            for id in currentMessagesIDList{
                if !previewsMessagesIDList.contains(id){//这条消息不包含在之前的消息里
                    //如果这条消息不在列表里，那么取对应的消息ID查询结果，并与定义的需要提醒取或，只要有一条消息需要提醒，那么值将会是true
                    needsAlertFromCurrentAlertSettingForTargetMSGType =  needsAlertFromCurrentAlertSettingForTargetMSGType || messageAlertArray[currentMessagesTypeList[itemID]] /*getMSGAlertSettings(index: currentMessagesTypeList[itemID]*/
                }
                itemID += 1
            }
            //获取当前设置，决定是否需要提醒，以及提醒多少次
            let frequency = getMsgVoiceAlertFrequencyWeight()
            print(frequency)
            if frequency == 1{
                // 不提醒
                isNeedsAlert = false
                AlertFrequencyValue = 0
            }else if frequency == 10{
                //提醒一次
                //
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 1
            }else{
                //提醒多次
                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
                for msgType in currentMessagesTypeList{
                    let tempAlertTag = messageAlertArray[msgType] // getMSGAlertSettings(index: msgType)
                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
                }
                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
                AlertFrequencyValue = 10
            }
        }
        
        if isNeedsAlert == true{
            if (AlertFrequencyValue == 1) && (isTheAlertPlayed == false){
                playAudio()
                isTheAlertPlayed = true
            }else if AlertFrequencyValue == 10{
                playAudio()
            }
        }
        
    }
    
    func playAudio(){
        
        if !isPlaying{
            //建立的SystemSoundID对象
            var soundID:SystemSoundID = 0
            //获取声音地址
            let path = Bundle.main.path(forResource: "msg", ofType: "wav")
            //地址转换
            let baseURL = NSURL(fileURLWithPath: path!)
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
            
            //添加音频结束时的回调
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, {
                (soundID, inClientData) -> Void in
                let mySelf = Unmanaged<OrdersViewController>.fromOpaque(inClientData!)
                    .takeUnretainedValue()
                mySelf.audioServicesPlaySystemSoundCompleted(soundID: soundID)
            }, observer)
            
            //播放声音
            AudioServicesPlaySystemSound(soundID)
            isPlaying = true
        }
        
        
    }
    //音频结束时的回调
    func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        print("Completion")
        isPlaying = false
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
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
