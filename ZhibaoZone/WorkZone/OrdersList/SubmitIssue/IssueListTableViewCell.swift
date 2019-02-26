//
//  IssueListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/2/25.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class IssueListTableViewCell: UITableViewCell {

    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 9, y: 12, width: kWidth - 55*2, height: 22))
    let checkBox:UIButton = UIButton.init(type: .custom)
    let seperatorLine:UIView = UIView.init()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkBox.setBackgroundImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
        checkBox.adjustsImageWhenHighlighted = true
        checkBox.frame = CGRect(x: kWidth - 150, y: 14.5, width: 20, height: 20)
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
    public class func customCell(tableView: UITableView) -> IssueListTableViewCell{
        let reuseIdentifier = "IssueListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = IssueListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! IssueListTableViewCell
    }
    
    public override func layoutSubviews() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.titleColors(color: .black)
        seperatorLine.frame = CGRect(x: 0, y: 44, width: kWidth - 110, height: 0.5)
        seperatorLine.backgroundColor = UIColor.lineColors(color: .grayLevel2)
        self.contentView.addSubview(seperatorLine)
        self.contentView.addSubview(titleLabel)
        
    }
    
}
