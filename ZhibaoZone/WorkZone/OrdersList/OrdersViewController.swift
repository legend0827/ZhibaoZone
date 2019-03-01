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
    //用户
    var isUserAsSuperFactory = false
    //全部订单子视图
    private let allOrdersVC = AllOrdersViewController(orderlistType: orderListCategoryType.allOrderCategory)
    //待报价子视图
    private let notQuoteYetVC = AllOrdersViewController(orderlistType: orderListCategoryType.notQuotePriceYetOrderCategory)
    //已报价子视图
    private let quoteAlreadyVC = AllOrdersViewController(orderlistType: orderListCategoryType.alreadyQuotedOderCategory)
    //未处理议价
   // private let bargainNotDealedVC = AllOrdersViewController(orderlistType: orderListCategoryType.bargainNotDealedCategory)
    //已处理议价
 //   private let bargainDealedVC = AllOrdersViewController(orderlistType: orderListCategoryType.bargainDealedCategory)
    //待接受生产子视图
    private let waitForProduceVC = AllOrdersViewController(orderlistType: orderListCategoryType.waitForAcceptProduceOrderCategory)
    //生产中子视图
    private let producingVC = AllOrdersViewController(orderlistType: orderListCategoryType.producingOrderCategory)

    ///// 设计师
    //待接单
    private let waitForDesignVC = AllOrdersViewController(orderlistType: orderListCategoryType.waitForDesignCategory)
   // 设计中
    private let designningVC = AllOrdersViewController(orderlistType: orderListCategoryType.designningCategory)
    //待定稿
    private let waitForConfirmDesignVC = AllOrdersViewController(orderlistType: orderListCategoryType.waitForConfirmDesignCategory)
    //待修改
    private let waitForModifyVC = AllOrdersViewController(orderlistType: orderListCategoryType.waitForModifyCategory)
   // 已定稿
    private let DesignConfirmedVC = AllOrdersViewController(orderlistType: orderListCategoryType.customerConfirmedCategory)
    //都未报价
    private let nobodyQuotedVC = AllOrdersViewController(orderlistType: orderListCategoryType.allFactoryNotQuoteCategory)
    
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
            if isUserAsSuperFactory{
                return .all(menuOptions: MenuOptionsForSuperFactory(), pagingControllers: pagingControllersForSuperFactory)
            }else{
                return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
            }
        case 4:
            return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
        default:
            print("nothing")
        }
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器 - 设计师
    fileprivate var pagingControllersForDesign: [UIViewController] {
        return [waitForDesignVC,designningVC,waitForModifyVC,waitForConfirmDesignVC,DesignConfirmedVC]
    }
    //所有子视图控制器 - 车间1
    fileprivate var pagingControllersForSuperFactory: [UIViewController] {
        return [nobodyQuotedVC,notQuoteYetVC,quoteAlreadyVC,waitForProduceVC,producingVC]
    }
    
    //所有子视图控制器 - 其他角色
    fileprivate var pagingControllers: [UIViewController] {
        return [notQuoteYetVC,quoteAlreadyVC,waitForProduceVC,producingVC]
    }
    
    //菜单配置项 - 其他角色
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            //return .segmentedControl
            return .segmentedControl//.standard(widthMode: MenuItemWidthMode.flexible, centerItem: false, scrollingMode: MenuScrollingMode.scrollEnabled)
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
                return [MenuItem2(),MenuItem3(),MenuItem4(),MenuItem5()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 4, color: UIColor.titleColors(color: .lightOrange), horizontalPadding: 38, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
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
            return [MenuItem6(),MenuItem13(),MenuItem7(),MenuItem14(),MenuItem8()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 4, color: UIColor.titleColors(color: .lightOrange), horizontalPadding: 28, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
        }
        
    }
    
    //菜单配置项 - 车间1
    fileprivate struct MenuOptionsForSuperFactory: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            //return .segmentedControl
            //return .segmentedControl//.standard(widthMode: MenuItemWidthMode.flexible, centerItem: false, scrollingMode: MenuScrollingMode.scrollEnabled)
            return .standard(widthMode: MenuItemWidthMode.flexible, centerItem: false, scrollingMode: MenuScrollingMode.scrollEnabledAndBouces)
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem15(),MenuItem2(),MenuItem3(),MenuItem4(),MenuItem5()]
        }
        //设置选中栏下方条的颜色
        var focusMode:MenuFocusMode {
            return .underline(height: 4, color: UIColor.titleColors(color: .lightOrange), horizontalPadding: 28, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
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
            return .underline(height: 4, color: UIColor.titleColors(color: .lightOrange), horizontalPadding: 42, verticalPadding: 5) // 水平间距 0 ，垂直间距 0
        }
        
    }
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            //return .text(title: MenuItemText(text: "全部"))
                return .text(title: MenuItemText(text: "全部", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "未报价", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    
    //第3个菜单项
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已报价", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    
    //第4个菜单项
    fileprivate struct MenuItem4: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    
    //第5个菜单项
    fileprivate struct MenuItem5: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待发货", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第6个菜单项
    fileprivate struct MenuItem6: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待接单", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第7个菜单项
    fileprivate struct MenuItem7: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待修改", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第8个菜单项
    fileprivate struct MenuItem8: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已定稿", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第9个菜单项
    fileprivate struct MenuItem9: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "咨询中", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第10个菜单项
    fileprivate struct MenuItem10: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待支付", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第11个菜单项
    fileprivate struct MenuItem11: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "未处理议价", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第12个菜单项
    fileprivate struct MenuItem12: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "已处理议价", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第13个菜单项
    fileprivate struct MenuItem13: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "设计中", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第14个菜单项
    fileprivate struct MenuItem14: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "待定稿", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
    //第15个菜单项
    fileprivate struct MenuItem15: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "都未报价", color: UIColor.titleColors(color: .darkGray), selectedColor: UIColor.titleColors(color: .black), font: UIFont.systemFont(ofSize: 16), selectedFont: UIFont.boldSystemFont(ofSize: 17)))
        }
    }
}

class OrdersViewController:UIViewController,UITextFieldDelegate,UIScrollViewDelegate{
    
    //系统声音播放
    var isPlaying = false
    var isTheAlertPlayed = false
    
    //获取消息列表
    var timerForMessageList:Timer!
    var isNeedsAlert = true
    var getMessagesCount = 0
    lazy var _tabBarVC: TabBarController = {
        return TabBarController(royeType: 1)
    }()
    //
    var onlineListOfDesigner:[NSDictionary] = []
    var onlineListOfServicer:[NSDictionary] = []
    var onlineListOfFactory:[NSDictionary] = []
    
    //统计分析按钮
    lazy var statisticDetailBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitle("统计分析", for: .normal)
      //  tempButton.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
        let arrow:UIImageView = UIImageView.init(frame: CGRect(x: 75, y: 5, width: 5, height: 9))
        arrow.image = UIImage(named: "right-arrow-white")
        tempButton.addSubview(arrow)
        tempButton.layer.cornerRadius = 16
        tempButton.layer.borderColor = UIColor.clear.cgColor
        tempButton.layer.borderWidth = 0.5
        tempButton.tag = 1
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.addTarget(self, action: #selector(jumpToStatisticDetail), for: .touchUpInside)
        return tempButton
    }()
    
