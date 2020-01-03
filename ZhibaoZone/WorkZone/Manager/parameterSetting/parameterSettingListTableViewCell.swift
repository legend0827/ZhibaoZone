//
//  parameterSettingListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class parameterSettingListTableViewCell: UITableViewCell,UITextFieldDelegate {

    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 20, width: 240, height: 22))
    let line:UIView = UIView.init(frame: CGRect(x: 15, y: 60.5, width: kWidth - 30, height: 0.5))
    lazy var parameterValue:UITextField = {
        let tempValue = UITextField.init(frame: CGRect(x: kWidth - 306, y: 10, width: 250, height: 41))
        tempValue.delegate = self
        tempValue.contentVerticalAlignment = .center
        tempValue.font = UIFont.systemFont(ofSize: 15)
        tempValue.textAlignment = .right
        tempValue.keyboardType = .numberPad
        return tempValue
    }()
    let parameteUnit:UILabel = {
        let label = UILabel.init(frame: CGRect(x: kWidth - 35, y: 20, width: 20, height: 22))
        label.text = "-"
        label.textAlignment = .center
        label.textColor = UIColor.titleColors(color: .black)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var switchsButton:UISwitch = {
        let tempSwitch = UISwitch.init(frame: CGRect(x: 200, y: 16, width: 51, height: 31))
        tempSwitch.isOn = true
        tempSwitch.isHidden = true
        tempSwitch.addTarget(self, action: #selector(switchBtnValueChanged), for: .valueChanged)
        return tempSwitch
    }()
    
    var textFieldMaxValue:Int = 0
    var textFieldMinValue:Int = 999
    var textFieldDefaultValue:Int = 0
    var fatherObject:pamaterSettingViewController?
    var selectedIndex:Int = 0
    var parameterSetting:parameterSettingType = .CSCreateOrderSetting
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> parameterSettingListTableViewCell{
        let reuseIdentifier = "parameterSettingListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = parameterSettingListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! parameterSettingListTableViewCell
    }
    
    public override func layoutSubviews() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.titleColors(color: .black)
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        self.contentView.addSubview(parameterValue)
        self.contentView.addSubview(parameteUnit)
        self.contentView.addSubview(line)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(switchsButton)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" || textField.text == "0.00"{
            textField.text = ""
        }
        if selectedIndex >= 4{
            let tableView = self.superTableView()
            UIView.animate(withDuration: 0.3) {
                tableView?.transform = CGAffineTransform(translationX: 0, y: CGFloat(-61 * (self.selectedIndex - 4)))
            }
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if selectedIndex >= 4{
            let tableView = self.superTableView()
            UIView.animate(withDuration: 0.3) {
                tableView?.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
        return true
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var currentValue:Int64 = 0
//        if parameterValue.text == "" || parameterValue.text == nil{
//            currentValue = 0
//        }else{
//            currentValue = Int64(parameterValue.text ?? "0")!
//        }
//        if currentValue >= textFieldMinValue && currentValue <= textFieldMaxValue{
//            print("正确值")
//        }else{
//            parameterValue.text = "\(textFieldDefaultValue)"
//            greyLayerPrompt.show(text: "参数值超限")
//        }
        if range.upperBound >= 9{
            parameterValue.text?.removeLast()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var currentValue:Int64 = 0
        if parameterValue.text == "" || parameterValue.text == nil{
           currentValue = 0
        }else{
            currentValue = Int64(parameterValue.text ?? "0")!
        }
        if currentValue >= textFieldMinValue && currentValue <= textFieldMaxValue{
            print("正确值")
        }else{
            parameterValue.text = "\(textFieldDefaultValue)"
            greyLayerPrompt.show(text: "参数值超限")
        }
        
        switch parameterSetting {
        case .CSCreateOrderSetting:
            switch selectedIndex{
            case 0:
                //cell.titleLabel.text = "参考转化率时间范围(天)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "servicer_conversionRate_timeRange")
            case 1:
                // cell.titleLabel.text = "参考转化率默认值(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "servicer_conversionRate_default")
            case 2:
                //cell.titleLabel.text = "新建订单最大数(达标)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "servicer_createLimit_reachedLimit")
                
            case 3:
                //cell.titleLabel.text = "新建订单最大数(不达标)"
                
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "servicer_createLimit_unreachedLimit")
            case 4:
                //cell.titleLabel.text = "新建订单最大数(不达标)"
                
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "servicer_conversionRecentDay_timeRange")
            case 5:
                //cell.titleLabel.text = "新建订单最大数(不达标)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "servicer_conversionRate_percentage")
                
            default:
                //cell.titleLabel.text = "参考转化率时间范围(天)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "servicer_conversionRate_timeRange")
            }
        //print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
            // print("经理跟单配置")
            switch selectedIndex{
            case 0:
                //cell.titleLabel.text = "待跟大单时间范围(小时)"
               // let tempValue = String(format: "%.4f", (Double(parameterValue.text ?? "0") ?? 0) / 24.0)
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "manager_follow_timeRange")
            case 1:
                // cell.titleLabel.text = "待跟大单选取比例(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "manager_follow_top")
                
            default:
                //cell.titleLabel.text = "待跟大单时间范围(天)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "manager_follow_top")
            }
        case .DSDistributeOrderSetting:
            //  print("设计派单跟单配置")
            switch selectedIndex{
            case 0:
                //cell.titleLabel.text = "设计派单轮换时间(秒)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_dispatch_timeInterval")
                
            case 1:
                //cell.titleLabel.text = "设计权重-设计单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
                
            case 2:
                //cell.titleLabel.text = "设计权重-修改单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_modifyNum")
            case 3:
                //cell.titleLabel.text = "设计权重-出图时间权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_averageDesignTime")
            case 4:
                //cell.titleLabel.text = "设计权重-拒单率权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_refuseRate")
            case 5:
                //cell.titleLabel.text = "设计权重-定稿率权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_adoptRate")
            case 6:
                //cell.titleLabel.text = "设计权重-定稿率权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_transferRate")
            case 7:
                //cell.titleLabel.text = "设计师选取比例(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "design_dispatch_topWeight")
            default:
                //cell.titleLabel.text = "设计权重-修改单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
            }
        case .DSHangUpSetting:
            // print("设计师派单配置")
            switch selectedIndex{
            case 0:
                //cell.titleLabel.text = "最少保证在线设计师数(人)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "designer_onlineLimit")
            default:
                //cell.titleLabel.text = "设计权重-修改单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
            }
        case .DSDesignFeeSetting:
            // print("设计费配置")
            switch selectedIndex{
            case 0:
                // cell.titleLabel.text = "设计费默认值(元)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "designFee_default")
            case 1:
                //cell.titleLabel.text = "设计费默认比例(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "designFee_set_default")
            case 2:
                //cell.titleLabel.text = "引导费比例(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "designGuideFee_set_default")
            case 3:
                //cell.titleLabel.text = "设计费最大值取值比例(%)"
                let tempValue = String(format: "%.4f", (Double((Int(parameterValue.text ?? "0") ?? 0) ) / 100.0))
                fatherObject?._paramterSettingDic.setValue(tempValue, forKey: "designFee_set_defaultMaxValue")
            case 4:
                //cell.titleLabel.text = "设计费最大值"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "designFee_Max")
                
            case 5:
                //cell.titleLabel.text = "设计费最小值"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "designFee_Min")
            default:
                //cell.titleLabel.text = "设计权重-修改单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
            }
        case .AutoPricingSetting:
            // print("设计师派单配置")
            switch selectedIndex{
            case 0:
                //cell.titleLabel.text = "最少保证在线设计师数(人)"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "autoPrice_3dQuote_minValue")
            default:
                //cell.titleLabel.text = "设计权重-修改单权重"
                fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "autoPrice_3dQuote_minValue")
            }
        default:
            print("Will Never Execute")
            
        }
         parameterValue.resignFirstResponder()
    }
    
    @objc func switchBtnValueChanged(){
        if switchsButton.isOn{
            parameterValue.text = "100"
            parameterValue.isEnabled = true
            
            switch parameterSetting {
            case .CSCreateOrderSetting:
                print("客服新建订单限制配置")
            case .MGFollowOrderSetting:
                print("经理跟单配置")
            case .DSDistributeOrderSetting:
                print("设计派单跟单配置")
                switch selectedIndex{
                case 0:
                    print("设计派单轮换时间(秒)")
                case 1:
                    //cell.titleLabel.text = "设计权重-设计单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
                    
                case 2:
                    //cell.titleLabel.text = "设计权重-修改单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_modifyNum")
                case 3:
                    //cell.titleLabel.text = "设计权重-出图时间权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_averageDesignTime")
                case 4:
                    //cell.titleLabel.text = "设计权重-拒单率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_refuseRate")
                case 5:
                    //cell.titleLabel.text = "设计权重-定稿率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_adoptRate")
                case 6:
                    //cell.titleLabel.text = "设计权重-定稿率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_transferRate")
                case 7:
                    print("设计师选取比例(%)")
                default:
                    //cell.titleLabel.text = "设计权重-修改单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
                }
            case .DSHangUpSetting:
                print("设计师派单配置")
            case .DSDesignFeeSetting:
                print("设计费配置")
            default:
                print("Will Never Execute")
                
            }
            
        }else{
            parameterValue.text = "0"
            parameterValue.isEnabled = false
            
            switch parameterSetting {
            case .CSCreateOrderSetting:
                print("客服新建订单限制配置")
            case .MGFollowOrderSetting:
                print("经理跟单配置")
            case .DSDistributeOrderSetting:
                print("设计派单跟单配置")
                switch selectedIndex{
                case 0:
                    print("设计派单轮换时间(秒)")
                case 1:
                    //cell.titleLabel.text = "设计权重-设计单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
                    
                case 2:
                    //cell.titleLabel.text = "设计权重-修改单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_modifyNum")
                case 3:
                    //cell.titleLabel.text = "设计权重-出图时间权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_averageDesignTime")
                case 4:
                    //cell.titleLabel.text = "设计权重-拒单率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_refuseRate")
                case 5:
                    //cell.titleLabel.text = "设计权重-定稿率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_adoptRate")
                case 6:
                    //cell.titleLabel.text = "设计权重-定稿率权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_transferRate")
                case 7:
                    print("设计师选取比例(%)")
                default:
                    //cell.titleLabel.text = "设计权重-修改单权重"
                    fatherObject?._paramterSettingDic.setValue(parameterValue.text, forKey: "design_weight_designNum")
                }
            case .DSHangUpSetting:
                print("设计师派单配置")
            case .DSDesignFeeSetting:
                print("设计费配置")
            default:
                print("Will Never Execute")
                
            }
        }
    }
}
