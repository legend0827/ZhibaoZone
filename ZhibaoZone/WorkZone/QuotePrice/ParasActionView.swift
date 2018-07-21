//
//  ParasActionView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ParasActionView: UIView,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
    //弹窗ViewVC
    lazy var popupVC = PopupViewController()
    //报价窗口页面VC
    lazy var quotePriceVC = QuotePriceViewController()
    //修改参数窗口VC
    lazy var editOrderParasVC = EditOrderParameters()
    //sourceVC
    var sourceVC:paraSourceType = .quotePrice
    ////
    //尺寸键盘
    var lengthValue:UITextField = UITextField.init()
    var widthValue:UITextField = UITextField.init()
    var heightValue:UITextField = UITextField.init()
    //按钮
    var oneKeyBtn:UIButton = UIButton.init(type: .custom)
    var twoKeyBtn:UIButton = UIButton.init(type: .custom)
    var threeKeyBtn:UIButton = UIButton.init(type: .custom)
    var fourKeyBtn:UIButton = UIButton.init(type: .custom)
    var fiveKeyBtn:UIButton = UIButton.init(type: .custom)
    var sixKeyBtn:UIButton = UIButton.init(type: .custom)
    var sevenKeyBtn:UIButton = UIButton.init(type: .custom)
    var eightKeyBtn:UIButton = UIButton.init(type: .custom)
    var nineKeyBtn:UIButton = UIButton.init(type: .custom)
    var deleteKeyBtn:UIButton = UIButton.init(type: .custom)
    var dotKeysBtn:UIButton = UIButton.init(type: .custom)
   // var dotKeysBtn:UIButton = UIButton.init(type: .custom)
    var zeroKeyBtn:UIButton = UIButton.init(type: .custom)
    var hideKeyboardBtn:UIButton = UIButton.init(type: .custom)
    var confirmKeyBtn:UIButton = UIButton.init(type: .custom)
    
    // 产品参数字典
    var ProductParams:[String] = []
    var parasCounts:Int = 0
    var selectedItems:[String] = []
    var _itemType:produceType = .mold
    var checkStatus:[Bool] = []
    //页面View
    let backgroundView:UIView = UIView.init()
    let cancelBtn:UIButton = UIButton.init(type: .custom)
    let confirmBtn:UIButton = UIButton.init(type: .custom)
    let titleOfView:UILabel = UILabel.init()
    //页面frame
    var _frame:CGRect = CGRect(x: 198, y: 50, width: 150, height: 30)
    
    //税率选择
    let TaxRadioPicker:UIPickerView = UIPickerView.init()
    //税率
    var taxRadioValue:Float = 0.16
    //选中表格
    lazy var contentTableView:UITableView = {
       let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 65, width: kWidth, height: self._frame.height - 95), style: .grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        tempTableView.backgroundColor = UIColor.white
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        
        return tempTableView
    }()
    
    init(frame:CGRect,paraDic:[String],paraCount:Int,seleItems:[String],itemType:produceType) {
        super.init(frame: frame)
        _frame = frame
        _itemType = itemType
        
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        //View标题
        titleOfView.frame = CGRect(x: 0, y: 20, width: kWidth, height: 25)
        titleOfView.textColor = UIColor.titleColors(color: .black)
        titleOfView.textAlignment = .center
        titleOfView.font = UIFont.boldSystemFont(ofSize: 18)
        
        cancelBtn.frame = CGRect(x: 25, y: 23, width: 50, height: 22)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        
        confirmBtn.frame = CGRect(x: kWidth - 75, y: 23, width: 50, height: 22)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        confirmBtn.isHidden = false
        
        self.addSubview(titleOfView)
        self.addSubview(cancelBtn)
        self.addSubview(confirmBtn)
        
        if itemType == .taxRadio{
            
            TaxRadioPicker.frame = CGRect(x: 0, y: 65, width: kWidth, height: 212 + heightChangeForiPhoneXFromBottom)
            TaxRadioPicker.backgroundColor = UIColor.backgroundColors(color: .white)
            TaxRadioPicker.delegate = self
            TaxRadioPicker.reloadComponent(0)
            TaxRadioPicker.selectRow(2, inComponent: 0, animated: true)
            
            self.addSubview(TaxRadioPicker)
        }else if itemType == .size{
            confirmBtn.isHidden = true
            cancelBtn.frame  = CGRect(x: kWidth - 75, y: 23, width: 50, height: 22)
            backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: frame.height)
            backgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
            self.addSubview(backgroundView)
            let lengthLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: 100, height: 22))
            lengthLabel.text = "长(mm):"
            lengthLabel.font = UIFont.systemFont(ofSize: 16)
            let seperateLine1:UIView = UIView.init(frame: CGRect(x: 20, y: lengthLabel.frame.maxY + 20, width: kWidth - 40, height: 0.5))
            seperateLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
            
            let widthLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine1.frame.maxY + 20, width: 100, height: 22))
            widthLabel.text = "宽(mm):"
            widthLabel.font = UIFont.systemFont(ofSize: 16)
            let seperateLine2:UIView = UIView.init(frame: CGRect(x: 20, y: widthLabel.frame.maxY + 20, width: kWidth - 40, height: 0.5))
            seperateLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
            
            let heightLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: seperateLine2.frame.maxY + 20, width: 100, height: 22))
            heightLabel.text = "高/厚(mm):"
            heightLabel.font = UIFont.systemFont(ofSize: 16)

            
            lengthValue.frame = CGRect(x: 126, y: 20, width: kWidth - 126, height: 22)
            lengthValue.placeholder = "请输入尺寸"
            lengthValue.delegate = self
            
            widthValue.frame = CGRect(x: 126, y: widthLabel.frame.minY, width: kWidth - 126, height: 22)
            widthValue.placeholder = "请输入尺寸"
            widthValue.delegate = self
            
            heightValue.frame = CGRect(x: 126, y: heightLabel.frame.minY, width: kWidth - 126, height: 22)
            heightValue.placeholder = "请输入尺寸"
            heightValue.delegate = self
            
            lengthValue.becomeFirstResponder()
            
            backgroundView.addSubview(lengthLabel)
            backgroundView.addSubview(widthLabel)
            backgroundView.addSubview(heightLabel)
            backgroundView.addSubview(seperateLine1)
            backgroundView.addSubview(seperateLine2)
            backgroundView.addSubview(lengthValue)
            backgroundView.addSubview(widthValue)
            backgroundView.addSubview(heightValue)
            
            setupKeyboard()
        }else{
            ProductParams = paraDic
            parasCounts = paraCount
            selectedItems = seleItems
            checkStatus = convertSelectedItems(paras: paraDic, selectedItems: selectedItems)
            
            contentTableView.frame = CGRect(x: 0, y: 65, width: kWidth, height: kHight - 151)
            self.addSubview(contentTableView)
        }

    }
    
    func setupKeyboard(){
        let keyWight:CGFloat = kWidth/4
        let keyHeight:CGFloat = 206.0/4
        
        let keyboardBG:UIView = UIView.init(frame: CGRect(x: 0, y: 190, width: kWidth, height: 206.0))
        keyboardBG.backgroundColor = UIColor.colorWithRgba(250, g: 251, b: 251, a: 1.0)
        
        oneKeyBtn.frame =       CGRect(x: 1,              y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        twoKeyBtn.frame =       CGRect(x: 1 + keyWight,   y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        threeKeyBtn.frame =     CGRect(x: 1 + keyWight*2, y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        fourKeyBtn.frame =      CGRect(x: 1,              y: keyHeight,       width: keyWight - 2,     height: keyHeight - 2)
        fiveKeyBtn.frame =      CGRect(x: 1 + keyWight,   y: keyHeight,       width: keyWight - 2,     height: keyHeight - 2)
        sixKeyBtn.frame =       CGRect(x: 1 + keyWight*2, y: keyHeight,       width: keyWight - 2,     height: keyHeight - 2)
        sevenKeyBtn.frame =     CGRect(x: 1,              y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        eightKeyBtn.frame =     CGRect(x: 1 + keyWight,   y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        nineKeyBtn.frame =      CGRect(x: 1 + keyWight*2, y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        dotKeysBtn.frame =      CGRect(x: 1,              y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        zeroKeyBtn.frame =      CGRect(x: 1 + keyWight,   y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        hideKeyboardBtn.frame = CGRect(x: 1 + keyWight*2, y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        deleteKeyBtn.frame =    CGRect(x: 1 + keyWight*3, y: 1,               width: keyWight - 2,     height: keyHeight*2 - 2)
        confirmKeyBtn.frame =   CGRect(x: keyWight*3, y: keyHeight*2 - 2,     width: keyWight,     height: keyHeight*2 + 4)
        
        oneKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        twoKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        threeKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        fourKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        fiveKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        sixKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        sevenKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        eightKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        nineKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        zeroKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        dotKeysBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        deleteKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        confirmKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        hideKeyboardBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        
        keyboardBG.addSubview(oneKeyBtn)
        keyboardBG.addSubview(twoKeyBtn)
        keyboardBG.addSubview(threeKeyBtn)
        keyboardBG.addSubview(fourKeyBtn)
        keyboardBG.addSubview(fiveKeyBtn)
        keyboardBG.addSubview(sixKeyBtn)
        keyboardBG.addSubview(sevenKeyBtn)
        keyboardBG.addSubview(eightKeyBtn)
        keyboardBG.addSubview(nineKeyBtn)
        keyboardBG.addSubview(dotKeysBtn)
        keyboardBG.addSubview(zeroKeyBtn)
        keyboardBG.addSubview(hideKeyboardBtn)
        keyboardBG.addSubview(deleteKeyBtn)
        keyboardBG.addSubview(confirmKeyBtn)
        
        let horizentalLine1:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 0.5))
        horizentalLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine1)
        
        let horizentalLine2:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight - 1, width: keyWight*3, height: 0.5))
        horizentalLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine2)
        
        let horizentalLine3:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*2 - 1, width: kWidth, height: 0.5))
        horizentalLine3.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine3)
        
        let horizentalLine4:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*3 - 1, width: keyWight*3, height: 0.5))
        horizentalLine4.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine4)
        
        let horizentalLine5:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*4 - 1, width: kWidth, height: 0.5))
        horizentalLine5.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine5)
        
        let verticalLine1:UIView = UIView.init(frame: CGRect(x: keyWight, y: 0, width: 0.5, height: 204.0))
        verticalLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine1)
        
        let verticalLine2:UIView = UIView.init(frame: CGRect(x: keyWight*2, y: 0, width: 0.5, height: 204.0))
        verticalLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine2)
        
        let verticalLine3:UIView = UIView.init(frame: CGRect(x: keyWight*3, y: 0, width: 0.5, height: 204.0))
        verticalLine3.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine3)
        
        oneKeyBtn.setImage(UIImage(named: "onekeyimg") , for: .normal)
        oneKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        oneKeyBtn.contentVerticalAlignment = .center
        oneKeyBtn.contentHorizontalAlignment = .center
        oneKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        oneKeyBtn.layer.borderWidth = 0.5
        oneKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        oneKeyBtn.tag = 1
        
        twoKeyBtn.setImage(UIImage(named: "twokeyimg") , for: .normal)
        twoKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        twoKeyBtn.contentVerticalAlignment = .center
        twoKeyBtn.contentHorizontalAlignment = .center
        twoKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        twoKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        twoKeyBtn.layer.borderWidth = 0.5
        twoKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        twoKeyBtn.tag = 2
        
        threeKeyBtn.setImage(UIImage(named: "threekeyimg") , for: .normal)
        threeKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        threeKeyBtn.contentVerticalAlignment = .center
        threeKeyBtn.contentHorizontalAlignment = .center
        threeKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        threeKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        threeKeyBtn.layer.borderWidth = 0.5
        threeKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        threeKeyBtn.tag = 3
        
        fourKeyBtn.setImage(UIImage(named: "fourkeyimg") , for: .normal)
        fourKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        fourKeyBtn.contentVerticalAlignment = .center
        fourKeyBtn.contentHorizontalAlignment = .center
        fourKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        fourKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        fourKeyBtn.layer.borderWidth = 0.5
        fourKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        fourKeyBtn.tag = 4
        
        fiveKeyBtn.setImage(UIImage(named: "fivekeyimg") , for: .normal)
        fiveKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        fiveKeyBtn.contentVerticalAlignment = .center
        fiveKeyBtn.contentHorizontalAlignment = .center
        fiveKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        fiveKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        fiveKeyBtn.layer.borderWidth = 0.5
        fiveKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        fiveKeyBtn.tag = 5
        
        sixKeyBtn.setImage(UIImage(named: "sixkeyimg") , for: .normal)
        sixKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        sixKeyBtn.contentVerticalAlignment = .center
        sixKeyBtn.contentHorizontalAlignment = .center
        sixKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        sixKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        sixKeyBtn.layer.borderWidth = 0.5
        sixKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        sixKeyBtn.tag = 6
        
        sevenKeyBtn.setImage(UIImage(named: "sevenkeyimg") , for: .normal)
        sevenKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        sevenKeyBtn.contentVerticalAlignment = .center
        sevenKeyBtn.contentHorizontalAlignment = .center
        sevenKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        sevenKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        sevenKeyBtn.layer.borderWidth = 0.5
        sevenKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        sevenKeyBtn.tag = 7
        
        eightKeyBtn.setImage(UIImage(named: "eightkeyimg") , for: .normal)
        eightKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        eightKeyBtn.contentVerticalAlignment = .center
        eightKeyBtn.contentHorizontalAlignment = .center
        eightKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        eightKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        eightKeyBtn.layer.borderWidth = 0.5
        eightKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        eightKeyBtn.tag = 8
        
        nineKeyBtn.setImage(UIImage(named: "ninekeyimg") , for: .normal)
        nineKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nineKeyBtn.contentVerticalAlignment = .center
        nineKeyBtn.contentHorizontalAlignment = .center
        nineKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        nineKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        nineKeyBtn.layer.borderWidth = 0.5
        nineKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        nineKeyBtn.tag = 9
        
        dotKeysBtn.setImage(UIImage(named: "dotkeyimg") , for: .normal)
        dotKeysBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        dotKeysBtn.contentVerticalAlignment = .center
        dotKeysBtn.contentHorizontalAlignment = .center
        dotKeysBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        dotKeysBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        dotKeysBtn.layer.borderWidth = 0.5
        dotKeysBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        dotKeysBtn.tag = 10
        
        zeroKeyBtn.setImage(UIImage(named: "zerokeyimg") , for: .normal)
        zeroKeyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        zeroKeyBtn.contentVerticalAlignment = .center
        zeroKeyBtn.contentHorizontalAlignment = .center
        zeroKeyBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
