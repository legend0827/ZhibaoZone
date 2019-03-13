//
//  pamaterSettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class pamaterSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var _parameterType:parameterSettingType = .CSCreateOrderSetting
    
    lazy var titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
    
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
            return 4
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
            return 6
        default:
           // print("客服新建订单限制配置")
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = parameterSettingListTableViewCell.customCell(tableView: paraterSettingListTable)
        cell.selectionStyle = .none
        
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
            case 1:
                cell.titleLabel.text = "参考转化率默认值(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
                
            case 2:
                cell.titleLabel.text = "新建订单最大数(达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "12"
                cell.textFieldDefaultValue = 12
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            case 3:
                cell.titleLabel.text = "新建订单最大数(不达标)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "单"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
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
            case 1:
                cell.titleLabel.text = "待跟大单选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "5"
                cell.textFieldDefaultValue = 5
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
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
            case 1:
                cell.titleLabel.text = "设计权重-设计单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
            case 2:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
            case 3:
                cell.titleLabel.text = "设计权重-出图时间权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
            case 4:
                cell.titleLabel.text = "设计权重-拒单率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
            case 5:
                cell.titleLabel.text = "设计权重-定稿率权重"
                cell.parameterValue.placeholder = "100 - 500"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 100
                cell.textFieldMaxValue = 500
            case 6:
                cell.titleLabel.text = "设计师选取比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
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
                cell.titleLabel.text = "设计费默认值(元)"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            case 1:
                cell.titleLabel.text = "设计费默认比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            case 2:
                cell.titleLabel.text = "引导费比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "30"
                cell.textFieldDefaultValue = 30
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            case 3:
                cell.titleLabel.text = "设计费最大值取值比例(%)"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "%"
                cell.parameterValue.text = "20"
                cell.textFieldDefaultValue = 20
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
            case 4:
                cell.titleLabel.text = "设计费最大值"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "100"
                cell.textFieldDefaultValue = 100
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            case 5:
                cell.titleLabel.text = "设计费最小值"
                cell.parameterValue.placeholder = "0 - 999"
                cell.parameteUnit.text = "元"
                cell.parameterValue.text = "8"
                cell.textFieldDefaultValue = 8
                cell.textFieldMinValue = 0
                cell.textFieldMaxValue = 999
            default:
                cell.titleLabel.text = "设计权重-修改单权重"
                cell.parameterValue.placeholder = "1 - 100"
                cell.parameteUnit.text = "-"
                cell.parameterValue.text = "60"
                cell.textFieldDefaultValue = 60
                cell.textFieldMinValue = 1
                cell.textFieldMaxValue = 100
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
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
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
        switch parameterType {
        case .CSCreateOrderSetting:
            print("客服新建订单限制配置")
        case .MGFollowOrderSetting:
            print("经理跟单配置")
        case .DSDistributeOrderSetting:
            print("设计派单跟单配置")
        case .DSHangUpSetting:
            print("设计师派单配置")
        case .DSDesignFeeSetting:
            print("设计费配置")
        default:
            print("客服新建订单限制配置")
        }
        
        self.view.addSubview(paraterSettingListTable) 
    }

    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


