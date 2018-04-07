//
//  SetParamtersViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreData

class SetParamtersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var _roleType = 0
    
    var MeVC = MeViewController()

    //导航栏
    
    //参数设置页面
    
    let labelTextDic:NSDictionary = ["0":"系统消息",
                                     "1":"发起询价",
                                     "2":"报价",
                                     "3":"定价",
                                     "4":"发起设计",
                                     "5":"接受设计单",
                                     "6":"提交设计稿",
                                     "7":"重新设计",
                                     "8":"定稿",
                                     "9":"付款",
                                     "10":"发送新订单",
                                     "11":"开始生产",
                                     "12":"中断生产",
                                     "13":"邮递",
                                     "14":"确认收货",
                                     "15":"发起售后",
                                     "16":"退货后退款",
                                     "17":"退款",
                                     "18":"退货后重做",
                                     "19":"重做",
                                     "20":"确认退款",
                                     "21":"信息交流",
                                     "22":"催单信息",
                                     "23":"其他信息"]
    let labelArrayForCustomerService:[String] = ["0","2","5","6","11","13","21","23"]
    let labelArrayForFactory:[String] = ["0","1","3","10","12","14","15","21","23"]
    let labelArrayForDesigner:[String] = ["0","4","7","8","21","22","23"]
    
    var currentRolesArray:[String] = []
    var setItemTag:Int = 0
    
    var selectorParamters = [Int:String]()
    
    let navigationBarInParameterSettings:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 27, width: UIScreen.main.bounds.width, height: 45))
    
    //报价的滑动条
    lazy var quotePriceWeightSlideBar:MarkSlider = {
        var tempSliderBar = MarkSlider.init(frame: CGRect(x: 15, y: 7, width: UIScreen.main.bounds.width - 30, height: 20))
        tempSliderBar.markPositions = [1,10,100]
        tempSliderBar.isContinuous = false
        tempSliderBar.maxValue = 100
        tempSliderBar.minValue = 1
        tempSliderBar.value = 1
        tempSliderBar.addTarget(self, action: #selector(quotePriceWeightSlideBarValueChanged(_:)), for: .valueChanged)
        
        return tempSliderBar
    }()
    
    
    //消息提醒的滑动条
    lazy var msgVoiceAlertFrequencyWeightSlideBar:MarkSlider = {
        var tempSliderBar = MarkSlider.init(frame: CGRect(x: 15, y: 7, width: UIScreen.main.bounds.width - 30, height: 20))
        tempSliderBar.markPositions = [1,10,100]
        tempSliderBar.isContinuous = false
        tempSliderBar.maxValue = 100
        tempSliderBar.minValue = 1
        tempSliderBar.value = 1
        tempSliderBar.addTarget(self, action: #selector(msgVoiceAlertFrequencyWeightSlideBarValueChanged(_:)), for: .valueChanged)
        
        return tempSliderBar
    }()
    
    lazy var ParameterSettingTableView:UITableView = {
        let tempTableView:UITableView = UITableView.init(frame: CGRect(x: 0, y: 72, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tempTableView.backgroundColor = #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorColor = UIColor.colorWithRgba(230, g: 230, b: 230, a: 1.0)
        tempTableView.separatorStyle = .singleLine
        tempTableView.estimatedRowHeight = 0;
        tempTableView.estimatedSectionHeaderHeight = 0;
        tempTableView.estimatedSectionFooterHeight = 0;
        
        return tempTableView
    }()
    
    
    init(roleType:Int) {
        _roleType = roleType
        if roleType == 1{
            currentRolesArray = labelArrayForCustomerService
        }else if roleType == 2{
            currentRolesArray = labelArrayForDesigner
        }else if roleType == 3{
            currentRolesArray = labelArrayForFactory
        }else{
            print("nothing")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white // 白色背景
        
        //设置导航栏
        
        navigationBarInParameterSettings.isHidden = false
        navigationBarInParameterSettings.backgroundColor = UIColor.white
        navigationBarInParameterSettings.barTintColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 13, width: 50, height: 60))
        titleLabel.text = "参数设置"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(cancelBtnClicked))
        leftButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)], for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationBarInParameterSettings.pushItem(navItem, animated: false)
        // Do any additional setup after loading the view.
        self.view.addSubview(navigationBarInParameterSettings)
        if _roleType == 3 || _roleType == 1 || _roleType == 2{
            self.view.addSubview(ParameterSettingTableView)
        }else{
            let nothingImageView:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 50, y: 200, width: 100, height: 100))
            nothingImageView.image = UIImage(named:"sadicon-gray")
            
            let nothingLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: 310, width: 200, height: 40))
            nothingLabel.text = "当前身份没有可调整参数"
            nothingLabel.textAlignment = .center
            nothingLabel.textColor = UIColor.gray
            nothingLabel.font = UIFont.systemFont(ofSize: 13)
            self.view.addSubview(nothingLabel)
            self.view.addSubview(nothingImageView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _roleType == 3{
            if section == 0{
                return 1
            }else if section == 1{
                let currentAlertWeight = getMsgVoiceAlertFrequencyWeight()
                if currentAlertWeight == 1{
                    return 1
                }else{
                    return currentRolesArray.count
                }
            }else{
                return 1
            }
            
        }else{
            if section == 0{
                let currentAlertWeight = getMsgVoiceAlertFrequencyWeight()
                if currentAlertWeight == 1{
                    return 1
                }else{
                    return currentRolesArray.count
                }
            }else{
                return 1
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if _roleType == 3{
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        cell.selectionStyle = .none
        if _roleType == 3{
            
            if indexPath.section == 0{
                let startMarkLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 25, width: 80, height: 44))
                startMarkLabel.text = "+¥1.00"
                startMarkLabel.textColor = UIColor.orange
                startMarkLabel.font = UIFont.systemFont(ofSize: 13)
                let midMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 60, y: 25, width: 80, height: 44))
                midMarkLabel.text = "+¥10.00"
                midMarkLabel.textAlignment = .center
                midMarkLabel.textColor = UIColor.orange
                midMarkLabel.font = UIFont.systemFont(ofSize: 13)
                
                let endMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 75, y: 25, width: 80, height: 44))
                endMarkLabel.text = "+¥100.00"
                endMarkLabel.textColor = UIColor.orange
                midMarkLabel.textAlignment = .right
                endMarkLabel.font = UIFont.systemFont(ofSize: 13)
                let quotePriceWeight = getQuotePriceWeight()
                print("quotePriceWeight\(quotePriceWeight)")
                var WeightValue:Float = 1.0
                
                cell.addSubview(quotePriceWeightSlideBar)
                if quotePriceWeight == 10{
                    WeightValue = 50
                }else if quotePriceWeight == 100{
                    WeightValue = 100
                }else{
                    WeightValue = 1
                }
                quotePriceWeightSlideBar.setValue(WeightValue, animated: true)
                cell.addSubview(startMarkLabel)
                cell.addSubview(midMarkLabel)
                cell.addSubview(endMarkLabel)
            }else{
                if indexPath.row == 0{
                    let startMarkLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 25, width: 80, height: 44))
                    startMarkLabel.text = "不提醒"
                    startMarkLabel.textColor = UIColor.orange
                    startMarkLabel.font = UIFont.systemFont(ofSize: 13)
                    let midMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 60, y: 25, width: 80, height: 44))
                    midMarkLabel.text = "1次"
                    midMarkLabel.textAlignment = .center
                    midMarkLabel.textColor = UIColor.orange
                    midMarkLabel.font = UIFont.systemFont(ofSize: 13)
                    
                    let endMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 75, y: 25, width: 80, height: 44))
                    endMarkLabel.text = "持续提醒"
                    endMarkLabel.textColor = UIColor.orange
                    midMarkLabel.textAlignment = .right
                    endMarkLabel.font = UIFont.systemFont(ofSize: 13)
                    let msgVoiceAlertFrequencyWeight = getMsgVoiceAlertFrequencyWeight()
                    var WeightValue:Float = 1.0
                    
                    cell.addSubview(msgVoiceAlertFrequencyWeightSlideBar)
                    if msgVoiceAlertFrequencyWeight == 10{
                        WeightValue = 50
                    }else if msgVoiceAlertFrequencyWeight == 100{
                        WeightValue = 100
                    }else{
                        WeightValue = 1
                    }
                    msgVoiceAlertFrequencyWeightSlideBar.setValue(WeightValue, animated: true)
                    cell.addSubview(startMarkLabel)
                    cell.addSubview(midMarkLabel)
                    cell.addSubview(endMarkLabel)
                }else{
                    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 5, width: 100, height: 34))
                    
                    titleLabel.text = labelTextDic.value(forKey: currentRolesArray[indexPath.row - 1]) as! String
                    titleLabel.font = UIFont.systemFont(ofSize: 13)
                    titleLabel.textColor = UIColor.black
                    
                    let switchBtn:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70 , y: 7, width: 60, height: 30))
                    switchBtn.isOn = getMSGAlertSettings(index: Int(currentRolesArray[indexPath.row - 1])!)//checkSecuritySetting().1 //返回值，前一个是未设置安全登录（true 是，false 否），后一个当前是关着还是开着的(true 开， false 关）
                    switchBtn.tag = indexPath.row - 1 + 100
                    selectorParamters[indexPath.row - 1] = "\(indexPath.row - 1 + 100)"
                    switchBtn.addTarget(self, action: #selector(switchForEachItemChanged), for: .valueChanged)
                    cell.addSubview(titleLabel)
                    cell.addSubview(switchBtn)
                }
            }
                
        }else{
            if indexPath.row == 0{
                let startMarkLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 25, width: 80, height: 44))
                startMarkLabel.text = "不提醒"
                startMarkLabel.textColor = UIColor.orange
                startMarkLabel.font = UIFont.systemFont(ofSize: 13)
                let midMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 60, y: 25, width: 80, height: 44))
                midMarkLabel.text = "1次"
                midMarkLabel.textAlignment = .center
                midMarkLabel.textColor = UIColor.orange
                midMarkLabel.font = UIFont.systemFont(ofSize: 13)
                
                let endMarkLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 75, y: 25, width: 80, height: 44))
                endMarkLabel.text = "持续提醒"
                endMarkLabel.textColor = UIColor.orange
                midMarkLabel.textAlignment = .right
                endMarkLabel.font = UIFont.systemFont(ofSize: 13)
                let msgVoiceAlertFrequencyWeight = getMsgVoiceAlertFrequencyWeight()
                var WeightValue:Float = 1.0
                
                cell.addSubview(msgVoiceAlertFrequencyWeightSlideBar)
                if msgVoiceAlertFrequencyWeight == 10{
                    WeightValue = 50
                }else if msgVoiceAlertFrequencyWeight == 100{
                    WeightValue = 100
                }else{
                    WeightValue = 1
                }
                msgVoiceAlertFrequencyWeightSlideBar.setValue(WeightValue, animated: true)
                cell.addSubview(startMarkLabel)
                cell.addSubview(midMarkLabel)
                cell.addSubview(endMarkLabel)
            }else{
                let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 5, width: 100, height: 34))
                
                titleLabel.text = labelTextDic.value(forKey: currentRolesArray[indexPath.row - 1]) as! String
                titleLabel.font = UIFont.systemFont(ofSize: 13)
                titleLabel.textColor = UIColor.black
                
                let switchBtn:UISwitch = UISwitch.init(frame: CGRect(x: UIScreen.main.bounds.width - 70 , y: 7, width: 60, height: 30))
                switchBtn.isOn = getMSGAlertSettings(index: Int(currentRolesArray[indexPath.row - 1])!)
                switchBtn.tag = indexPath.row - 1 + 100
                selectorParamters[indexPath.row - 1] = "\(indexPath.row - 1 + 100)"
                switchBtn.addTarget(self, action: #selector(switchForEachItemChanged), for: .valueChanged)
                cell.addSubview(titleLabel)
                cell.addSubview(switchBtn)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        headerview.backgroundColor = #colorLiteral(red: 0.9421117902, green: 0.9367800951, blue: 0.9586003423, alpha: 1)
        let titleLabelInCell:UILabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 200, height: 44))
        titleLabelInCell.font = UIFont.systemFont(ofSize: 13)
        titleLabelInCell.textAlignment = .left
        titleLabelInCell.textColor = UIColor.gray
        headerview.addSubview(titleLabelInCell)
        if section == 0{
            titleLabelInCell.text = "报价精度设置"
        }else if section == 1{
            titleLabelInCell.text = "消息提醒"
            let helpiConImageView:UIButton = UIButton.init(frame: CGRect(x: 76, y: 5, width: 60, height: 20))
            helpiConImageView.setImage(UIImage(named:"helpicon-gray"), for: .normal)
            helpiConImageView.setImage(UIImage(named:"helpicon-red"), for: .normal)
            helpiConImageView.addTarget(self, action: #selector(helpIconPressed), for: .touchUpInside)
            //headerview.addSubview(helpiConImageView)
        }
        return headerview
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0{
            if indexPath.row != 0{
                return 44
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    @objc func helpIconPressed(){
        let helpView = showBlurEffect(text: "消息音量设置指导")
        self.view.addSubview(helpView)
    }
    @objc func switchForEachItemChanged(_ switcher:UISwitch){
        //设置的值改变了
        for row in selectorParamters.values{
            if row == "\(switcher.tag)"{
                setItemTag = switcher.tag
            }
        }
        let setValue = switcher.isOn
        let index = setItemTag - 100
        let msgID = Int(currentRolesArray[index])
        saveMSGAlertSettings( value: setValue, index: msgID!)
    }
    
    @objc func quotePriceWeightSlideBarValueChanged(_ slider:UISlider){
        var quotePriceWeight = 1
        if slider.value <= 25 {
            quotePriceWeightSlideBar.setValue(1, animated: true)
            quotePriceWeight = 1
        }else if slider.value > 25 && slider.value <= 75{
            quotePriceWeightSlideBar.setValue(50, animated: true)
            quotePriceWeight = 10
        }else{
            quotePriceWeightSlideBar.setValue(100, animated: true)
            quotePriceWeight = 100
        }
        saveWeightToCoreData(value:quotePriceWeight,parameter: "quotePriceWeight")
    }
    
    @objc func msgVoiceAlertFrequencyWeightSlideBarValueChanged(_ slider:UISlider){
        var msgVoiceAlertFrequencyWeight = 1
        if slider.value <= 25 {
            msgVoiceAlertFrequencyWeightSlideBar.setValue(1, animated: true)
            msgVoiceAlertFrequencyWeight = 1
        }else if slider.value > 25 && slider.value <= 75{
            msgVoiceAlertFrequencyWeightSlideBar.setValue(50, animated: true)
            msgVoiceAlertFrequencyWeight = 10
        }else{
            msgVoiceAlertFrequencyWeightSlideBar.setValue(100, animated: true)
            msgVoiceAlertFrequencyWeight = 100
        }
        saveWeightToCoreData(value:msgVoiceAlertFrequencyWeight,parameter: "msgVoiceAlertFrequencyWeight")
        ParameterSettingTableView.reloadData()
    }
    
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setParametersView(roleType:Int){
        if roleType == 3{
            
        }
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

func getMSGAlertSettings(index:Int) ->Bool{
    var value = false
    //获取管理的数据上下文，对象
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<MessageAlertSettings>(entityName:"MessageAlertSettings")
    fetchRequest.returnsObjectsAsFaults = false
    // 设置查询条件
    let predicate = NSPredicate(format: "id = 1")
    fetchRequest.predicate = predicate
    
    //创建ParameterSettings对象
    let messageAlertSettings = NSEntityDescription.insertNewObject(forEntityName: "MessageAlertSettings", into: context) as! MessageAlertSettings
    //查询操作
    do {
        let fetchResults = try context.fetch(fetchRequest)
        for info in fetchResults{
            info.id = 1
                
            switch index {
            case 0:
                value = info.attribute0
            case 1:
                value = info.attribute1
            case 2:
                value = info.attribute2
            case 3:
                value = info.attribute3
            case 4:
                value = info.attribute4
            case 5:
                value = info.attribute5
            case 6:
                value = info.attribute6
            case 7:
                value = info.attribute7
            case 8:
                value = info.attribute8
            case 9:
                value = info.attribute9
            case 10:
                value = info.attribute10
            case 11:
                value = info.attribute11
            case 12:
                value = info.attribute12
            case 13:
                value = info.attribute13
            case 14:
                value = info.attribute14
            case 15:
                value = info.attribute15
            case 16:
                value = info.attribute16
            case 17:
                value = info.attribute17
            case 18:
                value = info.attribute18
            case 19:
                value = info.attribute19
            case 20:
                value = info.attribute20
            case 21:
                value = info.attribute21
            case 22:
                value = info.attribute22
            case 23:
                value = info.attribute23
            default:
                print("default")
            }
        }
    } catch {
        fatalError("保存失败\(error)")
    }
    return value
}

//创建毛玻璃效果
func showBlurEffect(text:String) -> UIVisualEffectView {
    //创建一个模糊效果
    let blurEffect = UIBlurEffect(style: .light)
    //创建一个承载模糊效果的视图
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height )
    let label = UILabel(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 100))
    label.text = text
    label.font = UIFont.systemFont(ofSize: 30)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.textColor = UIColor.black
    blurView.contentView.addSubview(label)
    // blurView.contentView.addSubview(closeBtn)
    return blurView
}

func saveMSGAlertSettings(value:Bool,index:Int){

    //获取管理的数据上下文，对象
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext

    //声明数据的请求
    let fetchRequest =  NSFetchRequest<MessageAlertSettings>(entityName:"MessageAlertSettings")
    fetchRequest.returnsObjectsAsFaults = false
    // 设置查询条件
    let predicate = NSPredicate(format: "id = 1")
    fetchRequest.predicate = predicate

    //创建ParameterSettings对象
    let messageAlertSettings = NSEntityDescription.insertNewObject(forEntityName: "MessageAlertSettings", into: context) as! MessageAlertSettings
    //查询操作
    do {
        let fetchResults = try context.fetch(fetchRequest)
        if fetchResults.count == 0 {
            //对象赋值
            messageAlertSettings.id = 1
            messageAlertSettings.attribute0 = false
            messageAlertSettings.attribute1 = false
            messageAlertSettings.attribute2 = false
            messageAlertSettings.attribute3 = false
            messageAlertSettings.attribute4 = false
            messageAlertSettings.attribute5 = false
            messageAlertSettings.attribute6 = false
            messageAlertSettings.attribute7 = false
            messageAlertSettings.attribute8 = false
            messageAlertSettings.attribute9 = false
            messageAlertSettings.attribute10 = false
            messageAlertSettings.attribute11 = false
            messageAlertSettings.attribute12 = false
            messageAlertSettings.attribute13 = false
            messageAlertSettings.attribute14 = false
            messageAlertSettings.attribute15 = false
            messageAlertSettings.attribute16 = false
            messageAlertSettings.attribute17 = false
            messageAlertSettings.attribute18 = false
            messageAlertSettings.attribute19 = false
            messageAlertSettings.attribute20 = false
            messageAlertSettings.attribute21 = false
            messageAlertSettings.attribute22 = false
            messageAlertSettings.attribute23 = false
            switch index {
            case 0:
                messageAlertSettings.attribute0 = value
            case 1:
                messageAlertSettings.attribute1 = value
            case 2:
                messageAlertSettings.attribute2 = value
            case 3:
                messageAlertSettings.attribute3 = value
            case 4:
                messageAlertSettings.attribute4 = value
            case 5:
                messageAlertSettings.attribute5 = value
            case 6:
                messageAlertSettings.attribute6 = value
            case 7:
                messageAlertSettings.attribute7 = value
            case 8:
                messageAlertSettings.attribute8 = value
            case 9:
                messageAlertSettings.attribute9 = value
            case 10:
                messageAlertSettings.attribute10 = value
            case 11:
                messageAlertSettings.attribute11 = value
            case 12:
                messageAlertSettings.attribute12 = value
            case 13:
                messageAlertSettings.attribute13 = value
            case 14:
                messageAlertSettings.attribute14 = value
            case 15:
                messageAlertSettings.attribute15 = value
            case 16:
                messageAlertSettings.attribute16 = value
            case 17:
                messageAlertSettings.attribute17 = value
            case 18:
                messageAlertSettings.attribute18 = value
            case 19:
                messageAlertSettings.attribute19 = value
            case 20:
                messageAlertSettings.attribute20 = value
            case 21:
                messageAlertSettings.attribute21 = value
            case 22:
                messageAlertSettings.attribute22 = value
            case 23:
                messageAlertSettings.attribute23 = value
            default:
                print("default")
            }
            try context.save()
            print("inserted recoreds in MessageAlertSettings")
        }else{
            for info in fetchResults{
                info.id = 1
                
                    switch index {
                    case 0:
                        info.attribute0 = value
                    case 1:
                        info.attribute1 = value
                    case 2:
                        info.attribute2 = value
                    case 3:
                        info.attribute3 = value
                    case 4:
                        info.attribute4 = value
                    case 5:
                        info.attribute5 = value
                    case 6:
                        info.attribute6 = value
                    case 7:
                        info.attribute7 = value
                    case 8:
                        info.attribute8 = value
                    case 9:
                        info.attribute9 = value
                    case 10:
                        info.attribute10 = value
                    case 11:
                        info.attribute11 = value
                    case 12:
                        info.attribute12 = value
                    case 13:
                        info.attribute13 = value
                    case 14:
                        info.attribute14 = value
                    case 15:
                        info.attribute15 = value
                    case 16:
                        info.attribute16 = value
                    case 17:
                        info.attribute17 = value
                    case 18:
                        info.attribute18 = value
                    case 19:
                        info.attribute19 = value
                    case 20:
                        info.attribute20 = value
                    case 21:
                        info.attribute21 = value
                    case 22:
                        info.attribute22 = value
                    case 23:
                        info.attribute23 = value
                    default:
                        print("default")
                    }
                    // info.quotePriceWeight = Int64(value)
                }
                try context.save()
        }
        print("new records saved")
    } catch {
        fatalError("保存失败\(error)")
    }
}

//初始化
func initMSGAlertSettings(){
    
    //获取管理的数据上下文，对象
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<MessageAlertSettings>(entityName:"MessageAlertSettings")
    fetchRequest.returnsObjectsAsFaults = false
    // 设置查询条件
    let predicate = NSPredicate(format: "id = 1")
    fetchRequest.predicate = predicate
    
    //创建ParameterSettings对象
    let messageAlertSettings = NSEntityDescription.insertNewObject(forEntityName: "MessageAlertSettings", into: context) as! MessageAlertSettings
    //查询操作
    do {
        let fetchResults = try context.fetch(fetchRequest)
        if fetchResults.count == 0 {
            //对象赋值
            messageAlertSettings.id = 1
            messageAlertSettings.attribute0 = false
            messageAlertSettings.attribute1 = true
            messageAlertSettings.attribute2 = true
            messageAlertSettings.attribute3 = true
            messageAlertSettings.attribute4 = true
            messageAlertSettings.attribute5 = false
            messageAlertSettings.attribute6 = false
            messageAlertSettings.attribute7 = false
            messageAlertSettings.attribute8 = false
            messageAlertSettings.attribute9 = false
            messageAlertSettings.attribute10 = false
            messageAlertSettings.attribute11 = false
            messageAlertSettings.attribute12 = false
            messageAlertSettings.attribute13 = false
            messageAlertSettings.attribute14 = false
            messageAlertSettings.attribute15 = false
            messageAlertSettings.attribute16 = false
            messageAlertSettings.attribute17 = false
            messageAlertSettings.attribute18 = false
            messageAlertSettings.attribute19 = false
            messageAlertSettings.attribute20 = false
            messageAlertSettings.attribute21 = false
            messageAlertSettings.attribute22 = false
            messageAlertSettings.attribute23 = false
            print("MessageAlertSettings initated")
        }else{
            print("there's a setting already")
        }
        try context.save()
        print("new records saved")
    } catch {
        fatalError("保存失败\(error)")
    }
}
func saveWeightToCoreData(value:Int,parameter:String){
    
    //获取管理的数据上下文，对象
    let app = UIApplication.shared.delegate as! AppDelegate
    let context = app.persistentContainer.viewContext
    
    //声明数据的请求
    let fetchRequest =  NSFetchRequest<ParameterSettings>(entityName:"ParameterSettings")
    fetchRequest.returnsObjectsAsFaults = false
    // 设置查询条件
    let predicate = NSPredicate(format: "id = 1")
    fetchRequest.predicate = predicate
    
    //创建ParameterSettings对象
    let parameterSettings = NSEntityDescription.insertNewObject(forEntityName: "ParameterSettings", into: context) as! ParameterSettings
    //查询操作
    do {
        let fetchResults = try context.fetch(fetchRequest)
        if fetchResults.count == 0 {
            //对象赋值
            parameterSettings.id = 1
            if parameter == "msgVoiceAlertFrequencyWeight"{
                parameterSettings.msgVoiceAlertFrequencyWeight = Int64(value)
            }else if parameter == "quotePriceWeight"{
                parameterSettings.quotePriceWeight = Int64(value)
            }else{
                print("parameter Error")
            }
            print("inserted recoreds in ParameterSettings")
        }else{
            for info in fetchResults{
                info.id = 1
                if parameter == "msgVoiceAlertFrequencyWeight"{
                    info.msgVoiceAlertFrequencyWeight = Int64(value)
                }else if parameter == "quotePriceWeight"{
                    info.quotePriceWeight = Int64(value)
                }else{
                    print("parameter Error")
                }
                // info.quotePriceWeight = Int64(value)
            }
        }
        try context.save()
        print("new records saved")
    } catch {
        fatalError("保存失败\(error)")
    }
}
