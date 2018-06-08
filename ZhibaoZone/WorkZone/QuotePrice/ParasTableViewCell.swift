//
//  ParasTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/6/1.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ParasTableViewCell: UITableViewCell {
    
    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 200, height: 22))
    let checkBox:UIButton = UIButton.init(type: .custom)
    let line:UIView = UIView.init(frame: CGRect(x: 15, y: 51, width: kWidth - 30, height: 1))
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkBox.setBackgroundImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
        checkBox.adjustsImageWhenHighlighted = true
        checkBox.frame = CGRect(x: kWidth - 40, y: 16, width: 20, height: 20)
        self.contentView.addSubview(checkBox)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> ParasTableViewCell{
        let reuseIdentifier = "ParasTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = ParasTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! ParasTableViewCell
    }
    
    public override func layoutSubviews() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.titleColors(color: .black)
        
        line.backgroundColor = UIColor.colorWithRgba(221, g: 221, b: 221, a: 1.0)
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(titleLabel)
        
    }
    
}
