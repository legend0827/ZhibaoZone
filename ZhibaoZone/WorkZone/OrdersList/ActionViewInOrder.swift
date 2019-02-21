//
//  ActionViewInOrder.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire


class ActionViewInOrder: UIView,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LeaveMsgContentTableViewCell.customCell(tableView: leaveMsgListTableView)
        cell.selectionStyle = .none
        return cell
    }
    
    //弹窗ViewVC
    var popupVC = PopupViewController()
    
    //键盘页面
    var calculatorView = calculatorKeyboard(frame: CGRect(x: 0, y: 100, width: kWidth, height: 416))
    
    //订单请求参数
    var _roleType:Int = 1
    var _token:String?
    var _userId:String?
    var _actionType:actionType = .quotePrice
    var _isBidding = false
    var initQuotePriceInfos:[NSDictionary] = []
    
    lazy var allOrderVC = AllOrdersViewController(orderlistType: orderListCategoryType.allOrderCategory)
    //页面frame
    var _frame:CGRect = CGRect(x: 198, y: 50, width: 150, height: 30)
   
    var _orderID:String = "110000"
    var _customID:String =  "10002020"
    
    //发货的时候显示的订单图
    var googsImge:UIImage = UIImage()
   
    //订单详情获取到了吗？
    var isOrderDetailsGets = false
    var isBudgetOver = false
    var isProduceCycleOver = false //
    //获取订单截止工期
    var deadline = 0
    //客户心理价
    var mindPrice:Float = 0.0
    
    //订单详情：
    var orderDetail:[AnyObject] = []
    //订单设计稿：
    var orderDesignPartten:[NSDictionary] = []
    //订单留言：
    var orderMessages:[NSDictionary] = []
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    //附件图片下载地址
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    //参考图列表
    var memoPictures:[UIImage] = []
    //参考图类型
    var previewTypes:[String] = []
    //物流公司名称
    var shippingCompanyNameValue:UILabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: kWidth - 40, height: 25))
    let shippingCodeValue:UITextField = UITextField.init(frame: CGRect(x: 120, y: 20, width: kWidth - 140, height: 25))
    var shippingCompanyNameValueCode = "DBL"
    
    //页面元素
    let ActionTitle:UILabel = UILabel.init(frame: CGRect(x: kWidth/2 - 38, y: 20, width: 72, height: 25))
    let cancelBtn:UIButton = UIButton.init(type: .custom)
    let confirmShippingBtn:UIButton = UIButton.init(type: .custom)
    let backgroundView:UIScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
   
    //报价窗口变量定义
    var quotePriceWeight = 1
    //mark  3 字 y = 60, 4字 y = 75
    let orderTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 50, width: 200, height: 30))
    let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 198, y: 50, width: 150, height: 30))
    let orderIDValue:UILabel = UILabel.init(frame: CGRect(x: 198, y: 50, width: 150, height: 30))

    //参考图
    let orderDefaultPic: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 75, width: 100, height: 100))
    //点击预览层
    let orderDefaultPicLayer:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 80, width: 100, height: 20))

    //产品类型
    let productTypeNameValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 175, width: 250, height: 30))
    //工艺
    let makeStyleValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 200, width: 280, height: 30))
    //附件材质
    let materialAccessoriesValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 225, width: 280, height: 30))
    
    
    //订购数目
    let orderCountValue:UILabel = UILabel.init(frame: CGRect(x: 160, y: 75, width: 100, height: 30))
    //产品尺寸
    //长
    // x: 190
    let productSizeValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))
    let productSizeHint:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))

    let quotePriceAtLastLabel:UILabel = UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
    let quotePriceAtLastTimeValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
    
    let quotePriceCurentLabel:UILabel =  UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
    
    let budgetPriceValue:UILabel = UILabel.init(frame: CGRect(x: 225, y: 295, width: 200, height: 44))
    let budgetPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))
    let budgetOveredLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))
    let overBudgetBackgroundView:UIView = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))

    //let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 65, y: 285, width: 200, height: 44))
    let setQuotePriceWeightBtn:UIButton = UIButton.init(type: .system)
    
    let quotePriceSlideBarRightLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    let quotePriceSlideBarMidLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 320, height: 30))
    let quotePriceSlideBarLeftLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 250, height: 30))
    
    let dashLine:UIImageView = UIImageView.init()
    let seperateLine2:UIView = UIView.init(frame: CGRect(x: 0, y: 1, width: kWidth, height: 5))
    let seperateLine3:UIView = UIView.init(frame: CGRect(x: 0, y: 2, width: kWidth, height: 5))
    let seperateLine4:UIView = UIView.init(frame: CGRect(x: 20, y: 3, width: kWidth - 40, height: 2))
    let seperateLine5:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    let seperateLine6:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    let seperateLine7:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    let seperateLine8:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    let seperateLine9:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    
    
    let quotePriceSubmitBtn:UIButton = UIButton.init(type: .custom)
    let bargainPriceSubmitBtn:UIButton = UIButton.init(type: .custom)
    let acceptDesignConfirmBtn:UIButton = UIButton.init(type: .custom)
    let acceptProduceConfirmBtn:UIButton = UIButton.init(type: .custom)
    
    //生产工期Label
    let isProduceCycleOverView:UIView = UIView.init(frame: CGRect(x:0, y: 0 , width: 110, height: 54))
    let produceTimeCostLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    let isProduceCycleOverLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let deadlineLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //接受生产
    let produceMemoLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let ProduceMemoValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let produceTimeCostBackgroundView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 52))
    let orderPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let orderPriceValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //接受设计
    let designMemoLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let designMemoValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    //let modifyMemoLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  //  let modifyMemoValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let designFeeLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //当前设计稿title
    lazy var currentDesignParttenTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tempLabel.text = "当前设计稿:"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
    //当前设计稿图片
    lazy var currentDesignParttenImageView:UIImageView = {
        let tempView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tempView.image = UIImage(named: "havenoimgyetimg")
        tempView.layer.borderColor = UIColor.lightGray.cgColor
        tempView.layer.borderWidth = 0.5
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = 6
        return tempView
    }()
    
    //当前沟通版本
    lazy var messageContactNumTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tempLabel.text = "留言·设计前沟通中"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
        //设置设计备注，订单备注输入框
    lazy var orderMemosForDesignOrProducer:UILabel = {
            //label值55，当前值62 差 7
            var tempLabel = UILabel.init(frame: CGRect(x: 15, y: 335+24, width: 320, height: 85))
            tempLabel.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            tempLabel.layer.cornerRadius = 5
            tempLabel.font = UIFont.systemFont(ofSize: 14)
            tempLabel.textColor = UIColor.black
            //tempLabel.textAlignment = NSTextAlignment.left
            tempLabel.lineBreakMode = .byTruncatingTail
            tempLabel.numberOfLines = 4
            tempLabel.textAlignment = .justified
            return tempLabel
        }()
    
        //报价的滑动条
    lazy var quotePriceSlideBar:UISlider = {
            var tempSliderBar = UISlider.init(frame: CGRect(x: 15, y: 390, width: 320, height: 20))
            return tempSliderBar
        }()
    
        //设置生产工期输入框
    lazy var produceTimeCostTextField:UITextField = {
            //label值55，当前值62 差 7
            var tempSliderTextField = UITextField.init(frame: CGRect(x: 250, y: 342, width: 56, height: 30))
            tempSliderTextField.backgroundColor = UIColor.clear//UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            tempSliderTextField.layer.cornerRadius = 5
            tempSliderTextField.delegate = self
            tempSliderTextField.keyboardType = .numberPad
            return tempSliderTextField
        }()
    
        //当前设置报价框
        lazy var currentValueOnSliderTextField:UILabel = {
            //label值55，当前值62 差 7
            var tempSliderTextField = UILabel.init(frame: CGRect(x: 110, y: 342, width: 86, height: 30)) // width 225 。 位置 335
            tempSliderTextField.backgroundColor = UIColor.clear//UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            tempSliderTextField.layer.cornerRadius = 5
            return tempSliderTextField
        }()
    
        //留言表格
    lazy var leaveMsgListTableView:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 51, width: kWidth, height: 200))
        tempTableView.delegate = self
        tempTableView.dataSource = self
        return tempTableView
    }()
        override init(frame: CGRect) {
        super.init(frame: frame)
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
        _userId = userInfos.value(forKey: "userid") as? String
        _token = userInfos.value(forKey: "token") as? String
        _frame = frame
        
        //获取System Parameter信息
        systemParam = getSystemParasFromPlist()
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
//        #if DEBUG
//            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
//        #else
//            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
//        #endif
        #if DEBUG
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
            downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnailDebug") as! String
        #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
            downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnail") as! String
        #endif
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func getOrderDetailFromServer(){
        DispatchQueue.global(qos: .background).async {
            self.getOrderDetails(OrderID: self._orderID, CustomID: self._customID)
        }
    }
    
    
    //使用ActionType创建View
    func createViewWithActionType(ActionType:actionType){
        //设置点击类型值
        _actionType = ActionType
        
        self.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //初始化值
        ActionTitle.frame  = CGRect(x: 30, y: 20, width: kWidth - 60, height: 25)
        ActionTitle.font = UIFont.systemFont(ofSize: 17)
        ActionTitle.textColor = UIColor.titleColors(color: .black)
        ActionTitle.textAlignment = .center
        self.addSubview(ActionTitle)
        
        //取消按钮
        cancelBtn.frame = CGRect(x: kWidth - 80, y: 22, width: 60, height: 22)
        cancelBtn.setTitle("关闭", for: .normal)
        cancelBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.contentHorizontalAlignment = .right
        cancelBtn.addTarget(self, action: #selector(closeActionView), for: .touchUpInside)
        self.addSubview(cancelBtn)
        //背景页面值
        
        backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height - 207 - heightChangeForiPhoneXFromBottom)
        backgroundView.contentSize = CGSize(width: kWidth, height: 661 + 166)
        //backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height )
        backgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
        backgroundView.delegate = self
        backgroundView.isDirectionalLockEnabled = true
        backgroundView.isScrollEnabled = true
        backgroundView.showsHorizontalScrollIndicator = false
        backgroundView.showsVerticalScrollIndicator = false
        backgroundView.setContentOffset(CGPoint(x: 0, y: 20),animated: true)// (10, 20), animated: false)
        backgroundView.scrollRectToVisible(CGRect(x:0, y:0, width:100, height:300), animated: false)
        self.addSubview(backgroundView)
        
        orderIDLabel.frame = CGRect(x: 20, y: 12, width: 200, height: 20)
        orderIDLabel.font = UIFont.systemFont(ofSize: 14)
        orderIDLabel.textColor = UIColor.titleColors(color: .black)
        orderIDLabel.text = "订单号:"
        backgroundView.addSubview(orderIDLabel)
        
        orderIDValue.frame = CGRect(x: 70, y: 12, width: 200, height: 20)
        orderIDValue.font = UIFont.systemFont(ofSize: 14)
        orderIDValue.textColor = UIColor.titleColors(color: .black)
        backgroundView.addSubview(orderIDValue)
        
        orderIDValue.text = "000000000" // for debug
        
        
        if ActionType != .shippingProduct { //如果不是点击的邮寄投递，那么执行
            getOrderDetailFromServer()
            
          //  self.layer.cornerRadius = 20
            
            //订单时间
            orderTimeLabel.frame = CGRect(x: kWidth - 220, y: 12, width: 200, height: 20)
            orderTimeLabel.font = UIFont.systemFont(ofSize: 14)
            orderTimeLabel.textColor = UIColor.titleColors(color: .gray)
            orderTimeLabel.textAlignment = .right
            orderTimeLabel.text = "2017-10-16 09:00:00" // for debug
            backgroundView.addSubview(orderTimeLabel)
            
            let seperateLine1:UIView = UIView.init(frame: CGRect(x: 20, y: 44, width: kWidth - 40, height: 0.5))
            seperateLine1.backgroundColor = UIColor.lineColors(color: .grayLevel5)
            backgroundView.addSubview(seperateLine1)
            //参考图
            orderDefaultPic.frame = CGRect(x: 20, y: 62, width: 118, height: 118) // y=62
            orderDefaultPic.image = UIImage(named: "defualt-design-pic")
            orderDefaultPic.contentMode = .scaleAspectFit
            orderDefaultPic.layer.cornerRadius = 6
            orderDefaultPic.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor//UIColor.lineColors(color: .grayLevel3).cgColor
            orderDefaultPic.layer.borderWidth = 0.5
            orderDefaultPic.layer.masksToBounds = true
            backgroundView.addSubview(orderDefaultPic)
            //点击预览层
            orderDefaultPicLayer.frame = CGRect(x: 20, y: 145, width: 118, height: 35)
            orderDefaultPicLayer.image = UIImage(named: "maskonimage")
            orderDefaultPicLayer.layer.cornerRadius = 6
            orderDefaultPicLayer.layer.masksToBounds = true
            
            //产品类型
            productTypeNameValue.frame = CGRect(x: 143, y: 63, width: 250, height: 22)
            productTypeNameValue.font = UIFont.boldSystemFont(ofSize: 16)
            productTypeNameValue.textColor = UIColor.titleColors(color: .black)
            productTypeNameValue.text = "徽章" // for debug
            backgroundView.addSubview(productTypeNameValue)
            
            //订购数目
            orderCountValue.frame = CGRect(x: kWidth - 120, y: 63, width: 100, height: 20)
            orderCountValue.font = UIFont.systemFont(ofSize: 14)
            orderCountValue.textColor = UIColor.titleColors(color: .darkGray)
            orderCountValue.textAlignment = .right
            orderCountValue.text = "x0" // for debug
            backgroundView.addSubview(orderCountValue)
            
            
            //工艺
            makeStyleValue.frame = CGRect(x: 143, y: 106, width: kWidth - 163, height: 60)
            makeStyleValue.numberOfLines = 3
            makeStyleValue.font = UIFont.systemFont(ofSize: 14)
            makeStyleValue.textColor = UIColor.titleColors(color: .darkGray)
            makeStyleValue.text = "" // for debug
            backgroundView.addSubview(makeStyleValue)
            
            //材质 + 附件
            materialAccessoriesValue.frame = CGRect(x: 143, y: 86, width: 280, height: 20)
            materialAccessoriesValue.font = UIFont.systemFont(ofSize: 14)
            materialAccessoriesValue.textColor = UIColor.titleColors(color: .darkGray)
            materialAccessoriesValue.text = "" // for debug
            backgroundView.addSubview(materialAccessoriesValue)
            //产品尺寸
            //长
            productSizeValue.frame = CGRect(x: 143, y: 146, width: 200, height: 20)
            productSizeValue.font = UIFont.systemFont(ofSize: 14)
            productSizeValue.textColor = UIColor.titleColors(color: .darkGray)
            productSizeValue.text = "0×0×0(mm)" // for debug
            backgroundView.addSubview(productSizeValue)
            
            productSizeHint.frame = CGRect(x: 143, y: 166, width: 200, height: 20)
            productSizeHint.font = UIFont.systemFont(ofSize: 10)
            productSizeHint.textColor = UIColor.titleColors(color: .gray)
            productSizeHint.text = "注：圆形产品直径参考长度(或宽度)值"
            backgroundView.addSubview(productSizeHint)
            
            quotePriceSubmitBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 308 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
            // quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            quotePriceSubmitBtn.backgroundColor = UIColor.gray
            quotePriceSubmitBtn.setTitle("提交报价", for: .normal)
            quotePriceSubmitBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            quotePriceSubmitBtn.backgroundColor = UIColor.gray
            quotePriceSubmitBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
            
            bargainPriceSubmitBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 308 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
            // quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            bargainPriceSubmitBtn.backgroundColor = UIColor.gray
            bargainPriceSubmitBtn.setTitle("提交反馈", for: .normal)
            bargainPriceSubmitBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            bargainPriceSubmitBtn.backgroundColor = UIColor.gray
            bargainPriceSubmitBtn.addTarget(self, action: #selector(confirmBargainBtnClicked), for: .touchUpInside)
            
            acceptDesignConfirmBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
            acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            acceptDesignConfirmBtn.setTitle("接受设计", for: .normal)
            acceptDesignConfirmBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            acceptDesignConfirmBtn.backgroundColor = UIColor.gray
            acceptDesignConfirmBtn.addTarget(self, action: #selector(confirmAcceptDesignBtnClicked), for: .touchUpInside)
            
            
            acceptProduceConfirmBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
            acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            acceptProduceConfirmBtn.setTitle("接受生产", for: .normal)
            acceptProduceConfirmBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            acceptProduceConfirmBtn.backgroundColor = UIColor.gray
            acceptProduceConfirmBtn.addTarget(self, action: #selector(confirmAcceptProduceBtnClicked), for: .touchUpInside)
            
            self.addSubview(quotePriceSubmitBtn)
            self.addSubview(bargainPriceSubmitBtn)
            self.addSubview(acceptDesignConfirmBtn)
            self.addSubview(acceptProduceConfirmBtn)
            
            switch ActionType {
            case .quotePrice:
                ActionTitle.text = "订单报价"
                quotePriceAtLastLabel.isHidden = false
                quotePriceAtLastTimeValue.isHidden = false
                quotePriceCurentLabel.isHidden = false
                currentValueOnSliderTextField.isHidden = false
                produceTimeCostLabel.isHidden = false
                setQuotePriceWeightBtn.isHidden = false
                quotePriceSlideBar.isHidden = false
                quotePriceSlideBarRightLabel.isHidden = false
                quotePriceSlideBarMidLabel.isHidden = false
                quotePriceSlideBarLeftLabel.isHidden = false
                
                quotePriceSubmitBtn.isHidden = false
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
            
                
                dashLine.frame = CGRect(x: 20, y: productSizeHint.frame.maxY + 5, width: kWidth - 40, height: 1)
                dashLine.image = UIImage(named: "dashlineimg")
                backgroundView.addSubview(dashLine)

                produceMemoLabel.frame = CGRect(x: 20, y: dashLine.frame.maxY + 15, width: 100, height: 22)
                produceMemoLabel.text = "生产要求:"
                produceMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceMemoLabel)
                
                ProduceMemoValue.frame = CGRect(x: 20, y: produceMemoLabel.frame.maxY + 15, width: kWidth - 40, height: 22)
                ProduceMemoValue.numberOfLines = 10
                ProduceMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(ProduceMemoValue)
                
                seperateLine2.frame = CGRect(x: 0, y: ProduceMemoValue.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                produceTimeCostLabel.text = "工期(天)"
                produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceTimeCostLabel)
                
                produceTimeCostTextField.text = "" // for debug
                produceTimeCostTextField.frame = CGRect(x: 130, y: seperateLine2.frame.maxY + 4 , width: kWidth - 120, height: 44)
                produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
                produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
                backgroundView.addSubview(produceTimeCostTextField)
                
                isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY - 1 , width: 110, height: 54)
                isProduceCycleOverView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
                isProduceCycleOverView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
                isProduceCycleOverView.layer.borderWidth = 1
                isProduceCycleOverView.isHidden = true
                backgroundView.addSubview(isProduceCycleOverView)
                
                isProduceCycleOverLabel.text = "超客户工期"
                isProduceCycleOverLabel.textColor = UIColor.titleColors(color: .red)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY  , width: 110, height: 27)
                isProduceCycleOverLabel.font = UIFont.systemFont(ofSize: 14)
                isProduceCycleOverLabel.textAlignment = .center
                isProduceCycleOverLabel.isHidden = true
                backgroundView.addSubview(isProduceCycleOverLabel)
                
                deadlineLabel.text = "客户工期: "
                deadlineLabel.textColor = UIColor.titleColors(color: .red)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY + 26 , width: 110, height: 27)
                deadlineLabel.font = UIFont.systemFont(ofSize: 14)
                deadlineLabel.textAlignment = .center
                deadlineLabel.isHidden = true
                backgroundView.addSubview(deadlineLabel)
                
                seperateLine3.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 52, width: kWidth - 40, height: 1)
                seperateLine3.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine3)
                
                quotePriceCurentLabel.text = "报价"
                quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
                quotePriceCurentLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(quotePriceCurentLabel)
                
                currentValueOnSliderTextField.text = "0"
                currentValueOnSliderTextField.textColor = UIColor.titleColors(color: .red)
                currentValueOnSliderTextField.font = UIFont.systemFont(ofSize: 16)
                currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
                //currentValueOnSliderTextField.
                
                quotePriceAtLastLabel.text = "上次报价 ¥- / 上次工期 - 天"
                quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 48 , width: kWidth - 20, height: 22)
                quotePriceAtLastLabel.font = UIFont.systemFont(ofSize: 12)
                backgroundView.addSubview(quotePriceAtLastLabel)
                
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap.numberOfTapsRequired = 1
                singleTap.numberOfTouchesRequired = 1
                
                let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap1.numberOfTapsRequired = 1
                singleTap1.numberOfTouchesRequired = 1
                
                let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap2.numberOfTapsRequired = 1
                singleTap2.numberOfTouchesRequired = 1
                currentValueOnSliderTextField.addGestureRecognizer(singleTap)
                currentValueOnSliderTextField.isUserInteractionEnabled = true
                //将点击上次报价也加入点击识别
                quotePriceAtLastLabel.addGestureRecognizer(singleTap1)
                quotePriceAtLastLabel.isUserInteractionEnabled = true
                //将点击标题也加入点击识别
                quotePriceCurentLabel.addGestureRecognizer(singleTap2)
                quotePriceAtLastLabel.isUserInteractionEnabled = true
                
                backgroundView.addSubview(currentValueOnSliderTextField)
                
                seperateLine4.frame = CGRect(x: 0, y: seperateLine3.frame.maxY + 80, width: kWidth, height: 5)
                seperateLine4.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine4)

            case .dealBargain:
                ActionTitle.text = "处理议价"
                quotePriceAtLastLabel.isHidden = false
                quotePriceAtLastTimeValue.isHidden = false
                quotePriceCurentLabel.isHidden = false
                currentValueOnSliderTextField.isHidden = false
                produceTimeCostLabel.isHidden = false
                setQuotePriceWeightBtn.isHidden = false
                quotePriceSlideBar.isHidden = false
                quotePriceSlideBarRightLabel.isHidden = false
                quotePriceSlideBarMidLabel.isHidden = false
                quotePriceSlideBarLeftLabel.isHidden = false
                
                quotePriceSubmitBtn.isHidden = true
                bargainPriceSubmitBtn.isHidden = false
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
                
                
                dashLine.frame = CGRect(x: 20, y: productSizeHint.frame.maxY + 5, width: kWidth - 40, height: 1)
                dashLine.image = UIImage(named: "dashlineimg")
                backgroundView.addSubview(dashLine)
                
                produceMemoLabel.frame = CGRect(x: 20, y: dashLine.frame.maxY + 15, width: 100, height: 22)
                produceMemoLabel.text = "生产要求:"
                produceMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceMemoLabel)
                
                ProduceMemoValue.frame = CGRect(x: 20, y: produceMemoLabel.frame.maxY + 15, width: kWidth - 40, height: 22)
                ProduceMemoValue.numberOfLines = 10
                ProduceMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(ProduceMemoValue)
                
                seperateLine2.frame = CGRect(x: 0, y: ProduceMemoValue.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                ///客户预算和工期
                overBudgetBackgroundView.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 1, width: kWidth, height: 54)
                overBudgetBackgroundView.backgroundColor = UIColor.colorWithRgba(255, g: 246, b: 246, a: 100)
                let redLine1:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 1))
                redLine1.backgroundColor = UIColor.backgroundColors(color: .red)
                
                budgetOveredLabel.frame = CGRect(x: 20, y: 16, width: kWidth - 40, height: 22)
                budgetOveredLabel.text = "客户预算/要求工期:"
                budgetOveredLabel.textColor = UIColor.titleColors(color: .red)
                overBudgetBackgroundView.addSubview(budgetOveredLabel)
                
                let redLine2:UIView = UIView.init(frame: CGRect(x: 0, y: 53, width: kWidth, height: 1))
                redLine2.backgroundColor = UIColor.backgroundColors(color: .red)
                overBudgetBackgroundView.addSubview(redLine1)
                overBudgetBackgroundView.addSubview(redLine2)
                backgroundView.addSubview(overBudgetBackgroundView)
                
                produceTimeCostLabel.text = "填写工期(天):"
                produceTimeCostLabel.frame = CGRect(x: 20, y: overBudgetBackgroundView.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceTimeCostLabel)
                
                produceTimeCostTextField.frame = CGRect(x: 130, y: overBudgetBackgroundView.frame.maxY + 4 , width: kWidth - 120, height: 44)
                produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
                produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
                backgroundView.addSubview(produceTimeCostTextField)
                
                isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY , width: 110, height: 54)
                isProduceCycleOverView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
                isProduceCycleOverView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
                isProduceCycleOverView.layer.borderWidth = 1
                isProduceCycleOverView.isHidden = true
                backgroundView.addSubview(isProduceCycleOverView)
                
                isProduceCycleOverLabel.text = "超客户工期"
                isProduceCycleOverLabel.textColor = UIColor.titleColors(color: .red)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY - 1 , width: 110, height: 27)
                isProduceCycleOverLabel.font = UIFont.systemFont(ofSize: 14)
                isProduceCycleOverLabel.textAlignment = .center
                isProduceCycleOverLabel.isHidden = true
                backgroundView.addSubview(isProduceCycleOverLabel)
                
                deadlineLabel.text = "客户工期: "
                deadlineLabel.textColor = UIColor.titleColors(color: .red)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY + 26 , width: 110, height: 27)
                deadlineLabel.font = UIFont.systemFont(ofSize: 14)
                deadlineLabel.textAlignment = .center
                deadlineLabel.isHidden = true
                backgroundView.addSubview(deadlineLabel)
                
                seperateLine3.frame = CGRect(x: 20, y: overBudgetBackgroundView.frame.maxY + 52, width: kWidth - 40, height: 5)
                seperateLine3.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine3)

                quotePriceCurentLabel.text = "设置当前报价:"
                quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
                quotePriceCurentLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(quotePriceCurentLabel)
                
                currentValueOnSliderTextField.text = "0"
                currentValueOnSliderTextField.textColor = UIColor.titleColors(color: .red)
                currentValueOnSliderTextField.font = UIFont.systemFont(ofSize: 16)
                currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
                
                quotePriceAtLastLabel.text = "上次报价 ¥- / 上次工期 - 天"
                quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 48 , width: kWidth - 20, height: 22)
                quotePriceAtLastLabel.font = UIFont.systemFont(ofSize: 12)
                backgroundView.addSubview(quotePriceAtLastLabel)
                
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap.numberOfTapsRequired = 1
                singleTap.numberOfTouchesRequired = 1
                
                let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap1.numberOfTapsRequired = 1
                singleTap1.numberOfTouchesRequired = 1
                
                let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(quetePriceClicked))
                singleTap2.numberOfTapsRequired = 1
                singleTap2.numberOfTouchesRequired = 1
                currentValueOnSliderTextField.addGestureRecognizer(singleTap)
                currentValueOnSliderTextField.isUserInteractionEnabled = true
                //将点击上次报价也加入点击识别
                quotePriceAtLastLabel.addGestureRecognizer(singleTap1)
                quotePriceAtLastLabel.isUserInteractionEnabled = true
                //将点击标题也加入点击识别
                quotePriceCurentLabel.addGestureRecognizer(singleTap2)
                quotePriceAtLastLabel.isUserInteractionEnabled = true
                
                backgroundView.addSubview(currentValueOnSliderTextField)
            
            case .acceptDesign:
                backgroundView.contentSize = CGSize(width: kWidth, height: 441)
                
                ActionTitle.text = "接受设计"
                quotePriceAtLastLabel.isHidden = true
                quotePriceAtLastTimeValue.isHidden = true
                quotePriceCurentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = true
                setQuotePriceWeightBtn.isHidden = true
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                
                quotePriceSubmitBtn.isHidden = true
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = false
                acceptProduceConfirmBtn.isHidden = true
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                designMemoLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designMemoValue.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designFeeLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designFeeValue.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                
                designMemoLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                designMemoLabel.text = "设计备注:"
                designMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(designMemoLabel)
    
                
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: 22)
                designMemoValue.numberOfLines = 10
                designMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(designMemoValue)
                
                designFeeLabel.text = "设计费:"
                designFeeLabel.frame = CGRect(x: 20, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                designFeeLabel.font = UIFont.systemFont(ofSize: 16)
                
                designFeeValue.frame = CGRect(x: 80, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                designFeeValue.font = UIFont.systemFont(ofSize: 26)
                designFeeValue.textColor = UIColor.titleColors(color: .red)
                self.addSubview(designFeeValue)
                self.addSubview(designFeeLabel)
                
            case .acceptProduce:
                // BackRoundView
                backgroundView.contentSize = CGSize(width: kWidth, height: 441)
                
                ActionTitle.text = "接受生产"
                quotePriceAtLastLabel.isHidden = true
                quotePriceAtLastTimeValue.isHidden = true
                quotePriceCurentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = false
                setQuotePriceWeightBtn.isHidden = true
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                
                quotePriceSubmitBtn.isHidden = true
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = false
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                
                produceMemoLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                produceMemoLabel.text = "生产备注:"
                produceMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceMemoLabel)
                
                
                ProduceMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: 22)
                ProduceMemoValue.numberOfLines = 10
                ProduceMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(ProduceMemoValue)
                
                
                produceTimeCostBackgroundView.frame =  CGRect(x: 0, y: self.frame.height - 194 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 52)
                produceTimeCostBackgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
                self.addSubview(produceTimeCostBackgroundView)
                
                let seperator:UIView = UIView.init()
                seperator.frame = CGRect(x: 0, y: 0, width: kWidth, height: 2)
                seperator.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                produceTimeCostBackgroundView.addSubview(seperator)
                
                produceTimeCostLabel.text = "填写工期(天):"
                produceTimeCostLabel.frame = CGRect(x: 20, y: seperator.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostBackgroundView.addSubview(produceTimeCostLabel)
                
                produceTimeCostTextField.text = "" // for debug
                produceTimeCostTextField.frame = CGRect(x: 130, y: seperator.frame.maxY + 4 , width: kWidth - 120, height: 44)
                produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
                produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
                produceTimeCostBackgroundView.addSubview(produceTimeCostTextField)
                
                
                isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: seperator.frame.maxY - 1 , width: 110, height: 54)
                isProduceCycleOverView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
                isProduceCycleOverView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
                isProduceCycleOverView.layer.borderWidth = 1
                isProduceCycleOverView.isHidden = true
                produceTimeCostBackgroundView.addSubview(isProduceCycleOverView)
                
                isProduceCycleOverLabel.text = "超客户工期"
                isProduceCycleOverLabel.textColor = UIColor.titleColors(color: .red)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: seperator.frame.maxY - 1 , width: 110, height: 27)
                isProduceCycleOverLabel.font = UIFont.systemFont(ofSize: 14)
                isProduceCycleOverLabel.textAlignment = .center
                isProduceCycleOverLabel.isHidden = true
                produceTimeCostBackgroundView.addSubview(isProduceCycleOverLabel)
                
                
                deadlineLabel.text = "客户工期: "
                deadlineLabel.textColor = UIColor.titleColors(color: .red)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: seperator.frame.maxY + 26 , width: 110, height: 27)
                deadlineLabel.font = UIFont.systemFont(ofSize: 14)
                deadlineLabel.textAlignment = .center
                deadlineLabel.isHidden = true
                produceTimeCostBackgroundView.addSubview(deadlineLabel)
                
                
                orderPriceLabel.text = "预算金额:"
                orderPriceLabel.frame = CGRect(x: 20, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                orderPriceLabel.font = UIFont.systemFont(ofSize: 16)
                
                orderPriceValue.frame = CGRect(x: 100, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                orderPriceValue.font = UIFont.systemFont(ofSize: 26)
                orderPriceValue.textColor = UIColor.titleColors(color: .red)
                self.addSubview(orderPriceValue)
                self.addSubview(orderPriceLabel)
                
            case .designRequires:
                backgroundView.contentSize = CGSize(width: kWidth, height: 441)
                
                ActionTitle.text = "设计要求"
                quotePriceAtLastLabel.isHidden = true
                quotePriceAtLastTimeValue.isHidden = true
                quotePriceCurentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = true
                setQuotePriceWeightBtn.isHidden = true
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                
                quotePriceSubmitBtn.isHidden = true
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                designMemoLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designMemoValue.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designFeeLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designFeeValue.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                
                designMemoLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                designMemoLabel.text = "设计备注:"
                designMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(designMemoLabel)
                
                
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: 22)
                designMemoValue.numberOfLines = 10
                designMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(designMemoValue)
                
                designFeeLabel.text = "设计费:"
                designFeeLabel.frame = CGRect(x: 20, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                designFeeLabel.font = UIFont.systemFont(ofSize: 16)
                
                designFeeValue.frame = CGRect(x: 80, y: self.frame.height - 133 - heightChangeForiPhoneXFromBottom, width: 120, height: 37)
                designFeeValue.font = UIFont.systemFont(ofSize: 26)
                designFeeValue.textColor = UIColor.titleColors(color: .red)
                self.addSubview(designFeeValue)
                self.addSubview(designFeeLabel)
                
            case .modifyRequires:
                backgroundView.contentSize = CGSize(width: kWidth, height: 441)
                
                ActionTitle.text = "设计要求"
                quotePriceAtLastLabel.isHidden = true
                quotePriceAtLastTimeValue.isHidden = true
                quotePriceCurentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = true
                setQuotePriceWeightBtn.isHidden = true
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                
                quotePriceSubmitBtn.isHidden = true
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
                //将订购数目的位置显示为设计费
                orderCountValue.font = UIFont.systemFont(ofSize: 16)
                orderCountValue.textColor = UIColor.titleColors(color: .red)
                orderCountValue.text = "¥-"
                
                //设计备注上的那一条
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine2)
                
                designMemoLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                designMemoValue.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                
                designMemoLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                designMemoLabel.text = "设计要求:"
                designMemoLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(designMemoLabel)
                
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: 22)
                designMemoValue.numberOfLines = 10
                designMemoValue.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(designMemoValue)
                
                //设计要求下方的线
                seperateLine8.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 74, width: kWidth - 40, height: 1)
                seperateLine8.backgroundColor = UIColor.lineColors(color: .grayLevel3)
                backgroundView.addSubview(seperateLine8)
                
                //当前设计稿:
                currentDesignParttenTitle.frame = CGRect(x: 20, y: seperateLine8.frame.maxY + 16, width: 200, height: 22)
                backgroundView.addSubview(currentDesignParttenTitle)
                
                currentDesignParttenImageView.frame = CGRect(x: 20, y: currentDesignParttenTitle.frame.maxY + 13, width: 68, height: 68)
                backgroundView.addSubview(currentDesignParttenImageView)
                //Line7. 当前设计稿下方的一条线
                seperateLine7.frame = CGRect(x: 0, y: seperateLine8.frame.maxY + 131, width: kWidth, height: 15)
                seperateLine7.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
                backgroundView.addSubview(seperateLine7)
                
                let notice:UILabel = UILabel.init(frame: CGRect(x: 0, y: seperateLine7.frame.maxY + 51, width: kWidth, height: 22))
                notice.text = "App暂不支持查看留言,请前往Web页面操作"
                notice.textAlignment = .center
                notice.textColor = UIColor.titleColors(color: .gray)
                notice.font = UIFont.systemFont(ofSize: 14)
                backgroundView.addSubview(notice)
               // leaveMsgListTableView.frame = CGRect(x: 0, y: seperateLine7.frame.maxY + 51, width: kWidth, height: 400)
              //  backgroundView.addSubview(leaveMsgListTableView)
            default:
                ActionTitle.text = "邮寄投递"
                quotePriceAtLastLabel.isHidden = true
                quotePriceAtLastTimeValue.isHidden = true
                quotePriceCurentLabel.isHidden = true
                currentValueOnSliderTextField.isHidden = true
                produceTimeCostLabel.isHidden = true
                setQuotePriceWeightBtn.isHidden = true
                quotePriceSlideBar.isHidden = true
                quotePriceSlideBarRightLabel.isHidden = true
                quotePriceSlideBarMidLabel.isHidden = true
                quotePriceSlideBarLeftLabel.isHidden = true
                
                quotePriceSubmitBtn.isHidden = false
                bargainPriceSubmitBtn.isHidden = true
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
            }
        }else{
            //初始化值
            //ActionTitle.frame  = CGRect(x: kWidth/2 - 50, y: 20, width: 100, height: 25)
            ActionTitle.text = "发货"
            
            backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth , height: 460) // 360
            backgroundView.contentSize = CGSize(width: kWidth, height: 369)
            
            cancelBtn.frame = CGRect(x: 20, y: 22, width: 60, height: 22)
            cancelBtn.contentHorizontalAlignment = .left
            
            //参考图
            orderDefaultPic.frame = CGRect(x: 20, y: 20, width: 118, height: 118) // y=62
            orderDefaultPic.image = googsImge //UIImage(named: "defualt-design-pic")
            orderDefaultPic.contentMode = .scaleAspectFit
            orderDefaultPic.layer.cornerRadius = 6
            orderDefaultPic.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor//UIColor.lineColors(color: .grayLevel3).cgColor
            orderDefaultPic.layer.borderWidth = 0.5
            orderDefaultPic.layer.masksToBounds = true
            backgroundView.addSubview(orderDefaultPic)
            
            orderIDLabel.frame = CGRect(x: 158, y: 20, width: 200, height: 20)
            orderIDValue.frame = CGRect(x: 158, y: 45, width: 200, height: 20)
            
            //确定按钮
            confirmShippingBtn.frame = CGRect(x: kWidth - 80, y: 22 , width: 60, height: 22)
            confirmShippingBtn.setTitle("确定", for: .normal)
            confirmShippingBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            confirmShippingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            confirmShippingBtn.contentHorizontalAlignment = .right
            confirmShippingBtn.addTarget(self, action: #selector(confirmShippingBtnClicked), for: .touchUpInside)
            self.addSubview(confirmShippingBtn)
            
            
            orderIDLabel.font = UIFont.systemFont(ofSize: 18)
            orderIDValue.font = UIFont.systemFont(ofSize: 18)
            orderIDValue.textAlignment = .left
            orderIDValue.text = _orderID
            
            seperateLine4.frame = CGRect(x: 20, y: 158, width: kWidth - 40, height: 2)
            seperateLine4.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            backgroundView.addSubview(seperateLine4)
            
            let shippingCompanyNameLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine4.frame.maxY + 20, width: 100, height: 25))
            shippingCompanyNameLabel.font = UIFont.systemFont(ofSize: 18)
            shippingCompanyNameLabel.text = "快递公司:"
            backgroundView.addSubview(shippingCompanyNameLabel)
            
            
            shippingCompanyNameValue.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 20, width: kWidth - 40, height: 25)
            shippingCompanyNameValue.font = UIFont.systemFont(ofSize: 18)
            shippingCompanyNameValue.textAlignment = .center
            shippingCompanyNameValue.text = "德邦"
            //为Label添加手势识别
            shippingCompanyNameValue.isUserInteractionEnabled = true
            let shippingTabSingle=UITapGestureRecognizer(target:self,action:#selector(shippingCompanyChooseTaped(_:)))
            shippingTabSingle.numberOfTapsRequired = 1
            shippingTabSingle.numberOfTouchesRequired = 1
            shippingCompanyNameValue.addGestureRecognizer(shippingTabSingle)
            backgroundView.addSubview(shippingCompanyNameValue)
            
            let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 42, y: seperateLine4.frame.maxY + 22, width: 22, height: 22))
            rightArrow.image = UIImage(named: "right-arrow")
            backgroundView.addSubview(rightArrow)
            
            seperateLine5.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 65, width: kWidth - 40, height: 2)
            seperateLine5.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            backgroundView.addSubview(seperateLine5)
            
            let shippingCodeLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine5.frame.maxY + 20, width: 100, height: 25))
            shippingCodeLabel.font = UIFont.systemFont(ofSize: 18)
            shippingCodeLabel.text = "物流单号:"
            backgroundView.addSubview(shippingCodeLabel)
            
            
            shippingCodeValue.frame = CGRect(x: 120, y: seperateLine5.frame.maxY + 20, width: kWidth - 140, height: 25)
            shippingCodeValue.placeholder = "请输入物流单号"
            shippingCodeValue.font = UIFont.systemFont(ofSize: 18)
            shippingCodeValue.keyboardType =  .numberPad//.decimalPad
            backgroundView.addSubview(shippingCodeValue)
            
            let shippingCodeScanBtn:UIButton = UIButton.init(type: .custom)
            //设置扫描二维码按钮样式
            shippingCodeScanBtn.frame = CGRect(x: kWidth - 42, y: seperateLine5.frame.maxY + 20, width: 22, height: 22)
            shippingCodeScanBtn.addTarget(self, action: #selector(scanQRCodeBtnClicked), for: UIControlEvents.touchUpInside)
            let qrcodeImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
            qrcodeImg.image =  UIImage(named:"scanqrcodeicon-gray")//  UIImage(named:"messagelisticon")
            shippingCodeScanBtn.addSubview(qrcodeImg)
            backgroundView.addSubview(shippingCodeScanBtn)
            
            seperateLine6.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 65, width: kWidth - 40, height: 2)
            seperateLine6.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
            backgroundView.addSubview(seperateLine6)
            
        }
    }
    @objc func quetePriceClicked(){
        print("priceLabelClicked")
        //收起工期键盘
        produceTimeCostTextField.resignFirstResponder()
        self.addSubview(calculatorView)
        self.bringSubview(toFront: calculatorView)
        calculatorView.frame = CGRect(x: 0, y: kHight, width: kWidth, height: 416 + heightChangeForiPhoneXFromBottom) // kHight - 416 - self.frame.minY - heightChangeForiPhoneXFromBottom
        calculatorView._roleType = _roleType
        calculatorView.popupVC = popupVC
        calculatorView.actionView = self
        calculatorView._actionType = _actionType
        UIView.animate(withDuration: 0.3) {
            self.calculatorView.transform = CGAffineTransform(translationX: 0, y: -420 + 166 - heightChangeForiPhoneXFromBottom - self.frame.minY)
            self.transform = CGAffineTransform(translationX: 0, y: -166)
        }
        //self.frame = CGRect(x: _frame.midX, y: _frame.minY, width: _frame.width, height: _frame.height + 216)
        //calculatorView
        
    }
    @objc func scanQRCodeBtnClicked(){
        let scanQRcodeVC = ScanCodeViewController(scanType: .barCodeForShipping)
        scanQRcodeVC.ActionViewObject = self
        let nav = UINavigationController.init(rootViewController: scanQRcodeVC)
        popupVC.present(nav, animated: true, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func confirmShippingBtnClicked(){
        
        print("确认邮寄投递按钮点击了")
        if shippingCodeValue.text == ""{
            greyLayerPrompt.show(text: "物流单号不能为空哦")
            return
        }
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        
//        //获取订单信息
//        let orderinfoObject = orderDetail[0] as? NSDictionary
//        let customID = orderinfoObject?.value(forKey: "customid") as? String
//        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        params["customid"] = _customID// customID
        params["company"] = shippingCompanyNameValueCode
        params["logisticsid"] = shippingCodeValue.text as! String
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "shippingConfirmDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "shippingConfirm") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        print("发货成功")
                        greyLayerPrompt.show(text: "发货成功成功")
                        self.closeActionView()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self.popupVC)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("发货失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "发货失败，请重试")
            }
        }
        print("发货按钮按钮点击了")
        
    }
    //设置权重
    @objc func setQuotePriceWeight(){
        let setParameterVC = SetParamtersViewController(roleType: _roleType)
        popupVC.present(setParameterVC, animated: true, completion: nil)
    }
    
    //点击接受设计
    @objc func confirmAcceptDesignBtnClicked(){
        
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String

        //获取订单信息
        let orderinfoObject = orderDetail[0] as? NSDictionary
        let designSheetID = orderinfoObject?.value(forKey: "designId") as! String

        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        params["wId"] = designSheetID
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "acceptDesignDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "acceptDesign") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        print("接受设计成功")
                        greyLayerPrompt.show(text: "接受设计成功")
                        self.closeActionView()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self.popupVC)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("接受失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "接受设计失败，请重试")
            }
        }
        print("接受设计按钮点击了")

    }
   
    @objc func confirmQuotePriceBtnClicked(){
        quotePriceSubmitBtn.backgroundColor = UIColor.gray
        bargainPriceSubmitBtn.backgroundColor = UIColor.gray
        acceptDesignConfirmBtn.backgroundColor = UIColor.gray
        acceptProduceConfirmBtn.backgroundColor = UIColor.gray
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
            self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.bargainPriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        }else{
            //获取用户信息
            let userInfos = getCurrentUserInfo()
            let token = userInfos.value(forKey: "token") as? String
            
            //获取订单信息
            let orderInfoObjects = orderDetail[0] as! NSDictionary// orderArray[selectedIndex]
            let rounds = orderInfoObjects.value(forKey: "inquiryRound") as! Int
            //let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary

            let customID = orderInfoObjects.value(forKey: "customid") as? String
            //let orderid = orderInfoObjects.value(forKey: "orderid") as? String
            var deadline = 0

            if orderInfoObjects.value(forKey: "userPeriod") as? Int == nil{
                deadline = 0
            }else{
                deadline = orderInfoObjects.value(forKey: "userPeriod") as! Int
            }
            
            
            if (deadline < Int(produceTimeCostTextField.text!)!) && deadline != 0{
                greyLayerPrompt.show(text: "订单生产周期超过预期")
                isProduceCycleOverView.isHidden = false
                isProduceCycleOverLabel.isHidden = false
                deadlineLabel.isHidden = false
                isProduceCycleOver = true
                deadlineLabel.text = "客户工期: \(deadline)"
                //return
            }else{
                isProduceCycleOverView.isHidden = true
                isProduceCycleOverLabel.isHidden = true
                deadlineLabel.isHidden = true
                isProduceCycleOver = false
            }
            //获取报价信息
            let currentValueOfQuotePrice = currentValueOnSliderTextField.text//quotePriceSlideBar.value
            
            //获取列表
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
            //定义请求参数
            let params:NSMutableDictionary = NSMutableDictionary()
            var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
            header["token"] = token
            params["customid"] = customID
            params["quotePrice"] = String(currentValueOfQuotePrice!)//String(format: "%.2f", currentValueOfQuotePrice)
            params["quotePeriod"] = produceTimeCostTextField.text
            params["rounds"] = String(rounds)

            #if DEBUG
            let requestUrl = _isBidding ? (apiAddresses.value(forKey: "biddingAPIDebug") as! String):(apiAddresses.value(forKey: "quotePriceDebug") as! String) //如果是议价，则调用议价接口
            #else
            let requestUrl = _isBidding ? (apiAddresses.value(forKey: "biddingAPI") as! String):(apiAddresses.value(forKey: "quotePrice") as! String)
            #endif
     
            _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
                (responseObject) in
                switch responseObject.result.isSuccess{
                case true:
                    if  let value = responseObject.result.value{
                        let json = JSON(value)
                        let statusCode = json["code"].int!
                        if statusCode == 200{
                            
                            if self.allOrderVC != nil {
                                self.allOrderVC.reloadData()
                            }
                            if self.isProduceCycleOver {
                                greyLayerPrompt.show(text: "报价成功,但是超过了客户工期")
                            }
                            
                            if !self.isProduceCycleOver && !self.isBudgetOver{
                                greyLayerPrompt.show(text: "报价成功")
                                self.closeActionView()
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
//                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("报价失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: errorMsg)
                        }
                    }
                case false:
                    print("处理失败")
                    greyLayerPrompt.show(text: "报价失败,请重试")
                }
                self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.bargainPriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            }

        }
        print("报价按钮点击了")
    }

    @objc func confirmBargainBtnClicked(){
        quotePriceSubmitBtn.backgroundColor = UIColor.gray
        bargainPriceSubmitBtn.backgroundColor = UIColor.gray
        acceptDesignConfirmBtn.backgroundColor = UIColor.gray
        acceptProduceConfirmBtn.backgroundColor = UIColor.gray
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
            self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.bargainPriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        }else{
            //获取用户信息
            let userInfos = getCurrentUserInfo()
            let token = userInfos.value(forKey: "token") as? String
            
            //获取订单信息
            let orderInfoObjects = orderDetail[0] as! NSDictionary// orderArray[selectedIndex]
            let rounds = orderInfoObjects.value(forKey: "inquiryRound") as! Int
            //let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary
            
            let customID = orderInfoObjects.value(forKey: "customid") as? String
            let orderid = orderInfoObjects.value(forKey: "orderid") as? String
            var deadline = 0
            
            if orderInfoObjects.value(forKey: "userPeriod") as? Int == nil{
                deadline = 0
            }else{
                deadline = orderInfoObjects.value(forKey: "userPeriod") as! Int
            }
            
            
            if (deadline < Int(produceTimeCostTextField.text!)!) && deadline != 0{
                greyLayerPrompt.show(text: "订单生产周期超过预期")
                isProduceCycleOverView.isHidden = false
                isProduceCycleOverLabel.isHidden = false
                deadlineLabel.isHidden = false
                isProduceCycleOver = true
                deadlineLabel.text = "客户工期: \(deadline)"
                //return
            }else{
                isProduceCycleOverView.isHidden = true
                isProduceCycleOverLabel.isHidden = true
                deadlineLabel.isHidden = true
                isProduceCycleOver = false
            }
            //获取报价信息
            let currentValueOfQuotePrice = currentValueOnSliderTextField.text//quotePriceSlideBar.value
            
            //获取列表
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
            //定义请求参数
            let params:NSMutableDictionary = NSMutableDictionary()
            var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
            header["token"] = token
            params["customid"] = customID
            params["price"] = String(currentValueOfQuotePrice!)//String(format: "%.2f", currentValueOfQuotePrice)
            params["period"] = produceTimeCostTextField.text
            params["rounds"] = rounds
            
            
            #if DEBUG
            let requestUrl = apiAddresses.value(forKey: "bargainDealAPIDebug") as! String
            #else
            let requestUrl = apiAddresses.value(forKey: "bargainDealAPI") as! String
            #endif
            
            
            _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
                (responseObject) in
                switch responseObject.result.isSuccess{
                case true:
                    if  let value = responseObject.result.value{
                        let json = JSON(value)
                        let statusCode = json["code"].int!
                        if statusCode == 200{
                            
                            if self.allOrderVC != nil {
                                self.allOrderVC.reloadData()
                            }
                            if self.isProduceCycleOver {
                                greyLayerPrompt.show(text: "议价反馈成功,但是超过了客户工期")
                            }
                            
                            if !self.isProduceCycleOver && !self.isBudgetOver{
                                greyLayerPrompt.show(text: "议价反馈成功")
                                self.closeActionView()
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
//                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("议价反馈失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: errorMsg)
                        }
                    }
                case false:
                    print("处理失败")
                    greyLayerPrompt.show(text: "处理失败,请重试")
                }
                self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.bargainPriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
                self.acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            }
            
        }
        print("报价按钮点击了")
    }
    @objc func confirmAcceptProduceBtnClicked(){
        //确定点击接受生产按钮
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String

        //获取订单信息
        let orderinfoObject = orderDetail[0] as? NSDictionary
        let customID = orderinfoObject?.value(forKey: "customid") as? String
        
        if orderinfoObject?.value(forKey: "userPeriod") as? Int == nil{
            deadline = 0
        }else{
            deadline = orderinfoObject?.value(forKey: "userPeriod") as! Int
        }

        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
            return
        }else{
            if (deadline < Int(produceTimeCostTextField.text!)!) && deadline != 0{
                greyLayerPrompt.show(text: "客户要求工期为\(deadline)天以内，请修改生产周期")
                return
            }
        }
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        params["customid"] = customID
        params["period"] = produceTimeCostTextField.text

        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "acceptProduceDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "acceptProduce") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        print("接受生产成功")
                        greyLayerPrompt.show(text: "接受生产成功")
                        self.closeActionView()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self.popupVC)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self.popupVC)
                    }else{
                        print("接受失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "接受生产失败，请重试")
            }
        }
        print("接受生产按钮点击了")
    }

    //缩略图imageView点击
    @objc func imageViewTap(_ recognizer:UITapGestureRecognizer){
        //图片索引
        let index = 0
        //进入图片全屏展示
        let previewVC = ImagePreviewVC(images:memoPictures , index: index, previewMode: .previewWithoutDelete)
        previewVC.PreviewType = previewTypes
        popupVC.present(previewVC, animated: true, completion: nil)
        
        
    }
    
    @objc func shippingCompanyChooseTaped(_ recoginizer:UITapGestureRecognizer){
        print("选中快递公司按钮点击了")
        let shippingCompanyChoosingVC = ShippingCompanyNameListViewController()
        //设置跳转带navigation controller的跳转
        shippingCompanyChoosingVC.actionViewObject = self
        let nav = UINavigationController(rootViewController: shippingCompanyChoosingVC)
        popupVC.present(nav, animated: true, completion: nil)
        
    }
    //关闭按钮
    @objc func closeActionView(){
        //更新订单条目
        if allOrderVC != nil{
            allOrderVC.reloadData()
        }
        popupVC.dismiss(animated: true, completion: nil)
    }


    @objc func quotePriceSliderBarValueChanged(_ slider:UISlider){
        quotePriceWeight = getQuotePriceWeight()
        currentValueOnSliderTextField.text = "\(Int(slider.value/Float(quotePriceWeight))*quotePriceWeight).00"
    }



    // 输入框的值发生变化
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentValueOnSliderTextField.resignFirstResponder()
        produceTimeCostTextField.resignFirstResponder()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(textFieldDidEndEditing(_:)))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        //收起计算报价的键盘
        if self.subviews.contains(calculatorView){
            UIView.animate(withDuration: 0.3) {
                self.calculatorView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        
        textField.inputAccessoryView = topView
        return true
    }

    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double

//        if currentValueOnSliderTextField.isFirstResponder{
//            //界面偏移动画
//            //UIScreen.main.bounds.height
////            UIView.animate(withDuration: duration, animations: { ()->Void in
////                self.blurPopView.transform = CGAffineTransform(translationX: 0, y:-(UIScreen.main.bounds.height + 130)) //-(height+300)+200
////            })
//        }
        if shippingCodeValue.isFirstResponder {
            UIView.animate(withDuration: duration) {
                ()->Void in
                self.transform = CGAffineTransform(translationX: 0, y: -166)
            }
        }
        if produceTimeCostTextField.isFirstResponder{
            switch _actionType{
            case .acceptProduce:
                UIView.animate(withDuration: duration) {
                    ()->Void in
                    self.transform = CGAffineTransform(translationX: 0, y: -338 )
                }
            case .quotePrice:
                UIView.animate(withDuration: duration) {
                    ()->Void in
                    self.transform = CGAffineTransform(translationX: 0, y: -166 ) // -76
                }
            default:
                print("nothing")
            }
            
        }
    }

    //键盘的隐藏
    @objc func keyBoardWillHide(_notification: Notification){

        let kbInfo = _notification.userInfo
        /*
         swift2.3正常，swift3.0取值为nil
         */
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double

        if currentValueOnSliderTextField.isFirstResponder {

        }

            UIView.animate(withDuration: duration) {
                ()->Void in
                self.transform = CGAffineTransform(translationX: 0, y: 0) //(UIScreen.main.bounds.height + 130)
            }
    }
    
    func getOrderDetails(OrderID:String,CustomID:String){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetailsDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetails") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
      //  params["userId"] =  _userId// userID
       // params["orderId"] =  OrderID
        params["customId"] =  CustomID
      //  params["roleType"] = _roleType// roletype
        header["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                            print("获取订单详情成功")
                            self.orderDetail.removeAll()
                            self.initQuotePriceInfos.removeAll()
                            let ordersummaryItem = json["data"].dictionaryObject! as NSDictionary
                            let designinfoItem = json["data","designInfo"].arrayObject! as NSArray
                            self.orderDetail.append(ordersummaryItem)
                            self.orderDetail.append(designinfoItem)
                            print("get order detail successed")
                            //获取成功数据了，刷新UI
                            DispatchQueue.main.async {
                                self.updateViewData()
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
                            //greyLayerPrompt.show(text: "登录已失效,请重新登录")
                            //LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("接受失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: "获取订单详情失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        greyLayerPrompt.show(text: "程序错误. Code:1")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }

    
    func downloadOrderImages(){
        DispatchQueue.global().async {
            //订单详情信息
            let dictionaryObjectInOrderArray = self.orderDetail
            let orderaddinfos = dictionaryObjectInOrderArray[0]
            
            //附件图片数目
            var attachImageCount:Int = 0
            //下载缩略图
            if orderaddinfos.value(forKey: "smallReferenceImage1") as? String != nil && orderaddinfos.value(forKey: "smallReferenceImage1") as? String != "" {
                let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(orderaddinfos.value(forKey: "smallReferenceImage1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    DispatchQueue.main.async {
                        self.orderDefaultPic.image = image
                    }
                    
                }catch{
                    print(error)
                    //缩略图下载失败，下载原图
                    let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage1") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = image
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = UIImage(named:"defualt-design-pic")//  UIImage(image:image)
                        }
                        //原图也下载失败
                    }
                    print("无缩略图")
                }
            }else if orderaddinfos.value(forKey: "smallReferenceImage2") as? String != nil && orderaddinfos.value(forKey: "smallReferenceImage2") as? String != "" {
                //第一张图不存在，下载第二张图的缩略图
                let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(orderaddinfos.value(forKey: "smallReferenceImage2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    DispatchQueue.main.async {
                        self.orderDefaultPic.image = image
                    }
                }catch{
                    print(error)
                    //缩略图下载失败，下载原图
                    let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = image
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                        }
                        //原图也下载失败
                    }
                    print("无缩略图")
                }
            }else if orderaddinfos.value(forKey: "smallReferenceImage3") as? String != nil && orderaddinfos.value(forKey: "smallReferenceImage3") as? String != "" {
                //第二张图也不存在,下载第三张图
                let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(orderaddinfos.value(forKey: "smallReferenceImage3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    DispatchQueue.main.async {
                        self.orderDefaultPic.image = image
                    }
                }catch{
                    print(error)
                    //缩略图下载失败，下载原图
                    let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage3") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = image
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            self.orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                        }
                        //原图也下载失败
                    }
                    print("无缩略图")
                }
            }else{
                //所有图片都没有，显示默认图
                DispatchQueue.main.async {
                    self.orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                }
            }
            
            
            //
            //下载原图
            //
            //设计师图递增
            self.memoPictures.removeAll()
            self.previewTypes.removeAll()
            if orderaddinfos.value(forKey: "initialReferenceImage1") as? String != nil && orderaddinfos.value(forKey: "initialReferenceImage1") as? String != "" {
                let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    self.memoPictures.append(image!)
                    self.previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "initialReferenceImage2") as? String != nil && orderaddinfos.value(forKey: "initialReferenceImage2") as? String != "" {
                let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    self.memoPictures.append(image!)
                    self.previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
                
            }
            if orderaddinfos.value(forKey: "initialReferenceImage3") as? String != nil && orderaddinfos.value(forKey: "initialReferenceImage3") as? String != ""{
                let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialReferenceImage3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    self.memoPictures.append(image!)
                    self.previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            
            DispatchQueue.main.async {
                self.orderDefaultPicLayer.removeFromSuperview()
                for subview in self.orderDefaultPic.subviews{
                    subview.removeFromSuperview()
                }
                if attachImageCount != 0{
                    self.orderDefaultPicLayer.frame = CGRect(x: 0, y: 118 - 35, width: 118, height: 35)
                    self.orderDefaultPic.addSubview(self.orderDefaultPicLayer)
                    for i in 1...attachImageCount{
                        //附件数目小红点
                        let pointSize:CGSize = CGSize(width: 5, height: 5)
                        let positionOffset:CGFloat = 35.0
                        let positionLength = self.orderDefaultPicLayer.frame.width
                        
                        let xPoint = (positionLength - positionOffset * 2) / CGFloat(attachImageCount + 1) + positionOffset - pointSize.width / 2
                        let pointGrow = (positionLength - positionOffset * 2) / CGFloat(attachImageCount + 1)
                        let imageCountLabel:UILabel = UILabel.init(frame: CGRect(x: xPoint + pointGrow * CGFloat(i - 1), y: 103, width: 5, height: 5))
                        imageCountLabel.backgroundColor = UIColor.white
                        imageCountLabel.layer.cornerRadius = 2.5
                        //imageCountLabel.text = "\(attachImageCount)"
                        imageCountLabel.textColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
                        imageCountLabel.textAlignment = .center
                        imageCountLabel.clipsToBounds = true // 对Label切角度
                        
                        self.orderDefaultPic.addSubview(imageCountLabel)
                    }
                    self.orderDefaultPic.isUserInteractionEnabled = true
                    
                    let tapSingle=UITapGestureRecognizer(target:self,
                                                         action:#selector(self.imageViewTap(_:)))
                    tapSingle.numberOfTapsRequired = 1
                    tapSingle.numberOfTouchesRequired = 1
                    
                    self.orderDefaultPic.addGestureRecognizer(tapSingle)
                }
            }
        }
    }
    
    func updateViewData(){
        //下载图片
        downloadOrderImages()
        //初始化值
        var maxPrice = 5000.0
        var currentValue:Double = 0.0
        
        //设置客户心理价(预算）
        
        var quotePriceOfFactory:Float = 0.0
        
        let orderInfoObjects = orderDetail[0] as! NSDictionary
        let designingObjects = orderDetail[1] as! NSArray
        
        //获取系统参数数据
        let statusObjects = systemParam[1] as! NSDictionary
        let productObjects = systemParam[0] as! NSDictionary
        let commandsObjects = systemParam[2] as! NSArray
        
        let commandsCode = orderInfoObjects.value(forKey: "command") as! String
        //订单号
        orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as? String
        //订单时间
        switch _roleType {
        case 1:
            orderTimeLabel.text = orderInfoObjects.value(forKey: "createTime") as? String
        case 2:
            orderTimeLabel.text = orderInfoObjects.value(forKey: "sendDesignTime") as? String
        case 3:
            if _actionType == .quotePrice{
                if self.initQuotePriceInfos.count == 0{
                    if commandsCode.contains("BIDDING_FEEDBACK"){
                        self.getQuoteInfo(quoteType: 3)
                    }else{
                        self.getQuoteInfo(quoteType: 1)
                    }
                    
                }else{
                    orderTimeLabel.text = initQuotePriceInfos[0].value(forKey: "time") as? String
                }
            }else{
                orderTimeLabel.text = orderInfoObjects.value(forKey: "workshopSendTime") as? String
            }
        default:
            orderTimeLabel.text = orderInfoObjects.value(forKey: "createTime") as? String
        }

        
        //参考图
       // orderDefaultPic.image = UIImage(named: "defualt-design-pic")
        //点击预览层
        //产品类型
        let goodsClassObject = productObjects.value(forKey: "goodsClass") as! NSArray
        let productType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "goodsClass") as! String, In: goodsClassObject, By: "goodsClass")
           // (goodsClassObject[Int(orderInfoObjects.value(forKey: "goodsClass") as! String)! - 1] as! NSDictionary).value(forKey: "goodsClass") as! String
        productTypeNameValue.text = productType//orderInfoObjects.value(forKey: "goodsclass") as? String

        //材质
        let materailObject = productObjects.value(forKey: "material") as! NSArray
        let materialType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "material") as! String, In: materailObject, By: "material")
           // (materailObject[Int(orderInfoObjects.value(forKey: "material") as! String)! - 1] as! NSDictionary).value(forKey: "material") as! String
        
        //附件
        var accessoriesType = ""
        let accessoriesObject = productObjects.value(forKey: "accessories") as! NSArray
        if orderInfoObjects.value(forKey: "accessories") as? String == nil{//如果附件为空
            accessoriesType = ""
        }else{
            accessoriesType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "accessories") as! String, In: accessoriesObject, By: "accessories")
                //(accessoriesObject[Int(orderInfoObjects.value(forKey: "accessories") as! String)! - 1] as! NSDictionary).value(forKey: "accessories") as! String
            if accessoriesType == "无" {
                accessoriesType = ""
            }
        }
        //材质 + 附件
        materialAccessoriesValue.text = materialType + " " + accessoriesType
        //订购数目
        if orderInfoObjects.value(forKey: "number") as? Int != nil{
            orderCountValue.text = "x\(orderInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            orderCountValue.text = "x0"
        }

        
        
        //设置工艺值
        var tempMakeStyleValue = ""
        //开模方式
        let modelClassObject = productObjects.value(forKey: "model") as! NSArray
        let modelString = orderInfoObjects.value(forKey: "model") as! String
        var modelType = ""
        let modelArray = modelString.split(separator: ",")
        for item in modelArray{
            //modelType += ",\((modelClassObject[Int(item)! - 1] as! NSDictionary).value(forKey: "model") as! String)"
            modelType += ",\(findValue(key: "id", keyValue: String(item), In: modelClassObject, By: "model"))"
        }
        if modelType == ",无"{
            modelType = ""
        }else{
            tempMakeStyleValue += modelType
        }
        
        //工艺
        let technologyClassObject = productObjects.value(forKey: "technology") as! NSArray
        let technologyString = orderInfoObjects.value(forKey: "technology") as! String
        var technologyType = ""
        let technologyArray = technologyString.split(separator: ",")
        for item in technologyArray{
            technologyType += ",\(findValue(key: "id", keyValue: String(item), In: technologyClassObject, By: "technology"))"
            //",\((technologyClassObject[Int(item)!  - 1] as! NSDictionary).value(forKey: "technology") as! String)"
        }
        if technologyType == ",无"{
            technologyType = ""
        }else{
            if tempMakeStyleValue == ""{
                tempMakeStyleValue += technologyType
            }else{
                tempMakeStyleValue += ";\(technologyType)"
            }
        }
        
        //电镀色
        let colorClassObject = productObjects.value(forKey: "color") as! NSArray
        let colorString = orderInfoObjects.value(forKey: "color") as! String
        var colorType = ""
        let colorArray = colorString.split(separator: ",")
        for item in colorArray{
            colorType += ",\(findValue(key: "id", keyValue: String(item), In: colorClassObject, By: "color"))"
            //",\((colorClassObject[Int(item)! - 1] as! NSDictionary).value(forKey: "color") as! String)"
        }
        if colorType == ",无"{
            colorType = ""
        }else{
            if tempMakeStyleValue == ""{
                tempMakeStyleValue += colorType
            }else{
                tempMakeStyleValue += ";\(colorType)"
            }
        }
        
        tempMakeStyleValue.remove(at: tempMakeStyleValue.startIndex) //删除掉开头的“，”
