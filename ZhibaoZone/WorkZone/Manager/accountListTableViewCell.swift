//
//  accountListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/17.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class accountListTableViewCell: UITableViewCell {
 
    let checkBoxBtn:UIButton = UIButton.init(type: .custom)
    let seperatorLine:UIView = UIView.init(frame: CGRect(x: 15, y: 0, width: kWidth - 30, height: 0.3))
    
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
        checkBoxBtn.setImage(UIImage(named: "checkbox-unchecked-gray"), for: .normal)
        nikeNameLabel.text = "车间1（12001022)"
        checkListOrdersCount.text = "12222"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func calculateLengthOfWords(withLabel:UILabel) -> Int{
        let textLength = withLabel.intrinsicContentSize.width
        return Int(textLength)
    }
    
    public class func customCell(tableView: UITableView) -> accountListTableViewCell{
        let reuseIdentifier = "accountListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = accountListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! accountListTableViewCell
    }
    
    override func layoutSubviews() {
        checkBoxBtn.frame = CGRect(x: kWidth - 42, y: 15, width: 22, height: 22)
        
        seperatorLine.backgroundColor = UIColor.lineColors(color: .lightGray)
        
        self.contentView.addSubview(seperatorLine)
        self.contentView.addSubview(nikeNameLabel)
        self.contentView.addSubview(checkBoxBtn)
        self.contentView.addSubview(checkListOrdersCount)
    }
    lazy var nikeNameLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: kWidth - 40, height: 22))
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
    lazy var checkListOrdersCount:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: kWidth - 120, y: 15, width: 100, height: 22))
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont.systemFont(ofSize: 16)
        return tempLabel
    }()
    
}