    //消息数目
    let messageCountBackLabel:UIView = UIView.init(frame: CGRect(x: 50, y: 5, width: 22, height: 16))
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 22, height: 16))
    
    //最近一天
    lazy var recentOneDayBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitle("近一日", for: .normal)
        tempButton.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
        tempButton.layer.cornerRadius = 16
        tempButton.layer.borderColor = UIColor.clear.cgColor
        tempButton.layer.borderWidth = 0.5
        tempButton.tag = 1
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.addTarget(self, action: #selector(switchTimeInterval), for: .touchUpInside)
        return tempButton
    }()
    
    //最近七天
    lazy var recentOneWeekBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitle("近一周", for: .normal)
        tempButton.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
        tempButton.layer.cornerRadius = 16
        tempButton.layer.borderColor = UIColor.lineColors(color: .red).cgColor
        tempButton.layer.borderWidth = 0.5
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.tag = 2
        tempButton.addTarget(self, action: #selector(switchTimeInterval), for: .touchUpInside)
        return tempButton
    }()
    
    //最近一月
    lazy var recentOneMonthBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitle("近30天", for: .normal)
        tempButton.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
        tempButton.layer.cornerRadius = 16
        tempButton.layer.borderColor = UIColor.clear.cgColor
        tempButton.layer.borderWidth = 0.5
        tempButton.tag = 3
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.addTarget(self, action: #selector(switchTimeInterval), for: .touchUpInside)
        return tempButton
    }()
    
    //自定义日期
    lazy var customDateBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitle("自定义日期", for: .normal)
        tempButton.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
        tempButton.layer.cornerRadius = 16
        tempButton.layer.borderColor = UIColor.clear.cgColor
        tempButton.layer.borderWidth = 0.5
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.tag = 4
        tempButton.addTarget(self, action: #selector(switchTimeInterval), for: .touchUpInside)
        return tempButton
        
    }()
    
    //用户角色
    var _roleType = 1
    var _userId = "1000000"
    lazy var scrollBackView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - heightChangeForiPhoneXFromBottom - 49))
        tempScrollView.contentSize = CGSize(width: kWidth, height: 730 )
        //backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height )
      //  tempScrollView.backgroundColor = UIColor.backgroundColors(color: .white)
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
    var onlineCustomerServiceCount:UIButton = UIButton.init(type: .custom)
    var onlineDesignerCount:UIButton = UIButton.init(type: .custom)
    var onlineProducerCount:UIButton = UIButton.init(type: .custom)
    var gudanAmountCount:UILabel = UILabel.init() // 估单
    var dealAmountCount:UILabel = UILabel.init() //成交
    var transferAmountCount:UILabel = UILabel.init() //成交转化
    var newOrderAmountCount:UIButton = UIButton.init(type: .custom)// 新建订单数量
    var doneOrderAmountCount:UIButton = UIButton.init(type: .custom) // 成交订单
    var waitForPayOrderAmountCount:UIButton = UIButton.init(type: .custom)//待支付订单
    var waitForAcceptDesignCount:UIButton = UIButton.init(type: .custom)
    var designningCount:UIButton = UIButton.init(type: .custom)
    var customerConfirmedCount:UIButton = UIButton.init(type: .custom)
    var waitForProduceCount:UIButton = UIButton.init(type: .custom)
    var producingOrderCount:UIButton = UIButton.init(type: .custom)
    var shippingOrderCount:UIButton = UIButton.init(type: .custom)
    var waitForQuoteOrderCount:UIButton = UIButton.init(type: .custom)
    var waitForBargainOrderCount:UIButton = UIButton.init(type: .custom)
    var waitForCompetionOrderCount:UIButton = UIButton.init(type: .custom)
    //时间统计范围
    var timeInterval_from:TimeInterval = 0
    var timeInterval_to:TimeInterval = 0
    //时间切换
   // let chooseTimeIntervalBtn:UIButton = UIButton.init(type: .custom)
    
    //标题栏背景
    let titleBarView:UIView = UIView.init(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44))
    //扫描二维码按钮
    let scanQRCodeBtn:UIButton = UIButton.init(type: .custom)
    //订单列表的搜素栏
    //let searchBarInOrders:UISearchBar = UISearchBar.init(frame: CGRect(x: 52, y: 5, width:kWidth - 104, height: 28))
    let searchBarInOrders:UIView = UIView.init(frame: CGRect(x: 52, y: 8, width:kWidth - 104, height: 28))
    //消息按钮
    let messageListBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    
    let backgroundImageView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 200))
    
    let noticeOfSearch:UIImageView = UIImageView.init(frame: CGRect(x: (kWidth - 147)/2, y: 64 + heightChangeForiPhoneXFromTop, width: 147, height: 17))
    let downArrowImg:UIImageView = UIImageView.init(frame: CGRect(x: 55, y: 9, width: 9, height: 5))
    override func viewDidLoad() {
        super.viewDidLoad()
       // getSystemParas()
        timeInterval_from = dateAheadNow(before: 7, countAs: .PerDay).TimeInterval
        timeInterval_to = getEndDateTimeOfToday().TimeInterval//1000
        //设置状态栏颜色
        setStatusBarBackgroundColor(color: UIColor.clear)
        let userinfos = getCurrentUserInfo()
        _roleType = Int(userinfos.value(forKey: "roletype") as! String)!
        _userId = userinfos.value(forKey: "userid") as! String
        
        backgroundImageView.image = UIImage(named: "titlebackgroundimg")
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
        
        //每30秒获取一次消息列表
        getMessageList()//先获取一次
        timerForMessageList = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getMessageList), userInfo: nil, repeats: true)
        timerForMessageList = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getOnlineStatus), userInfo: nil, repeats: true)
        
        
        if _roleType == 4{
            setupUIForManager()
        }else{
            
            //分页菜单配置
            var options = PagingMenuOptions()
            options.roleTypeForController = _roleType
            //车间1账号要求显示都未报价分类
            if _userId == "10000013"{
                options.isUserAsSuperFactory = true
            }else{
                options.isUserAsSuperFactory = false
            }
            
            //分页菜单控制器初始化
            let pagingMenuController = PagingMenuController(options: options)
            
            //分页菜单控制器尺寸设置
            pagingMenuController.view.frame.origin.y += 28 //(4 + heightChangeForiPhoneXFromTop)*3
            pagingMenuController.view.frame.size.height -= 5

            if UIDevice.current.isX(){
                heightChangeForiPhoneXFromTop = 24.0
                pagingMenuController.view.frame.origin.y += 66 //56
            }else{
                heightChangeForiPhoneXFromTop = 0.0
                pagingMenuController.view.frame.origin.y += 42//32
            }
            //建立父子关系
            addChildViewController(pagingMenuController)
            //分页菜单控制器视图添加到当前视图中
            view.addSubview(pagingMenuController.view)
            //print("分页显示出来了")
        }
        titleBarView.frame = CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: kWidth, height: 44)
        scanQRCodeBtn.frame = CGRect(x: 12, y: 11, width: 62, height: 22)
        messageListBtn.frame = CGRect(x: kWidth - 74, y: 1, width: 82, height: 42)
        searchBarInOrders.frame = CGRect(x: 46, y: 8, width:kWidth - 92, height: 32)
        //为搜索框添加点击事件
        let gestureRecognizerOfSearach = UITapGestureRecognizer(target: self, action:#selector(searchBarTaped))
        searchBarInOrders.addGestureRecognizer(gestureRecognizerOfSearach)
        
        //顶部titlebar显示
        titleBarView.backgroundColor = UIColor.clear
        
        //设置扫描二维码按钮样式
        scanQRCodeBtn.addTarget(self, action: #selector(scanQRCodeBtnClicked), for: UIControlEvents.touchUpInside)
        let qrcodeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        qrcodeImg.image =  UIImage(named:"scanqrcodeicon")//  UIImage(named:"messagelisticon")
        self.view.addSubview(scanQRCodeBtn)
        scanQRCodeBtn.addSubview(qrcodeImg)
        
        //设置消息按钮样式和响应
        messageListBtn.addTarget(self, action: #selector(messageListBtnClicked), for: UIControlEvents.touchUpInside)
        let msgListImg = UIImageView(frame: CGRect(x: 40, y: 11, width: 24, height: 20))
        msgListImg.image =  UIImage(named:"messagelisticon")
        self.view.addSubview(messageListBtn)
        
        
        
        messageCountBackLabel.layer.cornerRadius = 7
        messageCountBackLabel.clipsToBounds = true // 对Label切角度
        messageCountBackLabel.isHidden = true
        messageCountBackLabel.backgroundColor = UIColor.backgroundColors(color: .white)
        messageCountLabel.backgroundColor = UIColor.backgroundColors(color: .white)
        messageCountLabel.layer.cornerRadius = 7
        messageCountLabel.font = UIFont.systemFont(ofSize: 11)
        messageCountLabel.textColor = UIColor.titleColors(color: .red)
        messageCountLabel.textAlignment = .center
        messageCountLabel.clipsToBounds = true // 对Label切角度
        messageCountLabel.isHidden = false
        messageListBtn.addSubview(msgListImg)
        messageListBtn.addSubview(messageCountBackLabel)
        messageCountBackLabel.addSubview(messageCountLabel)
        
        //设置搜索栏
        searchBarInOrders.backgroundColor = UIColor.backgroundColors(color: .white)
        //searchBarInOrders.layer.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0).cgColor
        searchBarInOrders.layer.cornerRadius = 4
        let searchBarHintText:UILabel = UILabel.init(frame: CGRect(x: searchBarInOrders.frame.width/2 - 43, y: 0, width: 100, height: 32))
        searchBarHintText.text = "搜索订单号"
        searchBarHintText.textAlignment = .center
        searchBarHintText.textColor = UIColor.titleColors(color: .gray)
        searchBarHintText.font = UIFont.systemFont(ofSize: 15)
        let searchIconImg = UIImageView(frame: CGRect(x: searchBarInOrders.frame.width/2 - 55, y: 9, width: 14, height: 14))
        searchIconImg.image =  UIImage(named:"searchicon")
        searchBarInOrders.addSubview(searchIconImg)
        searchBarInOrders.addSubview(searchBarHintText)

        self.view.addSubview(titleBarView)
        titleBarView.addSubview(searchBarInOrders)
        titleBarView.addSubview(scanQRCodeBtn)
        titleBarView.addSubview(messageListBtn)

    }
    //切换日期按钮
    @objc func switchTimeInterval(_ button:UIButton){
        let index = button.tag
        switch index {
        case 1: // 近一日
            recentOneDayBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
            recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
            
            recentOneWeekBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneMonthBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            customDateBtn.layer.borderColor = UIColor.clear.cgColor
            customDateBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            //近一日的时间戳
            timeInterval_from = dateAheadNow(before: 1, countAs: .PerDay).TimeInterval
            timeInterval_to = getEndDateTimeOfToday().TimeInterval
            pullStatistics()
        case 2: // 近7日
            recentOneDayBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneWeekBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
            recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
            
            recentOneMonthBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            customDateBtn.layer.borderColor = UIColor.clear.cgColor
            customDateBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            //"最近1周"
            timeInterval_from = dateAheadNow(before: 7, countAs: .PerDay).TimeInterval
            timeInterval_to = getEndDateTimeOfToday().TimeInterval
            pullStatistics()
        case 3: // 近30天
            recentOneDayBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneWeekBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneMonthBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
            recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
            
            customDateBtn.layer.borderColor = UIColor.clear.cgColor
            customDateBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            timeInterval_from = dateAheadNow(before: 30, countAs: .PerDay).TimeInterval
            timeInterval_to = getEndDateTimeOfToday().TimeInterval

            pullStatistics()
        case 4: // 自定义日期
            recentOneDayBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneWeekBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            recentOneMonthBtn.layer.borderColor = UIColor.clear.cgColor
            recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
            
            customDateBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
            customDateBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
            changeTimeIntervalClicked()
        default:
            print("Doesnt exist!")
        }
        
    }
    
    
    
    @objc func setupUIForManager(){
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        self.view.addSubview(scrollBackView)
        
        //编辑订单请先搜索后进行操作
        
        noticeOfSearch.image = UIImage(named: "noticeofsearchhintimg")
        //数据统计title
        let titleOfPage:UIImageView = UIImageView.init(frame: CGRect(x: 10, y: noticeOfSearch.frame.maxY, width: 35*136/29, height: 35))
        titleOfPage.image = UIImage(named: "statisticnamelabelimg")
        
        let imgBG:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 210, y: noticeOfSearch.frame.maxY - 32, width: 156, height: 102))
       // imgBG.image = UIImage(named: "statisticbgimg")
        
        let dashLine:UIView = UIView.init(frame: CGRect(x: 15, y: titleOfPage.frame.maxY + 5, width: kWidth - 30, height: 1))
        dashLine.backgroundColor = UIColor.backgroundColors(color: .lightestGray)// titleColors(color: .lightGray)
        
        statisticDetailBtn.frame = CGRect(x: kWidth - 90, y: noticeOfSearch.frame.maxY + 15, width: 80, height: 18)
        self.view.addSubview(statisticDetailBtn)
        
//        //切换时间
//        chooseTimeIntervalBtn.setTitle("最近一周", for: .normal)
//        chooseTimeIntervalBtn.frame = CGRect(x: titleOfPage.frame.maxX + 12, y: titleOfPage.frame.minY, width: 80, height: 23)
//        chooseTimeIntervalBtn.contentVerticalAlignment = .center
//        chooseTimeIntervalBtn.contentHorizontalAlignment = .left
//        chooseTimeIntervalBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//        chooseTimeIntervalBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
//        chooseTimeIntervalBtn.addTarget(self, action: #selector(changeTimeIntervalClicked), for: .touchUpInside)
//
//        downArrowImg.image = UIImage(named: "down-arrow-white")
//        chooseTimeIntervalBtn.addSubview(downArrowImg)
//        scrollBackView.addSubview(chooseTimeIntervalBtn)
        
        let transparentBGboard1:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 148, width: kWidth, height: 495))
        transparentBGboard1.image = UIImage(named: "transparencybgimg")
        scrollBackView.addSubview(transparentBGboard1)
        
        let changeTimeIntervalBoard:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: dashLine.frame.maxY + 5, width: kWidth, height: 66))
        changeTimeIntervalBoard.image = UIImage(named: "changetimeintervalbgimg")
        changeTimeIntervalBoard.isUserInteractionEnabled  = true
        scrollBackView.addSubview(changeTimeIntervalBoard)
        
        let gap:CGFloat = (kWidth - 346)/3
        
        recentOneDayBtn.frame = CGRect(x: 15, y: 17, width: 72, height: 32)
        recentOneWeekBtn.frame = CGRect(x: recentOneDayBtn.frame.maxX + gap, y: 17, width: 72, height: 32)
        recentOneMonthBtn.frame = CGRect(x: recentOneWeekBtn.frame.maxX + gap, y: 17, width: 72, height: 32)
        customDateBtn.frame = CGRect(x: recentOneMonthBtn.frame.maxX + gap, y: 17, width: 100, height: 32)
        
        
        changeTimeIntervalBoard.addSubview(recentOneMonthBtn)
        changeTimeIntervalBoard.addSubview(recentOneWeekBtn)
        changeTimeIntervalBoard.addSubview(recentOneDayBtn)
        changeTimeIntervalBoard.addSubview(customDateBtn)
        
        let orderStatisticBoard1:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: changeTimeIntervalBoard.frame.maxY + 5, width: kWidth, height: 180)) // 135
        orderStatisticBoard1.image = UIImage(named: "statisticboardbgimg")
        orderStatisticBoard1.isUserInteractionEnabled = true
        
        let orangeDotImg1:UIImageView = UIImageView(frame: CGRect(x: 15, y: 14, width: 5, height: 18))
        orangeDotImg1.image = UIImage(named: "orangedotimg")
        orderStatisticBoard1.addSubview(orangeDotImg1)
        
        let customerServiceTitle:UILabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: 100, height: 25))
        customerServiceTitle.text = "客服数据"
        customerServiceTitle.font = UIFont.boldSystemFont(ofSize: 16)
        customerServiceTitle.textColor = UIColor.titleColors(color: .black)
        orderStatisticBoard1.addSubview(customerServiceTitle)
        
        //在线客服数量：
        let onlineIcon1:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 182, y: customerServiceTitle.frame.minY + 3, width: 16, height: 18))
        onlineIcon1.image = UIImage(named: "onlineiconimg")
        //orderStatisticBoard1.addSubview(onlineIcon1)
        
        onlineCustomerServiceCount.frame = CGRect(x: kWidth - 156, y: customerServiceTitle.frame.minY, width: 138, height: 26)
        onlineCustomerServiceCount.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        onlineCustomerServiceCount.setTitle("在线客服：-", for: .normal)
        onlineCustomerServiceCount.contentHorizontalAlignment = .right
        onlineCustomerServiceCount.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        onlineCustomerServiceCount.tag = 1
        onlineCustomerServiceCount.addTarget(self, action: #selector(onlineCheckBtnClicked(_:)), for: .touchUpInside)
        orderStatisticBoard1.addSubview(onlineCustomerServiceCount)
        
        let seperateLine1:UIView = UIView.init(frame: CGRect(x: 0, y: 45, width: kWidth, height: 0.5))
        seperateLine1.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        orderStatisticBoard1.addSubview(seperateLine1)
        //估单金额统计
        let gudanAmountTitle:UILabel = UILabel.init(frame: CGRect(x: 0, y: seperateLine1.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        gudanAmountTitle.text = "估单金额"
        gudanAmountTitle.font = UIFont.systemFont(ofSize: 14)
        gudanAmountTitle.textColor = UIColor.titleColors(color: .gray)
        gudanAmountTitle.textAlignment = .center
        
        gudanAmountCount.frame = CGRect(x: 0, y: gudanAmountTitle.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        gudanAmountCount.textAlignment = .center
        gudanAmountCount.textColor = UIColor.titleColors(color: .black)
        gudanAmountCount.text = "¥--"
        gudanAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(gudanAmountTitle)
        orderStatisticBoard1.addSubview(gudanAmountCount)
        
        //成交金额统计
        let dealAmonuntTitle:UILabel = UILabel.init(frame: CGRect(x: (kWidth - 200)/2, y: seperateLine1.frame.maxY + 15, width: 200, height: 20))
        dealAmonuntTitle.text = "成交金额"
        dealAmonuntTitle.font = UIFont.systemFont(ofSize: 14)
        dealAmonuntTitle.textColor = UIColor.titleColors(color: .gray)
        dealAmonuntTitle.textAlignment = .center
        
        dealAmountCount.frame = CGRect(x: kWidth/3, y: gudanAmountTitle.frame.maxY + 3, width: kWidth/3, height: 21)
        dealAmountCount.textAlignment = .center
        dealAmountCount.textColor = UIColor.titleColors(color: .black)
        dealAmountCount.text = "¥--"
        dealAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(dealAmonuntTitle)
        orderStatisticBoard1.addSubview(dealAmountCount)
        
        //成交转化
        let transferAmountLabel:UILabel = UILabel.init(frame: CGRect(x: kWidth/3*2 - 4.3, y: seperateLine1.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        transferAmountLabel.text = "成交转化"
        transferAmountLabel.font = UIFont.systemFont(ofSize: 14)
        transferAmountLabel.textColor = UIColor.titleColors(color: .gray)
        transferAmountLabel.textAlignment = .center
        
        transferAmountCount.frame = CGRect(x: kWidth/3*2 - 4.3, y: gudanAmountTitle.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        transferAmountCount.textAlignment = .center
        transferAmountCount.textColor = UIColor.titleColors(color: .black)
        transferAmountCount.text = "--.-%"
        transferAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(transferAmountLabel)
        orderStatisticBoard1.addSubview(transferAmountCount)
        
        //订单数统计 - 新建订单
        let newOrderLabel:UIButton = UIButton.init(frame: CGRect(x: 0, y: gudanAmountCount.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        newOrderLabel.setTitle("新建订单", for: .normal)
        newOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        newOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        newOrderLabel.contentHorizontalAlignment = .center
        newOrderLabel.contentVerticalAlignment = .center
        newOrderLabel.tag = 1
        newOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        
        newOrderAmountCount.frame = CGRect(x: 0, y: newOrderLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        newOrderAmountCount.setTitle("--", for: .normal)
        newOrderAmountCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        newOrderAmountCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        newOrderAmountCount.contentHorizontalAlignment = .center
        newOrderAmountCount.contentVerticalAlignment = .center
        newOrderAmountCount.tag = 1
        newOrderAmountCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        orderStatisticBoard1.addSubview(newOrderLabel)
        orderStatisticBoard1.addSubview(newOrderAmountCount)
        
        //订单数统计 - 成交订单
        let doneOrderLabel:UIButton = UIButton.init(frame: CGRect(x: (kWidth - 200)/2, y: dealAmountCount.frame.maxY + 15, width: 200, height: 20))
        doneOrderLabel.setTitle("成交订单", for: .normal)
        doneOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        doneOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        doneOrderLabel.contentHorizontalAlignment = .center
        doneOrderLabel.contentVerticalAlignment = .center
        doneOrderLabel.tag = 2
        doneOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        
        
        doneOrderAmountCount.frame = CGRect(x: (kWidth - 200)/2, y: doneOrderLabel.frame.maxY + 3, width: 200, height: 21)
        doneOrderAmountCount.setTitle("--", for: .normal)
        doneOrderAmountCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        doneOrderAmountCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        doneOrderAmountCount.contentHorizontalAlignment = .center
        doneOrderAmountCount.contentVerticalAlignment = .center
        doneOrderAmountCount.tag = 2
        doneOrderAmountCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        orderStatisticBoard1.addSubview(doneOrderLabel)
        orderStatisticBoard1.addSubview(doneOrderAmountCount)
        
        //订单数统计 - 待支付订单
        let waitForPayOrderLabel:UIButton = UIButton.init(frame: CGRect(x: kWidth/3*2 - 4.3, y: transferAmountCount.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        waitForPayOrderLabel.setTitle("议价中订单", for: .normal)
        waitForPayOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForPayOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForPayOrderLabel.contentHorizontalAlignment = .center
        waitForPayOrderLabel.contentVerticalAlignment = .center
        waitForPayOrderLabel.tag = 3
        waitForPayOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        waitForPayOrderAmountCount.frame = CGRect(x: kWidth/3*2 - 4.3, y: waitForPayOrderLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        waitForPayOrderAmountCount.setTitle("--", for: .normal)
        waitForPayOrderAmountCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForPayOrderAmountCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForPayOrderAmountCount.contentHorizontalAlignment = .center
        waitForPayOrderAmountCount.contentVerticalAlignment = .center
        waitForPayOrderAmountCount.tag = 3
        waitForPayOrderAmountCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        
        orderStatisticBoard1.addSubview(waitForPayOrderLabel)
        orderStatisticBoard1.addSubview(waitForPayOrderAmountCount)
        
        //设计数据
        let orderStatisticBoard2:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: orderStatisticBoard1.frame.maxY + 10, width: kWidth, height: 118)) // Y+25
        orderStatisticBoard2.image = UIImage(named: "statisticboardbgimg")
        orderStatisticBoard2.isUserInteractionEnabled = true
        scrollBackView.addSubview(orderStatisticBoard2)
        
        let orangeDotImg2:UIImageView = UIImageView(frame: CGRect(x: 15, y: 14, width: 5, height: 18))
        orangeDotImg2.image = UIImage(named: "orangedotimg")
        orderStatisticBoard2.addSubview(orangeDotImg2)
        
        let designerTitle:UILabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: 100, height: 25))
        designerTitle.text = "设计数据"
        designerTitle.font = UIFont.boldSystemFont(ofSize: 16)
        designerTitle.textColor = UIColor.titleColors(color: .black)
        orderStatisticBoard2.addSubview(designerTitle)
        
        //在线设计师数量：
        let onlineIcon2:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 182, y: designerTitle.frame.minY + 3, width: 16, height: 18))
        onlineIcon2.image = UIImage(named: "onlineiconimg")
       // orderStatisticBoard2.addSubview(onlineIcon2)
        
        onlineDesignerCount.frame = CGRect(x: kWidth - 156, y: designerTitle.frame.minY, width: 138, height: 26)
        onlineDesignerCount.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        onlineDesignerCount.setTitle("在线设计师：-", for: .normal)
        onlineDesignerCount.contentHorizontalAlignment = .right
        onlineDesignerCount.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        onlineDesignerCount.tag = 2
        onlineDesignerCount.addTarget(self, action: #selector(onlineCheckBtnClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(onlineDesignerCount)
        
        let seperateLine2:UIView = UIView.init(frame: CGRect(x: 0, y: 45, width: kWidth, height: 0.5))
        seperateLine2.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        orderStatisticBoard2.addSubview(seperateLine2)
        
        // - 待接受设计
        let waitForAcceptDesignLabel:UIButton = UIButton.init(frame: CGRect(x: 0, y: seperateLine2.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        waitForAcceptDesignLabel.setTitle("待设计", for: .normal)
        waitForAcceptDesignLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForAcceptDesignLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForAcceptDesignLabel.contentHorizontalAlignment = .center
        waitForAcceptDesignLabel.contentVerticalAlignment = .center
        waitForAcceptDesignLabel.tag = 4
        waitForAcceptDesignLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(waitForAcceptDesignLabel)
        
        waitForAcceptDesignCount.frame = CGRect(x: 0, y: waitForAcceptDesignLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        waitForAcceptDesignCount.setTitle("--", for: .normal)
        waitForAcceptDesignCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForAcceptDesignCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForAcceptDesignCount.contentHorizontalAlignment = .center
        waitForAcceptDesignCount.contentVerticalAlignment = .center
        waitForAcceptDesignCount.tag = 4
        waitForAcceptDesignCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(waitForAcceptDesignCount)
        
        // - 设计中
        let designingLabel:UIButton = UIButton.init(frame: CGRect(x: (kWidth - 200)/2, y: seperateLine2.frame.maxY + 15, width: 200, height: 20))
        designingLabel.setTitle("设计中", for: .normal)
        designingLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        designingLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        designingLabel.contentHorizontalAlignment = .center
        designingLabel.contentVerticalAlignment = .center
        designingLabel.tag = 5
        designingLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(designingLabel)
        
        designningCount.frame = CGRect(x: kWidth/3, y: designingLabel.frame.maxY + 3, width: kWidth/3, height: 21)
        designningCount.setTitle("--", for: .normal)
        designningCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        designningCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        designningCount.contentHorizontalAlignment = .center
        designningCount.contentVerticalAlignment = .center
        designningCount.tag = 5
        designningCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(designningCount)
        
        // - 已定稿
        let customerConfirmedDesignLabel:UIButton = UIButton.init(frame: CGRect(x: kWidth/3*2 - 4.3, y: seperateLine2.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        customerConfirmedDesignLabel.setTitle("已定稿", for: .normal)
        customerConfirmedDesignLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        customerConfirmedDesignLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        customerConfirmedDesignLabel.contentHorizontalAlignment = .center
        customerConfirmedDesignLabel.contentVerticalAlignment = .center
        customerConfirmedDesignLabel.tag = 6
        customerConfirmedDesignLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(customerConfirmedDesignLabel)
        
        customerConfirmedCount.frame = CGRect(x: kWidth/3*2 - 4.3, y: customerConfirmedDesignLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        customerConfirmedCount.setTitle("--", for: .normal)
        customerConfirmedCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        customerConfirmedCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        customerConfirmedCount.contentHorizontalAlignment = .center
        customerConfirmedCount.contentVerticalAlignment = .center
        customerConfirmedCount.tag = 6
        customerConfirmedCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(customerConfirmedCount)
        
        //车间数据
        let orderStatisticBoard3:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: orderStatisticBoard2.frame.maxY + 10, width: kWidth, height: 180))
        orderStatisticBoard3.image = UIImage(named: "statisticboardbgimg")
        orderStatisticBoard3.isUserInteractionEnabled = true
        scrollBackView.addSubview(orderStatisticBoard3)
        
        let orangeDotImg3:UIImageView = UIImageView(frame: CGRect(x: 15, y: 14, width: 5, height: 18))
        orangeDotImg3.image = UIImage(named: "orangedotimg")
        orderStatisticBoard3.addSubview(orangeDotImg3)
        
        let producerTitle:UILabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: 100, height: 25))
        producerTitle.text = "车间数据"
        producerTitle.font = UIFont.boldSystemFont(ofSize: 16)
        producerTitle.textColor = UIColor.titleColors(color: .black)
        orderStatisticBoard3.addSubview(producerTitle)
        
        //在线车间数量：
        let onlineIcon3:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 182, y: producerTitle.frame.minY + 3, width: 16, height: 18))
        onlineIcon3.image = UIImage(named: "onlineiconimg")
      //  orderStatisticBoard3.addSubview(onlineIcon3)
        
        onlineProducerCount.frame = CGRect(x: kWidth - 156, y: producerTitle.frame.minY, width: 138, height: 26)
        onlineProducerCount.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        onlineProducerCount.setTitle("在线车间：-", for: .normal)
        onlineProducerCount.contentHorizontalAlignment = .right
        onlineProducerCount.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        onlineProducerCount.tag = 3
        onlineProducerCount.addTarget(self, action: #selector(onlineCheckBtnClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(onlineProducerCount)
        
        let seperateLine3:UIView = UIView.init(frame: CGRect(x: 0, y: 45, width: kWidth, height: 0.5))
        seperateLine3.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        orderStatisticBoard3.addSubview(seperateLine3)
        
        
        // - 待报价
        let waitForQuoteOrderLabel:UIButton = UIButton.init(frame: CGRect(x: 0, y: seperateLine3.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        waitForQuoteOrderLabel.setTitle("待报价", for: .normal)
        waitForQuoteOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForQuoteOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForQuoteOrderLabel.contentHorizontalAlignment = .center
        waitForQuoteOrderLabel.contentVerticalAlignment = .center
        waitForQuoteOrderLabel.tag = 7
        waitForQuoteOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForQuoteOrderLabel)
        
        waitForQuoteOrderCount.frame = CGRect(x: 0, y: waitForQuoteOrderLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        waitForQuoteOrderCount.setTitle("--", for: .normal)
        waitForQuoteOrderCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForQuoteOrderCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForQuoteOrderCount.contentHorizontalAlignment = .center
        waitForQuoteOrderCount.contentVerticalAlignment = .center
        waitForQuoteOrderCount.tag = 7
        waitForQuoteOrderCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForQuoteOrderCount)
        
        // - 未处理议价
        let waitForBargainOrderLabel:UIButton = UIButton.init(frame: CGRect(x: (kWidth - 200)/2, y: seperateLine3.frame.maxY + 15, width: 200, height: 20))
        waitForBargainOrderLabel.setTitle("待议价", for: .normal)
        waitForBargainOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForBargainOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForBargainOrderLabel.contentHorizontalAlignment = .center
        waitForBargainOrderLabel.contentVerticalAlignment = .center
        waitForBargainOrderLabel.tag = 8
        waitForBargainOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForBargainOrderLabel)
        
        waitForBargainOrderCount.frame = CGRect(x: kWidth/3, y: waitForBargainOrderLabel.frame.maxY + 3, width: kWidth/3, height: 21)
        waitForBargainOrderCount.setTitle("--", for: .normal)
        waitForBargainOrderCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForBargainOrderCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForBargainOrderCount.contentHorizontalAlignment = .center
        waitForBargainOrderCount.contentVerticalAlignment = .center
        waitForBargainOrderCount.tag = 8
        waitForBargainOrderCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForBargainOrderCount)
        
        
        // - 竞价未报价
        let waitForCompetionOrderLabel:UIButton = UIButton.init(frame: CGRect(x: kWidth/3*2 - 4.3, y: seperateLine3.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        waitForCompetionOrderLabel.setTitle("待竞价", for: .normal)
        waitForCompetionOrderLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForCompetionOrderLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForCompetionOrderLabel.contentHorizontalAlignment = .center
        waitForCompetionOrderLabel.contentVerticalAlignment = .center
        waitForCompetionOrderLabel.tag = 9
        waitForCompetionOrderLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForCompetionOrderLabel)
        
        waitForCompetionOrderCount.frame = CGRect(x: kWidth/3*2 - 4.3, y: waitForCompetionOrderLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        waitForCompetionOrderCount.setTitle("--", for: .normal)
        waitForCompetionOrderCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForCompetionOrderCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForCompetionOrderCount.contentHorizontalAlignment = .center
        waitForCompetionOrderCount.contentVerticalAlignment = .center
        waitForCompetionOrderCount.tag = 9
        waitForCompetionOrderCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForCompetionOrderCount)
        
        
        // - 待接受生产
        let waitForAcceptProduceLabel:UIButton = UIButton.init(frame: CGRect(x: 0, y: waitForQuoteOrderCount.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        waitForAcceptProduceLabel.setTitle("待生产", for: .normal)
        waitForAcceptProduceLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        waitForAcceptProduceLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitForAcceptProduceLabel.contentHorizontalAlignment = .center
        waitForAcceptProduceLabel.contentVerticalAlignment = .center
        waitForAcceptProduceLabel.tag = 10
        waitForAcceptProduceLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForAcceptProduceLabel)
        
        waitForProduceCount.frame = CGRect(x: 0, y: waitForAcceptProduceLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        waitForProduceCount.setTitle("--", for: .normal)
        waitForProduceCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        waitForProduceCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        waitForProduceCount.contentHorizontalAlignment = .center
        waitForProduceCount.contentVerticalAlignment = .center
        waitForProduceCount.tag = 10
        waitForProduceCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(waitForProduceCount)
        
        // - 生产中
        let producingLabel:UIButton = UIButton.init(frame: CGRect(x: (kWidth - 200)/2, y: waitForQuoteOrderCount.frame.maxY + 15, width: 200, height: 20))
        producingLabel.setTitle("生产中", for: .normal)
        producingLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        producingLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        producingLabel.contentHorizontalAlignment = .center
        producingLabel.contentVerticalAlignment = .center
        producingLabel.tag = 11
        producingLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(producingLabel)
        
        producingOrderCount.frame = CGRect(x: kWidth/3, y: producingLabel.frame.maxY + 3, width: kWidth/3, height: 21)
        producingOrderCount.setTitle("--", for: .normal)
        producingOrderCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        producingOrderCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        producingOrderCount.contentHorizontalAlignment = .center
        producingOrderCount.contentVerticalAlignment = .center
        producingOrderCount.tag = 11
        producingOrderCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(producingOrderCount)
        
        
        // - 邮寄中
        let shippingLabel:UIButton = UIButton.init(frame: CGRect(x: kWidth/3*2 - 4.3, y: waitForQuoteOrderCount.frame.maxY + 15, width: (kWidth - 28)/3, height: 20))
        shippingLabel.setTitle("待发货", for: .normal)
        shippingLabel.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        shippingLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingLabel.contentHorizontalAlignment = .center
        shippingLabel.contentVerticalAlignment = .center
        shippingLabel.tag = 12
        shippingLabel.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(shippingLabel)
        
        
        shippingOrderCount.frame = CGRect(x: kWidth/3*2 - 4.3, y: shippingLabel.frame.maxY + 3, width: (kWidth - 28)/3, height: 21)
        shippingOrderCount.setTitle("--", for: .normal)
        shippingOrderCount.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        shippingOrderCount.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 16)
        shippingOrderCount.contentHorizontalAlignment = .center
        shippingOrderCount.contentVerticalAlignment = .center
        shippingOrderCount.tag = 12
        shippingOrderCount.addTarget(self, action: #selector(orderListClicked(_:)), for: .touchUpInside)
        orderStatisticBoard3.addSubview(shippingOrderCount)
        
        //待支付的订单统计
        
        scrollBackView.addSubview(noticeOfSearch)
        scrollBackView.addSubview(titleOfPage)
        backgroundImageView.addSubview(imgBG)
        scrollBackView.addSubview(orderStatisticBoard1)
        
        scrollBackView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        
        pullStatistics()
        getOnlineStatus()

    }
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
          //  self.scrollBackView.es.removeRefreshHeader()
            self.pullStatistics()
            self.getOnlineStatus()
        }
    }
    
    @objc func orderListClicked(_ button:UIButton){
       let index = button.tag
        print(index)
        switch index {
        case 1:
            let statisticOrderListVC = StatisticOrderListViewController(with: .newCreateOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 2:
            let statisticOrderListVC = StatisticOrderListViewController(with: .dealOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 3:
            let statisticOrderListVC = StatisticOrderListViewController(with: .bargainingOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 4:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForDesignOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 5:
            let statisticOrderListVC = StatisticOrderListViewController(with: .designingOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 6:
            let statisticOrderListVC = StatisticOrderListViewController(with: .designComfirmed, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 7:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForQuotePrice, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 8:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForBargain, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 9:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForBid, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 10:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForProduce, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 11:
            let statisticOrderListVC = StatisticOrderListViewController(with: .producingOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        case 12:
            let statisticOrderListVC = StatisticOrderListViewController(with: .waitForDelivery, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        default:
            let statisticOrderListVC = StatisticOrderListViewController(with: .newCreateOrder, startTime: timeInterval_from, endTime: timeInterval_to)
            self.present(statisticOrderListVC, animated: true, completion: nil)
        }
    }
    
    @objc func onlineCheckBtnClicked(_ button:UIButton){
        let index = button.tag
        switch index {
        case 1:
            print("在线客服列表点击了")
            guard self.onlineListOfServicer != nil else{
                greyLayerPrompt.show(text: "列表获取中，请稍后再试")
                return
            }
            let desigerOnlineVC = designerOnlineStatusViewController(with: self.onlineListOfServicer, roleType: 1)
            self.present(desigerOnlineVC, animated: true, completion: nil)
        case 2:
            print("在线设计师列表点击了")
            guard self.onlineListOfDesigner != nil else{
                greyLayerPrompt.show(text: "列表获取中，请稍后再试")
                return
            }
            let desigerOnlineVC = designerOnlineStatusViewController(with: self.onlineListOfDesigner, roleType: 2)
            self.present(desigerOnlineVC, animated: true, completion: nil)
        case 3:
            print("在线车间列表点击了")
            guard self.onlineListOfFactory != nil else{
                greyLayerPrompt.show(text: "列表获取中，请稍后再试")
                return
            }
            let desigerOnlineVC = designerOnlineStatusViewController(with: self.onlineListOfFactory, roleType: 3)
            self.present(desigerOnlineVC, animated: true, completion: nil)
        default:
            print("在线客服列表点击了")
        }
    }
    @objc func changeTimeIntervalClicked(){
        print("改变时间段的按钮点击了")
        
        let timerInterval = ChooseTimeInterval(frame: CGRect(x: 0, y: kHight - heightChangeForiPhoneXFromBottom - 625, width: kWidth, height: 625))
        
//        switch chooseTimeIntervalBtn.title(for: .normal) {
//        case "最近一天":
//            timerInterval.checkStatus = [true,false,false,false,false]
//        case "最近三天":
//            timerInterval.checkStatus = [false,true,false,false,false]
//        case "最近一周":
//            timerInterval.checkStatus = [false,false,true,false,false]
//        case "本月":
//            timerInterval.checkStatus = [false,false,false,true,false]
      //  case "自定义日期":
            timerInterval.checkStatus = [false,false,false,false,true]
//        default:
//            timerInterval.checkStatus = [false,false,true,false,false]
//        }
        
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        popVC.modalPresentationCapturesStatusBarAppearance = true
        timerInterval.popupVC = popVC
        timerInterval.managerVC = self
        timerInterval.initSelectedDate(startDateTime: timeInterval_from, endDateTime: timeInterval_to)
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        popVC.view.addSubview(timerInterval)
        
        self.present(popVC, animated: true, completion: nil)

    }
    @objc func getOnlineStatus(){
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "onlineStatusAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "onlineStatusAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    self.onlineListOfDesigner.removeAll()
                    self.onlineListOfServicer.removeAll()
                    self.onlineListOfFactory.removeAll()
                    if statusCode == 200{
                        //设计师在线列表
                        for item in json["data","designUser"].array!{
                            let dicItem = item.dictionaryObject! as NSDictionary
                            self.onlineListOfDesigner.append(dicItem)
                        }
                        //客服在线列表
                        for item in json["data","serviceUser"].array!{
                            let dicItem = item.dictionaryObject! as NSDictionary
                            self.onlineListOfServicer.append(dicItem)
                        }
                        
                        //车间在线列表
                        for item in json["data","shopUser"].array!{
                            let dicItem = item.dictionaryObject! as NSDictionary
                            self.onlineListOfFactory.append(dicItem)
                        }
                        
                        let onlineCountOfDesigner = json["data","users","design","onlines"].int!
                        let onlineCountOfServicer = json["data","users","service","onlines"].int!
                        let onlineCountOfFactory = json["data","users","shop","onlines"].int!
                        
                        self.onlineDesignerCount.setTitle("在线设计师：\(onlineCountOfDesigner)", for: .normal)
                        self.onlineCustomerServiceCount.setTitle("在线客服：\(onlineCountOfServicer)", for: .normal)
                        self.onlineProducerCount.setTitle("在线车间：\(onlineCountOfFactory)", for: .normal)
        
                  //     self.onlineList
                        //
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        //                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                        LogoutMission(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        self.onlineDesignerCount.setTitle("在线设计师：-", for: .normal)
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                self.onlineDesignerCount.setTitle("在线设计师：-", for: .normal)
                greyLayerPrompt.show(text: "获取数据失败，请重试")
            }
            self.scrollBackView.es.stopPullToRefresh()
        }
    }
    @objc func searchBarTaped(){
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
    
    @objc func scanQRCodeBtnClicked(){
        let scanQRcodeVC = ScanCodeViewController(scanType: .qrCode)
        scanQRcodeVC.orderVCObject = self
        let nav = UINavigationController.init(rootViewController: scanQRcodeVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func jumpToStatisticDetail(){
        let statisticVC = StatisticViewController()
        self.present(statisticVC, animated: true, completion: nil)
    }
    
    @objc func messageListBtnClicked(){
        let msgVC = MessageListViewController()
        msgVC.OrderMainObject = self
       // msgVC.messagesList = messagesList
        //设置跳转带navigation controller的跳转
        let nav = UINavigationController(rootViewController: msgVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    func pullStatistics(){
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
       
        noticeOfSearch.isHidden = false
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        
        //let now = NSDate()
        let startTime = timeInterval_from// (Int(now.timeIntervalSince1970) - 2592000)*1000 //30天前   51840000
        let endTime = timeInterval_to//getEndDateTimeOfToday() * 1000
        
        let startDate = Date(timeIntervalSince1970: startTime)
        let endDate = Date(timeIntervalSince1970: endTime)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = .current
        //let startTimeString = formatter.string(from: startTime)
//        let startDate = NSDate(timeIntervalSince1970: startTime)
//        let endDate = NSDate(timeIntervalSince1970: endTime)
        
        params["startTime"] = formatter.string(from: startDate)
        params["endTime"] = formatter.string(from: endDate)
        header["token"] = token
        print("startTime \(formatter.string(from: startDate))")
        print("endTime \(formatter.string(from: endDate))")
        
        
            #if DEBUG
            let requestUrl = apiAddresses.value(forKey: "statisticDebug") as! String
            #else
            let requestUrl = apiAddresses.value(forKey: "statistic") as! String
            #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        let format = NumberFormatter()
                        format.numberStyle = .decimal
                        self.gudanAmountCount.text = "¥" + format.string(from: NSNumber(value: json["data","mayBePrice"].int!))!
                        self.dealAmountCount.text = "¥" + format.string(from: NSNumber(value: json["data","payPrice"].int!))!
                        
                        if json["data","createCount"].int! == 0 {
                            self.transferAmountCount.text = "--.-%"
                        }else{
//                            if json["data","ratio"].float! != nil{
//                                self.transferAmountCount.text = "\(json["data","ratio"].float! * 100)%"
//                            }
                            self.transferAmountCount.text = "\(json["data","payCount"].int!/json["data","createCount"].int!)%"
                            let ratio = (Double(json["data","payCount"].int!)/Double(json["data","createCount"].int!))*100
                            self.transferAmountCount.text = String(format: "%.1f", ratio) + "%"
                            
                        }
                        self.newOrderAmountCount.setTitle(format.string(from: NSNumber(value: json["data","createCount"].int!))!, for: .normal)
                        self.doneOrderAmountCount.setTitle(format.string(from: NSNumber(value: json["data","payCount"].int!))!, for: .normal)
                        self.waitForAcceptDesignCount.setTitle(format.string(from: NSNumber(value: json["data","designCount"].int!))!, for: .normal)
                        self.designningCount.setTitle(format.string(from: NSNumber(value: json["data","desigingCount"].int!))!, for: .normal)
                        self.customerConfirmedCount.setTitle(format.string(from: NSNumber(value: json["data","finalTextCount"].int!))!, for: .normal)
                        self.waitForPayOrderAmountCount.setTitle(format.string(from: NSNumber(value: json["data","bargainCount"].int!))!, for: .normal)
                        self.waitForProduceCount.setTitle(format.string(from: NSNumber(value: json["data","waitProductCount"].int!))!, for: .normal)
                        self.producingOrderCount.setTitle(format.string(from: NSNumber(value: json["data","periodNear"].int!))!, for: .normal)
                        self.shippingOrderCount.setTitle(format.string(from: NSNumber(value: json["data","sendGoodsCount"].int!))!, for: .normal)
                        if json["data","notQuoteYetCount"].int != nil{
                            self.waitForQuoteOrderCount.setTitle(format.string(from: NSNumber(value: json["data","notQuoteYetCount"].int!))!, for: .normal)
                        }
                        if json["data","notDealBargainYerCount"].int != nil{
                            self.waitForBargainOrderCount.setTitle(format.string(from: NSNumber(value: json["data","notDealBargainYerCount"].int!))!, for: .normal)
                        }
                        if json["data","notBidPriceYetCount"].int != nil{
                            self.waitForCompetionOrderCount.setTitle(format.string(from: NSNumber(value: json["data","notBidPriceYetCount"].int!))!, for: .normal)
                        }
                       // self.producingOrderCount.text = "\(json["data","waitPayCount"].int!)"
                        self.noticeOfSearch.isHidden = true
                //
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
            }
            self.scrollBackView.es.stopPullToRefresh()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        setStatusBarBackgroundColor(color: UIColor.clear)
        setStatusBarHiden(toHidden: true, ViewController: self)
        titleBarView.backgroundColor = UIColor.clear
        
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
                let requestURL:String = apiAddresses.value(forKey: "getMessageCountDebug") as! String
                #else
                let requestURL:String = apiAddresses.value(forKey: "getMessageCount") as! String
                #endif
                //从datacore获取用户数据
                //获取管理的数据上下文，对象
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedObjectContext = appDelegate.persistentContainer.viewContext
                
                //声明数据的请求
                let fetchRequestOfToken = NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
                //        fetchRequest.fetchOffset = 0 //查询到偏移量
                fetchRequestOfToken.returnsObjectsAsFaults = false

                // 设置查询条件
                let predicateOfToken = NSPredicate(format: "id = '1'")
                fetchRequestOfToken.predicate = predicateOfToken

                var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
                //查询操作
                do {
                    let fetchedObjects = try managedObjectContext.fetch(fetchRequestOfToken)
                    //遍历查询结果
                    for info in fetchedObjects{
                        //更新数据
                        //设置获取全部订单参数组
                        header["token"] = info.token
                        try managedObjectContext.save()
                    }
                } catch  {
                    fatalError("获取失败")
                }
                _ = Alamofire.request(requestURL, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: header) .responseJSON{
                    (responseObject) in
                    switch responseObject.result.isSuccess{
                    case true:
                        if  let value = responseObject.result.value{
                            let json = JSON(value)
                            let statusCode = json["code"].int!
                            if statusCode == 200{//正常获取消息
                                self.getMessagesCount = json["data","didntRead"].int ?? 0
                                
                                if self.getMessagesCount == 0 {
                                    self._tabBarVC.redDot.isHidden = true
                                    self.messageCountBackLabel.isHidden = true
                                }else{
                                    self._tabBarVC.redDot.isHidden = false
                                    self.messageCountBackLabel.isHidden = false
                                    if self.getMessagesCount > 99{
                                        self.messageCountLabel.text = "99+"
                                    }else{
                                        self.messageCountLabel.text = "\(self.getMessagesCount)"
                                    }
                                    if json["data","hasNewMessage"].int == 1{
                                        self.playAudio()
                                    }
                                    self.calculateWeatherNeedsAlert()
                                }
                            }else if statusCode == 99999 || statusCode == 99998{
                                //异常
                                autoLogin(viewControler: self)
//                                greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                                LogoutMission(viewControler: self)
                            }else{ //获取消息失败
                                self._tabBarVC.redDot.isHidden = true
                                self.messageCountBackLabel.isHidden = true
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
//        var messageAlertArray:[Bool] = []
//        print("begain to calculate")
//        isNeedsAlert = false
//        var AlertFrequencyValue = 0
//        //var isTheAlertPlayedThisRound = false
//        //遍历当前获取到的列表里的所有
//        currentMessagesTypeList.removeAll()
//        currentMessagesIDList.removeAll()
//        for i in 0..<messagesList.count{
//            let mSGType = messagesList[i].value(forKey: "msgtype") as! Int
//            let mSGID = messagesList[i].value(forKey: "msgid") as! String
//            currentMessagesTypeList.append(mSGType)
//            currentMessagesIDList.append(mSGID)
//        }
//        for i in 0..<26{
//            messageAlertArray.append(getMSGAlertSettings(index: i))
//        }
//        print("get Array finised")
//        //第一次获取消息,直接判断是不是需要提醒
//        if previewsMessagesIDList.count == 0{
//
//            //遍历当前消息列表中的消息类型,以此得到是否需要提醒
//            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
//            for msgType in currentMessagesTypeList{
//                let tempAlertTag = messageAlertArray[msgType] //getMSGAlertSettings(index: msgType)
//                //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
//                needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
//            }
//
//            //获取当前设置，决定是否需要提醒，以及提醒多少次
//            let frequency = getMsgVoiceAlertFrequencyWeight()
//            print(frequency)
//            if frequency == 1{
//                // 不提醒
//                isNeedsAlert = false
//                AlertFrequencyValue = 0
//            }else if frequency == 10{
//                //提醒一次
//                //
//                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
//                AlertFrequencyValue = 1
//            }else{
//                //提醒多次
//                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
//                for msgType in currentMessagesTypeList{
//                    let tempAlertTag = messageAlertArray[msgType]//getMSGAlertSettings(index: msgType)
//                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
//                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
//                }
//                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
//                AlertFrequencyValue = 10
//            }
//
//            //将当前获取的列表替换到上次的列表中，以便下次比对
//            previewsMessagesIDList.removeAll()
//            previewsMessagesIDList = currentMessagesIDList
//        }else{ //不是第一次获取消息了
//            var itemID = 0
//            var needsAlertFromCurrentAlertSettingForTargetMSGType = false
//            for id in currentMessagesIDList{
//                if !previewsMessagesIDList.contains(id){//这条消息不包含在之前的消息里
//                    //如果这条消息不在列表里，那么取对应的消息ID查询结果，并与定义的需要提醒取或，只要有一条消息需要提醒，那么值将会是true
//                    needsAlertFromCurrentAlertSettingForTargetMSGType =  needsAlertFromCurrentAlertSettingForTargetMSGType || messageAlertArray[currentMessagesTypeList[itemID]] /*getMSGAlertSettings(index: currentMessagesTypeList[itemID]*/
//                }
//                itemID += 1
//            }
//            //获取当前设置，决定是否需要提醒，以及提醒多少次
//            let frequency = getMsgVoiceAlertFrequencyWeight()
//            print(frequency)
//            if frequency == 1{
//                // 不提醒
//                isNeedsAlert = false
//                AlertFrequencyValue = 0
//            }else if frequency == 10{
//                //提醒一次
//                //
//                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
//                AlertFrequencyValue = 1
//            }else{
//                //提醒多次
//                //重新设置 needsAlertFromCurrentAlertSettingForTargetMSGType 值，遍历当前列表
//                for msgType in currentMessagesTypeList{
//                    let tempAlertTag = messageAlertArray[msgType] // getMSGAlertSettings(index: msgType)
//                    //将获取到的设置与变量取或： 如果有任何一个设置的为需要提醒，那么值将会得到True
//                    needsAlertFromCurrentAlertSettingForTargetMSGType = needsAlertFromCurrentAlertSettingForTargetMSGType||tempAlertTag
//                }
//                isNeedsAlert = true && needsAlertFromCurrentAlertSettingForTargetMSGType
//                AlertFrequencyValue = 10
//            }
//        }
//
//        if isNeedsAlert == true{
//            if (AlertFrequencyValue == 1) && (isTheAlertPlayed == false){
//                playAudio()
//                isTheAlertPlayed = true
//            }else if AlertFrequencyValue == 10{
//                playAudio()
//            }
//        }
        
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
