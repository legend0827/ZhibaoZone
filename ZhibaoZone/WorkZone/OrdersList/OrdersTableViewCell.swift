//
//  OrdersTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 19/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    var roleType = 0//1 客服 2设计师 3 工厂 0 普通用户
    //mark  3 字 y = 60, 4字 y = 75
    let orderTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 20, width: 200, height: 30))
    let orderIDLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 210, y: 20, width: 200, height: 30))
    let orderID:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 200+35, y: 20, width: 200, height: 30))
    //产品类型
    let productTypeNameLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 55, width: 100, height: 30))
    var productTypeNameValue:UILabel = UILabel.init(frame: CGRect(x: 195, y: 55, width: 100, height: 30))
    //工艺
    let makeStyleLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 90, width: 200, height: 30))
    var makeStyleValue:UILabel = UILabel.init(frame: CGRect(x: 165, y: 90, width: 200, height: 30))
    //附件
    let accessoriesLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))
    var accessoriesValue:UILabel = UILabel.init(frame: CGRect(x: 165, y: 125, width: 100, height: 30))
    //订单状态
    let orderStatusLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 165, width: 100, height: 30))
    var orderStatusValue:UILabel = UILabel.init(frame: CGRect(x: 15, y: 165, width: 100, height: 30))
    let designStatusLabel:UILabel = UILabel.init(frame: CGRect(x: 75, y: 165, width: 100, height: 30))
    var designStatusValue:UILabel = UILabel.init(frame: CGRect(x: 75, y: 165, width: 100, height: 30))
    let returnPriceStatusLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 200, width: 100, height: 30))
    var returnPriceStatusValue:UILabel = UILabel.init(frame: CGRect(x: 15, y: 200, width: 100, height: 30))
    let paymentStatusLabel:UILabel = UILabel.init(frame: CGRect(x: 75, y: 200, width: 100, height: 30))
    var paymentStatusValue:UILabel = UILabel.init(frame: CGRect(x: 75, y: 200, width: 100, height: 30))
    //订购数目
    let orderCountLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 160, width: 100, height: 30))
    var orderCountValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 180, width: 100, height: 30))
    //产品尺寸
    //长
    // x: 190
    let productSizeOfLengthLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: 160, width: 100, height: 30))
    var productSizeOfLengthValue:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: 180, width: 100, height: 30))
    //宽
    let productSizeOfWidthLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 140, y: 160, width: 100, height: 30))
    var productSizeOfWidthValue:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 140, y: 180, width: 100, height: 30))
    //高
    var productSizeOfHeightLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 160, width: 100, height: 30))
    var productSizeOfHeightValue:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 80, y: 180, width: 100, height: 30))
    //圆形产品尺寸提示
    let productSizeHintLabel:UILabel = UILabel.init(frame:CGRect(x: UIScreen.main.bounds.width - 200, y: 200, width: 200, height: 30))
    
    //产品总价
    var orderTotalPrice:UILabel = UILabel.init(frame: CGRect(x: 15, y: 232, width: 200, height: 30))

    //设计费
    let designPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 130, y: 220, width: 200, height: 30))
    var designPriceValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 240, width: 200, height: 30))
    
    //客户心理价
    let custoerPriceLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 180, y: 220, width: 200, height: 30))
    var custoerPriceValue:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 180, y: 240, width: 200, height: 30))
    
    //报价
    let returnPrinceLabel:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 220, width: 200, height: 30))
    var returnPrinceValue:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 240, width: 200, height: 30))

    //报价按钮
    let quotePriceBtn:UIButton = UIButton.init(type: .system)
    
    //接受设计
    let acceptDesignOrderBtn:UIButton = UIButton.init(type: .system)
    //接受生产
    let acceptProduceOrderBtn:UIButton = UIButton.init(type: .system)
    
    var orderDefaultPic: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 60, width: 100, height: 100))
    


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
        
        let layoutPricingGap = 20
        //重排设计费，客户心理价，报价位置
        //设计费
            designPriceLabel.frame = CGRect(x: 130, y: 220, width: 200, height: 30)
            designPriceValue.frame = CGRect(x: 130, y: 240, width: 200, height: 30)
        //客户心理价
        if UIScreen.main.bounds.width != 414{
            custoerPriceLabel.frame = CGRect(x: 190, y: 220, width: 200, height: 30)
            custoerPriceValue.frame = CGRect(x: 190, y: 240, width: 200, height: 30)
        }else{
            custoerPriceLabel.frame = CGRect(x: 190+layoutPricingGap, y: 220, width: 200, height: 30)
            custoerPriceValue.frame = CGRect(x: 190+layoutPricingGap, y: 240, width: 200, height: 30)
        }

        //报价
        if UIScreen.main.bounds.width != 414{
            returnPrinceLabel.frame = CGRect(x: 280, y: 220, width: 200, height: 30)
            returnPrinceValue.frame = CGRect(x: 280, y: 240, width: 200, height: 30)
        }else{
            returnPrinceLabel.frame = CGRect(x: 280+layoutPricingGap, y: 220, width: 200, height: 30)
            returnPrinceValue.frame = CGRect(x: 280+layoutPricingGap, y: 240, width: 200, height: 30)
        }
        
        
        //设置值
        orderDefaultPic.image = UIImage(named:"defualt-design-pic")
        orderDefaultPic.layer.borderColor = UIColor.gray.cgColor
        orderDefaultPic.layer.borderWidth = 1
        orderDefaultPic.layer.cornerRadius = 5
        
        orderTimeLabel.text = "2017-12-01 00:00:00"
        orderTimeLabel.font = UIFont.systemFont(ofSize: 13)
        orderTimeLabel.textColor = UIColor.gray
        
        orderIDLabel.text = "订单号:"
        orderIDLabel.font = UIFont.systemFont(ofSize: 13)
        orderIDLabel.textColor = UIColor.gray
        
        orderID.text = "100000000000000"
        orderID.font = UIFont.systemFont(ofSize: 13)
        orderID.textColor = UIColor.black
        
        productTypeNameLabel.text = "产品类型:"
        productTypeNameLabel.font = UIFont.systemFont(ofSize: 13)
        productTypeNameLabel.textColor = UIColor.gray
        productTypeNameValue.text = "加载中..."
        productTypeNameValue.font = UIFont.systemFont(ofSize: 14)
        productTypeNameValue.textColor = UIColor.black
        
        makeStyleLabel.text = "工艺:"
        makeStyleLabel.font = UIFont.systemFont(ofSize: 13)
        makeStyleLabel.textColor = UIColor.gray
        makeStyleValue.text = "加载中..."
        makeStyleValue.font = UIFont.systemFont(ofSize: 14)
        makeStyleValue.textColor = UIColor.black
        
        accessoriesLabel.text = "附件:"
        accessoriesLabel.font = UIFont.systemFont(ofSize: 13)
        accessoriesLabel.textColor = UIColor.gray
        accessoriesValue.text = "加载中..."
        accessoriesValue.font = UIFont.systemFont(ofSize: 14)
        accessoriesValue.textColor = UIColor.black
        
        orderCountLabel.text = "数量"
        orderCountLabel.font = UIFont.systemFont(ofSize: 13)
        orderCountLabel.textColor = UIColor.gray
        orderCountValue.text = ""
        orderCountValue.font = UIFont.systemFont(ofSize: 14)
        orderCountValue.textColor = UIColor.black
        
        
        orderStatusLabel.text = "Order Status"
        orderStatusLabel.font = UIFont.systemFont(ofSize: 13)
        orderStatusLabel.textColor = UIColor.gray
        orderStatusValue.text = "加载中..."
        orderStatusValue.font = UIFont.systemFont(ofSize: 14)
        orderStatusValue.textColor = UIColor.black
        
        designStatusLabel.text = "Design Status"
        designStatusLabel.font = UIFont.systemFont(ofSize: 13)
        designStatusLabel.textColor = UIColor.gray
        designStatusValue.text = "未设计"
        designStatusValue.font = UIFont.systemFont(ofSize: 14)
        designStatusValue.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        returnPriceStatusLabel.text = "Quote Status"
        returnPriceStatusLabel.font = UIFont.systemFont(ofSize: 13)
        returnPriceStatusLabel.textColor = UIColor.gray
        returnPriceStatusValue.text = "未报价"
        returnPriceStatusValue.font = UIFont.systemFont(ofSize: 14)
        returnPriceStatusValue.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        paymentStatusLabel.text = "Payment Status"
        paymentStatusLabel.font = UIFont.systemFont(ofSize: 13)
        paymentStatusLabel.textColor = UIColor.gray
        paymentStatusValue.text = "未付款"
        paymentStatusValue.font = UIFont.systemFont(ofSize: 14)
        paymentStatusValue.textColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)

        
        productSizeOfHeightLabel.text = "高(mm)"
        productSizeOfHeightLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfHeightLabel.textColor = UIColor.gray
        productSizeOfHeightValue.text = ""
        productSizeOfHeightValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfHeightValue.textColor = UIColor.black
        
        productSizeOfWidthLabel.text = "宽(mm) x"
        productSizeOfWidthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfWidthLabel.textColor = UIColor.gray
        productSizeOfWidthValue.text = ""
        productSizeOfWidthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfWidthValue.textColor = UIColor.black
        
        productSizeOfLengthLabel.text = "长(mm) x"
        productSizeOfLengthLabel.font = UIFont.systemFont(ofSize: 13)
        productSizeOfLengthLabel.textColor = UIColor.gray
        productSizeOfLengthValue.text = ""
        productSizeOfLengthValue.font = UIFont.systemFont(ofSize: 14)
        productSizeOfLengthValue.textColor = UIColor.black
        
        productSizeHintLabel.text = "圆形产品直径参考长度（或宽度）值"
        productSizeHintLabel.textColor = UIColor.gray
        productSizeHintLabel.font = UIFont.systemFont(ofSize: 10)
        
        orderTotalPrice.text = "¥0.00"
        orderTotalPrice.textAlignment = .natural
        orderTotalPrice.font = UIFont.systemFont(ofSize: 18)
        orderTotalPrice.textColor = UIColor.orange
        
        acceptDesignOrderBtn.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 270, width: 80, height: 36)
        acceptDesignOrderBtn.setTitle("接受设计", for: .normal)
        acceptDesignOrderBtn.backgroundColor = UIColor.white
        acceptDesignOrderBtn.layer.borderWidth = 1
        acceptDesignOrderBtn.layer.cornerRadius = 5
        acceptDesignOrderBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        acceptDesignOrderBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
        
        
        acceptProduceOrderBtn.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 270, width: 80, height: 36)
        acceptProduceOrderBtn.setTitle("开始生产", for: .normal)
        acceptProduceOrderBtn.backgroundColor = UIColor.white
        acceptProduceOrderBtn.layer.borderWidth = 1
        acceptProduceOrderBtn.layer.cornerRadius = 5
        acceptProduceOrderBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        acceptProduceOrderBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)

        quotePriceBtn.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 270, width: 80, height: 36)
        quotePriceBtn.setTitle("报价", for: .normal)
        quotePriceBtn.backgroundColor = UIColor.white
        quotePriceBtn.layer.borderWidth = 1
        quotePriceBtn.layer.cornerRadius = 5
        quotePriceBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        quotePriceBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)


        contentView.addSubview(orderDefaultPic)
        contentView.addSubview(orderTimeLabel)
        contentView.addSubview(orderIDLabel)
        contentView.addSubview(orderID)
        contentView.addSubview(productTypeNameLabel)
        contentView.addSubview(productTypeNameValue)
        contentView.addSubview(makeStyleLabel)
        contentView.addSubview(makeStyleValue)
        contentView.addSubview(accessoriesLabel)
        contentView.addSubview(accessoriesValue)
        contentView.addSubview(orderCountLabel)
        contentView.addSubview(orderCountValue)
        //contentView.addSubview(orderStatusLabel)
        contentView.addSubview(orderStatusValue)
        contentView.addSubview(designStatusValue)
        //contentView.addSubview(designStatusLabel)
        //contentView.addSubview(returnPriceStatusLabel)
        contentView.addSubview(returnPriceStatusValue)
        //contentView.addSubview(paymentStatusLabel)
        contentView.addSubview(paymentStatusValue)
        contentView.addSubview(productSizeOfWidthLabel)
        contentView.addSubview(productSizeOfWidthValue)
        contentView.addSubview(productSizeOfLengthLabel)
        contentView.addSubview(productSizeOfLengthValue)
        contentView.addSubview(productSizeOfHeightLabel)
        contentView.addSubview(productSizeOfHeightValue)
        contentView.addSubview(productSizeHintLabel)
        contentView.addSubview(orderTotalPrice)
        
        if roleType == 1{ //1 客服 2设计师 3 工厂 0 普通用户
            contentView.addSubview(designPriceLabel)
            contentView.addSubview(designPriceValue)
            contentView.addSubview(custoerPriceValue)
            contentView.addSubview(custoerPriceLabel)
            contentView.addSubview(returnPrinceValue)
            contentView.addSubview(returnPrinceLabel)
        }else if roleType == 2{
            contentView.addSubview(designPriceLabel)
            contentView.addSubview(designPriceValue)
            contentView.addSubview(acceptDesignOrderBtn)
        }else if roleType == 3{
            contentView.addSubview(custoerPriceValue)
            contentView.addSubview(custoerPriceLabel)
            contentView.addSubview(returnPrinceValue)
            contentView.addSubview(returnPrinceLabel)
            contentView.addSubview(acceptProduceOrderBtn)
            contentView.addSubview(quotePriceBtn)
        }else{
            print("there's no such role in system")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - public
    public class func customCell(tableView: UITableView) -> OrdersTableViewCell{
        let reuseIdentifier =  "OrdersTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = OrdersTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        cell?.selectionStyle = .none
        
            
        return cell as! OrdersTableViewCell
    }
    
    public func settingRoleTypeForCell(roleType : Int,rowLocate: Int) {
        self.roleType = roleType
        designPriceLabel.text = "设计费"
        designPriceLabel.font = UIFont.systemFont(ofSize: 13)
        designPriceLabel.textColor = UIColor.gray
        designPriceValue.text = "¥8.00"
        designPriceValue.font = UIFont.systemFont(ofSize: 14)
        designPriceValue.textColor = UIColor.orange
        
        custoerPriceLabel.text = "预算"
        custoerPriceLabel.font = UIFont.systemFont(ofSize: 13)
        custoerPriceLabel.textColor = UIColor.gray
        custoerPriceValue.text = "¥0.00"
        custoerPriceValue.font = UIFont.systemFont(ofSize: 14)
        custoerPriceValue.textColor = UIColor.orange
        
        returnPrinceLabel.text = "报价"
        returnPrinceLabel.font = UIFont.systemFont(ofSize: 13)
        returnPrinceLabel.textColor = UIColor.gray
        returnPrinceValue.text = "¥0.00"
        returnPrinceValue.font = UIFont.systemFont(ofSize: 14)
        returnPrinceValue.textColor = UIColor.orange
        
        if roleType == 1{ //1 客服 2设计师 3 工厂 0 普通用户
            contentView.addSubview(designPriceLabel)
            contentView.addSubview(designPriceValue)
            contentView.addSubview(custoerPriceValue)
            contentView.addSubview(custoerPriceLabel)
            contentView.addSubview(returnPrinceValue)
            contentView.addSubview(returnPrinceLabel)
        }else if roleType == 2{
            contentView.addSubview(designPriceLabel)
            contentView.addSubview(designPriceValue)
            contentView.addSubview(acceptDesignOrderBtn)
        }else if roleType == 3{
            contentView.addSubview(custoerPriceValue)
            contentView.addSubview(custoerPriceLabel)
            contentView.addSubview(returnPrinceValue)
            contentView.addSubview(returnPrinceLabel)
            contentView.addSubview(acceptProduceOrderBtn)
            contentView.addSubview(quotePriceBtn)
        }else{
            print("there's no such role in system")
        }

        if rowLocate != 0{
            let view:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
            view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
            view.tag = 65 //65分割线
            contentView.addSubview(view)
        }
    }
    
//    public func changeHeightForView(changeHeight:Int){
//        let view = UIView.inigt(frame:CGRect(x: 0, y: 260+changeHeight, width: Int(UIScreen.main.bounds.width), height: 20))
//        view.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
//        contentView.addSubview(view)
//    }
    
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