//        zeroKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        zeroKeyBtn.layer.borderWidth = 0.5
        zeroKeyBtn.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        zeroKeyBtn.tag = 0
        
        deleteKeyBtn.setImage(UIImage(named: "deletekeyimg"), for: .normal)
//        deleteKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        deleteKeyBtn.layer.borderWidth = 0.5
        deleteKeyBtn.tag = 11
        
        confirmKeyBtn.setImage(UIImage(named: "confirmkeyimg"), for: .normal)
//        confirmKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        confirmKeyBtn.layer.borderWidth = 0.5
        confirmKeyBtn.tag = 12
        
        hideKeyboardBtn.setImage(UIImage(named: "hidekeyboardimg"), for: .normal)
//        hideKeyboardBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
//        hideKeyboardBtn.layer.borderWidth = 0.5
        hideKeyboardBtn.tag = 13
        
        backgroundView.addSubview(keyboardBG)

        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.inputView = UIView()
        //textField.isUserInteractionEnabled = false
      //  textField.isEnabled = false
        return true
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //view.end
//        self.endEditing(true)
//        super.touchesBegan(touches, with: event)
//    }
    @objc func keyboardKeyPressed(_ button:UIButton){
        let pressIndex = button.tag
        print("pressed key \(pressIndex)")
        var currentText = ""
        switch pressIndex {
        case 0:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "0"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "0"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "0"
            }else{
                print("There's no selected responder")
            }
        case 1:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "1"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "1"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "1"
            }else{
                print("There's no selected responder")
            }
        case 2:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "2"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "2"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "2"
            }else{
                print("There's no selected responder")
            }
        case 3:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "3"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "3"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "3"
            }else{
                print("There's no selected responder")
            }
        case 4:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "4"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "4"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "4"
            }else{
                print("There's no selected responder")
            }
        case 5:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "5"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "5"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "5"
            }else{
                print("There's no selected responder")
            }
        case 6:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "6"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "6"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "6"
            }else{
                print("There's no selected responder")
            }
        case 7:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "7"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "7"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "7"
            }else{
                print("There's no selected responder")
            }
        case 8:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "8"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "8"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "8"
            }else{
                print("There's no selected responder")
            }
        case 9:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                lengthValue.text = currentText + "9"
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                widthValue.text = currentText + "9"
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                heightValue.text = currentText + "9"
            }else{
                print("There's no selected responder")
            }
        case 10:
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                if currentText.contains("."){
                    return
                }
                if currentText != ""{
                    lengthValue.text = currentText + "."
                }else{
                    lengthValue.text = currentText + "0."
                }
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                if currentText != ""{
                    widthValue.text = currentText + "."
                }else{
                    widthValue.text = currentText + "0."
                }
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                if currentText != ""{
                    heightValue.text = currentText + "."
                }else{
                    heightValue.text = currentText + "0."
                }
            }else{
                print("There's no selected responder")
            }
            
        case 11: //delete
            if lengthValue.isFirstResponder {
                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
                //lengthValue.text =
                if currentText != "" {
                    currentText.removeLast()
                    lengthValue.text = currentText
                }
            }else if widthValue.isFirstResponder{
                currentText = widthValue.text ?? ""
                if currentText != ""{
                    currentText.removeLast()
                    widthValue.text = currentText
                }
            }else if heightValue.isFirstResponder{
                currentText = heightValue.text ?? ""
                if currentText != ""{
                    currentText.removeLast()
                    heightValue.text = currentText
                }
            }else{
                print("There's no selected responder")
            }
        case 12:
            if lengthValue.text == "" || widthValue.text == "" || heightValue.text == ""{
                greyLayerPrompt.show(text: "请填写产品尺寸")
            }else{
                if sourceVC == .quotePrice{
                    quotePriceVC.productLengthValue = lengthValue.text!
                    quotePriceVC.productWidthValue = widthValue.text!
                    quotePriceVC.productHeightValue = heightValue.text!
                    quotePriceVC.productSizeValue.text = "\(lengthValue.text!)x\(widthValue.text!)x\(heightValue.text!)"
                    quotePriceVC.updatePrice()
                }else{
                    editOrderParasVC.productLengthValue = lengthValue.text!
                    editOrderParasVC.productWidthValue = widthValue.text!
                    editOrderParasVC.productHeightValue = heightValue.text!
                    editOrderParasVC.productSizeValue.text = "\(lengthValue.text!)x\(widthValue.text!)x\(heightValue.text!)"
                }
                cancelBtnClicked()
            }
            // confrim
