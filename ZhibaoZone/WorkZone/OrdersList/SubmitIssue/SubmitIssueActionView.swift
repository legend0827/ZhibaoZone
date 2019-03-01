//
//  SubmitIssueActionView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/2/25.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class SubmitIssueActionView: UIView,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _issueList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueListTableViewCell.customCell(tableView: contentTableView)
        cell.selectionStyle = .none
        cell.checkBox.addTarget(self, action: #selector(checkedBoxChanged), for: .touchUpInside)
        cell.checkBox.tag = indexPath.row
        if checkStatus[indexPath.row]{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-checked"), for: .normal)
            
        }else{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
            //cell.checkBox.image = UIImage(named: "checkbox-unchecked")
        }
        cell.titleLabel.text = _issueList[indexPath.row].value(forKey: "name") as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checkStatus[indexPath.row] = !checkStatus[indexPath.row]
        checkStatus.removeAll()
        selectedItems.removeAll()
        for _ in 0..<_issueList.count{
            checkStatus.append(false)
        }
        checkStatus[indexPath.row] = true
        if checkStatus[indexPath.row]{
            selectedItems.append(_issueList[indexPath.row].value(forKey: "id") as! Int)
        }
        tableView.reloadData()
        print("Row \(indexPath.row) selected")
    }
    
    lazy var whiteBGView:UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = UIColor.backgroundColors(color: .white)
        return view
    }()
    
    //选项表格
    lazy var contentTableView:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 24, y: 54, width: self._frame!.width - 48, height: self._frame!.height - 54 - 75), style: .plain)
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
    
    //确认按钮
    lazy var confirmBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: 20, y: self._frame!.height - 55, width: (self._frame!.width - 55)/2, height: 40))
        button.addTarget(self, action: #selector(confirmBtnClicked), for: .touchUpInside)
        button.setTitle("确认", for: .normal)
        button.layer.backgroundColor = UIColor.titleColors(color: .lightOrange).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.backgroundColors(color: .white), for: .normal)
        button.layer.cornerRadius = 2
        return button
    }()
    
    //确认按钮
    lazy var cancelBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: self._frame!.width/2  + 7.5, y: self._frame!.height - 55, width: (self._frame!.width - 55)/2, height: 40))
        button.addTarget(self, action: #selector(cancelBtnClicked), for: .touchUpInside)
        button.setTitle("取消", for: .normal)
        button.layer.backgroundColor = UIColor.titleColors(color: .white).cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.backgroundColors(color: .black), for: .normal)
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.lineColors(color: .grayLevel1).cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    lazy var titleOfPage:UILabel = {
        let title = UILabel.init(frame: CGRect(x: 33, y: 20, width: 100, height: 24))
        title.text = "提交问题"
        title.font = UIFont.systemFont(ofSize: 17)
        title.textAlignment = .left
        return title
    }()
    
    
    var _frame:CGRect?
    var _token:String?
    var _userId:String?
    var _customId:String?
    var _roleType:Int?
    var _issueList:[NSDictionary] = []
    var _popupVC:PopupViewController?
    lazy var actionView:ActionViewInOrder = ActionViewInOrder.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //var parasCounts:Int = 0
    var selectedItems:[Int] = []
    var checkStatus:[Bool] = []
    //var systemParams:
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        //获取用户信息
        let userInfos = getCurrentUserInfo()
        _roleType = Int((userInfos.value(forKey: "roletype") as? String)!)!
        _userId = userInfos.value(forKey: "userid") as? String
        _token = userInfos.value(forKey: "token") as? String
        _frame = frame
        
        self.backgroundColor = UIColor.colorWithRgba(0, g: 0, b: 0, a: 0.5)
        
        whiteBGView.frame = frame
        whiteBGView.layer.cornerRadius = 6
        self.addSubview(whiteBGView)
        
        let dotImg=UIImageView.init(frame: CGRect(x: 20, y: 26, width: 3, height: 12))
        dotImg.image = UIImage(named: "orangedotimg")
        
        whiteBGView.addSubview(dotImg)
        whiteBGView.addSubview(titleOfPage)
        whiteBGView.addSubview(confirmBtn)
        whiteBGView.addSubview(cancelBtn)
        //获取System Parameter信息
       // systemParam = getSystemParasFromPlist()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initWithIssueList(issueList:[NSDictionary]){
        _issueList = issueList
        for _ in 0..<_issueList.count{
            self.checkStatus.append(false)
        }
        
        whiteBGView.addSubview(contentTableView)
    }

    @objc func confirmBtnClicked(){
        submitProblem()
        self.removeFromSuperview()
    }
    
    @objc func cancelBtnClicked(){
        print("cancelBtnClicked")
        self.removeFromSuperview()
    }
    
    @objc func checkedBoxChanged(_ button:UIButton){
        let index = button.tag
       // checkStatus[index] = !checkStatus[index]
        
        checkStatus.removeAll()
        selectedItems.removeAll()
        for _ in 0..<_issueList.count{
            checkStatus.append(false)
        }
        checkStatus[index] = true
        if checkStatus[index]{
            selectedItems.append(_issueList[index].value(forKey: "id") as! Int)
        }
        contentTableView.reloadData()
    }
    
    func submitProblem(){
        guard selectedItems.count != 0 else {
            greyLayerPrompt.show(text: "请选择问题后再提交")
            return
        }
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "submitProblemAPIDebug") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "submitProblemAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["customid"] =  self._customId
        params["id"] = selectedItems[0]
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
                           greyLayerPrompt.show(text: "问题提交成功")
                            if !self.actionView.isProblemSubmitted {
                                self.actionView.statusListView.append(self.actionView.issueSubmittedImageView)
                                self.actionView.updateOrderStatueIcon(iconList: self.actionView.statusListView)
                            }
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
