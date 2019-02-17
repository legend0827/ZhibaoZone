//
//  statisticOrderListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/24.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class statisticOrderListTableViewCell: UITableViewCell {
    
    lazy var backGroundView:UIView = {
        let tempView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 200))
        tempView.backgroundColor = UIColor.backgroundColors(color: .white)
        return tempView
    }()
    
    lazy var seperatorLine1:UIView = {
        let tempView:UIView = UIView.init(frame: CGRect(x: 14, y: 41.5, width: kWidth - 28, height: 0.5))
        tempView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        return tempView
    }()
    
    lazy var orderIDLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 15, width: kHight - 30, height: 18))
        tempLabel.textAlignment = .left
        tempLabel.text = "订单号 10020020200102"
        tempLabel.textColor = UIColor.titleColors(color: .darkGray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    
    lazy var produceImage:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: 15, y: 50, width: 100, height: 100))
        tempImageView.image = UIImage(named: "defualt-design-pic")
        tempImageView.layer.masksToBounds = true
        tempImageView.layer.cornerRadius = 4
        tempImageView.contentMode = .scaleAspectFit//.scaleAspectFill
        tempImageView.layer.backgroundColor = UIColor.lineColors(color: .grayLevel5).cgColor
        return tempImageView
    }()
    
    lazy var productTypeAndMaterialLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 200, y: 49, width: 185, height: 19))
        tempLabel.textAlignment = .right
        tempLabel.text = "徽章 锌合金"
        tempLabel.textColor = UIColor.titleColors(color: .darkGray)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return tempLabel
    }()
    
    lazy var produceParasLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 200, y: 69, width: 185, height: 18))
        tempLabel.textAlignment = .right
        tempLabel.text = "2D压铸 电镀 金色"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var sizeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 200, y: 89, width: 185, height: 18))
        tempLabel.textAlignment = .right
        tempLabel.text = "300.3 x 200 x 300(mm)"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var amountLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 150, y: 109, width: 135, height: 18))
        tempLabel.textAlignment = .right
        tempLabel.text = "x200002"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()

    
    lazy var inquryStatusLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 130, y: 49, width: 66, height: 26)) // CGRect(x: kWidth - 81 - 71 * 2, y: 138, width: 66, height: 26))
        tempLabel.textAlignment = .center
        tempLabel.text = "未询价"
        tempLabel.contentMode = .center
        tempLabel.layer.backgroundColor = UIColor.lineColors(color: .grayLevel5).cgColor
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()

    lazy var designStatusLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 130, y: 75, width: 66, height: 26))//CGRect(x: kWidth - 81 - 71, y: 138, width: 66, height: 26))
        tempLabel.textAlignment = .center
        tempLabel.text = "未设计"
        tempLabel.contentMode = .center
        tempLabel.layer.backgroundColor = UIColor.lineColors(color: .grayLevel5).cgColor
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var produceStatusLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 130, y: 101, width: 66, height: 26))//CGRect(x: kWidth - 81 , y: 138, width: 66, height: 26))
        tempLabel.textAlignment = .center
        tempLabel.text = "未分配生产"
        tempLabel.contentMode = .center
        tempLabel.layer.backgroundColor = UIColor.lineColors(color: .grayLevel5).cgColor
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 12)
        return tempLabel
    }()
    
    lazy var seperatorLine2:UIView = {
        let tempView:UIView = UIView.init(frame: CGRect(x: 14, y: 158.5, width: kWidth - 28, height: 0.5))
        tempView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        return tempView
    }()
    
    lazy var managerAcountLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 130, y: 130, width: kWidth - 30, height: 21)) // CGRect(x: kWidth -  150, y: 212, width: 135, height: 21))
        tempLabel.textAlignment = .left
        tempLabel.text = "王经理"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var customerServiceLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 164, width: kWidth - 30, height: 21))
        tempLabel.textAlignment = .left
        tempLabel.text = "客服:S01-英菲尼迪"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var designerLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 164, width: kWidth - 30, height: 21)) // CGRect(x: kWidth -  150, y: 192, width: 135, height: 21))
        tempLabel.textAlignment = .center
        tempLabel.text = "设计:D11-欧阳倩倩"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var factoryLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 164, width: kWidth - 30, height: 21)) //CGRect(x: 15, y: 212, width: kWidth - 30, height: 21))
        tempLabel.textAlignment = .right
        tempLabel.text = "车间:3D打印车间账号"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var seperatorLine3:UIView = {
        let tempView:UIView = UIView.init(frame: CGRect(x: 14, y: 217.5, width: kWidth - 28, height: 0.5))
        tempView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        return tempView
    }()
    
    lazy var createTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 15, width: kWidth - 30, height: 18))
        tempLabel.textAlignment = .right
        tempLabel.text = "2019-01-01 00:00:00"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        return tempLabel
    }()
    
    lazy var priceLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 130, y: 130, width: kWidth - 145, height: 20)) //CGRect(x: kWidth - 150, y: 248, width: 135, height: 23))
        tempLabel.textAlignment = .right
        tempLabel.contentMode = .topRight
        tempLabel.text = "¥20,000.00"
        tempLabel.textColor = UIColor.titleColors(color: .red)
        tempLabel.font = UIFont.systemFont(ofSize: 15)
        return tempLabel
    }()
    
//    lazy var priceTagLabel:UILabel = {
//        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 150, y: 150, width: 135, height: 20)) //CGRect(x: kWidth - 150, y: 248, width: 135, height: 23))
//        tempLabel.textAlignment = .right
//        tempLabel.text = "订单金额"
//        tempLabel.textColor = UIColor.titleColors(color: .gray)
//        tempLabel.font = UIFont.systemFont(ofSize: 12)
//        return tempLabel
//    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        self.backGroundView.addSubview(orderIDLabel)
        self.backGroundView.addSubview(produceImage)
        self.backGroundView.addSubview(seperatorLine1)
        self.backGroundView.addSubview(seperatorLine2)
       // self.backGroundView.addSubview(seperatorLine3)
        self.backGroundView.addSubview(productTypeAndMaterialLabel)
        self.backGroundView.addSubview(sizeLabel)
        self.backGroundView.addSubview(amountLabel)
        self.backGroundView.addSubview(inquryStatusLabel)
        self.backGroundView.addSubview(designStatusLabel)
        self.backGroundView.addSubview(produceStatusLabel)
        self.backGroundView.addSubview(managerAcountLabel)
        self.backGroundView.addSubview(customerServiceLabel)
        self.backGroundView.addSubview(designerLabel)
        self.backGroundView.addSubview(factoryLabel)
        self.backGroundView.addSubview(createTimeLabel)
        self.backGroundView.addSubview(priceLabel)
        self.backGroundView.addSubview(produceParasLabel)
        //self.backGroundView.addSubview(priceTagLabel)
        
        self.contentView.addSubview(backGroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> statisticOrderListTableViewCell{
        let reuseIdentifier = "statisticOrderListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = statisticOrderListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell as! statisticOrderListTableViewCell
    }

}
