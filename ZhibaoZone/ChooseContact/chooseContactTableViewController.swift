//
//  chooseContactTableViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 27/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class chooseContactViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    
    //工作台对象
    var workZoneVCObject = WorkZoneViewController()

    //联系人匹配结果数组
    var contactsMatchedArray:[NSDictionary] = []
    var contactCount = 0
    //联系人数组（原始）
    var contactsArray:[NSDictionary] = []
    //联系人为空
    var isEmptyContactBook = false
    
    let navigationBarInChooseContactView:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 27, width: UIScreen.main.bounds.width, height: 45))
    let searchBarInChooseContactView:UISearchBar = UISearchBar.init(frame: CGRect(x: 0, y: 71, width: UIScreen.main.bounds.width, height: 45))
    
    let grayLayer:UIView = UIView.init(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-27))
    let searchMatchedResultLayer:UIView = UIView.init(frame: CGRect(x: 0, y: 63, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-27))
    
    lazy var seachMatchedResultTableView:UITableView = {
        //height -72 调好的 /// y = 117
        var heightOfTableView = UIScreen.main.bounds.height - 116
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.white
        return tempTableView
    }()
    
    lazy var chooseContactTableView:UITableView = {
        //height -72 调好的 /// y = 117
        var heightOfTableView = UIScreen.main.bounds.height - 116
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 117, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.white
        return tempTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        navigationBarInChooseContactView.isHidden = false
        navigationBarInChooseContactView.backgroundColor = UIColor.white
        navigationBarInChooseContactView.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "选择联系人"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationBarInChooseContactView.pushItem(navItem, animated: false)
        
        //设置搜索栏
        searchBarInChooseContactView.backgroundColor = UIColor.white
        searchBarInChooseContactView.barTintColor = UIColor.white
        searchBarInChooseContactView.searchBarStyle = .minimal
        searchBarInChooseContactView.placeholder = "搜索"
        searchBarInChooseContactView.setValue("取消", forKey: "_cancelButtonText")
        if !isEmptyContactBook{
            self.view.addSubview(chooseContactTableView)
            loadOrderDataFromServer()
        }

        self.view.addSubview(navigationBarInChooseContactView)
        
        searchBarInChooseContactView.delegate = self
        self.view.addSubview(searchBarInChooseContactView)
    }
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - SearchBar delegate
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        grayLayer.backgroundColor = UIColor.gray
        grayLayer.alpha = 0.4
        self.view.addSubview(grayLayer)
        
        UIView.animate(withDuration: 0.3, delay:0.1, options:.curveEaseOut, animations: {()->Void in
            self.searchBarInChooseContactView.transform = CGAffineTransform(translationX: 0, y: -53)
            self.grayLayer.transform = CGAffineTransform(translationX: 0, y: -53)
            self.chooseContactTableView.transform = CGAffineTransform(translationX: 0, y: -53)
            self.view.bringSubview(toFront: self.searchBarInChooseContactView)
            self.searchBarInChooseContactView.setShowsCancelButton(true, animated: true)

        }, completion: {
            Void in
            let searchText = self.searchBarInChooseContactView.text
            if searchText == "" {
                if self.view.subviews.contains(self.searchMatchedResultLayer){
                    self.searchMatchedResultLayer.removeFromSuperview()
                }
            }else { // 匹配用户输入内容的前缀(不区分大小写)
                self.contactsMatchedArray.removeAll()
                for contactsArrayItem in self.contactsArray {
                    let isUserNikeNameMatched = (contactsArrayItem.value(forKey: "nickname") as! String).lowercased().hasSuffix((searchText?.lowercased())!)
                    let isUserIDMatched = (contactsArrayItem.value(forKey: "userid") as! String).lowercased().hasSuffix((searchText?.lowercased())!)
                    
                    if isUserNikeNameMatched || isUserIDMatched{
                        self.contactsMatchedArray.append(contactsArrayItem)
                    }
                }
                if self.view.subviews.contains(self.searchMatchedResultLayer){
                    self.seachMatchedResultTableView.reloadData()
                }else{
                    self.searchMatchedResultLayer.backgroundColor = UIColor.white
                    self.view.addSubview(self.searchMatchedResultLayer)
                    self.searchMatchedResultLayer.addSubview(self.seachMatchedResultTableView)
                    self.view.bringSubview(toFront: self.searchBarInChooseContactView)
                }
            }
            
        })
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if self.view.subviews.contains(searchMatchedResultLayer){
            searchMatchedResultLayer.removeFromSuperview()
        }

        print("cancel button clicked")
        UIView.animate(withDuration: 0.3, delay:0.1, options:.curveEaseOut, animations: {()->Void in
            self.searchBarInChooseContactView.transform = CGAffineTransform(translationX: 0, y: -1)
            self.grayLayer.transform = CGAffineTransform(translationX: 0, y: -1)
            self.chooseContactTableView.transform = CGAffineTransform(translationX: 0, y: -1)
            self.searchBarInChooseContactView.setShowsCancelButton(false, animated: true)
            self.grayLayer.removeFromSuperview()
            
        }, completion: {
            Void in
            self.searchBarInChooseContactView.resignFirstResponder()
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 没有搜索内容时显示全部组件
        if searchText == "" {
            if self.view.subviews.contains(searchMatchedResultLayer){
                searchMatchedResultLayer.removeFromSuperview()
            }
        }
        else { // 匹配用户输入内容的前缀(不区分大小写)
            self.contactsMatchedArray.removeAll()
            for contactsArrayItem in self.contactsArray {
                let isUserNikeNameMatched = (contactsArrayItem.value(forKey: "nickname") as! String).lowercased().hasSuffix((searchText.lowercased()))
                let isUserIDMatched = (contactsArrayItem.value(forKey: "userid") as! String).lowercased().hasSuffix((searchText.lowercased()))
                if isUserNikeNameMatched || isUserIDMatched{
                    self.contactsMatchedArray.append(contactsArrayItem)
                }
            }
            if self.view.subviews.contains(searchMatchedResultLayer){
                self.seachMatchedResultTableView.reloadData()
            }else{
                searchMatchedResultLayer.backgroundColor = UIColor.white
                self.view.addSubview(searchMatchedResultLayer)
                searchMatchedResultLayer.addSubview(seachMatchedResultTableView)
                self.view.bringSubview(toFront: searchBarInChooseContactView)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let temp = range.location == 0 && range.length == 1 //定位到删除最后一个字符操作
        let temp2 = range.location == 0 && range.length == 0 //定位到添加第一个字符
        
        if temp{
            if self.view.subviews.contains(searchMatchedResultLayer){
                searchMatchedResultLayer.removeFromSuperview()
            }
        }
        return true
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEqual(seachMatchedResultTableView){
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView.isEqual(seachMatchedResultTableView){
            return contactsMatchedArray.count
        }else{
            return contactCount
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(seachMatchedResultTableView){
            let cell = chooseContactTableViewCell.customCell(tableView: seachMatchedResultTableView)
            cell.selectionStyle = .none
            
            let contactItem:NSDictionary = contactsMatchedArray[indexPath.row]
            let userName = contactItem.value(forKey: "nickname") as! String
            let userID = Int(contactItem.value(forKey: "userid") as! String) as! Int
            cell.settingCellData(title: userName, contactID: userID)
            return cell
        }else{
            let cell = chooseContactTableViewCell.customCell(tableView: chooseContactTableView)
            cell.selectionStyle = .none
            let contactItem:NSDictionary = contactsArray[indexPath.row]
            let userName = contactItem.value(forKey: "nickname") as! String
            let userID = Int(contactItem.value(forKey: "userid") as! String) as! Int
            cell.settingCellData(title: userName, contactID: userID)
            return cell
        }

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(seachMatchedResultTableView){
            let contactItem:NSDictionary = contactsMatchedArray[indexPath.row]
            let userName = contactItem.value(forKey: "nickname") as! String
            let userID = Int(contactItem.value(forKey: "userid") as! String) as! Int
            workZoneVCObject.contactedUserID = "\(userID)"
            workZoneVCObject.setPostToPplTextField(text: userName)
            self.dismiss(animated: true, completion: nil)
        }else{
            let contactItem:NSDictionary = contactsArray[indexPath.row]
            let userName = contactItem.value(forKey: "nickname") as! String
            let userID = Int(contactItem.value(forKey: "userid") as! String) as! Int
            workZoneVCObject.contactedUserID = "\(userID)"
            workZoneVCObject.setPostToPplTextField(text: userName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //从plist获取联系人数目
        let plistFile = Bundle.main.path(forResource: "contactList", ofType: "plist")
        let tempContacts = NSArray.init(contentsOfFile: plistFile!)
        contactsArray.removeAll()
        if tempContacts?.count == 0{
            isEmptyContactBook = true
            print("empty contacts list")
            loadOrderDataFromServer()
        }else{
        isEmptyContactBook = false
        print(tempContacts)
        contactCount = (tempContacts?.count)!
            for index in 0..<contactCount {
                contactsArray.append(tempContacts![index] as! NSDictionary)
            }
            //self.view.addSubview(chooseContactTableView)
        }
        self.view.backgroundColor = UIColor.white
    }
 
    //加载数据
    func loadOrderDataFromServer() {
        print("进程数\(chooseContactViewController.requestCacheArr.count)")
        //去除未完成的数据请求
        for task in chooseContactViewController.requestCacheArr{
            task.cancel()
        }
        chooseContactViewController.requestCacheArr.removeAll()
        //先删除重试按钮
        if self.view.viewWithTag(300) != nil{ //200,201tag是重试按钮的view
            self.view.viewWithTag(300)?.removeFromSuperview()
            self.view.viewWithTag(301)?.removeFromSuperview()
        }
        //先删除没有订单的提示信息
        if self.view.viewWithTag(901) != nil{
            self.view.viewWithTag(901)?.removeFromSuperview()
            self.view.viewWithTag(902)?.removeFromSuperview()
            self.view.viewWithTag(903)?.removeFromSuperview()
        }
        
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
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
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()

        if isEmptyContactBook {
            self.view.addSubview(imageView)
            self.view.addSubview(noticeWhenLoadingData)
        }
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        
        #if DEBUG
            let getContactListOfURL:String = apiAddresses.value(forKey: "contactListAPIDebug") as! String
        #else
            let getContactListOfURL:String = apiAddresses.value(forKey: "contactListAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
        
        //从datacore获取用户数据
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<UserAccount>(entityName:"UserAccount")
        let fetchRequestOfToken = NSFetchRequest<TokenRestored>(entityName:"TokenRestored")
        //        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //        fetchRequest.fetchOffset = 0 //查询到偏移量
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequestOfToken.returnsObjectsAsFaults = false
        
        // 设置查询条件
        let predicate = NSPredicate(format: "id = '1'")
        fetchRequest.predicate = predicate
        
        // 设置查询条件
        let predicateOfToken = NSPredicate(format: "id = '1'")
        fetchRequestOfToken.predicate = predicateOfToken
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            //遍历查询结果
            for info in fetchedObjects{
                //更新数据
                //设置获取全部订单参数组
                params["userid"] =  info.userId
                params["roletype"] = "\(info.roleType)"
                params["commandcode"] = 14//查看任务详情
                try managedObjectContext.save()
            }
        } catch  {
            fatalError("获取失败")
        }
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequestOfToken)
            
            //遍历查询结果
            for info in fetchedObjects{
                //更新数据
                //设置获取全部订单参数组
                params["token"] = info.token
                try managedObjectContext.save()
            }
        } catch  {
            fatalError("获取失败")
        }
        for item in params{
            print(item)
        }
        
        let dataRequest = Alamofire.request(getContactListOfURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                let json = JSON(responseObject.result.value)
                if let value = responseObject.result.value{
                    let json = JSON(value)

                    let plistFile = Bundle.main.path(forResource: "contactList", ofType: "plist")
                    //临时存储联系人列表
                    var tempContactArray:[NSDictionary] = []
                    let emptyArray:NSArray = []
                    emptyArray.write(toFile: plistFile!, atomically: true)
                    self.contactsArray.removeAll()
                    for item in json["userlistinfo"].array! {
                        let restoreItem = item.dictionaryObject! as NSDictionary
                        tempContactArray.append(restoreItem)
                        self.contactsArray.append(restoreItem)
                    }
                    
                    let array = NSArray(array: tempContactArray)
                    //将数组写入联系人列表
                    array.write(toFile: plistFile!, atomically: true)
                    print("filePath:\(plistFile)")
                    
                    if self.isEmptyContactBook{
                        self.contactCount = tempContactArray.count
                        self.view.addSubview(self.chooseContactTableView)
                        self.isEmptyContactBook = false
                    }
                        self.chooseContactTableView.reloadData()
                    
                    //删除动画
                    if self.view.subviews.contains(imageView){
                        imageView.removeFromSuperview()
                        noticeWhenLoadingData.removeFromSuperview()
                    }
                    
                }
            case false:
                //加载出错，如果还没有数据显示，就删除表格，显示重拾
                if self.view.subviews.contains(self.chooseContactTableView) && self.contactCount == 0{
                    self.chooseContactTableView.removeFromSuperview()
                    if responseObject.result.error?.localizedDescription != "cancelled" && responseObject.result.error?.localizedDescription as! String != "已取消"{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            print(responseObject.result.error ?? "No result found")
                            greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                            let loadingFailedLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200))
                            loadingFailedLabel.text = "加载失败，请重试..."
                            loadingFailedLabel.tag = 300
                            loadingFailedLabel.font = UIFont.systemFont(ofSize: 14)
                            loadingFailedLabel.textColor = UIColor.gray
                            loadingFailedLabel.textAlignment = .center
                            
                            let retryBtn:UIButton = UIButton.init(type: .system)
                            retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 - 50, width: 150, height: 44)
                            retryBtn.backgroundColor = UIColor.white
                            retryBtn.layer.cornerRadius = 5
                            retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
                            retryBtn.layer.borderWidth = 1
                            retryBtn.setTitle("重试", for: .normal)
                            retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
                            retryBtn.tag = 301
                            retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
                            //先删除重试按钮
                            self.view.viewWithTag(300)?.removeFromSuperview()
                            self.view.viewWithTag(301)?.removeFromSuperview()
                            
                            self.view.addSubview(loadingFailedLabel)
                            self.view.addSubview(retryBtn)
                        }
                    }

                }
                if !self.view.subviews.contains(self.chooseContactTableView) && self.contactCount == 0{
                    self.emytyAreaShowingLabel(withRetry: true)
                }
                //加载出错，如果已经有数据显示了，就不删除表格，不提示
                if self.view.subviews.contains(imageView){
                    imageView.removeFromSuperview()
                    noticeWhenLoadingData.removeFromSuperview()
                }
            }
        }
        chooseContactViewController.requestCacheArr.append(dataRequest)
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        //什么都没有
        let sizeOfNothing:Int = Int(UIScreen.main.bounds.width - 200)
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 200, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 20 , width: 200, height: 44))
        nothingToSHowLabel.text = "这里还什么都没有呢"
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.tag = 901
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
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
            self.view.addSubview(retryBtn)
        }
    }
    @objc func retryBtnInViewClicked(){
        loadOrderDataFromServer()
    }
    /*
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
