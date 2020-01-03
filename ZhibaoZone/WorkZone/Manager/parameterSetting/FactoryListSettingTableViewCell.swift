//
//  FactoryListSettingTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/9/5.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class FactoryListSettingTableViewCell: UITableViewCell {

   
    lazy var FactoryNameLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 22, width: kHight - 30, height: 22))
        tempLabel.textAlignment = .left
        tempLabel.text = "车间账号"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
    
    lazy var rightArrow:UIImageView = {
        let rightArrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 29, y: 29, width: 14, height: 14))
        rightArrow.image = UIImage(named:"right-arrow")
        //rightArrow.bounds = CGRect(x:kWidth - 30,y:21,width:5,height:9)
        return rightArrow
    }()
    
    lazy var HintImageLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 215, y: 24, width: 185, height: 19))
        tempLabel.textAlignment = .right
        tempLabel.text = "能力设置"
        tempLabel.textColor = UIColor.titleColors(color: .darkGray)
        tempLabel.font = UIFont.boldSystemFont(ofSize: 13)
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
        self.selectionStyle = .none
        
        self.contentView.addSubview(FactoryNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> FactoryListSettingTableViewCell{
        let reuseIdentifier = "FactoryListSettingTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = FactoryListSettingTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell as! FactoryListSettingTableViewCell
    }
    
    override func layoutSubviews() {
        self.contentView.addSubview(HintImageLabel)
        self.contentView.addSubview(rightArrow)
    }
}
