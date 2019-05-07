//
//  customerListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/5/6.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class customerListTableViewCell: UITableViewCell {
    //绑定店铺
    lazy var bindingShopTitleLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 8, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "绑定店铺"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //绑定店铺
    lazy var bindingShopValueLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 89, y: 8, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.text = "绑定店铺"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //管理员号
    lazy var adminTitleLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 26, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "管理员号"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //管理员号
    lazy var adminValueLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 89, y: 26, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.text = "管理员号"
        tempLabel.textAlignment = .left
        return tempLabel
    }()

    
    //手机号
    lazy var mobileTitleLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 44, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "手机号"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //手机号
    lazy var mobileValueLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 89, y: 44, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.text = "13900130999"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //微信昵称
    lazy var nikeNameTitleLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 62, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "微信昵称"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //微信昵称
    lazy var nikeNameValueLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 89, y: 62, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.text = "微信昵称"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //微信号
    lazy var wechatIDTitleLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 80, width: kWidth - 100, height: 22))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "微信号"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    //微信号
    lazy var wechatIDValueLabel:UITextField = {
        let tempTextField = UITextField.init(frame: CGRect(x: 89, y: 80, width: kWidth - 100, height: 22))
        tempTextField.placeholder = "请输入微信号"
        tempTextField.font = UIFont.systemFont(ofSize: 13)
        tempTextField.textAlignment = .left
        return tempTextField
    }()
    
    //时间
    lazy var updateTimeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 15, y: 115.5, width: 200, height: 18))
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.text = "2019-01-01 12:00:00"
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    lazy var bindingBtn:UIButton = {
        let button = UIButton.init(frame: CGRect(x: kWidth - 75, y: 110, width: 60, height: 28))
        button.setTitle("绑定", for: .normal)
        button.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 2
        button.layer.borderColor = UIColor.lineColors(color: .grayLevel1).cgColor
        button.layer.borderWidth = 0.5
        return button
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
        self.contentView.addSubview(bindingShopTitleLabel)
        self.contentView.addSubview(bindingShopValueLabel)
        self.contentView.addSubview(adminTitleLabel)
        self.contentView.addSubview(adminValueLabel)
        self.contentView.addSubview(mobileTitleLabel)
        self.contentView.addSubview(mobileValueLabel)
        self.contentView.addSubview(wechatIDTitleLabel)
        self.contentView.addSubview(wechatIDValueLabel)
        self.contentView.addSubview(nikeNameTitleLabel)
        self.contentView.addSubview(nikeNameValueLabel)
        self.contentView.addSubview(updateTimeLabel)
        self.contentView.addSubview(bindingBtn)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> customerListTableViewCell{
        let reuseIdentifier = "customerListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = customerListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! customerListTableViewCell
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
