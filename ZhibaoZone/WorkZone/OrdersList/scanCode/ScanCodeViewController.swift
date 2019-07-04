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
    
    //扫描订单的弹窗
    lazy var scanPopUpWindows:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 46 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 46 - heightChangeForiPhoneXFromTop))
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 20, y: 23, width: kWidth - 20, height: 24))
        title.text = "扫描订单"
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .center
        
        tempView.addSubview(title)
        tempView.addSubview(remainProduceTimeWhiteBoard)
        
        
        tempView.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        tempView.addSubview(closePopUpBtn)
        
        return tempView
    }()
    
    //剩余发货时间面板
    lazy var remainProduceTimeWhiteBoard:UIView = {
        let view:UIView = UIView.init(frame: CGRect(x: 0, y: 70, width: kWidth, height: 183))
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
        
        //任务截止时间
        // 获取当前系统时间
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strNowTime = timeFormatter.string(from: date) as String
        
        let now = timeFormatter.date(from: strNowTime)
        //将创建任务时间转换为Date格式
        let dateResult = timeFormatter.date(from: "2019-07-05 12:00:00")
        
        let gregorian = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        let result = gregorian?.components(.second, from:now! , to: dateResult!, options: NSCalendar.Options.init(rawValue: 0)).second as! Int
        
        countdownTime = result//Int((taskInfoDic.value(forKey: "taskperiod") as! String))!*60 - result
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
        tempLabel.text = "接受生产时间 2019-01-01 01:00:00"
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textAlignment = .left
        tempLabel.textColor = UIColor.titleColors(color: .lightGray)
        return tempLabel
    }()
    
    //售后地址
    lazy var shippingAddressArea:UIView = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 12, width: 100, height: 21))
        tempLabel.text = "接受生产时间 2019-01-01 01:00:00"
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textAlignment = .left
        tempLabel.textColor = UIColor.titleColors(color: .lightGray)
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
                                    
                                    //倒计时开始计时
                                    self.timeEventsOfCountDown() // 设置timer前先执行一次
                                    self.timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(self.timeEventsOfCountDown), userInfo: nil, repeats: true)
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
