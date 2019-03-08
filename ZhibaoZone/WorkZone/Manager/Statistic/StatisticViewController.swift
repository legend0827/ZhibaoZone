//
//  StatisticViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/17.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class StatisticViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let statisticCount = statisticData.count + allShopStatisticData.count
        return statisticCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statisticTableViewCell.customCell(tableView: statisticTableView)
        
        cell.compositeIndexLabel.isHidden = true
        cell.acceptOrderCountLabel.isHidden = true
        cell.dealOrderCountLabel.isHidden = true
        cell.acceptOrderAmountLabel.isHidden = true
        cell.dealOrderAmountLabel.isHidden = true
        cell.transferRateLabel.isHidden = true
        cell.singleOrderPriceLabel.isHidden = true
        cell.AverageDealTimeLabel.isHidden = true
        cell.quoteRateLabel.isHidden = true
        cell.AverageDesignPriceLabel.isHidden = true
        
        cell.designRefuseRateLabel.isHidden = true
        cell.designTransferRateLabel.isHidden = true
        cell.designDealOrderCountLabel.isHidden = true
        cell.designAcceptOrderCountLabel.isHidden = true
        cell.designAverageDesignTimeLabel.isHidden = true
        cell.designDealOrderAmountLabel.isHidden = true
        cell.designAcceptOrderAmountLabel.isHidden = true
        cell.designAverageDesignPriceLabel.isHidden = true
        
        cell.facSendOrderCountLabel.isHidden = true
        cell.facAverageSendTimeLabel.isHidden = true
        cell.facQuoteOrderCountLabel.isHidden = true
        cell.facAcceptOrderCountLabel.isHidden = true
        cell.facAverageQuoteTimeLabel.isHidden = true
        cell.facInquryOrderCountLabel.isHidden = true
        cell.facAcceptOrderAmountLabel.isHidden = true
        
        switch statisticRoleType {
        case 1://客服
            
            cell.compositeIndexLabel.isHidden = false
            cell.acceptOrderCountLabel.isHidden = false
            cell.dealOrderCountLabel.isHidden = false
            cell.acceptOrderAmountLabel.isHidden = false
            cell.dealOrderAmountLabel.isHidden = false
            cell.transferRateLabel.isHidden = false
            cell.singleOrderPriceLabel.isHidden = false
            cell.AverageDealTimeLabel.isHidden = false
            cell.quoteRateLabel.isHidden = false
            cell.AverageDesignPriceLabel.isHidden = false
            
            if !isDataLoading {
            if indexPath.row == 0{
                if !allShopStatisticData.isEmpty{
                    cell.userNickName.text = "所有客服"
                    cell.compositeIndexLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "composite") as! Double)
                    cell.acceptOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                    cell.dealOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "clinchNumber") as! Int)"
                    cell.acceptOrderAmountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "acceptPrice") as! Double)"
                    cell.dealOrderAmountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "clinchprice") as! Double)"
                    cell.transferRateLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "changeSize") as! Double * 100) + "%"
                    cell.singleOrderPriceLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "price") as! Double)
                    cell.AverageDealTimeLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "averageTime") as! String)"
                    cell.quoteRateLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "enquiry") as! Double * 100) + "%"
                    cell.AverageDesignPriceLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "designePrice") as! Double)
                    
                }else{
                    cell.userNickName.text = "所有客服"
                    cell.compositeIndexLabel.text = "--"
                    cell.acceptOrderCountLabel.text = "--"
                    cell.dealOrderCountLabel.text = "--"
                    cell.acceptOrderAmountLabel.text = "--"
                    cell.dealOrderAmountLabel.text = "--"
                    cell.transferRateLabel.text = "--"
                    cell.singleOrderPriceLabel.text = "--"
                    cell.AverageDealTimeLabel.text = "--"
                    cell.quoteRateLabel.text = "--"
                    cell.AverageDesignPriceLabel.text = "--"
                }
            }else{
                cell.userNickName.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "userName") as! String)"
                cell.compositeIndexLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "composite") as! Double)
                cell.acceptOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                cell.dealOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "clinchNumber") as! Int)"
                cell.acceptOrderAmountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptPrice") as! Double)"
                cell.dealOrderAmountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "clinchprice") as! Double)"
                cell.transferRateLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "changeSize") as! Double * 100) + "%"//"\()%"
                cell.singleOrderPriceLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "price") as! Double)
                cell.AverageDealTimeLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "averageTime") as! String)"
                cell.quoteRateLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "enquiry") as! Double * 100) + "%"
                cell.AverageDesignPriceLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "designePrice") as! Double)
                }
                
            }else{
                cell.userNickName.text = "--"
                cell.compositeIndexLabel.text = "--"
                cell.acceptOrderCountLabel.text = "--"
                cell.dealOrderCountLabel.text = "--"
                cell.acceptOrderAmountLabel.text = "--"
                cell.dealOrderAmountLabel.text = "--"
                cell.transferRateLabel.text = "--"
                cell.singleOrderPriceLabel.text = "--"
                cell.AverageDealTimeLabel.text = "--"
                cell.quoteRateLabel.text = "--"
                cell.AverageDesignPriceLabel.text = "--"
            }
        case 2: //设计师
            cell.designRefuseRateLabel.isHidden = false
            cell.designTransferRateLabel.isHidden = false
            cell.designDealOrderCountLabel.isHidden = false
            cell.designAcceptOrderCountLabel.isHidden = false
            cell.designAverageDesignTimeLabel.isHidden = false
            cell.designDealOrderAmountLabel.isHidden = false
            cell.designAcceptOrderAmountLabel.isHidden = false
            cell.designAverageDesignPriceLabel.isHidden = false
            if !isDataLoading{
                if indexPath.row == 0{
                    if !allShopStatisticData.isEmpty{
                        cell.userNickName.text = "所有设计"
                        cell.designAcceptOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                        cell.designDealOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "finalizeNumber") as! Int)"
                        cell.designAcceptOrderAmountLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "acceptPrice") as! Double)
                        cell.designDealOrderAmountLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "finalizePrice") as! Double)
                        cell.designTransferRateLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "finalizeRatio") as! Double * 100) + "%"
                        cell.designRefuseRateLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "refuseRate") as! Double * 100) + "%"
                        cell.designAverageDesignTimeLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "averageDesignTime") as! String)"
                        cell.designAverageDesignPriceLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "designPrice") as! Double)
                        
                        
                    }else{
                        cell.userNickName.text = "所有设计"
                        cell.designAcceptOrderCountLabel.text = "--"
                        cell.designDealOrderCountLabel.text = "--"
                        cell.designAcceptOrderAmountLabel.text = "--"
                        cell.designDealOrderAmountLabel.text = "--"
                        cell.designTransferRateLabel.text = "--"
                        cell.designRefuseRateLabel.text = "--"
                        cell.designAverageDesignTimeLabel.text = "--"
                        cell.designAverageDesignPriceLabel.text = "--"
                    }
                }else{
                    cell.userNickName.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "userName") as! String)"
                    cell.designAcceptOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                    cell.designDealOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "finalizeNumber") as! Int)"
                    cell.designAcceptOrderAmountLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptPrice") as! Double)
                    cell.designDealOrderAmountLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "finalizePrice") as! Double)
                    cell.designTransferRateLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "finalizeRatio") as! Double * 100) + "%"
                    cell.designRefuseRateLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "refuseRate") as! Double * 100) + "%"
                    cell.designAverageDesignTimeLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "averageDesignTime") as! String)"
                    cell.designAverageDesignPriceLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "designPrice") as! Double)
                }
                
            }else{
                cell.userNickName.text = "--"
                cell.designAcceptOrderCountLabel.text = "--"
                cell.designDealOrderCountLabel.text = "--"
                cell.designAcceptOrderAmountLabel.text = "--"
                cell.designDealOrderAmountLabel.text = "--"
                cell.designTransferRateLabel.text = "--"
                cell.designRefuseRateLabel.text = "--"
                cell.designAverageDesignTimeLabel.text = "--"
                cell.designAverageDesignPriceLabel.text = "--"
            }
        case 3: //车间
            cell.facSendOrderCountLabel.isHidden = false
            cell.facAverageSendTimeLabel.isHidden = false
            cell.facQuoteOrderCountLabel.isHidden = false
            cell.facAcceptOrderCountLabel.isHidden = false
            cell.facAverageQuoteTimeLabel.isHidden = false
            cell.facInquryOrderCountLabel.isHidden = false
            cell.facAcceptOrderAmountLabel.isHidden = false
            
            if !isDataLoading{
                if indexPath.row == 0{
                    if !allShopStatisticData.isEmpty{
                        cell.userNickName.text = "所有车间"
                        cell.facInquryOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "enquiryNumber") as! Int)"
                        cell.facQuoteOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "quoteNumber") as! Int)"
                        cell.facAcceptOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                        cell.facSendOrderCountLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "sendNumber") as! Int)"
                        cell.facAcceptOrderAmountLabel.text = String(format: "%.2f%", (allShopStatisticData[0] as NSDictionary).value(forKey: "acceptPrice") as! Double)
                        cell.facAverageQuoteTimeLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "averageQuoteTime") as! String)"
                        cell.facAverageSendTimeLabel.text = "\((allShopStatisticData[0] as NSDictionary).value(forKey: "averageSendTime") as! String)"
                        
                        
                    }else{
                        cell.userNickName.text = "所有车间"
                        cell.facSendOrderCountLabel.text = "--"
                        cell.facAverageSendTimeLabel.text = "--"
                        cell.facQuoteOrderCountLabel.text = "--"
                        cell.facAcceptOrderCountLabel.text = "--"
                        cell.facAverageQuoteTimeLabel.text = "--"
                        cell.facInquryOrderCountLabel.text = "--"
                        cell.facAcceptOrderAmountLabel.text = "--"
                        
                    }
                }else{
                    cell.userNickName.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "userName") as! String)"
                    cell.facInquryOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "enquiryNumber") as! Int)"
                    cell.facQuoteOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "quoteNumber") as! Int)"
                    cell.facAcceptOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptNumber") as! Int)"
                    cell.facSendOrderCountLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "sendNumber") as! Int)"
                    cell.facAcceptOrderAmountLabel.text = String(format: "%.2f%", (statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "acceptPrice") as! Double)
                    cell.facAverageQuoteTimeLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "averageQuoteTime") as! String)"
                    cell.facAverageSendTimeLabel.text = "\((statisticData[indexPath.row - 1] as NSDictionary).value(forKey: "averageSendTime") as! String)"
                    
                }
                
            }else{
                cell.userNickName.text = "--"
                cell.facSendOrderCountLabel.text = "--"
                cell.facAverageSendTimeLabel.text = "--"
                cell.facQuoteOrderCountLabel.text = "--"
                cell.facAcceptOrderCountLabel.text = "--"
                cell.facAverageQuoteTimeLabel.text = "--"
                cell.facInquryOrderCountLabel.text = "--"
                cell.facAcceptOrderAmountLabel.text = "--"
            }
        default:
            cell.userNickName.text = "--"
            cell.designAcceptOrderCountLabel.text = "--"
            cell.designDealOrderCountLabel.text = "--"
            cell.designAcceptOrderAmountLabel.text = "--"
            cell.designDealOrderAmountLabel.text = "--"
            cell.designTransferRateLabel.text = "--"
            cell.designRefuseRateLabel.text = "--"
            cell.designAverageDesignTimeLabel.text = "--"
            cell.designAverageDesignPriceLabel.text = "--"
        }
        //cell.userNickName.text = ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    
    //头部导航栏
    lazy var scrollBackgroundView:UIScrollView = {
        let tempScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: kHight, height: kWidth - 44))
        
        let headerBar = UIView.init(frame: CGRect(x: -500, y: 0, width: 1996, height: 36))
        headerBar.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        tempScrollView.addSubview(headerBar)
        
        tempScrollView.showsVerticalScrollIndicator = false
        tempScrollView.showsHorizontalScrollIndicator = false
        tempScrollView.contentSize = CGSize(width: 1036 - heightChangeForiPhoneXFromBottom, height: 36)
        //tempScrollView.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        tempScrollView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempScrollView
    }()
    //底部导航栏
    lazy var bottomNavigationBar:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: kWidth - 44, width: kHight, height: 44))
        tempView.backgroundColor = UIColor.backgroundColors(color: backgroundColorsType.lightestGray)
        return tempView
    }()
    
    //离开页面
    lazy var closeVCBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: kHight - 62, y: 0, width: 89, height: 35)
        button.setImage(UIImage(named: "closeLayericonimg"), for: .normal)
        button.addTarget(self, action: #selector(closeLayerBtnClicked), for: .touchUpInside)
        return button
    }()
    
    
    //客服统计切换tab
    lazy var customerServicerStatisticBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 15, y: 10, width: 80, height: 21)
        button.setTitle("客服统计", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(switchStatisticTypeBtnClicked), for: .touchUpInside)
        return button
    }()
    
    
    //设计统计切换tab
    lazy var designerStatisticBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 106, y: 10, width: 80, height: 21)
        button.setTitle("设计统计", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(switchStatisticTypeBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //车间统计切换tab
    lazy var factoryStatisticBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 197, y: 10, width: 80, height: 21)
        button.setTitle("车间统计", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 3
        button.addTarget(self, action: #selector(switchStatisticTypeBtnClicked), for: .touchUpInside)
        return button
    }()
    
    
    //时间选择按钮
    lazy var timeIntervalChoosenBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: kHight - 95, y: 10, width: 80, height: 21)
        button.setTitle("本月", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 55
        button.addTarget(self, action: #selector(filterBtnClicked), for: .touchUpInside)
        return button
    }()
    
    
    //品类选择按钮
    lazy var goodsClassChoosenBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: kHight - 190, y: 10, width: 80, height: 21)
        button.setTitle("不限品类", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 56
        button.addTarget(self, action: #selector(filterBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //店铺选择按钮
    lazy var shopChoosenBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: kHight - 285, y: 10, width: 80, height: 21)
        button.setTitle("不限店铺", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 15)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 57
        button.addTarget(self, action: #selector(filterBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //排序按钮
    lazy var rankingBtn1:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 1
        button.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn2:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 2
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn3:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 3
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn4:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 4
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn5:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 5
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn6:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 65, y: 5, width: 9, height: 10)
        button.tag = 6
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn7:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 64, y: 5, width: 9, height: 10)
        button.tag = 7
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn8:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 95, y: 5, width: 9, height: 10)
        button.tag = 8
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn9:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 64, y: 5, width: 9, height: 10)
        button.tag = 9
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var rankingBtn10:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 81, y: 5, width: 9, height: 10)
        button.tag = 10
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //------- 设计师ranking tag从21到28
    //设计Ranking
    lazy var rankingBtn21:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 21
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn22:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 22
        button.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn23:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 23
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn24:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 24
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn25:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 25
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn26:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 26
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn27:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 103, y: 5, width: 9, height: 10)
        button.tag = 27
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //设计Ranking
    lazy var rankingBtn28:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 91, y: 5, width: 9, height: 10)
        button.tag = 28
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //------- 车间ranking tag从31到37
    //车间Ranking
    lazy var rankingBtn31:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 31
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn32:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 32
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn33:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 33
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn34:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 34
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn35:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 71, y: 5, width: 9, height: 10)
        button.tag = 35
        button.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn36:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 95, y: 5, width: 9, height: 10)
        button.tag = 36
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //车间Ranking
    lazy var rankingBtn37:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 103, y: 5, width: 9, height: 10)
        button.tag = 37
        button.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
        button.addTarget(self, action: #selector(ringkingBtnClicked), for: .touchUpInside)
        return button
    }()
    //综合指数
    lazy var compositeIndexBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 103, y: 5, width: 80, height: 18)
        button.setTitle("综合指数", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.darkGray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 10
        button.addSubview(rankingBtn1)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //接单数量- 设计
    lazy var designAcceptOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 103, y: 5, width: 80, height: 18)
        button.setTitle("接单单数", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 10
        button.addSubview(rankingBtn21)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //询价数量- 车间
    lazy var facInqueryOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 103, y: 5, width: 80, height: 18)
        button.setTitle("询价数量", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 10
        button.addSubview(rankingBtn31)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //接单单数
    lazy var acceptOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 182, y: 5, width: 80, height: 18)
        button.setTitle("接单单数", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 11
        button.addSubview(rankingBtn2)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //定稿数量 - 设计
    lazy var designDealOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 182, y: 5, width: 80, height: 18)
        button.setTitle("定稿数量", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.darkGray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 11
        button.addSubview(rankingBtn22)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //报价数量 - 车间
    lazy var facQuoteOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 182, y: 5, width: 80, height: 18)
        button.setTitle("报价数量", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 11
        button.addSubview(rankingBtn32)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //成交单数
    lazy var dealOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 261, y: 5, width: 80, height: 18)
        button.setTitle("成交单数", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 12
        button.addSubview(rankingBtn3)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //接单金额 - 设计
    lazy var designOrderAmountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 261, y: 5, width: 80, height: 18)
        button.setTitle("接单金额", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 12
        button.addSubview(rankingBtn23)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //接单数量 - 车间
    lazy var facAcceptOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 261, y: 5, width: 80, height: 18)
        button.setTitle("接单数量", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 12
        button.addSubview(rankingBtn33)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //接单金额
    lazy var acceptOrderAmountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 365, y: 5, width: 80, height: 18)
        button.setTitle("接单金额", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 13
        button.addSubview(rankingBtn4)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //定稿金额 - 设计
    lazy var designDealOrderAmountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 365, y: 5, width: 80, height: 18)
        button.setTitle("定稿金额", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 13
        button.addSubview(rankingBtn24)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //发货单数 - 车间
    lazy var facSendOrderCountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 365, y: 5, width: 80, height: 18)
        button.setTitle("发货单数", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 13
        button.addSubview(rankingBtn34)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //成交金额
    lazy var dealOrderAmountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 469, y: 5, width: 80, height: 18)
        button.setTitle("成交金额", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 14
        button.addSubview(rankingBtn5)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //定稿率 - 设计
    lazy var designTransferRateBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 469, y: 5, width: 80, height: 18)
        button.setTitle("  定稿率", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 14
        button.addSubview(rankingBtn25)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //接单金额 - 车间
    lazy var facAcceptOrderAmountBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 449, y: 5, width: 80, height: 18)
        button.setTitle("接单金额", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.darkGray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 14
        button.addSubview(rankingBtn35)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //转化率
    lazy var transferRateBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 548, y: 5, width: 80, height: 18)
        button.setTitle("  转化率", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 15
        button.addSubview(rankingBtn6)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //拒单率 - 设计
    lazy var designRefuseRateBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 548, y: 5, width: 80, height: 18)
        button.setTitle("  拒单率", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 15
        button.addSubview(rankingBtn26)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //报价时间(平均) - 车间
    lazy var facAverageQuoteTimeBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 528, y: 5, width: 100, height: 18)
        button.setTitle("报价时间(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 15
        button.addSubview(rankingBtn36)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //客单价
    lazy var singleOrderPriceBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 635, y: 5, width: 80, height: 18)
        button.setTitle("客单价", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 16
        button.addSubview(rankingBtn7)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //出图时间- 设计
    lazy var designAverageDesignTimeBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 635, y: 5, width: 120, height: 18)
        button.setTitle("出图时间(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 16
        button.addSubview(rankingBtn27)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //发货时间(平均)- 车间
    lazy var facAverageSendTimeBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 635, y: 5, width: 120, height: 18)
        button.setTitle("发货时间(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 16
        button.addSubview(rankingBtn37)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //成交时间(平均)
    lazy var AverageDealTimeBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 710, y: 5, width: 100, height: 18)
        button.setTitle("成交时间(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 17
        button.addSubview(rankingBtn8)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //设计费(平均) - 设计
    lazy var designAverageDesignPriceBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 750, y: 5, width: 100, height: 18)
        button.setTitle("设计费(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 17
        button.addSubview(rankingBtn28)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    //询价率
    lazy var quoteRateBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 805, y: 5, width: 80, height: 18)
        button.setTitle("  询价率", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.tag = 18
        button.addSubview(rankingBtn9)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //设计费(平均)
    lazy var AverageDesignPriceBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 885, y: 5, width: 80, height: 18)
        button.setTitle("设计费(平均)", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 13)
        button.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
        button.tag = 19
        button.addSubview(rankingBtn10)
        button.addTarget(self, action: #selector(switchStatisticIndexBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //用户名
    lazy var userNickNameLabel:UILabel = {
        let label = UILabel.init(frame: CGRect(x: 15, y: 5, width: 50, height: 18))
        label.text = "用户名"
        label.font = UIFont(name: "DINPro-Medium", size: 13)
        label.textColor = UIColor.titleColors(color: titleColorsType.gray)
        return label
    }()
    
    
    lazy var selectTagIcon:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 45, y: 40, width: 20, height: 4))
        tempView.backgroundColor = UIColor.lineColors(color: lineColorsType.lightOrange)
        return tempView
    }()
    
    lazy var statisticTableView:UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 36 , width: 1036 - heightChangeForiPhoneXFromBottom, height:kWidth - 76), style: UITableViewStyle.plain)
        tempTableView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempTableView.delegate = self
        tempTableView.dataSource = self
      //  tempTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempTableView.isScrollEnabled = true
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 100
        tempTableView.separatorStyle = .singleLine//.none
        tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel1)
        return tempTableView
    }()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var timeIntervalIndexs:[Int] = [5] //默认本月
    var timeIntervalList:[NSDictionary] = [["id":1,"timeInterval":"今天"],
                                           ["id":2,"timeInterval":"昨天"],
                                           ["id":3,"timeInterval":"本周"],
                                           ["id":4,"timeInterval":"上周"],
                                           ["id":5,"timeInterval":"本月"],
                                           ["id":6,"timeInterval":"上月"]]
    var shopIndexs:[Int] = []
    var shopList:[NSDictionary] = []
    var goodsClassIndexs:[Int] = []
    var goodsClassList:[NSDictionary] = []
    //系统配置项目Dict
    var systemParam:[AnyObject] = []
    
    //统计数据
    var statisticData:[NSDictionary] = []
    //全店统计
    var allShopStatisticData:[NSDictionary] = []
    var page:Int = 1
    var totalPageCount = 1
    //统计角色对象
    var statisticRoleType = 1 // 1客服 2设计师 3车间
    var rankingTypeList:[String] = []
    var selectedRankingIndex:Int = 10
    //数据加载标记
    var isDataLoading = true
    //加载中的动画集合
    var theLoadingViewNeedsToBeKill:[UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置横屏
        appDelegate.blockRotation = true
        //获取系统字典
        systemParam = getSystemParasFromPlist()
        let productObjects = systemParam[0] as! NSDictionary
        
        //加载产品列表字典
        goodsClassList.removeAll()
        for item in (productObjects.value(forKey: "goodsClass") as! NSArray){
            goodsClassList.append(item as! NSDictionary)
        }
        //加载店铺列表字典
        shopList.removeAll()
        for item in (productObjects.value(forKey: "shop") as! NSArray){
            shopList.append(item as! NSDictionary)
        }
        
        self.rankingTypeList = ["desc","desc","desc","desc","desc","desc","desc","asc","desc","desc"]
        
        self.view.addSubview(scrollBackgroundView)
        
        
        setupUI()
        
        //添加下拉刷新
        statisticTableView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        //添加上拉加载
        statisticTableView.es.addInfiniteScrolling {
            [weak self] in
            self?.loadMore()
        }
        
        getStatisticDetails(for: 1, rankingIndex: 10)//默认加载客服数据

        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //添加统计表格
        scrollBackgroundView.addSubview(statisticTableView)
        //用户名
        scrollBackgroundView.addSubview(userNickNameLabel)
        //客服统计项目
        scrollBackgroundView.addSubview(compositeIndexBtn)
        scrollBackgroundView.addSubview(acceptOrderCountBtn)
        scrollBackgroundView.addSubview(dealOrderCountBtn)
        scrollBackgroundView.addSubview(acceptOrderAmountBtn)
        scrollBackgroundView.addSubview(dealOrderAmountBtn)
        scrollBackgroundView.addSubview(transferRateBtn)
        scrollBackgroundView.addSubview(singleOrderPriceBtn)
        scrollBackgroundView.addSubview(AverageDealTimeBtn)
        scrollBackgroundView.addSubview(quoteRateBtn)
        scrollBackgroundView.addSubview(AverageDesignPriceBtn)
        
        
        //设计师统计项目
        scrollBackgroundView.addSubview(designAverageDesignPriceBtn)
        scrollBackgroundView.addSubview(designAverageDesignTimeBtn)
        scrollBackgroundView.addSubview(designRefuseRateBtn)
        scrollBackgroundView.addSubview(designTransferRateBtn)
        scrollBackgroundView.addSubview(designDealOrderAmountBtn)
        scrollBackgroundView.addSubview(designOrderAmountBtn)
        scrollBackgroundView.addSubview(designDealOrderCountBtn)
        scrollBackgroundView.addSubview(designAcceptOrderCountBtn)
        
        //车间统计项目
        scrollBackgroundView.addSubview(facSendOrderCountBtn)
        scrollBackgroundView.addSubview(facAverageSendTimeBtn)
        scrollBackgroundView.addSubview(facQuoteOrderCountBtn)
        scrollBackgroundView.addSubview(facAcceptOrderCountBtn)
        scrollBackgroundView.addSubview(facAverageQuoteTimeBtn)
        scrollBackgroundView.addSubview(facAcceptOrderAmountBtn)
        scrollBackgroundView.addSubview(facInqueryOrderCountBtn)
        
        designAverageDesignPriceBtn.isHidden = true
        designAverageDesignTimeBtn.isHidden = true
        designRefuseRateBtn.isHidden = true
        designTransferRateBtn.isHidden = true
        designDealOrderAmountBtn.isHidden = true
        designOrderAmountBtn.isHidden = true
        designDealOrderCountBtn.isHidden = true
        designAcceptOrderCountBtn.isHidden = true
        
        facSendOrderCountBtn.isHidden = true
        facAverageSendTimeBtn.isHidden = true
        facQuoteOrderCountBtn.isHidden = true
        facAcceptOrderCountBtn.isHidden = true
        facAverageQuoteTimeBtn.isHidden = true
        facAcceptOrderAmountBtn.isHidden = true
        facInqueryOrderCountBtn.isHidden = true
        
        self.view.addSubview(bottomNavigationBar)
        self.bottomNavigationBar.addSubview(customerServicerStatisticBtn)
        self.bottomNavigationBar.addSubview(designerStatisticBtn)
        self.bottomNavigationBar.addSubview(factoryStatisticBtn)
        self.bottomNavigationBar.addSubview(selectTagIcon)
        self.bottomNavigationBar.addSubview(timeIntervalChoosenBtn)
        self.bottomNavigationBar.addSubview(shopChoosenBtn)
        self.bottomNavigationBar.addSubview(goodsClassChoosenBtn)
        
        self.view.addSubview(closeVCBtn)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.clear)
        setStatusBarHiden(toHidden: true, ViewController: self)
        //设置横屏
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        print("View Will Appear")
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.getStatisticDetails(for: self.statisticRoleType,rankingIndex: self.selectedRankingIndex)
                self.statisticTableView.reloadData()
                self.statisticTableView.es.stopLoadingMore()
            }else{
                self.statisticTableView.es.noticeNoMoreData()
            }
        }
    }

    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.page = 1
            self.getStatisticDetails(for: self.statisticRoleType,rankingIndex: self.selectedRankingIndex)
        }
    }
    
    @objc func ringkingBtnClicked(_ button:UIButton){
        let tag = button.tag
       // switch tag {
        print(tag)
    }
    
    @objc func switchStatisticTypeBtnClicked(_ button:UIButton){
        if isDataLoading{
            return
        }
        isDataLoading = true
        shopChoosenBtn.isHidden = true
        //客服
        compositeIndexBtn.isHidden = true
        acceptOrderCountBtn.isHidden = true
        dealOrderCountBtn.isHidden = true
        acceptOrderAmountBtn.isHidden = true
        dealOrderAmountBtn.isHidden = true
        transferRateBtn.isHidden = true
        singleOrderPriceBtn.isHidden = true
        AverageDealTimeBtn.isHidden = true
        quoteRateBtn.isHidden = true
        AverageDesignPriceBtn.isHidden = true
        
        //设计师
        designAverageDesignPriceBtn.isHidden = true
        designAverageDesignTimeBtn.isHidden = true
        designRefuseRateBtn.isHidden = true
        designTransferRateBtn.isHidden = true
        designDealOrderAmountBtn.isHidden = true
        designOrderAmountBtn.isHidden = true
        designDealOrderCountBtn.isHidden = true
        designAcceptOrderCountBtn.isHidden = true
        
        //车间
        facSendOrderCountBtn.isHidden = true
        facAverageSendTimeBtn.isHidden = true
        facQuoteOrderCountBtn.isHidden = true
        facAcceptOrderCountBtn.isHidden = true
        facAverageQuoteTimeBtn.isHidden = true
        facAcceptOrderAmountBtn.isHidden = true
        facInqueryOrderCountBtn.isHidden = true
        
        let tag = button.tag
        switch tag {
        case 1:
            print("客服统计按钮点击了")
            statisticRoleType = 1
            selectTagIcon.frame = CGRect(x: 45, y: 40, width: 20, height: 4)
            customerServicerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.black), for: .normal)
            designerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            factoryStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            
            compositeIndexBtn.isHidden = false
            acceptOrderCountBtn.isHidden = false
            dealOrderCountBtn.isHidden = false
            acceptOrderAmountBtn.isHidden = false
            dealOrderAmountBtn.isHidden = false
            transferRateBtn.isHidden = false
            singleOrderPriceBtn.isHidden = false
            AverageDealTimeBtn.isHidden = false
            quoteRateBtn.isHidden = false
            AverageDesignPriceBtn.isHidden = false
            //默认排序方式：
            selectedRankingIndex = 10
            //客服的默认值
            rankingBtn22.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
            scrollBackgroundView.contentSize = CGSize(width: 1036 - heightChangeForiPhoneXFromBottom, height: 36)
            shopChoosenBtn.isHidden = false
        case 2:
            statisticRoleType = 2
            print("设计师统计按钮点击了")
            selectTagIcon.frame = CGRect(x: 136, y: 40, width: 20, height: 4)
            customerServicerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            designerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.black), for: .normal)
            factoryStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            
            designAverageDesignPriceBtn.isHidden = false
            designAverageDesignTimeBtn.isHidden = false
            designRefuseRateBtn.isHidden = false
            designTransferRateBtn.isHidden = false
            designDealOrderAmountBtn.isHidden = false
            designOrderAmountBtn.isHidden = false
            designDealOrderCountBtn.isHidden = false
            designAcceptOrderCountBtn.isHidden = false
            //默认排序方式 - 定稿数量
            selectedRankingIndex = 11
            //设计师的ranking值
            rankingBtn22.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
            scrollBackgroundView.contentSize = CGSize(width: 920 - heightChangeForiPhoneXFromBottom, height: 36)
        case 3:
            statisticRoleType = 3
            print("车间统计按钮点击了")
            selectTagIcon.frame = CGRect(x: 227, y: 40, width: 20, height: 4)
            customerServicerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            designerStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.gray), for: .normal)
            factoryStatisticBtn.setTitleColor(UIColor.titleColors(color: titleColorsType.black), for: .normal)
            
            facSendOrderCountBtn.isHidden = false
            facAverageSendTimeBtn.isHidden = false
            facQuoteOrderCountBtn.isHidden = false
            facAcceptOrderCountBtn.isHidden = false
            facAverageQuoteTimeBtn.isHidden = false
            facAcceptOrderAmountBtn.isHidden = false
            facInqueryOrderCountBtn.isHidden = false
            
            //默认排序方式 - 接单金额
            selectedRankingIndex = 14
            //车间的ranking值
            rankingBtn35.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
            scrollBackgroundView.contentSize = CGSize(width: 870 - heightChangeForiPhoneXFromBottom, height: 36)
            
        default:
            print("客服统计按钮点击了")
        }
        getStatisticDetails(for: statisticRoleType, rankingIndex: selectedRankingIndex)
    }
    
    @objc func switchStatisticIndexBtnClicked(_ button:UIButton){
        
        //客服按钮设置
        compositeIndexBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        acceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        dealOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        acceptOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        dealOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        transferRateBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        singleOrderPriceBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        AverageDealTimeBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        quoteRateBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        AverageDesignPriceBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        //设计按钮设置
        designAcceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designDealOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designDealOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designTransferRateBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designRefuseRateBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designAverageDesignTimeBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        designAverageDesignPriceBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        //车间按钮设置
        facSendOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facAverageSendTimeBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facQuoteOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facAcceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facAverageQuoteTimeBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facAcceptOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        facInqueryOrderCountBtn.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        
        for i in 0..<rankingTypeList.count{
            
            switch i {
            case 0:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn1.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn21.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn31.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn1.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn1.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn21.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn31.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn1.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 1:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn2.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn22.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn32.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn2.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn2.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn22.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn32.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn2.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 2:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn3.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn23.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn33.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn3.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn3.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn23.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn33.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn3.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 3:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn4.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn24.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn34.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn4.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn4.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn24.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn34.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn4.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 4:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn5.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn25.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn35.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn5.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn5.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn25.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn35.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn5.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 5:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn6.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn26.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn36.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn6.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn6.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn26.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn36.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn6.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 6:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn7.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn27.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn37.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    default:
                        rankingBtn7.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn7.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn27.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        rankingBtn37.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    default:
                        rankingBtn7.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 7:
                if rankingTypeList[i] == "desc"{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn8.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn28.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    case 3:
                        print("车间没有ranking 38")
                    default:
                        rankingBtn8.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                    }
                    
                }else{
                    switch statisticRoleType{
                    case 1:
                        rankingBtn8.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 2:
                        rankingBtn28.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    case 3:
                        print("车间没有ranking 38")
                    default:
                        rankingBtn8.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                    }
                    
                }
            case 8:
                if rankingTypeList[i] == "desc"{
                    rankingBtn9.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                }else{
                    rankingBtn9.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                }
            case 9:
                if rankingTypeList[i] == "desc"{
                    rankingBtn10.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                }else{
                    rankingBtn10.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                }
            default:
                if rankingTypeList[i] == "desc"{
                    rankingBtn1.setImage(UIImage(named: "rankingdownunselectediconimg"), for: .normal)
                }else{
                    rankingBtn1.setImage(UIImage(named: "rankingupunselectediconimg"), for: .normal)
                }
            }
            
        }
        
        let tag = button.tag
        switch tag {
        case 10:
            switch self.statisticRoleType{
            case 1:
                compositeIndexBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[0] = "asc"
                    }else{
                        rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[0] = "desc"
                    }
                }else{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                print("设计按钮")
                designAcceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn21.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[0] = "asc"
                    }else{
                        rankingBtn21.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[0] = "desc"
                    }
                }else{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn21.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn21.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                print("车间按钮")
                facInqueryOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn31.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[0] = "asc"
                    }else{
                        rankingBtn31.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[0] = "desc"
                    }
                }else{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn31.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn31.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                compositeIndexBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[0] = "asc"
                    }else{
                        rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[0] = "desc"
                    }
                }else{
                    if rankingTypeList[0] == "desc"{
                        rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
            
        case 11:
            switch statisticRoleType{
            case 1:
                acceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn2.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[1] = "asc"
                    }else{
                        rankingBtn2.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[1] = "desc"
                    }
                }else{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn2.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn2.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designDealOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn22.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[1] = "asc"
                    }else{
                        rankingBtn22.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[1] = "desc"
                    }
                }else{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn22.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn22.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facQuoteOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn32.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[1] = "asc"
                    }else{
                        rankingBtn32.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[1] = "desc"
                    }
                }else{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn32.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn32.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                acceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn2.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[1] = "asc"
                    }else{
                        rankingBtn2.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[1] = "desc"
                    }
                }else{
                    if rankingTypeList[1] == "desc"{
                        rankingBtn2.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn2.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 12:
            switch statisticRoleType{
            case 1:
                dealOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn3.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[2] = "asc"
                    }else{
                        rankingBtn3.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[2] = "desc"
                    }
                }else{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn3.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn3.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn23.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[2] = "asc"
                    }else{
                        rankingBtn23.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[2] = "desc"
                    }
                }else{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn23.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn23.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facAcceptOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn33.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[2] = "asc"
                    }else{
                        rankingBtn33.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[2] = "desc"
                    }
                }else{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn33.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn33.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                dealOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn3.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[2] = "asc"
                    }else{
                        rankingBtn3.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[2] = "desc"
                    }
                }else{
                    if rankingTypeList[2] == "desc"{
                        rankingBtn3.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn3.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 13:
            switch statisticRoleType{
            case 1:
                acceptOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn4.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[3] = "asc"
                    }else{
                        rankingBtn4.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[3] = "desc"
                    }
                }else{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn4.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn4.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designDealOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn24.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[3] = "asc"
                    }else{
                        rankingBtn24.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[3] = "desc"
                    }
                }else{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn24.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn24.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facSendOrderCountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn34.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[3] = "asc"
                    }else{
                        rankingBtn34.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[3] = "desc"
                    }
                }else{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn34.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn34.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                acceptOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn4.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[3] = "asc"
                    }else{
                        rankingBtn4.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[3] = "desc"
                    }
                }else{
                    if rankingTypeList[3] == "desc"{
                        rankingBtn4.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn4.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 14:
            switch statisticRoleType{
            case 1:
                dealOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn5.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[4] = "asc"
                    }else{
                        rankingBtn5.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[4] = "desc"
                    }
                }else{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn5.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn5.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designTransferRateBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn25.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[4] = "asc"
                    }else{
                        rankingBtn25.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[4] = "desc"
                    }
                }else{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn25.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn25.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facAcceptOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn35.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[4] = "asc"
                    }else{
                        rankingBtn35.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[4] = "desc"
                    }
                }else{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn35.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn35.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                dealOrderAmountBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn5.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[4] = "asc"
                    }else{
                        rankingBtn5.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[4] = "desc"
                    }
                }else{
                    if rankingTypeList[4] == "desc"{
                        rankingBtn5.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn5.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 15:
            switch statisticRoleType{
            case 1:
                transferRateBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn6.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[5] = "asc"
                    }else{
                        rankingBtn6.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[5] = "desc"
                    }
                }else{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn6.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn6.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designRefuseRateBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn26.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[5] = "asc"
                    }else{
                        rankingBtn26.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[5] = "desc"
                    }
                }else{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn26.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn26.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facAverageQuoteTimeBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn36.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[5] = "asc"
                    }else{
                        rankingBtn36.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[5] = "desc"
                    }
                }else{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn36.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn36.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                transferRateBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn6.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[5] = "asc"
                    }else{
                        rankingBtn6.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[5] = "desc"
                    }
                }else{
                    if rankingTypeList[5] == "desc"{
                        rankingBtn6.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn6.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 16:
            switch statisticRoleType{
            case 1:
                singleOrderPriceBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn7.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[6] = "asc"
                    }else{
                        rankingBtn7.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[6] = "desc"
                    }
                }else{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn7.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn7.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designAverageDesignTimeBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn27.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[6] = "asc"
                    }else{
                        rankingBtn27.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[6] = "desc"
                    }
                }else{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn27.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn27.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                facAverageSendTimeBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn37.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[6] = "asc"
                    }else{
                        rankingBtn37.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[6] = "desc"
                    }
                }else{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn37.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn37.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            default:
                singleOrderPriceBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn7.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[6] = "asc"
                    }else{
                        rankingBtn7.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[6] = "desc"
                    }
                }else{
                    if rankingTypeList[6] == "desc"{
                        rankingBtn7.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn7.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 17:
            switch statisticRoleType{
            case 1:
                AverageDealTimeBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn8.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[7] = "asc"
                    }else{
                        rankingBtn8.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[7] = "desc"
                    }
                }else{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn8.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn8.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 2:
                designAverageDesignPriceBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn28.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[7] = "asc"
                    }else{
                        rankingBtn28.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[7] = "desc"
                    }
                }else{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn28.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn28.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            case 3:
                print("车间没有Ranking 38")
            default:
                AverageDealTimeBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
                if selectedRankingIndex == tag{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn8.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                        rankingTypeList[7] = "asc"
                    }else{
                        rankingBtn8.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                        rankingTypeList[7] = "desc"
                    }
                }else{
                    if rankingTypeList[7] == "desc"{
                        rankingBtn8.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    }else{
                        rankingBtn8.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    }
                }
            }
            
        case 18:
            quoteRateBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
            if selectedRankingIndex == tag{
                if rankingTypeList[8] == "desc"{
                    rankingBtn9.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    rankingTypeList[8] = "asc"
                }else{
                    rankingBtn9.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    rankingTypeList[8] = "desc"
                }
            }else{
                if rankingTypeList[8] == "desc"{
                    rankingBtn9.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                }else{
                    rankingBtn9.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                }
            }
        case 19:
            AverageDesignPriceBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
            if selectedRankingIndex == tag{
                if rankingTypeList[9] == "desc"{
                    rankingBtn10.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    rankingTypeList[9] = "asc"
                }else{
                    rankingBtn10.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    rankingTypeList[9] = "desc"
                }
            }else{
                if rankingTypeList[9] == "desc"{
                    rankingBtn10.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                }else{
                    rankingBtn10.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                }
            }
        default:
            compositeIndexBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
            if selectedRankingIndex == tag{
                if rankingTypeList[0] == "desc"{
                    rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                    rankingTypeList[0] = "asc"
                }else{
                    rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                    rankingTypeList[0] = "desc"
                }
            }else{
                if rankingTypeList[0] == "desc"{
                    rankingBtn1.setImage(UIImage(named: "rankingdownselectediconimg"), for: .normal)
                }else{
                    rankingBtn1.setImage(UIImage(named: "rankingupselectediconimg"), for: .normal)
                }
            }
        }
        selectedRankingIndex = tag
        self.getStatisticDetails(for: self.statisticRoleType,rankingIndex: self.selectedRankingIndex)
    }
    
    @objc func filterBtnClicked(_ button:UIButton){
        let tag = button.tag
        switch tag {
        case 55:
            let chooseTimeIntervalView = FilterForHorizentalView.init(frame: CGRect(x: 0, y: kWidth - 331, width: kHight, height: 331))
            chooseTimeIntervalView.isUserInteractionEnabled = true
            chooseTimeIntervalView.selectionStyle = .single
            chooseTimeIntervalView.statisticVC = self
            chooseTimeIntervalView.seletedIndexs = timeIntervalIndexs
            chooseTimeIntervalView.selectedItems = transferSelectedItemToIndexs(filterList: timeIntervalList, selectedItem: timeIntervalIndexs)
            chooseTimeIntervalView.createFilterView(with: "时间段", filterType: .timeInterval, filterItemList: timeIntervalList)
            
            let popVC = PopUpsPortialViewController()//PopUpsPortialViewController.init(with: appDelegate)
            popVC.view.backgroundColor = UIColor.clear
          //  popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            chooseTimeIntervalView.popupVC = popVC
            
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(chooseTimeIntervalView)
            
            self.present(popVC, animated: true, completion: nil)
            
        case 56:
            let chooseGoodsClassView = FilterForHorizentalView.init(frame: CGRect(x: 0, y: kWidth - 331, width: kHight, height: 331))
           // let array = getListValue(from: goodsClassList, identifier: "goodsClass")
            
            chooseGoodsClassView.isUserInteractionEnabled = true
            chooseGoodsClassView.selectionStyle = .multiple
            chooseGoodsClassView.statisticVC = self
            chooseGoodsClassView.seletedIndexs = goodsClassIndexs
            chooseGoodsClassView.selectedItems = transferSelectedItemToIndexs(filterList: goodsClassList, selectedItem: goodsClassIndexs)
            chooseGoodsClassView.createFilterView(with: "品类", filterType: .goodsClass, filterItemList: goodsClassList)
            
            let popVC = PopUpsPortialViewController()//PopUpsPortialViewController.init(with: appDelegate)
            popVC.view.backgroundColor = UIColor.clear
            //  popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            chooseGoodsClassView.popupVC = popVC
            
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(chooseGoodsClassView)
            
            self.present(popVC, animated: true, completion: nil)
        case 57:
            let chooseShopView = FilterForHorizentalView.init(frame: CGRect(x: 0, y: kWidth - 331, width: kHight, height: 331))
          //  let array = getListValue(from: shopList, identifier: "shop")
            
            chooseShopView.isUserInteractionEnabled = true
            chooseShopView.selectionStyle = .multiple
            chooseShopView.statisticVC = self
            chooseShopView.seletedIndexs = shopIndexs
            chooseShopView.selectedItems = transferSelectedItemToIndexs(filterList: shopList, selectedItem: shopIndexs)
            chooseShopView.createFilterView(with: "店铺", filterType: .shop, filterItemList: shopList)
            
            let popVC = PopUpsPortialViewController()//PopUpsPortialViewController.init(with: appDelegate)
            popVC.view.backgroundColor = UIColor.clear
            //  popVC.view.addSubview(showBlurEffect()) //UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            popVC.view.addSubview(popVC.grayLayer)
            popVC.modalPresentationCapturesStatusBarAppearance = true
            chooseShopView.popupVC = popVC
            
            popVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext //
            popVC.view.addSubview(chooseShopView)
            
            self.present(popVC, animated: true, completion: nil)
        default:
            print("客服统计按钮点击了")
        }
    }
    

    //已选中的值转化为对应的index
    func transferSelectedItemToIndexs(filterList:[NSDictionary],selectedItem:[Int]) -> [Bool]{
        var selectedIndexs:[Bool] = []
        
        for _ in 0..<filterList.count{
            selectedIndexs.append(false)
        }
        //code = 2
        for i in 0..<filterList.count{
            for item in selectedItem{
                if (filterList[i].value(forKey: "id") as! Int) == item{
                    selectedIndexs[i] = true
                }
               // selectedIndexs[item] = true
            }
        }
        
        return selectedIndexs
    }
    
    func getListValue(from itemList:[NSDictionary], identifier:String) -> [String]{
        var array:[String] = []
        for item in itemList{
            array.append(item.value(forKey: identifier) as! String)
        }
        return array
    }
    
    @objc func closeLayerBtnClicked(){
        //设置横屏
         let value = UIInterfaceOrientation.portrait.rawValue
         UIDevice.current.setValue(value, forKey: "orientation")
        self.dismiss(animated: true, completion: nil)
    }
    
    func StartLoadingAnimation(){
        //加载中动画与文字
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 , width: 200, height: 30))
        //动画imageView
        let imageView = UIImageView()
        
        //当loadingView不为空的时候，表示有LoadingView在运行
        if theLoadingViewNeedsToBeKill.count != 0 {
            for item in theLoadingViewNeedsToBeKill{
                item.removeFromSuperview()
            }
        }
        
        noticeWhenLoadingData.text = "加载中，请稍侯..."
        noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
        noticeWhenLoadingData.textColor = UIColor.gray
        noticeWhenLoadingData.textAlignment = .center
        //loading动画
        var images:[UIImage] = []
        for i in 0...27{
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named:imagePath)!
            images.append(image)
        }
        
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 150 , width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        
        theLoadingViewNeedsToBeKill.append(imageView)
        theLoadingViewNeedsToBeKill.append(noticeWhenLoadingData)
        
        self.view.addSubview(imageView)
        self.view.addSubview(noticeWhenLoadingData)
        
    }
    
    func StopLoadingAnimation(){
        if theLoadingViewNeedsToBeKill.count != 0 {
            for item in theLoadingViewNeedsToBeKill {
                item.removeFromSuperview()
            }
        }
    }
    
    func timeIntervalTransfer(index:Int) ->(StartTime:String,EndTime:String){
        var startTimeString = ""
        var endTimeString = ""
        
        switch index{
        case 1: //今天
            startTimeString = getStartDateTimeOfToday().String
            endTimeString = getEndDateTimeOfToday().String
        case 2:
            //昨天
            startTimeString = dateAheadToday(before: 1, getStart: true, UnitType: .byDay).String
            endTimeString = dateAheadToday(before: 1, getStart: false, UnitType: .byDay).String
        case 3:
            //本周
            startTimeString = getWeekTime(getStartDateTimeOfToday().String).Monday
            let tempTimeString = getWeekTime(getEndDateTimeOfToday().String).Sunday
            endTimeString = tempTimeString.prefix(10) + " 23:59:59"
        case 4:
            //上周
            startTimeString = getWeekTime(dateAheadToday(before: 7, getStart: true, UnitType: .byDay).String).Monday
            let tempString = getWeekTime(dateAheadToday(before: 7, getStart: true, UnitType: .byDay).String).Sunday
            endTimeString = tempString.prefix(10) + " 23:59:59"
        case 5:
            //本月
            startTimeString = startOfCurrentMonth(getStartDateTimeOfToday().String)
            endTimeString = endOfCurrentMonth(getStartDateTimeOfToday().String, returnEndTime: true)
        case 6:
            //上月
            let firstDayOfThisMonth = startOfCurrentMonth(getStartDateTimeOfToday().String)
            let lastDayOfLastMonth = getLastDay(firstDayOfThisMonth)
            startTimeString = startOfCurrentMonth(lastDayOfLastMonth)
            endTimeString = endOfCurrentMonth(lastDayOfLastMonth, returnEndTime: true)
        default:
            startTimeString = startOfCurrentMonth(getStartDateTimeOfToday().String)
            endTimeString = endOfCurrentMonth(getStartDateTimeOfToday().String, returnEndTime: true)
        }
        return (startTimeString,endTimeString)
    }
    
    func getStatisticDetails(for roleType:Int,rankingIndex:Int){
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        let token = userInfos.value(forKey: "token") as? String
        
        self.isDataLoading = true
        self.StartLoadingAnimation()
        
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        header["token"] = token
        let time = timeIntervalTransfer(index: self.timeIntervalIndexs[0])
        params["startTime"] = time.StartTime
        params["endTime"] = time.EndTime
        
        print(time)
        
        var goodsClassString = ""
        for item in goodsClassIndexs{
            goodsClassString += "\(item),"
        }
        
        if goodsClassString != ""{
            goodsClassString.removeLast()
        }
        params["goodsclass"] = goodsClassString
        
        params["sortType"] = rankingTypeList[rankingIndex - 10]
        params["page"] = 1
        params["size"] = 100
        params["allcount"] = true

        var requestUrl = ""
        switch roleType {
        case 1:
            #if DEBUG
                requestUrl = apiAddresses.value(forKey: "statisticForCustomerAPIDebug") as! String
            #else
                requestUrl = apiAddresses.value(forKey: "statisticForCustomerAPI") as! String
            #endif
            
            var shopsString = ""
            for item in shopIndexs{
                shopsString += "\(item),"
            }
            
            if shopsString != ""{
                shopsString.removeLast()
            }
            params["shops"] =  shopsString
            
            //SortIndex
            switch rankingIndex {
            case 10:
                params["sort"] = "composite"
            case 11:
                params["sort"] = "acceptNumber"
            case 12:
                params["sort"] = "clinchNumber"
            case 13:
                params["sort"] = "acceptPrice"
            case 14:
                params["sort"] = "clinchprice"
            case 15:
                params["sort"] = "changeSize"
            case 16:
                params["sort"] = "price"
            case 17:
                params["sort"] = "averageTime"
            case 18:
                params["sort"] = "enquiry"
            case 19:
                params["sort"] = "designePrice"
            default:
                params["sort"] = "composite"
            }
        case 2:
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "statisticForDesignerAPIDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "statisticForDesignerAPI") as! String
            #endif
            
            switch rankingIndex {
            case 10:
                params["sort"] = "acceptNumber"
            case 11:
                params["sort"] = "finalizeNumber"
            case 12:
                params["sort"] = "acceptPrice"
            case 13:
                params["sort"] = "finalizePrice"
            case 14:
                params["sort"] = "finalizeRatio"
            case 15:
                params["sort"] = "refuseRate"
            case 16:
                params["sort"] = "averageDesignTime"
            case 17:
                params["sort"] = "designPrice"
            default:
                params["sort"] = "acceptNumber"
            }
        case 3:
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "statisticForFactoryAPIDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "statisticForFactoryAPI") as! String
            #endif
            
            switch rankingIndex {
            case 10:
                params["sort"] = "enquiryNumber"
            case 11:
                params["sort"] = "quoteNumber"
            case 12:
                params["sort"] = "acceptNumber"
            case 13:
                params["sort"] = "sendNumber"
            case 14:
                params["sort"] = "acceptPrice"
            case 15:
                params["sort"] = "averageQuoteTime"
            case 16:
                params["sort"] = "averageSendTime"
            default:
                params["sort"] = "acceptNumber"
            }
        default:
            #if DEBUG
            requestUrl = apiAddresses.value(forKey: "statisticForCustomerAPIDebug") as! String
            #else
            requestUrl = apiAddresses.value(forKey: "statisticForCustomerAPI") as! String
            #endif
        }
        
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
                    self.statisticData.removeAll()
                    self.allShopStatisticData.removeAll()
                    self.totalPageCount = 1

                    if statusCode == 200{
                        self.totalPageCount = Int(json["data","totalNumber"].int!/100)
                        //设计师在线列表
                        for item in json["data","list"].array!{
                            let dicItem = item.dictionaryObject! as NSDictionary
                            self.statisticData.append(dicItem)
                        }
                        //客服在线列表
                        let dicItem =  json["data","all"].dictionaryObject! as NSDictionary
                        self.allShopStatisticData.append(dicItem)
                        self.isDataLoading = false
                        self.statisticTableView.reloadData()
                        //     self.onlineList
                        //
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        self.isDataLoading = true
                        self.statisticTableView.reloadData()
                        //                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                        LogoutMission(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                        self.isDataLoading = true
                        self.statisticTableView.reloadData()
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
            }
            
            self.statisticTableView.es.stopPullToRefresh()
            self.StopLoadingAnimation()
        }
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
