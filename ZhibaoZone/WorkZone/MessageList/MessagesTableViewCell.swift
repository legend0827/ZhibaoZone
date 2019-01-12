//
//  MessagesTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    let orderCellView:UIView = UIView.init()
    let seperateLineView:UIView = UIView.init()
    
    var msgCreateTimeInList:UILabel = UILabel.init()
    
    let msgOrderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 55, width: 100, height: 20))
    var msgOrderIDInList:UILabel = UILabel.init(frame: CGRect(x: 60, y: 55, width: 150, height: 20))

    let msgTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 11, width: 200, height: 20))
    var msgTitleInList:UILabel = UILabel.init(frame: CGRect(x: 50, y: 11, width: 200, height: 20))
    
    let msgContentLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 86, width: 150, height: 20))
    var msgContentInList:UILabel = UILabel.init(frame: CGRect(x: 50, y: 86, width: UIScreen.main.bounds.width - 35 - 75, height: 20))
    
   // let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 30, y:40, width: 30, height: 30))

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
        
        orderCellView.frame =  CGRect(x: 15, y: 5, width: kWidth - 30 , height: 117)
        orderCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        orderCellView.layer.cornerRadius = 6
        orderCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        orderCellView.layer.shadowOpacity = 1.0
        orderCellView.layer.shadowColor = UIColor.lineColors(color: .grayLevel3).cgColor//UIColor.black.cgColor
        
        msgTitleLabel.text = "标题:"
        msgTitleLabel.font = UIFont.systemFont(ofSize: 14)
        msgTitleLabel.textColor = UIColor.titleColors(color: .black)
        
        msgTitleInList.text = "标准消息"
        msgTitleInList.font = UIFont.systemFont(ofSize: 14)
        msgTitleInList.textColor = UIColor.titleColors(color: .black)
        
        msgOrderIDLabel.text = "订单号:"
        msgOrderIDLabel.font = UIFont.systemFont(ofSize: 14)
        msgOrderIDLabel.textColor = UIColor.titleColors(color: .darkGray)
        
        msgOrderIDInList.text = "10000000000"
        msgOrderIDInList.font = UIFont.systemFont(ofSize: 14)
        msgOrderIDInList.textColor = UIColor.titleColors(color: .darkGray)
        
        
        seperateLineView.frame = CGRect(x: 10, y: 42, width: orderCellView.frame.width - 20 , height: 1)
        seperateLineView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        
        msgCreateTimeInList.frame = CGRect(x: orderCellView.frame.maxX - 230, y: 11, width: 200, height: 20)
        msgCreateTimeInList.font = UIFont.systemFont(ofSize: 14)
        msgCreateTimeInList.text = "2017-12-01 00:00:00"
        msgCreateTimeInList.textAlignment = .right
        msgCreateTimeInList.textColor = UIColor.titleColors(color: .black)
        
        msgContentLabel.text = "内容:"
        msgContentLabel.font = UIFont.systemFont(ofSize: 14)
        msgContentLabel.textColor = UIColor.titleColors(color: .gray)
        
        msgContentInList.text = "无内容"
        msgContentInList.font = UIFont.systemFont(ofSize: 14)
        msgContentInList.textColor = UIColor.titleColors(color: .gray)
        msgContentInList.lineBreakMode = .byCharWrapping
        msgContentInList.numberOfLines = 2
        msgContentInList.textAlignment = .left
        
        contentView.backgroundColor = UIColor.backgroundColors(color: .lightestGray)
        
        contentView.addSubview(orderCellView)
        orderCellView.addSubview(seperateLineView)
        orderCellView.addSubview(msgTitleLabel)
        orderCellView.addSubview(msgContentLabel)
        orderCellView.addSubview(msgContentInList)
        orderCellView.addSubview(msgOrderIDLabel)
        orderCellView.addSubview(msgOrderIDInList)
        orderCellView.addSubview(msgTitleInList)
        orderCellView.addSubview(msgCreateTimeInList)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> MessagesTableViewCell{
        let reuseIdentifier = "messageListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = MessagesTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! MessagesTableViewCell
    }
    
    public func settingCellData(title : String) {
        titleLabel.text = title
    }
    
    // MARK:- private
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 20, y: 10, width: 160, height: 20)
        // actionBtn.frame = CGRect(x: 210, y: 5, width: 90, height: 30)
    }
    
    
    //MARKL - lazy
    lazy var titleLabel:UILabel = {
        let tempTitleLabel = UILabel()
        tempTitleLabel.textColor = UIColor.black
        return tempTitleLabel
    }()
}
