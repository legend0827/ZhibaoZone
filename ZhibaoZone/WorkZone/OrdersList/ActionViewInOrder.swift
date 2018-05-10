//
//  ActionViewInOrder.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class ActionViewInOrder: UIView,UITextViewDelegate,UITextFieldDelegate {
    
    //弹窗ViewVC
    var popupVC = PopupViewController()
    
    //订单请求参数
    var _royeType:Int = 1
    var _token:String?
    var _userId:String?
    var _actionType:actionType = .quotePrice
    //页面frame
    var _frame:CGRect = CGRect(x: 198, y: 50, width: 150, height: 30)
   
    var _orderID:String = "110000"
    var _customID:String "10002020"
   
    //订单详情获取到了吗？
    var isOrderDetailsGets = false
    
    //订单详情：
    var orderDetail:[NSDictionary] = []
    
    //附件图片下载地址
    var downloadURLHeader = ""
    
    //参考图列表
    var memoPictures:[UIImage] = []
    
    
    //页面元素
    let ActionTitle:UILabel = UILabel.init(frame: CGRect(x: kWidth/2 - 38, y: 20, width: 72, height: 25))
    let cancelBtn:UIButton = UIButton.init(type: .custom)
    let backgroundView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
   
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
    
    let customerPriceValue:UILabel = UILabel.init(frame: CGRect(x: 225, y: 295, width: 200, height: 44))
    let customerPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))

    let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 65, y: 285, width: 200, height: 44))
    let setQuotePriceWeightBtn:UIButton = UIButton.init(type: .system)
    
    let quotePriceSlideBarRightLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    let quotePriceSlideBarMidLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 320, height: 30))
    let quotePriceSlideBarLeftLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 250, height: 30))
    
    let quotePriceSubmitBtn:UIButton = UIButton.init(type: .custom)
    let acceptDesignConfirmBtn:UIButton = UIButton.init(type: .custom)
    let acceptProduceConfirmBtn:UIButton = UIButton.init(type: .custom)
    
    //生产工期Label
    let produceTimeCostLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
    
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
        _royeType = Int((userInfos.value(forKey: "roletype") as? String)!)!
        _userId = userInfos.value(forKey: "userid") as? String
        _token = userInfos.value(forKey: "token") as? String
        _frame = frame

    }
    func getOrderDetailFromServer(){
        DispatchQueue.global(qos: .background).async {
            self.getOrderDetails(OrderID: _orderID, CustomID: _customID)
        }
    }
    
    //使用ActionType创建View
    func createViewWithActionType(ActionType:actionType){
        self.layer.cornerRadius = 20
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
        backgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
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
        
        orderIDValue.text = "10023012030123" // for debug
        
        //订单时间
        orderTimeLabel.frame = CGRect(x: kWidth - 220, y: 12, width: 200, height: 20)
        orderTimeLabel.font = UIFont.systemFont(ofSize: 14)
        orderTimeLabel.textColor = UIColor.titleColors(color: .black)
        orderTimeLabel.textAlignment = .right
        orderTimeLabel.text = "2018-01-29 12:00:12" // for debug
        backgroundView.addSubview(orderTimeLabel)
        
        let seperateLine1:UIView = UIView.init(frame: CGRect(x: 20, y: 44, width: kWidth - 40, height: 2))
        seperateLine1.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        backgroundView.addSubview(seperateLine1)
        //参考图
        orderDefaultPic.frame = CGRect(x: 20, y: 62, width: 118, height: 118)
        orderDefaultPic.image = UIImage(named: "defualt-design-pic")
        orderDefaultPic.layer.cornerRadius = 6
        orderDefaultPic.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
        orderDefaultPic.layer.borderWidth = 0.5
        backgroundView.addSubview(orderDefaultPic)
        //点击预览层
        orderDefaultPicLayer.frame = CGRect(x: 20, y: 145, width: 118, height: 35)
        orderDefaultPicLayer.image = UIImage(named: "maskonimage")
        orderDefaultPicLayer.layer.cornerRadius = 6
        backgroundView.addSubview(orderDefaultPicLayer)

        
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
        orderCountValue.text = "x200000" // for debug
        backgroundView.addSubview(orderCountValue)
        
        
        //工艺
        makeStyleValue.frame = CGRect(x: 143, y: 106, width: kWidth - 163, height: 60)
        makeStyleValue.numberOfLines = 3
        makeStyleValue.font = UIFont.systemFont(ofSize: 14)
        makeStyleValue.textColor = UIColor.titleColors(color: .darkGray)
        makeStyleValue.text = "2D;烤漆;光磨;磨砂;亮黑;浅蓝;烤漆;粉紫;蓝色;烤漆黑;黑黄;白色金;锖" // for debug
        backgroundView.addSubview(makeStyleValue)
        
        //材质 + 附件
        materialAccessoriesValue.frame = CGRect(x: 143, y: 86, width: 280, height: 20)
        materialAccessoriesValue.font = UIFont.systemFont(ofSize: 14)
        materialAccessoriesValue.textColor = UIColor.titleColors(color: .darkGray)
        materialAccessoriesValue.text = "锌合金  别针；" // for debug
        backgroundView.addSubview(materialAccessoriesValue)
        //产品尺寸
        //长
        // x: 190
        productSizeValue.frame = CGRect(x: 143, y: 166, width: 200, height: 20)
        productSizeValue.font = UIFont.systemFont(ofSize: 14)
        productSizeValue.textColor = UIColor.titleColors(color: .darkGray)
        productSizeValue.text = "300.5×300×200(mm)" // for debug
        backgroundView.addSubview(productSizeValue)
        
        productSizeHint.frame = CGRect(x: 143, y: 186, width: 200, height: 20)
        productSizeHint.font = UIFont.systemFont(ofSize: 10)
        productSizeHint.textColor = UIColor.titleColors(color: .gray)
        productSizeHint.text = "注：圆形产品直径参考长度(或宽度)值"
        backgroundView.addSubview(productSizeHint)
        
        quotePriceSubmitBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
        quotePriceSubmitBtn.backgroundColor = UIColor.iconColors(color: .red)
        quotePriceSubmitBtn.setTitle("提交报价", for: .normal)
        quotePriceSubmitBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        quotePriceSubmitBtn.addTarget(self, action: #selector(confirmQuotePriceBtnClicked), for: .touchUpInside)
        
        acceptDesignConfirmBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
        acceptDesignConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptDesignConfirmBtn.setTitle("接受设计", for: .normal)
        acceptDesignConfirmBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        quotePriceSubmitBtn.addTarget(self, action: #selector(confirmAcceptDesignBtnClicked), for: .touchUpInside)
        
        
        acceptProduceConfirmBtn.frame = CGRect(x: kWidth - 120, y: self.frame.height - 142 - heightChangeForiPhoneXFromBottom, width: 120, height: 56)
        acceptProduceConfirmBtn.backgroundColor = UIColor.iconColors(color: .red)
        acceptProduceConfirmBtn.setTitle("接受生产", for: .normal)
        acceptProduceConfirmBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        quotePriceSubmitBtn.addTarget(self, action: #selector(confirmAcceptProduceBtnClicked), for: .touchUpInside)
        
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
            
            let seperateLine2:UIView = UIView.init(frame: CGRect(x: 0, y: productSizeHint.frame.maxY + 5, width: kWidth, height: 5))
            seperateLine2.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine2)
            
            quotePriceAtLastLabel.text = "上次报价:"
            quotePriceAtLastLabel.frame = CGRect(x: 20, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
            quotePriceAtLastLabel.font = UIFont.systemFont(ofSize: 16)
            backgroundView.addSubview(quotePriceAtLastLabel)
            
            quotePriceAtLastTimeValue.text = "¥5392.00" //for debug
            quotePriceAtLastTimeValue.textColor = UIColor.titleColors(color: .red)
            quotePriceAtLastTimeValue.frame = CGRect(x: 100, y: seperateLine2.frame.maxY + 15 , width: 100, height: 22)
            quotePriceAtLastTimeValue.font = UIFont.systemFont(ofSize: 16)
            backgroundView.addSubview(quotePriceAtLastTimeValue)
            
            let seperateLine3:UIView = UIView.init(frame: CGRect(x: 0, y: seperateLine2.frame.maxY + 52, width: kWidth, height: 5))
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
            
            let seperateLine4:UIView = UIView.init(frame: CGRect(x: 20, y: seperateLine3.frame.maxY + 52, width: kWidth - 40, height: 2))
            seperateLine4.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine4)
            
            produceTimeCostLabel.text = "填写工期:"
            produceTimeCostLabel.frame = CGRect(x: 20, y: seperateLine4.frame.maxY + 15 , width: 100, height: 22)
            produceTimeCostLabel.font = UIFont.systemFont(ofSize: 16)
            backgroundView.addSubview(produceTimeCostLabel)
            
            produceTimeCostTextField.text = "18" // for debug
            produceTimeCostTextField.frame = CGRect(x: 100, y: seperateLine4.frame.maxY + 4 , width: kWidth - 120, height: 44)
            produceTimeCostTextField.textColor = UIColor.titleColors(color: .black)
            produceTimeCostTextField.font = UIFont.systemFont(ofSize: 16)
            produceTimeCostTextField.placeholder = "填写完成生产、发货时间"
            backgroundView.addSubview(produceTimeCostTextField)
            
            let seperateLine5:UIView = UIView.init(frame: CGRect(x: 20, y: seperateLine4.frame.maxY + 52, width: kWidth - 40, height: 2))
            seperateLine5.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
            backgroundView.addSubview(seperateLine5)
            
            setQuotePriceWeightBtn.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 15, width: 100, height: 22)
            setQuotePriceWeightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            setQuotePriceWeightBtn.contentHorizontalAlignment = .left
            setQuotePriceWeightBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            setQuotePriceWeightBtn.setTitle("设置精准度", for: .normal)
            setQuotePriceWeightBtn.addTarget(self, action: #selector(setQuotePriceWeight), for: .touchUpInside)
            backgroundView.addSubview(setQuotePriceWeightBtn)
            
            quotePriceSlideBar.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 51, width: kWidth - 40, height: 20)
            backgroundView.addSubview(quotePriceSlideBar)
            
            quotePriceSlideBarRightLabel.frame = CGRect(x: quotePriceSlideBar.frame.width - 180, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarRightLabel.text = "¥5000.00"
            quotePriceSlideBarRightLabel.textAlignment = .right
            quotePriceSlideBarRightLabel.textColor = UIColor.titleColors(color: .lightGray)
            quotePriceSlideBarRightLabel.font = UIFont.systemFont(ofSize: 12)
            
            quotePriceSlideBarMidLabel.frame = CGRect(x:  quotePriceSlideBar.frame.width/2 - 80 , y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarMidLabel.text = "¥10.00"
            quotePriceSlideBarMidLabel.textAlignment = .center
            quotePriceSlideBarMidLabel.textColor = UIColor.titleColors(color: .lightGray)
            quotePriceSlideBarMidLabel.font = UIFont.systemFont(ofSize: 12)
            
            quotePriceSlideBarLeftLabel.frame = CGRect(x: 20, y: seperateLine5.frame.maxY + 72, width: 200, height: 22)
            quotePriceSlideBarLeftLabel.text = "¥0.00"
            quotePriceSlideBarLeftLabel.textColor = UIColor.titleColors(color: .lightGray)
            quotePriceSlideBarLeftLabel.font = UIFont.systemFont(ofSize: 12)
            
            backgroundView.addSubview(quotePriceSlideBarRightLabel)
            backgroundView.addSubview(quotePriceSlideBarMidLabel)
            backgroundView.addSubview(quotePriceSlideBarLeftLabel)
            
            
        case .acceptDesign:
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
            
        case .acceptProduce:
            ActionTitle.text = "接受生产"
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
            acceptDesignConfirmBtn.isHidden = true
            acceptProduceConfirmBtn.isHidden = false
            
        default:
            ActionTitle.text = "订单报价"
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
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置权重
    @objc func setQuotePriceWeight(){
        let setParameterVC = SetParamtersViewController(roleType: _royeType)
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
        if produceTimeCostTextField.text == ""{
            greyLayerPrompt.show(text: "生产工期不能为空,请重试")
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
                //return
            }
            //获取报价信息
            let currentValueOfQuotePrice = quotePriceSlideBar.value
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
                    print("报价成功")
                    greyLayerPrompt.show(text: "报价成功")
                    self.closeActionView()
                case false:
                    print("处理失败")
                    greyLayerPrompt.show(text: "报价失败,请重试")
                }
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


        //获取订单信息
        var deadline = 0

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
        //previewVC.PreviewType = previewTypes
        popupVC.present(previewVC, animated: true, completion: nil)
        
        
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

        if currentValueOnSliderTextField.isFirstResponder{
            //界面偏移动画
            //UIScreen.main.bounds.height
//            UIView.animate(withDuration: duration, animations: { ()->Void in
//                self.blurPopView.transform = CGAffineTransform(translationX: 0, y:-(UIScreen.main.bounds.height + 130)) //-(height+300)+200
//            })
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
    }
    
    func getOrderDetails(OrderID:String,CustomID:String){
        let userAccountInfo = getCurrentUserInfo()
        let userID = userAccountInfo.value(forKey: "userid")
        let token = userAccountInfo.value(forKey: "token")
        let roletype = userAccountInfo.value(forKey: "roletype") as? String
        
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
        params["userId"] =  userID
        params["orderId"] =  OrderID
        params["customId"] =  CustomID
        params["roletype"] = roletype
        params["token"] = token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
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
                }
                self.isOrderDetailsGets = true
            case false:
                print("get order detail failed")
                self.isOrderDetailsGets = true
            }
        }
    }
}
