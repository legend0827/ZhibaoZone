//
//  TastsViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 03/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class TastsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    var roleType = 1//1 客服 2设计师 3 工厂 0 普通用户
    var toDealNum = 0//待处理任务数
    var historyNum = 0 //历史任务数
    var page: Int = 1
    var totalPageCount: Int = 1
    //任务
    var taskListArray:[NSDictionary] = []
    
    let WaitForDealingModelLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: 200, height: 30))
    let SwitchModelBtn:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70 , y: 10, width: 60, height: 30))

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskListTableViewCell.customCell(tableView: TaskListTableView)
        
        let dictionaryObjectInTaskArray = taskListArray[indexPath.row]
       
        if dictionaryObjectInTaskArray.value(forKey: "tasksendtime") as? String == nil{
            cell.taskCreateTimeInList.text = "2017-01-01 12:00:00"
        }else{
            cell.taskCreateTimeInList.text = (dictionaryObjectInTaskArray.value(forKey: "tasksendtime") as! String)
        }

        
        if dictionaryObjectInTaskArray.value(forKey: "taskinfo") as? String == nil{
            cell.taskContentInList.textColor = UIColor.gray
            cell.taskContentInList.text = "无任务内容"
        }else{
            cell.taskContentInList.text = (dictionaryObjectInTaskArray.value(forKey: "taskinfo") as! String)
        }
        
        if dictionaryObjectInTaskArray.value(forKey: "orderid") as? String == nil{
            cell.taskOrderIDInList.textColor = UIColor.gray
            cell.taskOrderIDInList.text = "未指定订单号"
        }else{
            cell.taskOrderIDInList.text = (dictionaryObjectInTaskArray.value(forKey: "orderid") as! String)
        }
        
        if dictionaryObjectInTaskArray.value(forKey: "tasksendername") as? String == nil{
            cell.taskSenderUserNameInList.textColor = UIColor.gray
            cell.taskSenderUserNameInList.text = "未指定发送者"
        }else{
            cell.taskSenderUserNameInList.text = (dictionaryObjectInTaskArray.value(forKey: "tasksendername") as! String)
        }
        
        if dictionaryObjectInTaskArray.value(forKey: "taskperiod") as? Int == nil{
            cell.taskDeadLineInList.textColor = UIColor.gray
            cell.taskDeadLineInList.text = "未指定任务期限"
        }else{
            cell.taskDeadLineInList.text = "\(dictionaryObjectInTaskArray.value(forKey: "taskperiod") as! Int)分钟"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionaryObjectInTaskArray = taskListArray[indexPath.row]
        
        var taskID:String
        if dictionaryObjectInTaskArray.value(forKey: "taskid") as? String == nil{
            print("there's no such mission")
            greyLayerPrompt.show(text: "错误任务")
            return
            taskID = "1"
        }else{
            taskID = dictionaryObjectInTaskArray.value(forKey: "taskid") as! String
        }
        
        var customeID:String
        if dictionaryObjectInTaskArray.value(forKey: "customid") as? String == nil{
           // print("there's no such mission")
           // greyLayerPrompt.show(text: "错误任务")
            customeID = "null"
            //return
        }else{
            customeID = dictionaryObjectInTaskArray.value(forKey: "customid") as! String
        }
        
        var TaskType:Int?
        if dictionaryObjectInTaskArray.value(forKey: "tasktype") as? String == nil{
            // print("there's no such mission")
            // greyLayerPrompt.show(text: "错误任务")
            TaskType = 0
            //return
        }else{
            TaskType = dictionaryObjectInTaskArray.value(forKey: "tasktype") as! Int
        }
        
        var OrderID:String?
        if dictionaryObjectInTaskArray.value(forKey: "orderid") as? String == nil{
            // print("there's no such mission")
            // greyLayerPrompt.show(text: "错误任务")
            OrderID = "null"
            //return
        }else{
            OrderID = dictionaryObjectInTaskArray.value(forKey: "orderid") as! String
        }
        var GoodsID:String?
        if dictionaryObjectInTaskArray.value(forKey: "goodsid") as? String == nil{
            // print("there's no such mission")
            // greyLayerPrompt.show(text: "错误任务")
            GoodsID = "null"
            //return
        }else{
            GoodsID = dictionaryObjectInTaskArray.value(forKey: "goodsid") as! String
        }
        let taskDetailView = TaskDetailViewController(currentTaskID: taskID, currentCustomid: customeID, currentOrderID: OrderID!, currentGoodsID: GoodsID!, currentTaskType: TaskType!)
        self.present(taskDetailView, animated: true, completion: nil)
        //self.navigationController?.pushViewController(taskDetailView, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1//CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        return view
    }
    
    lazy var TaskListTableView:UITableView = {
        //height -77 调好的
        var heightOfTableView = UIScreen.main.bounds.height - 96
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        
        return tempTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if roleType != 0 {
            //加载订单数据
            SwitchModelBtn.isOn = true
            SwitchModelBtn.addTarget(self, action: #selector(swithValueChanged), for: .valueChanged)
            WaitForDealingModelLabel.text = "仅显示待处理"
            WaitForDealingModelLabel.font = UIFont.boldSystemFont(ofSize: 15)
            
            self.view.addSubview(WaitForDealingModelLabel)
            self.view.addSubview(SwitchModelBtn)
            
            TaskListTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            TaskListTableView.isScrollEnabled = true
            TaskListTableView.rowHeight = UITableViewAutomaticDimension
            TaskListTableView.estimatedRowHeight = 100
            TaskListTableView.separatorStyle = .none//.none
            TaskListTableView.separatorColor = UIColor.clear
            //调试一下，展示隐藏
            loadOrderDataFromServer(pages: 1)
            //添加下拉刷新
            //addPullToRefresh(animator: header)
            TaskListTableView.es.addPullToRefresh {
                [weak self] in
                self?.refresh()
            }
            //添加上拉加载
            //addInfiniteScrolling(animator: footer)
            TaskListTableView.es.addInfiniteScrolling {
                [weak self] in
                self?.loadMore()
            }

        }
    }
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page = 1
            self.taskListArray.removeAll()
            self.loadOrderDataFromServer(pages:self.page)
        }
    }
    
    private func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.page += 1
            if self.page <= self.totalPageCount{
                self.loadOrderDataFromServer(pages: self.page)
                self.TaskListTableView.reloadData()
                self.TaskListTableView.es.stopLoadingMore()
            }else{
                self.TaskListTableView.es.noticeNoMoreData()
            }
        }
    }
    @objc func swithValueChanged(){
        taskListArray.removeAll()
        if SwitchModelBtn.isOn{
            print("load data for 待处理")
        }else{
            print("load data for 全部任务")
        }
        TaskListTableView.removeFromSuperview()
        loadOrderDataFromServer(pages: 1)
    }
    //加载数据
    func loadOrderDataFromServer(pages:Int) {
        //去除未完成的数据请求
        for task in TastsViewController.requestCacheArr{
            task.cancel()
        }
        TastsViewController.requestCacheArr.removeAll()
        //先删除重试按钮
        if self.view.viewWithTag(200) != nil{ //200,201tag是重试按钮的view
            self.view.viewWithTag(200)?.removeFromSuperview()
            self.view.viewWithTag(201)?.removeFromSuperview()
        }
        //先删除没有订单的提示信息
        if self.view.viewWithTag(801) != nil{
            self.view.viewWithTag(801)?.removeFromSuperview()
            self.view.viewWithTag(802)?.removeFromSuperview()
            self.view.viewWithTag(803)?.removeFromSuperview()
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
        if self.view.subviews.contains(TaskListTableView) {
            print("view exists")
        }else{
            print("view not exists")
            self.view.addSubview(imageView)
            self.view.addSubview(noticeWhenLoadingData)
        }
        
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        
        #if DEBUG
            var listOfURL:String = apiAddresses.value(forKey: "taskListDealingAPIDebug") as! String
            if SwitchModelBtn.isOn {
                //待处理任务
                listOfURL = apiAddresses.value(forKey: "taskListDealingAPIDebug") as! String
            }else{
                //历史任务
                listOfURL = apiAddresses.value(forKey: "taskListHistoryAPIDebug") as! String
            }
        #else
            var listOfURL:String = apiAddresses.value(forKey: "taskListDealingAPI") as! String
            if SwitchModelBtn.isOn {
                //待处理任务
                listOfURL = apiAddresses.value(forKey: "taskListDealingAPI") as! String
            }else{
                //历史任务
                listOfURL = apiAddresses.value(forKey: "taskListHistoryAPI") as! String
            }
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
                params["userId"] =  info.userId
                params["roleType"] = "\(info.roleType)"
                params["currentPage"] = pages
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
    
        let dataRequest = Alamofire.request(listOfURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            print("there's \(TastsViewController.requestCacheArr.count) task is running")
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    //print(json)
                    if self.SwitchModelBtn.isOn{
                        self.toDealNum = json["taskinfo","todealtask"].count//获取待处理任务总数
                        if self.toDealNum != 0{
                            self.totalPageCount = json["taskinfo","todealnum"].int!/self.toDealNum//获取待处理任务总数
                            print("每页5条,总共\(self.totalPageCount)页")
                            for item in json["taskinfo","todealtask"].array! {
                                let restoreItem = item.dictionaryObject! as NSDictionary
                                self.taskListArray.append(restoreItem)
                            }
                            if self.view.subviews.contains(self.TaskListTableView) {
                                print("view  exists")
                            }else{
                                self.view.addSubview(self.TaskListTableView)
                                print("view not exists")
                                imageView.removeFromSuperview()
                                noticeWhenLoadingData.removeFromSuperview()
                            }
                            self.TaskListTableView.reloadData()
                            self.TaskListTableView.es.stopPullToRefresh()
                        }else{
                            if pages == 1{
                                imageView.removeFromSuperview()
                                noticeWhenLoadingData.removeFromSuperview()
                                self.emytyAreaShowingLabel(withRetry: true)
                            }else{
                                self.TaskListTableView.es.noticeNoMoreData()
                            }
                        }
                    }else{
                        self.historyNum = json["taskinfo","historytask"].count//获取历史任务总数
                        if self.historyNum != 0{
                            self.totalPageCount = json["taskinfo","historynum"].int!/self.historyNum//获取历史任务总数
                            print("每页5条,总共\(self.totalPageCount)页")
                            for item in json["taskinfo","historytask"].array! {
                                let restoreItem = item.dictionaryObject! as NSDictionary
                                self.taskListArray.append(restoreItem)
                                }
                            if self.view.subviews.contains(self.TaskListTableView) {
                                print("view  exists")
                            }else{
                                self.view.addSubview(self.TaskListTableView)
                                print("view not exists")
                                imageView.removeFromSuperview()
                                noticeWhenLoadingData.removeFromSuperview()
                            }
                            self.TaskListTableView.reloadData()
                            self.TaskListTableView.es.stopPullToRefresh()
                        }else{
                            if pages == 1{
                                imageView.removeFromSuperview()
                                noticeWhenLoadingData.removeFromSuperview()
                                self.emytyAreaShowingLabel(withRetry: true)
                            }else{
                                self.TaskListTableView.es.noticeNoMoreData()
                            }
                        }
                    }
                    

                }
            case false:
                if self.view.subviews.contains(self.TaskListTableView) {
                    print("view  exists")
                    self.TaskListTableView.removeFromSuperview()
                }else{
                    print("view not exists")
                    imageView.removeFromSuperview()
                    noticeWhenLoadingData.removeFromSuperview()
                }
                if responseObject.result.error?.localizedDescription != "cancelled" && responseObject.result.error?.localizedDescription as! String != "已取消"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        print(responseObject.result.error ?? "No result found")
                        if responseObject.result.error?.localizedDescription as! String == "The Internet connection appears to be offline."{
                            greyLayerPrompt.show(text: "未接入网络，请接入网络再试")
                        }else{
                            if responseObject.result.error?.localizedDescription as! String != "JSON could not be serialized because of error:\nThe data couldn’t be read because it isn’t in the correct format." && responseObject.error?.localizedDescription as! String != "Response could not be serialized, input data was nil or zero length."{
                                greyLayerPrompt.show(text: "糟糕，服务器出了一点问题，请稍后再试")
                            }
                            
                        }
                        let loadingFailedLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200))
                        loadingFailedLabel.text = "加载失败，请重试..."
                        loadingFailedLabel.tag = 200
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
                        retryBtn.tag = 201
                        retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
                        //先删除重试按钮
                        self.view.viewWithTag(200)?.removeFromSuperview()
                        self.view.viewWithTag(201)?.removeFromSuperview()
                        
                        self.view.addSubview(loadingFailedLabel)
                        self.view.addSubview(retryBtn)
                    }
                }
            }
        }
        TastsViewController.requestCacheArr.append(dataRequest)
    }
    @objc func retryBtnInViewClicked(){
        taskListArray.removeAll()
        loadOrderDataFromServer(pages: 1)
        
    }
    
    func emytyAreaShowingLabel(withRetry:Bool) {
        //什么都没有
        let sizeOfNothing:Int = Int(UIScreen.main.bounds.width - 200)
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 200, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 20 , width: 200, height: 44))
        nothingToSHowLabel.text = "这里还什么都没有呢"
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.tag = 801
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        nothingToShow.tag = 803
        self.view.addSubview(nothingToShow)
        if withRetry {
            let retryBtn:UIButton = UIButton.init(type: .system)
            retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 + 50, width: 150, height: 44)
            retryBtn.backgroundColor = UIColor.white
            retryBtn.layer.cornerRadius = 5
            retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
            retryBtn.layer.borderWidth = 1
            retryBtn.tag = 802
            retryBtn.setTitle("再试试", for: .normal)
            retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
            retryBtn.addTarget(self, action: #selector(self.retryBtnInViewClicked), for: .touchUpInside)
            self.view.addSubview(retryBtn)
        }
    }
    func emytyAreaShowingLabel(){
        //什么都没有
        let sizeOfNothing:Int = Int(UIScreen.main.bounds.width - 200)
        let nothingToShow = UIImageView(frame: CGRect(x: 100, y:Int((UIScreen.main.bounds.height)/2) - 200, width: sizeOfNothing, height: sizeOfNothing))
        //设置文字标签
        let nothingToSHowLabel:UILabel = UILabel.init(frame:CGRect(x: (sizeOfNothing + 200)/2-sizeOfNothing/2, y: Int((UIScreen.main.bounds.height)/2) - 20 , width: 200, height: 44))
        nothingToSHowLabel.text = "这里还什么都没有呢"
        nothingToSHowLabel.alpha = 0.4
        nothingToSHowLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        nothingToSHowLabel.font = UIFont.systemFont(ofSize: 15)
        nothingToSHowLabel.textAlignment = .center
        self.view.addSubview(nothingToSHowLabel)
        
        nothingToShow.image = UIImage(named:"nothing")
        nothingToShow.alpha = 0.4
        self.view.addSubview(nothingToShow)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
