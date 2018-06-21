//
//  ParasActionView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ParasActionView: UIView,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
    //弹窗ViewVC
    var popupVC = PopupViewController()
    //报价窗口页面VC
    var quotePriceVC = QuotePriceViewController()
    
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
        }else{
            ProductParams = paraDic
            parasCounts = paraCount
            selectedItems = seleItems
            checkStatus = convertSelectedItems(paras: paraDic, selectedItems: selectedItems)
            
            contentTableView.frame = CGRect(x: 0, y: 65, width: kWidth, height: kHight - 151)
            self.addSubview(contentTableView)
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
        
        return SelectedValue
    }
    //点击取消按钮
    @objc func cancelBtnClicked(){
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmBtnClicked(){
        var returnString = ""
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
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
