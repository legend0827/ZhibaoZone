//
//  SecuritySettingViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 05/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreData

class SecuritySettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var MeVC = MeViewController()

    let navigationBarInSecuritySettings:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 27, width: UIScreen.main.bounds.width, height: 45))
    
    lazy var switchForSecurity:UISwitch = {
        let tempSwitch:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70, y: 10, width: 60, height: 30))
        tempSwitch.isOn = checkSecuritySetting().1 //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
        tempSwitch.addTarget(self, action: #selector(switchForSecurityValueChanged), for: .valueChanged)
        return tempSwitch
    }()
    
    
    lazy var SecuritySettingTableView:UITableView = {
        let tempTableView:UITableView = UITableView.init(frame: CGRect(x: 0, y: 72, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempTableView.backgroundColor = #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorColor = UIColor.clear
        tempTableView.separatorStyle = .none
        tempTableView.estimatedRowHeight = 0;
        tempTableView.estimatedSectionHeaderHeight = 0;
        tempTableView.estimatedSectionFooterHeight = 0;
        
        return tempTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        
        navigationBarInSecuritySettings.isHidden = false
        navigationBarInSecuritySettings.backgroundColor = UIColor.white
        navigationBarInSecuritySettings.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "安全设置"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationBarInSecuritySettings.pushItem(navItem, animated: false)
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(SecuritySettingTableView)
        self.view.addSubview(navigationBarInSecuritySettings)
        // Do any additional setup after loading the view.
    }
    
    //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
    func checkSecuritySetting() -> (Bool,Bool){
        //从datacore获取用户数据
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<SecuritySettings>(entityName:"SecuritySettings")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        // 设置查询条件
        let predicate = NSPredicate(format: "id = '1'")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            if fetchedObjects.count == 0{
                    return (true,false)
            }else{
                for info in fetchedObjects{
                    return (false,info.loginEnableStatus)
                }
            }
        } catch  {
            fatalError("获取失败")
        }
        return (true,false)
    }
    func updateOrWriteDataToServer(isToOpen:Bool,setPassword:String){
        //从datacore获取用户数据
        //获取管理的数据上下文，对象
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //声明数据的请求
        let fetchRequest =  NSFetchRequest<SecuritySettings>(entityName:"SecuritySettings")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        //创建User对象
        let securitySettings = NSEntityDescription.insertNewObject(forEntityName: "SecuritySettings", into: managedObjectContext) as! SecuritySettings

        // 设置查询条件
        let predicate = NSPredicate(format: "id = '1'")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            if fetchedObjects.count == 0 {

                //对象赋值
                securitySettings.id = 1
                if isToOpen{
                    securitySettings.loginEnableStatus = true
                }else{
                    securitySettings.loginEnableStatus = false
                }
                // setPassword 等于NOSTRING 表示不更新PASSWORD
                if setPassword != "NOSTRING"{
                    securitySettings.loginPassword = setPassword
                }
                securitySettings.loginPassword = "1234"
                securitySettings.setSecurityStatus = 1
                print("插入成功")
            }else{
                //更新数据
                for info in fetchedObjects{
                    if isToOpen{
                        info.loginEnableStatus = true
                    }else{
                        info.loginEnableStatus = false
                    }
                    // setPassword 等于NOSTRING 表示不更新PASSWORD
                    if setPassword != "NOSTRING"{
                        info.loginPassword = setPassword
                    }
                }
            }
            try managedObjectContext.save()
            print("更新成功")
            
        } catch  {
            fatalError("获取失败")
        }
    }
    
    @objc func switchForSecurityValueChanged(){
        if switchForSecurity.isOn{
            //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
            let isFirstSet = checkSecuritySetting().0
            if isFirstSet{
                print("还未设置安全登录，是否前往设置")
                let firstSetAlertView:UIAlertController = UIAlertController(title: "设置登录密码", message: "还没设置登录密码,启用安全登录需要先设置登录密码", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "不了", style: .cancel){(UIAlertAction) in
                    print("点击了不了")
                }
                let toSettingAction = UIAlertAction(title: "去开启", style: .default) { (UIAlertAction) in
                    print("点击了好的")
                }
                firstSetAlertView.addAction(cancelAction)
                firstSetAlertView.addAction(toSettingAction)
                self.present(firstSetAlertView, animated: true, completion: nil)
                
            }else{
                print("开启安全登录，已经设置过了，设置开启")
                updateOrWriteDataToServer(isToOpen:true,setPassword: "NOSTRING")// setPassword 等于NOSTRING 表示不更新PASSWORD
            }
        }else{
            //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
            let isFirstSet = checkSecuritySetting().0
            if isFirstSet{
                print("关闭安全登录，不用设置")
            }else{
                print("关闭安全登录，已经设置过了，但是因为关闭，执行关闭操作")
                updateOrWriteDataToServer(isToOpen:false,setPassword: "NOSTRING")// setPassword 等于NOSTRING 表示不更新PASSWORD
            }
        }
    }
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if switchForSecurity.isOn{
                let isFirstSet = checkSecuritySetting().0
                if isFirstSet{
                    print("第一次设置")
                    
                    let password:String = "1234"
                    updateOrWriteDataToServer(isToOpen:true,setPassword: password)
                }else{
                    print("改密码")
                    let password:String = "1234"
                    updateOrWriteDataToServer(isToOpen:true,setPassword: password)
                }
            }else{
                let isFirstSet = checkSecuritySetting().0
                if isFirstSet{
                    print("第一次设置")
                    let password:String = "1234"
                    updateOrWriteDataToServer(isToOpen:true,setPassword: password)
                    switchForSecurity.isOn = true
                }else{
                    print("改密码")
                    let password:String = "1234"
                    updateOrWriteDataToServer(isToOpen:true,setPassword: password)
                }
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0{
        let tempView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        tempView.backgroundColor = UIColor.clear
        return tempView
        }else{
            let tempView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01))
            tempView.backgroundColor = UIColor.clear
            return tempView
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cell.selectionStyle = .none
        let titleLabelInCell:UILabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 200, height: 44))
        titleLabelInCell.font = UIFont.systemFont(ofSize: 15)
        titleLabelInCell.textAlignment = .left
        
        if indexPath.section == 0{
            titleLabelInCell.text = "安全登录"
            cell.addSubview(switchForSecurity)
        }else {
            titleLabelInCell.text = "手势登录"
            let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 30, y: 8, width: 30, height: 30))
            
            imageViewOfArrow.image = UIImage(named:"right-arrow")
            imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:8,width:15,height:15)
            cell.addSubview(imageViewOfArrow)
        }
        
        cell.addSubview(titleLabelInCell)
        
        return cell
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
