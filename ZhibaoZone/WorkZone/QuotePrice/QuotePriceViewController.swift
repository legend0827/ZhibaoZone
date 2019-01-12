//
//  QuotePriceViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class QuotePriceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
   
   // 产品参数字典
    var ProductParams:[[NSDictionary]] = [[]]
    var parasCounts:[Int] = []
    
    //开模方式选中项
    var moldSelectedItems:[String] = []
    //生产工艺选中项
    var produceStyleSelectedItems:[String] = []
    //电镀色选中项目
    var colorSelectedItems:[String] = []
    
    //含税不含税的图标
    let taxLabelView:UIImageView = UIImageView.init()
    //报价金额
    let currentPriceLabel:UILabel = UILabel.init()
    let updatingPriceLabel:UILabel = UILabel.init()
    
    //开发票
    let payTaxBtn:UIButton = UIButton.init(type: .custom)
    let payTaxcheckBoxBtn:UIButton = UIButton.init(type: .custom)
    //不开发票
    let payWithoutTaxBtn:UIButton = UIButton.init(type: .custom)
    let payWithoutTaxcheckBoxBtn:UIButton = UIButton.init(type: .custom)
    
    //是否开发票
    var payTaxStatus:Bool = false
    //税率
    let taxRadioBtn:UIButton = UIButton.init(type: .custom)
    var taxRadioValue:Float = 0.0
    
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    
    //产品类型
    let productTypeLabel:UILabel = UILabel.init()
    let productTypeValue:UILabel = UILabel.init()
    var productTypeValueID:String = ""
    
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
    var productMaterialValueID:String = ""
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
    var productAccessoriesValueID:String = ""

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
    var productMoldStyleValueID:String = ""
    //生产工艺
    let productProduceStyleLabel:UILabel = UILabel.init()
    let productProduceStyleValue:UILabel = UILabel.init()
    var productProduceStyleID:String = ""
    //电镀色
    let productColorLabel:UILabel = UILabel.init()
    let productColorValue:UILabel = UILabel.init()
    var productColorValueID:String = ""
    //尺寸
    let productSizeLabel:UILabel = UILabel.init()
    let productSizeValue:UILabel = UILabel.init()
    var productLengthValue:String = "30.0"
    var productWidthValue:String = "30.0"
    var productHeightValue:String = "2.0"
