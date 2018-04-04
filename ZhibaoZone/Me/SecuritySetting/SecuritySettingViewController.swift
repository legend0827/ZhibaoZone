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
        let tempSwitch:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70, y: 7, width: 60, height: 30))
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
    
    
    @objc func switchForSecurityValueChanged(){
        if switchForSecurity.isOn{
            //返回值，前一个是已设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
            let isFirstSet = checkSecuritySetting().0
            if !isFirstSet{
                print("还未设置安全登录，是否前往设置")
                let firstSetAlertView:UIAlertController = UIAlertController(title: "设置登录密码", message: "还没设置登录密码,启用安全登录需要先设置登录密码", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "不了", style: .cancel){(UIAlertAction) in
                    print("点击了不了")
                    self.switchForSecurity.isOn = false
                }
                let toSettingAction = UIAlertAction(title: "去开启", style: .default) { (UIAlertAction) in
                    
//                    let gesture = GestureViewController()
//                    gesture.securityVC = self
//                    gesture.type = GestureViewControllerType.setting
//                    self.present(gesture, animated: true, completion: nil)
                    let verifyGesture = GestureVerifyViewController()
                    verifyGesture.presentActionType = "presenting"
                    verifyGesture.fatherVC = self
                    self.present(verifyGesture, animated: true, completion: nil)
                    updateOrWriteDataToServer(isToOpen:true,isToDelete:false)
                    
                    let key = UserDefaults.standard.object(forKey: gestureFinalSaveKey) as? String ?? nil
                    if key == nil{
                        self.switchForSecurity.isOn = false
                    }else{
                        self.switchForSecurity.isOn = true
                    }
                }
                firstSetAlertView.addAction(cancelAction)
                firstSetAlertView.addAction(toSettingAction)
                self.present(firstSetAlertView, animated: true, completion: nil)
                
            }else{
                print("开启安全登录，已经设置过了，设置开启")
                updateOrWriteDataToServer(isToOpen:true,isToDelete:false)
            }
        }else{
            //返回值，前一个是已设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
            let isFirstSet = checkSecuritySetting().0
            if !isFirstSet{
                print("关闭安全登录，不用设置")
            }else{
                print("关闭安全登录，已经设置过了，但是因为关闭，执行关闭操作")
                updateOrWriteDataToServer(isToOpen:false,isToDelete:false)
            }
        }
    }
    
    @objc func cancelBtnClicked(){
            self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
             let isFirstSet = checkSecuritySetting().0
            if switchForSecurity.isOn{
                //安全登录开着呢，一定已经设置过了，直接验证
                let gestureVerify = GestureVerifyViewController()
                gestureVerify.fatherVC = self
                self.present(gestureVerify, animated: true, completion: nil)
            }else{
                //安全登录关闭着呢，判断是不是第一次设置
                if !isFirstSet{
//                    //第一次设置，直接设置
//                    let gesture = GestureViewController()
//                    gesture.type = GestureViewControllerType.setting
//                    gesture.securityVC = self
//                    self.present(gesture, animated: true, completion: nil)
                    
                    let verifyGesture = GestureVerifyViewController()
                    verifyGesture.presentActionType = "presenting"
                    verifyGesture.fatherVC = self
                    self.present(verifyGesture, animated: true, completion: nil)
                    
                    updateOrWriteDataToServer(isToOpen:true,isToDelete:false)
                    
                    let key = UserDefaults.standard.object(forKey: gestureFinalSaveKey) as? String ?? nil
                    if key == nil{
                        switchForSecurity.isOn = false
                    }else{
                        switchForSecurity.isOn = true
                    }
                }else{
                    //不是第一次，验证并修改
                    let gestureVerify = GestureVerifyViewController()
                    gestureVerify.fatherVC = self
                    self.present(gestureVerify, animated: true, completion: nil)
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

//返回值，前一个是已设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
func checkSecuritySetting() -> (Bool,Bool){
    let key = UserDefaults.standard.object(forKey: gestureFinalSaveKey) as? String ?? nil
    
    if key == nil{
        return (false,false)
    }else{
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
                return (false,false)
            }else{
                for info in fetchedObjects{
                    return (info.setSecurityStatus,info.loginEnableStatus)
                }
            }
        } catch  {
            fatalError("获取失败")
        }
        return (false,false)
    }
}

func updateOrWriteDataToServer(isToOpen:Bool,isToDelete:Bool){
    
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
            securitySettings.setSecurityStatus = !isToDelete
            securitySettings.loginEnableStatus = isToOpen
            print("插入成功")
        }else{
            //更新数据
            for info in fetchedObjects{
                info.setSecurityStatus = !isToDelete
                info.loginEnableStatus = isToOpen
            }
        }
        try managedObjectContext.save()
        print("更新成功")
        
    } catch  {
        fatalError("获取失败")
    }
}
