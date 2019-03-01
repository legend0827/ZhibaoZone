//
//  quotePriceHistoryView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/2/28.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class quotePriceHistoryView: UIView,UITableViewDelegate,UITableViewDataSource{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteHistoryListArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = quotePriceHistoryTableViewCell.customCell(tableView: quotePriceContentTableView)
        cell.selectionStyle = .none
        
        let priceDic = quoteHistoryListArray[indexPath.row]
        //询价时间
        if priceDic.value(forKey: "inquiryTime") as? String == nil || priceDic.value(forKey: "inquiryTime") as? String == ""{
            cell.inqueryTimeValue.text = "未获得询价时间"
        }else{
            cell.inqueryTimeValue.text = priceDic.value(forKey: "inquiryTime") as! String
        }
        //产品类型
        cell.productTypeValue.text = priceDic.value(forKey: "goodsclass") as! String
        //材质+配件
        cell.materialAndAccessoryValue.text = (priceDic.value(forKey: "material") as! String) + " " + (priceDic.value(forKey: "accessories") as! String)
        //生产能力
        cell.produceStyleValue.text = (priceDic.value(forKey: "model") as! String) + ";" + (priceDic.value(forKey: "technology") as! String) + ";" + (priceDic.value(forKey: "color") as! String)
        //工期
        cell.producePeriodValue.text = "工期 \(priceDic.value(forKey: "userPeriod") as! Int)"
        //数量
        cell.orderNumberValue.text = "数量 \(priceDic.value(forKey: "number") as! Int)"
        //尺寸
        cell.produceSizeValue.text = "\(priceDic.value(forKey: "length") as! Double)" + " x " + "\(priceDic.value(forKey: "width") as! Double)" + " x " + "\(priceDic.value(forKey: "height") as! Double)"
       // let inqueryTime = priceDic.value(forKey: "inquiryTime")
        cell.quoteInfo = priceDic.value(forKey: "quoteInfo") as! [NSDictionary]
        cell.priceListTableView.reloadData()
        return cell
    }
     //页面元素
    lazy var ActionTitle:UILabel = {
        let tempLable = UILabel.init(frame: CGRect(x: kWidth/2 - 38, y: 20, width: 72, height: 25))
        tempLable.text = "报价历史"
        tempLable.textColor = UIColor.titleColors(color: .black)
        tempLable.textAlignment = .center
        tempLable.font = UIFont.systemFont(ofSize: 17)
        return tempLable
    }()
    
    lazy var cancelBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: kWidth - 80, y: 22, width: 60, height: 22))
        button.setTitle("关闭", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(closeActionView), for: .touchUpInside)
        return button
    }()
    
    //报价历史表格
    lazy var quotePriceContentTableView:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 70, width: kWidth, height: self.frame.height - 70),style:.plain)
            
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none//.none
        //tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel1)
        tempTableView.backgroundColor = UIColor.white
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        
        return tempTableView
    }()
    
    
    var _frame:CGRect?
    var _customId:String?
    var _token:String?
    var _popupVC:PopupViewController?
    var quoteHistoryListArray:[NSDictionary] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        //获取用户信息
//        let userInfos = getCurrentUserInfo()
//        _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
//        _userId = userInfos.value(forKey: "userid") as? String
//        _token = userInfos.value(forKey: "token") as? String
       // _frame = frame
        
        self.addSubview(cancelBtn)
        self.addSubview(ActionTitle)
        self.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //self.addSubview(quotePriceContentTableView)
        
        //获取System Parameter信息
        // systemParam = getSystemParasFromPlist()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func closeActionView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (finished) in
            self.removeFromSuperview()
        }
        
    }
    
    func getQuoteHistories(){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "quotePriceHistoriesAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "quotePriceHistoriesAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["customid"] =  self._customId
        //  params["roleType"] = _roleType// roletype
        header["token"] = _token// token
        
        _ = Alamofire.request(newTaskUpdateURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    do {
                        let statusCode = try json["code"].int!
                        if statusCode == 200{
                           //greyLayerPrompt.show(text: "问题提交成功")
                            self.quoteHistoryListArray.removeAll()
                            for item in json["data","priceHistory"].array!{
                                let dicItem = item.dictionaryObject! as NSDictionary
                                self.quoteHistoryListArray.append(dicItem)
                            }
                            self.addSubview(self.quotePriceContentTableView)
                        }else if statusCode == 99999 || statusCode == 99998{
                            //异常
                            autoLogin(viewControler: self._popupVC!)
                            //                            greyLayerPrompt.show(text: "登录已失效,请重新登录")
                            //                            LogoutMission(viewControler: self.popupVC)
                        }else{
                            print("获取失败，code:\(statusCode)")
                            let errorMsg = json["message"].string!
                            greyLayerPrompt.show(text: "获取失败,\(errorMsg)")
                        }
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        greyLayerPrompt.show(text: "程序错误. Code:1")
                    }
                    
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
