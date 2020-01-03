//
//  FactoryListSettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/9/5.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class FactoryListSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factoryListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FactoryListSettingTableViewCell.customCell(tableView: factoryListTableView) as! FactoryListSettingTableViewCell
        
        let factoryData = factoryListData[indexPath.row]
        
        let workShopName = factoryData.value(forKey: "nickName") as! String
        
        cell.FactoryNameLabel.text = workShopName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let factorySettingVC = FactorySettingViewController(factoryInfos: factoryListData[selectedIndex],factoryVC: self) //FactorySettingViewController()
        factorySettingVC.modalPresentationStyle = .fullScreen
        self.present(factorySettingVC, animated: true, completion: nil)
    }
    //车间列表数据
    var factoryListData:[NSDictionary] = []
    //记录的需要移除的Views
    var theViewNeedToBeKill:[UIView] = []
    //车间列表
    lazy var factoryListTableView:UITableView = {
        //height -77 调好的
        //var heightOfTableView = UIScreen.main.bounds.height - 62
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 64 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (64 + heightChangeForiPhoneXFromTop)), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempTableView.isScrollEnabled = true
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 100
        tempTableView.separatorStyle = .singleLine//.none
        tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel3)
        return tempTableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.barTintColor = UIColor.backgroundColors(color: .lightestGray)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "车间配置"
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
        // Do any additional setup after loading the view.
        loadListData()
       // self.view.addSubview(factoryListTableView)
    }
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadListData(){
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
        let requestUrl = apiAddresses.value(forKey: "setFactorySettingInitAPIDebug") as! String
        #else
        let requestUrl = apiAddresses.value(forKey: "setFactorySettingInitAPI") as! String
        #endif
        _ = Alamofire.request(requestUrl,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let statusCode = json["code"].int!
                    if statusCode == 200{
                        self.factoryListData.removeAll()
                        let listData = json["data"].array!
                        for item in listData{
                            self.factoryListData.append(item.dictionaryObject! as NSDictionary)
                        }
                        
                        if self.view.subviews.contains(self.factoryListTableView){
                            self.factoryListTableView.reloadData()
                        }else{
                            self.view.addSubview(self.factoryListTableView)
                        }
                        
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                        self.factoryListData.removeAll()
                        self.emytyAreaShowingLabel(withRetry: true)
                        self.factoryListTableView.removeFromSuperview()
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
                self.factoryListData.removeAll()
                self.emytyAreaShowingLabel(withRetry: true)
                self.factoryListTableView.removeFromSuperview()
            }
            self.factoryListTableView.es.stopPullToRefresh()
        }
        
    }
    
    @objc func retryBtnInViewClicked(){
        factoryListData.removeAll()
        loadListData()
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        for item in theViewNeedToBeKill{
            item.removeFromSuperview()
        }
        //什么都没有
        let sizeOfNothing:Int = 180
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 300, width: sizeOfNothing, height: sizeOfNothing))
        theViewNeedToBeKill.append(nothingToShow)
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 120 , width: 200, height: 44))
        nothingToSHowLabel.text = "空空如也..."
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.tag = 901
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        theViewNeedToBeKill.append(nothingToSHowLabel)
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        nothingToShow.tag = 903
        self.view.addSubview(nothingToShow)
        if withRetry {
            let retryBtn:UIButton = UIButton.init(type: .system)
            retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 + 50, width: 150, height: 44)
            retryBtn.backgroundColor = UIColor.white
            retryBtn.layer.cornerRadius = 5
            retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
            retryBtn.layer.borderWidth = 1
            retryBtn.tag = 902
            retryBtn.setTitle("再试试", for: .normal)
            retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
            retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
            theViewNeedToBeKill.append(retryBtn)
            self.view.addSubview(retryBtn)
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
