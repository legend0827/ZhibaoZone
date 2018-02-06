//
//  TaskDetailViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 25/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class TaskDetailViewController: UIViewController {
    
    //MARK:-网络请求管理
    static fileprivate var requestCacheArr = [DataRequest]();
    var taskDetailArray:[NSDictionary] = []
    
    var currentTaskID:Int
    var currentCustomid:Int
    
    //导航栏
    let navigationBarInTaskDetail:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 30))
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrderDataFromServer()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationBarInTaskDetail.isHidden = false
        navigationBarInTaskDetail.backgroundColor = UIColor.white
        navigationBarInTaskDetail.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "任务详情"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        let rightButton = UIBarButtonItem(title: "完成任务", style: .done, target: self, action: #selector(taskFinishedBtnClicked))
        rightButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)], for: .normal)
        
        rightButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        rightButton.titleTextAttributes(for: .normal)
        
        
        navItem.setLeftBarButton(leftButton, animated: false)
        navItem.setRightBarButton(rightButton, animated: false)
        navigationBarInTaskDetail.pushItem(navItem, animated: false)
        self.view.addSubview(navigationBarInTaskDetail)
    }
    @objc func taskFinishedBtnClicked(){
        print("done pressed")
    }
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    init(currentTaskID:Int,currentCustomid:Int) {
        self.currentTaskID = currentTaskID
        self.currentCustomid = currentCustomid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载数据
    func loadOrderDataFromServer() {
        //去除未完成的数据请求
        for task in TaskDetailViewController.requestCacheArr{
            task.cancel()
        }
        TaskDetailViewController.requestCacheArr.removeAll()
        //先删除重试按钮
        if self.view.viewWithTag(300) != nil{ //200,201tag是重试按钮的view
            self.view.viewWithTag(300)?.removeFromSuperview()
            self.view.viewWithTag(301)?.removeFromSuperview()
        }
        //先删除没有订单的提示信息
        if self.view.viewWithTag(701) != nil{
            self.view.viewWithTag(701)?.removeFromSuperview()
            self.view.viewWithTag(702)?.removeFromSuperview()
            self.view.viewWithTag(703)?.removeFromSuperview()
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

        self.view.addSubview(imageView)
        self.view.addSubview(noticeWhenLoadingData)

        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        
        #if DEBUG
            var detailOfURL:String = apiAddresses.value(forKey: "taskDetailAPIDebug") as! String
        #else
            var detailOfURL:String = apiAddresses.value(forKey: "taskDetailAPI") as! String
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
                params["commandcode"] = 93//查看任务详情
                params["taskid"] = currentTaskID
                params["customid"] = currentCustomid
                
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
        
        let dataRequest = Alamofire.request(detailOfURL,method:.get, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if let value = responseObject.result.value{
                    let json = JSON(value)
                    //print(json)
                    for item in json["taskinfo","todealtask"].array! {
                        let restoreItem = item.dictionaryObject! as NSDictionary
                        self.taskDetailArray.append(restoreItem)
                    }
                    imageView.removeFromSuperview()
                    noticeWhenLoadingData.removeFromSuperview()
                    
                }
            case false:
                imageView.removeFromSuperview()
                noticeWhenLoadingData.removeFromSuperview()
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
        }
        TaskDetailViewController.requestCacheArr.append(dataRequest)
    }
    @objc func retryBtnInViewClicked(){
        taskDetailArray.removeAll()
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