//        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";无", with: "") //将“;,替换为;
//        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: "无;", with: "") //将“;,替换为;
//        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: "无", with: "") //将“;,替换为;
//        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ",,", with: "") //将“;,替换为;
//        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";;", with: "") //将“;,替换为;
        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";,", with: ";") //将“;,替换为;
        //tempMakeStyleValue.remove(at: tempMakeStyleValue.endIndex)
        makeStyleValue.text = tempMakeStyleValue
        let heightOfLabel = calculateLabelHeightWithText(with: tempMakeStyleValue, labelWidth: makeStyleValue.frame.width, textFont: makeStyleValue.font)
        makeStyleValue.frame = CGRect(x: 143, y: 106, width: kWidth - 163, height: heightOfLabel + 10)
        
        //产品尺寸
        var produceSizeValue = ""
        if orderInfoObjects.value(forKey: "length") as? NSNumber != nil {
            let lengthString =  "\(orderInfoObjects.value(forKey: "length") as! NSNumber)"
            if lengthString.contains("."){
                produceSizeValue = produceSizeValue + "\(orderInfoObjects.value(forKey: "length")as! Double)"
            }else{
                produceSizeValue = produceSizeValue + "\(orderInfoObjects.value(forKey: "length")as! NSNumber)"
            }
        }else{
            produceSizeValue = ""
        }

        if orderInfoObjects.value(forKey: "width") as? NSNumber != nil {
            let widthString =  "\(orderInfoObjects.value(forKey: "width") as! NSNumber)"
            if widthString.contains("."){
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! Double)"
            }else{
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
            }
            //produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "width")as! NSNumber)"
            
        }else{
            produceSizeValue = produceSizeValue + "x "
        }
        if orderInfoObjects.value(forKey: "height") as? NSNumber != nil {
            
            let heightString =  "\(orderInfoObjects.value(forKey: "height") as! NSNumber)"
            if heightString.contains("."){
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! Double)(mm)"
            }else{
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! NSNumber)(mm)"
            }
        }else{
            produceSizeValue = produceSizeValue + "x (mm)"
        }
        productSizeValue.text = produceSizeValue
        
        if heightOfLabel > 40{
            productSizeHint.frame = CGRect(x: 143, y: 186, width: 200, height: 20)
            productSizeValue.frame = CGRect(x: 143, y: 166, width: 200, height: 20)
        }

        switch _actionType {
        case .quotePrice,.dealBargain:
            if orderInfoObjects.value(forKey: "produceMemo") as? String != nil && orderInfoObjects.value(forKey: "produceMemo") as! String != ""{

                let ProduceMemo = orderInfoObjects.value(forKey: "produceMemo") as! String
                ProduceMemoValue.text = ProduceMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: ProduceMemo, labelWidth: ProduceMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                ProduceMemoValue.frame = CGRect(x: 20, y: produceMemoLabel.frame.maxY + 15 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
            }else{
                ProduceMemoValue.text = "无备注信息"
                ProduceMemoValue.textColor = UIColor.titleColors(color: .lightGray)
            }
            adjustActionViewHeight()
            //显示超工期
            var lastPeriod = 0
            if orderInfoObjects.value(forKey: "userPeriod") as? Int == nil{
                deadline = 0
            }else{
                deadline = orderInfoObjects.value(forKey: "userPeriod") as! Int
            }
            if orderInfoObjects.value(forKey: "lastPeriod") as? Int == nil{
                lastPeriod = 0
            }else{
                lastPeriod = orderInfoObjects.value(forKey: "lastPeriod") as! Int
            }
            
            
            if (deadline < lastPeriod) && deadline != 0{
               // greyLayerPrompt.show(text: "订单生产周期超过预期")
                isProduceCycleOverView.isHidden = false
                isProduceCycleOverLabel.isHidden = false
                deadlineLabel.isHidden = false
                isProduceCycleOver = true
                deadlineLabel.text = "客户工期: \(deadline)"
                //return
            }else{
                isProduceCycleOverView.isHidden = true
                isProduceCycleOverLabel.isHidden = true
                deadlineLabel.isHidden = true
                isProduceCycleOver = false
            }
            //设置上次报价
            
            var lastQuotePrice = "0"
            if orderInfoObjects.value(forKey: "lastQuote") as? Double == nil || orderInfoObjects.value(forKey: "lastQuote") as? Double == 0.0{
                lastQuotePrice = "¥-"
            }else{
                lastQuotePrice = "¥\(orderInfoObjects.value(forKey: "lastQuote") as! Double)0"
              //  currentValue = orderInfoObjects.value(forKey: "lastQuote") as! Double
            }
            if lastPeriod == 0 {
                let orignalText = NSMutableAttributedString(string: "上次报价/工期: \(lastQuotePrice) / - 天")
                //上次报价
                let range = orignalText.string.range(of: lastQuotePrice)
                let nsRange = orignalText.string.nsRange(from: range!)
                orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: nsRange)
                quotePriceAtLastLabel.attributedText = orignalText
                //currentValueOnSliderTextField.text = "\(currentValue)"
            }else{
                let orignalText = NSMutableAttributedString(string: "上次报价/工期: \(lastQuotePrice) / \(lastPeriod) 天")
                //上次报价
                let range = orignalText.string.range(of: "\(lastQuotePrice) / \(lastPeriod)")
                let nsRange = orignalText.string.nsRange(from: range!)
                orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: nsRange)
                //上次工期
//                let rangeOfSymbol = orignalText.string.range(of: "上次工期 ")
//                let upperIndex = rangeOfSymbol?.upperBound.samePosition(in: orignalText.string)
//                let length = "\(lastPeriod)".length()
//                let location = orignalText.string.distance(from: orignalText.string.startIndex, to: upperIndex!)
//                let rangeOfPeriod = orignalText.string.range(of: String(lastPeriod))
//                let nsRangeOfPeriod =  orignalText.string.nsRange(from: rangeOfPeriod!)
//
//                orignalText.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)], range: NSRange.init(location: location, length: length))
                quotePriceAtLastLabel.attributedText = orignalText
                //currentValueOnSliderTextField.text = "\(currentValue)"
            }
            
