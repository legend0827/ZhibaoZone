//
//  pamaterSettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class pamaterSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var _parameterType:parameterSettingType = .CSCreateOrderSetting
    
    lazy var titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
    
    var _paramterSettingDic:NSMutableDictionary = NSMutableDictionary()
    var _savedParameterSettingDic:NSMutableDictionary = NSMutableDictionary()
    //双重确认
    lazy var doubleCheckPopUpWindow:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 20, y: 111 + heightChangeForiPhoneXFromTop, width: kWidth - 40, height: 393/335 * (kWidth - 40)))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        //确定提交
        let updateImidiatelyBtn:UIButton = UIButton.init(frame: CGRect(x: 20, y: tempView.frame.height - 55, width: (tempView.frame.width - 55)/2, height: 40))
        updateImidiatelyBtn.layer.cornerRadius = 2
        updateImidiatelyBtn.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        updateImidiatelyBtn.setTitle("确定提交", for: .normal)
        updateImidiatelyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        updateImidiatelyBtn.setTitleColor(UIColor.lineColors(color: .white), for: .normal)
        updateImidiatelyBtn.addTarget(self, action: #selector(confirmSubmitParameterClicked), for: .touchUpInside)
        
        tempView.addSubview(updateImidiatelyBtn)
        //取消按钮
        let cancelUpdateBtn:UIButton = UIButton.init(frame: CGRect(x: tempView.frame.width/2 + 7.5, y: tempView.frame.height - 55, width: (tempView.frame.width - 55)/2, height: 40))
        cancelUpdateBtn.layer.cornerRadius = 2
        cancelUpdateBtn.layer.backgroundColor = UIColor.lineColors(color: .white).cgColor
        cancelUpdateBtn.layer.borderColor = UIColor.lineColors(color: .grayLevel2).cgColor
        cancelUpdateBtn.layer.borderWidth = 0.5
        cancelUpdateBtn.setTitle("取消", for: .normal)
        cancelUpdateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelUpdateBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelUpdateBtn.addTarget(self, action: #selector(cancelUpdateClicked), for: .touchUpInside)
        
        let beforeUpdate:UILabel = UILabel.init(frame: CGRect(x: 204, y: 20, width: 60, height: 21))
        beforeUpdate.textAlignment = .left
        beforeUpdate.text = "更改前"
        beforeUpdate.textColor = UIColor.titleColors(color: .gray)
        beforeUpdate.font  = UIFont.systemFont(ofSize: 15)
        
        tempView.addSubview(beforeUpdate)
    
        let afterUpdate:UILabel = UILabel.init(frame: CGRect(x: tempView.frame.width - 80, y: 20, width: 60, height: 21))
        afterUpdate.textAlignment = .right
        afterUpdate.text = "更改后"
        afterUpdate.textColor = UIColor.titleColors(color: .darkGray)
        afterUpdate.font  = UIFont.systemFont(ofSize: 15)
        
        tempView.addSubview(afterUpdate)
        
        let seperateLine:UIView = UIView.init(frame: CGRect(x: 20, y: 56.5, width: tempView.frame.width - 40, height: 0.5))
        seperateLine.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        tempView.addSubview(seperateLine)
        
        tempView.layer.cornerRadius = 6
        tempView.addSubview(cancelUpdateBtn)
        tempView.addSubview(doubleCheckTitle)
        tempView.isUserInteractionEnabled = true
        
        tempView.addSubview(firstTitleOfDoubleCheck)
        tempView.addSubview(secondTitleOfDoubleCheck)
        tempView.addSubview(thirdTitleOfDoubleCheck)
        tempView.addSubview(fouthTitleOfDoubleCheck)
        tempView.addSubview(fifthTitleOfDoubleCheck)
        tempView.addSubview(sixthTitleOfDoubleCheck)
        tempView.addSubview(seventhTitleOfDoubleCheck)
        
        tempView.addSubview(firstBeforeValueOfDoubleCheck)
        tempView.addSubview(secondBeforeValueOfDoubleCheck)
        tempView.addSubview(thirdBeforeValueOfDoubleCheck)
        tempView.addSubview(fouthBeforeValueOfDoubleCheck)
        tempView.addSubview(fifthBeforeValueOfDoubleCheck)
        tempView.addSubview(sixthBeforeValueOfDoubleCheck)
        tempView.addSubview(seventhBeforeValueOfDoubleCheck)
        
        tempView.addSubview(firstAfterValueOfDoubleCheck)
        tempView.addSubview(secondAfterValueOfDoubleCheck)
        tempView.addSubview(thirdAfterValueOfDoubleCheck)
        tempView.addSubview(fouthAfterValueOfDoubleCheck)
        tempView.addSubview(fifthAfterValueOfDoubleCheck)
        tempView.addSubview(sixthAfterValueOfDoubleCheck)
        tempView.addSubview(seventhAfterValueOfDoubleCheck)
        return tempView
    }()
    
    //更新提示窗口
    lazy var doubleCheckNoticeBGView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        tempView.backgroundColor = UIColor.clear
        
        //灰色窗口
        let bgimg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        bgimg.image = UIImage(named: "blurBgViewgreyimg")
        tempView.addSubview(bgimg)
        
        tempView.addSubview(doubleCheckPopUpWindow)
        
        return tempView
    }()
    
    
    lazy var doubleCheckTitle:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 20, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        return tempLabel
    }()
    
    lazy var firstTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 72, width: 200, height: 21))
        tempLabel.text = "参考转化率默认值(%)"
        tempLabel.isHidden = false
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var secondTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 110, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.isHidden = true
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var thirdTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 148, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fouthTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 186, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fifthTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 224, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var sixthTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 262, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var seventhTitleOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 300, width: 200, height: 21))
        tempLabel.text = "核对配置更改"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var firstBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 72, width: 85, height: 21))
        tempLabel.text = "30"
        tempLabel.isHidden = false
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var secondBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 110, width: 85, height: 21))
        tempLabel.text = "30"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.isHidden = true
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var thirdBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 148, width: 85, height: 21))
        tempLabel.text = "12"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fouthBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 186, width: 85, height: 21))
        tempLabel.text = "8"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fifthBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 224, width: 85, height: 21))
        tempLabel.text = "100"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var sixthBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 262, width: 85, height: 21))
        tempLabel.text = "100"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var seventhBeforeValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 164, y: 300, width: 85, height: 21))
        tempLabel.text = "60"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var firstAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x:kWidth - 260, y: 72, width: 200, height: 21))
        tempLabel.text = "30"
        tempLabel.isHidden = false
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var secondAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 110, width: 200, height: 21))
        tempLabel.text = "30"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.isHidden = true
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var thirdAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 148, width: 200, height: 21))
        tempLabel.text = "12"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fouthAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 186, width: 200, height: 21))
        tempLabel.text = "8"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var fifthAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 224, width: 200, height: 21))
        tempLabel.text = "100"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var sixthAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 262, width: 200, height: 21))
        tempLabel.text = "100"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var seventhAfterValueOfDoubleCheck:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 260, y: 300, width: 200, height: 21))
        tempLabel.text = "60"
        tempLabel.isHidden = true
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    lazy var saveParameterBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: kHight - 60 - heightChangeForiPhoneXFromBottom, width: kWidth, height: 60 + heightChangeForiPhoneXFromBottom))
        button.setTitle("", for: .normal)
        button.isEnabled = true
        
        let title:UILabel = UILabel.init(frame: CGRect(x: 0, y: 18, width: kWidth, height: 24))
        title.text = "保存配置"
        title.textAlignment = .center
        title.textColor =  UIColor.titleColors(color: .white)
        title.font = UIFont.systemFont(ofSize: 17)
        button.addSubview(title)
        
        button.layer.backgroundColor = UIColor.lineColors(color: .lightOrange).cgColor
        button.addTarget(self, action: #selector(saveParameterBtnClicked), for: .touchUpInside)
        return button
    }()
    lazy var paraterSettingListTable:UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - heightChangeForiPhoneXFromBottom - heightChangeForiPhoneXFromTop - 64))
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        return table
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch _parameterType {
        case .CSCreateOrderSetting:
            return 6
            //print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
           // print("经理跟单配置")
            return 2
        case .DSDistributeOrderSetting:
          //  print("设计派单跟单配置")
            return 7
        case .DSHangUpSetting:
           // print("设计师派单配置")
            return 1
        case .DSDesignFeeSetting:
           // print("设计费配置")
            return 5
        case .AutoPricingSetting:
            return 1
        default:
           // print("客服新建订单限制配置")
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parameterSettingListTableViewCell.customCell(tableView: paraterSettingListTable)
        cell.selectionStyle = .none
        cell.fatherObject = self
        cell.parameterSetting = _parameterType
        cell.selectedIndex = indexPath.row
        switch _parameterType {
        case .CSCreateOrderSetting:
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "参考转化率时间范围(天)"
                cell.parameterValue.placeholder = "1 - 999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMaxValue = 999
                cell.textFieldMinValue = 1
                if let servicer_conversionRate_timeRange = _paramterSettingDic.value(forKey: "servicer_conversionRate_timeRange") as? Int{
                    cell.parameterValue.text = "\(servicer_conversionRate_timeRange)"
                }
                
            case 1:
                cell.titleLabel.text = "参考转化率默认值(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let servicer_conversionRate_default = _paramterSettingDic.value(forKey: "servicer_conversionRate_default") as? Double{
                    cell.parameterValue.text = "\(Int(servicer_conversionRate_default * 100))"
                }
            case 2:
                cell.titleLabel.text = "新建订单最大数(达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "12"
                cell.textFieldDefaultValue = 12
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let servicer_createLimit_reachedLimit = _paramterSettingDic.value(forKey: "servicer_createLimit_reachedLimit") as? Int{
                    cell.parameterValue.text = "\(servicer_createLimit_reachedLimit)"
                }
            case 3:
                cell.titleLabel.text = "新建订单最大数(不达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let servicer_createLimit_unreachedLimit = _paramterSettingDic.value(forKey: "servicer_createLimit_unreachedLimit") as? Int{
                    cell.parameterValue.text = "\(servicer_createLimit_unreachedLimit)"
                }
            case 4:
                cell.titleLabel.text = "客服(达标)转化率参考范围(天)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "3"
                cell.textFieldDefaultValue = 3
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let servicer_conversionRecentDay_timeRange = _paramterSettingDic.value(forKey: "servicer_conversionRecentDay_timeRange") as? Int{
                    cell.parameterValue.text = "\(servicer_conversionRecentDay_timeRange)"
                }
            case 5:
                cell.titleLabel.text = "客服(达标)转化率参考幅度(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "70"
                cell.textFieldDefaultValue = 70
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let servicer_conversionRate_percentage = _paramterSettingDic.value(forKey: "servicer_conversionRate_percentage") as? Double{
                    cell.parameterValue.text = "\(Int(servicer_conversionRate_percentage * 100))"
                }
            default:
                cell.titleLabel.text = "参考转化率时间范围(天)"
                cell.parameterValue.placeholder = "1 - 999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 999
            }
        //print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
            // print("经理跟单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "待跟大单时间范围(小时)"
                cell.parameterValue.placeholder = "1 - 9999"
                cell.parameteUnit.text = "时"
                cell.parameterValue.text = "24"
                cell.textFieldDefaultValue = 24
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 9999
                if let manager_follow_timeRange = _paramterSettingDic.value(forKey: "manager_follow_timeRange") as? Int{
                    cell.parameterValue.text = "\(manager_follow_timeRange)"
                }
            case 1:
                cell.titleLabel.text = "待跟大单选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "5"
                cell.textFieldDefaultValue = 5
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let manager_follow_top = _paramterSettingDic.value(forKey: "manager_follow_top") as? Double{
                    cell.parameterValue.text = "\(Int(manager_follow_top * 100))"
                }
            default:
                cell.titleLabel.text = "待跟大单时间范围(天)"
                cell.parameterValue.placeholder = "1 - 9999"
                cell.parameteUnit.text = "天"
                cell.parameterValue.text = "24"
                cell.textFieldDefaultValue = 24
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 9999
            }
        case .DSDistributeOrderSetting:
            //  print("设计派单跟单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "设计派单轮换时间(秒)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "秒"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let design_dispatch_timeInterval = _paramterSettingDic.value(forKey: "design_dispatch_timeInterval") as? Int{
                    cell.parameterValue.text = "\(design_dispatch_timeInterval)"
                }
            case 1:
                cell.titleLabel.text = "设计权重-设计单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_designNum = _paramterSettingDic.value(forKey: "design_weight_designNum") as? Int{
                    cell.parameterValue.text = "\(design_weight_designNum)"
                }
                cell.switchsButton.isHidden = false
            case 2:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_modifyNum = _paramterSettingDic.value(forKey: "design_weight_modifyNum") as? Int{
                    cell.parameterValue.text = "\(design_weight_modifyNum)"
                }
                cell.switchsButton.isHidden = false
            case 3:
                cell.titleLabel.text = "设计权重-出图时间权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_averageDesignTime = _paramterSettingDic.value(forKey: "design_weight_averageDesignTime") as? Int{
                    cell.parameterValue.text = "\(design_weight_averageDesignTime)"
                }
                cell.switchsButton.isHidden = false
            case 4:
                cell.titleLabel.text = "设计权重-拒单率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_refuseRate = _paramterSettingDic.value(forKey: "design_weight_refuseRate") as? Int{
                    cell.parameterValue.text = "\(design_weight_refuseRate)"
                }
                cell.switchsButton.isHidden = false
            case 5:
                cell.titleLabel.text = "设计权重-定稿率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
                if let design_weight_adoptRate = _paramterSettingDic.value(forKey: "design_weight_adoptRate") as? Int{
                    cell.parameterValue.text = "\(design_weight_adoptRate)"
                }
                cell.switchsButton.isHidden = false
            case 6:
                cell.titleLabel.text = "设计师选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let design_dispatch_topWeight = _paramterSettingDic.value(forKey: "design_dispatch_topWeight") as? Double{
                    cell.parameterValue.text = "\(Int(design_dispatch_topWeight * 100))"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            }
        case .DSHangUpSetting:
            // print("设计师派单配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "最少保证在线设计师数(人)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "人"
                cell.parameterValue.text = "3"
                cell.textFieldDefaultValue = 3
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designer_onlineLimit = _paramterSettingDic.value(forKey: "designer_onlineLimit") as? Int{
                    cell.parameterValue.text = "\(designer_onlineLimit)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            }
        case .DSDesignFeeSetting:
            // print("设计费配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "设计费最小值(元)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_default = _paramterSettingDic.value(forKey: "designFee_default") as? Int{
                    cell.parameterValue.text = "\(designFee_default)"
                }
            case 1:
                cell.titleLabel.text = "设计费默认比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designFee_set_default = _paramterSettingDic.value(forKey: "designFee_set_default") as? Double{
                    cell.parameterValue.text = "\(Int(designFee_set_default * 100))"
                }
            case 2:
                cell.titleLabel.text = "引导费比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designGuideFee_set_default = _paramterSettingDic.value(forKey: "designGuideFee_set_default") as? Double{
                    cell.parameterValue.text = "\(Int(designGuideFee_set_default * 100))"
                }
            case 3:
                cell.titleLabel.text = "设计费最大值取值比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "20"
                cell.textFieldDefaultValue = 20
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                if let designFee_set_defaultMaxValue = _paramterSettingDic.value(forKey: "designFee_set_defaultMaxValue") as? Double{
                    cell.parameterValue.text = "\(Int(designFee_set_defaultMaxValue * 100))"
                }
            case 4:
                cell.titleLabel.text = "设计费最大值(元)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_Max = _paramterSettingDic.value(forKey: "designFee_Max") as? Int{
                    cell.parameterValue.text = "\(designFee_Max)"
                }
            case 5:
                cell.titleLabel.text = "设计费最小值"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let designFee_Min = _paramterSettingDic.value(forKey: "designFee_Min") as? Int{
                    cell.parameterValue.text = "\(designFee_Min)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            }
        case .AutoPricingSetting:
            // print("自动报价配置")
            switch indexPath.row{
            case 0:
                cell.titleLabel.text = "3D打印自动报价最低值(元)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "100.0"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
                if let autoPrice_3dQuote_minValue = _paramterSettingDic.value(forKey: "autoPrice_3dQuote_minValue") as? Int{
                    cell.parameterValue.text = "\(autoPrice_3dQuote_minValue)"
                }
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            }
        default:
            print("Will Never Execute")
            
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .white)
        navBar.barTintColor = UIColor.backgroundColors(color: .white)
        navBar.isTranslucent = false //关闭模糊效果
        
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        
        //添加左侧
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        setupUI(with: _parameterType)
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setupUI(with parameterType:parameterSettingType){

        initParameter(for: _parameterType)
        self.view.addSubview(paraterSettingListTable)
        self.view.addSubview(saveParameterBtn)
    }
    @objc func saveParameterBtnClicked(){
        self.view.addSubview(self.doubleCheckNoticeBGView)
        checkAndTransferDataBeforeSave(parameterType: _parameterType, beforeDictionary: _savedParameterSettingDic, afterDictionary: _paramterSettingDic)
        print("\(_paramterSettingDic)")
//        UIApplication.shared.statusBarView?.addSubview(self.fadeStatusBarBackgroundView)
//        self.faceStatusBarView.removeAll()
       // self.faceStatusBarView.append(self.fadeStatusBarBackgroundView)
    }

    @objc func cancelUpdateClicked(){
        self.doubleCheckNoticeBGView.removeFromSuperview()
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
   
    fileprivate func checkAndTransferDataBeforeSave(parameterType type:parameterSettingType, beforeDictionary:NSMutableDictionary,afterDictionary:NSMutableDictionary){
        switch type {
        case .CSCreateOrderSetting:
            //客服限制接单
            secondTitleOfDoubleCheck.isHidden = false
            thirdTitleOfDoubleCheck.isHidden = false
            fouthTitleOfDoubleCheck.isHidden = false
            fifthTitleOfDoubleCheck.isHidden = false
            sixthTitleOfDoubleCheck.isHidden = false
            seventhTitleOfDoubleCheck.isHidden = true
            
            secondBeforeValueOfDoubleCheck.isHidden = false
            thirdBeforeValueOfDoubleCheck.isHidden = false
            fouthBeforeValueOfDoubleCheck.isHidden = false
            fifthBeforeValueOfDoubleCheck.isHidden = false
            sixthBeforeValueOfDoubleCheck.isHidden = false
            seventhBeforeValueOfDoubleCheck.isHidden = true
            
            secondAfterValueOfDoubleCheck.isHidden = false
            thirdAfterValueOfDoubleCheck.isHidden = false
            fouthAfterValueOfDoubleCheck.isHidden = false
            fifthAfterValueOfDoubleCheck.isHidden = false
            sixthAfterValueOfDoubleCheck.isHidden = false
            seventhAfterValueOfDoubleCheck.isHidden = true
            
            firstTitleOfDoubleCheck.text = "参考转化率时间范围(天)"
            secondTitleOfDoubleCheck.text = "参考转化率默认值(%)"
            thirdTitleOfDoubleCheck.text = "新建订单最大数(达标)"
            fouthTitleOfDoubleCheck.text = "新建订单最大数(不达标)"
            fifthTitleOfDoubleCheck.text = "客服(达标)转化率参考范围(天)"
            sixthTitleOfDoubleCheck.text = "客服(达标)转化率参考幅度(%)"
            
            
            //1
            if let servicer_conversionRate_timeRange = afterDictionary.value(forKey: "servicer_conversionRate_timeRange") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(servicer_conversionRate_timeRange)"
            }else{
                if let servicer_conversionRate_timeRange = afterDictionary.value(forKey: "servicer_conversionRate_timeRange") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(servicer_conversionRate_timeRange)"
                }
            }
            if let servicer_conversionRate_timeRange = beforeDictionary.value(forKey: "servicer_conversionRate_timeRange") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(servicer_conversionRate_timeRange)"
            }
            //2
            if let servicer_conversionRate_default = afterDictionary.value(forKey: "servicer_conversionRate_default") as? Double{
                secondAfterValueOfDoubleCheck.text = "\(Int(servicer_conversionRate_default * 100))"
            }else{
                if let servicer_conversionRate_default = afterDictionary.value(forKey: "servicer_conversionRate_default") as? String{
                    secondAfterValueOfDoubleCheck.text = "\(Int(Double(servicer_conversionRate_default as! String)! * 100))"
                }
            }
            
            if let servicer_conversionRate_default = beforeDictionary.value(forKey: "servicer_conversionRate_default") as? Double{
                secondBeforeValueOfDoubleCheck.text = "\(Int(servicer_conversionRate_default * 100))"
            }
            //3
            if let servicer_createLimit_reachedLimit = afterDictionary.value(forKey: "servicer_createLimit_reachedLimit") as? Int{
                thirdAfterValueOfDoubleCheck.text = "\(servicer_createLimit_reachedLimit)"
            }else{
                if let servicer_createLimit_reachedLimit = afterDictionary.value(forKey: "servicer_createLimit_reachedLimit") as? String{
                    thirdAfterValueOfDoubleCheck.text = "\(servicer_createLimit_reachedLimit)"
                }
            }
            if let servicer_createLimit_reachedLimit = beforeDictionary.value(forKey: "servicer_createLimit_reachedLimit") as? Int{
                thirdBeforeValueOfDoubleCheck.text = "\(servicer_createLimit_reachedLimit)"
            }
            //4
            if let servicer_createLimit_unreachedLimit = afterDictionary.value(forKey: "servicer_createLimit_unreachedLimit") as? Int{
                fouthAfterValueOfDoubleCheck.text = "\(servicer_createLimit_unreachedLimit)"
            }else{
                if let servicer_createLimit_unreachedLimit = afterDictionary.value(forKey: "servicer_createLimit_unreachedLimit") as? String{
                    fouthAfterValueOfDoubleCheck.text = "\(servicer_createLimit_unreachedLimit)"
                }
            }
            if let servicer_createLimit_unreachedLimit = beforeDictionary.value(forKey: "servicer_createLimit_unreachedLimit") as? Int{
                fouthBeforeValueOfDoubleCheck.text = "\(servicer_createLimit_unreachedLimit)"
            }
            //5
            if let servicer_conversionRecentDay_timeRange = afterDictionary.value(forKey: "servicer_conversionRecentDay_timeRange") as? Int{
                fifthAfterValueOfDoubleCheck.text = "\(servicer_conversionRecentDay_timeRange)"
            }else{
                if let servicer_conversionRecentDay_timeRange = afterDictionary.value(forKey: "servicer_conversionRecentDay_timeRange") as? String{
                    fifthAfterValueOfDoubleCheck.text = "\(servicer_conversionRecentDay_timeRange)"
                }
            }
            if let servicer_conversionRecentDay_timeRange = beforeDictionary.value(forKey: "servicer_conversionRecentDay_timeRange") as? Int{
                fifthBeforeValueOfDoubleCheck.text = "\(servicer_conversionRecentDay_timeRange)"
            }
            //6
            if let servicer_conversionRate_percentage = afterDictionary.value(forKey: "servicer_conversionRate_percentage") as? Double{
                sixthAfterValueOfDoubleCheck.text = "\(Int(servicer_conversionRate_percentage * 100))"
            }else{
                if let servicer_conversionRate_percentage = afterDictionary.value(forKey: "servicer_conversionRate_percentage") as? String{
                    sixthAfterValueOfDoubleCheck.text = "\(Int(Double(servicer_conversionRate_percentage as! String)! * 100))"
                }
            }
            if let servicer_conversionRate_percentage = beforeDictionary.value(forKey: "servicer_conversionRate_percentage") as? Double{
                sixthBeforeValueOfDoubleCheck.text = "\(Int(servicer_conversionRate_percentage * 100))"
            }

        case .MGFollowOrderSetting:
           // print("经理跟单配置")
            secondTitleOfDoubleCheck.isHidden = false
            thirdTitleOfDoubleCheck.isHidden = true
            fouthTitleOfDoubleCheck.isHidden = true
            fifthTitleOfDoubleCheck.isHidden = true
            sixthTitleOfDoubleCheck.isHidden = true
            seventhTitleOfDoubleCheck.isHidden = true
            
            secondAfterValueOfDoubleCheck.isHidden = false
            thirdAfterValueOfDoubleCheck.isHidden = true
            fouthAfterValueOfDoubleCheck.isHidden = true
            fifthAfterValueOfDoubleCheck.isHidden = true
            sixthAfterValueOfDoubleCheck.isHidden = true
            seventhAfterValueOfDoubleCheck.isHidden = true
            
            secondBeforeValueOfDoubleCheck.isHidden = false
            thirdBeforeValueOfDoubleCheck.isHidden = true
            fouthBeforeValueOfDoubleCheck.isHidden = true
            fifthBeforeValueOfDoubleCheck.isHidden = true
            sixthBeforeValueOfDoubleCheck.isHidden = true
            seventhBeforeValueOfDoubleCheck.isHidden = true
            
            firstTitleOfDoubleCheck.text = "待跟大单时间范围(天)"
            secondTitleOfDoubleCheck.text = "待跟大单选取比例(%)"
            
            //1
            if let manager_follow_timeRange = afterDictionary.value(forKey: "manager_follow_timeRange") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(manager_follow_timeRange)"
            }else{
                if let manager_follow_timeRange = afterDictionary.value(forKey: "manager_follow_timeRange") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(manager_follow_timeRange)"
                }
            }
            if let manager_follow_timeRange = beforeDictionary.value(forKey: "manager_follow_timeRange") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(manager_follow_timeRange)"
            }
            //2
            if let manager_follow_top = afterDictionary.value(forKey: "manager_follow_top") as? Double{
                secondAfterValueOfDoubleCheck.text = "\(Int(manager_follow_top * 100))"
            }else{
                if let manager_follow_top = afterDictionary.value(forKey: "manager_follow_top") as? String{
                    secondAfterValueOfDoubleCheck.text = "\(Int(Double(manager_follow_top as! String)! * 100))"
                }
            }
            if let manager_follow_top = beforeDictionary.value(forKey: "manager_follow_top") as? Double{
                secondBeforeValueOfDoubleCheck.text = "\(Int(manager_follow_top * 100))"
            }
           
        case .DSDistributeOrderSetting:
           // print("设计派单跟单配置")
            secondTitleOfDoubleCheck.isHidden = false
            thirdTitleOfDoubleCheck.isHidden = false
            fouthTitleOfDoubleCheck.isHidden = false
            fifthTitleOfDoubleCheck.isHidden = false
            sixthTitleOfDoubleCheck.isHidden = false
            seventhTitleOfDoubleCheck.isHidden = false
            
            secondAfterValueOfDoubleCheck.isHidden = false
            thirdAfterValueOfDoubleCheck.isHidden = false
            fouthAfterValueOfDoubleCheck.isHidden = false
            fifthAfterValueOfDoubleCheck.isHidden = false
            sixthAfterValueOfDoubleCheck.isHidden = false
            seventhAfterValueOfDoubleCheck.isHidden = false
            
            secondBeforeValueOfDoubleCheck.isHidden = false
            thirdBeforeValueOfDoubleCheck.isHidden = false
            fouthBeforeValueOfDoubleCheck.isHidden = false
            fifthBeforeValueOfDoubleCheck.isHidden = false
            sixthBeforeValueOfDoubleCheck.isHidden = false
            seventhBeforeValueOfDoubleCheck.isHidden = false
            
            firstTitleOfDoubleCheck.text = "设计派单轮换时间(秒)"
            secondTitleOfDoubleCheck.text = "设计权重-设计单权重"
            thirdTitleOfDoubleCheck.text = "设计权重-修改单权重"
            fouthTitleOfDoubleCheck.text = "设计权重-出图时间权重"
            fifthTitleOfDoubleCheck.text = "设计权重-拒单率权重"
            sixthTitleOfDoubleCheck.text = "设计权重-定稿率权重"
            seventhTitleOfDoubleCheck.text = "设计师选取比例(%)"
            if let design_dispatch_timeInterval = afterDictionary.value(forKey: "design_dispatch_timeInterval") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(design_dispatch_timeInterval)"
            }else{
                if let design_dispatch_timeInterval = afterDictionary.value(forKey: "design_dispatch_timeInterval") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(design_dispatch_timeInterval)"
                }
            }
            if let design_dispatch_timeInterval = beforeDictionary.value(forKey: "design_dispatch_timeInterval") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(design_dispatch_timeInterval)"
            }
            //2
            if let design_weight_designNum = afterDictionary.value(forKey: "design_weight_designNum") as? Int{
                secondAfterValueOfDoubleCheck.text = "\(design_weight_designNum)"
            }else{
                if let design_weight_designNum = afterDictionary.value(forKey: "design_weight_designNum") as? String{
                    secondAfterValueOfDoubleCheck.text = "\(design_weight_designNum)"
                }
            }
            if let design_weight_designNum = beforeDictionary.value(forKey: "design_weight_designNum") as? Int{
                secondBeforeValueOfDoubleCheck.text = "\(design_weight_designNum)"
            }
            //3
            if let design_weight_modifyNum = afterDictionary.value(forKey: "design_weight_modifyNum") as? Int{
                thirdAfterValueOfDoubleCheck.text = "\(design_weight_modifyNum)"
            }else{
                if let design_weight_modifyNum = afterDictionary.value(forKey: "design_weight_modifyNum") as? String{
                    thirdAfterValueOfDoubleCheck.text = "\(design_weight_modifyNum)"
                }
            }
            if let design_weight_modifyNum = beforeDictionary.value(forKey: "design_weight_modifyNum") as? Int{
                thirdBeforeValueOfDoubleCheck.text = "\(design_weight_modifyNum)"
            }
            //4
            if let design_weight_averageDesignTime = afterDictionary.value(forKey: "design_weight_averageDesignTime") as? Int{
                fouthAfterValueOfDoubleCheck.text = "\(design_weight_averageDesignTime)"
            }else{
                if let design_weight_averageDesignTime = afterDictionary.value(forKey: "design_weight_averageDesignTime") as? String{
                    fouthAfterValueOfDoubleCheck.text = "\(design_weight_averageDesignTime)"
                }
            }
            if let design_weight_averageDesignTime = beforeDictionary.value(forKey: "design_weight_averageDesignTime") as? Int{
                fouthBeforeValueOfDoubleCheck.text = "\(design_weight_averageDesignTime)"
            }
            //5
            if let design_weight_refuseRate = afterDictionary.value(forKey: "design_weight_refuseRate") as? Int{
                fifthAfterValueOfDoubleCheck.text = "\(design_weight_refuseRate)"
            }else{
                if let design_weight_refuseRate = afterDictionary.value(forKey: "design_weight_refuseRate") as? String{
                    fifthAfterValueOfDoubleCheck.text = "\(design_weight_refuseRate)"
                }
            }
            if let design_weight_refuseRate = beforeDictionary.value(forKey: "design_weight_refuseRate") as? Int{
                fifthBeforeValueOfDoubleCheck.text = "\(design_weight_refuseRate)"
            }
            //6
            if let design_weight_adoptRate = afterDictionary.value(forKey: "design_weight_adoptRate") as? Int{
                sixthAfterValueOfDoubleCheck.text = "\(design_weight_adoptRate)"
            }else{
                if let design_weight_adoptRate = afterDictionary.value(forKey: "design_weight_adoptRate") as? String{
                    sixthAfterValueOfDoubleCheck.text = "\(design_weight_adoptRate)"
                }
            }
            if let design_weight_adoptRate = beforeDictionary.value(forKey: "design_weight_adoptRate") as? Int{
                sixthBeforeValueOfDoubleCheck.text = "\(design_weight_adoptRate)"
            }
            //7
            if let design_dispatch_topWeight = afterDictionary.value(forKey: "design_dispatch_topWeight") as? Double{
                seventhAfterValueOfDoubleCheck.text = "\(Int(design_dispatch_topWeight * 100))"
            }else{
                if let design_dispatch_topWeight = afterDictionary.value(forKey: "design_dispatch_topWeight") as? String{
                    seventhAfterValueOfDoubleCheck.text = "\(Int(Double(design_dispatch_topWeight as! String)! * 100))"
                }
            }
            if let design_dispatch_topWeight = beforeDictionary.value(forKey: "design_dispatch_topWeight") as? Double{
                seventhBeforeValueOfDoubleCheck.text = "\(Int(design_dispatch_topWeight * 100))"
            }
            
        case .DSHangUpSetting:
            //print("设计师派单配置")
            secondTitleOfDoubleCheck.isHidden = true
            thirdTitleOfDoubleCheck.isHidden = true
            fouthTitleOfDoubleCheck.isHidden = true
            fifthTitleOfDoubleCheck.isHidden = true
            sixthTitleOfDoubleCheck.isHidden = true
            seventhTitleOfDoubleCheck.isHidden = true
            
            secondAfterValueOfDoubleCheck.isHidden = true
            thirdAfterValueOfDoubleCheck.isHidden = true
            fouthAfterValueOfDoubleCheck.isHidden = true
            fifthAfterValueOfDoubleCheck.isHidden = true
            sixthAfterValueOfDoubleCheck.isHidden = true
            seventhAfterValueOfDoubleCheck.isHidden = true
            
            secondBeforeValueOfDoubleCheck.isHidden = true
            thirdBeforeValueOfDoubleCheck.isHidden = true
            fouthBeforeValueOfDoubleCheck.isHidden = true
            fifthBeforeValueOfDoubleCheck.isHidden = true
            sixthBeforeValueOfDoubleCheck.isHidden = true
            seventhBeforeValueOfDoubleCheck.isHidden = true
            
            firstTitleOfDoubleCheck.text = "最少保证在线设计师数(人)"
            if let designer_onlineLimit = afterDictionary.value(forKey: "designer_onlineLimit") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(designer_onlineLimit)"
            }else{
                if let designer_onlineLimit = afterDictionary.value(forKey: "designer_onlineLimit") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(designer_onlineLimit)"
                }
            }
            if let designer_onlineLimit = beforeDictionary.value(forKey: "designer_onlineLimit") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(designer_onlineLimit)"
            }
            

        case .DSDesignFeeSetting:
           // print("设计费配置")
            secondTitleOfDoubleCheck.isHidden = false
            thirdTitleOfDoubleCheck.isHidden = false
            fouthTitleOfDoubleCheck.isHidden = false
            fifthTitleOfDoubleCheck.isHidden = false
            sixthTitleOfDoubleCheck.isHidden = true
            seventhTitleOfDoubleCheck.isHidden = true
            
            secondAfterValueOfDoubleCheck.isHidden = false
            thirdAfterValueOfDoubleCheck.isHidden = false
            fouthAfterValueOfDoubleCheck.isHidden = false
            fifthAfterValueOfDoubleCheck.isHidden = false
            sixthAfterValueOfDoubleCheck.isHidden = true
            seventhAfterValueOfDoubleCheck.isHidden = true
            
            secondBeforeValueOfDoubleCheck.isHidden = false
            thirdBeforeValueOfDoubleCheck.isHidden = false
            fouthBeforeValueOfDoubleCheck.isHidden = false
            fifthBeforeValueOfDoubleCheck.isHidden = false
            sixthBeforeValueOfDoubleCheck.isHidden = true
            seventhBeforeValueOfDoubleCheck.isHidden = true
            
            firstTitleOfDoubleCheck.text = "设计费最小值(元)"
            secondTitleOfDoubleCheck.text = "设计费默认比例(%)"
            thirdTitleOfDoubleCheck.text = "引导费比例(%)"
            fouthTitleOfDoubleCheck.text = "设计费取汁比例(%)"
            fifthTitleOfDoubleCheck.text = "设计费最大值(元)"
            sixthTitleOfDoubleCheck.text = "设计费最小值(元)"
            if let designFee_default = afterDictionary.value(forKey: "designFee_default") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(designFee_default)"
            }else{
                if let designFee_default = afterDictionary.value(forKey: "designFee_default") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(designFee_default)"
                }
            }
            if let designFee_default = beforeDictionary.value(forKey: "designFee_default") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(designFee_default)"
            }
            //2
            if let designFee_set_default = afterDictionary.value(forKey: "designFee_set_default") as? Double{
                secondAfterValueOfDoubleCheck.text = "\(Int(designFee_set_default * 100))"
            }else{
                if let designFee_set_default = afterDictionary.value(forKey: "designFee_set_default") as? String{
                    secondAfterValueOfDoubleCheck.text = "\(Int(Double(designFee_set_default as! String)! * 100))"
                }
            }
            if let designFee_set_default = beforeDictionary.value(forKey: "designFee_set_default") as? Double{
                secondBeforeValueOfDoubleCheck.text = "\(Int(designFee_set_default * 100))"
            }
            //3
            if let designGuideFee_set_default = afterDictionary.value(forKey: "designGuideFee_set_default") as? Double{
                thirdAfterValueOfDoubleCheck.text = "\(Int(designGuideFee_set_default * 100))"
            }else{
                if let designGuideFee_set_default = afterDictionary.value(forKey: "designGuideFee_set_default") as? String{
                    thirdAfterValueOfDoubleCheck.text = "\(Int(Double(designGuideFee_set_default as! String)! * 100))"
                }
            }
            if let designGuideFee_set_default = beforeDictionary.value(forKey: "designGuideFee_set_default") as? Double{
                thirdBeforeValueOfDoubleCheck.text = "\(Int(designGuideFee_set_default * 100))"
            }
            //4
            if let designFee_set_defaultMaxValue = afterDictionary.value(forKey: "designFee_set_defaultMaxValue") as? Double{
                fouthAfterValueOfDoubleCheck.text = "\(Int(designFee_set_defaultMaxValue * 100))"
            }else{
                if let designFee_set_defaultMaxValue = afterDictionary.value(forKey: "designFee_set_defaultMaxValue") as? String{
                    fouthAfterValueOfDoubleCheck.text = "\(Int(Double(designFee_set_defaultMaxValue as String)! * 100))"
                }
            }
            if let designFee_set_defaultMaxValue = beforeDictionary.value(forKey: "designFee_set_defaultMaxValue") as? Double{
                fouthBeforeValueOfDoubleCheck.text = "\(Int(designFee_set_defaultMaxValue * 100))"
            }
            //5
            if let designFee_Max = afterDictionary.value(forKey: "designFee_Max") as? Int{
                fifthAfterValueOfDoubleCheck.text = "\(designFee_Max)"
            }else{
                if let designFee_Max = afterDictionary.value(forKey: "designFee_Max") as? String{
                    fifthAfterValueOfDoubleCheck.text = "\(designFee_Max)"
                }
            }
            if let designFee_Max = beforeDictionary.value(forKey: "designFee_Max") as? Int{
                fifthBeforeValueOfDoubleCheck.text = "\(designFee_Max)"
            }
            //6
            if let designFee_Min = afterDictionary.value(forKey: "designFee_Min") as? Int{
                sixthAfterValueOfDoubleCheck.text = "\(designFee_Min)"
            }else{
                if let designFee_Min = afterDictionary.value(forKey: "designFee_Min") as? String{
                    sixthAfterValueOfDoubleCheck.text = "\(designFee_Min)"
                }
            }
            if let designFee_Min = beforeDictionary.value(forKey: "designFee_Min") as? Int{
                sixthBeforeValueOfDoubleCheck.text = "\(designFee_Min)"
            }
        case .AutoPricingSetting:
            // print("自动报价")
            secondTitleOfDoubleCheck.isHidden = true
            thirdTitleOfDoubleCheck.isHidden = true
            fouthTitleOfDoubleCheck.isHidden = true
            fifthTitleOfDoubleCheck.isHidden = true
            sixthTitleOfDoubleCheck.isHidden = true
            seventhTitleOfDoubleCheck.isHidden = true
            
            secondAfterValueOfDoubleCheck.isHidden = true
            thirdAfterValueOfDoubleCheck.isHidden = true
            fouthAfterValueOfDoubleCheck.isHidden = true
            fifthAfterValueOfDoubleCheck.isHidden = true
            sixthAfterValueOfDoubleCheck.isHidden = true
            seventhAfterValueOfDoubleCheck.isHidden = true
            
            secondBeforeValueOfDoubleCheck.isHidden = true
            thirdBeforeValueOfDoubleCheck.isHidden = true
            fouthBeforeValueOfDoubleCheck.isHidden = true
            fifthBeforeValueOfDoubleCheck.isHidden = true
            sixthBeforeValueOfDoubleCheck.isHidden = true
            seventhBeforeValueOfDoubleCheck.isHidden = true
            
            firstTitleOfDoubleCheck.text = "3D打印自动报价最低值(元)"

            if let autoPrice_3dQuote_minValue = afterDictionary.value(forKey: "autoPrice_3dQuote_minValue") as? Int{
                firstAfterValueOfDoubleCheck.text = "\(autoPrice_3dQuote_minValue)"
            }else{
                if let autoPrice_3dQuote_minValue = afterDictionary.value(forKey: "autoPrice_3dQuote_minValue") as? String{
                    firstAfterValueOfDoubleCheck.text = "\(autoPrice_3dQuote_minValue)"
                }
            }
            if let autoPrice_3dQuote_minValue = beforeDictionary.value(forKey: "autoPrice_3dQuote_minValue") as? Int{
                firstBeforeValueOfDoubleCheck.text = "\(autoPrice_3dQuote_minValue)"
            }
           
            
        default:
            print("客服新建订单限制配置")
        }
    }
    //初始化页面
    fileprivate func initParameter(for parameterType:parameterSettingType){
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
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "paramterSettingInitAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "paramterSettingInitAPI") as! String
        #endif
        
        _ = Alamofire.request(requestUrl,method:.get,encoding: URLEncoding.default,headers:header) .responseJSON{ //, parameters:params as? [String:AnyObject]
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        let dic = json["data"].dictionaryObject as! NSDictionary
                        
                        self._paramterSettingDic.setDictionary(dic as! [AnyHashable : Any])
                        self._savedParameterSettingDic.setDictionary(dic as! [AnyHashable : Any])
//                        self._paramterSettingDic = dic
//                        self._savedParameterSettingDic = dic
                        self.saveParameterBtn.isEnabled = true
                        self.paraterSettingListTable.reloadData()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        self.saveParameterBtn.isEnabled = false
                        print("获取参数失败")
                    }
                }
            case false:
                print("获取列表失败")
                greyLayerPrompt.show(text: "获取参数失败,请返回上一页再试,请重试")
                self.saveParameterBtn.isEnabled = true
                
            }
        }
    }
    
    //初始化页面
    @objc func confirmSubmitParameterClicked(){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        let userId = userInfos.value(forKey: "userid") as? String
        guard userId == "10000005" || userId == "10000029" || userId == "1000055" else {
            greyLayerPrompt.show(text: "您没有修改参数权限")
            return
        }
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        
        header["token"] = token

        params["servicer_conversionRate_timeRange"] = _paramterSettingDic.value(forKey: "servicer_conversionRate_timeRange")
        params["servicer_conversionRate_default"] = _paramterSettingDic.value(forKey: "servicer_conversionRate_default")
        params["servicer_createLimit_reachedLimit"] = _paramterSettingDic.value(forKey: "servicer_createLimit_reachedLimit")
        params["servicer_createLimit_unreachedLimit"] = _paramterSettingDic.value(forKey: "servicer_createLimit_unreachedLimit")
        params["servicer_conversionRecentDay_timeRange"] = _paramterSettingDic.value(forKey: "servicer_conversionRecentDay_timeRange")
        params["servicer_conversionRate_percentage"] = _paramterSettingDic.value(forKey: "servicer_conversionRate_percentage")
            
        params["manager_follow_timeRange"] = _paramterSettingDic.value(forKey: "manager_follow_timeRange")
        params["manager_follow_top"] = _paramterSettingDic.value(forKey: "manager_follow_top")

        params["design_dispatch_timeInterval"] = _paramterSettingDic.value(forKey: "design_dispatch_timeInterval")
        params["design_weight_designNum"] = _paramterSettingDic.value(forKey: "design_weight_designNum")
        params["design_weight_modifyNum"] = _paramterSettingDic.value(forKey: "design_weight_modifyNum")
        params["design_weight_averageDesignTime"] = _paramterSettingDic.value(forKey: "design_weight_averageDesignTime")
        params["design_weight_refuseRate"] = _paramterSettingDic.value(forKey: "design_weight_refuseRate")
        params["design_weight_adoptRate"] = _paramterSettingDic.value(forKey: "design_weight_adoptRate")
        params["design_dispatch_topWeight"] = _paramterSettingDic.value(forKey: "design_dispatch_topWeight")
            
        params["designer_onlineLimit"] = _paramterSettingDic.value(forKey: "designer_onlineLimit")
            
        params["designFee_default"] = _paramterSettingDic.value(forKey: "designFee_default")
        params["designFee_set_default"] = _paramterSettingDic.value(forKey: "designFee_set_default")
        params["designGuideFee_set_default"] = _paramterSettingDic.value(forKey: "designGuideFee_set_default")
        params["designFee_set_defaultMaxValue"] = _paramterSettingDic.value(forKey: "designFee_set_defaultMaxValue")
        params["designFee_Max"] = _paramterSettingDic.value(forKey: "designFee_Max")
        params["designFee_Min"] = _paramterSettingDic.value(forKey: "designFee_Min")
        
        params["autoPrice_3dQuote_minValue"] = _paramterSettingDic.value(forKey: "autoPrice_3dQuote_minValue")
        
        
        #if DEBUG
        let requestUrl = apiAddresses.value(forKey: "paramterSettingSubmitAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "paramterSettingSubmitAPI") as! String
        #endif
        
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        greyLayerPrompt.show(text: "参数更新成功")
                        self.cancelUpdateClicked()
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        self.saveParameterBtn.isEnabled = false
                        print("获取参数失败")
                    }
                }
            case false:
                print("获取列表失败")
                greyLayerPrompt.show(text: "获取参数失败,请返回上一页再试,请重试")
                self.saveParameterBtn.isEnabled = false
            }
        }
    }

}


