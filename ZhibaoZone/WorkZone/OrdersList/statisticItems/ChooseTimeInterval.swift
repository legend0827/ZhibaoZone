//
//  ChooseTimeInterval.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/9/25.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ChooseTimeInterval: UIView,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.isEqual(startTimePickerView){
            let yearNum = yearArray?.count
            let monthNum = monthArray?.count
            
            let selctYear = (yearArray![yearIndex!] as! NSString).intValue
            let selctMonth = (monthArray![monthIndex!] as! NSString).intValue
            
            let dayNum = self.daysCount(year: Int(selctYear) , month: Int(selctMonth),forStarts: true)
            let numberArr = [yearNum,monthNum,dayNum]
            return numberArr[component]!
        }else{
            let yearNum = endYearArray?.count
            let monthNum = endMonthArray?.count
            
            let selctYear = (endYearArray![endYearIndex!] as! NSString).intValue
            let selctMonth = (endMonthArray![endMonthIndex!] as! NSString).intValue
            
            let dayNum = self.daysCount(year: Int(selctYear) , month: Int(selctMonth),forStarts: false)
            let numberArr = [yearNum,monthNum,dayNum]
            return numberArr[component]!
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let headLabel = UILabel.init()
        headLabel.textColor  = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        headLabel.textAlignment = NSTextAlignment.center
        if component == 0 {
            headLabel.text = yearArray?[row] as? String
        }
        if component == 1 {
            headLabel.text = monthArray?[row] as? String
        }
        if component == 2 {
            headLabel.text = dayArray?[row] as? String
        }
        
        return headLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.isEqual(startTimePickerView){
            if component == 0 {
                yearIndex = row
            }
            if component == 1 {
                monthIndex = row
            }
            if component == 2 {
                dayIndex = row
            }
            if component == 0 || component == 1{
                let selctYear = (yearArray![yearIndex!] as! NSString).intValue
                let selctMonth = (monthArray![monthIndex!] as! NSString).intValue
                let _ = self.daysCount(year: Int(selctYear) , month: Int(selctMonth),forStarts: true)
                
                if (dayArray?.count)!-1 < dayIndex! {
                    dayIndex = (dayArray?.count)!-1
                }
            }
            getStartTimeStamp()
        }else{
            if component == 0 {
                endYearIndex = row
            }
            if component == 1 {
                endMonthIndex = row
            }
            if component == 2 {
                endDayIndex = row
            }
            if component == 0 || component == 1{
                let selctYear = (endYearArray![endYearIndex!] as! NSString).intValue
                let selctMonth = (endMonthArray![endMonthIndex!] as! NSString).intValue
                let _ = self.daysCount(year: Int(selctYear) , month: Int(selctMonth),forStarts: false)
                
                if (endDayArray?.count)!-1 < endDayIndex! {
                    endDayIndex = (endDayArray?.count)!-1
                }
            }
            getEndTimeStamp()
        }
        
        pickerView.reloadAllComponents()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 380
        }
        return 52.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChooseTimeIntervalCellTableViewCell.customCell(tableView: contentTableView)
        cell.selectionStyle = .none
        cell.checkBox.addTarget(self, action: #selector(checkedBoxChanged), for: .touchUpInside)
        cell.checkBox.tag = indexPath.row
        cell.line.isHidden = false
        if checkStatus[indexPath.row]{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-checked"), for: .normal)
            
        }else{
            cell.checkBox.setBackgroundImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "最近1天"
        case 1:
            cell.titleLabel.text = "最近3天"
        case 2:
            cell.titleLabel.text = "最近1周"
        case 3:
            cell.titleLabel.text = "本月"
            
        case 4:
            cell.titleLabel.text = "自定义日期"
            hint.text = "请选择开始至结束的日期"
            hint.textColor = UIColor.titleColors(color: .lightGray)
            hint.font = UIFont.systemFont(ofSize: 12)
            
            hintiCon.image = UIImage(named: "calendariconimg")
            cell.contentView.addSubview(hintiCon)
            cell.contentView.addSubview(hint)
            cell.line.isHidden = true
            //如果选中了自定义时间段，添加pickerview
            if checkStatus[4]{
                cell.addSubview(startTimePickerView)
                cell.addSubview(endTimePickerView)
                cell.addSubview(startTimeLabel)
                cell.addSubview(endTimeLabel)
                backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: 563)
                contentTableView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 561)
            }else{
                contentTableView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 268)
                backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: 268)
                startTimePickerView.removeFromSuperview()
                endTimeLabel.removeFromSuperview()
                startTimeLabel.removeFromSuperview()
                endTimePickerView.removeFromSuperview()
            }
        default:
            print(" not exists")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkStatus = [false,false,false,false,false]
        checkStatus[indexPath.row] = true
        contentTableView.reloadData()
        switch indexPath.row {
        case 0:
            //"最近1天"
            startTimeStamp = dateAheadNow(before: 1, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 1:
            //"最近3天"
            startTimeStamp = dateAheadNow(before: 3, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 2:
            //"最近1周"
            startTimeStamp = dateAheadNow(before: 7, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 3:
            // "本月"
            let now = Date()
            
            let dayFormatter = DateFormatter()
            let hourFormatter = DateFormatter()
            let minitesFormatter = DateFormatter()
            let secondFormatter = DateFormatter()
            
            dayFormatter.dateFormat = "dd"
            hourFormatter.dateFormat = "HH"
            minitesFormatter.dateFormat = "mm"
            secondFormatter.dateFormat = "ss"
            
            dayFormatter.locale = .current
            hourFormatter.locale = .current
            minitesFormatter.locale = .current
            secondFormatter.locale = .current
            
            let dayOfNow = dayFormatter.string(from: now) //date(from: now)
            let hourOfNow = hourFormatter.string(from: now) //date(from: now)
            let minitesOfNow = minitesFormatter.string(from: now) //date(from: now)
            let secondOfNow = secondFormatter.string(from: now) //date(from: now)
            
            let dayInterval = Int(dayOfNow)! * 24 * 60 * 60
            let hourInterval = Int(hourOfNow)! * 60 * 60
            let minitesInterval = Int(minitesOfNow)! * 60
            let secondInterval = Int(secondOfNow)!
            
            startTimeStamp = dateAheadNow(before: dayInterval + hourInterval + minitesInterval + secondInterval, countAs: .perSecond).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 4:
            //"自定义日期"
            print("nothing")
        default:
            print("not exists")
        }
    }
    

    //自定义选择时间 - 开始时间
    var yearIndex:NSInteger?
    var monthIndex:NSInteger?
    var dayIndex:NSInteger?
    
    var yearArray:NSMutableArray?
    var monthArray:NSMutableArray?
    var dayArray:NSMutableArray?
    
    //自定义时间 - 结束时间
    var endYearIndex:NSInteger?
    var endMonthIndex:NSInteger?
    var endDayIndex:NSInteger?
    
    var endYearArray:NSMutableArray?
    var endMonthArray:NSMutableArray?
    var endDayArray:NSMutableArray?
    
    public let MAXYEAR = 2019
    public let MINYEAR = 2017
    //弹窗ViewVC
    var popupVC = PopupViewController()
    //源VC
    var managerVC = OrdersViewController()
    //页面frame
    var _frame:CGRect = CGRect(x: 198, y: 50, width: 150, height: 30)
    
    var startTimeStamp:TimeInterval = 0.0
    var endTimeStamp:TimeInterval = 0.0
    var checkStatus:[Bool] = [false,false,true,false,false]
    let hint:UILabel = UILabel.init(frame: CGRect(x: 144, y: 18, width: 150, height: 17))
    let hintiCon:UIImageView = UIImageView.init(frame: CGRect(x: 125, y: 20, width: 13, height: 14))
    //选中表格
    lazy var contentTableView:UITableView = {
        let tempTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 268), style: .grouped)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        tempTableView.backgroundColor = UIColor.white
        tempTableView.estimatedRowHeight = 100
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.isScrollEnabled = true
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        
        return tempTableView
    }()

    lazy var startTimePickerView:UIPickerView = {
        let tempPicker:UIPickerView = UIPickerView.init(frame: CGRect(x: 0, y: 80 , width: kWidth, height: 120))
        tempPicker.backgroundColor = UIColor.backgroundColors(color: .white)
        tempPicker.showsSelectionIndicator = true
        tempPicker.delegate = self
        tempPicker.dataSource = self
       // tempPicker.setValue(UIFont.systemFont(ofSize: 16), forKey: "font")
        //tempPicker.minimumDate = Date.
     //   tempPicker.addTarget(self, action: #selector(startTimeValueChanged), for: .valueChanged)
        
        return tempPicker
    }()
    
    lazy var endTimePickerView:UIPickerView = {
        let tempPicker:UIPickerView = UIPickerView.init(frame: CGRect(x: 0, y: 223 , width: kWidth, height: 120))
        tempPicker.backgroundColor = UIColor.backgroundColors(color: .white)
        tempPicker.showsSelectionIndicator = true
        tempPicker.delegate = self
        tempPicker.dataSource = self
        // tempPicker.setValue(UIFont.systemFont(ofSize: 16), forKey: "font")
        //tempPicker.minimumDate = Date.
       //   tempPicker.addTarget(self, action: #selector(endTimeValueChanged), for: .valueChanged)
        return tempPicker
    }()
    
    
    lazy var startTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 15+52, width: 100, height: 20))
        tempLabel.text = "开始时间:"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        return tempLabel
    }()
    
    lazy var endTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 158+52, width: 100, height: 20))
        tempLabel.text = "截止时间:"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        return tempLabel
    }()
    
    /// 计算每个月的天数
    fileprivate func daysCount(year:Int,month:Int, forStarts:Bool) -> Int{
        let isrunNian = year%4 == 0 ? (year%100 == 0 ? (year%400 == 0 ? true:false):true):false
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12{
            self.setDayArr(num: 31,forStarts: forStarts)
            return 31
        }else if month == 4 || month == 6 || month == 9 || month == 11{
            self.setDayArr(num: 30,forStarts: forStarts)
            return 30
        }else if month == 2{
            if isrunNian{
                self.setDayArr(num: 29,forStarts: forStarts)
                return 29
            }else{
                self.setDayArr(num: 28,forStarts: forStarts)
                return 28
            }
        }
        return 0
    }
    
    fileprivate func setDayArr(num:NSInteger,forStarts:Bool){
        if forStarts{
            dayArray?.removeAllObjects()
            for i in 1...num {
                let dayStr = String(format:"%02d",i)
                dayArray?.add(dayStr)
            }
        }else{
            endDayArray?.removeAllObjects()
            for i in 1...num {
                let dayStr = String(format:"%02d",i)
                endDayArray?.add(dayStr)
            }
        }
    }
    
    
    
    fileprivate func scrollToDate (date:NSDate) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year,.hour], from: date as Date)
        let _ = self.daysCount(year: dateComponents.year!, month: dateComponents.month!,forStarts: true)
        
        yearIndex = dateComponents.year!-MINYEAR
        monthIndex = dateComponents.month!-1
        dayIndex = dateComponents.day!-1
        
        endYearIndex = dateComponents.year!-MINYEAR
        endMonthIndex = dateComponents.month!-1
        endDayIndex = dateComponents.day!-1
        
        self.startTimePickerView.reloadAllComponents()
        self.startTimePickerView.selectRow(yearIndex!, inComponent: 0, animated: true)
        self.startTimePickerView.selectRow(monthIndex!, inComponent: 1, animated: true)
        self.startTimePickerView.selectRow(dayIndex!, inComponent: 2, animated: true)
        
        self.endTimePickerView.reloadAllComponents()
        self.endTimePickerView.selectRow(endYearIndex!, inComponent: 0, animated: true)
        self.endTimePickerView.selectRow(endMonthIndex!, inComponent: 1, animated: true)
        self.endTimePickerView.selectRow(endDayIndex!, inComponent: 2, animated: true)
        getStartTimeStamp()
        getEndTimeStamp()
    }
    
    fileprivate func defaultConfig(){
        yearArray = NSMutableArray.init()
        monthArray = NSMutableArray.init()
        dayArray = NSMutableArray.init()
        
        endYearArray = NSMutableArray.init()
        endMonthArray = NSMutableArray.init()
        endDayArray = NSMutableArray.init()
        
        yearIndex = 0
        monthIndex = 0
        dayIndex = 0
        
        endYearIndex = 0
        endMonthIndex = 0
        endDayIndex = 0
        
        for i in 1...12 {
            let monthStr = String(format:"%02d",i)
            monthArray?.add(monthStr)
            endMonthArray?.add(monthStr)
        }
        for i in MINYEAR...MAXYEAR {
            let yearStr = String(format:"%d",i)
            yearArray?.add(yearStr)
            endYearArray?.add(yearStr)
        }
    }
    //页面元素
    let ActionTitle:UILabel = UILabel.init(frame: CGRect(x: kWidth/2 - 38, y: 20, width: 72, height: 25))
    let cancelBtn:UIButton = UIButton.init(type: .custom)
    let confirmBtn:UIButton = UIButton.init(type: .custom)
    let backgroundView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _frame = frame
        self.defaultConfig()
        self.scrollToDate(date: NSDate())
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        //初始化值
        ActionTitle.frame  = CGRect(x: 30, y: 20, width: kWidth - 60, height: 25)
        ActionTitle.font = UIFont.boldSystemFont(ofSize: 18)
        ActionTitle.textColor = UIColor.titleColors(color: .black)
        ActionTitle.textAlignment = .center
        ActionTitle.text = "选择时间段"
        self.addSubview(ActionTitle)
        
        //取消按钮
        cancelBtn.frame = CGRect(x: 20, y: 22, width: 60, height: 22)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.contentHorizontalAlignment = .left
        cancelBtn.addTarget(self, action: #selector(closeActionView), for: .touchUpInside)
        self.addSubview(cancelBtn)
        
        //确定按钮
        confirmBtn.frame = CGRect(x: kWidth - 80, y: 22, width: 60, height: 22)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.contentHorizontalAlignment = .right
        confirmBtn.addTarget(self, action: #selector(confirmActionView), for: .touchUpInside)
        self.addSubview(confirmBtn)
        //背景页面值
        
        backgroundView.frame = CGRect(x: 0, y: 65, width: kWidth, height: 268)
        backgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
        self.addSubview(backgroundView)
        
        startTimeStamp = dateAheadNow(before: 7, countAs: .PerDay).TimeInterval
        endTimeStamp = getEndDateTimeOfToday().TimeInterval
        
        backgroundView.addSubview(contentTableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeActionView(){
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmActionView(){

        print("startTimeStamp: \(startTimeStamp)")
        print("endTimeStamp: \(endTimeStamp)")
        managerVC.timeInterval_from = startTimeStamp
        managerVC.timeInterval_to = endTimeStamp
        for i in 0..<checkStatus.count{
            if checkStatus[i]{
                switch i{
                case 0: //近一日
                    
                    managerVC.recentOneDayBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
                    managerVC.recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
                    
                    managerVC.recentOneWeekBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                    
                    managerVC.recentOneMonthBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                    
                    managerVC.customDateBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.customDateBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                    
                case 1:
                   // managerVC.chooseTimeIntervalBtn.setTitle("最近三天", for: .normal)
                  //  managerVC.downArrowImg.frame = CGRect(x: 55, y: 9, width: 9, height: 5)
                    print("normal, 近3日")
                case 2://近7日
                    managerVC.recentOneDayBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.recentOneDayBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                    
                    managerVC.recentOneWeekBtn.layer.borderColor = UIColor.lineColors(color: .red).cgColor
                    managerVC.recentOneWeekBtn.setTitleColor(UIColor.lineColors(color: .red), for: .normal)
                    
                    managerVC.recentOneMonthBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.recentOneMonthBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                    
                    managerVC.customDateBtn.layer.borderColor = UIColor.clear.cgColor
                    managerVC.customDateBtn.setTitleColor(UIColor.lineColors(color: .grayLevel1), for: .normal)
                case 3:
                    print("normal, 本月")
//                    managerVC.chooseTimeIntervalBtn.setTitle("本月", for: .normal)
//                    managerVC.downArrowImg.frame = CGRect(x: 35, y: 9, width: 9, height: 5)
                case 4:
                   // managerVC.chooseTimeIntervalBtn.setTitle("自定义时间", for: .normal)
                   // managerVC.downArrowImg.frame = CGRect(x: 75, y: 9, width: 9, height: 5)
                    print("normal, 自定义时间")
                default:
                    print("error")
                }
            }
        }
        managerVC.pullStatistics()
        popupVC.dismiss(animated: true, completion: nil)
    }
    @objc func checkedBoxChanged(_ button:UIButton){
        let index = button.tag
        checkStatus = [false,false,false,false,false]
        checkStatus[index] = true
        contentTableView.reloadData()
        switch index {
        case 0:
            //"最近1天"
            startTimeStamp = dateAheadNow(before: 1, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 1:
            //"最近3天"
            startTimeStamp = dateAheadNow(before: 3, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 2:
            //"最近1周"
            startTimeStamp = dateAheadNow(before: 7, countAs: .PerDay).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 3:
            // "本月"
            let now = Date()
            
            let dayFormatter = DateFormatter()
            let hourFormatter = DateFormatter()
            let minitesFormatter = DateFormatter()
            let secondFormatter = DateFormatter()
            
            dayFormatter.dateFormat = "dd"
            hourFormatter.dateFormat = "HH"
            minitesFormatter.dateFormat = "mm"
            secondFormatter.dateFormat = "ss"
            
            dayFormatter.locale = .current
            hourFormatter.locale = .current
            minitesFormatter.locale = .current
            secondFormatter.locale = .current
            
            let dayOfNow = dayFormatter.string(from: now) //date(from: now)
            let hourOfNow = hourFormatter.string(from: now) //date(from: now)
            let minitesOfNow = minitesFormatter.string(from: now) //date(from: now)
            let secondOfNow = secondFormatter.string(from: now) //date(from: now)
            
            let dayInterval = Int(dayOfNow)! * 24 * 60 * 60
            let hourInterval = Int(hourOfNow)! * 60 * 60
            let minitesInterval = Int(minitesOfNow)! * 60
            let secondInterval = Int(secondOfNow)!
            
            startTimeStamp = dateAheadNow(before: dayInterval + hourInterval + minitesInterval + secondInterval, countAs: .perSecond).TimeInterval
            endTimeStamp = getEndDateTimeOfToday().TimeInterval
        case 4:
            //"自定义日期"
            print("nothing")
        default:
            print("not exists")
        }
    }
    
    @objc func getStartTimeStamp(){
        let startTimeString = "\(yearArray?[yearIndex!] as! String)-\(monthArray?[monthIndex!] as! String)-\(dayArray?[dayIndex!] as! String) 00:00:00"
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        let endDateTime = formatter.date(from: startTimeString)
        startTimeStamp = (endDateTime?.timeIntervalSince1970)!
        print("startTimeStamp: \(startTimeStamp)")
       // print("endTimeStamp: \(endTimeStamp)")
    }
    
    @objc func getEndTimeStamp(){
        let endTimeString = "\(endYearArray?[endYearIndex!] as! String)-\(endMonthArray?[endMonthIndex!] as! String)-\(endDayArray?[endDayIndex!] as! String) 23:59:59"
       // print("startTimeStamp: \(startTimeStamp)")
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        let endDateTime = formatter.date(from: endTimeString)
        endTimeStamp = (endDateTime?.timeIntervalSince1970)!
        print("endTimeStamp: \(endTimeStamp)")
    }
}
