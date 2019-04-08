//
//  statisticTableViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/1/17.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class statisticTableViewCell: UITableViewCell {
    lazy var numberSequence:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 5, y: 5, width: 20, height: 34))
        tempLabel.numberOfLines = 2
        tempLabel.contentMode = .center
        tempLabel.text = "1"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 12)
        return tempLabel
    }()
    
    lazy var userNickName:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 25, y: 5, width: 80, height: 34))
        tempLabel.numberOfLines = 2
        tempLabel.contentMode = .center
        tempLabel.text = "S01-多贝特多贝特"
        tempLabel.textColor = UIColor.titleColors(color: .gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 12)
        return tempLabel
    }()
    
    //综合指数
    lazy var compositeIndexLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 113, y: 15, width: 54, height: 18))
        tempLabel.text = "综合指数"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //接单单数
    lazy var acceptOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 113, y: 15, width: 135, height: 18))
        tempLabel.text = "接单单数"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //成交单数
    lazy var dealOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 195, y: 15, width: 135, height: 18))
        tempLabel.text = "成交单数"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //接单金额
    lazy var acceptOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 300, y: 15, width: 135, height: 18))
        tempLabel.text = "接单金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //成交金额
    lazy var dealOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 400, y: 15, width: 135, height: 18))
        tempLabel.text = "成交金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //转化率
    lazy var transferRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 560, y: 15, width: 54, height: 18))
        tempLabel.text = "转化率"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //客单价
    lazy var singleOrderPriceLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 575, y: 15, width: 120, height: 18))
        tempLabel.text = "客单价"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //成交时间(平均)
    lazy var AverageDealTimeLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 685, y: 15, width: 120, height: 18))
        tempLabel.text = "成交时间(平均)"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //询价率
    lazy var quoteRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 810, y: 15, width: 65, height: 18))
        tempLabel.text = "询价率"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //设计费(平均)
    lazy var AverageDesignPriceLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 900, y: 15, width: 65, height: 18))
        tempLabel.text = "设计费(平均)"
        tempLabel.textAlignment = .right
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        
        return tempLabel
    }()
    //// ------ 设计
    //派单数量
    lazy var designDistributeOrderCountLabel:UILabel = {
        let tempLabel = UILabel.init(frame:CGRect(x: 33, y: 15, width: 135, height: 18))
        tempLabel.text = "派单数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //接单数量
    lazy var designAcceptOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 118, y: 15, width: 135, height: 18))
        tempLabel.text = "接单数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //定稿数量
    lazy var designDealOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 197, y: 15, width: 135, height: 18))
        tempLabel.text = "定稿数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //接单金额
    lazy var designAcceptOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 280, y: 15, width: 135, height: 18))
        tempLabel.text = "接单金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //定稿金额
    lazy var designDealOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 380, y: 15, width: 135, height: 18))
        tempLabel.text = "定稿金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //定稿率
    lazy var designTransferRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 453, y: 15, width: 135, height: 18))
        tempLabel.text = "定稿率"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //拒单率
    lazy var designRefuseRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 527, y: 15, width: 135, height: 18))
        tempLabel.text = "拒单率"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //成交出图(平均)
    lazy var designAverageDesignTimeLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 647, y: 15, width: 120, height: 18))
        tempLabel.text = "出图时间(平均)"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //成交出图(平均)
    lazy var designAverageDesignPriceLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 738, y: 15, width: 120, height: 18))
        tempLabel.text = "设计费(平均)"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //// ------ 车间
    //询价数量
    lazy var facInquryOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 33, y: 15, width: 135, height: 18))
        tempLabel.text = "询价数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //报价数量
    lazy var facQuoteOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 118, y: 15, width: 135, height: 18))
        tempLabel.text = "报价数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //接单数量
    lazy var facAcceptOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 193, y: 15, width: 135, height: 18))
        tempLabel.text = "接单数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //发货单数
    lazy var facSendOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 280, y: 15, width: 135, height: 18))
        tempLabel.text = "发货数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //订单金额
    lazy var facOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 360, y: 15, width: 135, height: 18))
        tempLabel.text = "订单金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //接单金额
    lazy var facAcceptOrderAmountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 453, y: 15, width: 135, height: 18))
        tempLabel.text = "接单金额"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //报价时间
    lazy var facQuoteInTimeLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 527, y: 15, width: 135, height: 18))
        tempLabel.text = "实时报价"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //报价时间
    lazy var facAverageQuoteTimeLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 637, y: 15, width: 135, height: 18))
        tempLabel.text = "报价时间"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //发货时间
    lazy var facAverageSendTimeLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 757, y: 15, width: 120, height: 18))
        tempLabel.text = "发货时间(平均)"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    
    //// ------ 客服跟单
    //订单数量
    lazy var csStatusOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 33, y: 15, width: 135, height: 18))
        tempLabel.text = "订单数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //跟单数量
    lazy var csStatusFollowOrderCountLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 118, y: 15, width: 135, height: 18))
        tempLabel.text = "跟单数量"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //接单数量
    lazy var csStatusFollowOrderRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 193, y: 15, width: 135, height: 18))
        tempLabel.text = "跟单比例"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //正常占比
    lazy var csStatusNormalOrderRateLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 270, y: 15, width: 135, height: 18))
        tempLabel.text = "正常占比"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //嫌贵议价
    lazy var csStatusTooExpensiveLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 340, y: 15, width: 135, height: 18))
        tempLabel.text = "嫌贵议价"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //需求不能满足
    lazy var csStatusNeedsNotCaptiableLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 443, y: 15, width: 135, height: 18))
        tempLabel.text = "需求不能满足"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //别处购买
    lazy var csStatusBoughtSomeWhereElseLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 547, y: 15, width: 120, height: 18))
        tempLabel.text = "别处购买"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    //客户失联
    lazy var csStatusCSMissedLabel:UILabel = {
        
        let tempLabel = UILabel.init(frame:CGRect(x: 657, y: 15, width: 120, height: 18))
        tempLabel.text = "客户失联"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.titleColors(color: titleColorsType.gray)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 13)
        
        return tempLabel
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(userNickName)
        self.contentView.addSubview(numberSequence)
        
        self.contentView.addSubview(compositeIndexLabel)
        self.contentView.addSubview(acceptOrderCountLabel)
        self.contentView.addSubview(dealOrderCountLabel)
        self.contentView.addSubview(acceptOrderAmountLabel)
        self.contentView.addSubview(dealOrderAmountLabel)
        self.contentView.addSubview(transferRateLabel)
        self.contentView.addSubview(singleOrderPriceLabel)
        self.contentView.addSubview(AverageDealTimeLabel)
        self.contentView.addSubview(quoteRateLabel)
        self.contentView.addSubview(AverageDesignPriceLabel)
        
        self.contentView.addSubview(designDistributeOrderCountLabel)
        self.contentView.addSubview(designRefuseRateLabel)
        self.contentView.addSubview(designTransferRateLabel)
        self.contentView.addSubview(designDealOrderCountLabel)
        self.contentView.addSubview(designAcceptOrderCountLabel)
        self.contentView.addSubview(designAverageDesignTimeLabel)
        self.contentView.addSubview(designDealOrderAmountLabel)
        self.contentView.addSubview(designAcceptOrderAmountLabel)
        self.contentView.addSubview(designAverageDesignPriceLabel)
        
        self.contentView.addSubview(facSendOrderCountLabel)
        self.contentView.addSubview(facAverageSendTimeLabel)
        self.contentView.addSubview(facQuoteOrderCountLabel)
        self.contentView.addSubview(facAcceptOrderCountLabel)
        self.contentView.addSubview(facAverageQuoteTimeLabel)
        self.contentView.addSubview(facInquryOrderCountLabel)
        self.contentView.addSubview(facAcceptOrderAmountLabel)
        self.contentView.addSubview(facOrderAmountLabel)
        self.contentView.addSubview(facQuoteInTimeLabel)
        
        self.contentView.addSubview(csStatusCSMissedLabel)
        self.contentView.addSubview(csStatusOrderCountLabel)
        self.contentView.addSubview(csStatusTooExpensiveLabel)
        self.contentView.addSubview(csStatusFollowOrderRateLabel)
        self.contentView.addSubview(csStatusNormalOrderRateLabel)
        self.contentView.addSubview(csStatusFollowOrderCountLabel)
        self.contentView.addSubview(csStatusNeedsNotCaptiableLabel)
        self.contentView.addSubview(csStatusBoughtSomeWhereElseLabel)

        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - public
    public class func customCell(tableView: UITableView) -> statisticTableViewCell{
        let reuseIdentifier = "statisticTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if cell == nil {
            cell = statisticTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        }
        return cell as! statisticTableViewCell
    }

}
