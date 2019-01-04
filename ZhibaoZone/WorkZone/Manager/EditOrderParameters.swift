//
//  OrderOfManagerViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class EditOrderParameters: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource {
    
    //订单
    var orderObject:NSDictionary = [:]
    
    //搜索页面Object
    var orderVCObject  = OrderSearchViewController(searchModel: searchContentsType.orderidAndWangWangID, roleType: 4)
    //订单号
    var orderID:UILabel = UILabel.init()
    //customid
    var customIDValue:String = ""
    var orderIDValue:String = ""
    //订单图
    var orderImage:UIImageView = UIImageView.init()
    var orderState:UILabel = UILabel.init()
    var designState:UILabel = UILabel.init()
    var quotePriceState:UILabel = UILabel.init()
    var payState:UILabel = UILabel.init()
    //含税标签
    var orderPriceLabel:UIImageView = UIImageView.init()

    // 产品参数字典
    var ProductParams:[[NSDictionary]] = [[]]
    var parasCounts:[Int] = []
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    
    //开模方式选中项
    var moldSelectedItems:[String] = []
    //生产工艺选中项
    var produceStyleSelectedItems:[String] = []
    //电镀色选中项目
    var colorSelectedItems:[String] = []
    
    //保存预览
    lazy var savePreviewBG:UIImageView = UIImageView.init()
    lazy var grayLayer:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
    lazy var blurView =  showBlurEffect()
    lazy var confirmSaveBtn:UIButton = UIButton.init(type: .custom)
    lazy var beforeChangeLabel:UILabel = UILabel.init()
    lazy var afterChangeLabel:UILabel = UILabel.init()
    
    lazy var ProductType_Old:UILabel = UILabel.init()
    lazy var ProductAmount_Old:UILabel = UILabel.init()
    lazy var ProductMatarialAndAccessories_Old:UILabel = UILabel.init()
    lazy var ProductProduceParas_Old:UILabel = UILabel.init()
    lazy var ProductDeadline_Old:UILabel = UILabel.init()
    lazy var ProductSize_Old:UILabel = UILabel.init()
    
    lazy var ProductType_New:UILabel = UILabel.init()
    lazy var ProductAmount_New:UILabel = UILabel.init()
    lazy var ProductMatarialAndAccessories_New:UILabel = UILabel.init()
    lazy var ProductProduceParas_New:UILabel = UILabel.init()
    lazy var ProductDeadline_New:UILabel = UILabel.init()
    lazy var ProductSize_New:UILabel = UILabel.init()
    lazy var afterChangeIcon:UIImageView = UIImageView.init()
    //附件图片下载地址
    var downloadURLHeader = ""
    var downloadURLHeaderForThumbnail = ""
    
    //产品类型
    let productTypeLabel:UILabel = UILabel.init()
    let productTypeValue:UILabel = UILabel.init()
    
    
    //旧值
    var old_productType:String = "徽章"
    var old_material:String = ""
    var old_accessories:String = ""
    var old_amount:Int = 0
    var old_modal:String = ""
    var old_produceStyle:String = ""
    var old_length:String = ""
    var old_width:String = ""
    var old_height:String = ""
    var old_color:String = ""
    var old_deadline:String = ""
    var old_shop:String = ""
    var old_customerWang:String = ""
    var old_isCountinueOrder:String = ""
    //新值
    var new_productType:String = "徽章"
    var new_material:String = ""
    var new_accessories:String = ""
    var new_amount:Int = 0
    var new_modal:String = ""
    var new_produceStyle:String = ""
    var new_length:String = ""
    var new_width:String = ""
    var new_height:String = ""
    var new_color:String = ""
    var new_deadline:String = ""
    var new_shop:String = ""
    var new_customerWang:String = ""
    var new_isCountinueOrder:String = ""
    
    //旧值-ID
    var old_productType_ID:String = ""
    var old_material_ID:String = ""
    var old_accessories_ID:String = ""
    var old_amount_ID:Int = 0
    var old_modal_ID:String = ""
    var old_produceStyle_ID:String = ""
    var old_length_ID:String = ""
    var old_width_ID:String = ""
    var old_height_ID:String = ""
    var old_color_ID:String = ""
    var old_deadline_ID:String = ""
    var old_shop_ID:String = ""
    var old_customerWang_ID:String = ""
    var old_isCountinueOrder_ID:String = ""
    //新值-ID
    var new_productType_ID:String = ""
    var new_material_ID:String = ""
    var new_accessories_ID:String = ""
    var new_amount_ID:Int = 0
    var new_modal_ID:String = ""
    var new_produceStyle_ID:String = ""
    var new_length_ID:String = ""
    var new_width_ID:String = ""
    var new_height_ID:String = ""
    var new_color_ID:String = ""
    var new_deadline_ID:String = ""
    var new_shop_ID:String = ""
    var new_customerWang_ID:String = ""
    var new_isCountinueOrder_ID:String = ""
    //keywindows
  //  let keywindow = UIApplication.shared.keyWindow
 //   var window = UIWindow.init()
    
    lazy var ProductTypePicker:UIPickerView = {
        let tempPicker = UIPickerView.init()
        tempPicker.frame = CGRect(x: 0, y: 30, width: kWidth, height: 150)
        // tempPicker.selectRow(0, inComponent: 0, animated: true)
        tempPicker.reloadComponent(0)
        tempPicker.delegate = self
        tempPicker.isHidden = true
        return tempPicker
    }()
    
    //产品材质
    let productMaterialLabel:UILabel = UILabel.init()
    let productMaterialValue:UILabel = UILabel.init()
    lazy var ProductMaterialPicker:UIPickerView = {
        let tempPicker = UIPickerView.init()
        tempPicker.frame = CGRect(x: 0, y: 30, width: kWidth, height: 150)
        tempPicker.delegate = self
        tempPicker.reloadComponent(0)
        //  tempPicker.selectRow(0, inComponent: 0, animated: true)
        tempPicker.isHidden = true
        return tempPicker
    }()
    //附件
    let productAccessoriesLabel:UILabel = UILabel.init()
    let productAccessoriesValue:UILabel = UILabel.init()
    lazy var ProductAccessoriesPicker:UIPickerView = {
        let tempPicker = UIPickerView.init()
        tempPicker.frame = CGRect(x: 0, y: 30, width: kWidth, height: 150)
        // tempPicker.selectRow(0, inComponent: 0, animated: true)
        tempPicker.delegate = self
        tempPicker.isHidden = true
        return tempPicker
    }()
    
    //开模方式
    let productMoldStyleLabel:UILabel = UILabel.init()
    let productMoldStyleValue:UILabel = UILabel.init()
    //生产工艺
    let productProduceStyleLabel:UILabel = UILabel.init()
    let productProduceStyleValue:UILabel = UILabel.init()
    //电镀色
    let productColorLabel:UILabel = UILabel.init()
    let productColorValue:UILabel = UILabel.init()
    //尺寸
    let productSizeLabel:UILabel = UILabel.init()
    let productSizeValue:UILabel = UILabel.init()
    var productLengthValue:String = "0.0"
    var productWidthValue:String = "0.0"
    var productHeightValue:String = "0.0"
   // let byLabel1:UILabel = UILabel.init()
  //  let byLabel2:UILabel = UILabel.init()
    //数量
    let productAmountLabel:UILabel = UILabel.init()
    let productAmountValue:UITextField = UITextField.init()
    //工期
    let productDeadLineLabel:UILabel = UILabel.init()
    let productDeadLineValue:UITextField = UITextField.init()
    //分割线
    let seperateLine1:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine2:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine3:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 1))
    let seperateLine4:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine5:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine6:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30 , height: 0.5))
    let seperateLine7:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30 , height: 0.5))
    let seperateLine8:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30 , height: 0.5))
    let seperateLine9:UIView = UIView.init(frame: CGRect(x: 15, y: 52, width: kWidth - 30 , height: 0.5))
    let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 35, y: 16, width: 20, height: 20))
    //保存
    let saveBtn:UIButton = UIButton.init(type: UIButtonType.custom)
    //判断cell是否展开
    var isProductTypeExpand = false
    var isProductMaterialExpand = false
    var isProductAccessoriesExpand = false
    
    lazy var editOrderParasTable:UITableView = {
        let tempTableView = UITableView(frame: CGRect(x: 0, y: 186 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 186 - heightChangeForiPhoneXFromTop), style: UITableViewStyle.grouped)
        //.init(frame: CGRect(x: 0, y: 186 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 186 - heightChangeForiPhoneXFromTop))
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.backgroundColor = UIColor.white
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        tempTableView.separatorStyle = .none
        
        return tempTableView
    }()
    
    
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        
        //setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        super.viewDidLoad()
        setupUI()
        systemParam = getSystemParasFromPlist()
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
        titleLabel.text = "编辑订单"
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
        
       
        //添加左侧
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        
        //获取数据
        //从plist获取CheckListItem
        
        ProductParams.removeAll()
        let productParamDicObjec = systemParam[0] as! NSDictionary
        
        let productDicInArray = productParamDicObjec.value(forKey: "goodsClass") as! [NSDictionary]
        let materialDicInArray = productParamDicObjec.value(forKey: "material") as! [NSDictionary]
        let accessoriesDicInArray = productParamDicObjec.value(forKey: "accessories") as! [NSDictionary]
        let modelDicInArray = productParamDicObjec.value(forKey: "model") as! [NSDictionary]
        let technologyDicInArray = productParamDicObjec.value(forKey: "technology") as! [NSDictionary]
        let colorDicInArray = productParamDicObjec.value(forKey: "color") as! [NSDictionary]
        
        ProductParams.append(productDicInArray)
        ProductParams.append(materialDicInArray)
        ProductParams.append(accessoriesDicInArray)
        ProductParams.append(modelDicInArray)
        ProductParams.append(technologyDicInArray)
        ProductParams.append(colorDicInArray)
        
        parasCounts.removeAll()
        for i in 0..<ProductParams.count{
            parasCounts.append(ProductParams[i].count)
        }
        
        self.view.addSubview(editOrderParasTable)
        self.view.bringSubview(toFront: saveBtn)
        setupSelectedItems()
        
