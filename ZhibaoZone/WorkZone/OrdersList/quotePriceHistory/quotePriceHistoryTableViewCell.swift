//
//  quotePriceHistoryTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/2/28.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class quotePriceHistoryTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if quoteInfo.count == 0{
            //self.scrollBgView.contentSize = CGSize(width: (kWidth - 186), height: 135)
            return 1
        }else{
           // let width = Int(kWidth - 186) * Int(quoteInfo.count)
           // self.scrollBgView.contentSize = CGSize(width: width, height: 135)
            return quoteInfo.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! priceListCollectionViewCell
        if quoteInfo.count == 0{
            cell.priceTime.text = "-"
            cell.priceValue.text = "尚未报价"
            cell.priceCountSequenceValue.text = "1"
        }else{
            
            let quoteInfoDic = quoteInfo[indexPath.row]
            //次序
            let sequenceNumber = quoteInfoDic.value(forKey: "quoteNo") as! Int
            cell.priceCountSequenceValue.text = "\(sequenceNumber)"
            //报价
            let quotePeriod = quoteInfoDic.value(forKey: "quotePeriod") as! Int
            var quotePriceString = ""
            if quotePeriod == 0 {
               quotePriceString = "¥\(quoteInfoDic.value(forKey: "quotePrice") as! Double)/当天"
            }else{
                quotePriceString = "¥\(quoteInfoDic.value(forKey: "quotePrice") as! Double)/\(quotePeriod)天"
            }
            cell.priceValue.text = quotePriceString
            //时间
            var quoteTime = quoteInfoDic.value(forKey: "quoteTime") as! String
            quoteTime.removeFirst()
            quoteTime.removeFirst()
            cell.priceTime.text = quoteTime
            if (quoteInfoDic.value(forKey: "isNew") as! Int) == 1{
                cell.currentPriceIcon.isHidden = false
            }else{
                cell.currentPriceIcon.isHidden = true
            }
            
        }
        return cell
    }

//    lazy var scrollBgView:UIScrollView = {
//        let tempScrollView = UIScrollView.init(frame: CGRect(x: 186, y: 0, width: kWidth-186, height: 135))
//        tempScrollView.contentSize = CGSize(width: kWidth - 186, height: 135)
//        tempScrollView.backgroundColor = UIColor.backgroundColors(color: .white)
//        return tempScrollView
//    }()
    
    lazy var productInfoBGView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: 156, height: 144))
        
        //灰层
        let blurView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 156, height: 143))
        blurView.image = UIImage(named: "quotepricehistorybgimg1")
        tempView.addSubview(blurView)
        
        //面板
        let whiteBoard:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 150, height: 139))
        whiteBoard.backgroundColor = UIColor.backgroundColors(color: .white)
        
        tempView.addSubview(whiteBoard)
        
        return tempView
    }()
    
    lazy var priceInfoBGView:UIView = {
        let tempView = UIView.init(frame: CGRect(x: 156, y: 0, width: 35, height: 135))
        
        //灰层
        let blurView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 3, width: 35, height: 129))
        blurView.image = UIImage(named: "quotepricehistorybgimg2")
        tempView.addSubview(blurView)
        
        //面板
        let whiteBoard:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 135))
        whiteBoard.backgroundColor = UIColor.backgroundColors(color: .white)
        
        tempView.addSubview(whiteBoard)
        
        return tempView
    }()
    
    lazy var inqueryTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 6, width: 200, height: 14))
        tempLabel.text = "询价时间"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 10)
        return tempLabel
    }()
    
    lazy var inqueryTimeValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 18, width: 200, height: 14))
        tempLabel.text = "2018-12-12 11:00:00"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 10)
        return tempLabel
    }()
    
    lazy var productTypeValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 35, width: 200, height: 17))
        tempLabel.text = "徽章"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var materialAndAccessoryValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 49, width: 200, height: 17))
        tempLabel.text = "锌合金 别针"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var produceStyleValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 62, width: 131, height: 34))
        tempLabel.text = "双面开模"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        tempLabel.numberOfLines = 2
        return tempLabel
    }()
    
    lazy var producePeriodValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 90, width: 200, height: 17))
        tempLabel.text = "工期 99天"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var orderNumberValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 66, y: 90, width: 200, height: 17))
        tempLabel.text = "数量 300000"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var produceSizeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 104, width: 200, height: 17))
        tempLabel.text = "尺寸(mm）"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var produceSizeValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 10, y: 117, width: 200, height: 17))
        tempLabel.text = "300.5 x 300 x 300"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var priceCountLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 159, y: 20, width: 30, height: 17))
        tempLabel.text = "次序"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var priceValueLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 159, y: 60, width: 30, height: 17))
        tempLabel.text = "报价"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var priceTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 159, y: 101, width: 30, height: 17))
        tempLabel.text = "时间"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    let CELL_ID = "cell_id";
    //报价记录表格
    lazy var priceListTableView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:115,height: 144)  //设置item尺寸
        layout.minimumLineSpacing = 0  //上下间隔
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)            //section四周的缩进
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal  //滚动方向
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: 189, y: 0, width: kWidth - 192, height: 144 ),collectionViewLayout:layout) // -180
        tempCollectionView.backgroundColor =  UIColor.lineColors(color: .grayLevel5)// UIColor.backgroundColors(color: .white)
        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        tempCollectionView.isScrollEnabled = true
        
        //  tempCollectionView.isScrollEnabled = true // 允许拖动
        tempCollectionView.register(priceListCollectionViewCell.self, forCellWithReuseIdentifier: CELL_ID)
        // 注册一个headView
        tempCollectionView.register(CollectionReusableViewHeader.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        return tempCollectionView
    }()
    
    var quoteInfo:[NSDictionary] = []
    
    let seperatorLine:UIView = UIView.init()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> quotePriceHistoryTableViewCell{
        let reuseIdentifier = "quotePriceHistoryTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = quotePriceHistoryTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! quotePriceHistoryTableViewCell
    }
    
    public override func layoutSubviews() {
  
        self.backgroundColor = UIColor.backgroundColors(color: .white)
        seperatorLine.frame = CGRect(x: 0, y: 138, width: kWidth, height: 5)
        seperatorLine.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        productInfoBGView.addSubview(inqueryTimeLabel)
        productInfoBGView.addSubview(inqueryTimeValue)
        productInfoBGView.addSubview(productTypeValue)
        productInfoBGView.addSubview(materialAndAccessoryValue)
        productInfoBGView.addSubview(producePeriodValue)
        productInfoBGView.addSubview(produceStyleValue)
        productInfoBGView.addSubview(orderNumberValue)
        productInfoBGView.addSubview(produceSizeLabel)
        productInfoBGView.addSubview(produceSizeValue)
        
        self.contentView.addSubview(priceCountLabel)
        self.contentView.addSubview(priceTimeLabel)
        self.contentView.addSubview(priceValueLabel)
        
        //scrollBgView.addSubview(priceListTableView)
        self.contentView.addSubview(priceListTableView)
       // self.contentView.addSubview(scrollBgView)
       // self.contentView.addSubview(priceInfoBGView)
        self.contentView.addSubview(productInfoBGView)
        self.contentView.addSubview(seperatorLine)
        
    }
    
}
