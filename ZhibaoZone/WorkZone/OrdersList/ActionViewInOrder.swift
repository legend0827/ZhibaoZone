//
//  ActionViewInOrder.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class ActionViewInOrder: UIView,UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate {
    
    //弹窗ViewVC
    var popupVC = PopupViewController()
    
    //订单请求参数
    var _roleType:Int = 1
    var _token:String?
    var _userId:String?
    var _actionType:actionType = .quotePrice
    //页面frame
    var _frame:CGRect = CGRect(x: 198, y: 50, width: 150, height: 30)
   
    var _orderID:String = "110000"
    var _customID:String =  "10002020"
    var _goodsID:String = "12123213131"
   
    //订单详情获取到了吗？
    var isOrderDetailsGets = false
    var isBudgetOver = false
    var isProduceCycleOver = false //
    //获取订单截止工期
    var deadline = 0
    //客户心理价
    var mindPrice:Float = 0.0
    
    //订单详情：
    var orderDetail:[NSDictionary] = []
    
    //附件图片下载地址
    var downloadURLHeader = ""
    
    //参考图列表
    var memoPictures:[UIImage] = []
    //参考图类型
    var previewTypes:[String] = []
    //物流公司名称
    var shippingCompanyNameValue:UILabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: kWidth - 40, height: 25))
    let shippingCodeValue:UITextField = UITextField.init(frame: CGRect(x: 120, y: 20, width: kWidth - 140, height: 25))
    
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
    
    let seperateLine2:UIView = UIView.init(frame: CGRect(x: 0, y: 1, width: kWidth, height: 5))
    let seperateLine3:UIView = UIView.init(frame: CGRect(x: 0, y: 2, width: kWidth, height: 5))
    let seperateLine4:UIView = UIView.init(frame: CGRect(x: 20, y: 3, width: kWidth - 40, height: 2))
    let seperateLine5:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    let seperateLine6:UIView = UIView.init(frame: CGRect(x: 20, y: 4, width: kWidth - 40, height: 2))
    
    
    let quotePriceSubmitBtn:UIButton = UIButton.init(type: .custom)
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
    let designFeeLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
            return tempSliderTextField
        }()
    
        //当前设置报价框
        lazy var currentValueOnSliderTextField:UITextField = {
            //label值55，当前值62 差 7
            var tempSliderTextField = UITextField.init(frame: CGRect(x: 110, y: 342, width: 86, height: 30)) // width 225 。 位置 335
            tempSliderTextField.backgroundColor = UIColor.clear//UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            tempSliderTextField.layer.cornerRadius = 5
            tempSliderTextField.delegate = self
            return tempSliderTextField
        }()
    
        override init(frame: CGRect) {
        super.init(frame: frame)
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
        _userId = userInfos.value(forKey: "userid") as? String
        _token = userInfos.value(forKey: "token") as? String
        _frame = frame
        
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if DEBUG
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        #else
            downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
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
        
        self.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        //初始化值
        ActionTitle.frame  = CGRect(x: kWidth/2 - 50, y: 20, width: 100, height: 25)
        ActionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        ActionTitle.textColor = UIColor.titleColors(color: .black)
        ActionTitle.textAlignment = .center
        self.addSubview(ActionTitle)
        
        //取消按钮
        cancelBtn.frame = CGRect(x: kWidth - 80, y: 22, width: 60, height: 22)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.contentHorizontalAlignment = .right
        cancelBtn.addTarget(self, action: #selector(closeActionView), for: .touchUpInside)
        self.addSubview(cancelBtn)
        //背景页面值
        
        backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: self.frame.height - 207 - heightChangeForiPhoneXFromBottom)
        backgroundView.contentSize = CGSize(width: kWidth, height: 541)
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
            
            self.layer.cornerRadius = 20
            
            //订单时间
            orderTimeLabel.frame = CGRect(x: kWidth - 220, y: 12, width: 200, height: 20)
            orderTimeLabel.font = UIFont.systemFont(ofSize: 14)
            orderTimeLabel.textColor = UIColor.titleColors(color: .black)
            orderTimeLabel.textAlignment = .right
            orderTimeLabel.text = "2017-10-16 09:00:00" // for debug
            backgroundView.addSubview(orderTimeLabel)
            
            let seperateLine1:UIView = UIView.init(frame: CGRect(x: 20, y: 44, width: kWidth - 40, height: 2))
            seperateLine1.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine1)
            //参考图
            orderDefaultPic.frame = CGRect(x: 20, y: 62, width: 118, height: 118) // y=62
            orderDefaultPic.image = UIImage(named: "defualt-design-pic")
            orderDefaultPic.layer.cornerRadius = 6
            orderDefaultPic.layer.borderColor = UIColor.lineColors(color: .white).cgColor//UIColor.lineColors(color: .lightGray).cgColor
            orderDefaultPic.layer.borderWidth = 0.5
            orderDefaultPic.layer.masksToBounds = true
            backgroundView.addSubview(orderDefaultPic)
            //点击预览层
            orderDefaultPicLayer.frame = CGRect(x: 20, y: 145, width: 118, height: 35)
            orderDefaultPicLayer.image = UIImage(named: "maskonimage")
            orderDefaultPicLayer.layer.cornerRadius = 6
            orderDefaultPicLayer.layer.masksToBounds = true
            //  backgroundView.addSubview(orderDefaultPicLayer)
            
            
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
            
            quotePriceSubmitBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
            // quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            quotePriceSubmitBtn.backgroundColor = UIColor.gray
            quotePriceSubmitBtn.setTitle("提交报价", for: .normal)
            quotePriceSubmitBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            quotePriceSubmitBtn.backgroundColor = UIColor.gray
            quotePriceSubmitBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
            
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
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine3.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 52, width: kWidth, height: 5)
                seperateLine4.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 52, width: kWidth - 40, height: 2)
                seperateLine5.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 52, width: kWidth - 40, height: 2)
                
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                backgroundView.addSubview(seperateLine2)
                
                quotePriceAtLastLabel.text = "上次报价:"
                quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                quotePriceAtLastLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(quotePriceAtLastLabel)
                
                quotePriceAtLastTimeValue.text = "¥0.00" //for debug
                quotePriceAtLastTimeValue.textColor = UIColor.titleColors(color: .red)
                quotePriceAtLastTimeValue.frame = CGRect(x: 100, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
                quotePriceAtLastTimeValue.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(quotePriceAtLastTimeValue)
                
                
                seperateLine3.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                backgroundView.addSubview(seperateLine3)
                
                quotePriceCurentLabel.text = "设置当前报价:"
                quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
                quotePriceCurentLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(quotePriceCurentLabel)
                
                currentValueOnSliderTextField.text = "¥0.00"
                currentValueOnSliderTextField.textColor = UIColor.titleColors(color: .red)
                currentValueOnSliderTextField.font = UIFont.systemFont(ofSize: 16)
                currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
                currentValueOnSliderTextField.placeholder = "填写金额"
                backgroundView.addSubview(currentValueOnSliderTextField)
                
                
                seperateLine4.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                backgroundView.addSubview(seperateLine4)
                
                produceTimeCostLabel.text = "填写工期:"
                produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
                backgroundView.addSubview(produceTimeCostLabel)
                
                produceTimeCostTextField.text = "" // for debug
                produceTimeCostTextField.frame = CGRect(x: 100, y: seperateLine4.frame.maxY + 4 , width: kWidth - 120, height: 44)
                produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
                produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
                backgroundView.addSubview(produceTimeCostTextField)
                
                seperateLine5.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                backgroundView.addSubview(seperateLine5)
                
                isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: seperateLine4.frame.maxY - 1 , width: 110, height: 54)
                isProduceCycleOverView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
                isProduceCycleOverView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
                isProduceCycleOverView.layer.borderWidth = 1
                isProduceCycleOverView.isHidden = true
                backgroundView.addSubview(isProduceCycleOverView)
                
                isProduceCycleOverLabel.text = "超客户工期"
                isProduceCycleOverLabel.textColor = UIColor.titleColors(color: .red)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: seperateLine4.frame.maxY - 1 , width: 110, height: 27)
                isProduceCycleOverLabel.font = UIFont.systemFont(ofSize: 14)
                isProduceCycleOverLabel.textAlignment = .center
                isProduceCycleOverLabel.isHidden = true
                backgroundView.addSubview(isProduceCycleOverLabel)
                
                
                deadlineLabel.text = "客户工期: "
                deadlineLabel.textColor = UIColor.titleColors(color: .red)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: seperateLine4.frame.maxY + 26 , width: 110, height: 27)
                deadlineLabel.font = UIFont.systemFont(ofSize: 14)
                deadlineLabel.textAlignment = .center
                deadlineLabel.isHidden = true
                backgroundView.addSubview(deadlineLabel)
                
                
                setQuotePriceWeightBtn.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 15, width: 100, height: 22)
                setQuotePriceWeightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                setQuotePriceWeightBtn.contentHorizontalAlignment = .left
                setQuotePriceWeightBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
                setQuotePriceWeightBtn.setTitle("设置精准度", for: .normal)
                setQuotePriceWeightBtn.addTarget(self, action: #selector(setQuotePriceWeight), for: .touchUpInside)
                backgroundView.addSubview(setQuotePriceWeightBtn)
                
                quotePriceSlideBar.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 51, width: kWidth - 40, height: 20)
                quotePriceSlideBar.addTarget(self, action: #selector(quotePriceSliderBarValueChanged(_:)), for: .valueChanged)
                backgroundView.addSubview(quotePriceSlideBar)
                
                quotePriceSlideBarRightLabel.frame = CGRect(x: quotePriceSlideBar.frame.width - 180, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
                quotePriceSlideBarRightLabel.text = "¥5000.00"
                quotePriceSlideBarRightLabel.textAlignment = .right
                quotePriceSlideBarRightLabel.textColor = UIColor.titleColors(color: .gray)
                quotePriceSlideBarRightLabel.font = UIFont.systemFont(ofSize: 12)
                
                quotePriceSlideBarMidLabel.frame = CGRect(x:  quotePriceSlideBar.frame.width/2 - 80 , y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
                quotePriceSlideBarMidLabel.text = "¥2500.00"
                quotePriceSlideBarMidLabel.textAlignment = .center
                quotePriceSlideBarMidLabel.textColor = UIColor.titleColors(color: .gray)
                quotePriceSlideBarMidLabel.font = UIFont.systemFont(ofSize: 12)
                
                quotePriceSlideBarLeftLabel.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
                quotePriceSlideBarLeftLabel.text = "¥0.00"
                quotePriceSlideBarLeftLabel.textColor = UIColor.titleColors(color: .gray)
                quotePriceSlideBarLeftLabel.font = UIFont.systemFont(ofSize: 12)
                
                backgroundView.addSubview(quotePriceSlideBarRightLabel)
                backgroundView.addSubview(quotePriceSlideBarMidLabel)
                backgroundView.addSubview(quotePriceSlideBarLeftLabel)
                
                
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
                acceptDesignConfirmBtn.isHidden = false
                acceptProduceConfirmBtn.isHidden = true
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
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
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = false
                
                seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
                seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
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
                
                seperateLine3.frame = CGRect(x: 0, y: 0, width: kWidth, height: 2)
                seperateLine3.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
                produceTimeCostBackgroundView.addSubview(seperateLine3)
                
                produceTimeCostLabel.text = "填写工期:"
                produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 100, height: 22)
                produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostBackgroundView.addSubview(produceTimeCostLabel)
                
                produceTimeCostTextField.text = "" // for debug
                produceTimeCostTextField.frame = CGRect(x: 100, y: seperateLine3.frame.maxY + 4 , width: kWidth - 120, height: 44)
                produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
                produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
                produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
                produceTimeCostBackgroundView.addSubview(produceTimeCostTextField)
                
                
                isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: seperateLine3.frame.maxY - 1 , width: 110, height: 54)
                isProduceCycleOverView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
                isProduceCycleOverView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
                isProduceCycleOverView.layer.borderWidth = 1
                isProduceCycleOverView.isHidden = true
                produceTimeCostBackgroundView.addSubview(isProduceCycleOverView)
                
                isProduceCycleOverLabel.text = "超客户工期"
                isProduceCycleOverLabel.textColor = UIColor.titleColors(color: .red)
                isProduceCycleOverLabel.frame = CGRect(x:kWidth - 110, y: seperateLine3.frame.maxY - 1 , width: 110, height: 27)
                isProduceCycleOverLabel.font = UIFont.systemFont(ofSize: 14)
                isProduceCycleOverLabel.textAlignment = .center
                isProduceCycleOverLabel.isHidden = true
                produceTimeCostBackgroundView.addSubview(isProduceCycleOverLabel)
                
                
                deadlineLabel.text = "客户工期: "
                deadlineLabel.textColor = UIColor.titleColors(color: .red)
                deadlineLabel.frame = CGRect(x:kWidth - 110, y: seperateLine3.frame.maxY + 26 , width: 110, height: 27)
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
                acceptDesignConfirmBtn.isHidden = true
                acceptProduceConfirmBtn.isHidden = true
            }
        }else{
            //初始化值
            //ActionTitle.frame  = CGRect(x: kWidth/2 - 50, y: 20, width: 100, height: 25)
            ActionTitle.text = "发货"
            
            backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth , height: 360) // 360
            backgroundView.contentSize = CGSize(width: kWidth, height: 239)
            
            cancelBtn.frame = CGRect(x: 20, y: 22, width: 60, height: 22)
            cancelBtn.contentHorizontalAlignment = .left
            
            //确定按钮
            confirmShippingBtn.frame = CGRect(x: kWidth - 80, y: 22 , width: 60, height: 22)
            confirmShippingBtn.setTitle("确定", for: .normal)
            confirmShippingBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            confirmShippingBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            confirmShippingBtn.contentHorizontalAlignment = .right
            confirmShippingBtn.addTarget(self, action: #selector(confirmShippingBtnClicked), for: .touchUpInside)
            self.addSubview(confirmShippingBtn)
            
            
            orderIDLabel.frame = CGRect(x: 20, y: 20, width: 200, height: 25)
            orderIDLabel.font = UIFont.systemFont(ofSize: 18)
            
            orderIDValue.frame = CGRect(x: 20, y: 20, width: kWidth - 40, height: 25)
            orderIDValue.font = UIFont.systemFont(ofSize: 18)
            orderIDValue.textAlignment = .center
            orderIDValue.text = _orderID
            
            seperateLine4.frame = CGRect(x: 20, y: 65, width: kWidth - 40, height: 2)
            seperateLine4.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine4)
            
            let shippingCompanyNameLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine4.frame.maxY + 20, width: 100, height: 25))
            shippingCompanyNameLabel.font = UIFont.systemFont(ofSize: 18)
            shippingCompanyNameLabel.text = "快递公司:"
            backgroundView.addSubview(shippingCompanyNameLabel)
            
            
            shippingCompanyNameValue.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 20, width: kWidth - 40, height: 25)
            shippingCompanyNameValue.font = UIFont.systemFont(ofSize: 18)
            shippingCompanyNameValue.textAlignment = .center
            shippingCompanyNameValue.text = "德邦物流"
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
            seperateLine5.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine5)
            
            let shippingCodeLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine5.frame.maxY + 20, width: 100, height: 25))
            shippingCodeLabel.font = UIFont.systemFont(ofSize: 18)
            shippingCodeLabel.text = "物流单号:"
            backgroundView.addSubview(shippingCodeLabel)
            
            
            shippingCodeValue.frame = CGRect(x: 120, y: seperateLine5.frame.maxY + 20, width: kWidth - 140, height: 25)
            shippingCodeValue.placeholder = "请输入物流单号"
            shippingCodeValue.font = UIFont.systemFont(ofSize: 18)
            shippingCodeValue.keyboardType = .decimalPad
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
            seperateLine6.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine6)
            
        }
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
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String
        
        //获取订单信息
       // let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
       // let customID = orderinfoObject?.value(forKey: "customid") as? String
        //let orderID = orderinfoObject?.value(forKey: "orderid") as? String
        //let goodsID = orderinfoObject?.value(forKey: "goodsid") as? String
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["orderid"] = _orderID //orderID
        params["customid"] = _customID// customID
        params["isreceive"] = 1
        params["commandcode"] = 58
        params["goodsid"] = _goodsID
        params["logisticscompany"] = shippingCompanyNameValue.text as! String
        params["logisticssheetid"] = shippingCodeValue.text as! String
        
        
        var requestUrl:String = ""
        if roletype == "3" {
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "shippingConfirmDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "shippingConfirm") as! String
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
                        print("发货成功")
                        greyLayerPrompt.show(text: "发货成功成功")
                        self.closeActionView()
                    }else{
                        print("发货失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
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
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String

        //获取订单信息
        let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
        let customID = orderinfoObject?.value(forKey: "customid") as? String
        let orderID = orderinfoObject?.value(forKey: "orderid") as? String

        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["orderid"] = orderID
        params["customid"] = customID
        params["isreceive"] = 1
        params["commandcode"] = 143


        var requestUrl:String = ""
        if roletype == "2" {
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "acceptDesignDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "acceptDesign") as! String
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
                        print("接受设计成功")
                        greyLayerPrompt.show(text: "接受设计成功")
                        self.closeActionView()
                    }else{
                        print("接受失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
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
        acceptDesignConfirmBtn.backgroundColor = UIColor.gray
        acceptProduceConfirmBtn.backgroundColor = UIColor.gray
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
            
            self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
            self.acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
        }else{

            //获取用户信息
            let userInfos = getCurrentUserInfo()
            let roletype = userInfos.value(forKey: "roletype") as? String
            let userid = userInfos.value(forKey: "userid") as? String
            let token = userInfos.value(forKey: "token") as? String


            
            //获取订单信息
            let dictionaryObjectInOrderArray = orderDetail[2]// orderArray[selectedIndex]

            let orderInfoObjects = dictionaryObjectInOrderArray.value(forKey: "orderinfo") as! NSDictionary

            let customID = orderInfoObjects.value(forKey: "customid") as? String
            let orderid = orderInfoObjects.value(forKey: "orderid") as? String
            var deadline = 0

            if orderInfoObjects.value(forKey: "deadline") as? Int == nil{
                deadline = 0
            }else{
                deadline = orderInfoObjects.value(forKey: "deadline") as! Int
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
            let currentValueOfQuotePrice = quotePriceSlideBar.value
            
            
            //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
            if mindPrice != 0.0 {
                if _roleType != 1{
                    if _roleType == 3 && (mindPrice < currentValueOfQuotePrice){
                        adjustQuotePriceViewHeight(buggetType: .overBugget, bugget: mindPrice)
                        isBudgetOver = true
                    }else{
                        adjustQuotePriceViewHeight(buggetType: .included, bugget: mindPrice)
                        isBudgetOver = false
                    }
                }else{
                    adjustQuotePriceViewHeight(buggetType: .overBugget, bugget: mindPrice)
                    isBudgetOver = true
                }
            }else{
                adjustQuotePriceViewHeight(buggetType: .included, bugget: mindPrice)
                isBudgetOver = false
            }
            
            //获取列表
            let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
            let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
            let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
            //定义请求参数
            let params:NSMutableDictionary = NSMutableDictionary()
            params["userId"] = userid
            params["roleType"] = roletype
            params["token"] = token
            params["customid"] = customID
            params["orderid"] = orderid
            params["returnprice"] = Int(currentValueOfQuotePrice)//String(format: "%.2f", currentValueOfQuotePrice)
            params["productioncycle"] = produceTimeCostTextField.text
            params["commandcode"] = 141

            var requestUrl:String = ""
            if roletype == "3" {
                #if DEBUG
                requestUrl = apiAddresses.value(forKey: "quotePriceDebug") as! String
                #else
                requestUrl = apiAddresses.value(forKey: "quotePrice") as! String
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
                            if self.isProduceCycleOver {
                                greyLayerPrompt.show(text: "报价成功,但是超过了客户工期")
                            }
                            
                            if self.isBudgetOver{
                                greyLayerPrompt.show(text: "报价成功,但是超过了客户预算")
                                self.quotePriceAtLastTimeValue.text = "¥\(currentValueOfQuotePrice)0"
                                self.adjustQuotePriceViewHeight(buggetType: .overBugget, bugget: self.mindPrice)
                            }
                            
                            if !self.isProduceCycleOver && !self.isBudgetOver{
                                greyLayerPrompt.show(text: "报价成功")
                                self.closeActionView()
                            }
                        }else{
                            print("报价失败，code:\(statusObject)")
                            let errorMsg = json["status","msg"].string!
                            greyLayerPrompt.show(text: errorMsg)
                        }
                    }
                case false:
                    print("处理失败")
                    greyLayerPrompt.show(text: "报价失败,请重试")
                }
                self.quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
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
        let roletype = userInfos.value(forKey: "roletype") as? String
        let userid = userInfos.value(forKey: "userid") as? String
        let token = userInfos.value(forKey: "token") as? String

        //获取订单信息
        let orderinfoObject = orderDetail[2].value(forKey: "orderinfo") as? NSDictionary
        let customID = orderinfoObject?.value(forKey: "customid") as? String
        let orderID = orderinfoObject?.value(forKey: "orderid") as? String
        let goodsID = orderinfoObject?.value(forKey: "goodsid") as? String


        

        if orderinfoObject?.value(forKey: "deadline") as? Int == nil{
            deadline = 0
        }else{
            deadline = orderinfoObject?.value(forKey: "deadline") as! Int
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
        params["userid"] = userid
        params["roletype"] = roletype
        params["token"] = token
        params["orderid"] = orderID
        params["customid"] = customID
        params["goodsid"] = goodsID
        params["isreceive"] = 1
        params["productioncycle"] = produceTimeCostTextField.text
        params["commandcode"] = 171


        var requestUrl:String = ""
        if roletype == "3" {
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "acceptProduceDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "acceptProduce") as! String
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
                        print("接受生产成功")
                        greyLayerPrompt.show(text: "接受生产成功")
                        self.closeActionView()
                    }else{
                        print("接受失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
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
    //关闭报价按钮
    @objc func closeActionView(){
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
        if  textField.isEqual(currentValueOnSliderTextField){
            if currentValueOnSliderTextField.text == ""{
                currentValueOnSliderTextField.text = "0.00"
            }
            let sliderValue = currentValueOnSliderTextField.text
            if Float(sliderValue as! String)! > quotePriceSlideBar.maximumValue {
                quotePriceSlideBar.maximumValue = Float(sliderValue as! String)!
            }
            quotePriceSlideBar.setValue(Float(sliderValue as! String)!, animated: true)
            quotePriceSlideBarRightLabel.text = "¥\(quotePriceSlideBar.maximumValue)0"
            quotePriceSlideBarMidLabel.text = "¥\(quotePriceSlideBar.maximumValue/2)0"
            quotePriceSlideBarLeftLabel.text = "¥0.00"
        }else{
            print("工期完成输入")
        }

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
                self.transform = CGAffineTransform(translationX: 0, y: -216) 
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
                    self.transform = CGAffineTransform(translationX: 0, y: -76 )
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
//            UIView.animate(withDuration: duration, animations: {()->Void in
//                self.blurPopView.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-110))// -(height-35)+200  -632
//            })
        }
       // if  shippingCodeValue.isFirstResponder{
            UIView.animate(withDuration: duration) {
                ()->Void in
                self.transform = CGAffineTransform(translationX: 0, y: 0) //(UIScreen.main.bounds.height + 130)
            }
//        }
//        if  produceTimeCostTextField.isFirstResponder && _actionType == .acceptProduce{
//            UIView.animate(withDuration: duration) {
//                ()->Void in
//                self.transform = CGAffineTransform(translationX: 0, y: 0) //(UIScreen.main.bounds.height + 130)
//            }
//        }
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
        params["userId"] =  _userId// userID
        params["orderId"] =  OrderID
        params["customId"] =  CustomID
        params["roleType"] = _roleType// roletype
        params["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["status","code"].string!
                    if statusObject == "0"{
                        print("获取订单详情成功")
                        self.orderDetail.removeAll()
                        let userinfoItem = json["userinfo"].dictionaryObject! as NSDictionary
                        let orderaddinfoItem = json["orderaddinfo"].dictionaryObject! as NSDictionary
                        let ordersummaryItem = json["ordersummary"].dictionaryObject! as NSDictionary
                        let nicknameItem = json["nickname"].dictionaryObject! as NSDictionary
                        let useraddressItem = json["useraddress"].dictionaryObject! as NSDictionary
                        let designinfoItem = json["designinfo"].dictionaryObject! as NSDictionary
                        self.orderDetail.append(userinfoItem)
                        self.orderDetail.append(orderaddinfoItem)
                        self.orderDetail.append(ordersummaryItem)
                        self.orderDetail.append(nicknameItem)
                        self.orderDetail.append(useraddressItem)
                        self.orderDetail.append(designinfoItem)
                        print("get order detail successed")
                        //获取成功数据了，刷新UI
                        DispatchQueue.main.async {
                            self.updateViewData()
                        }
                    }else{
                        print("接受失败，code:\(statusObject)")
                        let errorMsg = json["status","msg"].string!
                        greyLayerPrompt.show(text: "获取订单详情失败,\(errorMsg)")
                    }
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    
    func updateViewData(){
        //初始化值
        var maxPrice = 5000.0
        var currentValue:Float = 0.0
        
        //设置客户心理价(预算）
        
        var quotePriceOfFactory:Float = 0.0
        
        let dictionaryObjectInOrderArray = orderDetail
        let priceInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "price") as! NSDictionary
        let statusObjects = dictionaryObjectInOrderArray[2].value(forKey: "state") as! NSDictionary
        let goodsInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "goodsinfo") as! NSDictionary
        let orderInfoObjects = dictionaryObjectInOrderArray[2].value(forKey: "orderinfo") as! NSDictionary
        
        let orderaddinfos = dictionaryObjectInOrderArray[1]
        
        let accessoriesObject = goodsInfoObjects.value(forKey: "accessoriesname")
        let colorObject = goodsInfoObjects.value(forKey: "color")
        let sizeObject = goodsInfoObjects.value(forKey: "size") as! NSDictionary
        
        //附件图片数目
        var attachImageCount:Int = 0
        //设计师图递增
        if _roleType == 2{
            memoPictures.removeAll()
            previewTypes.removeAll()
            if orderaddinfos.value(forKey: "imageurl1") as? String != nil && orderaddinfos.value(forKey: "imageurl1") as? String != "" {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "imageurl2") as? String != nil && orderaddinfos.value(forKey: "imageurl2") as? String != "" {
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
                
            }
            if orderaddinfos.value(forKey: "imageurl3") as? String != nil && orderaddinfos.value(forKey: "imageurl3") as? String != ""{
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
        }
        //工厂图递增
        if _roleType == 3{
            memoPictures.removeAll()
            previewTypes.removeAll()
            if orderaddinfos.value(forKey: "fimageurl1") as? String != nil && orderaddinfos.value(forKey: "fimageurl1") as? String != ""{
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "fimageurl2") as? String != nil && orderaddinfos.value(forKey: "fimageurl2") as? String != ""{
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            if orderaddinfos.value(forKey: "fimageurl3") as? String != nil && orderaddinfos.value(forKey: "fimageurl3") as? String != ""{
                let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    memoPictures.append(image!)
                    previewTypes.append("public.image")
                    attachImageCount += 1
                }catch{
                    print(error)
                }
            }
            
            //没有一张工厂的参考图
            if attachImageCount == 0{
                if orderaddinfos.value(forKey: "imageurl1") as? String != nil && orderaddinfos.value(forKey: "imageurl1") as? String != ""{
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        previewTypes.append("public.image")
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
                if orderaddinfos.value(forKey: "imageurl2") as? String != nil && orderaddinfos.value(forKey: "imageurl2") as? String != "" {
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        previewTypes.append("public.image")
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
                if orderaddinfos.value(forKey: "imageurl3") as? String != nil && orderaddinfos.value(forKey: "imageurl3") as? String != ""{
                    let imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        memoPictures.append(image!)
                        previewTypes.append("public.image")
                        attachImageCount += 1
                    }catch{
                        print(error)
                    }
                }
            }
        }
        
        orderDefaultPicLayer.removeFromSuperview()
        for subview in orderDefaultPic.subviews{
            subview.removeFromSuperview()
        }
        
        if attachImageCount != 0{
            orderDefaultPicLayer.frame = CGRect(x: 0, y: 118 - 35, width: 118, height: 35)
            orderDefaultPic.addSubview(orderDefaultPicLayer)
            for i in 1...attachImageCount{
                //附件数目小红点
                let pointSize:CGSize = CGSize(width: 5, height: 5)
                let positionOffset:CGFloat = 35.0
                let positionLength = orderDefaultPicLayer.frame.width
                
                let xPoint = (positionLength - positionOffset * 2) / CGFloat(attachImageCount + 1) + positionOffset - pointSize.width / 2
                let pointGrow = (positionLength - positionOffset * 2) / CGFloat(attachImageCount + 1)
                let imageCountLabel:UILabel = UILabel.init(frame: CGRect(x: xPoint + pointGrow * CGFloat(i - 1), y: 103, width: 5, height: 5))
                imageCountLabel.backgroundColor = UIColor.white
                imageCountLabel.layer.cornerRadius = 2.5
                //imageCountLabel.text = "\(attachImageCount)"
                imageCountLabel.textColor =  #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
                imageCountLabel.textAlignment = .center
                imageCountLabel.clipsToBounds = true // 对Label切角度
                
                orderDefaultPic.addSubview(imageCountLabel)
            }
            orderDefaultPic.isUserInteractionEnabled = true
            
            let tapSingle=UITapGestureRecognizer(target:self,
                                                 action:#selector(imageViewTap(_:)))
            tapSingle.numberOfTapsRequired = 1
            tapSingle.numberOfTouchesRequired = 1
            
            orderDefaultPic.addGestureRecognizer(tapSingle)
        }
        
        
        //设置图片
        if _roleType == 2 {
            var imageURLString:String = ""
            if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
                if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
                    if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
                        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                    }else{
                        //第三张图不为空
                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            let image = UIImage.gif(data:data)
                            orderDefaultPic.image = image//  UIImage(image:image)
                        }catch{
                            print(error)
                        }
                    }
                }else{
                    //第二不为空
                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        orderDefaultPic.image = image//  UIImage(image:image)
                    }catch{
                        print(error)
                    }
                }
            }else{
                //第一张图不为空
                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    orderDefaultPic.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
            }
        }else if _roleType == 3{
            var imageURLString:String = ""
            if orderaddinfos.value(forKey: "fimageurl1") as? String == nil {
                if orderaddinfos.value(forKey: "fimageurl2") as? String == nil {
                    if orderaddinfos.value(forKey: "fimageurl3") as? String == nil {
                        //三张工厂参考图都为空，加载设计参考图
                        if orderaddinfos.value(forKey: "imageurl1") as? String == nil {
                            if orderaddinfos.value(forKey: "imageurl2") as? String == nil {
                                if orderaddinfos.value(forKey: "imageurl3") as? String == nil {
                                    orderDefaultPic.image = UIImage(named:"defualt-design-pic")
                                }else{
                                    //第三张图不为空
                                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl3") as! String)"
                                    let url = URL(string: imageURLString)!
                                    do{
                                        let data = try Data.init(contentsOf: url)
                                        let image = UIImage.gif(data:data)
                                        orderDefaultPic.image = image//  UIImage(image:image)
                                    }catch{
                                        print(error)
                                    }
                                }
                            }else{
                                //第二不为空
                                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl2") as! String)"
                                let url = URL(string: imageURLString)!
                                do{
                                    let data = try Data.init(contentsOf: url)
                                    let image = UIImage.gif(data:data)
                                    orderDefaultPic.image = image//  UIImage(image:image)
                                }catch{
                                    print(error)
                                }
                            }
                        }else{
                            //第一张图不为空
                            imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "imageurl1") as! String)"
                            let url = URL(string: imageURLString)!
                            do{
                                let data = try Data.init(contentsOf: url)
                                let image = UIImage.gif(data:data)
                                orderDefaultPic.image = image//  UIImage(image:image)
                            }catch{
                                print(error)
                            }
                        }
                    }else{
                        //第三张图不为空
                        imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl3") as! String)"
                        let url = URL(string: imageURLString)!
                        do{
                            let data = try Data.init(contentsOf: url)
                            let image = UIImage.gif(data:data)
                            orderDefaultPic.image = image//  UIImage(image:image)
                        }catch{
                            print(error)
                        }
                    }
                }else{
                    //第二不为空
                    imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl2") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let image = UIImage.gif(data:data)
                        orderDefaultPic.image = image//  UIImage(image:image)
                    }catch{
                        print(error)
                    }
                }
            }else{
                //第一张图不为空
                imageURLString = "\(downloadURLHeader)\(orderaddinfos.value(forKey: "fimageurl1") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    orderDefaultPic.image = image//  UIImage(image:image)
                }catch{
                    print(error)
                }
            }
        }else{
            orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        }
        
        
        //订单号
        orderIDValue.text = orderInfoObjects.value(forKey: "orderid") as? String
        //订单时间
        orderTimeLabel.text = orderInfoObjects.value(forKey: "createtime") as? String
        
        //参考图
       // orderDefaultPic.image = UIImage(named: "defualt-design-pic")
        //点击预览层
        
        //产品类型
        productTypeNameValue.text = orderInfoObjects.value(forKey: "goodsclass") as? String
        
        //订购数目
        if goodsInfoObjects.value(forKey: "number") as? Int != nil{
            orderCountValue.text = "x\(goodsInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            orderCountValue.text = "x0"
        }

        // 设置材质+附件值
        var tempMaterialAndAccessoriesValue = ""
        if goodsInfoObjects.value(forKey: "texturename") as? String != nil{
            let texturenameValue = goodsInfoObjects.value(forKey: "texturename") as! String
            tempMaterialAndAccessoriesValue = "\(texturenameValue) "
        }
        if accessoriesObject as? String != nil{
            let accessoriesValue  = accessoriesObject as! String
            tempMaterialAndAccessoriesValue = tempMaterialAndAccessoriesValue + accessoriesValue
        }
        //材质 + 附件
        materialAccessoriesValue.text = tempMaterialAndAccessoriesValue
        
        //设置工艺值
        var tempMakeStyleValue = ""
        var colorValue = ""
        if colorObject as? String != nil {
            colorValue = colorObject as! String
            tempMakeStyleValue += ",\(colorValue)"
        }
        var shapeVlaue = ""
        if goodsInfoObjects.value(forKey: "shape") as? String != nil{
            shapeVlaue = goodsInfoObjects.value(forKey: "shape") as! String
            tempMakeStyleValue += ",\(shapeVlaue)"
        }
        
        var technologyValue = ""
        if goodsInfoObjects.value(forKey: "technology") as? String != nil{
            technologyValue = goodsInfoObjects.value(forKey: "technology") as! String
            tempMakeStyleValue += ",\(technologyValue)"
        }
        
        tempMakeStyleValue.remove(at: tempMakeStyleValue.startIndex) //删除掉开头的“，”
        tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";,", with: ";") //将“;,替换为;
        makeStyleValue.text = tempMakeStyleValue
        let heightOfLabel = calculateLabelHeightWithText(with: tempMakeStyleValue, labelWidth: makeStyleValue.frame.width, textFont: makeStyleValue.font)
        makeStyleValue.frame = CGRect(x: 143, y: 106, width: kWidth - 163, height: heightOfLabel + 10)
        
        //产品尺寸
        var produceSizeValue = ""
        if sizeObject.value(forKey: "length") as? Float != nil {
            produceSizeValue = "\(sizeObject.value(forKey: "length")as! Float)"
        }else{
            produceSizeValue = ""
        }
        
        if sizeObject.value(forKey: "width") as? Float != nil {
            produceSizeValue = produceSizeValue + "x\(sizeObject.value(forKey: "width")as! Float)"
        }else{
            produceSizeValue = produceSizeValue + "x "
        }
        if sizeObject.value(forKey: "height") as? Float != nil {
            produceSizeValue = produceSizeValue + "x\(sizeObject.value(forKey: "height")as! Float)(mm)"
        }else{
            produceSizeValue = produceSizeValue + "x (mm)"
        }
        productSizeValue.text = produceSizeValue
        
        if heightOfLabel > 40{
            productSizeHint.frame = CGRect(x: 143, y: 186, width: 200, height: 20)
            productSizeValue.frame = CGRect(x: 143, y: 166, width: 200, height: 20)
        }

        switch _actionType {
        case .quotePrice:
            //优先客户心理价，再估价，再系统估价
            if priceInfoObjects.value(forKey: "mindprice") as? Float == nil || priceInfoObjects.value(forKey: "mindprice") as! Float == 0.0{
                if priceInfoObjects.value(forKey: "extent1") as? Float == nil || priceInfoObjects.value(forKey: "extent1") as! Float == 0.0{
                    if priceInfoObjects.value(forKey: "returnprice") as? Float == nil || priceInfoObjects.value(forKey: "returnprice") as! Float == 0.0{
                        maxPrice = 5000.0
                    }else{
                        maxPrice = Double(priceInfoObjects.value(forKey: "returnprice") as! Float) * 3
                    }
                }else{
                    maxPrice = Double(priceInfoObjects.value(forKey: "extent1") as! Float) * 3
                }
            }else{
                maxPrice = Double((priceInfoObjects.value(forKey: "mindprice") as! Float)*3)
            }
            
            //设置上次报价
            if priceInfoObjects.value(forKey: "returnprice") as? Float == nil{
                quotePriceAtLastTimeValue.text = "¥0.00"
            }else{
                quotePriceAtLastTimeValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
                quotePriceOfFactory = priceInfoObjects.value(forKey: "returnprice") as! Float
                currentValue = Float(priceInfoObjects.value(forKey: "returnprice") as! Float)
            }
            quotePriceSlideBarRightLabel.text = "¥\(maxPrice)0"
            quotePriceSlideBarMidLabel.text = "¥\(maxPrice/2)0"
            quotePriceSlideBarLeftLabel.text = "¥0.00"
            currentValueOnSliderTextField.text = "\(currentValue)"
            quotePriceSlideBar.maximumValue = Float(maxPrice)
            quotePriceSlideBar.setValue(currentValue, animated: true)
            
            if priceInfoObjects.value(forKey: "mindprice") as? Float == nil{
                budgetPriceValue.text = "¥0.00"
            }else{
                budgetPriceValue.text = "¥\(priceInfoObjects.value(forKey: "mindprice") as! Float)0"
                mindPrice = priceInfoObjects.value(forKey: "mindprice") as! Float
            }
            
            
            //如果工厂身份，并且报价高于客户心理价，显示客户心理价. 否则不显示
            if mindPrice != 0.0 {
                if _roleType != 1{
                    if _roleType == 3 && (mindPrice < quotePriceOfFactory){
                        if (statusObjects.value(forKey:"payoffstate") as! NSDictionary).value(forKey: "code") as! Int == 1{
                            adjustQuotePriceViewHeight(buggetType: .included, bugget: mindPrice)
                            isBudgetOver = false
                        }else{
                            adjustQuotePriceViewHeight(buggetType: .overBugget, bugget: mindPrice)
                            isBudgetOver = true
                        }
                    }else{
                        adjustQuotePriceViewHeight(buggetType: .included, bugget: mindPrice)
                        isBudgetOver = false
                    }
                }else{
                    adjustQuotePriceViewHeight(buggetType: .overBugget, bugget: mindPrice)
                    isBudgetOver = true
                }
            }else{
                adjustQuotePriceViewHeight(buggetType: .included, bugget: mindPrice)
                isBudgetOver = false
            }
        case .acceptDesign:
            print("设置接受设计的值")
            if orderaddinfos.value(forKey: "remarks") as? String != nil && orderaddinfos.value(forKey: "remarks") as! String != ""{
                
                let designMemo = orderaddinfos.value(forKey: "remarks") as! String
                designMemoValue.text = designMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: designMemo, labelWidth: designMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                designMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
            }else{
                designMemoValue.text = "无备注信息"
                designMemoValue.textColor = UIColor.titleColors(color: .lightGray)
            }
            
            //如果没有报过价，则显示finalPrice。 如果报过价，取低值
            if priceInfoObjects.value(forKey: "designprice") as? Float == nil || priceInfoObjects.value(forKey: "designprice") as? Float == 0.0{
                designFeeValue.text = "¥8.00"
            }else{
                designFeeValue.text = "¥\(priceInfoObjects.value(forKey: "designprice") as! Float)0"
            }
        case .acceptProduce:
           print("设置接受生产的值")
           if orderaddinfos.value(forKey: "fremarks") as? String != nil && orderaddinfos.value(forKey: "fremarks") as! String != ""{
            
                let ProduceMemo = orderaddinfos.value(forKey: "fremarks") as! String
                ProduceMemoValue.text = ProduceMemo
                let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: ProduceMemo, labelWidth: ProduceMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
                ProduceMemoValue.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 37 , width: kWidth - 40, height: heightOfProduceMemoLabel + 10)
           }else{
                ProduceMemoValue.text = "无备注信息"
                ProduceMemoValue.textColor = UIColor.titleColors(color: .lightGray)
           }
           
           //如果没有报过价，则显示finalPrice。 如果报过价，取低值
           if priceInfoObjects.value(forKey: "returnprice") as? Float == nil || priceInfoObjects.value(forKey: "returnprice") as? Float == 0.0{
                orderPriceValue.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Float)0"
           }else{
                if priceInfoObjects.value(forKey: "finalprice") as! Float > priceInfoObjects.value(forKey: "returnprice") as! Float{
                    orderPriceValue.text = "¥\(priceInfoObjects.value(forKey: "returnprice") as! Float)0"
                }else{
                    orderPriceValue.text = "¥\(priceInfoObjects.value(forKey: "finalprice") as! Float)0"
                }
           }
            
        default:
            print("设置报价的值")
        }
        quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
    }
    
    func adjustQuotePriceViewHeight(buggetType:quotePriceOverType,bugget:Float){
        if buggetType == .overBugget{
            budgetPriceLabel.isHidden = false
            budgetPriceValue.isHidden = false
            budgetOveredLabel.isHidden = false
            overBudgetBackgroundView.isHidden = false
            
            seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
            seperateLine3.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 104, width: kWidth, height: 5)
            seperateLine4.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 52, width: kWidth - 40, height: 2)
            seperateLine5.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 52, width: kWidth - 40, height: 2)
            
            overBudgetBackgroundView.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 52, width: kWidth, height: 53)
            overBudgetBackgroundView.backgroundColor = UIColor.backgroundColors(color: .lightRed)
            overBudgetBackgroundView.layer.borderColor = UIColor.iconColors(color: .lightRed).cgColor
            overBudgetBackgroundView.layer.borderWidth = 1
            backgroundView.addSubview(overBudgetBackgroundView)
            
            budgetPriceLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 67 , width: 100, height: 22)
            budgetPriceLabel.text = "客户预算:"
            budgetPriceLabel.font = UIFont.systemFont(ofSize: 16)
            budgetPriceLabel.textColor = UIColor.titleColors(color: .red)
            backgroundView.addSubview(budgetPriceLabel)
            
            budgetPriceValue.frame = CGRect(x: 100, y: seperateLine2.frame.maxY + 67 , width: 100, height: 22)
            budgetPriceValue.text = "¥\(bugget)" //for debug
            budgetPriceValue.textColor = UIColor.titleColors(color: .red)
            budgetPriceValue.font = UIFont.systemFont(ofSize: 16)
            backgroundView.addSubview(budgetPriceValue)
            
            budgetOveredLabel.frame = CGRect(x: kWidth - 120, y: seperateLine2.frame.maxY + 67 , width: 100, height: 22)
            budgetOveredLabel.text = "超预算" //for debug
            budgetOveredLabel.textAlignment = .right
            budgetOveredLabel.textColor = UIColor.titleColors(color: .red)
            budgetOveredLabel.font = UIFont.systemFont(ofSize: 16)
            backgroundView.addSubview(budgetOveredLabel)

            quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
            currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
            produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 15 , width: 100, height: 22)
            isProduceCycleOverView.frame =  CGRect(x:kWidth - 110, y: seperateLine4.frame.maxY - 1 , width: 110, height: 54)
            isProduceCycleOverLabel.frame = CGRect(x:kWidth - 100, y: seperateLine4.frame.maxY - 1 , width: 100, height: 27)
            deadlineLabel.frame = CGRect(x:kWidth - 100, y: seperateLine4.frame.maxY + 26 , width: 100, height: 27)
            produceTimeCostTextField.frame = CGRect(x: 100, y: seperateLine4.frame.maxY + 4 , width: kWidth - 120, height: 44)
            setQuotePriceWeightBtn.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 15, width: 100, height: 22)
            quotePriceSlideBar.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 51, width: kWidth - 40, height: 20)
            quotePriceSlideBarRightLabel.frame = CGRect(x: quotePriceSlideBar.frame.width - 180, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarMidLabel.frame = CGRect(x:  quotePriceSlideBar.frame.width/2 - 80 , y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarLeftLabel.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)

        }else{
            budgetPriceLabel.isHidden = true
            budgetPriceValue.isHidden = true
            budgetOveredLabel.isHidden = true
            overBudgetBackgroundView.isHidden = true
            
            seperateLine2.frame = CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5)
            seperateLine3.frame = CGRect(x: 0, y: seperateLine2.frame.maxY + 52, width: kWidth, height: 5)
            seperateLine4.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 52, width: kWidth - 40, height: 2)
            seperateLine5.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 52, width: kWidth - 40, height: 2)
            
            quotePriceCurentLabel.frame = CGRect(x: 20, y: seperateLine3.frame.maxY + 15 , width: 120, height: 22)
            currentValueOnSliderTextField.frame = CGRect(x: 130, y: seperateLine3.frame.maxY + 4 , width: kWidth - 150, height: 44)
            produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 15 , width: 100, height: 22)
            produceTimeCostTextField.frame = CGRect(x: 100, y: seperateLine4.frame.maxY + 4 , width: kWidth - 120, height: 44)
            setQuotePriceWeightBtn.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 15, width: 100, height: 22)
            quotePriceSlideBar.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 51, width: kWidth - 40, height: 20)
            quotePriceSlideBarRightLabel.frame = CGRect(x: quotePriceSlideBar.frame.width - 180, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarMidLabel.frame = CGRect(x:  quotePriceSlideBar.frame.width/2 - 80 , y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarLeftLabel.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
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
