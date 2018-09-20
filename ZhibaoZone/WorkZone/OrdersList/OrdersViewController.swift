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
    
    //消息数目
    let messageCountBackLabel:UIView = UIView.init(frame: CGRect(x: 50, y: -5, width: 22, height: 16))
    let messageCountLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 22, height: 16))
    
    //用户角色
    var _roleType = 1
    lazy var scrollBackView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight - heightChangeForiPhoneXFromBottom - 49))
        tempScrollView.contentSize = CGSize(width: kWidth, height: 770 )
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
    var gudanAmountCount:UILabel = UILabel.init() // 估单
    var dealAmountCount:UILabel = UILabel.init() //成交
    var transferAmountCount:UILabel = UILabel.init() //成交转化
    var newOrderAmountCount:UILabel = UILabel.init() // 新建订单数量
    var doneOrderAmountCount:UILabel = UILabel.init() // 成交订单
    var waitForPayOrderAmountCount:UILabel = UILabel.init()//待支付订单
    var waitForAcceptDesignCount:UILabel = UILabel.init()
    var designningCount:UILabel = UILabel.init()
    var customerConfirmedCount:UILabel = UILabel.init()
    var waitForProduceCount:UILabel = UILabel.init()
    var producingOrderCount:UILabel = UILabel.init()
    var shippingOrderCount:UILabel = UILabel.init()
    //时间统计范围
    var timeInterval_from:String = "1244411144444"
    var timeInterval_to:String = "1244411144444"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置状态栏颜色
        setStatusBarBackgroundColor(color: UIColor.clear)
        let userinfos = getCurrentUserInfo()
        _roleType = Int(userinfos.value(forKey: "roletype") as! String)!
        
        backgroundImageView.image = UIImage(named: "titlebackgroundimg")
        self.view.addSubview(backgroundImageView)
        self.view.sendSubview(toBack: backgroundImageView)
        
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
        titleBarView.backgroundColor = UIColor.clear
        
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
        searchBarInOrders.backgroundColor = UIColor.backgroundColors(color: .white)
        //searchBarInOrders.layer.backgroundColor = UIColor.colorWithRgba(236, g: 133, b: 133, a: 1.0).cgColor
        searchBarInOrders.layer.cornerRadius = 6
        let searchBarHintText:UILabel = UILabel.init(frame: CGRect(x: searchBarInOrders.frame.width/2 - 50, y: 0, width: 100, height: 28))
        searchBarHintText.text = "搜索订单号"
        searchBarHintText.textAlignment = .center
        searchBarHintText.textColor = UIColor.titleColors(color: .darkGray)
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
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        self.view.addSubview(scrollBackView)
        pullStatistics()
        //编辑订单请先搜索后进行操作
        let noticeOfSearch:UIImageView = UIImageView.init(frame: CGRect(x: (kWidth - 201)/2, y: 64 + heightChangeForiPhoneXFromTop, width: 201, height: 17))
        noticeOfSearch.image = UIImage(named: "noticeofsearchhintimg")
        //数据统计title
        let titleOfPage:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: noticeOfSearch.frame.maxY + 30, width: 97, height: 23))
        titleOfPage.image = UIImage(named: "statisticnamelabelimg")
        
        let imgBG:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 210, y: noticeOfSearch.frame.maxY + 5, width: 156, height: 102))
        imgBG.image = UIImage(named: "statisticbgimg")
        
        let dashLine:UIView = UIView.init(frame: CGRect(x: 15, y: titleOfPage.frame.maxY + 5, width: kWidth - 30, height: 1))
        dashLine.backgroundColor = UIColor.backgroundColors(color: .lightestgray)// titleColors(color: .lightGray)
        
        //时间切换
        let chooseTimeIntervalBtn:UIButton = UIButton.init(type: .custom)
        chooseTimeIntervalBtn.setTitle("最近一天", for: .normal)
        chooseTimeIntervalBtn.frame = CGRect(x: titleOfPage.frame.maxX + 12, y: titleOfPage.frame.minY, width: 80, height: 23)
        chooseTimeIntervalBtn.contentVerticalAlignment = .center
        chooseTimeIntervalBtn.contentHorizontalAlignment = .left
        chooseTimeIntervalBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        chooseTimeIntervalBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        chooseTimeIntervalBtn.addTarget(self, action: #selector(changeTimeIntervalClicked), for: .touchUpInside)
        let downArrowImg:UIImageView = UIImageView.init(frame: CGRect(x: 55, y: 9, width: 9, height: 5))
        downArrowImg.image = UIImage(named: "down-arrow-white")
        chooseTimeIntervalBtn.addSubview(downArrowImg)
        scrollBackView.addSubview(chooseTimeIntervalBtn)
        
        let transparentBGboard1:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 200, width: kWidth, height: 195))
        transparentBGboard1.image = UIImage(named: "transparencybgimg")
        scrollBackView.addSubview(transparentBGboard1)
        
        let orderStatisticBoard1:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: dashLine.frame.maxY + 10, width: kWidth - 4, height: 135))
        orderStatisticBoard1.image = UIImage(named: "statisticboardbgimg")
        orderStatisticBoard1.isUserInteractionEnabled = true
        
        let customerServiceTitle:UILabel = UILabel.init(frame: CGRect(x: 21, y: 20, width: 100, height: 25))
        customerServiceTitle.text = "客服数据"
        customerServiceTitle.font = UIFont.systemFont(ofSize: 18)
        customerServiceTitle.textColor = UIColor.titleColors(color: .black)
        orderStatisticBoard1.addSubview(customerServiceTitle)
        
        //在线客服数量：
        onlineCustomerServiceCount.frame = CGRect(x: kWidth - 156, y: customerServiceTitle.frame.minY, width: 138, height: 26)
        onlineCustomerServiceCount.setTitleColor(UIColor.lineColors(color: .gray), for: .normal)
        onlineCustomerServiceCount.setTitle("在线客服：9999+", for: .normal)
        onlineCustomerServiceCount.contentHorizontalAlignment = .center
        onlineCustomerServiceCount.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        onlineCustomerServiceCount.layer.cornerRadius = 14
        onlineCustomerServiceCount.layer.borderColor = UIColor.lineColors(color: .gray).cgColor
        onlineCustomerServiceCount.layer.borderWidth = 0.5
        onlineCustomerServiceCount.tag = 1
        onlineCustomerServiceCount.addTarget(self, action: #selector(onlineCheckBtnClicked(_:)), for: .touchUpInside)
        orderStatisticBoard1.addSubview(onlineCustomerServiceCount)
        
        //估单金额统计
        let gudanAmountTitle:UIImageView = UIImageView.init(frame: CGRect(x: 21, y: customerServiceTitle.frame.maxY + 18, width: 85, height: 25))
        gudanAmountTitle.image = UIImage(named: "gudanamountimg")
        
        gudanAmountCount.frame = CGRect(x: 23, y: gudanAmountTitle.frame.maxY + 9, width: kWidth/3, height: 21)
        gudanAmountCount.textAlignment = .left
        gudanAmountCount.textColor = UIColor.titleColors(color: .black)
        gudanAmountCount.text = "¥99,122.00"
        gudanAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(gudanAmountTitle)
        orderStatisticBoard1.addSubview(gudanAmountCount)
        
        //成交金额统计
        let dealAmonuntTitle:UIImageView = UIImageView.init(frame: CGRect(x: (kWidth - 85)/2, y: customerServiceTitle.frame.maxY + 18, width: 85, height: 25))
        dealAmonuntTitle.image = UIImage(named: "dealamonuntimg")
        
        dealAmountCount.frame = CGRect(x: (kWidth - 85)/2 + 2, y: gudanAmountTitle.frame.maxY + 9, width: kWidth/3, height: 21)
        dealAmountCount.textAlignment = .left
        dealAmountCount.textColor = UIColor.titleColors(color: .black)
        dealAmountCount.text = "¥99,122.00"
        dealAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(dealAmonuntTitle)
        orderStatisticBoard1.addSubview(dealAmountCount)
        
        //成交转化
        let transferAmountLabel:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 106, y: customerServiceTitle.frame.maxY + 18, width: 85, height: 25))
        transferAmountLabel.image = UIImage(named: "transferamountimg")
        
        transferAmountCount.frame = CGRect(x: kWidth - 104, y: gudanAmountTitle.frame.maxY + 9, width: kWidth/3, height: 21)
        transferAmountCount.textAlignment = .left
        transferAmountCount.textColor = UIColor.titleColors(color: .black)
        transferAmountCount.text = "32.2%"
        transferAmountCount.font = UIFont(name: "DINPro-Medium", size: 16)
        
        orderStatisticBoard1.addSubview(transferAmountLabel)
        orderStatisticBoard1.addSubview(transferAmountCount)
        
        //订单数统计 - 新建订单
        let newOrderStoryBoard:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: orderStatisticBoard1.frame.maxY , width: 129, height: 75 * 129 / 119))
        newOrderStoryBoard.image = UIImage(named: "neworderbgimg")
        
        
        let newOrderLabel:UILabel = UILabel.init(frame: CGRect(x: 12, y: newOrderStoryBoard.frame.height - 32, width: 70, height: 20))
        newOrderLabel.text = "新建订单"
        newOrderLabel.textColor = UIColor.titleColors(color: .darkGray)
        newOrderLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        newOrderAmountCount.frame = CGRect(x: 12, y: 20, width: newOrderStoryBoard.frame.width, height: 28)
        newOrderAmountCount.textAlignment = .left
        newOrderAmountCount.textColor = UIColor.titleColors(color: .black)
        newOrderAmountCount.text = "1392881"
        newOrderAmountCount.font = UIFont(name: "DINPro-Medium", size: 22)
        
        scrollBackView.addSubview(newOrderStoryBoard)
        newOrderStoryBoard.addSubview(newOrderLabel)
        newOrderStoryBoard.addSubview(newOrderAmountCount)
        
        //订单数统计 - 成交订单
        let doneOrderStoryBoard:UIImageView = UIImageView.init(frame: CGRect(x: (kWidth - 129)/2, y: orderStatisticBoard1.frame.maxY , width: 129, height: 75 * 129 / 119))
        doneOrderStoryBoard.image = UIImage(named: "doneorderbgimg")
        
        
        let doneOrderLabel:UILabel = UILabel.init(frame: CGRect(x: 12, y: doneOrderStoryBoard.frame.height - 32, width: 70, height: 20))
        doneOrderLabel.text = "成交订单"
        doneOrderLabel.textColor = UIColor.titleColors(color: .darkGray)
        doneOrderLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        doneOrderAmountCount.frame = CGRect(x: 12, y: 20, width: doneOrderStoryBoard.frame.width, height: 28)
        doneOrderAmountCount.textAlignment = .left
        doneOrderAmountCount.textColor = UIColor.titleColors(color: .black)
        doneOrderAmountCount.text = "1392881"
        doneOrderAmountCount.font = UIFont(name: "DINPro-Medium", size: 22)
        
        scrollBackView.addSubview(doneOrderStoryBoard)
        doneOrderStoryBoard.addSubview(doneOrderLabel)
        doneOrderStoryBoard.addSubview(doneOrderAmountCount)
        
        //订单数统计 - 待支付订单
        let waitForPayOrderStoryBoard:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 134, y: orderStatisticBoard1.frame.maxY, width: 129, height: 75 * 129 / 119))
        waitForPayOrderStoryBoard.image = UIImage(named: "waitforpayorderbgimg")
        
        
        let waitForPayOrderLabel:UILabel = UILabel.init(frame: CGRect(x: 12, y: waitForPayOrderStoryBoard.frame.height - 32, width: 100, height: 20))
        waitForPayOrderLabel.text = "待支付订单"
        waitForPayOrderLabel.textColor = UIColor.titleColors(color: .darkGray)
        waitForPayOrderLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        waitForPayOrderAmountCount.frame = CGRect(x: 12, y: 20, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        waitForPayOrderAmountCount.textAlignment = .left
        waitForPayOrderAmountCount.textColor = UIColor.titleColors(color: .black)
        waitForPayOrderAmountCount.text = "1392881"
        waitForPayOrderAmountCount.font = UIFont(name: "DINPro-Medium", size: 22)
        
        scrollBackView.addSubview(waitForPayOrderStoryBoard)
        waitForPayOrderStoryBoard.addSubview(waitForPayOrderLabel)
        waitForPayOrderStoryBoard.addSubview(waitForPayOrderAmountCount)
        
        //设计数据
        let transparentBGboard2:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: transparentBGboard1.frame.maxY + 10, width: kWidth, height: kWidth * 180 / 375))
        transparentBGboard2.image = UIImage(named: "transparencybgimg")
        scrollBackView.addSubview(transparentBGboard2)
        
        let orderStatisticBoard2:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: transparentBGboard1.frame.maxY + 25, width: kWidth - 4, height: (kWidth - 4) * 150 / 355))
        orderStatisticBoard2.image = UIImage(named: "designdataboardimg")
        orderStatisticBoard2.isUserInteractionEnabled = true
        scrollBackView.addSubview(orderStatisticBoard2)
        
        //在线设计师数量：
        onlineDesignerCount.frame = CGRect(x: kWidth - 156, y: 5, width: 138, height: 26)
        onlineDesignerCount.setTitleColor(UIColor.lineColors(color: .gray), for: .normal)
        onlineDesignerCount.setTitle("在线设计师：999+", for: .normal)
        onlineDesignerCount.contentHorizontalAlignment = .center
        onlineDesignerCount.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        onlineDesignerCount.layer.cornerRadius = 14
        onlineDesignerCount.layer.borderColor = UIColor.lineColors(color: .gray).cgColor
        onlineDesignerCount.layer.borderWidth = 0.5
        onlineDesignerCount.tag = 2
        onlineDesignerCount.addTarget(self, action: #selector(onlineCheckBtnClicked(_:)), for: .touchUpInside)
        orderStatisticBoard2.addSubview(onlineDesignerCount)
        
        // - 待接受设计
        let waitForAcceptDesignLabel:UILabel = UILabel.init(frame: CGRect(x: newOrderLabel.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        waitForAcceptDesignLabel.text = "待接受设计"
        waitForAcceptDesignLabel.textColor = UIColor.titleColors(color: .gray)
        waitForAcceptDesignLabel.textAlignment = .center
        waitForAcceptDesignLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard2.addSubview(waitForAcceptDesignLabel)
        
        waitForAcceptDesignCount.frame = CGRect(x: newOrderLabel.frame.minX, y: waitForAcceptDesignLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        waitForAcceptDesignCount.textAlignment = .center
        waitForAcceptDesignCount.textColor = UIColor.titleColors(color: .black)
        waitForAcceptDesignCount.text = "1392881"
        waitForAcceptDesignCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard2.addSubview(waitForAcceptDesignCount)
        
        // - 设计中
        let designingLabel:UILabel = UILabel.init(frame: CGRect(x: doneOrderStoryBoard.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        designingLabel.text = "设计中"
        designingLabel.textColor = UIColor.titleColors(color: .gray)
        designingLabel.textAlignment = .center
        designingLabel.font = UIFont.systemFont(ofSize: 14)
        orderStatisticBoard2.addSubview(designingLabel)
        
        designningCount.frame = CGRect(x: doneOrderStoryBoard.frame.minX, y: designingLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        designningCount.textAlignment = .center
        designningCount.textColor = UIColor.titleColors(color: .black)
        designningCount.text = "1392881"
        designningCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard2.addSubview(designningCount)
        
        // - 已定稿
        let customerConfirmedDesignLabel:UILabel = UILabel.init(frame: CGRect(x: waitForPayOrderStoryBoard.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        customerConfirmedDesignLabel.text = "已定稿"
        customerConfirmedDesignLabel.textColor = UIColor.titleColors(color: .gray)
        customerConfirmedDesignLabel.font = UIFont.systemFont(ofSize: 14)
        customerConfirmedDesignLabel.textAlignment = .center
        orderStatisticBoard2.addSubview(customerConfirmedDesignLabel)
        
        customerConfirmedCount.frame = CGRect(x: waitForPayOrderStoryBoard.frame.minX, y: customerConfirmedDesignLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        customerConfirmedCount.textAlignment = .center
        customerConfirmedCount.textColor = UIColor.titleColors(color: .black)
        customerConfirmedCount.text = "1392881"
        customerConfirmedCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard2.addSubview(customerConfirmedCount)
        
        //生产数据
        let transparentBGboard3:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: transparentBGboard2.frame.maxY + 7, width: kWidth, height: kWidth * 180 / 375))
        transparentBGboard3.image = UIImage(named: "transparencybgimg")
        scrollBackView.addSubview(transparentBGboard3)
        
        let orderStatisticBoard3:UIImageView = UIImageView.init(frame: CGRect(x: 2, y: transparentBGboard2.frame.maxY + 25, width: kWidth - 4, height: (kWidth - 4) * 150 / 355))
        orderStatisticBoard3.image = UIImage(named: "produceboardimg")
        scrollBackView.addSubview(orderStatisticBoard3)
        // - 待接受生产
        let waitForAcceptProduceLabel:UILabel = UILabel.init(frame: CGRect(x: newOrderLabel.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        waitForAcceptProduceLabel.text = "待接受生产"
        waitForAcceptProduceLabel.textColor = UIColor.titleColors(color: .gray)
        waitForAcceptProduceLabel.font = UIFont.systemFont(ofSize: 14)
        waitForAcceptProduceLabel.textAlignment = .center
        orderStatisticBoard3.addSubview(waitForAcceptProduceLabel)
        
        waitForProduceCount.frame = CGRect(x: newOrderLabel.frame.minX, y: waitForAcceptProduceLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        waitForProduceCount.textAlignment = .center
        waitForProduceCount.textColor = UIColor.titleColors(color: .black)
        waitForProduceCount.text = "1392881"
        waitForProduceCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard3.addSubview(waitForProduceCount)
        
        // - 生产中
        let producingLabel:UILabel = UILabel.init(frame: CGRect(x: doneOrderStoryBoard.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        producingLabel.text = "生产中"
        producingLabel.textColor = UIColor.titleColors(color: .gray)
        producingLabel.font = UIFont.systemFont(ofSize: 14)
        producingLabel.textAlignment = .center
        orderStatisticBoard3.addSubview(producingLabel)
        
        producingOrderCount.frame = CGRect(x: doneOrderStoryBoard.frame.minX, y: producingLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        producingOrderCount.textAlignment = .center
        producingOrderCount.textColor = UIColor.titleColors(color: .black)
        producingOrderCount.text = "1392881"
        producingOrderCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard3.addSubview(producingOrderCount)
        
        // - 邮寄中
        let shippingLabel:UILabel = UILabel.init(frame: CGRect(x: waitForPayOrderStoryBoard.frame.minX, y: 60, width: doneOrderStoryBoard.frame.width, height: 20))
        shippingLabel.text = "邮寄中"
        shippingLabel.textColor = UIColor.titleColors(color: .gray)
        shippingLabel.font = UIFont.systemFont(ofSize: 14)
        shippingLabel.textAlignment = .center
        orderStatisticBoard3.addSubview(shippingLabel)
        
        shippingOrderCount.frame = CGRect(x: waitForPayOrderStoryBoard.frame.minX, y: shippingLabel.frame.maxY + 11, width: waitForPayOrderStoryBoard.frame.width, height: 28)
        shippingOrderCount.textAlignment = .center
        shippingOrderCount.textColor = UIColor.titleColors(color: .black)
        shippingOrderCount.text = "1392881"
        shippingOrderCount.font = UIFont(name: "DINPro-Medium", size: 22)
        orderStatisticBoard3.addSubview(shippingOrderCount)
        
        //待支付的订单统计
        
        scrollBackView.addSubview(noticeOfSearch)
        scrollBackView.addSubview(titleOfPage)
        backgroundImageView.addSubview(imgBG)
        scrollBackView.addSubview(orderStatisticBoard1)

    }
    @objc func onlineCheckBtnClicked(_ button:UIButton){
        let index = button.tag
        if index == 1{
            print("在线客服列表点击了")
        }else{
            print("在线设计师列表点击了")
        }
    }
    @objc func changeTimeIntervalClicked(){
        print("改变时间段的按钮点击了")
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
    @objc func messageListBtnClicked(){
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
                        self.gudanAmountCount.text = "\(workFlows[0].value(forKey: "num") as! Int)"
                        self.producingOrderCount.text = "\(workFlows[7].value(forKey: "num") as! Int)"
                        self.shippingOrderCount.text = "\(workFlows[8].value(forKey: "num") as! Int)"
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
        setStatusBarBackgroundColor(color: UIColor.clear)
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
        for i in 0..<26{
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