//        if tempParaItems?.count == 0{
//            loadOrderDataFromServer()
//        }else{
//            for i in tempParaItems!{
//                ProductParams.append(i as! [NSDictionary])
//            }
//            parasCounts.removeAll()
//            for items in ProductParams{
//                parasCounts.append(items.count)
//            }
//
//            //contactCountself.view.addSubview(chooseContactTableView)
//        }
//
        self.view.addSubview(saveBtn)
        self.view.bringSubview(toFront: saveBtn)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
//        //获取数据
//        //从plist获取CheckListItem
//        let plistFile = Bundle.main.path(forResource: "checkListItemsArray", ofType: "plist")
//        let tempParaItems = NSArray.init(contentsOfFile: plistFile!)
//        ProductParams.removeAll()
//
//        if tempParaItems?.count == 0{
//            loadOrderDataFromServer()
//        }else{
//            for i in tempParaItems!{
//                ProductParams.append(i as! [String])
//            }
//            parasCounts.removeAll()
//            for items in ProductParams{
//                parasCounts.append(items.count)
//            }
//            self.view.addSubview(editOrderParasTable)
//            self.view.bringSubview(toFront: saveBtn)
//            setupSelectedItems()
//            //contactCountself.view.addSubview(chooseContactTableView)
//        }
    }
    
    private func setupUI(){
        
        //背景颜色
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //iPhoneX适配
        if UIDevice.current.isX(){
            heightChangeForiPhoneXFromTop = 24.0
        }else{
            heightChangeForiPhoneXFromTop = 0.0
        }
        
        //订单信息层
        let orderInfoBgView:UIView = UIView.init(frame: CGRect(x: 10, y: 76 + heightChangeForiPhoneXFromTop, width: kWidth - 20, height: 100))
        orderInfoBgView.layer.cornerRadius = 8
        orderInfoBgView.backgroundColor = UIColor.backgroundColors(color: .white)
        let orderInfoBgViewShadow:UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 122  + heightChangeForiPhoneXFromTop, width: kWidth - 20, height: 52))
        orderInfoBgViewShadow.image = UIImage(named: "pricebgshadow")

        self.view.addSubview(orderInfoBgViewShadow)
        self.view.addSubview(orderInfoBgView)
        
        //订单图
        orderImage.frame = CGRect(x: 5, y: 5, width: 90, height: 90)
        orderImage.image = UIImage(named: "defualt-design-pic-loading")
        orderImage.layer.masksToBounds = true
        orderImage.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        orderImage.layer.borderWidth = 1
        orderImage.layer.cornerRadius = 6
        orderImage.contentMode = .scaleAspectFit
        orderInfoBgView.addSubview(orderImage)
        
        orderID.frame = CGRect(x: 110, y: 5, width: kWidth - 20, height: 20)
        orderID.text = "订单号: 10000000"
        orderID.font = UIFont.systemFont(ofSize: 14)
        orderInfoBgView.addSubview(orderID)
        
        orderState.frame = CGRect(x: orderID.frame.minX, y: orderID.frame.maxY + 10, width: 68, height: 21)
        orderState.text = "新订单"
        orderState.textColor = UIColor.titleColors(color: .darkGray)
        orderState.font = UIFont.systemFont(ofSize: 12)
        orderState.layer.cornerRadius = 2
        orderState.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        orderState.layer.borderWidth = 0.5
        orderInfoBgView.addSubview(orderState)
        orderState.textAlignment = .center
        
        payState.frame = CGRect(x: orderID.frame.minX + 80, y: orderID.frame.maxY + 10, width: 68, height: 21)
        payState.text = "未支付"
        payState.textColor = UIColor.titleColors(color: .darkGray)
        payState.font = UIFont.systemFont(ofSize: 12)
        payState.layer.cornerRadius = 2
        payState.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        payState.layer.borderWidth = 0.5
        payState.textAlignment = .center
        orderInfoBgView.addSubview(payState)
        
        quotePriceState.frame = CGRect(x: orderID.frame.minX, y: orderState.frame.maxY + 10 , width: 68, height: 21)
        quotePriceState.text = "未询价"
        quotePriceState.textColor = UIColor.titleColors(color: .darkGray)
        quotePriceState.font = UIFont.systemFont(ofSize: 12)
        quotePriceState.layer.cornerRadius = 2
        quotePriceState.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        quotePriceState.layer.borderWidth = 0.5
        quotePriceState.textAlignment = .center
        orderInfoBgView.addSubview(quotePriceState)
        
        designState.frame = CGRect(x: orderID.frame.minX + 80, y: orderState.frame.maxY + 10 , width: 68, height: 21)
        designState.text = "未设计"
        designState.textColor = UIColor.titleColors(color: .darkGray)
        designState.font = UIFont.systemFont(ofSize: 12)
        designState.layer.cornerRadius = 2
        designState.layer.borderColor = UIColor.titleColors(color: .lightGray).cgColor
        designState.layer.borderWidth = 0.5
        designState.textAlignment = .center
        orderInfoBgView.addSubview(designState)
        
        
        saveBtn.frame = CGRect(x: 10, y: kHight - 64 - heightChangeForiPhoneXFromBottom, width: kWidth - 20, height: 42)
        saveBtn.backgroundColor = UIColor.backgroundColors(color: .red)
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.layer.cornerRadius = 6
        saveBtn.addTarget(self, action: #selector(saveEditInfos), for: .touchUpInside)

        
        //表格中的cell
        //产品类别
        productTypeLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productTypeLabel.text = "产品类型:"
        productTypeLabel.textColor = UIColor.titleColors(color: .black)
        productTypeLabel.font = UIFont.systemFont(ofSize: 16)
        
        productTypeValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productTypeValue.text = "徽章"
        productTypeValue.textColor = UIColor.titleColors(color: .black)
        productTypeValue.font = UIFont.systemFont(ofSize: 16)
        
        //生产材质
        productMaterialLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productMaterialLabel.text = "产品材质:"
        productMaterialLabel.textColor = UIColor.titleColors(color: .black)
        productMaterialLabel.font = UIFont.systemFont(ofSize: 16)
        
        productMaterialValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productMaterialValue.text = "锌合金"
        productMaterialValue.textColor = UIColor.titleColors(color: .black)
        productMaterialValue.font = UIFont.systemFont(ofSize: 16)
        
        //生产配件
        productAccessoriesLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productAccessoriesLabel.text = "产品配件:"
        productAccessoriesLabel.textColor = UIColor.titleColors(color: .black)
        productAccessoriesLabel.font = UIFont.systemFont(ofSize: 16)
        
        productAccessoriesValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productAccessoriesValue.text = "蝴蝶扣"
        productAccessoriesValue.textColor = UIColor.titleColors(color: .black)
        productAccessoriesValue.font = UIFont.systemFont(ofSize: 16)
        
        //开模方式
        productMoldStyleLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productMoldStyleLabel.text = "开模方式:"
        productMoldStyleLabel.textColor = UIColor.titleColors(color: .black)
        productMoldStyleLabel.font = UIFont.systemFont(ofSize: 16)
        
        productMoldStyleValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productMoldStyleValue.text = "2D冲压"
        productMoldStyleValue.textColor = UIColor.titleColors(color: .black)
        productMoldStyleValue.font = UIFont.systemFont(ofSize: 16)
        
        //生产工艺
        productProduceStyleLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productProduceStyleLabel.text = "生产工艺:"
        productProduceStyleLabel.textColor = UIColor.titleColors(color: .black)
        productProduceStyleLabel.font = UIFont.systemFont(ofSize: 16)
        
        productProduceStyleValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productProduceStyleValue.text = "烤漆"
        productProduceStyleValue.textColor = UIColor.titleColors(color: .black)
        productProduceStyleValue.font = UIFont.systemFont(ofSize: 16)
        
        //电镀色
        productColorLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productColorLabel.text = "电 镀 色:"
        productColorLabel.textColor = UIColor.titleColors(color: .black)
        productColorLabel.font = UIFont.systemFont(ofSize: 16)
        
        productColorValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productColorValue.text = "金色"
        productColorValue.textColor = UIColor.titleColors(color: .black)
        productColorValue.font = UIFont.systemFont(ofSize: 16)
        
        //尺寸
        productSizeLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productSizeLabel.text = "长×宽×厚(mm):"
        productSizeLabel.textColor = UIColor.titleColors(color: .black)
        productSizeLabel.font = UIFont.systemFont(ofSize: 16)
        
        //尺寸
        productSizeValue.frame = CGRect(x: 150, y: 15, width: kWidth - 170, height: 22)
        productSizeValue.text = productLengthValue + "x" + productWidthValue + "x" + productHeightValue
        productSizeValue.textColor = UIColor.titleColors(color: .black)
        productSizeValue.font = UIFont.systemFont(ofSize: 16)

        
        //数量
        productAmountLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productAmountLabel.text = "数 量:"
        productAmountLabel.textColor = UIColor.titleColors(color: .black)
        productAmountLabel.font = UIFont.systemFont(ofSize: 16)
        
        productAmountValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productAmountValue.text = "0"
        productAmountValue.textAlignment = .left
        productAmountValue.backgroundColor = UIColor.backgroundColors(color: .white)
        productAmountValue.layer.cornerRadius = 4
        productAmountValue.delegate = self
        productAmountValue.keyboardType = .numberPad
        
        //数量
        productDeadLineLabel.frame = CGRect(x: 15, y: 15, width: 200, height: 22)
        productDeadLineLabel.text = "客户工期(天):"
        productDeadLineLabel.textColor = UIColor.titleColors(color: .black)
        productDeadLineLabel.font = UIFont.systemFont(ofSize: 16)
        
        productDeadLineValue.frame = CGRect(x: 125, y: 15, width: 200, height: 22)
        productDeadLineValue.text = "0"
        productDeadLineValue.textAlignment = .left
        productDeadLineValue.backgroundColor = UIColor.backgroundColors(color: .white)
        productDeadLineValue.layer.cornerRadius = 4
        productDeadLineValue.delegate = self
        productDeadLineValue.keyboardType = .numberPad
        
        //分割线
        seperateLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine3.image = UIImage(named: "dashlineimg")
        seperateLine4.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine5.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine6.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine7.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine8.backgroundColor = UIColor.lineColors(color: .lightGray)
        seperateLine9.backgroundColor = UIColor.lineColors(color: .lightGray)
    
        DispatchQueue.global().async {
            self.loadData()
        }
    }
    
    func loadData(){
        let orderInfoObjects = orderObject
        
        //下载订单图片
        if orderInfoObjects.value(forKey: "goodsimage") as? String == nil || orderInfoObjects.value(forKey: "goodsimage") as? String == ""{ // 图片字段为空
            DispatchQueue.main.async {
                self.orderImage.image = UIImage(named:"defualt-design-pic")
            }
        }else{
            let imageURLString:String = "\(self.downloadURLHeaderForThumbnail)\(orderInfoObjects.value(forKey: "goodsimage") as! String)"
            let url = URL(string: imageURLString)!
            do{
                let data = try Data.init(contentsOf: url)
                let image = UIImage.gif(data:data)
                DispatchQueue.main.async {
                    self.orderImage.image = image
                }
            }catch{
                let imageURLString:String = "\(self.downloadURLHeader)\(orderInfoObjects.value(forKey: "goodsimage") as! String)"
                let url = URL(string: imageURLString)!
                do{
                    let data = try Data.init(contentsOf: url)
                    let image = UIImage.gif(data:data)
                    DispatchQueue.main.async {
                        self.orderImage.image = image
                    }
                }catch{
                    print(error)
                    DispatchQueue.main.async {
                        self.orderImage.image = UIImage(named:"defualt-design-pic")
                    }
                }
                print("无缩略图")
            }
        }
        //更新订单号
        DispatchQueue.main.async {
            guard orderInfoObjects != nil else{
                greyLayerPrompt.show(text: "订单异常,请联系管理员")
                return
            }
            
            self.customIDValue = orderInfoObjects.value(forKey: "customid") as! String
            self.orderIDValue = orderInfoObjects.value(forKey: "orderid") as! String
            self.orderID.text = "订单号: \(self.orderIDValue)"
            
            //状态Object
            let statusObjects = self.systemParam[1] as! NSDictionary
            //产品参数Object
            let productObjets = self.systemParam[0] as! NSDictionary
            
            //设置订单状态
            if (orderInfoObjects.value(forKey: "produceStatus") as! Int) == 0 {
                self.orderState.text = "咨询中"
            }else if (orderInfoObjects.value(forKey: "produceStatus") as! Int) == 1{
                self.orderState.text = "待分配生产"
            }else{
                let statusCode = orderInfoObjects.value(forKey: "produceStatus") as! Int
                self.orderState.text = "\(((statusObjects.value(forKey: "produceStatus") as! NSArray)[statusCode - 1] as! NSDictionary).value(forKey: "servicerTag") as! String)"
            }
            
            //设置设计状态
            let designStatusCode = orderInfoObjects.value(forKey: "designStatus") as! Int
            self.designState.text = "\(((statusObjects.value(forKey: "designStatus") as! NSArray)[designStatusCode - 1] as! NSDictionary).value(forKey: "servicerTag") as! String)"

            //设置询价状态
            let inquiryStatusCode = orderInfoObjects.value(forKey: "inquiryStatus") as! Int
            self.quotePriceState.text = "\(((statusObjects.value(forKey: "inquiryStatus") as! NSArray)[inquiryStatusCode - 1] as! NSDictionary).value(forKey: "servicerTag") as! String)"
            
            //设置支付状态
            if inquiryStatusCode == 6{
                self.payState.text = "已支付"
            }else{
                self.payState.text = "未支付"
            }
            
            if (orderInfoObjects.value(forKey: "userPeriod") as? Int) == nil {
                self.productDeadLineValue.text = "0"
            }else{
                self.productDeadLineValue.text = "\(orderInfoObjects.value(forKey: "userPeriod") as! Int)"
            }
            
            //产品类型
            self.old_productType_ID = orderInfoObjects.value(forKey: "goodsClass") as! String
            self.old_productType = ((productObjets.value(forKey: "goodsClass") as! NSArray)[Int(self.old_produceStyle_ID)! - 1] as! NSDictionary).value(forKey: "goodsClass") as! String
            self.productTypeValue.text = self.old_productType
            //材质
            self.old_material_ID = orderInfoObjects.value(forKey: "material") as! String
            self.old_material = ((productObjets.value(forKey: "material") as! NSArray)[Int(self.old_material_ID)! - 1] as! NSDictionary).value(forKey: "material") as! String
            self.productMaterialValue.text = self.old_material
           //配件
            self.old_accessories_ID = orderInfoObjects.value(forKey: "accessories") as! String
            self.old_accessories = ((productObjets.value(forKey: "accessories") as! NSArray)[Int(self.old_accessories_ID)! - 1] as! NSDictionary).value(forKey: "accessories") as! String
            self.productAccessoriesValue.text = self.old_accessories
            //开模方式
            self.old_modal_ID = orderInfoObjects.value(forKey: "model") as! String
            let old_model_IDArray = self.old_modal_ID.split(separator: ",")
            for item in old_model_IDArray{
                self.old_modal += ((productObjets.value(forKey: "model") as! NSArray)[Int(item)! - 1] as! NSDictionary).value(forKey: "model") as! String
            }
            self.productMoldStyleValue.text = self.old_modal
            //工艺
            self.old_produceStyle_ID = orderInfoObjects.value(forKey: "technology") as! String
            let old_produceStyle_IDArray = self.old_produceStyle_ID.split(separator: ",")
            for item in old_produceStyle_IDArray{
                self.old_produceStyle += ((productObjets.value(forKey: "technology") as! NSArray)[Int(item)! - 1] as! NSDictionary).value(forKey: "technology") as! String
            }
            self.productProduceStyleValue.text = self.old_produceStyle
            //颜色
            self.old_color_ID = orderInfoObjects.value(forKey: "color") as! String
            let old_color_IDArray = self.old_color_ID.split(separator: ",")
            for item in old_color_IDArray{
                self.old_color += ((productObjets.value(forKey: "color") as! NSArray)[Int(item)! - 1] as! NSDictionary).value(forKey: "color") as! String
            }
            self.productColorValue.text = self.old_color
            
            //数量
            self.old_amount = orderInfoObjects.value(forKey: "number") as! Int
            self.productAmountValue.text = "\(self.old_amount)"
            
            if (orderInfoObjects.value(forKey: "deadline") as? Int) == nil {
                self.old_deadline = "0"
            }else{
                self.old_deadline = String(orderInfoObjects.value(forKey: "deadline") as! Int)
            }
            
//            self.old_length = String((goodsInfoObject.value(forKey: "size") as! NSDictionary).value(forKey: "length") as! Double)
//            self.productLengthValue = self.old_length
//
//            self.old_width = String((goodsInfoObject.value(forKey: "size") as! NSDictionary).value(forKey: "width") as! Double)
//            self.productWidthValue = self.old_width
//
//            self.old_height = String((goodsInfoObject.value(forKey: "size") as! NSDictionary).value(forKey: "height") as! Double)
//            self.productHeightValue = self.old_height
            
            self.productSizeValue.text = "\(self.productLengthValue)x\(self.productWidthValue)x\(self.productHeightValue)"
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //自定义键盘按钮
        let topView = UIToolbar()
        topView.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(hideKeyBoard))
        let buttonsArray = [flexSpace,doneBtn]
        topView.items = buttonsArray
        topView.sizeToFit()
        
        textField.inputAccessoryView = topView
        if textField.text == "0"{
            textField.text = ""
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == ""{
            textField.text = "0"
        }
    }
    
    @objc func hideKeyBoard(){
        productAmountValue.resignFirstResponder()
        productDeadLineValue.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QuotePriceTableViewCell.customCell(tableView: editOrderParasTable)
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.contentView.addSubview(productTypeLabel)
            cell.contentView.addSubview(productTypeValue)
            cell.contentView.addSubview(ProductTypePicker)
            return cell
        case 1:
            cell.contentView.addSubview(productMaterialLabel)
            cell.contentView.addSubview(productMaterialValue)
            cell.contentView.addSubview(seperateLine1)
            cell.contentView.addSubview(ProductMaterialPicker)
            return cell
        case 2:
            cell.contentView.addSubview(productAccessoriesLabel)
            cell.contentView.addSubview(productAccessoriesValue)
            cell.contentView.addSubview(seperateLine2)
            cell.contentView.addSubview(ProductAccessoriesPicker)
            return cell
        case 3:
            cell.contentView.addSubview(productMoldStyleLabel)
            cell.contentView.addSubview(productMoldStyleValue)
            cell.contentView.addSubview(seperateLine3)
            return cell
        case 4:
            cell.contentView.addSubview(productProduceStyleLabel)
            cell.contentView.addSubview(productProduceStyleValue)
            cell.contentView.addSubview(seperateLine4)
            return cell
        case 5:
            cell.contentView.addSubview(productColorLabel)
            cell.contentView.addSubview(productColorValue)
            cell.contentView.addSubview(seperateLine5)
            return cell
        case 6:
            cell.contentView.addSubview(seperateLine6)
            cell.contentView.addSubview(productAmountLabel)
            cell.contentView.addSubview(productAmountValue)
            return cell
        case 7:
            cell.contentView.addSubview(seperateLine7)
            cell.contentView.addSubview(productDeadLineLabel)
            cell.contentView.addSubview(productDeadLineValue)
            return cell
        case 8:
            cell.contentView.addSubview(seperateLine8)
            cell.contentView.addSubview(productSizeLabel)
            cell.contentView.addSubview(productSizeValue)
            
            rightArrow.image = UIImage(named: "right-arrow")
            cell.contentView.addSubview(rightArrow)
            cell.contentView.addSubview(seperateLine9)
            return cell
        default:
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0,1,2:
            if indexPath.row == 2{
            }
            var tempHeight:CGFloat = 52.0
            if indexPath.row == 0 && isProductTypeExpand {
                tempHeight = 130.0 + 52.0
            }else if indexPath.row == 1 && isProductMaterialExpand {
                tempHeight = 130.0 + 52.0
            }else if indexPath.row == 2 && isProductAccessoriesExpand{
                tempHeight = 130.0 + 52.0
            }else{
                if indexPath.row == 2{
                    tempHeight = 2.0 + 52.0
                }
            }
            // print("\(indexPath.row) height = \(tempHeight)")
            return tempHeight
        case 3,4,5,6,7:
            return 52.0
        case 8:
            return 53.0
        default:
            return 52.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProductAccessoriesPicker.isHidden = true
        ProductMaterialPicker.isHidden = true
        ProductTypePicker.isHidden = true
        switch indexPath.row {
        case 0:
            //更改展开状态
            isProductTypeExpand = !isProductTypeExpand
            isProductMaterialExpand = false
            isProductAccessoriesExpand = false
            if isProductTypeExpand{
                ProductTypePicker.isHidden = false
            }
            
            productAmountValue.resignFirstResponder()
        case 1:
            //更改展开状态
            isProductMaterialExpand = !isProductMaterialExpand
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            if isProductMaterialExpand{
                ProductMaterialPicker.isHidden = false
            }
            
            productAmountValue.resignFirstResponder()
        case 2:
            //更改展开状态
            isProductAccessoriesExpand = !isProductAccessoriesExpand
            isProductTypeExpand = false
            isProductMaterialExpand = false
            if isProductAccessoriesExpand{
                ProductAccessoriesPicker.isHidden = false
            }
        
            productAmountValue.resignFirstResponder()
        case 3:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            print("3 pressed")
       
            productAmountValue.resignFirstResponder()
            //定义参数弹出层
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            
            popVC.modalPresentationCapturesStatusBarAppearance = true
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            
            let ParasView = ParasActionView(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 106),paraDic:ProductParams[3],paraCount:ProductParams[3].count,seleItems:moldSelectedItems,itemType:.mold)
            ParasView.titleOfView.text = "开模方式"
            ParasView.popupVC = popVC
            ParasView.editOrderParasVC = self
            ParasView.sourceVC = .editOrder
            popVC.view.addSubview(ParasView)
            self.present(popVC, animated: true, completion: nil)
        case 4:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            print("4 pressed")

            productAmountValue.resignFirstResponder()
            //定义参数弹出层
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            let ParasView = ParasActionView(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 106),paraDic:ProductParams[4],paraCount:ProductParams[4].count,seleItems:produceStyleSelectedItems,itemType:.produceStyle)
            ParasView.titleOfView.text = "生产工艺"
            ParasView.popupVC = popVC
            ParasView.editOrderParasVC = self
            ParasView.sourceVC = .editOrder
            popVC.view.addSubview(ParasView)
            self.present(popVC, animated: true, completion: nil)
        case 5:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            print("5 pressed")
            
            productAmountValue.resignFirstResponder()
            
            //定义参数弹出层
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            
            popVC.modalPresentationCapturesStatusBarAppearance = true
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            let ParasView = ParasActionView(frame: CGRect(x: 0, y: 86, width: kWidth, height: kHight + 106),paraDic:ProductParams[5],paraCount:ProductParams[5].count,seleItems:colorSelectedItems,itemType:.color)
            ParasView.titleOfView.text = "电镀色"
            ParasView.popupVC = popVC
            ParasView.editOrderParasVC = self
            ParasView.sourceVC = .editOrder
            popVC.view.addSubview(ParasView)
            self.present(popVC, animated: true, completion: nil)
        case 6:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            print("Pressed 6,7 and doing nothing")
        case 7:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            print("Pressed 6,7 and doing nothing")
        case 8:
            isProductTypeExpand = false
            isProductAccessoriesExpand = false
            isProductMaterialExpand = false
            
            //定义参数弹出层
            let popVC = PopupViewController()
            popVC.view.backgroundColor = UIColor.clear
            popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            let ParasView = ParasActionView(frame: CGRect(x: 0, y: kHight - 459 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 459 + heightChangeForiPhoneXFromBottom),paraDic:ProductParams[4],paraCount:ProductParams[4].count,seleItems:produceStyleSelectedItems,itemType:.size)
            ParasView.titleOfView.text = "尺寸"
            ParasView.popupVC = popVC
            ParasView.editOrderParasVC = self
            ParasView.sourceVC = .editOrder
            ParasView.lengthValue.text = productLengthValue
            ParasView.widthValue.text = productWidthValue
            ParasView.heightValue.text = productHeightValue
            popVC.view.addSubview(ParasView)
            self.present(popVC, animated: true, completion: nil)
            
            
        default:
            print("defualt")
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case ProductTypePicker:
            return parasCounts[0]
        case ProductMaterialPicker:
            return parasCounts[1]
        case ProductAccessoriesPicker:
            return parasCounts[2]
        default:
            return 10
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16)
            pickerLabel?.textAlignment = .center
            switch pickerView {
            case ProductTypePicker:
                let productItems = ProductParams[0]
                pickerLabel?.text = productItems[row].value(forKey: "goodsClass") as! String
            case ProductMaterialPicker:
                
                let productItems = ProductParams[1]
                pickerLabel?.text = productItems[row].value(forKey: "material") as! String
            case ProductAccessoriesPicker:
                
                let productItems = ProductParams[2]
                pickerLabel?.text = productItems[row].value(forKey: "accessories") as! String
            default:
                pickerLabel?.text = String(row)
            }
        }
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case ProductTypePicker:
            let productItems = ProductParams[0]
            productTypeValue.text = productItems[row].value(forKey: "goodsClass") as! String
            new_productType = productItems[row].value(forKey: "goodsClass") as! String
            new_productType_ID = String(productItems[row].value(forKey: "id") as! Int)
        case ProductMaterialPicker:
            let productItems = ProductParams[1]
            productMaterialValue.text = productItems[row].value(forKey: "material") as! String
            new_material = productItems[row].value(forKey: "material") as! String
            new_material_ID = String(productItems[row].value(forKey: "id") as! Int)
        case ProductAccessoriesPicker:
            let productItems = ProductParams[2]
            productAccessoriesValue.text = productItems[row].value(forKey: "accessories") as! String
            new_accessories = productItems[row].value(forKey: "accessories") as! String
            new_accessories_ID = String(productItems[row].value(forKey: "id") as! Int)
        default:
            print("something was wrong")
        }
        // pickerView.selectRow(row, inComponent: 0, animated: true)
