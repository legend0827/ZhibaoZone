//
//  FilterForHorizentalView.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/18.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class FilterForHorizentalView: UIView,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListItem.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FilterTableViewCell.customCell(tableView: filterTableView)
        
        cell.selectedCheckImg.isHidden = true
        cell.selectedView.isHidden = true
        if selectedItems[indexPath.row]{
            cell.selectedCheckImg.isHidden = false
            cell.selectedView.isHidden = false
        }
        
        switch _filterType {
        case .timeInterval:
            cell.selectItemLabel.text = (filterListItem[indexPath.row].value(forKey: "timeInterval") as! String)
        case .shop:
            cell.selectItemLabel.text = (filterListItem[indexPath.row].value(forKey: "shop") as! String)
        case .goodsClass:
            cell.selectItemLabel.text = (filterListItem[indexPath.row].value(forKey: "goodsClass") as! String)
        default:
            cell.selectItemLabel.text = (filterListItem[indexPath.row].value(forKey: "TimeInterval") as! String)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectionStyle == .single {
            for i in 0..<filterListItem.count{
                self.selectedItems[i] = false
            }
            self.selectedItems[indexPath.row] = true
        }else{
            if selectedItems[indexPath.row] {
                self.selectedItems[indexPath.row] = false
            }else{
                self.selectedItems[indexPath.row] = true
            }
            //self.selectedItems.append(indexPath.row)// = indexPath.row
        }
        
        restoreData(tableView: tableView)
        
    }
    func restoreData(tableView:UITableView){
        self.seletedIndexs = transferSelectedItemToIndexs(checkedItems: selectedItems, listItemDic: filterListItem)
        setupSelectAllTitle()
        tableView.reloadData()
    }
    
    lazy var filterTableView:UITableView = {
        var tempTableView = UITableView(frame: CGRect(x: 0, y: 50 , width: kHight, height:kWidth - 76), style: UITableViewStyle.grouped)
        tempTableView.backgroundColor = UIColor.backgroundColors(color: .white)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        //  tempTableView.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        tempTableView.isScrollEnabled = true
        tempTableView.rowHeight = UITableViewAutomaticDimension
        tempTableView.estimatedRowHeight = 100
        tempTableView.separatorStyle = .singleLine//.none
        tempTableView.showsVerticalScrollIndicator = false
        tempTableView.showsHorizontalScrollIndicator = false
        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        tempTableView.tableFooterView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
        tempTableView.contentInset = .zero
        tempTableView.separatorColor = UIColor.lineColors(color: .grayLevel3)
        return tempTableView
    }()
    
    lazy var selectAllBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 0 + heightChangeForiPhoneXFromTop, y: 50, width: kHight + heightChangeForiPhoneXFromBottom, height: 40)
        button.setTitle("全部品类", for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont(name: "DINPro-Medium", size: 12)
        button.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        button.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        button.addTarget(self, action: #selector(selectAllBtnClicked), for: .touchUpInside)
        return button
    }()
    
    //弹窗ViewVC
    lazy var popupVC = PopUpsPortialViewController()
    //统计对象VC
    var statisticVC:StatisticViewController?
    
    var _filterType:filterType = filterType.timeInterval
    //选择的项目
    var selectedItems:[Bool] = []
    var filterListItem:[NSDictionary] = []
    //选择的index列表（所选对象的code列表）
    var seletedIndexs:[Int] = []
    //选择类型
    var selectionStyle:selectionModelType = .single
    
    lazy var titleOfPageLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 0 + heightChangeForiPhoneXFromTop, y: 15, width: kHight + heightChangeForiPhoneXFromBottom, height: 21))
        tempLabel.text = "时间段"
        tempLabel.textAlignment = .center
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 15)
        return tempLabel
    }()
    
    lazy var closeBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame =  CGRect(x: 15, y: 16, width: 30, height: 18)
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(closeLayerBtnClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmBtn:UIButton = {
        let button = UIButton.init(type: .custom)
        button.frame =  CGRect(x: kHight - 45, y: 16, width: 30, height: 18)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .gray), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(confirmBtnCliced), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createFilterView(with titleOfPage:String, filterType:filterType, filterItemList:[NSDictionary]){
        self.titleOfPageLabel.text = titleOfPage
        self._filterType = filterType
        self.filterListItem = filterItemList
        
//        selectedItems.removeAll()
//        for _ in 0..<filterItemList.count{
//            selectedItems.append(false)
//        }
        
        self.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        self.addSubview(titleOfPageLabel)
        self.addSubview(closeBtn)
        self.addSubview(confirmBtn)
        self.addSubview(filterTableView)
        if selectionStyle == .multiple{
            self.addSubview(selectAllBtn)
        }
        //设置全选按钮的值
        setupSelectAllTitle()
    }
    
    func transferSelectedItemToIndexs(checkedItems:[Bool], listItemDic:[NSDictionary]) -> [Int]{
        var indexs:[Int] = []
        for i in 0..<checkedItems.count{
            if checkedItems[i]{
                indexs.append((listItemDic[i]).value(forKey: "id") as! Int)
            }
        }
        return indexs
    }
    
    @objc func closeLayerBtnClicked(){
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectAllBtnClicked(){
        //是指Filter的值
        if seletedIndexs.count == self.filterListItem.count{
            //全部
            selectedItems.removeAll()
            for _ in 0..<filterListItem.count{
                selectedItems.append(false)
            }
            seletedIndexs.removeAll()
        }else {
            //不止一个值的时候，但是又不是全部值的时候显示部分店铺
            selectedItems.removeAll()
            for i in 0..<filterListItem.count{
                selectedItems.append(true)
            }
            seletedIndexs.removeAll()
            for item in filterListItem{
                seletedIndexs.append(item.value(forKey: "id") as! Int)
            }
        }
        
        setupSelectAllTitle()
        self.filterTableView.reloadData()
    }
    
    
    @objc func confirmBtnCliced(){
        print("confirm Button CLicked")
        switch _filterType {
        case .timeInterval:
            statisticVC?.timeIntervalIndexs = seletedIndexs
            
            switch seletedIndexs[0]{
            case 1:
                statisticVC?.timeIntervalChoosenBtn.setTitle("今天", for: .normal)
            case 2:
                statisticVC?.timeIntervalChoosenBtn.setTitle("昨天", for: .normal)
            case 3:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本周", for: .normal)
            case 4:
                statisticVC?.timeIntervalChoosenBtn.setTitle("上周", for: .normal)
            case 5:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本月", for: .normal)
            case 6:
                statisticVC?.timeIntervalChoosenBtn.setTitle("上月", for: .normal)
            default:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本月", for: .normal)
            }
        case .shop:
            statisticVC?.shopIndexs = seletedIndexs
            //是指Filter的值
            if seletedIndexs.isEmpty{
                statisticVC?.shopChoosenBtn.setTitle("不限店铺", for: .normal)
            }else if seletedIndexs.count == 1{
                //只有一个值时显示选定的值
                for item in filterListItem{
                    if (item.value(forKey: "id") as! Int) == seletedIndexs[0]{
                        let buttonTitle = item.value(forKey: "shop") as! String
                        statisticVC?.shopChoosenBtn.setTitle(buttonTitle, for: .normal)
                    }
                }
                
            }else if seletedIndexs.count == self.filterListItem.count{
                //全部店铺
                statisticVC?.shopChoosenBtn.setTitle("全部店铺", for: .normal)
            }else {
                //不止一个值的时候，但是又不是全部值的时候显示部分店铺
                statisticVC?.shopChoosenBtn.setTitle("部分店铺", for: .normal)
            }
        case .goodsClass:
            statisticVC?.goodsClassIndexs = seletedIndexs
            if seletedIndexs.isEmpty{
                statisticVC?.goodsClassChoosenBtn.setTitle("不限品类", for: .normal)
            }else if seletedIndexs.count == 1{
                //只有一个值时显示选定的值
                for item in filterListItem{
                    if (item.value(forKey: "id") as! Int) == seletedIndexs[0]{
                        let buttonTitle = item.value(forKey: "goodsClass") as! String
                        statisticVC?.goodsClassChoosenBtn.setTitle(buttonTitle, for: .normal)
                    }
                }
            }else if seletedIndexs.count == self.filterListItem.count{
                //全部店铺
                statisticVC?.goodsClassChoosenBtn.setTitle("全部品类", for: .normal)
            }else {
                //不止一个值的时候，但是又不是全部值的时候显示部分店铺
                statisticVC?.goodsClassChoosenBtn.setTitle("部分品类", for: .normal)
            }
        default:
            statisticVC?.timeIntervalIndexs = seletedIndexs
            switch seletedIndexs[0]{
            case 1:
                statisticVC?.timeIntervalChoosenBtn.setTitle("今天", for: .normal)
            case 2:
                statisticVC?.timeIntervalChoosenBtn.setTitle("昨天", for: .normal)
            case 3:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本周", for: .normal)
            case 4:
                statisticVC?.timeIntervalChoosenBtn.setTitle("上周", for: .normal)
            case 5:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本月", for: .normal)
            case 6:
                statisticVC?.timeIntervalChoosenBtn.setTitle("上月", for: .normal)
            default:
                statisticVC?.timeIntervalChoosenBtn.setTitle("本月", for: .normal)
            }
        }
        statisticVC?.getStatisticDetails(for: (statisticVC?.statisticRoleType)!, rankingIndex: (statisticVC?.selectedRankingIndex)!)
        popupVC.dismiss(animated: true, completion: nil)
    }
    
    
    func setupSelectAllTitle(){
        if selectionStyle == .single{
            self.filterTableView.frame = CGRect(x: 0, y: 50 , width: kHight, height:kWidth - 76)
        }else{
            
            self.filterTableView.frame = CGRect(x: 0, y: 91 , width: kHight, height:kWidth - 117)
        }
        switch _filterType {
        case .timeInterval:
            print("TimeInterval is Single Chooice Option")
        case .shop:
            //是指Filter的值
            if seletedIndexs.count == self.filterListItem.count{
                //全部
                selectAllBtn.setTitle("不限店铺", for: .normal)
            }else {
                //不止一个值的时候，但是又不是全部值的时候显示部分店铺
                selectAllBtn.setTitle("全部店铺", for: .normal)
            }
        case .goodsClass:
            //是指Filter的值
            if seletedIndexs.count == self.filterListItem.count{
                //全部
                selectAllBtn.setTitle("不限品类", for: .normal)
            }else {
                //不止一个值的时候，但是又不是全部值的时候显示部分店铺
                selectAllBtn.setTitle("全部品类", for: .normal)
            }
        default:
            print("TimeInterval is Single Chooice Option")
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
