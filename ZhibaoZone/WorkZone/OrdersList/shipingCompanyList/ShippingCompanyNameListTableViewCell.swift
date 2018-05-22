//
//  ShippingCompanyNameListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/15.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ShippingCompanyNameListTableViewCell: UITableViewCell {

    
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
        titleLabel.text = "德邦物流"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func calculateLengthOfWords(withLabel:UILabel) -> Int{
        let textLength = withLabel.intrinsicContentSize.width
        return Int(textLength)
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> ShippingCompanyNameListTableViewCell{
        let reuseIdentifier = "chooseCompanyTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = ShippingCompanyNameListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! ShippingCompanyNameListTableViewCell
    }
    
    public func settingCellData(title : String, companyID:Int) {
        titleLabel.text = title
        companyIDLabel.text = "(\(companyID))"
    }
    
    // MARK:- private
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 25, y: 15, width: 160, height: 22)
    }
    
    
    //MARKL - lazy 快递公司名字
    lazy var titleLabel:UILabel = {
        let tempTitleLabel = UILabel()
        tempTitleLabel.textColor = UIColor.black
        
        return tempTitleLabel
    }()
    //MARKL - lazy 快递公司ID号
    lazy var companyIDLabel:UILabel = {
        let tempCompanyIDLabel = UILabel()
        tempCompanyIDLabel.textColor = UIColor.gray
        
        return tempCompanyIDLabel
    }()

}