//    let productLengthValue:UITextField = UITextField.init()
//    let productWidthValue:UITextField = UITextField.init()
//    let productHeightValue:UITextField = UITextField.init()
//    let byLabel1:UILabel = UILabel.init()
//    let byLabel2:UILabel = UILabel.init()
    //数量
    let productAmountLabel:UILabel = UILabel.init()
    let productAmountValue:UITextField = UITextField.init()
    
    //分割线
    let seperateLine1:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine2:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine3:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 1))
    let seperateLine4:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine5:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.5))
    let seperateLine6:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30 , height: 0.5))
    let seperateLine7:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30 , height: 0.5))
    let seperateLine8:UIView = UIView.init(frame: CGRect(x: 15, y: 52, width: kWidth - 30 , height: 0.5))
    
    //判断cell是否展开
    var isProductTypeExpand = false
    var isProductMaterialExpand = false
    var isProductAccessoriesExpand = false
    
    lazy var quotePriceParasTable:UITableView = {
        let tempTableView = UITableView(frame: CGRect(x: 0, y: 186 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 206 - heightChangeForiPhoneXFromTop), style: UITableViewStyle.grouped)
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
        
        //setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        super.viewDidLoad()
        systemParam = getSystemParasFromPlist()
        setupUI()
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
        //设置初始值
        productTypeValueID = String(productDicInArray[0].value(forKey: "id") as! Int)
        productMaterialValueID = String(productDicInArray[1].value(forKey: "id") as! Int)
        productAccessoriesValueID = String(productDicInArray[2].value(forKey: "id") as! Int)
        setupSelectedItems()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
        systemParam = getSystemParasFromPlist()
        setupUI()
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
        
        setupSelectedItems()
    }
    
    private func setupUI(){
        
        //背景颜色
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //检车设备
        if UIDevice.current.isX(){
            heightChangeForiPhoneXFromTop = 24.0
        }else{
            heightChangeForiPhoneXFromTop = 0.0
        }
        //报价下的窗口
        let redBGView:UIView = UIView.init(frame: CGRect(x: 0, y:0, width: kWidth, height: 89+heightChangeForiPhoneXFromTop))
        redBGView.backgroundColor = UIColor.backgroundColors(color: .red)
        self.view.addSubview(redBGView)
        
        let titleOfQuotePrice:UILabel = UILabel.init(frame: CGRect(x: 10, y: 31 + heightChangeForiPhoneXFromTop, width: 200, height: 25))
        titleOfQuotePrice.text = "估算订单价格"
        titleOfQuotePrice.textColor = UIColor.titleColors(color: .white)
        titleOfQuotePrice.textAlignment = .left
        titleOfQuotePrice.font = UIFont.systemFont(ofSize: 18)
        
        redBGView.addSubview(titleOfQuotePrice)
        redBGView.addSubview(taxLabelView)
        
        taxLabelView.frame = CGRect(x: 128, y: 35 + heightChangeForiPhoneXFromTop, width: 40, height: 17)
        taxLabelView.image = UIImage(named: "taxLableimg-notax")
        taxLabelView.layer.masksToBounds = true
        
        //报价层
        let priceResultBgView:UIView = UIView.init(frame: CGRect(x: 10, y: 66 + heightChangeForiPhoneXFromTop, width: kWidth - 20, height: 70))
        priceResultBgView.layer.cornerRadius = 8
        priceResultBgView.backgroundColor = UIColor.backgroundColors(color: .white)
        let priceResultBgViewShadow:UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 92  + heightChangeForiPhoneXFromTop, width: kWidth - 20, height: 52))
        priceResultBgViewShadow.image = UIImage(named: "pricebgshadow")
        
        //发票层
        let taxResultBgView:UIView = UIView.init(frame: CGRect(x: 15, y: 126  + heightChangeForiPhoneXFromTop, width: kWidth - 30, height: 52))
        taxResultBgView.layer.cornerRadius = 8
        taxResultBgView.backgroundColor = UIColor.backgroundColors(color: .white)
        let taxResultBgViewShadow:UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 134  + heightChangeForiPhoneXFromTop, width: kWidth - 30, height: 52))
        taxResultBgViewShadow.image = UIImage(named: "pricebgshadow")
        
        self.view.addSubview(taxResultBgViewShadow)
        self.view.addSubview(taxResultBgView)
        self.view.addSubview(priceResultBgViewShadow)
        self.view.addSubview(priceResultBgView)
        
        //报价金额
        currentPriceLabel.frame = CGRect(x: (priceResultBgView.frame.width - 200)/2, y: 17, width: 200, height: 37)
        currentPriceLabel.textAlignment = .center
        currentPriceLabel.text = "¥0.00"
        currentPriceLabel.textColor = UIColor.titleColors(color: .red)
        currentPriceLabel.font = UIFont.systemFont(ofSize: 26)
        priceResultBgView.addSubview(currentPriceLabel)
        
        //价格更新中
        updatingPriceLabel.frame = CGRect(x: (priceResultBgView.frame.width - 200)/2, y: 39, width: 200, height: 37)
        updatingPriceLabel.textAlignment = .center
        updatingPriceLabel.text = "   计算中..."
        updatingPriceLabel.isHidden = true
        updatingPriceLabel.textColor = UIColor.titleColors(color: .black)
        updatingPriceLabel.font = UIFont.systemFont(ofSize: 14)
        priceResultBgView.addSubview(updatingPriceLabel)
       
        //开发票
        payTaxcheckBoxBtn.frame = CGRect(x: 40, y: 21, width: 20, height: 20)
        payTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
        payTaxcheckBoxBtn.addTarget(self, action: #selector(checkBoxChanged), for: .touchUpInside)
        payTaxBtn.frame = CGRect(x: 55, y: 20, width: 80, height: 22)
        payTaxBtn.setTitle("开发票", for: .normal)
        payTaxBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        payTaxBtn.setTitleColor(UIColor.backgroundColors(color: .black), for: .normal)
        payTaxBtn.addTarget(self, action: #selector(checkBoxChanged), for: .touchUpInside)
        
        taxRadioBtn.frame = CGRect(x: 115, y: 19, width: 100, height: 22)
        taxRadioBtn.isHidden = true
        taxRadioBtn.setTitleColor(UIColor.backgroundColors(color: .red), for: .normal)
        let taxRadioString = "税率: 16%"
        let attributes =  [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let attributedText = NSAttributedString(string: taxRadioString, attributes: attributes)

        taxRadioBtn.setAttributedTitle(attributedText, for: .normal)
        taxRadioBtn.addTarget(self, action:#selector(taxRadioBtnClicked), for: .touchUpInside)
        
        //不开发票
        payWithoutTaxcheckBoxBtn.frame = CGRect(x: taxResultBgView.frame.width - 129, y: 21, width: 20, height: 20)
        payWithoutTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-checked"), for: .normal)
        payWithoutTaxcheckBoxBtn.addTarget(self, action: #selector(checkBoxChanged), for: .touchUpInside)
        payWithoutTaxBtn.frame = CGRect(x: taxResultBgView.frame.width - 105, y: 20, width: 80, height: 22)
        payWithoutTaxBtn.setTitle("不开发票", for: .normal)
        payWithoutTaxBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        payWithoutTaxBtn.setTitleColor(UIColor.backgroundColors(color: .black), for: .normal)
        payWithoutTaxBtn.addTarget(self, action: #selector(checkBoxChanged), for: .touchUpInside)
        
        taxResultBgView.addSubview(payTaxBtn)
        taxResultBgView.addSubview(payTaxcheckBoxBtn)
        taxResultBgView.addSubview(payWithoutTaxcheckBoxBtn)
        taxResultBgView.addSubview(payWithoutTaxBtn)
        taxResultBgView.addSubview(taxRadioBtn)
        
        
        
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
        
//        productLengthValue.frame = CGRect(x: 15, y: 32, width: (kWidth-120)/3, height: 32)
//        productLengthValue.text = "30.0"
//        productLengthValue.textAlignment = .center
//        productLengthValue.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
//        productLengthValue.layer.cornerRadius = 4
//        productLengthValue.delegate = self
//
//        productWidthValue.frame = CGRect(x: productLengthValue.frame.maxX + 45, y: 32, width: (kWidth-120)/3, height: 32)
//        productWidthValue.text = "30.0"
//        productWidthValue.textAlignment = .center
//        productWidthValue.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
//        productWidthValue.layer.cornerRadius = 4
//        productWidthValue.delegate = self
//
//        productHeightValue.frame = CGRect(x: productWidthValue.frame.maxX + 45, y: 32, width: (kWidth-120)/3, height: 32)
//        productHeightValue.text = "2.0"
//        productHeightValue.textAlignment = .center
//        productHeightValue.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
//        productHeightValue.layer.cornerRadius = 4
//        productHeightValue.delegate = self
        
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
        
        //分割线
        seperateLine1.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine2.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine3.image = UIImage(named: "dashlineimg")
        seperateLine4.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine5.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine6.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine7.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        seperateLine8.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        
        self.view.addSubview(quotePriceParasTable)
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
//
//        if textView.isEqual(postToPplTextFeild) {
//            print("postToFiled selected")
//            postToPplAddContact.isHidden = false
//        }else{
//            postToPplAddContact.isHidden = true
//        }
        
        //        if textView.isEqual(self.postToPplTextFeild) && postToPplTextFeild.text == "输入/选中任务接受者"{
        //            postToPplTextFeild.text = ""
        //        }
        
        textField.inputAccessoryView = topView
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        productAmountValue.resignFirstResponder()
       //
        //textField.resignFirstResponder()
        updatePrice()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QuotePriceTableViewCell.customCell(tableView: quotePriceParasTable)
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
            cell.contentView.addSubview(productSizeLabel)
            cell.contentView.addSubview(productSizeValue)
            let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 35, y: 16, width: 20, height: 20))
            rightArrow.image = UIImage(named: "right-arrow")
            cell.contentView.addSubview(rightArrow)
            cell.contentView.addSubview(seperateLine8)
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
        case 3,4,5,6:
            return 52.0
        case 7:
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
            ParasView.quotePriceVC = self
            ParasView.sourceVC = .quotePrice
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
            ParasView.quotePriceVC = self
            ParasView.sourceVC = .quotePrice
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
            ParasView.quotePriceVC = self
            ParasView.sourceVC = .quotePrice
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
            ParasView.quotePriceVC = self
            ParasView.sourceVC = .quotePrice
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
            productTypeValueID = String(productItems[row].value(forKey: "id") as! Int)
        case ProductMaterialPicker:
            let productItems = ProductParams[1]
            productMaterialValue.text = productItems[row].value(forKey: "material") as! String
            productMaterialValueID = String(productItems[row].value(forKey: "id") as! Int)
        case ProductAccessoriesPicker:
            let productItems = ProductParams[2]
            productAccessoriesValue.text = productItems[row].value(forKey: "accessories") as! String
            productAccessoriesValueID = String(productItems[row].value(forKey: "id") as! Int)
        default:
            print("something was wrong")
        }
       // pickerView.selectRow(row, inComponent: 0, animated: true)
        updatePrice()
    }
    @objc func checkBoxChanged(){
        payTaxStatus = !payTaxStatus
        if payTaxStatus{
            if taxRadioValue == 0.0{
                taxRadioValue = 0.16
            }
            taxLabelView.image = UIImage(named: "taxLableimg-withtax")
            taxRadioBtn.isHidden = false
            payTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-checked"), for: .normal)
            payWithoutTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
        }else{
            taxRadioValue = 0.0
            taxLabelView.image = UIImage(named: "taxLableimg-notax")
            taxRadioBtn.isHidden = true
            payTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
            payWithoutTaxcheckBoxBtn.setImage(UIImage(named: "checkbox-checked"), for: .normal)
        }
        updatePrice()
    }
    
    
    func updatePrice(){
        updatingPriceLabel.isHidden = false
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
        params["iscontinue"] = "0"
        params["quality"] = "0"
        header["token"] = token
        params["num"] = productAmountValue.text as! String //orderID
        params["producttype"] = productTypeValueID
        params["material"] = productMaterialValueID
        params["color"] = productColorValueID
        params["model"] = productMoldStyleValueID
        params["technology"] = productProduceStyleID
        params["sizelong"] = productLengthValue
        params["sizewidth"] = productWidthValue
        params["sizeheight"] = productHeightValue
        params["accessories"] = productAccessoriesValueID
        
        
            #if DEBUG
           let requestUrl = apiAddresses.value(forKey: "autoPriceDebug") as! String
            #else
           let requestUrl = apiAddresses.value(forKey: "autoPrice") as! String
            #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        print("自动价格获取成功")
                        greyLayerPrompt.show(text: "价格已刷新")
                        let returnPrice = json["data","pred_duty"].float!
                        print("returnPrice = \(returnPrice)")
                        let priceWithoutShipping = returnPrice/(1 + 0.02)
                        print("priceWithoutShipping = \(priceWithoutShipping)")
                        let taxPrice = priceWithoutShipping * self.taxRadioValue
                        print("taxPrice = \(taxPrice)")
                        let currentPrice = taxPrice + returnPrice
                         print("currentPrice = \(currentPrice)")
                        self.currentPriceLabel.text = "¥\(Int(currentPrice)).00"
                        //self.closeActionView()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
//                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
//                        LogoutMission(viewControler: self)
                    }else{
                        
                        let errorMsg = json["message"].string!
                        print("报价失败，msg:\(errorMsg)")
                        self.currentPriceLabel.text = "¥0.00"
                        greyLayerPrompt.show(text: errorMsg)
                    }
                }
            case false:
                print("处理失败")
                self.currentPriceLabel.text = "¥0.00"
                greyLayerPrompt.show(text: "更新报价失败")
            }
            self.updatingPriceLabel.isHidden = true
        }
        print("自动报价")
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
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
        ParasView.quotePriceVC = self
        popVC.view.addSubview(ParasView)
        self.present(popVC, animated: true, completion: nil)
    }
    //键盘设置
    @objc func keyBoardWillShow(_notification: Notification){
        //获取userInfo
        let kbInfo = _notification.userInfo
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        UIView.animate(withDuration: duration) {
            self.quotePriceParasTable.transform = CGAffineTransform(translationX: 0, y: -240)
        }
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_notification: Notification){
        
        let kbInfo = _notification.userInfo
        /*
         swift2.3正常，swift3.0取值为nil
         */
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        UIView.animate(withDuration: duration) {
            self.quotePriceParasTable.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        
        
    }
    func setupSelectedItems(){
        moldSelectedItems.removeAll()
        produceStyleSelectedItems.removeAll()
        colorSelectedItems.removeAll()
        
        var modelTypeArray:[String] = []
        for item in ProductParams[3]{
            modelTypeArray.append(item.value(forKey: "model") as! String)
        }
        for item in modelTypeArray{ // 开模方式
            if (productMoldStyleValue.text?.contains(item))!{
                moldSelectedItems.append(item)
            }
        }
        
        var produceArray:[String] = []
        for item in ProductParams[4]{
            produceArray.append(item.value(forKey: "technology") as! String)
        }
        for item in produceArray{ // 生产工艺
            if (productProduceStyleValue.text?.contains(item))!{
                produceStyleSelectedItems.append(item)
            }
        }
        
        var colorArray:[String] = []
        for item in ProductParams[5]{
            colorArray.append(item.value(forKey: "color") as! String)
        }
        for item in colorArray{ // 电镀色
            if (productColorValue.text?.contains(item))!{
                colorSelectedItems.append(item)
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