//
            if _actionType == .dealBargain{
                if orderInfoObjects.value(forKey: "workshopBasePrice") as? Double == nil{
                    budgetOveredLabel.text = "客户预算/要求工期: -/-天"
                }else{
                    budgetOveredLabel.text = "客户预算/要求工期: ¥\(orderInfoObjects.value(forKey: "workshopBasePrice") as! Double)元 / \(orderInfoObjects.value(forKey: "userPeriod") as! Int)天"
                }
            }
            
            
        case .acceptDesign:
            print("设置接受设计的值")
            if orderInfoObjects.value(forKey: "memo") as? String != nil && orderInfoObjects.value(forKey: "memo") as! String != ""{

                let designMemo = orderInfoObjects.value(forKey: "memo") as! String
                designMemoValue.text = designMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: designMemo, labelWidth: designMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
            }else{
                designMemoValue.text = "无备注信息"
                designMemoValue.textColor = UIColor.titleColors(color: .lightGray)
            }
            
            //显示设计费
            if orderInfoObjects.value(forKey: "designPrice") as? Float == nil || orderInfoObjects.value(forKey: "designPrice") as? Float == 0.0{
                designFeeValue.text = "-"
            }else{
                designFeeValue.text = "¥\(orderInfoObjects.value(forKey: "designPrice") as! Float)0"
            }
        case .acceptProduce:
           print("设置接受生产的值")
           if orderInfoObjects.value(forKey: "produceMemo") as? String != nil && orderInfoObjects.value(forKey: "produceMemo") as! String != ""{

                let ProduceMemo = orderInfoObjects.value(forKey: "produceMemo") as! String
                ProduceMemoValue.text = ProduceMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: ProduceMemo, labelWidth: ProduceMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                ProduceMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
           }else{
                ProduceMemoValue.text = "无备注信息"
                ProduceMemoValue.textColor = UIColor.titleColors(color: .lightGray)
           }
           adjustActionViewHeight()
           //竞价输入框 - 2.0.4
           if orderInfoObjects.value(forKey: "producePrice") as? Double == nil || orderInfoObjects.value(forKey: "producePrice") as? Float == 0.0{
                orderPriceValue.text = "¥-.--"
           }else{
            if (orderInfoObjects.value(forKey: "lastQuote") as! Float) == 0.0{
                orderPriceValue.text = "¥\(orderInfoObjects.value(forKey: "producePrice") as! NSNumber)"
            }else{
                    if Float(truncating: orderInfoObjects.value(forKey: "producePrice") as! NSNumber) > (orderInfoObjects.value(forKey: "lastQuote") as! Float){
                        orderPriceValue.text = "¥\(orderInfoObjects.value(forKey: "lastQuote") as! NSNumber)"
                    }else{
                        orderPriceValue.text = "¥\(orderInfoObjects.value(forKey: "producePrice") as! NSNumber)"
                    }
                }
           }
        case .designRequires:
            print("设置接受设计的值")
            if orderInfoObjects.value(forKey: "memo") as? String != nil && orderInfoObjects.value(forKey: "memo") as! String != ""{

                let designMemo = orderInfoObjects.value(forKey: "memo") as! String
                designMemoValue.text = designMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: designMemo, labelWidth: designMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
            }else{
                designMemoValue.text = "无备注信息"
                designMemoValue.textColor = UIColor.titleColors(color: .lightGray)
            }
            
            //显示设计费
            if orderInfoObjects.value(forKey: "designPrice") as? Float == nil || orderInfoObjects.value(forKey: "designPrice") as? Float == 0.0{
                designFeeValue.text = "-"
            }else{
                designFeeValue.text = "¥\(orderInfoObjects.value(forKey: "designPrice") as! Float)0"
            }
        case .modifyRequires:
            //设计稿
          //  let designInfos = (orderInfoObjects[5].value(forKey: "designer") as! NSArray)
         //   let desingersInfos = (designInfos[0] as! NSDictionary).value(forKey: "designerpattern") as! NSArray
            
            print("设置接受设计的值")
            //设计要求
            if orderInfoObjects.value(forKey: "memo") as? String != nil && orderInfoObjects.value(forKey: "memo") as! String != ""{

                let designMemo =  orderInfoObjects.value(forKey: "memo") as! String
                designMemoValue.text = designMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: designMemo, labelWidth: designMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
            }else{
                designMemoValue.text = "无备注信息"
                designMemoValue.textColor = UIColor.titleColors(color: .lightGray)
            }
            
            //当前设计稿：
            getDesignPattern()
            
            //设计留言消息：
          //  getDesignMessage()
          
            //如果没有报过价，则显示finalPrice。 如果报过价，取低值
            if orderInfoObjects.value(forKey: "designPrice") as? Float == nil || orderInfoObjects.value(forKey: "designPrice") as? Float == 0.0{
                orderCountValue.text = "¥8.00"
            }else{
                orderCountValue.text = "¥\(orderInfoObjects.value(forKey: "designPrice") as! Float)0"
            }
            
        default:
            print("设置报价的值")
        }
        quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        bargainPriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
    }
    
    func getQuoteInfo(quoteType:Int){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "initQuotePriceDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "initQuotePrice") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["customid"] =  _customID
        params["state"] = quoteType// roletype
        header["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                            print("获取报价信息")
                            self.initQuotePriceInfos.removeAll()
                            let orderQuotePriceInfoItem = json["data"].dictionaryObject! as NSDictionary
                            self.initQuotePriceInfos.append(orderQuotePriceInfoItem)
                            //获取成功数据了，刷新UI
                            DispatchQueue.main.async {
                                self.updateViewData()
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
                            //                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
                            //                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("接受失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: "获取订单详情失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        greyLayerPrompt.show(text: "程序错误. Code:1")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    
    func getDesignMessage(){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "designMessageAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "designMessageAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["customid"] =  _customID
        //  params["roleType"] = _roleType// roletype
        header["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                            print("获取订单详情成功")
                            self.orderDetail.removeAll()
                            let ordersummaryItem = json["data"].dictionaryObject! as NSDictionary
                            let designinfoItem = json["data","designInfo"].arrayObject! as NSArray
                            self.orderDetail.append(ordersummaryItem)
                            self.orderDetail.append(designinfoItem)
                            print("get order detail successed")
                            //获取成功数据了，刷新UI
                            DispatchQueue.main.async {
                                self.updateViewData()
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
//                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("接受失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: "获取订单详情失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        greyLayerPrompt.show(text: "程序错误. Code:1")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    func updateDesignPartten(){
        print("updating design pattern")
        let currentDesignPatternObject = orderDesignPartten[0]
        let designParrtenVerison = currentDesignPatternObject.value(forKey: "version")
        currentDesignParttenTitle.text = "当前设计稿: 第\(designParrtenVerison!)版"
        DispatchQueue.global().async {
            if currentDesignPatternObject.value(forKey: "smallDesignImage1") as? String != nil && currentDesignPatternObject.value(forKey: "smallDesignImage1") as? String != "" {
                let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(currentDesignPatternObject.value(forKey: "smallDesignImage1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    DispatchQueue.main.async {
                        self.currentDesignParttenImageView.image = image
                    }
                    
                }catch{
                    print(error)
                    //缩略图下载失败，下载原图
                    let imageURLString = "\(self.downloadURLHeader)\(currentDesignPatternObject.value(forKey: "initialDesignImage1") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                        let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        DispatchQueue.main.async {
                            self.currentDesignParttenImageView.image = image
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            self.currentDesignParttenImageView.image = UIImage(named:"defualt-design-pic")//  UIImage(image:image)
                        }
                        //原图也下载失败
                    }
                    print("无缩略图")
                }
            }
        }
    }
    func getDesignPattern(){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "designPatternAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "designPatternAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["customid"] =  _customID
        //  params["roleType"] = _roleType// roletype
        header["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                            print("获取设计稿详情成功")
                            self.orderDesignPartten.removeAll()
                            if json["data"].array?.count == 0{
                                print("无设计稿")
                            }else{
                                for item in json["data"].array!{
                                    let dicObject = item.dictionaryObject as! NSDictionary
                                    self.orderDesignPartten.append(dicObject)
                                }
    //                            let ordersummaryItem = json["data"].dictionaryObject! as NSDictionary
    //                            let designinfoItem = json["data","designInfo"].arrayObject! as NSArray
    //                            self.orderDetail.append(ordersummaryItem)
    //                            self.orderDetail.append(designinfoItem)
                                print("get order partten successed")
                                //获取成功数据了，刷新UI
                                DispatchQueue.main.async {
                                    self.updateDesignPartten()
                                }
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
//                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("接受失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: "获取设计稿失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        greyLayerPrompt.show(text: "程序错误. Code:1")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    func adjustActionViewHeight(){
            dashLine.frame = CGRect(x: 20, y: productSizeHint.frame.maxY + 5, width: kWidth + 40, height: 1)
            seperateLine2.frame = CGRect(x: 0, y: ProduceMemoValue.frame.maxY + 5, width: kWidth, height: 5)
           if _actionType == .quotePrice {
                seperateLine3.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 52, width: kWidth - 40, height: 1)
                seperateLine4.frame = CGRect(x: 0, y: seperateLine3.frame.maxY + 80, width: kWidth, height: 5)
                quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 48 , width: kWidth - 20, height: 22)
                quotePriceAtLastTimeValue.frame = CGRect(x: 100, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
                currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
                produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostTextField.frame = CGRect(x: 130, y: seperateLine2.frame.maxY + 4 , width: kWidth - 120, height: 44)
                isProduceCycleOverView.frame = CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY , width: 110, height: 54)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY  , width: 110, height: 27)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: seperateLine2.frame.maxY + 26 , width: 110, height: 27)
           }else if _actionType == .dealBargain{
                overBudgetBackgroundView.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 1, width: kWidth, height: 54)
                seperateLine3.frame = CGRect(x: 20, y: overBudgetBackgroundView.frame.maxY + 52, width: kWidth - 40, height: 1)
                seperateLine4.frame = CGRect(x: 0, y: seperateLine3.frame.maxY + 80, width: kWidth, height: 5)
                quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 48 , width: kWidth - 20, height: 22)
                quotePriceAtLastTimeValue.frame = CGRect(x: 100, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
                currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
                produceTimeCostLabel.frame = CGRect(x: 20, y: overBudgetBackgroundView.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostTextField.frame = CGRect(x: 130, y: overBudgetBackgroundView.frame.maxY + 4 , width: kWidth - 120, height: 44)
                isProduceCycleOverView.frame = CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY , width: 110, height: 54)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY  , width: 110, height: 27)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: overBudgetBackgroundView.frame.maxY + 26 , width: 110, height: 27)
        }
    }
//    //视图滚动中一直触发
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("x:\(scrollView.contentOffset.x) y:\(scrollView.contentOffset.y)")
//       // scrollView.contentSize =  CGSize(width: 0, height: kWidth)
//        //scrollView.frame.offsetBy(dx: scrollView.contentOffset.x, dy: scrollView.contentOffset.y)
//    }
    
}

//if orderstate < 7 { //订单状态小于7 ，订单出于生产前
//    budgetPriceLabel.value = mindPrice
//    if mindPrice != 0.0 {
//        if mindPrice < returnPrice{
//            budgetPriceLabel.show()
//        }else{
//            budgetPriceLabel.hide()
//        }
//    }else{
//        budgetPriceLabel.hide()
//    }
//}else{
//    budgetPriceLabel.show()
//    if returnPrice = 0.0 {
//        budgetPriceLabel.value = finalPrice
//    }else{
//        budgetPriceLabel.value = returnPrice
//    }
//}
