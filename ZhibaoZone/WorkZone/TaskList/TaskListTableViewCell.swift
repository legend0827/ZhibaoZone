//
//  TaskListCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 24/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    //let taskCrateTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
    var taskCreateTimeInList:UILabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
    
    let taskOrderIDLabel:UILabel = UILabel.init(frame: CGRect(x: 175, y: 0, width: 100, height: 30))
    var taskOrderIDInList:UILabel = UILabel.init(frame: CGRect(x: 220, y: 0, width: 150, height: 30))
    
    let taskSenderUserNameLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 35, width: 60, height: 30))
    var taskSenderUserNameInList:UILabel = UILabel.init(frame: CGRect(x: 63, y: 35, width: 120, height: 30))
    
    let taskDeadLineLabel:UILabel = UILabel.init(frame: CGRect(x: 175, y: 35, width: 200, height: 30))
    var taskDeadLineInList:UILabel = UILabel.init(frame: CGRect(x: 235, y: 35, width: 200, height: 30))
    
    let taskContentLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 70, width: 150, height: 30))
    var taskContentInList:UILabel = UILabel.init(frame: CGRect(x: 75, y: 50, width: UIScreen.main.bounds.width - 35 - 75, height: 60))

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

        taskContentLabel.text = "任务内容:"
        taskContentLabel.font = UIFont.systemFont(ofSize: 13)
        taskContentLabel.textColor = UIColor.gray
        
        taskContentInList.text = "无内容"
        taskContentInList.font = UIFont.systemFont(ofSize: 13)
        taskContentInList.textColor = UIColor.black
        taskContentInList.lineBreakMode = .byCharWrapping
        taskContentInList.numberOfLines = 2
        taskContentInList.textAlignment = .natural
        
        taskOrderIDLabel.text = "订单号:"
        taskOrderIDLabel.font = UIFont.systemFont(ofSize: 13)
        taskOrderIDLabel.textColor = UIColor.gray
        
        taskOrderIDInList.text = "10000000000"
        taskOrderIDInList.font = UIFont.systemFont(ofSize: 13)
        taskOrderIDInList.textColor = UIColor.black
        
        taskSenderUserNameLabel.text = "发起者:"
        taskSenderUserNameLabel.font = UIFont.systemFont(ofSize: 13)
        taskSenderUserNameLabel.textColor = UIColor.gray
        
        taskSenderUserNameInList.text = "无名氏"
        taskSenderUserNameInList.font = UIFont.systemFont(ofSize: 13)
        taskSenderUserNameInList.textColor = UIColor.black
        
        
        taskDeadLineLabel.text = "处理期限:"
        taskDeadLineLabel.font = UIFont.systemFont(ofSize: 13)
        taskDeadLineLabel.textColor = UIColor.gray
        
        taskDeadLineInList.text = "30分钟"
        taskDeadLineInList.font = UIFont.systemFont(ofSize: 13)
        taskDeadLineInList.textColor = UIColor.black
        
        
//        taskCrateTimeLabel.text = "创建时间:"
//        taskCrateTimeLabel.font = UIFont.systemFont(ofSize: 13)
//        taskCrateTimeLabel.textColor = UIColor.gray
        
        taskCreateTimeInList.text = "2017-12-01 00:00:00"
        taskCreateTimeInList.font = UIFont.systemFont(ofSize: 13)
        taskCreateTimeInList.textColor = UIColor.black
        
        contentView.addSubview(taskDeadLineLabel)
        contentView.addSubview(taskSenderUserNameLabel)
        contentView.addSubview(taskContentLabel)
//        contentView.addSubview(taskCrateTimeLabel)
        contentView.addSubview(taskContentInList)
        contentView.addSubview(taskOrderIDLabel)
        contentView.addSubview(taskOrderIDInList)
        contentView.addSubview(taskSenderUserNameInList)
        contentView.addSubview(taskDeadLineInList)
        contentView.addSubview(taskCreateTimeInList)
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