//            if lengthValue.isFirstResponder {
//                currentText = lengthValue.text ?? "" // 如果lengthValue.text 为空 则使用"0.0"
//                lengthValue.text = currentText + "2"
//            }else if widthValue.isFirstResponder{
//                currentText = widthValue.text ?? ""
//                widthValue.text = currentText + "2"
//            }else if heightValue.isFirstResponder{
//                currentText = heightValue.text ?? ""
//                heightValue.text = currentText + "2"
//            }else{
                print("There's no selected responder")
//            }
        case 13: // hideKeyboard
            cancelBtnClicked()
        default:
            print("wrong key pressed")
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            taxRadioValue = 0.03
        case 1:
            taxRadioValue = 0.06
        case 2:
            taxRadioValue = 0.16
        default:
            taxRadioValue = 0.16
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil{
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 26)
            pickerLabel?.textAlignment = .center
            switch row {
            case 0:
                pickerLabel?.text = "3%"
            case 1:
                pickerLabel?.text = "6%"
            case 2:
                pickerLabel?.text = "16%"
            default:
                pickerLabel?.text = "16%"
            }
        }
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 57.0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parasCounts
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ParasTableViewCell.customCell(tableView: contentTableView)
        cell.selectionStyle = .none
        cell.checkBox.addTarget(self, action: #selector(checkedBoxChanged), for: .touchUpInside)
        cell.checkBox.tag = indexPath.row
        if checkStatus[indexPath.row]{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-checked"), for: .normal)
            
        }else{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
            //cell.checkBox.image = UIImage(named: "checkbox-unchecked")
        }
        switch _itemType {
        case .mold:
            cell.titleLabel.text = ProductParams[indexPath.row]
        case .produceStyle:
            cell.titleLabel.text = ProductParams[indexPath.row]
        case .color:
            cell.titleLabel.text = ProductParams[indexPath.row]

        default:
            print("hellp")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkStatus[indexPath.row] = !checkStatus[indexPath.row]
        if checkStatus[indexPath.row]{
            switch _itemType {
            case .mold:
                //判断是不是选中了双面开模
                var isDoubleSideChecked = false
                for item in ProductParams{
                    if item == "双面开模"{
                        let indexOfObject1 = ProductParams.index(of:item)
                        isDoubleSideChecked = checkStatus[indexOfObject1!]
                        break
                    }
                }
                
                if isDoubleSideChecked{
                    //双面开模选中了
                    if ProductParams[indexPath.row] == "无" ||  ProductParams[indexPath.row] == "浇铸" ||  ProductParams[indexPath.row] == "模切" ||  ProductParams[indexPath.row] == "双面开模" {
                        for i in 0..<checkStatus.count{
                            checkStatus[i] = false
                        }
                        checkStatus[indexPath.row] = true
                    }else{
                        
                        for item in ProductParams{
                            if item == "无" || item == "浇铸" || item == "模切"{
                                let indexOfObject1 = ProductParams.index(of:item)
                                checkStatus[indexOfObject1!] = false
                            }
                        }
                    }
                    //选中项目个数
                    var selectedItemCount = 0
                    for ls in checkStatus{
                        if ls == true{
                            selectedItemCount += 1
                        }
                    }
                    if selectedItemCount > 3{
                        checkStatus[indexPath.row] = false
                        greyLayerPrompt.show(text: "双面开模不能超过3种开模方式")
                    }
                    
                }else{
                    ///如果双面开模没有选中. 则直接按位取反
                    //所有选项取消选中
                    for i in 0..<checkStatus.count{
                        checkStatus[i] = false
                    }
                    //再把当前的checkStatus改为true
                    checkStatus[indexPath.row] = true
                }
            case .produceStyle:
                if ProductParams[indexPath.row] == "无" {
                    for index in 0..<checkStatus.count{
                        checkStatus[index] = false
                    }
                    checkStatus[indexPath.row] = true
                }else{
                    for item in ProductParams{
                        if item == "无" {
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                            break
                        }
                    }
                }
                
            case .color:
                if ProductParams[indexPath.row] == "无" {
                    for index in 0..<checkStatus.count{
                        checkStatus[index] = false
                    }
                    checkStatus[indexPath.row] = true
                }else{
                    for item in ProductParams{
                        if item == "无" {
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                            break
                        }
                    }
                }
            default:
                print("hellp")
            }
        }else{
//            if _itemType == .mold{
//                if ProductParams[indexPath.row] == "双面开模"{
//                    //如果双面开模没有选中. 则直接按位取反
//                    for item in ProductParams{
//                        if item == "无"{
//                            let indexOfObject1 = ProductParams.index(of:item)
//                            checkStatus[indexOfObject1!] = true
//                        }else{
//                            let indexOfObject1 = ProductParams.index(of:item)
//                            checkStatus[indexOfObject1!] = false
//                        }
//                    }
//                }
//            }
//
            switch _itemType{
            case .mold:
                
                if ProductParams[indexPath.row] == "双面开模"{
                    //如果双面开模没有选中. 则直接按位取反
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                        }else{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                        }
                    }
                }
                
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
                
            case .produceStyle:
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
            case .color:
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
            default:
                print("hallo")
                
            }
        }
        tableView.reloadData()
        print("Row \(indexPath.row) selected")
    }
    
    @objc func checkedBoxChanged(_ button:UIButton){
        let index = button.tag
        checkStatus[index] = !checkStatus[index]
        
        /*规则：
         1 、在选择双面开模以前，所有的选项都是单选
         2、选中双面开模后：
         1、取消对“无”或者“浇铸”或者“模切”的选择，选中“双面开模”
         2、不用取消已经选中的带2D或者3D的项目
         3、带2D和3D两字的项目可以选择1个或者2个，最多两个项目
         3、如果选择了双面开模，又尝试选择：“无”或者“浇铸”或者“模切”，则取消所有现有勾选，只选中最新选择的项目
         */
        
        if checkStatus[index]{
            
            switch _itemType {
            case .mold:
                //判断是不是选中了双面开模
                var isDoubleSideChecked = false
                for item in ProductParams{
                    if item == "双面开模"{
                        let indexOfObject1 = ProductParams.index(of:item)
                        isDoubleSideChecked = checkStatus[indexOfObject1!]
                        break
                    }
                }
                
                if isDoubleSideChecked{
                    //双面开模选中了
                    if ProductParams[index] == "无" ||  ProductParams[index] == "浇铸" ||  ProductParams[index] == "模切" ||  ProductParams[index] == "双面开模" {
                        for i in 0..<checkStatus.count{
                            checkStatus[i] = false
                        }
                        checkStatus[index] = true
                    }else{
                        
                        for item in ProductParams{
                            if item == "无" || item == "浇铸" || item == "模切"{
                                let indexOfObject1 = ProductParams.index(of:item)
                                checkStatus[indexOfObject1!] = false
                            }
                        }
                    }
                    //选中项目个数
                    var selectedItemCount = 0
                    for ls in checkStatus{
                        if ls == true{
                            selectedItemCount += 1
                        }
                    }
                    if selectedItemCount > 3{
                        checkStatus[index] = false
                        greyLayerPrompt.show(text: "双面开模不能超过3种开模方式")
                    }

                }else{
                    ///如果双面开模没有选中. 则直接按位取反
                    //所有选项取消选中
                    for i in 0..<checkStatus.count{
                        checkStatus[i] = false
                    }
                    //再把当前的checkStatus改为true
                    checkStatus[index] = true
                }
                
            case .produceStyle:
                if ProductParams[index] == "无" {
                    for i in 0..<checkStatus.count{
                        checkStatus[i] = false
                    }
                    checkStatus[index] = true
                }else{
                     for item in ProductParams{
                        if item == "无" {
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                            break
                        }
                    }
                }
                
            case .color:
                if ProductParams[index] == "无" {
                    for i in 0..<checkStatus.count{
                        checkStatus[i] = false
                    }
                    checkStatus[index] = true
                }else{
                    for item in ProductParams{
                        if item == "无" {
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                            break
                        }
                    }
                }
            default:
                print("hellp")
            }
            //如果勾选项目超过3个，提醒
            
        }else{
            
            switch _itemType{
            case .mold:
                
                if ProductParams[index] == "双面开模"{
                    //如果双面开模没有选中. 则直接按位取反
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                        }else{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = false
                        }
                    }
                }
                
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
                
            case .produceStyle:
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
            case .color:
                //选中项目个数
                var selectedItemCount = 0
                for ls in checkStatus{
                    if ls == true{
                        selectedItemCount += 1
                    }
                }
                if selectedItemCount == 0{
                    for item in ProductParams{
                        if item == "无"{
                            let indexOfObject1 = ProductParams.index(of:item)
                            checkStatus[indexOfObject1!] = true
                            break
                        }
                    }
                }
            default:
                print("hallo")
                
            }
        }
        
        contentTableView.reloadData()
    }
    func convertSelectedItems(paras:[String],selectedItems:[String])->[Bool]{
        var tempBoolArray:[Bool] = []
        switch _itemType {
        case .mold:
            
            for i in 0..<paras.count{
                var hasTheValue = false
                for item in selectedItems{
                    if paras[i] == item{
                        tempBoolArray.append(true)
                        hasTheValue = true
                        break
                    }
                }
                if !hasTheValue{
                    tempBoolArray.append(false)
                }
            }
            
        case .produceStyle:
            for i in 0..<paras.count{
                var hasTheValue = false
                for item in selectedItems{
                    if paras[i] == item{
                        tempBoolArray.append(true)
                        hasTheValue = true
                        break
                    }
                }
                if !hasTheValue{
                    tempBoolArray.append(false)
                }
            }
        case .color:
            for i in 0..<paras.count{
                var hasTheValue = false
                for item in selectedItems{
                    if paras[i] == item{
                        tempBoolArray.append(true)
                        hasTheValue = true
                        break
                    }
                }
                if !hasTheValue{
                    tempBoolArray.append(false)
                }
            }
        default:
            print("hellp")
        }
        
        return tempBoolArray
    }
    
    func convertCheckStatusToValue(statusArray:[Bool],Paras:[String]) -> String{
        var SelectedValue = ""
        if sourceVC == .quotePrice{
            switch _itemType {
            case .mold:
                
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]) "
                    }
                }
                
            case .produceStyle:
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]) "
                    }
                }
                
            case .color:
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]) "
                    }
                }
            default:
                print("hellp")
            }
        }else{
            switch _itemType {
            case .mold:
                
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]);"
                    }
                }
                
            case .produceStyle:
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]);"
                    }
                }
                
            case .color:
                for i in 0..<Paras.count{
                    if statusArray[i]{
                        SelectedValue += "\(Paras[i]);"
                    }
                }
            default:
                print("hellp")
            }
        }
        
        return SelectedValue
    }
    //点击取消按钮
    @objc func cancelBtnClicked(){
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmBtnClicked(){
        var returnString = ""
        
        if sourceVC == .quotePrice{
            switch _itemType {
            case .mold:
                
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                quotePriceVC.productMoldStyleValue.text = returnString
            case .produceStyle:
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                quotePriceVC.productProduceStyleValue.text = returnString
                
            case .color:
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                quotePriceVC.productColorValue.text = returnString
            case .taxRadio:
                
                let taxRadioString = "税率: \(Int(taxRadioValue * 100))%"
                let attributes =  [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16),NSAttributedStringKey.foregroundColor:UIColor.titleColors(color: .red),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
                let attributedText = NSAttributedString(string: taxRadioString, attributes: attributes)
                quotePriceVC.taxRadioValue = taxRadioValue
                quotePriceVC.taxRadioBtn.setAttributedTitle(attributedText, for: .normal)
            default:
                print("hellp")
            }
            
            quotePriceVC.setupSelectedItems()
            quotePriceVC.updatePrice()
        }else{
            switch _itemType {
            case .mold:
                
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                editOrderParasVC.productMoldStyleValue.text = returnString
                editOrderParasVC.new_modal = returnString
            case .produceStyle:
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                editOrderParasVC.productProduceStyleValue.text = returnString
                editOrderParasVC.new_produceStyle = returnString
            case .color:
                returnString = convertCheckStatusToValue(statusArray: checkStatus, Paras: ProductParams)
                editOrderParasVC.productColorValue.text = returnString
                editOrderParasVC.new_color = returnString
            case .taxRadio:
                print("Wow! There's no possibility to get this")
            default:
                print("hellp")
            }
            //editOrderParasVC.updateParams()
            editOrderParasVC.setupSelectedItems()
        }
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
