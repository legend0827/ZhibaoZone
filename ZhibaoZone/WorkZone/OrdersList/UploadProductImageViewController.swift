//
//  UploadProductImageViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/10.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Photos
import AudioToolbox
import CloudKit
import QCloudCore
import QCloudCOSXML
import Alamofire

class UploadProductImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var _orderID:String = "10000000"
    var _goodsImage:UIImage = UIImage()
    var _productType:String = "徽章"
    var _materialAndAccessory:String = "锌合金 别针"
    var _modalAndColor:String = "2D"
    var _customID:String = "1000000"
    
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    var orderObject:NSDictionary = [:]
    //参考图
    let goodImage:UIImageView = UIImageView.init()
    let orderIDLabel:UILabel = UILabel.init()
    let productType:UILabel = UILabel.init()
    let materialAndAccessories:UILabel = UILabel.init()
    let modalAndColorL:UILabel = UILabel.init()
    
    let seperateLine1:UIImageView = UIImageView.init()
    let noiticeOnUpload:UILabel = UILabel.init()
    let AddPicBtn:UIButton = UIButton.init(type: .custom)
    var AddPicTag = 0
    
    //从本地上传到IOS客户端的路径
    var tempimageURLs:[Int:String] = [:]
    var imageURLs:[String] = []
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    //预览路径
    var temppreviewURLs:[Int:URL] = [:]
    var previewURLs:[URL] = []
    //上传图片到COS临时存储到名字
    var taskImages:[NSDictionary] = []
    var tempAttachmentPics:[Int:UIImage] = [:]
    var AttachmentPics:[UIImage] = []
    var tempAttachmentTypes:[Int:String] = [:]
    var AttachmentTypes:[String] = []
    var OriginalPicCount = 0
    var SelectedPicCount = 0
    var mapperOfImage:[Int] = []
    //上传的图片：
    let selectedImage1:UIImageView = UIImageView.init()
    let selectedImage2:UIImageView = UIImageView.init()
    let selectedImage3:UIImageView = UIImageView.init()
    let deleteBtnOnImage1:UIButton = UIButton.init(type: .custom)
    let deleteBtnOnImage2:UIButton = UIButton.init(type: .custom)
    let deleteBtnOnImage3:UIButton = UIButton.init(type: .custom)
    
    //从iCloud下载的图片
    let icloudDownloadImage1:UIImageView = UIImageView.init()
    let icloudDownloadImage2:UIImageView = UIImageView.init()
    let icloudDownloadImage3:UIImageView = UIImageView.init()
    let icloudDownloadPercentage1:UILabel = UILabel.init()
    let icloudDownloadPercentage2:UILabel = UILabel.init()
    let icloudDownloadPercentage3:UILabel = UILabel.init()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        super.viewDidLoad()
        
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .red)
        navBar.barTintColor = UIColor.backgroundColors(color: .red)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "上传成品图"
        titleLabel.textColor = UIColor.titleColors(color: .white)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-white")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .white)
        
        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "上传", style: .plain,
                                           target: self, action: #selector(uploadBtnClicked))
        rightBarItem.tintColor = UIColor.backgroundColors(color: .white)
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        navItem.setRightBarButton(rightBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        // Do any additional setup after loading the view.
        
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
        systemParam = getSystemParasFromPlist()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .clear))
        setStatusBarHiden(toHidden: true, ViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupUI(){
        goodImage.frame = CGRect(x: 20, y: 100 + heightChangeForiPhoneXFromTop, width: 118, height: 118)
        orderIDLabel.frame = CGRect(x: goodImage.frame.maxX + 24, y: goodImage.frame.minY, width: 300, height: 22)
        productType.frame = CGRect(x: orderIDLabel.frame.minX, y: orderIDLabel.frame.maxY, width: 300, height: 22)
        materialAndAccessories.frame = CGRect(x: orderIDLabel.frame.minX, y: productType.frame.maxY, width: 300, height: 22)
        modalAndColorL.frame = CGRect(x: orderIDLabel.frame.minX, y: materialAndAccessories.frame.maxY, width: kWidth - 178, height: 22)
        
        goodImage.image = UIImage(named: "defualt-design-pic")
        goodImage.layer.masksToBounds = true
        goodImage.layer.cornerRadius = 6
        goodImage.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        goodImage.layer.borderWidth = 1
        
        orderIDLabel.text = "订单号: 10000000"
        orderIDLabel.textColor = UIColor.titleColors(color: .black)
        orderIDLabel.textAlignment = .left
        orderIDLabel.font = UIFont.systemFont(ofSize: 16)
        
        productType.text = "徽章"
        productType.textColor = UIColor.titleColors(color: .black)
        productType.textAlignment = .left
        productType.font = UIFont.boldSystemFont(ofSize: 16)
        
        materialAndAccessories.text = "锌合金  别针"
        materialAndAccessories.textColor = UIColor.titleColors(color: .black)
        materialAndAccessories.textAlignment = .left
        materialAndAccessories.font = UIFont.systemFont(ofSize: 16)
        
        modalAndColorL.text = "2D;烤漆;"
        modalAndColorL.textColor = UIColor.titleColors(color: .black)
        modalAndColorL.textAlignment = .left
        modalAndColorL.font = UIFont.systemFont(ofSize: 16)
        modalAndColorL.numberOfLines = 5
        
        seperateLine1.frame = CGRect(x: 20, y: goodImage.frame.maxY + 40, width: kWidth - 40, height: 1)
        seperateLine1.image = UIImage(named: "dashlineimg")
        
        noiticeOnUpload.frame = CGRect(x: 20, y: seperateLine1.frame.maxY + 40, width: kWidth - 40, height: 20)
        noiticeOnUpload.text = "最多可上传三张图片"
        noiticeOnUpload.font = UIFont.systemFont(ofSize: 14)
        noiticeOnUpload.textAlignment = .center
        noiticeOnUpload.textColor = UIColor.titleColors(color: .black)
        
        AddPicBtn.frame = CGRect(x: 20, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        AddPicBtn.setImage(UIImage(named: "addPicImg"), for: .normal)
        AddPicBtn.layer.cornerRadius = 6
        AddPicBtn.layer.masksToBounds = true
        AddPicBtn.addTarget(self, action: #selector(addPicBtnClicked), for: .touchUpInside)
        AddPicBtn.tag = AddPicTag
        
        selectedImage1.frame = CGRect(x: 20, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        selectedImage2.frame = CGRect(x: 20 + 118, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        selectedImage3.frame = CGRect(x: 20 + 118 * 2, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        
        icloudDownloadImage1.frame = CGRect(x: 20, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        icloudDownloadPercentage1.frame = CGRect(x: 0, y: 34, width: icloudDownloadImage1.frame.width, height: 13)
        
        icloudDownloadImage2.frame = CGRect(x: 20 + 118, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        icloudDownloadPercentage2.frame = CGRect(x: 0, y: 34, width: icloudDownloadImage1.frame.width, height: 13)
        
        icloudDownloadImage3.frame = CGRect(x: 20 + 118 * 2, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
        icloudDownloadPercentage3.frame = CGRect(x: 0, y: 34, width: icloudDownloadImage1.frame.width, height: 13)
        
        selectedImage1.isUserInteractionEnabled = true
        selectedImage2.isUserInteractionEnabled = true
        selectedImage3.isUserInteractionEnabled = true
        
        let singleTap1 = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        singleTap1.numberOfTapsRequired = 1
        singleTap1.numberOfTouchesRequired = 1
        
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        singleTap2.numberOfTapsRequired = 1
        singleTap2.numberOfTouchesRequired = 1
        
        let singleTap3 = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))
        singleTap3.numberOfTapsRequired = 1
        singleTap3.numberOfTouchesRequired = 1
        
        selectedImage1.addGestureRecognizer(singleTap1)
        selectedImage2.addGestureRecognizer(singleTap2)
        selectedImage3.addGestureRecognizer(singleTap3)
        
        //第一张图
        selectedImage1.tag = 0
        selectedImage1.layer.cornerRadius = 6
        selectedImage1.layer.masksToBounds = true
        selectedImage1.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        selectedImage1.layer.borderWidth = 1
        selectedImage1.contentMode = .scaleAspectFit
        
        deleteBtnOnImage1.setImage(UIImage(named: "deleteiconimg"), for: .normal)
        deleteBtnOnImage1.tag = 0
        deleteBtnOnImage1.frame = CGRect(x: selectedImage1.frame.maxX - 12, y: selectedImage1.frame.minY - 12, width: 24, height: 24)
        deleteBtnOnImage1.addTarget(self, action: #selector(deleteImageCliced), for: .touchUpInside)
        icloudDownloadPercentage1.text = "0%"
        icloudDownloadImage1.image = UIImage(named: "iclouddownloadingimg")
        icloudDownloadImage1.layer.cornerRadius = 6
        icloudDownloadImage1.layer.masksToBounds = true
        icloudDownloadPercentage1.font = UIFont.systemFont(ofSize: 9)
        icloudDownloadPercentage1.textAlignment = .center
        icloudDownloadPercentage1.textColor = UIColor.titleColors(color: .white)
        
        self.view.addSubview(selectedImage1)
        self.view.addSubview(icloudDownloadImage1)
        icloudDownloadImage1.addSubview(icloudDownloadPercentage1)
        self.view.addSubview(deleteBtnOnImage1)
        
        //第二张图
        selectedImage2.tag = 1
        selectedImage2.layer.cornerRadius = 6
        selectedImage2.layer.masksToBounds = true
        selectedImage2.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        selectedImage2.layer.borderWidth = 1
        selectedImage2.contentMode = .scaleAspectFit
        
        deleteBtnOnImage2.setImage(UIImage(named: "deleteiconimg"), for: .normal)
        deleteBtnOnImage2.tag = 1
        deleteBtnOnImage2.frame = CGRect(x: selectedImage2.frame.maxX - 12, y: selectedImage2.frame.minY - 12, width: 24, height: 24)
        deleteBtnOnImage2.addTarget(self, action: #selector(deleteImageCliced), for: .touchUpInside)
        
        icloudDownloadPercentage2.text = "0%"
        icloudDownloadImage2.image = UIImage(named: "iclouddownloadingimg")
        icloudDownloadImage2.layer.cornerRadius = 6
        icloudDownloadImage2.layer.masksToBounds = true
        icloudDownloadPercentage2.font = UIFont.systemFont(ofSize: 9)
        icloudDownloadPercentage2.textAlignment = .center
        icloudDownloadPercentage2.textColor = UIColor.titleColors(color: .white)
        
        self.view.addSubview(selectedImage2)
        self.view.addSubview(icloudDownloadImage2)
        icloudDownloadImage2.addSubview(icloudDownloadPercentage2)
        self.view.addSubview(deleteBtnOnImage2)
        //第三张图
        selectedImage3.tag = 2
        selectedImage3.layer.cornerRadius = 6
        selectedImage3.layer.masksToBounds = true
        selectedImage3.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        selectedImage3.layer.borderWidth = 1
        selectedImage3.contentMode = .scaleAspectFit
        
        deleteBtnOnImage3.setImage(UIImage(named: "deleteiconimg"), for: .normal)
        deleteBtnOnImage3.tag = 2
        deleteBtnOnImage3.frame = CGRect(x: selectedImage3.frame.maxX - 12, y: selectedImage3.frame.minY - 12, width: 24, height: 24)
        deleteBtnOnImage3.addTarget(self, action: #selector(deleteImageCliced), for: .touchUpInside)
        
        icloudDownloadPercentage3.text = "70%"
        icloudDownloadImage3.image = UIImage(named: "iclouddownloadingimg")
        icloudDownloadImage3.layer.cornerRadius = 6
        icloudDownloadImage3.layer.masksToBounds = true
        icloudDownloadPercentage3.font = UIFont.systemFont(ofSize: 9)
        icloudDownloadPercentage3.textAlignment = .center
        icloudDownloadPercentage3.textColor = UIColor.titleColors(color: .white)
        
        self.view.addSubview(selectedImage3)
        self.view.addSubview(icloudDownloadImage3)
        icloudDownloadImage3.addSubview(icloudDownloadPercentage3)
        self.view.addSubview(deleteBtnOnImage3)
        
        
        selectedImage1.isHidden = true
        selectedImage2.isHidden = true
        selectedImage3.isHidden = true
        deleteBtnOnImage1.isHidden = true
        deleteBtnOnImage2.isHidden = true
        deleteBtnOnImage3.isHidden = true
        icloudDownloadImage1.isHidden = true
        icloudDownloadImage2.isHidden = true
        icloudDownloadImage3.isHidden = true
        
        self.view.addSubview(goodImage)
        self.view.addSubview(orderIDLabel)
        self.view.addSubview(productType)
        self.view.addSubview(materialAndAccessories)
        self.view.addSubview(modalAndColorL)
        self.view.addSubview(seperateLine1)
        self.view.addSubview(noiticeOnUpload)
        self.view.addSubview(AddPicBtn)
        DispatchQueue.global().async {
            self.loadData()
        }
    }
    
    @objc func loadData(){
        let orderInfoObjects = orderObject as! NSDictionary
        let orderID = orderInfoObjects.value(forKey: "orderid") as! String
        _customID = orderInfoObjects.value(forKey: "customid") as! String
        let productObjects = systemParam[0] as! NSDictionary
       // let productInfoObject = orderObject.value(forKey: "goodsinfo") as! NSDictionary
        
        //获取订单图片
        if orderInfoObjects.value(forKey: "smallGoodsImage") as? String == nil{ // 图片字段为空
            DispatchQueue.main.async {
                self.goodImage.image = UIImage(named:"defualt-design-pic")
            }
            
            
        }else{
            let imageURLString:String = "\(downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "smallGoodsImage") as! String)"
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage.gif(data:data)
                DispatchQueue.main.async {
                    self.goodImage.image = image//  UIImage(image:image)
                }
                
            }catch{
                let imageURLString:String = "\(downloadURLHeader)\(orderInfoObjects.value(forKey: "smallGoodsImage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    DispatchQueue.main.async {
                        self.goodImage.image = image//  UIImage(image:image)
                    }
                }catch{
                    print(error)
                }
                print("无缩略图")
            }
            
        }
        DispatchQueue.main.async {
            self._orderID = orderID
            
            //产品类型
            let goodsClassObject = productObjects.value(forKey: "goodsClass") as! NSArray
            let productType = (goodsClassObject[Int(orderInfoObjects.value(forKey: "goodsClass") as! String)! - 1] as! NSDictionary).value(forKey: "goodsClass") as! String
            
            //材质
            let materailObject = productObjects.value(forKey: "material") as! NSArray
            let materialType = (materailObject[Int(orderInfoObjects.value(forKey: "material") as! String)! - 1] as! NSDictionary).value(forKey: "material") as! String
            
            //附件
            var accessoriesType = ""
            let accessoriesObject = productObjects.value(forKey: "accessories") as! NSArray
            if orderInfoObjects.value(forKey: "accessories") as? String == nil{//如果附件为空
                accessoriesType = ""
            }else{
                accessoriesType = (accessoriesObject[Int(orderInfoObjects.value(forKey: "accessories") as! String)! - 1] as! NSDictionary).value(forKey: "accessories") as! String
                if accessoriesType == "无" {
                    accessoriesType = ""
                }
            }

            
            //设置工艺值
            var tempMakeStyleValue = ""
            //开模方式
            let modelClassObject = productObjects.value(forKey: "model") as! NSArray
            let modelString = orderInfoObjects.value(forKey: "model") as! String
            var modelType = ""
            let modelArray = modelString.split(separator: ",")
            for item in modelArray{
                modelType += ",\((modelClassObject[Int(item)! - 1] as! NSDictionary).value(forKey: "model") as! String)"
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
                technologyType += ",\((technologyClassObject[Int(item)!  - 1] as! NSDictionary).value(forKey: "technology") as! String)"
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
                colorType += ",\((colorClassObject[Int(item)! - 1] as! NSDictionary).value(forKey: "color") as! String)"
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
            tempMakeStyleValue = tempMakeStyleValue.replacingOccurrences(of: ";,", with: ";") //将“;,替换为;
            
            self._productType = productType
            self._materialAndAccessory = materialType + " " + accessoriesType
            self._modalAndColor = tempMakeStyleValue
            
            self.orderIDLabel.text = "订单号: \(orderID)"
            self.productType.text = productType
            self.materialAndAccessories.text = self._materialAndAccessory
            self.modalAndColorL.text = self._modalAndColor
        }
        
    }
    @objc func deleteImageCliced(_ button:UIButton){
        let index = button.tag
        switch index {
        case 0:
            deleteAttachment(atIndex: 0)
        case 1:
            deleteAttachment(atIndex: 1)
        case 2:
            deleteAttachment(atIndex: 2)
        default:
            deleteAttachment(atIndex: 0)
        }
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapOnImage(_ tap:UITapGestureRecognizer){
        //TODO
        //图片索引
        let index = tap.view!.tag
        //进入图片全屏展示
        
//        if AttachmentTypes[index-10] == "publuc.movie"{
//
//        }
        guard tempAttachmentPics.count != 0 else {
            greyLayerPrompt.show(text: "图片在下载中..请稍后再预览")
            return
        }
        guard !self.deleteBtnOnImage1.isHidden else {
            greyLayerPrompt.show(text: "图片在下载中..请稍后再预览")
            return
        }
        print("the index of Image is \(index)")
        changePositionOfPictures()
        let previewVC = ImagePreviewVC(images: AttachmentPics, index: index, previewMode: .previewWithDelete)
        previewVC.imageUrls = previewURLs
        previewVC.PreviewType = AttachmentTypes
        previewVC.uploadProductImageVCObject = self
        previewVC.previewSourceVC = "UploadProductImageVC"
        //  previewVC.previewMode = .previewWithDelete
        self.present(previewVC, animated: true, completion: nil)
    }
    
    func changePositionOfPictures(){
        guard tempAttachmentPics.count != 0 else {
            return
        }
        AttachmentPics.removeAll()
        imageURLs.removeAll()
        previewURLs.removeAll()
        AttachmentTypes.removeAll()
        
        switch tempAttachmentPics.count {
        case 1:
            if tempAttachmentPics[0] != nil{
                AttachmentPics.append(tempAttachmentPics[0]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[0]! as String)
                imageURLs.append(tempimageURLs[0]! as String)
                previewURLs.append(temppreviewURLs[0]! as URL)
            }else if tempAttachmentPics[1] != nil{
                AttachmentPics.append(tempAttachmentPics[1]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[1]! as String)
                imageURLs.append(tempimageURLs[1]! as String)
                previewURLs.append(temppreviewURLs[1]! as URL)
            }else{
                AttachmentPics.append(tempAttachmentPics[2]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[2]! as String)
                imageURLs.append(tempimageURLs[2]! as String)
                previewURLs.append(temppreviewURLs[2]! as URL)
            }
        case 2:
            if tempAttachmentPics[0] == nil{
                AttachmentPics.append(tempAttachmentPics[1]! as UIImage)
                AttachmentPics.append(tempAttachmentPics[2]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[1]! as String)
                AttachmentTypes.append(tempAttachmentTypes[2]! as String)
                imageURLs.append(tempimageURLs[1]! as String)
                imageURLs.append(tempimageURLs[2]! as String)
                previewURLs.append(temppreviewURLs[1]! as URL)
                previewURLs.append(temppreviewURLs[2]! as URL)
            }else if tempAttachmentPics[1] == nil{
                AttachmentPics.append(tempAttachmentPics[0]! as UIImage)
                AttachmentPics.append(tempAttachmentPics[2]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[0]! as String)
                AttachmentTypes.append(tempAttachmentTypes[2]! as String)
                imageURLs.append(tempimageURLs[0]! as String)
                imageURLs.append(tempimageURLs[2]! as String)
                previewURLs.append(temppreviewURLs[0]! as URL)
                previewURLs.append(temppreviewURLs[2]! as URL)
            }else{
                AttachmentPics.append(tempAttachmentPics[0]! as UIImage)
                AttachmentPics.append(tempAttachmentPics[1]! as UIImage)
                AttachmentTypes.append(tempAttachmentTypes[1]! as String)
                AttachmentTypes.append(tempAttachmentTypes[0]! as String)
                imageURLs.append(tempimageURLs[1]! as String)
                imageURLs.append(tempimageURLs[0]! as String)
                previewURLs.append(temppreviewURLs[1]! as URL)
                previewURLs.append(temppreviewURLs[0]! as URL)
            }
        case 3:
            AttachmentPics.append(tempAttachmentPics[0]! as UIImage)
            AttachmentPics.append(tempAttachmentPics[1]! as UIImage)
            AttachmentPics.append(tempAttachmentPics[2]! as UIImage)
            
            AttachmentTypes.append(tempAttachmentTypes[0]! as String)
            AttachmentTypes.append(tempAttachmentTypes[1]! as String)
            AttachmentTypes.append(tempAttachmentTypes[2]! as String)
            
            imageURLs.append(tempimageURLs[0]! as String)
            imageURLs.append(tempimageURLs[1]! as String)
            imageURLs.append(tempimageURLs[2]! as String)
            
            previewURLs.append(temppreviewURLs[0]! as URL)
            previewURLs.append(temppreviewURLs[1]! as URL)
            previewURLs.append(temppreviewURLs[2]! as URL)
        default:
            AttachmentPics.append(tempAttachmentPics[0]! as UIImage)
            
            AttachmentTypes.append(tempAttachmentTypes[0]! as String)
            imageURLs.append(tempimageURLs[0]! as String)
            
            previewURLs.append(temppreviewURLs[0]! as URL)
        }
        //AttachmentPics.append((tempAttachmentPics[0] as! UIImage)
    }
    
    func deleteAttachment(atIndex:Int){
        let resourceIndex = atIndex//mapperOfImage[atIndex]
        if atIndex >= tempAttachmentPics.count {
            print("can't found this pic becasue out of range")
        }else{
            switch atIndex{
            case 0:
                if SelectedPicCount == 3{
                    tempAttachmentPics.updateValue(tempAttachmentPics[1]!, forKey: 0)
                    tempAttachmentPics.updateValue(tempAttachmentPics[2]!, forKey: 1)
                    
                   // tempAttachmentPics.key
                    tempAttachmentTypes.updateValue(tempAttachmentTypes[1]!, forKey: 0)
                    tempAttachmentTypes.updateValue(tempAttachmentTypes[2]!, forKey: 1)
                    
                    temppreviewURLs.updateValue(temppreviewURLs[1]!, forKey: 0)
                    temppreviewURLs.updateValue(temppreviewURLs[2]!, forKey: 1)
                    
                    //删除元素
                    tempAttachmentPics.removeValue(forKey: 2) // .remove(at: atIndex)
                    tempAttachmentTypes.removeValue(forKey: 2) //(at: atIndex)
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    let imagePath = tempimageURLs[resourceIndex]// imageURLs[atIndex]
                    
                    do {
                        try fileManager.removeItem(atPath: imagePath!)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    tempimageURLs.updateValue(tempimageURLs[1]!, forKey: 0)
                    tempimageURLs.updateValue(tempimageURLs[2]!, forKey: 1)
                    
                    tempimageURLs.removeValue(forKey: 2)//(at: atIndex)
                    temppreviewURLs.removeValue(forKey: 2)//(at: atIndex)
                }else if SelectedPicCount == 2{
                    tempAttachmentPics.updateValue(tempAttachmentPics[1]!, forKey: 0)
                    tempAttachmentTypes.updateValue(tempAttachmentTypes[1]!, forKey: 0)
                    temppreviewURLs.updateValue(temppreviewURLs[1]!, forKey: 0)
                    //删除元素
                    tempAttachmentPics.removeValue(forKey: 1) // .remove(at: atIndex)
                    tempAttachmentTypes.removeValue(forKey: 1) //(at: atIndex)
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    let imagePath = tempimageURLs[resourceIndex]// imageURLs[atIndex]
                    
                    do {
                        try fileManager.removeItem(atPath: imagePath!)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    tempimageURLs.updateValue(tempimageURLs[1]!, forKey: 0)
                    
                    tempimageURLs.removeValue(forKey: 1)//(at: atIndex)
                    temppreviewURLs.removeValue(forKey: 1)//(at: atIndex)
                }
            case 1:
                if SelectedPicCount == 3{
                    
                    tempAttachmentPics.updateValue(tempAttachmentPics[2]!, forKey: 1)
                    
                    tempAttachmentTypes.updateValue(tempAttachmentTypes[2]!, forKey: 1)
                    
                    temppreviewURLs.updateValue(temppreviewURLs[2]!, forKey: 1)
                    
                    //删除元素
                    tempAttachmentPics.removeValue(forKey: 2)
                    tempAttachmentTypes.removeValue(forKey: 2)
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    let imagePath = tempimageURLs[resourceIndex]// imageURLs[atIndex]
                    
                    do {
                        try fileManager.removeItem(atPath: imagePath!)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    tempimageURLs.updateValue(tempimageURLs[2]!, forKey: 1)
                    tempimageURLs.removeValue(forKey: 2)
                    temppreviewURLs.removeValue(forKey: 2)
                }
            case 2:
                print("no need to switch picture")
            default:
                print("running default")
            }
            
            
            //TODO: update the UI
            print("delete row called succedd")
            OriginalPicCount -= 1
            SelectedPicCount -= 1
            
            AddPicBtn.isHidden = false
            switch SelectedPicCount {
            case 0:
                AddPicBtn.frame = CGRect(x: 20, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
              //  mapperOfImage.remove(at: 0)
                selectedImage1.isHidden = true
                selectedImage2.isHidden = true
                selectedImage3.isHidden = true
                deleteBtnOnImage1.isHidden = true
                deleteBtnOnImage2.isHidden = true
                deleteBtnOnImage3.isHidden = true
                icloudDownloadImage1.isHidden = true
                icloudDownloadImage2.isHidden = true
                icloudDownloadImage3.isHidden = true
            case 1:
                
                if atIndex == 0{
                    selectedImage1.image = selectedImage2.image
                   // mapperOfImage[0] = mapperOfImage[1]
                }
               // mapperOfImage.remove(at: 1)
                AddPicBtn.frame = CGRect(x: 20 + 118, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
                selectedImage1.isHidden = false
                selectedImage2.isHidden = true
                selectedImage3.isHidden = true
                deleteBtnOnImage1.isHidden = false
                deleteBtnOnImage2.isHidden = true
                deleteBtnOnImage3.isHidden = true
                icloudDownloadImage1.isHidden = true
                icloudDownloadImage2.isHidden = true
                icloudDownloadImage3.isHidden = true
            case 2:
                if atIndex == 0{
                    selectedImage1.image = selectedImage2.image
                //   mapperOfImage[0] = mapperOfImage[1]
                    selectedImage2.image = selectedImage3.image
                 //   mapperOfImage[1] = mapperOfImage[2]
                }else if atIndex == 1{
                    selectedImage2.image = selectedImage3.image
                }
              //  mapperOfImage.remove(at: 2)
                AddPicBtn.frame = CGRect(x: 20 + 118 * 2, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)

                selectedImage1.isHidden = false
                selectedImage2.isHidden = false
                selectedImage3.isHidden = true
                deleteBtnOnImage1.isHidden = false
                deleteBtnOnImage2.isHidden = false
                deleteBtnOnImage3.isHidden = true
                icloudDownloadImage1.isHidden = true
                icloudDownloadImage2.isHidden = true
                icloudDownloadImage3.isHidden = true
            default:
                selectedImage1.isHidden = false
                selectedImage2.isHidden = true
                selectedImage3.isHidden = true
                deleteBtnOnImage1.isHidden = false
                deleteBtnOnImage2.isHidden = true
                deleteBtnOnImage3.isHidden = true
                icloudDownloadImage1.isHidden = true
                icloudDownloadImage2.isHidden = true
                icloudDownloadImage3.isHidden = true
            }
            
        }
    }
    
    @objc func addPicBtnClicked(_ button:UIButton){
        //备份代码
        let actionSheet = UIAlertController(title: "上传图片", message: nil, preferredStyle: .actionSheet)
        let
        cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive) { (action:UIAlertAction) -> Void in
            //断是否能进行拍照，可以的话打开相机
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                //根据指定的SourceType来获取该SourceType下可以用的媒体类型，返回的是一个数组
                
                //允许视频
                //let mediaTypeArr:NSArray = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)! as NSArray  //允许视频
                //只允许照片
                let mediaTypeArr:NSArray = ["public.image"]//UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.camera)! as NSArray  //只允许照片
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera//.camera
                picker.mediaTypes = (mediaTypeArr as [AnyObject]) as! [String]
                picker.videoQuality = .typeHigh
                picker.allowsEditing = false
                picker.videoMaximumDuration = 15
                picker.delegate = self //as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                picker.allowsEditing = false
                self.present(picker, animated: true, completion: nil)
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        }
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            //开始选择照片，最多允许选择4张
            let allowChooseCount = 3 - self.SelectedPicCount
            _ = self.presentHGImagePicker(maxSelected:allowChooseCount) { (assets) in
                //结果处理
                print("共选择了\(assets.count)张图片，分别如下：")
                for asset in assets{
                    self.appendImage(with: self.getAssetThumbnail(asset: asset))
                }
                var currentIndex = self.OriginalPicCount
                for asset in assets {
                    self.PHAssetToUIImage(asset: asset,index: currentIndex)
                    currentIndex += 1
                }
            }
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func appendImage(with Image:UIImage){
        guard Image != nil else {
            return
        }
        AddPicBtn.isHidden = false
        switch SelectedPicCount {
        case 0:
            AddPicBtn.frame = CGRect(x: 20 + 118, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
            selectedImage1.image = Image
            
            selectedImage1.isHidden = false
            selectedImage2.isHidden = true
            selectedImage3.isHidden = true
            deleteBtnOnImage1.isHidden = false
            deleteBtnOnImage2.isHidden = true
            deleteBtnOnImage3.isHidden = true
            icloudDownloadImage1.isHidden = true
            icloudDownloadImage2.isHidden = true
            icloudDownloadImage3.isHidden = true
            mapperOfImage.append(0)
        case 1:
            AddPicBtn.frame = CGRect(x: 20 + 118 * 2, y: noiticeOnUpload.frame.maxY + 40, width: 98, height: 98)
            selectedImage2.image = Image
            
            selectedImage1.isHidden = false
            selectedImage2.isHidden = false
            selectedImage3.isHidden = true
            deleteBtnOnImage1.isHidden = false
            deleteBtnOnImage2.isHidden = false
            deleteBtnOnImage3.isHidden = true
            icloudDownloadImage1.isHidden = true
            icloudDownloadImage2.isHidden = true
            icloudDownloadImage3.isHidden = true
            mapperOfImage.append(1)
        case 2:
            selectedImage3.image = Image
            
            AddPicBtn.isHidden = true
            selectedImage1.isHidden = false
            selectedImage2.isHidden = false
            selectedImage3.isHidden = false
            deleteBtnOnImage1.isHidden = false
            deleteBtnOnImage2.isHidden = false
            deleteBtnOnImage3.isHidden = false
            icloudDownloadImage1.isHidden = true
            icloudDownloadImage2.isHidden = true
            icloudDownloadImage3.isHidden = true
            mapperOfImage.append(2)
        default:
            selectedImage1.isHidden = false
            selectedImage2.isHidden = true
            selectedImage3.isHidden = true
            deleteBtnOnImage1.isHidden = false
            deleteBtnOnImage2.isHidden = true
            deleteBtnOnImage3.isHidden = true
            icloudDownloadImage1.isHidden = true
            icloudDownloadImage2.isHidden = true
            icloudDownloadImage3.isHidden = true
        }
        SelectedPicCount += 1
    }
    
    // MARK: - 将PHAsset对象转为UIImage对象
    //获取原图
    func PHAssetToUIImage(asset: PHAsset, index currentIndex:Int){
        //当前的图片索引
        let currentImageIndex = currentIndex
        var tempHDImage = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        imageRequestOption.isNetworkAccessAllowed = true
        // 按照PHImageRequestOptions指定的规则取出图片
        
        // newTaskViewTitle.text = "正在同步iCloud图片..." //上传图片
        imageRequestOption.progressHandler = { (progress, error, stop, info) in
            //可以控制进度条
            print(progress)
            if progress != 1.0 {
                DispatchQueue.main.async(execute: {
                    print("downloading image at \(currentImageIndex)")
                    self.deleteBtnOnImage1.isHidden = true
                    self.deleteBtnOnImage2.isHidden = true
                    self.deleteBtnOnImage3.isHidden = true
                    switch currentImageIndex{
                    case 0:
                        self.icloudDownloadPercentage1.text =  "\(Int(progress*100))%"
                        self.icloudDownloadImage1.isHidden = false
                    case 1:
                        self.icloudDownloadPercentage2.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage2.isHidden = false
                    case 2:
                        self.icloudDownloadPercentage3.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage3.isHidden = false
                    default:
                        self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage1.isHidden = false
                    }
                    //self.progressBtn.progress = CGFloat(progress)
                })
            }else{
                DispatchQueue.main.async(execute: {
                    self.deleteBtnOnImage1.isHidden = false
                    self.deleteBtnOnImage2.isHidden = false
                    self.deleteBtnOnImage3.isHidden = false
                    switch currentImageIndex{
                    case 0:
                        self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage1.isHidden = true
                    case 1:
                        self.icloudDownloadPercentage2.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage2.isHidden = true
                    case 2:
                        self.icloudDownloadPercentage3.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage3.isHidden = true
                    default:
                        self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                        self.icloudDownloadImage1.isHidden = true
                    }
//                    self.
//                    self.progressBtn.isHidden = true
//                    self.updateCellView(tableView: self.newTaskTableView)
                })
            }
        }
        if asset.mediaType == .video{
            
            let options:PHVideoRequestOptions = PHVideoRequestOptions.init()
            options.version = .current
            options.deliveryMode = .automatic
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            
            options.progressHandler = { (progress, error, stop, info) in
                //可以控制进度条
                print(progress)
                if progress != 1.0 {
                    DispatchQueue.main.async(execute: {
                        print("downloading image at \(currentImageIndex)")
                        switch currentImageIndex{
                        case 0:
                            self.icloudDownloadPercentage1.text =  "\(Int(progress*100))%"
                            self.icloudDownloadImage1.isHidden = false
                        case 1:
                            self.icloudDownloadPercentage2.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage2.isHidden = false
                        case 2:
                            self.icloudDownloadPercentage3.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage3.isHidden = false
                        default:
                            self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage1.isHidden = false
                        }
                        //self.progressBtn.progress = CGFloat(progress)
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        switch currentImageIndex{
                        case 0:
                            self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage1.isHidden = true
                        case 1:
                            self.icloudDownloadPercentage2.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage2.isHidden = true
                        case 2:
                            self.icloudDownloadPercentage3.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage3.isHidden = true
                        default:
                            self.icloudDownloadPercentage1.text = "\(Int(progress*100))%"
                            self.icloudDownloadImage1.isHidden = true
                        }
                    })
                }
            }
            
            let videoRequstManager:PHCachingImageManager = PHCachingImageManager.init()// PHImageManager = PHImageManager.default()
            
            DispatchQueue.global(qos: .background).async(execute: {
                videoRequstManager.requestAVAsset(forVideo: asset, options: options, resultHandler: {(AVAsset,nil,infos) -> Void in
                    let urlAssets = AVAsset as? AVURLAsset
                    let data = NSData.init(contentsOf: (urlAssets?.url)!)
                    
                    
                    imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill, options: imageRequestOption, resultHandler: {(result,info) in
                        tempHDImage = result! //如果是图片
                        
                        self.tempAttachmentPics.updateValue(tempHDImage, forKey: currentIndex)// append(tempHDImage)
                    })
                    //图片保存的路径
                    //这里将图片放在沙盒的documents文件夹中
                    
                    //Home目录
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/ProductImage"
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                    do {
                        try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    
                    var fnameIndex = "00"
                    if self.OriginalPicCount == 0 {
                        fnameIndex = "00"
                    }else if self.OriginalPicCount == 1{
                        fnameIndex = "01"
                    }else if self.OriginalPicCount == 2{
                        fnameIndex = "02"
                    }else {
                        fnameIndex = "03"
                    }
                    
                    // let fileExtent = "MP4"
                    
                    let fnameWithExtend = "/image00\(fnameIndex).MP4"
                    
                    let imagePath = documentPath.appending(fnameWithExtend)
                    fileManager.createFile(atPath: imagePath, contents: data! as Data, attributes: nil)
                    //得到选择后沙盒中图片的完整路径
                    let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
                    //将图片插入到imageURLs
                    self.tempimageURLs.updateValue(filePath, forKey: currentIndex)// append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.temppreviewURLs.updateValue((urlAssets?.url)!, forKey: currentIndex)// append((urlAssets?.url)!)
                    self.mapperOfImage[self.OriginalPicCount] = currentIndex
//                    if self.OriginalPicCount == 0{
//                            self.mapperOfImage.updateValue(currentIndex, forKey: 0)// append(currentIndex)
//                    }else if self.OriginalPicCount == 1{
//                        self.mapperOfImage.updateValue(currentIndex, forKey: 1)// append(currentIndex)
//                    }else{
//                        self.mapperOfImage.updateValue(currentIndex, forKey: 2)// append(currentIndex)
//                    }
                    //self.mapperOfImage.updateValue(currentIndex, forKey: hai)// append(currentIndex)
                    
                    self.OriginalPicCount += 1
                    self.tempAttachmentTypes.updateValue("public.movie", forKey: currentIndex) // append("public.movie")// 视频或者视频
                    
//                    DispatchQueue.main.async(execute: {
//                        self.progressBtn.isHidden = true
//                        self.updateCellView(tableView: self.newTaskTableView)
//                    })
                })
                
            })
        }else{
            //获取原图
            DispatchQueue.global(qos: .background).async {
                imageManager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill, options: imageRequestOption, resultHandler: {(result,info) in
                    tempHDImage = result! //如果是图片
                    
                    //先把图片转成NSData
                    let data = UIImageJPEGRepresentation(tempHDImage, 0.5)
                    
                    //图片保存的路径
                    //这里将图片放在沙盒的documents文件夹中
                    
                    //Home目录
                    let homeDirectory = NSHomeDirectory()
                    let documentPath = homeDirectory + "/Documents/ProductImage"
                    //文件管理器
                    let fileManager: FileManager = FileManager.default
                    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
                    do {
                        try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch  {
                        print("something wrong was happening")
                    }
                    
                    var fnameIndex = "00"
                    if self.OriginalPicCount == 0 {
                        fnameIndex = "00"
                    }else if self.OriginalPicCount == 1{
                        fnameIndex = "01"
                    }else if self.OriginalPicCount == 2{
                        fnameIndex = "02"
                    }else {
                        fnameIndex = "03"
                    }
                    
                    
                    let fnameWithExtend = "/image00\(fnameIndex).png"
                    let imagePath = documentPath.appending(fnameWithExtend)
                    fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
                    //fileManager.createFileAtPath(documentPath.append("/image.png"), contents: data, attributes: nil)
                    //得到选择后沙盒中图片的完整路径
                    let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
                    //将图片插入到imageURLs
                    self.tempimageURLs.updateValue(filePath, forKey: currentIndex)// append(filePath)
                    let urls:URL = URL.init(string: filePath)!
                    self.temppreviewURLs.updateValue(urls, forKey: currentIndex)// append(urls)
                    self.mapperOfImage[self.OriginalPicCount] = currentIndex
//                    if self.OriginalPicCount == 0{
//                        self.mapperOfImage.updateValue(currentIndex, forKey: 0)// append(currentIndex)
//                    }else if self.OriginalPicCount == 1{
//                        self.mapperOfImage.updateValue(currentIndex, forKey: 1)// append(currentIndex)
//                    }else{
//                        self.mapperOfImage.updateValue(currentIndex, forKey: 2)// append(currentIndex)
//                    }
                    
                    self.OriginalPicCount += 1
                    self.tempAttachmentPics.updateValue(tempHDImage, forKey: currentIndex)// append(tempHDImage)
                    print("Insert picture at index \(currentImageIndex)")
                    self.tempAttachmentTypes.updateValue("public.image", forKey: currentIndex)// append("public.image")// 视频或者视频
                    //self.mapperOfImage.append(currentIndex)
//                    DispatchQueue.main.async(execute: {
//                        self.progressBtn.isHidden = true
//                        self.updateCellView(tableView: self.newTaskTableView)
//                    })
                    //self.updateCellView(tableView: self.newTaskTableView)
                })
            }
        }
        
    }
    
    //获取缩略图
    func getAssetThumbnail(asset:PHAsset) -> UIImage{
        var image:UIImage?
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        let targetSize:CGSize = CGSize(width: 90, height: 90)
        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (thumbnailImage, info) in
            print("getted thumbnailimaged")
            image = thumbnailImage
        }
        return image!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        print("canceled")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        //当选择的类型是图片
        if type == "public.image"
        {
            
            //修正图片的位置
            let image = self.fixOrientation(aImage: (info[UIImagePickerControllerOriginalImage] as! UIImage))
            //先把图片转成NSData
            let data = UIImageJPEGRepresentation(image, 0.5)
            
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/ProductImage"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch  {
                print("something wrong was happening")
            }
            
            var fnameIndex = "00"
            if self.OriginalPicCount == 0 {
                fnameIndex = "00"
            }else if self.OriginalPicCount == 1{
                fnameIndex = "01"
            }else if self.OriginalPicCount == 2{
                fnameIndex = "02"
            }else {
                fnameIndex = "03"
            }
            let fnameWithExtend = "/image00\(fnameIndex).png"
            
            let imagePath = documentPath.appending(fnameWithExtend)
            fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
            //fileManager.createFileAtPath(documentPath.append("/image.png"), contents: data, attributes: nil)
            //得到选择后沙盒中图片的完整路径
            let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
            print("filePath:" + filePath)
            //            Alamofire.upload(.POST, "http://192.168.3.16:9060/client/updateHeadUrl", multipartFormData: { multipartFormData in
            //                let lastData = NSData(contentsOfFile: filePath)
            //
            //                multipartFormData.appendBodyPart(data: lastData!, name: "image")
            //
            //            }, encodingCompletion: { response in
            //                picker.dismissViewControllerAnimated(true, completion: nil)
            //                switch response {
            //                case .Success(let upload, _, _):
            //                    upload.responseJSON(completionHandler: { (response) in
            //                        print(response)
            //                        self.imageView.image = UIImage(data: data!)
            //
            //                    })
            //
            //                case .Failure(let encodingError):
            //                    print(encodingError)
            //                }
            //
            //            })
            
            tempAttachmentPics.updateValue(image, forKey: self.OriginalPicCount) //append(image)
            tempAttachmentTypes.updateValue("public.image", forKey: self.OriginalPicCount)// append("public.image")
            
            tempimageURLs.updateValue(filePath, forKey: self.OriginalPicCount)// append(filePath)
            let urls:URL = URL.init(string: filePath)!
            temppreviewURLs.updateValue(urls, forKey: self.OriginalPicCount)// append(urls)
            print("the taken pic upload successed")
            self.mapperOfImage[self.OriginalPicCount] = self.OriginalPicCount
//            if self.OriginalPicCount == 0{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 0)// append(currentIndex)
//            }else if self.OriginalPicCount == 1{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 1)// append(currentIndex)
//            }else{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 2)// append(currentIndex)
//            }
//
            OriginalPicCount += 1
            picker.dismiss(animated: true, completion: nil)
            appendImage(with: image)
           // self.mapperOfImage.append(self.OriginalPicCount)
           // updateCellView(tableView: newTaskTableView)
            
        }
        
        //当选择的类型是图片
        if type == "public.movie"
        {
            print("你拍摄的是视频")
            //系统保存到tmp目录里的文件路径
            let infoDic = info as NSDictionary
            let mediaUrl:URL = infoDic[UIImagePickerControllerMediaURL] as! URL
            let videoPath = mediaUrl.path
            
            //如果视频文件可以保存的话
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath){
                //用下边的方法保存视频
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil)
            }
            
            //先把视频转成NSData
            let data = NSData(contentsOf: mediaUrl)
            
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents/ProductImage"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch  {
                print("something wrong was happening")
            }
            
            var fnameIndex = "00"
            if self.OriginalPicCount == 0 {
                fnameIndex = "00"
            }else if self.OriginalPicCount == 1{
                fnameIndex = "01"
            }else if self.OriginalPicCount == 2{
                fnameIndex = "02"
            }else {
                fnameIndex = "03"
            }
            let fnameWithExtend = "/image00\(fnameIndex).mov"
            
            let imagePath = documentPath.appending(fnameWithExtend)
            
            fileManager.createFile(atPath: imagePath, contents: data! as Data, attributes: nil)
            //得到选择后沙盒中视频的完整路径
            let filePath: String = String(format: "%@%@", documentPath, fnameWithExtend)
            print("filePath:" + filePath)
            //            Alamofire.upload(.POST, "http://192.168.3.16:9060/client/updateHeadUrl", multipartFormData: { multipartFormData in
            //                let lastData = NSData(contentsOfFile: filePath)
            //
            //                multipartFormData.appendBodyPart(data: lastData!, name: "image")
            //
            //            }, encodingCompletion: { response in
            //                picker.dismissViewControllerAnimated(true, completion: nil)
            //                switch response {
            //                case .Success(let upload, _, _):
            //                    upload.responseJSON(completionHandler: { (response) in
            //                        print(response)
            //                        self.imageView.image = UIImage(data: data!)
            //
            //                    })
            //
            //                case .Failure(let encodingError):
            //                    print(encodingError)
            //                }
            //
            //            })
            //将视频转成avAsset
            let avAsset = AVAsset(url: mediaUrl as URL)
            
            //生成视频截图
            let generator = AVAssetImageGenerator(asset: avAsset)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0,600)
            var actualTime:CMTime = CMTimeMake(0,0)
            let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
            let frameImg = UIImage.init(cgImage: imageRef)
            
            let image =  frameImg
            tempAttachmentPics.updateValue(image, forKey: self.OriginalPicCount)// append(image)
            tempAttachmentTypes.updateValue("public.movie", forKey: self.OriginalPicCount)// append("public.movie")
            tempimageURLs.updateValue(filePath, forKey: self.OriginalPicCount)// append(filePath) // filePath
            temppreviewURLs.updateValue(mediaUrl, forKey: self.OriginalPicCount)// append(mediaUrl)
            print("videoPath: \(videoPath)")
            print("the taken video upload successed")
            self.mapperOfImage[self.OriginalPicCount] = self.OriginalPicCount
//            if self.OriginalPicCount == 0{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 0)// append(currentIndex)
//            }else if self.OriginalPicCount == 1{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 1)// append(currentIndex)
//            }else{
//                self.mapperOfImage.updateValue(OriginalPicCount, forKey: 2)// append(currentIndex)
//            }
            
            OriginalPicCount += 1
            picker.dismiss(animated: true, completion: nil)
            appendImage(with: image)
            //self.mapperOfImage.append(OriginalPicCount)
            //            //测试预览视频
            //            //视频播放
            //
            //            //定义一个视频播放器，通过本地文件路径初始化
            //            let player = AVPlayer(url: mediaUrl)
            //            let playerViewController = AVPlayerViewController()
            //            playerViewController.player = player
            //            self.present(playerViewController, animated: true) {
            //                playerViewController.player!.play()
            //            }
            
        }
    }
    //修复旋转照片的功能
    func fixOrientation(aImage: UIImage) -> UIImage {
        // No-op if the orientation is already correct
        if aImage.imageOrientation ==  .up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity//  CGAffineTransformIdentity
        switch aImage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: aImage.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: aImage.size.height)
            transform = transform.rotated(by: -.pi/2)
        default:
            break
        }
        
        switch aImage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: aImage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: aImage.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        
        let ctx = CGContext(data: nil, width: Int(aImage.size.width), height: Int(aImage.size.height), bitsPerComponent: (aImage.cgImage?.bitsPerComponent)!, bytesPerRow:0 , space: (aImage.cgImage?.colorSpace!)!, bitmapInfo: (aImage.cgImage?.bitmapInfo)!.rawValue)
        ctx?.concatenate(transform)
        
        switch aImage.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.height), height: CGFloat(aImage.size.width)))
        default:
            ctx?.draw(aImage.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(aImage.size.width), height: CGFloat(aImage.size.height)))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = (ctx?.makeImage())!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    //上传附件，并返回附件名称
    func uploadFiles(images:[String])->[String]{
        
        //请求用到的参数
        var Bucket = "resource-1255653994"
        #if DEBUG
        Bucket = "test-1255653994"
        #else
        Bucket = "resource-1255653994"
        #endif
        
        //定义请求参数
        var fileUrls:[String] = []
        //循环次数控制
        var LoopMaxCount = images.count
        var LoopCurrentCount = 1
        for image in images{
            do{
                
                let fileLocalUrl:NSURL = NSURL.fileURL(withPath: image) as NSURL
                
                let fnameExtension = image.substring(from: image.index(of: ".")!)
                
                let upload = QCloudCOSXMLUploadObjectRequest<AnyObject>()
                upload.body = fileLocalUrl
                upload.bucket = Bucket
                
                let date = NSDate()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyyMMdd"
                let strNowTime = timeFormatter.string(from: date as Date) as String
                let fnameInDataBase = "\(_orderID)_\(getRandomName())\(fnameExtension)"
                upload.object = "/\(fnameInDataBase)"
                
                greyLayerPrompt.show(text: "成品图上传中:开始上传")
                upload.setFinish({ (result, error) in
                    DispatchQueue.main.async {
                        print("上传成功图片\(LoopCurrentCount)")
                        if (error != nil) {
                            print("something was wrong,Error message:\(String(describing: error?.localizedDescription))")
                        }else{
                            
                            print("***************图片上传完了，准备上传服务器********************")
                            if LoopMaxCount == LoopCurrentCount{
                                print("当前成功上传图片\(LoopMaxCount),开始创建任务task")
                                //self.createTaskList()//创建任务在图片上传成功后
                                self.uploadToServer()
                            }else{
                                print("当前成功上传图片\(LoopCurrentCount),不执行CreateTaskList")
                            }
                            print("result:\(result?.qcloud_modelToJSONString() ?? "complte")")
                            greyLayerPrompt.show(text: "成品上传中:图片\(LoopCurrentCount)上传成功")
                            LoopCurrentCount += 1
                        }
                    }
                })
                
                let defaultCOSTRANSFERMANGER:QCloudCOSTransferMangerService = QCloudCOSTransferMangerService.defaultCOSTransferManager()
                defaultCOSTRANSFERMANGER.uploadObject(upload)
                fileUrls.append(fnameInDataBase)//
            }catch{
                print("URL create failded")
            }
            
        }
        return fileUrls
    }
    
    
    
    func uploadToServer(){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as! String
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
//        var urls = taskImages[0]
//        if taskImages.count == 2{
//            urls += "," + taskImages[1]
//        }else if taskImages.count == 3{
//            urls += "," + taskImages[1]
//            urls += "," + taskImages[2]
//        }

        
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        params["customid"] = _customID
        header["token"] = token
        switch taskImages.count {
        case 0:
            return
        case 1:
            params["initialReferenceImage1"] = taskImages[0].value(forKey: "originalImage") as! String
            params["initialReferenceImage2"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "originalImage") as! String
            params["initialReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "originalImage") as! String
            params["middleReferenceImage1"] =  taskImages[0].value(forKey: "middleImage") as! String
            params["middleReferenceImage2"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "middleImage") as! String
            params["middleReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "middleImage") as! String
            params["smallReferenceImage1"] =  taskImages[0].value(forKey: "smallImage") as! String
            params["smallReferenceImage2"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "smallImage") as! String
            params["smallReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "smallImage") as! String
        case 2:
            params["initialReferenceImage1"] = taskImages[0].value(forKey: "originalImage") as! String
            params["initialReferenceImage2"] =  taskImages[1].value(forKey: "originalImage") as! String
            params["initialReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "originalImage") as! String
            params["middleReferenceImage1"] =  taskImages[0].value(forKey: "middleImage") as! String
            params["middleReferenceImage2"] =  taskImages[1].value(forKey: "middleImage") as! String
            params["middleReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "middleImage") as! String
            params["smallReferenceImage1"] =  taskImages[0].value(forKey: "smallImage") as! String
            params["smallReferenceImage2"] =  taskImages[1].value(forKey: "smallImage") as! String
            params["smallReferenceImage3"] =  ""//(taskImages[0] as! NSDictionary).value(forKey: "smallImage") as! String
        case 3:
            params["initialReferenceImage1"] = taskImages[0].value(forKey: "originalImage") as! String
            params["initialReferenceImage2"] =  taskImages[1].value(forKey: "originalImage") as! String
            params["initialReferenceImage3"] =  taskImages[2].value(forKey: "originalImage") as! String
            params["middleReferenceImage1"] =  taskImages[0].value(forKey: "middleImage") as! String
            params["middleReferenceImage2"] =  taskImages[1].value(forKey: "middleImage") as! String
            params["middleReferenceImage3"] =  taskImages[2].value(forKey: "middleImage") as! String
            params["smallReferenceImage1"] =  taskImages[0].value(forKey: "smallImage") as! String
            params["smallReferenceImage2"] =  taskImages[1].value(forKey: "smallImage") as! String
            params["smallReferenceImage3"] =  taskImages[2].value(forKey: "smallImage") as! String
        default:
            print("hello")
        }
       // params["images"] = urls
     
        
        #if DEBUG
       var requestUrl = apiAddresses.value(forKey: "uploadProuctImageAPIDebug") as! String
        #else
       var requestUrl = apiAddresses.value(forKey: "uploadProuctImageAPI") as! String
        #endif
        let newServer = UserDefaults.standard.object(forKey: "newServer") as! Bool
        if !newServer {
            requestUrl = requestUrl.replacingOccurrences(of: "140.143.249.2", with: "119.27.170.195")
        }
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    let statusMsg = json["message"].string!
                    if statusCode == 200{
                        greyLayerPrompt.show(text: statusMsg)
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                    }else {
                        greyLayerPrompt.show(text: statusMsg)
                    }
                    
                }
            case false:
                greyLayerPrompt.show(text: "上传失败,请重试")
            }
            print("data reload")
        }
        self.cancelBtnClicked()
    }
    
    func clearImageCache(){
        
        //Home目录
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents/ProductImage"
        //文件管理器
        let fileManager: FileManager = FileManager.default
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            //try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            var currentPath = try fileManager.currentDirectoryPath
            currentPath.removeAll()
        }
        catch  {
            print("something wrong was happening")
        }
    }
    
    @objc func uploadBtnClicked(){
        changePositionOfPictures()
        let userinfos = getCurrentUserInfo()
        let token = userinfos.value(forKey: "token") as! String
        //taskImages = uploadFiles(images: imageURLs)
        uploadImageToServer(with: AttachmentPics, customID: _customID, usage: "product_image", userToken: token)
    }
    
    //通过服务器上传图片
    func uploadImageToServer( with img:[UIImage], customID customid:String,usage type:String, userToken token:String){
        
        var fileURLs:[NSDictionary] = []
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let plistData:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = plistData.value(forKey: "apiAddress") as! NSDictionary
        
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        
        
        #if DEBUG
        var uploadurl = apiAddresses.value(forKey: "uploadImageAPIDebug") as! String
        #else
        var uploadurl = apiAddresses.value(forKey: "uploadImageAPI") as! String
        #endif
        
        var LoopMaxCount = img.count
        var LoopCurrentCount = 1
        
        for image in img{
            let data=UIImagePNGRepresentation(image)//把图片转成data
            
            Alamofire.upload(multipartFormData: { (FormData) in
                let param = ["customid":customid,"type":type]
                for (key,value) in param{
                    FormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                FormData.append(data!, withName: "file", fileName: "fileName.png", mimeType:"image/png")
            }, to: uploadurl,headers:header) { (encodingResult) in
                switch encodingResult {
                case .success(let upload,_,_) :
                    upload.responseJSON(completionHandler: { (response) in
                        print("\(response)")  //上传成功通过response返回json值
                        switch response.result.isSuccess{
                        case true:
                            if  let value = response.result.value{
                                let json = JSON(value)
                                let statusCode = json["code"].int!
                                if statusCode == 200 {
                                    print("图片上传到服务器成功")
                                    let urlsDic = ["smallImage":json["data","sImageUrl"].string!,"originalImage":json["data","oImageUrl"].string!,"middleImage":json["data","mImageUrl"].string!]
                                    fileURLs.append(urlsDic as NSDictionary)
                                    self.taskImages.append(urlsDic as NSDictionary)
                                    if LoopCurrentCount == LoopMaxCount{
                                        self.uploadToServer()
                                      //  return fileURLs
                                    }else{
                                        LoopCurrentCount += 1
                                    }
                                }else if statusCode == 99999 || statusCode == 99998{
                                    //异常
                                    autoLogin(viewControler: self)
//                                    greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                                    LogoutMission(viewControler: self)
                                }else{
                                    print("发货失败，code:\(statusCode)")
                                    let errorMsg = json["message"].string!
                                    greyLayerPrompt.show(text: errorMsg)
                                }
                            }
                        case false:
                            print("hallo")
                            greyLayerPrompt.show(text: "服务器异常，上传图片失败")
                        }
                    })
                case .failure(let error):
                    print(error)
                    greyLayerPrompt.show(text: "服务器异常，上传图片失败")
                }
            }
        }
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
