//
//  parameterSettingTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class parameterSettingTableViewCell: UITableViewCell {

    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 20, y: 15, width: 200, height: 22))
    let arrow:UIImageView = UIImageView.init(frame: CGRect(x: kWidth - 29, y: 21, width: 14, height: 14))
    
    let line:UIView = UIView.init(frame: CGRect(x: 15, y: 51, width: kWidth - 30, height: 0.5))
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    public class func customCell(tableView: UITableView) -> parameterSettingTableViewCell{
        let reuseIdentifier = "parameterSettingTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = parameterSettingTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! parameterSettingTableViewCell
    }
    
    public override func layoutSubviews() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.titleColors(color: .black)
        arrow.image = UIImage(named: "right-arrow")
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(arrow)
        self.contentView.addSubview(titleLabel)
    }


}
