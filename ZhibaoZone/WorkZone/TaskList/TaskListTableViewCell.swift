//
//  TaskListCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 24/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    let taskCellView:UIView = UIView.init()
    let seperateLineView:UIView = UIView.init()
    
    var taskCreateTimeInList:UILabel = UILabel.init()
    
    let taskOrderIDLabel:UILabel = UILabel.init()
    
    let taskSenderUserNameLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 55, width: 100, height: 20))
    var taskSenderUserNameInList:UILabel = UILabel.init(frame: CGRect(x: 60, y: 55, width: 150, height: 20))
    
    let taskDeadlineLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 11, width: 200, height: 20))
    var taskDeadlineInList:UILabel = UILabel.init(frame: CGRect(x: 80, y: 11, width: 200, height: 20))
    
    let taskContentLabel:UILabel = UILabel.init(frame: CGRect(x: 10, y: 86, width: 150, height: 20))
    var taskContentInList:UILabel = UILabel.init(frame: CGRect(x: 50, y: 86, width: UIScreen.main.bounds.width - 35 - 75, height: 20))
    
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
        
        taskCellView.frame =  CGRect(x: 15, y: 5, width: kWidth - 30 , height: 117)
        taskCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        taskCellView.layer.cornerRadius = 6
        taskCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        taskCellView.layer.shadowOpacity = 1.0
        taskCellView.layer.shadowColor = UIColor.lineColors(color: .lightGray).cgColor//UIColor.black.cgColor
        
        taskDeadlineLabel.text = "标题:"
        taskDeadlineLabel.font = UIFont.systemFont(ofSize: 14)
        taskDeadlineLabel.textColor = UIColor.titleColors(color: .black)
        
        taskDeadlineInList.text = "标准消息"
        taskDeadlineInList.font = UIFont.systemFont(ofSize: 14)
        taskDeadlineInList.textColor = UIColor.titleColors(color: .black)
        
        taskOrderIDLabel.frame = CGRect(x: taskCellView.frame.maxX - 230, y: 55, width: 200, height: 20)
        taskOrderIDLabel.text = "订单号: 205176704145811"
        taskOrderIDLabel.textAlignment = .right
        taskOrderIDLabel.font = UIFont.systemFont(ofSize: 14)
        taskOrderIDLabel.textColor = UIColor.titleColors(color: .darkGray)
        
        
        
        seperateLineView.frame = CGRect(x: 10, y: 42, width: taskCellView.frame.width - 20 , height: 1)
        seperateLineView.backgroundColor = UIColor.lineColors(color: .lightGray)
        
        taskCreateTimeInList.frame = CGRect(x: taskCellView.frame.maxX - 230, y: 11, width: 200, height: 20)
        taskCreateTimeInList.font = UIFont.systemFont(ofSize: 14)
        taskCreateTimeInList.text = "2017-12-01 00:00:00"
        taskCreateTimeInList.textAlignment = .right
        taskCreateTimeInList.textColor = UIColor.titleColors(color: .black)
        
        taskContentLabel.text = "内容:"
        taskContentLabel.font = UIFont.systemFont(ofSize: 14)
        taskContentLabel.textColor = UIColor.titleColors(color: .gray)
        
        taskContentInList.text = "无内容"
        taskContentInList.font = UIFont.systemFont(ofSize: 14)
        taskContentInList.textColor = UIColor.titleColors(color: .gray)
        taskContentInList.lineBreakMode = .byCharWrapping
        taskContentInList.numberOfLines = 1
        taskContentInList.textAlignment = .left
        
        taskSenderUserNameLabel.text = "发起者:"
        taskSenderUserNameLabel.font = UIFont.systemFont(ofSize: 14)
        taskSenderUserNameLabel.textColor = UIColor.titleColors(color: .darkGray)
        
        taskSenderUserNameInList.text = "无名氏"
        taskSenderUserNameInList.font = UIFont.systemFont(ofSize: 14)
        taskSenderUserNameInList.textColor = UIColor.titleColors(color: .darkGray)
        
        contentView.backgroundColor = UIColor.backgroundColors(color: .lightestgray)
        
        taskDeadlineLabel.text = "处理期限:"
        taskDeadlineLabel.font = UIFont.systemFont(ofSize: 14)
        taskDeadlineLabel.textColor = UIColor.titleColors(color: .black)
        
        taskDeadlineInList.text = "30分钟"
        taskDeadlineInList.font = UIFont.systemFont(ofSize: 14)
        taskDeadlineInList.textColor = UIColor.titleColors(color: .black)
        
        contentView.addSubview(taskCellView)
        taskCellView.addSubview(seperateLineView)
        taskCellView.addSubview(taskDeadlineLabel)
        taskCellView.addSubview(taskContentLabel)
        taskCellView.addSubview(taskContentInList)
        taskCellView.addSubview(taskSenderUserNameLabel)
        taskCellView.addSubview(taskSenderUserNameInList)
        taskCellView.addSubview(taskOrderIDLabel)
        taskCellView.addSubview(taskDeadlineInList)
        taskCellView.addSubview(taskCreateTimeInList)
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> TaskListTableViewCell{
        let reuseIdentifier = "TaskListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = TaskListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! TaskListTableViewCell
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
