//
//  switchOrderListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/17.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class switchOrderListTableViewCell: UITableViewCell {
    
    let switchBtn:UIButton = UIButton.init(type: .custom)

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
        self.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        let backgroundView:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kWidth , height: 200))
        backgroundView.image = UIImage(named: "orderlistbgimg")
        backgroundView.layer.masksToBounds = true
        backgroundView.isUserInteractionEnabled = true
        //backgroundView.layer.cornerRadius = 0
        
        orderImage.frame = CGRect(x: 30, y: 30, width: 80, height: 80)
        
        orderIDLabel.frame = CGRect(x: orderImage.frame.maxX + 20, y: orderImage.frame.minY, width: 200, height: 20)
        orderIDLabel.text = "订单号: --"
        orderIDLabel.font = UIFont.systemFont(ofSize: 14)
        orderIDLabel.textColor = UIColor.titleColors(color: .black)
        orderIDLabel.textAlignment = .left
        
        wangwangIDLabel.frame = CGRect(x: orderImage.frame.maxX + 20, y: orderIDLabel.frame.maxY + 7, width: 200, height: 20)
        wangwangIDLabel.text = "旺旺号: --"
        wangwangIDLabel.font = UIFont.systemFont(ofSize: 14)
        wangwangIDLabel.textColor = UIColor.titleColors(color: .black)
        wangwangIDLabel.textAlignment = .left
        
        producePriceLabel.frame = CGRect(x: orderImage.frame.maxX + 20, y: orderIDLabel.frame.maxY + 7, width: 200, height: 20)
        producePriceLabel.text = "产品费: --"
        producePriceLabel.font = UIFont.systemFont(ofSize: 14)
        producePriceLabel.textColor = UIColor.titleColors(color: .black)
        producePriceLabel.textAlignment = .left
        
        customernikeNameLabel.frame = CGRect(x: orderImage.frame.maxX + 20, y: wangwangIDLabel.frame.maxY + 7, width: 200, height: 20)
        customernikeNameLabel.text = "客服: --"
        customernikeNameLabel.textColor = UIColor.titleColors(color: .black)
        customernikeNameLabel.font = UIFont.systemFont(ofSize: 14)
        customernikeNameLabel.textAlignment = .left
        
        let dashLine:UIImageView = UIImageView.init(frame: CGRect(x: 20, y: orderImage.frame.maxY + 10, width: backgroundView.frame.width - 40, height: 1))
        dashLine.image = UIImage(named: "dashlineimg")
        
        dnikeNameLabel.frame = CGRect(x: 30, y: dashLine.frame.maxY + 10, width: 200, height: 20)
        dnikeNameLabel.text = "方案师: --"
        dnikeNameLabel.textColor = UIColor.titleColors(color: .black)
        dnikeNameLabel.font = UIFont.systemFont(ofSize: 14)
        dnikeNameLabel.textAlignment = .left
        
        fnikeNameLabel.frame = CGRect(x: 30 , y: dnikeNameLabel.frame.maxY + 7, width: 200, height: 20)
        fnikeNameLabel.text = "车间: --"
        fnikeNameLabel.textColor = UIColor.titleColors(color: .black)
        fnikeNameLabel.font = UIFont.systemFont(ofSize: 14)
        fnikeNameLabel.textAlignment = .left
        
        switchBtn.frame = CGRect(x: backgroundView.frame.width - 110, y: dashLine.frame.maxY + 23 , width: 85, height: 30)
        switchBtn.layer.backgroundColor = UIColor.backgroundColors(color: .red).cgColor
        switchBtn.layer.cornerRadius = 6
        switchBtn.setTitle("开始转接", for: .normal)
        switchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        switchBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        
        backgroundView.addSubview(switchBtn)
        backgroundView.addSubview(dashLine)
        backgroundView.addSubview(dnikeNameLabel)
        backgroundView.addSubview(fnikeNameLabel)
        backgroundView.addSubview(customernikeNameLabel)
        backgroundView.addSubview(wangwangIDLabel)
        backgroundView.addSubview(orderIDLabel)
        backgroundView.addSubview(orderImage)
        backgroundView.addSubview(producePriceLabel)
        
        contentView.addSubview(backgroundView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func calculateLengthOfWords(withLabel:UILabel) -> Int{
        let textLength = withLabel.intrinsicContentSize.width
        return Int(textLength)
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> switchOrderListTableViewCell{
        let reuseIdentifier = "switchOrderListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = switchOrderListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! switchOrderListTableViewCell
    }
    
    //MARKL - lazy 订单号
    lazy var orderIDLabel:UILabel = {
        let tempTitleLabel = UILabel()
        tempTitleLabel.textColor = UIColor.black
        
        return tempTitleLabel
    }()
  
    //MARKL - lazy 旺旺号
    lazy var wangwangIDLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()
    
    //MARKL - lazy 客服
    lazy var customernikeNameLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()
    
    lazy var producePriceLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()
    //MARKL - lazy 车间
    lazy var fnikeNameLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()

    //MARKL - lazy 方案师
    lazy var dnikeNameLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()
    //MARKL - lazy 图像
    lazy var orderImage:UIImageView = {
        let tempCompanyIDLabel = UIImageView()
        tempCompanyIDLabel.image = UIImage(named: "defualt-design-pic")
        tempCompanyIDLabel.layer.cornerRadius = 6
        tempCompanyIDLabel.layer.masksToBounds = true
        tempCompanyIDLabel.layer.borderColor = UIColor.lineColors(color: .gray).cgColor
        tempCompanyIDLabel.layer.borderWidth = 0.5
        
        return tempCompanyIDLabel
    }()
}
