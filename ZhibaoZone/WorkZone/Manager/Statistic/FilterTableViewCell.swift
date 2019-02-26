//
//  FilterTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/18.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    lazy var selectItemLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: kHight - 30, height: 21))
        tempLabel.textAlignment = .center
        tempLabel.text = "今天"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 12)
        return tempLabel
    }()

    lazy var selectedCheckImg:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: kHight - 96 , y: 14, width: 16, height: 13))
        tempImageView.image = UIImage(named: "selectedcheckiconimg")
        return tempImageView
    }()
    
    lazy var selectedView: UIView = {
        let tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: kHight, height: 40))
        tempView.backgroundColor = UIColor.colorWithRgba(255, g: 248, b: 246, a: 1.0)
        return tempView
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
        self.selectedCheckImg.isHidden = true
        self.selectedView.isHidden = true
        self.selectionStyle = .none
        self.contentView.addSubview(selectedView)
        self.contentView.addSubview(selectItemLabel)
        self.contentView.addSubview(selectedCheckImg)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> FilterTableViewCell{
        let reuseIdentifier = "FilterTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = FilterTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        
        return cell as! FilterTableViewCell
    }
}
