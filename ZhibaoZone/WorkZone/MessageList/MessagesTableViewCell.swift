//
//  MessagesTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    var msgCreateTimeInList:UILabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
    
    let msgOrderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 175, y: 0, width: 100, height: 30))
    var msgOrderIDInList:UILabel = UILabel.init(frame: CGRect(x: 220, y: 0, width: 150, height: 30))
    
    let msgSenderUserNameLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 35, width: 60, height: 30))
    var msgSenderUserNameInList:UILabel = UILabel.init(frame: CGRect(x: 63, y: 35, width: 120, height: 30))
    
    let msgTitleLabel:UILabel = UILabel.init(frame: CGRect(x: 175, y: 35, width: 200, height: 30))
    var msgTitleInList:UILabel = UILabel.init(frame: CGRect(x: 235, y: 35, width: 200, height: 30))
    
    let msgContentLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 70, width: 150, height: 30))
    var msgContentInList:UILabel = UILabel.init(frame: CGRect(x: 75, y: 70, width: UIScreen.main.bounds.width - 35 - 75, height: 30))
    
    let imageViewOfArrow:UIImageView = UIImageView.init(frame: CGRect(x: UIScreen.main.bounds.width - 30, y:40, width: 30, height: 30))

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
        
        imageViewOfArrow.image = UIImage(named:"right-arrow")
        imageViewOfArrow.bounds = CGRect(x:UIScreen.main.bounds.width - 30,y:15,width:20,height:20)
        
        msgContentLabel.text = "消息内容:"
        msgContentLabel.font = UIFont.systemFont(ofSize: 13)
        msgContentLabel.textColor = UIColor.gray
        
        msgContentInList.text = "无内容"
        msgContentInList.font = UIFont.systemFont(ofSize: 13)
        msgContentInList.textColor = UIColor.black
        msgContentInList.lineBreakMode = .byCharWrapping
        msgContentInList.numberOfLines = 2
        msgContentInList.textAlignment = .left
        
        msgOrderIDLabel.text = "订单号:"
        msgOrderIDLabel.font = UIFont.systemFont(ofSize: 13)
        msgOrderIDLabel.textColor = UIColor.gray
        
        msgOrderIDInList.text = "10000000000"
        msgOrderIDInList.font = UIFont.systemFont(ofSize: 13)
        msgOrderIDInList.textColor = UIColor.black
        
        msgSenderUserNameLabel.text = "发送者:"
        msgSenderUserNameLabel.font = UIFont.systemFont(ofSize: 13)
        msgSenderUserNameLabel.textColor = UIColor.gray
        
        msgSenderUserNameInList.text = "无名氏"
        msgSenderUserNameInList.font = UIFont.systemFont(ofSize: 13)
        msgSenderUserNameInList.textColor = UIColor.black
        
        
        msgTitleLabel.text = "标题:"
        msgTitleLabel.font = UIFont.systemFont(ofSize: 13)
        msgTitleLabel.textColor = UIColor.gray
        
        msgTitleInList.text = "标准消息"
        msgTitleInList.font = UIFont.systemFont(ofSize: 13)
        msgTitleInList.textColor = UIColor.black
        
        msgCreateTimeInList.text = "2017-12-01 00:00:00"
        msgCreateTimeInList.font = UIFont.systemFont(ofSize: 13)
        msgCreateTimeInList.textColor = UIColor.black
        
        contentView.addSubview(msgTitleLabel)
        contentView.addSubview(msgSenderUserNameLabel)
        contentView.addSubview(msgContentLabel)
        //        contentView.addSubview(taskCrateTimeLabel)
        contentView.addSubview(msgContentInList)
        contentView.addSubview(msgOrderIDLabel)
        contentView.addSubview(msgOrderIDInList)
        contentView.addSubview(msgSenderUserNameInList)
        contentView.addSubview(msgTitleInList)
        contentView.addSubview(msgCreateTimeInList)
        contentView.addSubview(imageViewOfArrow)
        self.selectionStyle = .none
        
        let view = UIView.init(frame:CGRect(x: 0, y: 110, width: UIScreen.main.bounds.width, height: 20))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        contentView.addSubview(view)
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
