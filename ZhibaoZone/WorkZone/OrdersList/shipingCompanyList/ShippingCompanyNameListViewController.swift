//
//  ShippingCompanyNameListViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/15.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ShippingCompanyNameListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //联系人数组（原始）
    var shippingCompanyArray:[NSDictionary] = []
    let indexSource:[String] = ["D","E", "F", "G", "H", "J", "Q", "S","U", "Y", "Z","#"]
    //公司列表为空
    var isEmptyCompanyBook:Bool = true
    var companyCount = 0
    
    var actionViewObject = ActionViewInOrder(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // D
            return 1
        case 1: //E
            return 1
        case 2: //F
            return 1
        case 3: //G
            return 1
        case 4://H
            return 2
        case 5://J
            return 1
        case 6://Q
            return 1
        case 7://S
            return 3
        case 8://U
            return 1
        case 9://Y
            return 3
        case 10://Z
            return 1
        case 11://#
            return 1
        default:
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ShippingCompanyNameListTableViewCell.customCell(tableView: chooseCompanyTableView)
        cell.selectionStyle = .none

        let tempLineBottom:UIView = UIView.init(frame: CGRect(x: 20, y: 51, width: kWidth - 65, height: 1))
        tempLineBottom.backgroundColor = UIColor.lineColors(color: .lightGray)
        cell.addSubview(tempLineBottom)
        switch indexPath.section {
        case 0: // D
            cell.titleLabel.text = shippingCompanyArray[0].value(forKey: "name") as! String
        case 1: //E
            cell.titleLabel.text = shippingCompanyArray[1].value(forKey: "name") as! String
        case 2: //F
            cell.titleLabel.text = shippingCompanyArray[2].value(forKey: "name") as! String
        case 3: //G
            cell.titleLabel.text = shippingCompanyArray[3].value(forKey: "name") as! String
        case 4://H
            if indexPath.row == 0{
                cell.titleLabel.text = shippingCompanyArray[4].value(forKey: "name") as! String
            }else{
                cell.titleLabel.text = shippingCompanyArray[5].value(forKey: "name") as! String
            }
        case 5://J
            cell.titleLabel.text = shippingCompanyArray[6].value(forKey: "name") as! String
        case 6://Q
            cell.titleLabel.text = shippingCompanyArray[7].value(forKey: "name") as! String
        case 7://S
            if indexPath.row == 0{
                cell.titleLabel.text = shippingCompanyArray[8].value(forKey: "name") as! String
            }else if indexPath.row == 1{
                cell.titleLabel.text = shippingCompanyArray[9].value(forKey: "name") as! String
            }else{
                cell.titleLabel.text = shippingCompanyArray[10].value(forKey: "name") as! String
            }
        case 8://U
            cell.titleLabel.text = shippingCompanyArray[11].value(forKey: "name") as! String
        case 9://Y
            if indexPath.row == 0{
                cell.titleLabel.text = shippingCompanyArray[12].value(forKey: "name") as! String
            }else if indexPath.row == 1{
                cell.titleLabel.text = shippingCompanyArray[13].value(forKey: "name") as! String
            }else{
                cell.titleLabel.text = shippingCompanyArray[14].value(forKey: "name") as! String
            }
        case 10://Z
            cell.titleLabel.text = shippingCompanyArray[15].value(forKey: "name") as! String
        case 11://#
            cell.titleLabel.text = "其他"
        default:
            print("nothing")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    //添加索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexSource
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        var tpIndex:Int = 0
        for charactor in indexSource{
            //判断索引值和组名相等，返回组坐标
            if charactor as! String == title{
                return tpIndex
            }
            tpIndex += 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[0].value(forKey: "name") as! String
        case [1,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[1].value(forKey: "name") as! String
        case [2,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[2].value(forKey: "name") as! String
        case [3,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[3].value(forKey: "name") as! String
        case [4,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[4].value(forKey: "name") as! String
        case [4,1]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[5].value(forKey: "name") as! String
        case [5,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[6].value(forKey: "name") as! String
        case [6,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[7].value(forKey: "name") as! String
        case [7,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[8].value(forKey: "name") as! String
        case [7,1]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[9].value(forKey: "name") as! String
        case [7,2]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[10].value(forKey: "name") as! String
        case [8,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[11].value(forKey: "name") as! String
        case [9,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[12].value(forKey: "name") as! String
        case [9,1]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[13].value(forKey: "name") as! String
        case [9,2]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[14].value(forKey: "name") as! String
        case [10,0]:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[15].value(forKey: "name") as! String
        case [11,0]:
            actionViewObject.shippingCompanyNameValue.text = "其他"
        default:
            actionViewObject.shippingCompanyNameValue.text = shippingCompanyArray[0].value(forKey: "name") as! String
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let tempView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 38))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        
        let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 25, y: 15, width: 20, height: 22))
        titleLabel.text = "#"
        tempView.addSubview(titleLabel)
        switch section {
        case 0: // D
            titleLabel.text = "D"
        case 1: //E
            titleLabel.text = "E"
        case 2: //F
            titleLabel.text = "F"
        case 3: //G
            titleLabel.text = "G"
        case 4://H
            titleLabel.text = "H"
        case 5://J
            titleLabel.text = "J"
        case 6://Q
            titleLabel.text = "Q"
        case 7://S
            titleLabel.text = "S"
        case 8://U
            titleLabel.text = "U"
        case 9://Y
            titleLabel.text = "Y"
        case 10://Z
            titleLabel.text = "Z"
        case 11://Z
            titleLabel.text = "#"
        default:
            titleLabel.text = "A"
        }
        return tempView
    }
    
    lazy var chooseCompanyTableView:UITableView = {
        //height -72 调好的 /// y = 117
        var heightOfTableView = UIScreen.main.bounds.height - 86
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 86, width: UIScreen.main.bounds.width, height: heightOfTableView), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.backgroundColor = UIColor.white
        tempTableView.separatorStyle = .none
        tempTableView.sectionIndexColor = UIColor.titleColors(color: .black)
        return tempTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:20 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        navBar.barTintColor = UIColor.backgroundColors(color: .lightestgray)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "选择快递"
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-white")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        //添加导航栏右侧的取消按钮
        let rightBarItem = UIBarButtonItem(title: "确定", style: .plain,
                                           target: self, action: #selector(confirmBtnClicked))
        rightBarItem.tintColor = UIColor.backgroundColors(color: .black)
        //        // 添加左侧、右侧按钮
        navItem.setLeftBarButton(leftBarItem, animated: false)
        navItem.setRightBarButton(rightBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        // 导航栏添加到view上
        self.view.addSubview(navBar)
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(chooseCompanyTableView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func cancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func confirmBtnClicked(){
        print("确定按钮点击了")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .backgroundColors(color: .lightestgray))
        
        //从plist获取快递公司列表
        let plistFile = Bundle.main.path(forResource: "shippingCompanyNameList", ofType: "plist")
        let tempContacts = NSArray.init(contentsOfFile: plistFile!)
        shippingCompanyArray.removeAll()
        if tempContacts?.count == 0{
            isEmptyCompanyBook = true
            print("empty contacts list")
            loadCompanyToPlist()
        }else{
            isEmptyCompanyBook = false
            print(tempContacts)
            companyCount = (tempContacts?.count)!
            for index in 0..<companyCount {
                shippingCompanyArray.append(tempContacts![index] as! NSDictionary)
            }
            //self.view.addSubview(chooseContactTableView)
        }
        self.view.backgroundColor = UIColor.white
        
    }
    
    func loadCompanyToPlist(){
        let plistFile = Bundle.main.path(forResource: "shippingCompanyNameList", ofType: "plist")
        //临时存储联系人列表
        var tempContactArray:[NSDictionary] = []
        let emptyArray:NSArray = []
        emptyArray.write(toFile: plistFile!, atomically: true)
        shippingCompanyArray.removeAll()
        
        let shippingCompanyArrayBook:[NSDictionary] = [["name":"德邦","id":"DBL"],
                                                       ["name":"EMS","id":"EMS"],
                                                       ["name":"快捷快递","id":"FAST"],
                                                       ["name":"国通快递","id":"GTO"],
                                                       ["name":"天天快递","id":"HHTT"],
                                                       ["name":"百世快递","id":"HTKY"],
                                                       ["name":"京东物流","id":"JD"],
                                                       ["name":"全峰快递","id":"QFKD"],
                                                       ["name":"顺丰速运","id":"SF"],
                                                       ["name":"申通快递","id":"STO"],
                                                       ["name":"中通快递","id":"STO"],
                                                       ["name":"优速快递","id":"UC"],
                                                       ["name":"韵达速递","id":"YD"],
                                                       ["name":"圆通速递","id":"YTO"],
                                                       ["name":"邮政快递包裹","id":"YZPY"],
                                                       ["name":"宅急送","id":"ZJS"]]
        shippingCompanyArray = shippingCompanyArrayBook
//
        let array = NSArray(array: shippingCompanyArrayBook)
        //将数组写入联系人列表
        array.write(toFile: plistFile!, atomically: true)
        print("filePath:\(plistFile)")
//
        if self.isEmptyCompanyBook{
            self.companyCount = shippingCompanyArrayBook.count
            self.view.addSubview(self.chooseCompanyTableView)
            self.isEmptyCompanyBook = false
        }
//        self.chooseContactTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: .backgroundColors(color: .red))
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