//        updatePrice()
    }
    
    func updateParams(){
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
        params["wCustomid"] = customIDValue
        params["orderid"] = orderIDValue
        params["number"] = new_amount// productAmountValue.text as! String //orderID
        params["goodsClass"] = new_productType // productTypeValue.text as! String// customID
        params["material"] = new_material//productMaterialValue.text as! String
        params["length"] = new_length
        params["width"] = new_width
        params["height"] = new_height
        params["color"] = new_color// productColorValue.text as! String
        params["model"] = new_modal//productMoldStyleValue.text as! String
        params["technology"] = new_produceStyle//productProduceStyleValue.text as! String
        params["userPeriod"] = new_deadline
       // params["length"] = productLengthValue.text as! String
      //  params["width"] = productWidthValue.text as! String
     //   params["height"] = productHeightValue.text as! String
        params["accessories"] = new_accessories//productAccessoriesValue.text as! String
//        params["customerWang"] =
//        params["shop"] =
      //  params["isContinueOrder"] =

        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "updateOrderInfoAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "updateOrderInfoAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusObject = json["status","code"].string!
                    if statusObject == "0"{
                       greyLayerPrompt.show(text: "订单更新成功")
                        //self.closeActionView()
                    }else{
                        
                        let errorMsg = json["status","msg"].string!
                        print("更新订单失败，msg:\(errorMsg)")
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "更新订单失败")
            }
        }
        print("更新订单")
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saveEditInfos(){
        print("Save button clicked")
        
        guard productAmountValue.text != nil && productAmountValue.text != "" && productAmountValue.text != "0" else {
            greyLayerPrompt.show(text: "产品数量不合法,请检查后再继续")
            return
        }
        
        setStatusBarHiden(toHidden: true, ViewController: self)
        //setStatusBarBackgroundColor(color: UIColor.clear)
        
        
        //let Appdelegate = UIApplication.shared.delegate as! AppDelegate
       // let window = UIApplication.shared.keyWindow!
        //let window = UIWindow.init(frame: UIScreen.main.bounds)
//
//        let winodw:UIWindow?
//        window.frame = UIScreen.main.bounds
//        window.windowLevel = UIWindowLevelAlert - 1
//        window.makeKeyAndVisible()
//        window.backgroundColor = UIColor.red
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window = window
        
        grayLayer.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.7)
        //grayLayer.frame = CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height)
        self.view.addSubview(grayLayer)
      //  window.bringSubview(toFront: grayLayer)
       // Appdelegate.window?.bringSubview(toFront: grayLayer)
        
        
        
        //设置保存预览页面
        savePreviewBG.frame = CGRect(x: 0, y: 45 + heightChangeForiPhoneXFromTop, width: kWidth , height: 480/335 * (kWidth))
        savePreviewBG.image = UIImage(named: "savepreviewbgimg")
        savePreviewBG.isUserInteractionEnabled = true
        
        let closeBtnOfSavePreview:UIButton = UIButton.init(type: .custom)
        closeBtnOfSavePreview.setImage(UIImage(named: "closeofsavepreimg"), for: .normal)
        closeBtnOfSavePreview.frame = CGRect(x: (kWidth - 28)/2, y: savePreviewBG.frame.maxY + 10, width: 28, height: 28)
        closeBtnOfSavePreview.addTarget(self, action: #selector(closeLayerClicked), for: .touchUpInside)
        
        grayLayer.addSubview(blurView)
        blurView.contentView.addSubview(closeBtnOfSavePreview)
        
        blurView.contentView.addSubview(savePreviewBG)
        
        //设置保存页面UI
        ProductType_Old.frame = CGRect(x: 45, y: savePreviewBG.frame.height * 77/480, width: 200, height: 20)
        ProductAmount_Old.frame = CGRect(x: savePreviewBG.frame.width - 245, y: savePreviewBG.frame.height * 77/480, width: 200, height: 20)
        ProductMatarialAndAccessories_Old.frame = CGRect(x: 45, y: ProductType_Old.frame.maxY + 5, width: 200, height: 20)
        ProductDeadline_Old.frame = CGRect(x: savePreviewBG.frame.width - 245, y: ProductType_Old.frame.maxY + 5, width: 200, height: 20)
        ProductProduceParas_Old.frame = CGRect(x: 45, y: ProductMatarialAndAccessories_Old.frame.maxY + 5, width: savePreviewBG.frame.width - 90, height: 20)
        beforeChangeLabel.frame = CGRect(x: 25, y: 50, width: savePreviewBG.frame.width - 50, height: 22)
        beforeChangeLabel.text = "更改前"
        beforeChangeLabel.textAlignment = .center
        beforeChangeLabel.textColor = UIColor.titleColors(color: .black)
        beforeChangeLabel.font = UIFont.systemFont(ofSize: 18)
        
        ProductType_Old.text = old_productType
        ProductType_Old.font = UIFont.systemFont(ofSize: 16)
        ProductType_Old.textColor = UIColor.titleColors(color: .black)
        ProductType_Old.textAlignment = .left
        
        ProductAmount_Old.text = "x\(old_amount)"
        ProductAmount_Old.font = UIFont.systemFont(ofSize: 16)
        ProductAmount_Old.textColor = UIColor.titleColors(color: .black)
        ProductAmount_Old.textAlignment = .right
        
        ProductDeadline_Old.text = "\(old_deadline)天"
        ProductDeadline_Old.font = UIFont.systemFont(ofSize: 16)
        ProductDeadline_Old.textColor = UIColor.titleColors(color: .black)
        ProductDeadline_Old.textAlignment = .right
        
        
        ProductMatarialAndAccessories_Old.text = old_material + " " + old_accessories
        ProductMatarialAndAccessories_Old.font = UIFont.systemFont(ofSize: 16)
        ProductMatarialAndAccessories_Old.textColor = UIColor.titleColors(color: .darkGray)
        ProductMatarialAndAccessories_Old.textAlignment = .left
        
        ProductProduceParas_Old.text = old_modal + old_produceStyle + old_color
        ProductProduceParas_Old.font = UIFont.systemFont(ofSize: 16)
        ProductProduceParas_Old.textColor = UIColor.titleColors(color: .darkGray)
        ProductProduceParas_Old.textAlignment = .left
        ProductProduceParas_Old.numberOfLines = 3
        let heightOfLabel = calculateLabelHeightWithText(with: ProductProduceParas_Old.text!, labelWidth: ProductProduceParas_Old.frame.width, textFont: UIFont.systemFont(ofSize: 16))
        ProductProduceParas_Old.frame = CGRect(x: 45, y: ProductMatarialAndAccessories_Old.frame.maxY + 5, width: savePreviewBG.frame.width - 90, height: heightOfLabel)
        
        ProductSize_Old.text = "\(old_length)x\(old_width)x\(old_height)(mm)"
        ProductSize_Old.font = UIFont.systemFont(ofSize: 16)
        ProductSize_Old.textColor = UIColor.titleColors(color: .darkGray)
        ProductSize_Old.textAlignment = .left
        ProductSize_Old.frame = CGRect(x: 45, y: ProductProduceParas_Old.frame.maxY + 5, width: 200, height: 20)
        
        savePreviewBG.addSubview(ProductType_Old)
        savePreviewBG.addSubview(ProductAmount_Old)
        savePreviewBG.addSubview(ProductMatarialAndAccessories_Old)
        savePreviewBG.addSubview(ProductProduceParas_Old)
        savePreviewBG.addSubview(ProductSize_Old)
        savePreviewBG.addSubview(beforeChangeLabel)
        
        // 更换后
        ProductType_New.frame = CGRect(x: 45, y: savePreviewBG.frame.height * 285/480 , width: 200, height: 20)
        ProductAmount_New.frame = CGRect(x: savePreviewBG.frame.width - 245, y: savePreviewBG.frame.height * 285/480, width: 200, height: 20)
        ProductMatarialAndAccessories_New.frame = CGRect(x: 45, y: ProductType_New.frame.maxY + 5, width: 200, height: 20)
        ProductDeadline_New.frame = CGRect(x: savePreviewBG.frame.width - 245, y: ProductType_New.frame.maxY + 5, width: 200, height: 20)
        afterChangeIcon.frame = CGRect(x: (savePreviewBG.frame.width - 76)/2, y: savePreviewBG.frame.height * 245/480, width: 18, height: 18)
        afterChangeIcon.image = UIImage(named: "changedimg")
        afterChangeLabel.frame = CGRect(x: afterChangeIcon.frame.maxX + 10, y: afterChangeIcon.frame.minY - 4, width: 200, height: 22)
        afterChangeLabel.text = "更改后"
        afterChangeLabel.textAlignment = .left
        afterChangeLabel.textColor = UIColor.titleColors(color: .black)
        afterChangeLabel.font = UIFont.systemFont(ofSize: 18)
        
        new_productType = productTypeValue.text!
        
        if new_productType != old_productType{
            ProductType_New.textColor = UIColor.titleColors(color: .red)
        }else{
            ProductType_New.textColor = UIColor.titleColors(color: .black)
        }
        ProductType_New.text = new_productType
        ProductType_New.font = UIFont.systemFont(ofSize: 16)
        ProductType_New.textAlignment = .left
        
        new_amount = Int(productAmountValue.text!)!
        if new_amount != old_amount{
            ProductAmount_New.textColor = UIColor.titleColors(color: .red)
        }else{
            ProductAmount_New.textColor = UIColor.titleColors(color: .black)
        }
        
        ProductAmount_New.text = "x\(new_amount)"
        ProductAmount_New.font = UIFont.systemFont(ofSize: 16)
        ProductAmount_New.textAlignment = .right
        
        new_deadline = productDeadLineValue.text!
        ProductDeadline_New.text = "\(new_deadline)天"
        ProductDeadline_New.font = UIFont.systemFont(ofSize: 16)
        ProductDeadline_New.textAlignment = .right
        
        new_material = productMaterialValue.text!
        new_accessories = productAccessoriesValue.text!
        
        if new_material != old_material{
            if new_accessories != old_accessories{
                ProductMatarialAndAccessories_New.text = new_material + " " + new_accessories
                ProductMatarialAndAccessories_New.textColor = UIColor.titleColors(color: .red)
            }else{
                let AttrubuteStringOfMaterail = NSAttributedString(string: new_material + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                let AttrubuteStringOfAccessory = NSAttributedString(string: new_accessories, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                
                let MultableAttrubuteStringOfMaterail = NSMutableAttributedString(attributedString: AttrubuteStringOfMaterail)
                MultableAttrubuteStringOfMaterail.append(AttrubuteStringOfAccessory)
                
                ProductMatarialAndAccessories_New.attributedText = MultableAttrubuteStringOfMaterail
            }
        }else{
            if new_accessories != old_accessories{
                let AttrubuteStringOfMaterail = NSAttributedString(string: new_material + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                let AttrubuteStringOfAccessory = NSAttributedString(string: new_accessories, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                
                let MultableAttrubuteStringOfMaterail = NSMutableAttributedString(attributedString: AttrubuteStringOfMaterail)
                MultableAttrubuteStringOfMaterail.append(AttrubuteStringOfAccessory)
                
                ProductMatarialAndAccessories_New.attributedText = MultableAttrubuteStringOfMaterail
            }else{
                ProductMatarialAndAccessories_New.text = new_material + " " + new_accessories
                ProductMatarialAndAccessories_New.textColor = UIColor.titleColors(color: .darkGray)
            }
        }
        
        ProductMatarialAndAccessories_New.font = UIFont.systemFont(ofSize: 16)
        ProductMatarialAndAccessories_New.textAlignment = .left
        
        new_modal = productMoldStyleValue.text!
        new_produceStyle = productProduceStyleValue.text!
        new_color = productColorValue.text!
        
        if new_deadline != old_deadline{
            ProductDeadline_New.textColor = UIColor.titleColors(color: .red)
        }else{
            ProductDeadline_New.textColor = UIColor.titleColors(color: .darkGray)
        }
        
        if new_modal != old_modal{
            if new_produceStyle != old_produceStyle{
                if new_color != old_color{
                    ProductProduceParas_New.text = new_material + " " + new_accessories
                    ProductProduceParas_New.textColor = UIColor.titleColors(color: .red)
                }else{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }
                
            }else{
                if new_color != old_color{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }else{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }
            }
        }else{
            if new_produceStyle != old_produceStyle{
                if new_color != old_color{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }else{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }
                
            }else{
                if new_color != old_color{
                    let AttrubuteStringOfModal = NSAttributedString(string: new_modal + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfProduceStyle = NSAttributedString(string: new_produceStyle + " ", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfColor = NSAttributedString(string: new_color, attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOfModal)
                    MultableAttrubuteString.append(AttrubuteStringOfProduceStyle)
                    MultableAttrubuteString.append(AttrubuteStringOfColor)
                    
                    ProductProduceParas_New.attributedText = MultableAttrubuteString
                }else{
                    ProductProduceParas_New.text = new_modal + new_produceStyle + new_color
                    ProductProduceParas_New.textColor = UIColor.titleColors(color: .darkGray)
                }
                
            }
            
        }
        
        ProductProduceParas_New.font = UIFont.systemFont(ofSize: 16)
        ProductProduceParas_New.textAlignment = .left
        ProductProduceParas_New.numberOfLines = 3
        
        let heightOfLabelNew = calculateLabelHeightWithText(with: new_modal + new_produceStyle + new_color, labelWidth: ProductProduceParas_New.frame.width, textFont: UIFont.systemFont(ofSize: 16))
        ProductProduceParas_New.frame = CGRect(x: 45, y: ProductMatarialAndAccessories_New.frame.maxY + 5, width: savePreviewBG.frame.width - 90, height: heightOfLabelNew)
        
        new_length = productLengthValue
        new_width = productWidthValue
        new_height = productHeightValue
        
        if new_length != old_length{
            if new_width != old_width{
                if new_height != old_height{
                    ProductSize_New.text = "\(new_length)x\(new_width)x\(new_height)(mm)"
                    ProductSize_New.textColor = UIColor.titleColors(color: .red)
                }else{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }
            }else{
                if new_height != old_height{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }else{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }
            }
        }else{
            if new_width != old_width{
                if new_height != old_height{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }else{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }
            }else{
                if new_height != old_height{
                    let AttrubuteStringOLength = NSAttributedString(string: new_length + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfWidth = NSAttributedString(string: new_width + "x", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .darkGray)])
                    let AttrubuteStringOfHeight = NSAttributedString(string: new_height + "(mm)", attributes: [NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red)])
                    
                    let MultableAttrubuteString = NSMutableAttributedString(attributedString: AttrubuteStringOLength)
                    MultableAttrubuteString.append(AttrubuteStringOfWidth)
                    MultableAttrubuteString.append(AttrubuteStringOfHeight)
                    
                    ProductSize_New.attributedText = MultableAttrubuteString
                }else{
                    ProductSize_New.text = "\(new_length)x\(new_width)x\(new_height)(mm)"
                    ProductSize_New.textColor = UIColor.titleColors(color: .darkGray)
                }
            }
        }
        
        confirmSaveBtn.frame = CGRect(x: 35, y: savePreviewBG.frame.height - 77, width: savePreviewBG.frame.width - 70, height: 42)
        confirmSaveBtn.setTitle("确认", for: .normal)
        confirmSaveBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        confirmSaveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmSaveBtn.layer.cornerRadius = 6
        confirmSaveBtn.layer.masksToBounds = true
        confirmSaveBtn.setBackgroundImage(UIImage(named: "saveconfirmbgimg"), for: .normal)
        confirmSaveBtn.addTarget(self, action: #selector(confirmSaveClicked), for: .touchUpInside)
        
        savePreviewBG.addSubview(confirmSaveBtn)
        
        ProductSize_New.font = UIFont.systemFont(ofSize: 16)
        ProductSize_New.textAlignment = .left
        ProductSize_New.frame = CGRect(x: 45, y: ProductProduceParas_New.frame.maxY + 5, width: 200, height: 20)
        
        savePreviewBG.addSubview(ProductType_New)
        savePreviewBG.addSubview(ProductAmount_New)
        savePreviewBG.addSubview(ProductMatarialAndAccessories_New)
        savePreviewBG.addSubview(ProductProduceParas_New)
        savePreviewBG.addSubview(ProductSize_New)
        savePreviewBG.addSubview(afterChangeLabel)
        savePreviewBG.addSubview(afterChangeIcon)
        savePreviewBG.addSubview(ProductDeadline_New)
        savePreviewBG.addSubview(ProductDeadline_Old)
    }
    
    @objc func taxRadioBtnClicked(){
        //定义参数弹出层
        let popVC = PopupViewController()
        popVC.view.backgroundColor = UIColor.clear
        popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        popVC.view.addSubview(popVC.grayLayer)
        
        popVC.modalPresentationCapturesStatusBarAppearance = true
        popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
        
        let ParasView = ParasActionView(frame: CGRect(x: 0, y: kHight - 277 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 277 + heightChangeForiPhoneXFromBottom),paraDic:ProductParams[3],paraCount:ProductParams[3].count,seleItems:moldSelectedItems,itemType:produceType.taxRadio)
        ParasView.titleOfView.text = "选择税率"
        ParasView.popupVC = popVC
        ParasView.editOrderParasVC = self
        popVC.view.addSubview(ParasView)
        self.present(popVC, animated: true, completion: nil)
    }
    
    @objc func closeLayerClicked(){
    
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window = keywindow

        setStatusBarHiden(toHidden: false, ViewController: self)
        grayLayer.removeFromSuperview()
    }
    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        UIView.animate(withDuration: duration) {
            self.editOrderParasTable.transform = CGAffineTransform(translationX: 0, y: -240)
        }
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_notification: Notification){
        
        let kbInfo = _notification.userInfo
        /*
         swift2.3正常，swift3.0取值为nil
         */
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        UIView.animate(withDuration: duration) {
            self.editOrderParasTable.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        
    }
    func setupSelectedItems(){
//        moldSelectedItems.removeAll()
//        produceStyleSelectedItems.removeAll()
//        colorSelectedItems.removeAll()
//        for item in ProductParams[3]{ // 开模方式
//            if (productMoldStyleValue.text?.contains(item))!{
//                moldSelectedItems.append(item)
//            }
//        }
//        for item in ProductParams[4]{ // 生产工艺
//            if (productProduceStyleValue.text?.contains(item))!{
//                produceStyleSelectedItems.append(item)
//            }
//        }
//        for item in ProductParams[5]{ // 电镀色
//            if (productColorValue.text?.contains(item))!{
//                colorSelectedItems.append(item)
//            }
//        }
        
    }
    
    @objc func confirmSaveClicked(){
        print("提交更新")
        updateParams()
        setStatusBarHiden(toHidden: false, ViewController: self)
        cancelBtnClicked()
        orderVCObject.searchBarCancelButtonClicked()
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
