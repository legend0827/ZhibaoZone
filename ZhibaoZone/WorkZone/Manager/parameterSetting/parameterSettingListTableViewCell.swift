//
//  parameterSettingListTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/3/12.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class parameterSettingListTableViewCell: UITableViewCell,UITextFieldDelegate {

    let titleLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 22))
    let line:UIView = UIView.init(frame: CGRect(x: 15, y: 60.5, width: kWidth - 30, height: 0.5))
    lazy var parameterValue:UITextField = {
        let tempValue = UITextField.init(frame: CGRect(x: kWidth - 156, y: 20, width: 100, height: 21))
        tempValue.delegate = self
        tempValue.font = UIFont.systemFont(ofSize: 15)
        tempValue.textAlignment = .right
        tempValue.keyboardType = .numberPad
        return tempValue
    }()
    let parameteUnit:UILabel = {
        let label = UILabel.init(frame: CGRect(x: kWidth - 35, y: 20, width: 20, height: 21))
        label.text = "-"
        label.textAlignment = .center
        label.textColor = UIColor.titleColors(color: .black)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var textFieldMaxValue:Int = 0
    var textFieldMinValue:Int = 999
    var textFieldDefaultValue:Int = 0
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
    public class func customCell(tableView: UITableView) -> parameterSettingListTableViewCell{
        let reuseIdentifier = "parameterSettingListTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = parameterSettingListTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! parameterSettingListTableViewCell
    }
    
    public override func layoutSubviews() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.titleColors(color: .black)
        line.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        self.contentView.addSubview(parameterValue)
        self.contentView.addSubview(parameteUnit)
        self.contentView.addSubview(line)
        self.contentView.addSubview(titleLabel)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0" || textField.text == "0.00"{
            textField.text = ""
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let currentValue = Int((textField.text as? String) ?? "-1")
        if currentValue! >= textFieldMinValue && currentValue! <= textFieldMaxValue{
            print("正确值")
        }else{
            textField.text = "\(textFieldDefaultValue)"
            greyLayerPrompt.show(text: "参数值超限")
        }
        
        return true
    }
}
