//
//  onLineListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/12/13.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class onLineListTableViewCell: UITableViewCell {
    
//    let seperatorLine
    
    //在线状态
    lazy var onlineStatusiCon:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: kWidth - 73 , y: 22, width: 58, height: 16))
        tempImageView.image = UIImage(named: "offlinestatusicon")
        return tempImageView
    }()
    
    //用户昵称
    lazy var userNikeName:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.text = "S01-用户昵称"
        return tempLabel
    }()
    
    let statusTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 37, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "离线时间: 0小时0分0分"
        return tempLabel
    }()
    
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
        self.contentView.addSubview(statusTimeLabel)
        self.contentView.addSubview(userNikeName)
        self.contentView.addSubview(onlineStatusiCon)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> onLineListTableViewCell{
        let reuseIdentifier = "onLineListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = onLineListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! onLineListTableViewCell
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
