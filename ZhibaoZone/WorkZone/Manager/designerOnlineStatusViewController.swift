//
//  designerOnlineStatusViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class designerOnlineStatusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._onlineStatusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = onLineListTableViewCell.customCell(tableView: onlineListTableView)
        let onlineStatusObject = _onlineStatusList[indexPath.row]
        let userName = onlineStatusObject.value(forKey: "nickName") as? String
        let onlineStatus = onlineStatusObject.value(forKey: "onlineStatus") as? Int
        let offlineTimeInterval:TimeInterval = onlineStatusObject.value(forKey: "updateTime") as? Double ?? 0
        cell.userNikeName.text = userName!
        switch onlineStatus {
        case 0:
            cell.onlineStatusiCon.image = UIImage(named: "offlinestatusicon")
            cell.statusTimeLabel.text = "离线时间: \(transferTimeToString(with: offlineTimeInterval))"
        case 1:
            cell.onlineStatusiCon.image = UIImage(named: "onlinestatusicon")
            cell.statusTimeLabel.text = "当前在线"
        case 2:
            cell.onlineStatusiCon.image = UIImage(named: "hangupstatusicon")
            cell.statusTimeLabel.text = "挂起时间: \(transferTimeToString(with: offlineTimeInterval))"
        default:
            cell.onlineStatusiCon.image = UIImage(named: "offlinestatusicon")
            cell.statusTimeLabel.text = "离线时间: \(transferTimeToString(with: offlineTimeInterval))"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67.0
    }
    //导航栏
    let navigationBarInMessageList:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
    //
    lazy var _onlineStatusList:[NSDictionary] = []
    lazy var _listRole = 2
    var isDataLoading = false
    
    //在线人员列表
    lazy var onlineListTableView:UITableView = {
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
    

    init(with onlineList:[NSDictionary], roleType:Int){
        super.init(nibName: nil, bundle: nil)
        self._onlineStatusList = onlineList
        self._listRole = roleType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        switch _listRole {
        case 1:
            titleLabel.text = "客服在线状态"
        case 2:
            titleLabel.text = "设计师在线状态"
        case 3:
            titleLabel.text = "车间在线状态"
        default:
            titleLabel.text = "设计师在线状态"
        }
        
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
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        //灰层
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        //添加下拉刷新
        //addPullToRefresh(animator: header)
        onlineListTableView.es.addPullToRefresh {
            [weak self] in
            self?.refresh()
        }
        self.view.addSubview(onlineListTableView)
        // Do any additional setup after loading the view.
    }
    
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //self.page = 1
          //  self._onlineStatusList.removeAll()
            self.getOnlineStatus()
            //self.loadOrderDataFromServer(pages:self.page)
        }
    }
    
    //点击返回
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .backgroundColors(color: .red))
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .clear)
        setStatusBarHiden(toHidden: false, ViewController: self)
    }
    @objc func getOnlineStatus(){
        //确定点击接受生产按钮
        //获取用户信息
        if isDataLoading{
            return
        }
        isDataLoading = true
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
        var requestUrl = apiAddresses.value(forKey: "onlineStatusAPIDebug") as! String
        #else
        var requestUrl = apiAddresses.value(forKey: "onlineStatusAPI") as! String
        #endif
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
                    self._onlineStatusList.removeAll()
                    if statusCode == 200{
                        switch self._listRole{
                        case 1:
                            for item in json["data","serviceUser"].array!{
                                let dicItem = item.dictionaryObject! as NSDictionary
                                self._onlineStatusList.append(dicItem)
                            }
                        case 2:
                            for item in json["data","designUser"].array!{
                                let dicItem = item.dictionaryObject! as NSDictionary
                                self._onlineStatusList.append(dicItem)
                            }
                        case 3:
                            for item in json["data","shopUser"].array!{
                                let dicItem = item.dictionaryObject! as NSDictionary
                                self._onlineStatusList.append(dicItem)
                            }
                        default:
                            for item in json["data","designUser"].array!{
                                let dicItem = item.dictionaryObject! as NSDictionary
                                self._onlineStatusList.append(dicItem)
                            }
                        }
                        
                        self.onlineListTableView.reloadData()
                        //     self.onlineList
                        //
                    }else if statusCode == 99999 || statusCode == 99998{
                        //异常
                        autoLogin(viewControler: self)
                        //                        greyLayerPrompt.show(text: "登录已失效,请重新登录")
                        //                        LogoutMission(viewControler: self)
                    }else{
                        print("获取数据失败，code:\(statusCode)")
                        let errorMsg = json["message"].string!
                        greyLayerPrompt.show(text: errorMsg)
                        self.onlineListTableView.reloadData()
                    }
                }
            case false:
                print("处理失败")
                greyLayerPrompt.show(text: "获取数据失败，请重试")
                self.onlineListTableView.reloadData()
            }
            self.onlineListTableView.es.stopPullToRefresh()
            self.isDataLoading = false
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
