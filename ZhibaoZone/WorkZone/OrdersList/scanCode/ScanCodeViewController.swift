//
//  ScanCodeViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/24.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ScanCodeViewController: UIViewController {
    var _scanType:scanCodeActionType = .qrCode
    var ActionViewObject = ActionViewInOrder()
    
    var _token = ""
    var _CustomID = ""
    
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
    
    //弹窗ViewVC
    var popupVC = PopupViewController()
    
    var theAddressToPaste:[String] = []
    
    //扫描订单的弹窗
    lazy var scanPopUpWindows:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 46 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 46 - heightChangeForiPhoneXFromTop))
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 20, y: 23, width: kWidth - 20, height: 24))
        title.text = "扫描订单"
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .center
        tempView.isUserInteractionEnabled = true
        
        tempView.addSubview(title)
        tempView.addSubview(scrollView)
        
        scrollView.addSubview(remainProduceTimeWhiteBoard)
        scrollView.addSubview(shippingAddressAreaWhiteBoard)
        scrollView.addSubview(orderInfosAreaWhiteBoard)
        scrollView.addSubview(produceMemoAreaWhiteBoard)
        
        scrollView.scrollsToTop = true
        tempView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(closePopUpBtn)
        
        //获取System Parameter信息
        systemParam = getSystemParasFromPlist()
        
        //下载图片链接地址
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let resourcesDownloadLinks:NSDictionary = data.value(forKey: "resourcesDownloadLinks") as! NSDictionary
        #if DEBUG
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksDebug") as! String
        downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnailDebug") as! String
        #else
        downloadURLHeader = resourcesDownloadLinks.value(forKey: "imagesDownloadLinks") as! String
        downloadURLHeaderForThumbnail = resourcesDownloadLinks.value(forKey: "imagesDownloadLinksThumbnail") as! String
        #endif
        
        return tempView
    }()
    
    lazy var scrollView:UIScrollView = {
        let tempScrollView:UIScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 70, width: kWidth, height: kHight - 46 - heightChangeForiPhoneXFromTop - heightChangeForiPhoneXFromBottom - 70))
        tempScrollView.contentSize = CGSize(width: kWidth, height: 740)
        tempScrollView.isUserInteractionEnabled = true
        return tempScrollView
    }()
    
    //剩余发货时间面板
    lazy var remainProduceTimeWhiteBoard:UIView = {
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 183))
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        view.addSubview(orderIDLabel)
        view.addSubview(dashSeperatorLine)
        view.addSubview(acceptProduceTimeLabel)
        
        let remainTimeLabel = UILabel.init(frame: CGRect(x: 20, y: 53, width: kWidth - 40, height: 24))
        remainTimeLabel.textColor = UIColor.titleColors(color: .black)
        remainTimeLabel.text = "剩余发货时间"
        remainTimeLabel.font = UIFont.systemFont(ofSize: 17)
        remainTimeLabel.textAlignment = .center
        view.addSubview(remainTimeLabel)
        
        view.addSubview(remainTimeCountdownLabel)
        return view
    }()
    
    //订单号
    lazy var orderIDLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 12, width: kWidth - 30, height: 21))
        tempLabel.text = "订单号 000000000000000"
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    lazy var dashSeperatorLine:UIImageView = {
        let view = UIImageView.init(frame: CGRect(x: 0, y: 140.5, width: kWidth, height: 0.5))
        view.image = UIImage(named: "dashlineimg")
        return view
    }()
    
    lazy var remainTimeCountdownLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 81, width: kWidth - 40, height: 39))
        tempLabel.font = UIFont.systemFont(ofSize: 32)
        tempLabel.textAlignment = .center
        tempLabel.textColor = UIColor.titleColors(color: .lightOrange)
        
        let orignalText = NSMutableAttributedString(string: "--天--时--分")
        //天
        let range1 = orignalText.string.range(of: "天")
        let nsRange1 = orignalText.string.nsRange(from: range1!)
        orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange1)
        //self.remainTimeCountdownLabel.attributedText = orignalText
        //时
        let range2 = orignalText.string.range(of: "时")
        let nsRange2 = orignalText.string.nsRange(from: range2!)
        orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange2)
        //self.remainTimeCountdownLabel.attributedText = orignalText
        //分
        let range3 = orignalText.string.range(of: "分")
        let nsRange3 = orignalText.string.nsRange(from: range3!)
        orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange3)
        tempLabel.attributedText = orignalText
        
        return tempLabel
    }()
    
    //接受生产时间
    lazy var acceptProduceTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: dashSeperatorLine.frame.maxY + 12.5, width: kWidth - 30, height: 21))
        tempLabel.text = "接受生产时间 2018-01-01 01:00:00"
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textAlignment = .left
        tempLabel.textColor = UIColor.titleColors(color: .lightGray)
        return tempLabel
    }()
    
    //收货地址
    lazy var shippingAddressAreaWhiteBoard:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 188, width: kWidth, height: 182))
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let areaLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 14, width: kWidth - 30, height: 21))
        areaLabel.font = UIFont.systemFont(ofSize: 15)
        areaLabel.textColor = UIColor.titleColors(color: .black)
        areaLabel.textAlignment = .left
        areaLabel.text = "收货地址"
        view.addSubview(areaLabel)
        view.isUserInteractionEnabled = true
        
        view.addSubview(oneKeyCopyBtn)
        
        let line1:UIView = UIView.init(frame: CGRect(x: 0, y: 53.5, width: kWidth, height: 0.5))
        line1.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        view.addSubview(line1)
        
        //联系人
        let contactLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: line1.frame.maxY + 12, width: kWidth - 30, height: 18))
        contactLabel.font = UIFont.systemFont(ofSize: 13)
        contactLabel.textColor = UIColor.titleColors(color: .gray)
        contactLabel.textAlignment = .left
        contactLabel.text = "联系人"
        view.addSubview(contactLabel)
        
        //联系方式
        let mobilePhoneLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: contactLabel.frame.maxY + 4, width: kWidth - 30, height: 18))
        mobilePhoneLabel.font = UIFont.systemFont(ofSize: 13)
        mobilePhoneLabel.textColor = UIColor.titleColors(color: .gray)
        mobilePhoneLabel.textAlignment = .left
        mobilePhoneLabel.text = "联系方式"
        view.addSubview(mobilePhoneLabel)
        
        //邮编
        let postCodeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: mobilePhoneLabel.frame.maxY + 4, width: kWidth - 30, height: 18))
        postCodeLabel.font = UIFont.systemFont(ofSize: 13)
        postCodeLabel.textColor = UIColor.titleColors(color: .gray)
        postCodeLabel.textAlignment = .left
        postCodeLabel.text = "邮编"
        view.addSubview(postCodeLabel)
        
        //所在地区
        let mainAreaLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: postCodeLabel.frame.maxY + 4, width: kWidth - 30, height: 18))
        mainAreaLabel.font = UIFont.systemFont(ofSize: 13)
        mainAreaLabel.textColor = UIColor.titleColors(color: .gray)
        mainAreaLabel.textAlignment = .left
        mainAreaLabel.text = "所在地区"
        view.addSubview(mainAreaLabel)
        
        //详细地址
        let detailAreaLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: mainAreaLabel.frame.maxY + 4, width: kWidth - 30, height: 18))
        detailAreaLabel.font = UIFont.systemFont(ofSize: 13)
        detailAreaLabel.textColor = UIColor.titleColors(color: .gray)
        detailAreaLabel.textAlignment = .left
        detailAreaLabel.text = "详细地址"
        view.addSubview(detailAreaLabel)
        
        contactLabelValue.frame = contactLabel.frame
        view.addSubview(contactLabelValue)
        
        mobilePhoneLabelValue.frame = mobilePhoneLabel.frame
        view.addSubview(mobilePhoneLabelValue)
        
        postCodeLabelValue.frame = postCodeLabel.frame
        view.addSubview(postCodeLabelValue)
        
        mainAreaLabelValue.frame = mainAreaLabel.frame
        view.addSubview(mainAreaLabelValue)
        
        detailAreaLabelValue.frame = detailAreaLabel.frame
        view.addSubview(detailAreaLabelValue)
        
        return view
    }()
    
    
    //收件人值
    lazy var contactLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "王雅雅"
        return tempLabel
    }()
    
    //联系方式
    lazy var mobilePhoneLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "+86 - 13800138000"
        return tempLabel
    }()
    
    //邮编
    lazy var postCodeLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "000000"
        return tempLabel
    }()
    
    //所在地区
    lazy var mainAreaLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "湖北省 武汉市 青山区"
        return tempLabel
    }()
    
    //所在地区
    lazy var detailAreaLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "红卫路街道五高中和广场市场8楼2301号"
        return tempLabel
    }()
    
    //订购信息面板
    lazy var orderInfosAreaWhiteBoard:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 374, width: kWidth, height: 183))
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let line1:UIView = UIView.init(frame: CGRect(x: 0, y: 120.5, width: kWidth, height: 0.5))
        line1.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        view.addSubview(line1)
        
        //数量
        let productAmountLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: line1.frame.maxY + 12, width: kWidth - 30, height: 18))
        productAmountLabel.font = UIFont.systemFont(ofSize: 13)
        productAmountLabel.textColor = UIColor.titleColors(color: .gray)
        productAmountLabel.textAlignment = .left
        productAmountLabel.text = "数量(个)"
        view.addSubview(productAmountLabel)
        
        //尺寸(mm)
        let productSizeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: productAmountLabel.frame.maxY + 4, width: kWidth - 30, height: 18))
        productSizeLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeLabel.textColor = UIColor.titleColors(color: .gray)
        productSizeLabel.textAlignment = .left
        productSizeLabel.text = "尺寸(mm)"
        view.addSubview(productSizeLabel)
        
        productAmountLabelValue.frame = productAmountLabel.frame
        view.addSubview(productAmountLabelValue)
        
        productSizeLabelValue.frame = productSizeLabel.frame
        view.addSubview(productSizeLabelValue)
        
        view.addSubview(produceImageView)
        
        goodsClassValue.frame = CGRect(x: kWidth - 265, y: 16, width: 250, height: 21)
        view.addSubview(goodsClassValue)
        
        materailAndAccessoryValue.frame = CGRect(x: kWidth - 265, y: goodsClassValue.frame.maxY + 4, width: 250, height: 21)
        view.addSubview(materailAndAccessoryValue)
        
        technologyValue.frame = CGRect(x: kWidth - 265, y: materailAndAccessoryValue.frame.maxY + 4, width: 250, height: 36)
        view.addSubview(technologyValue)
        return view
    }()
    
    //产品主图
    lazy var produceImageView:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 16, width: 88, height: 88))
        tempImageView.image = UIImage(named: "defualt-design-pic")
        tempImageView.layer.cornerRadius = 4
        tempImageView.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
        tempImageView.layer.masksToBounds  = true
        tempImageView.contentMode = .scaleAspectFit
        return tempImageView
    }()
    
    //产品类型
    lazy var goodsClassValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.boldSystemFont(ofSize: 15)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "徽章"
        return tempLabel
    }()
    
    //材质 配件
    lazy var materailAndAccessoryValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "锌合金 别针"
        return tempLabel
    }()
    
    //工艺
    lazy var technologyValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.numberOfLines = 3
        tempLabel.text = "双面开模;2D冲压;电镀;烤漆;银色(镍)双面开模;2D冲压;电镀;烤漆;银色(镍)"
        return tempLabel
    }()
    
    //数量
    lazy var productAmountLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "100000"
        return tempLabel
    }()
    
    //尺寸
    lazy var productSizeLabelValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .right
        tempLabel.text = "200.1 x 300.1 x 200"
        return tempLabel
    }()
    
    lazy var produceMemoAreaWhiteBoard:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 562, width: kWidth, height: 183))
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 15, y: 16, width: kWidth - 30, height: 21))
        title.text = "生产备注"
        title.textAlignment = .left
        title.textColor = UIColor.titleColors(color: .black)
        title.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(title)
        
        produceMemoValue.frame = CGRect(x: 15, y: title.frame.maxY + 4, width: kWidth - 30, height: 36)
        view.addSubview(produceMemoValue)
        
        return view
    }()
    
    lazy var produceMemoValue:UILabel = {
        let tempLabel = UILabel.init()
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.numberOfLines = 5
        tempLabel.text = "生产的时候稍微细致一些，有些地方打磨平整一点，要求量不要太粗糙，还有就是凹凸感稍微重一点,高端一点…"
        return tempLabel
    }()
    
    lazy var closePopUpBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: kWidth - 85, y: 25, width: 80, height: 21))
        button.setTitle("取消", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        button.addTarget(self, action: #selector(closePopupBtnClicked), for: .touchUpInside)
        return button
    }()
    var orderVCObject = OrdersViewController()
    let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
    
    let QRLabel:UILabel  = UILabel.init(frame: CGRect(x: 0, y: 33, width: kWidth/2, height: 25))
    lazy var QRTypeBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.frame = CGRect(x: 0, y: kHight - 90 - heightChangeForiPhoneXFromBottom, width: kWidth/2, height: 90 + heightChangeForiPhoneXFromBottom)
        //        QRTypeBtn.setImage(UIImage(named: "qrbarcodeicon-highlight"), for: .highlighted)
        //        QRTypeBtn.setImage(UIImage(named: "qrbarcodeicon-normal"), for: .normal)
        
        QRLabel.text = "二维码"
        QRLabel.textColor = UIColor.titleColors(color: .red)
        QRLabel.font = UIFont.systemFont(ofSize: 18)
        QRLabel.textAlignment = .center
        tempButton.addSubview(QRLabel)
        tempButton.addTarget(self, action: #selector(switchToQRcode), for: .touchUpInside)
        
        return tempButton
    }()
    
    let BarLabel:UILabel  = UILabel.init(frame: CGRect(x: 0, y: 33, width: kWidth/2, height: 25))
    lazy var BarTypeBtn:UIButton = {
        let tempButton = UIButton.init(type: .custom)
        tempButton.setTitleColor(UIColor.titleColors(color: .red), for: .highlighted)
        tempButton.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        
        tempButton.frame = CGRect(x: kWidth/2 , y: kHight - 90 - heightChangeForiPhoneXFromBottom , width: kWidth/2 , height: 90 + heightChangeForiPhoneXFromBottom)
        //        BarTypeBtn.setImage(UIImage(named: "qrbarcodeicon-highlight"), for: .highlighted)
        //        BarTypeBtn.setImage(UIImage(named: "qrbarcodeicon-normal"), for: .normal)
        
        BarLabel.text = "条形码"
        BarLabel.textColor = UIColor.titleColors(color: .white)
        BarLabel.font = UIFont.systemFont(ofSize: 18)
        BarLabel.textAlignment = .center
        tempButton.addSubview(BarLabel)
        tempButton.addTarget(self, action: #selector(switchToBarcode), for: .touchUpInside)
        
        return tempButton
    }()
    
    lazy var oneKeyCopyBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 85, y: 17, width: 100, height: 16))
        let image:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 17, height: 16))
        image.image = UIImage(named: "copyiconimg")
        button.addSubview(image)
        button.addTarget(self, action: #selector(copyAddressBtnClicked), for: .touchUpInside)
        return button
    }()
    let scancodeBackImage:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 64, width: kWidth, height: kWidth))
    let noticeLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: 9, width: 225, height: 20))
    let scanlineImg:UIImageView = UIImageView.init(frame: CGRect(x: kWidth/10, y: 104, width: kWidth/10*8, height: 4))
    let scanlineImgForBarCode:UIImageView = UIImageView.init(frame: CGRect(x: kWidth/10, y: 266, width: kWidth/10*8, height: 4))
    // MARK: - 1. 懒加载: 会话,输入设备,输出设备,预览图层
    //会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    //拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        
        //获取摄像头
        let device = AVCaptureDevice.default(for: .video)
        
        do {
            //创建输入对象
            let input = try AVCaptureDeviceInput(device: device!)
            return input
        } catch {
            //打印错误信息
            print(error)
            return nil
        }
    }()
    
    init(scanType:scanCodeActionType) {
        _scanType = scanType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //拿到输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHight) //UIScreen.main.bounds
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return layer
    }()
    
    //倒计时
    var timer:Timer!
    var countdownTime:Int = 0
    
    var currentTimeString:String {
        get {
            if countdownTime <= 0 {
                
                return String(format:"%02d天%02d时%02d分",Int(countdownTime)/86400,Int(countdownTime%86400)/3600
                    ,Int(countdownTime)/60%60)
                
            } else {
                
                
                return String(format:"%02d天%02d时%02d分",Int(countdownTime)/86400,Int(countdownTime%86400)/3600
                    ,Int(countdownTime)/60%60)
            }
        }
    }
    
    @objc func copyAddressBtnClicked(){
        UIPasteboard.general.strings = theAddressToPaste
        greyLayerPrompt.show(text: "收货地址复制成功")
    }
    
    @objc func timeEventsOfCountDown(){
        DispatchQueue.main.async {
            self.countdownTime = self.countdownTime - 60
            
            let orignalText = NSMutableAttributedString(string: self.currentTimeString)
            //天
            let range1 = orignalText.string.range(of: "天")
            let nsRange1 = orignalText.string.nsRange(from: range1!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange1)
            //self.remainTimeCountdownLabel.attributedText = orignalText
            //时
            let range2 = orignalText.string.range(of: "时")
            let nsRange2 = orignalText.string.nsRange(from: range2!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange2)
            //self.remainTimeCountdownLabel.attributedText = orignalText
            //分
            let range3 = orignalText.string.range(of: "分")
            let nsRange3 = orignalText.string.nsRange(from: range3!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], range: nsRange3)
            self.remainTimeCountdownLabel.attributedText = orignalText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: false, ViewController: self)
        
        self.view.backgroundColor = UIColor.clear

       
        let scancodeBackImageMask:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 64+kWidth, width: kWidth, height: kHight - 64 - kWidth))
        scancodeBackImageMask.image = UIImage(named: "scancodebackimg-mask")
        
        let scancodeBackImageMaskOnTop:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 64))
        scancodeBackImageMaskOnTop.image = UIImage(named: "scancodebackimg-mask")
        
        let scanBackImg:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: kHight - 90 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 90 + heightChangeForiPhoneXFromBottom))
        scanBackImg.image = UIImage(named: "qrbarcodeicon-normal")
        

        self.view.addSubview(scanBackImg)
        self.view.addSubview(scancodeBackImageMask)
        self.view.addSubview(scancodeBackImage)
        self.view.addSubview(scancodeBackImageMaskOnTop)
        
       
        self.view.addSubview(QRTypeBtn)
        self.view.addSubview(BarTypeBtn)
        
        let sepereateLineView:UIImageView = UIImageView.init(frame: CGRect(x: kWidth/2, y: QRTypeBtn.frame.minY, width: 1, height: 90))
        sepereateLineView.image = UIImage()
        
        self.view.addSubview(sepereateLineView)
        let seperateLine:UIImageView = UIImageView.init(frame: CGRect(x: kWidth/2, y: QRTypeBtn.frame.minY + 25, width: 1, height: 40))
        seperateLine.image = UIImage(named: "seperatelineinscancode")
        self.view.addSubview(seperateLine)

        // 提示信息
        let scancodeNoticeImg:UIImageView = UIImageView.init(frame: CGRect(x: (kWidth-225)/2, y: QRTypeBtn.frame.minY - 60, width: 225, height: 38))
        scancodeNoticeImg.image = UIImage(named: "scancodenoticebgimg")
        scancodeNoticeImg.layer.cornerRadius = 19
        scancodeNoticeImg.layer.masksToBounds = true
        
        //扫描动画
        scanlineImg.image = UIImage(named: "scancodelineimg")
        self.view.addSubview(scanlineImg)
        
        scanlineImgForBarCode.image = UIImage(named: "scancodelineimg")
        self.view.addSubview(scanlineImgForBarCode)
        //提示文字
        if _scanType == .barCode || _scanType == .barCodeForShipping {
            noticeLabel.text = "将条形码放入框内"
            scanlineImg.isHidden = true
            scanlineImgForBarCode.isHidden = false
        }else{
            noticeLabel.text = "将二维码放入框内"
            scanlineImg.isHidden = false
            scanlineImgForBarCode.isHidden = true
        }
        
        noticeLabel.textColor = UIColor.titleColors(color: .white)
        noticeLabel.textAlignment = .center
        noticeLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.view.addSubview(scancodeNoticeImg)
        scancodeNoticeImg.addSubview(noticeLabel)
        
        //扫描动画
        scanlineImg.image = UIImage(named: "scancodelineimg")
        self.view.addSubview(scanlineImg)
        
        UIView.animate(withDuration: 3.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
            self.scanlineImg.transform = CGAffineTransform(translationX: 0, y: 295)
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
            self.scanlineImgForBarCode.transform = CGAffineTransform(translationX: 0, y: 133)
        }, completion: nil)
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.clear//UIColor.backgroundColors(color: .clear)
        navBar.setBackgroundImage(UIImage(), for: .default) //.compact
        navBar.shadowImage = UIImage()
        //navBar.subviews.first?.alpha = 0 //将背景设置为透明
        //navBar
        navBar.barTintColor = UIColor.backgroundColors(color: .white)
        navBar.isTranslucent = true //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        
        titleLabel.text = "扫描二维码"
        titleLabel.textColor = UIColor.titleColors(color: .white)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-white")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .white)
        
        
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        //navItem.setRightBarButton(rightBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        
        if _scanType == .barCode || _scanType == .barCodeForShipping {
            switchToBarcode()
        }else{
            switchToQRcode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //灰层
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        starScan()
        
        // Do any additional setup after loading the view.
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func switchToQRcode(){
//        if _scanType != .qrCode{
            _scanType = .qrCode
                scancodeBackImage.image = UIImage(named: "scancodebackimg")
                noticeLabel.text = "将二维码放入框内"
            scanlineImg.isHidden = false
            titleLabel.text = "扫描二维码"
            QRLabel.textColor = UIColor.titleColors(color: .red)
            BarLabel.textColor = UIColor.titleColors(color: .white)
            scanlineImgForBarCode.isHidden = true
           // scanlineImg.frame =  CGRect(x: kWidth/10, y: 104, width: kWidth/10*8, height: 4)
            UIView.animate(withDuration: 3.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
                self.scanlineImg.transform = CGAffineTransform(translationX: 0, y: 295)
            }, completion: nil)
    }
    
    @objc func switchToBarcode(){
        
            _scanType = .barCode
            scancodeBackImage.image = UIImage(named: "barcodebackimg")
            noticeLabel.text = "将条形码放入框内"
            titleLabel.text = "扫描条形码"
            scanlineImg.isHidden = true
            QRLabel.textColor = UIColor.titleColors(color: .white)
            BarLabel.textColor = UIColor.titleColors(color: .red)
            scanlineImgForBarCode.isHidden = false
            UIView.animate(withDuration: 2.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
                self.scanlineImgForBarCode.transform = CGAffineTransform(translationX: 0, y: 133) // 166
            }, completion: nil)
    }
    
    //MARK: - 2. 扫描二维码
    func starScan() {
        
        //先判断是否能将设备添加到回话中
        if !session.canAddInput(deviceInput!) {
            return
        }
        
        //判断是否能够将输出添加到回话中
        if !session .canAddOutput(output) {
            return
        }
        
        //将输入和输出添加到回话中
        session.addInput(deviceInput!)
        session.addOutput(output)
        
        //设置输入能够解析的数据类型
        
        //设置能解析的数据类型,一定要在输出对象添加到会员之后设置
        output.metadataObjectTypes = [.aztec,.ean13,.ean8,.code128,.qr]//output.availableMetadataObjectTypes
        
        //设置输出对象的代理,只要解析成功,就会通知代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // dispatch_get_main_queue()
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //告诉session开始扫描
        session.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - 3. 实现代理 AVCaptureMetadataOutputObjectsDelegate
extension ScanCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    //只要解析到数据就会调用
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if metadataObjects.count > 0 {
            session.stopRunning()
            let object = metadataObjects[0]
            let string: String = (object as AnyObject).stringValue
            if let url = URL(string: string) {
                if UIApplication.shared.canOpenURL(url) {
                    //去打开地址链接
                    _ = self.navigationController?.popViewController(animated: true)
                    UIApplication.shared.open(url)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    if _scanType == .barCodeForShipping{
                        ActionViewObject.shippingCodeValue.text = (object as AnyObject).stringValue
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        //获取非链接结果
                        _CustomID = string + "1"
                        self.getOrderDetails(CustomID: _CustomID)

//
                      //  self.dismiss(animated: true, completion: nil)
//                        self.dismiss(animated: true) {
//                            self.orderListVC.searchBarTaped()
//                        }
//                        let alertViewController = UIAlertController(title: "扫描结果", message: (object as AnyObject).stringValue, preferredStyle: .alert)
//                        let actionCancel = UIAlertAction(title: "退出", style: .cancel, handler: { (action) in
//                            self.dismiss(animated: true, completion: nil)
//                           // _ = self.navigationController?.popViewController(animated: true)
//                        })
//                        let actinSure = UIAlertAction(title: "再次扫描", style: .default, handler: { (action) in
//                            self.session.startRunning()
//                        })
//                        alertViewController.addAction(actionCancel)
//                        alertViewController.addAction(actinSure)
//                        self.present(alertViewController, animated: true, completion: nil)
//                        //self.dismiss(animated: true, completion: nil)
                        }
                }
            }
        }
        
        
        // print(metadataObjects.last?.stringValue)
        //获取扫描结果
        //注意是: stringValue
       
    }
    
    @objc func closePopupBtnClicked(){
        self.scanPopUpWindows.removeFromSuperview()
        session.startRunning()
    }
    
    func downloadOrderImages(){
        DispatchQueue.global().async {
            //订单详情信息
            let dictionaryObjectInOrderArray = self.orderDetail
            let orderaddinfos = dictionaryObjectInOrderArray[0]
            
            var noReferenceImageAvailable = false
            //附件图片数目
            var attachImageCount:Int = 0
            //下载缩略图
            if orderaddinfos.value(forKey: "smallGoodsImage") as? String != nil && orderaddinfos.value(forKey: "smallGoodsImage") as? String != "" {
                let imageURLString = "\(self.downloadURLHeaderForThumbnail)\(orderaddinfos.value(forKey: "smallGoodsImage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let oImage = UIImage.gif(data:data)
                    let image = UIImage(data: compressionImage(with: oImage!) as Data)
                    DispatchQueue.main.async {
                        self.produceImageView.image = image
                    }
                    
                }catch{
                    print(error)
                    //缩略图下载失败，下载原图
                    let imageURLString = "\(self.downloadURLHeader)\(orderaddinfos.value(forKey: "initialGoodsImage") as! String)"
                    let url = URL(string: imageURLString)!
                    do{
                        let data = try Data.init(contentsOf: url)
                        let oImage = UIImage.gif(data:data)
                        let image = UIImage(data: compressionImage(with: oImage!) as Data)
                        DispatchQueue.main.async {
                            self.produceImageView.image = image
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            self.produceImageView.image = UIImage(named:"defualt-design-pic")//  UIImage(image:image)
                        }
                        //原图也下载失败
                    }
                    print("无缩略图")
                }
            }else{
                noReferenceImageAvailable = true
                //所有图片都没有，显示默认图
                DispatchQueue.main.async {
                    self.produceImageView.image = UIImage(named:"defualt-design-pic")
                }
            }
        }
    }
    func loadDataToTheWindows(){
        //下载图片
        downloadOrderImages()
        
        let orderInfoObjects = orderDetail[0] as! NSDictionary
        
        //获取系统参数数据
        let productObjects = systemParam[0] as! NSDictionary

        //订单号
        orderIDLabel.text = "订单号 \(orderInfoObjects.value(forKey: "orderid") as! String)"
        //订单时间
        acceptProduceTimeLabel.text = "接受生产时间 \(orderInfoObjects.value(forKey: "produceTime") as! String)"
        
        //产品类型
        let goodsClassObject = productObjects.value(forKey: "goodsClass") as! NSArray
        let productType = findValue(key: "id", keyValue: orderInfoObjects.value(forKey: "goodsClass") as! String, In: goodsClassObject, By: "goodsClass")
        // (goodsClassObject[Int(orderInfoObjects.value(forKey: "goodsClass") as! String)! - 1] as! NSDictionary).value(forKey: "goodsClass") as! String
        goodsClassValue.text = productType//orderInfoObjects.value(forKey: "goodsclass") as? String
        
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
        materailAndAccessoryValue.text = materialType + " " + accessoriesType
        //订购数目
        if orderInfoObjects.value(forKey: "number") as? Int != nil{
            productAmountLabelValue.text = "\(orderInfoObjects.value(forKey: "number") as! Int)" //"1000"
        }else{
            productAmountLabelValue.text = "0"
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
        if tempMakeStyleValue != ""{
            tempMakeStyleValue.remove(at: tempMakeStyleValue.startIndex) //删除掉开头的“，”
            tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";,", with: ";") //将“;,替换为;
        }
        technologyValue.text = tempMakeStyleValue
        let heightOfLabel = calculateLabelHeightWithText(with: tempMakeStyleValue, labelWidth: technologyValue.frame.width, textFont: technologyValue.font)
        technologyValue.frame = CGRect(x: kWidth - 265, y: materailAndAccessoryValue.frame.maxY + 4, width: 250, height: heightOfLabel + 10)
        
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
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! Double)"
            }else{
                produceSizeValue = produceSizeValue + "x\(orderInfoObjects.value(forKey: "height")as! NSNumber)"
            }
        }else{
            produceSizeValue = produceSizeValue + "x "
        }
        productSizeLabelValue.text = produceSizeValue

        if orderInfoObjects.value(forKey: "produceMemo") as? String != nil && orderInfoObjects.value(forKey: "produceMemo") as! String != ""{
            let ProduceMemo = orderInfoObjects.value(forKey: "produceMemo") as! String
            produceMemoValue.text = ProduceMemo
            let heightOfProduceMemoLabel = calculateLabelHeightWithText(with: ProduceMemo, labelWidth: produceMemoValue.frame.width, textFont: UIFont.systemFont(ofSize: 14))
            
            let tempFrame = produceMemoValue.frame
            produceMemoValue.frame = CGRect(x: 15, y: tempFrame.minY, width: kWidth - 30, height: heightOfProduceMemoLabel + 10)
        }else{
            produceMemoValue.text = "无备注信息"
            produceMemoValue.textColor = UIColor.titleColors(color: .lightGray)
        }
        
        //收货地址填充
        let reciver = orderInfoObjects.value(forKey: "name") as! String
        let mobilePhone = orderInfoObjects.value(forKey: "mobilephone") as! String
        let country = orderInfoObjects.value(forKey: "country") as! String
        let province = orderInfoObjects.value(forKey: "province") as! String
        let city = orderInfoObjects.value(forKey: "city") as! String
        let district = orderInfoObjects.value(forKey: "county") as! String
        let detailAddress = orderInfoObjects.value(forKey: "detailAddress") as! String
        
        contactLabelValue.text = reciver
        mobilePhoneLabelValue.text = mobilePhone
        mainAreaLabelValue.text = province + " " + city + " " + district
        detailAreaLabelValue.text = detailAddress
        
        theAddressToPaste = ["收货人：\(reciver)\n",
                                        "手机号码：\(mobilePhone)\n",
                                        "所在地区：\(province + city + district)\n",
                                        "详细地址： \(detailAddress)"
        ]
        //剩余发货时间
        // 获取当前系统时间
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        let now = timeFormatter.date(from: strNowTime)
        //将创建任务时间转换为Date格式
        
        if orderInfoObjects.value(forKey: "workshopProduceDeadlineTime") as? String != nil && orderInfoObjects.value(forKey: "workshopProduceDeadlineTime") as? String != ""{
            let deadline = orderInfoObjects.value(forKey: "workshopProduceDeadlineTime") as! String
            let dateResult = timeFormatter.date(from: deadline)
            
            let gregorian = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
            let result = gregorian?.components(.second, from:now! , to: dateResult!, options: NSCalendar.Options.init(rawValue: 0)).second as! Int
            
            countdownTime = result//Int((taskInfoDic.value(forKey: "taskperiod") as! String))!*60 - result
            
            //倒计时开始计时
            self.timeEventsOfCountDown() // 设置timer前先执行一次
            self.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.timeEventsOfCountDown), userInfo: nil, repeats: true)
        }else{
            self.remainTimeCountdownLabel.text = "--"
        }
        
    }
    
    func getOrderDetails(CustomID:String){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetailsDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "orderDetails") as! String
        #endif
        
        let userinfo = getCurrentUserInfo()
        _token = userinfo.value(forKey: "token") as! String
        
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        params["customId"] =  CustomID
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
                            //获取成功数据了，刷新UI
                            let orderInfoObjects = self.orderDetail[0] as! NSDictionary
                            let produceStatus:Int = orderInfoObjects.value(forKey: "produceStatus") as! Int

                            DispatchQueue.main.async {
                                //显示页面
                                
                                if produceStatus == 3 && (userinfo.value(forKey: "roletype") as! String) == "3"{
                                    // 如果订单处于生产中，则显示生产单详情弹窗
                                    self.view.addSubview(self.scanPopUpWindows)
                                    self.loadDataToTheWindows()
                                    
                                    print("处于生产中")
                                }else{
                                    //如果不是，就执行搜索
                                    //如果订单不在生产中,进入订单搜索功能
                                    let searchVC = OrderSearchViewController(searchModel: .orderidOnly, roleType: Int(userinfo.value(forKey: "roletype") as! String) as! Int)
                                    searchVC.searchBar.text = "\(self._CustomID.removeLast())"
                                    searchVC.tabbarObject = self.orderVCObject._tabBarVC
                                    self.present(searchVC, animated: true) {
                                        searchVC.searchBar.resignFirstResponder()
                                    }
                                }
                            }
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self.popupVC)
                            //greyLayerPrompt.show(text: "登录已失效,请重新登录")
                            //LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("获取失败，code:\(statusCode)")
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
}
