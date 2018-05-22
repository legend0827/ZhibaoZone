//
//  TaskContentTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 20/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class TaskContentTableViewCell: UITableViewCell {
    
    let senderInContentNameLabel:UILabel = UILabel.init(frame: CGRect(x: 54, y: 11, width: 200, height: 20))
    let senderInCotentAvatarLocal = CGRect(x: 20, y: 10, width: 24, height: 24)
    let contentLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 43, width: kWidth - 40, height: 20))
    let sendTimeInCotentLabel:UILabel = UILabel.init(frame: CGRect(x: kWidth - 220 , y: 11, width: 200, height: 20))
    let replyBtn:UIButton = UIButton.init(frame: CGRect(x: kWidth - 44, y: 22, width: 24, height: 18))
    
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
        
        
        senderInContentNameLabel.text = "谁谁谁说:"
        senderInContentNameLabel.font = UIFont.systemFont(ofSize: 16)
        senderInContentNameLabel.textColor = UIColor.titleColors(color: .black)//UIColor.colorWithRgba(94, g: 170, b: 224, a: 1.0)//淡蓝色
        
       // senderInCotentAvatarLocal
        
        let avatar = createIcon(imageSize: 24, locale: senderInCotentAvatarLocal, iconShape: AvatarShape.AvatarShapeTypeSquareWithRadius)
        
        contentView.addSubview(avatar)
        
        sendTimeInCotentLabel.text = "2018-10-10 00:00:00"
        sendTimeInCotentLabel.textColor = UIColor.titleColors(color: .darkGray)
        sendTimeInCotentLabel.font = UIFont.systemFont(ofSize: 14)
        sendTimeInCotentLabel.textAlignment = .right
        
        contentLabel.text = "12"
        contentLabel.textColor = UIColor.titleColors(color: .black)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        let replyImg:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 24, height: 18))
        replyImg.image = UIImage(named: "replyicon")
        replyBtn.addSubview(replyImg)
       // replyBtn.setTitle("回复", for: .normal)
       // replyBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
      //  replyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        let heightForFooterItems = contentLabel.frame.height + 20
        
        //sendTimeInCotentLabel.frame = CGRect(x: 60, y: heightForFooterItems , width: 120, height: 40)
        replyBtn.frame = CGRect(x: kWidth - 44, y: heightForFooterItems, width: 24, height: 18)
        
        contentView.addSubview(sendTimeInCotentLabel)
        contentView.addSubview(senderInContentNameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(replyBtn)
        
        let view:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 15, height: 1))
        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        view.tag = 65 //65分割线
        contentView.addSubview(view)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> TaskContentTableViewCell{
        let reuseIdentifier = "TaskContentTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = TaskContentTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! TaskContentTableViewCell
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
