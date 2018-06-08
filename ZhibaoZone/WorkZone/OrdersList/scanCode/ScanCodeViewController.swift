//
//  ScanCodeViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/24.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import AVFoundation
class ScanCodeViewController: UIViewController {
    var _scanType:scanCodeActionType = .qrCode
    var ActionViewObject = ActionViewInOrder()
    
    var orderVCObject = OrdersViewController()
    
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
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
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
        layer.frame = UIScreen.main.bounds
        return layer
    }()
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        
       
        if _scanType == .barCode || _scanType == .barCodeForShipping {
            scancodeBackImage.image = UIImage(named: "barcodebackimg")
        }else{
            scancodeBackImage.image = UIImage(named: "scancodebackimg")
        }
        
       
        let scancodeBackImageMask:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 64+kWidth, width: kWidth, height: kHight - 64 - kWidth))
        scancodeBackImageMask.image = UIImage(named: "scancodebackimg-mask")
        
        let scancodeBackImageMaskOnTop:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 64))
        scancodeBackImageMaskOnTop.image = UIImage(named: "scancodebackimg-mask")
        
        let scanBackImg:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: kHight - 90 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 90))
        scanBackImg.image = UIImage(named: "qrbarcodeicon-normal")
        
        if UIDevice.current.isX(){
            let scancodeBackImgBottom:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: kHight - heightChangeForiPhoneXFromBottom, width: kWidth, height: heightChangeForiPhoneXFromBottom))
            scancodeBackImgBottom.image = UIImage(named: "qrbarcodeicon-normal")
            let scancodeBackImgBottom2:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: kHight - heightChangeForiPhoneXFromBottom, width: kWidth, height: heightChangeForiPhoneXFromBottom))
            scancodeBackImgBottom2.image = UIImage(named: "qrbarcodeicon-normal")
            self.view.addSubview(scancodeBackImgBottom)
            self.view.addSubview(scancodeBackImgBottom2)
        }
        self.view.addSubview(scanBackImg)
        self.view.addSubview(scancodeBackImageMask)
        self.view.addSubview(scancodeBackImage)
        self.view.addSubview(scancodeBackImageMaskOnTop)
        
        let QRTypeBtn:UIButton = UIButton.init(type: .custom)
        QRTypeBtn.frame = CGRect(x: 0, y: kHight - 90 - heightChangeForiPhoneXFromBottom, width: kWidth/2, height: 90)
        QRTypeBtn.setImage(UIImage(named: "qrbarcodeicon-highlight"), for: .highlighted)
        QRTypeBtn.setImage(UIImage(named: "qrbarcodeicon-normal"), for: .normal)
        let QRLabel:UILabel  = UILabel.init(frame: CGRect(x: 0, y: 33, width: kWidth/2, height: 25))
        QRLabel.text = "二维码"
        QRLabel.textColor = UIColor.titleColors(color: .white)
        QRLabel.font = UIFont.systemFont(ofSize: 18)
        QRLabel.textAlignment = .center
        QRTypeBtn.addSubview(QRLabel)
        QRTypeBtn.addTarget(self, action: #selector(switchToQRcode), for: .touchUpInside)
        
        let BarTypeBtn:UIButton = UIButton.init(type: .custom)
        BarTypeBtn.frame = CGRect(x: kWidth/2 , y: kHight - 90 - heightChangeForiPhoneXFromBottom, width: kWidth/2 , height: 90)
        BarTypeBtn.setImage(UIImage(named: "qrbarcodeicon-highlight"), for: .highlighted)
        BarTypeBtn.setImage(UIImage(named: "qrbarcodeicon-normal"), for: .normal)
        let BarLabel:UILabel  = UILabel.init(frame: CGRect(x: 0, y: 33, width: kWidth/2, height: 25))
        BarLabel.text = "条形码"
        BarLabel.textColor = UIColor.titleColors(color: .white)
        BarLabel.font = UIFont.systemFont(ofSize: 18)
        BarLabel.textAlignment = .center
        BarTypeBtn.addSubview(BarLabel)
        BarTypeBtn.addTarget(self, action: #selector(switchToBarcode), for: .touchUpInside)
       
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
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //灰层
       // self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        starScan()
        
        // Do any additional setup after loading the view.
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func switchToQRcode(){
        if _scanType != .qrCode{
            _scanType = .qrCode
                scancodeBackImage.image = UIImage(named: "scancodebackimg")
                noticeLabel.text = "将二维码放入框内"
            scanlineImg.isHidden = false
            scanlineImgForBarCode.isHidden = true
           // scanlineImg.frame =  CGRect(x: kWidth/10, y: 104, width: kWidth/10*8, height: 4)
            UIView.animate(withDuration: 3.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
                self.scanlineImg.transform = CGAffineTransform(translationX: 0, y: 295)
            }, completion: nil)
        }
    }
    
    @objc func switchToBarcode(){
        if _scanType != .barCode && _scanType != .barCodeForShipping {
            _scanType = .barCode
            scancodeBackImage.image = UIImage(named: "barcodebackimg")
            noticeLabel.text = "将条形码放入框内"
            scanlineImg.isHidden = true
            scanlineImgForBarCode.isHidden = false
            UIView.animate(withDuration: 2.0, delay: 0.5, options: [.autoreverse,.repeat,.curveLinear], animations: {
                self.scanlineImgForBarCode.transform = CGAffineTransform(translationX: 0, y: 133) // 166
            }, completion: nil)
        }
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
                        let userinfo = getCurrentUserInfo()
                        let searchVC = OrderSearchViewController(searchModel: .orderidOnly, roleType: Int(userinfo.value(forKey: "roletype") as! String) as! Int)
                        searchVC.searchBar.text = (object as AnyObject).stringValue
                        searchVC.tabbarObject = orderVCObject._tabBarVC
                        self.present(searchVC, animated: true) {
                            searchVC.searchBar.resignFirstResponder()
                        }
                        
//
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
}
