//
//  chooseContactTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 27/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class chooseContactTableViewCell: UITableViewCell {
    let avatars:NSDictionary = [
        "1":"default1",
        "2":"default2",
        "3":"default3",
        "4":"default4",
        "5":"default5",
        "6":"default6",
        "7":"default7",
        "8":"default8",
        "9":"default9",
        "10":"default10"
    ]

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
        titleLabel.text = "菠萝蜜丹"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)

        contactIDLabel.text = "(1000010)"
        contactIDLabel.font = UIFont.systemFont(ofSize: 13)
        contactIDLabel.frame = CGRect(x: calculateLengthOfWords(withLabel: titleLabel)+70, y: 17, width: 160, height: 20)
        createIcon()
        contentView.addSubview(contactIDLabel)
        contentView.addSubview(contactUserIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func calculateLengthOfWords(withLabel:UILabel) -> Int{
        let textLength = withLabel.intrinsicContentSize.width
        return Int(textLength)
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> chooseContactTableViewCell{
        let reuseIdentifier = "chooseContactTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = chooseContactTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! chooseContactTableViewCell
    }
    
    public func settingCellData(title : String, contactID:Int) {
        titleLabel.text = title
        contactIDLabel.text = "(\(contactID))"
        contactIDLabel.frame =  CGRect(x: calculateLengthOfWords(withLabel: titleLabel)+70, y: 17, width: 160, height: 20)
    }
    
    // MARK:- private
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 65, y: 17, width: 160, height: 20)
        //contactIDLabel.frame = CGRect(x: 100, y: 17, width: 160, height: 20)
        contactUserIcon.frame = CGRect(x: 15, y: 5, width: 40, height: 40)
    }
    
    
    //MARKL - lazy 联系人昵称
    lazy var titleLabel:UILabel = {
        let tempTitleLabel = UILabel()
        tempTitleLabel.textColor = UIColor.black
        
        return tempTitleLabel
    }()
    //MARKL - lazy 联系人ID号
    lazy var contactIDLabel:UILabel = {
        let tempContactIDLabel = UILabel()
        tempContactIDLabel.textColor = UIColor.gray
        
        return tempContactIDLabel
    }()
    
    //MARKL - lazy 联系人头像
    lazy var contactUserIcon:UIImageView = {
        let tempContactUserIcon = UIImageView()
        
        //tempTitleLabel.textColor = UIColor.black
        return tempContactUserIcon
    }()
    
    func createIcon() {
        //随机取头像
        let avatarIndex = Int(arc4random()%10+1)
        let image = UIImage(named:avatars.value(forKey: String(avatarIndex)) as! String)
        let imageSize:CGFloat = 40.0
        
        contactUserIcon.bounds = CGRect(x:15,y:10,width:imageSize,height:imageSize)
        contactUserIcon.frame = CGRect(x:15, y:10, width:imageSize, height:imageSize)
        
        // 用设置圆角的方法设置圆形
        contactUserIcon.layer.cornerRadius =  10 //photo.bounds.height/2
        
        // 设置图片的外围圆框*
        contactUserIcon.layer.masksToBounds = true
        contactUserIcon.layer.borderColor = UIColor.white.cgColor
        contactUserIcon.layer.borderWidth = 3
        
        contactUserIcon.image = image
        
    }
   
}
