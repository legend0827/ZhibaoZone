//
//  OrdersCollectionViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class OrdersCollectionViewCell: UICollectionViewCell {
    
    let orderCellView:UIView = UIView.init()
    let orderCellImageView:UIImageView = UIImageView.init()
    let productTypeAndMaterialInCell:UILabel = UILabel.init()
    let productSizeLabel:UILabel = UILabel.init()
    let productSize:UILabel = UILabel.init()
    let productQuantityInCell:UILabel = UILabel.init()
    let productQuantityInCellLabel:UILabel = UILabel.init()
    let quotePriceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptProduceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptDesignBtnInCell:UIButton = UIButton.init(type: .custom)
    let biddingBtnInCell:UIButton = UIButton.init(type: .custom)
    let shippingBtnInCell:UIButton = UIButton.init(type: .custom)
    let takePhotoForProductBtnInCell:UIButton = UIButton.init(type: .custom)
    let dealBargainBtnInCell:UIButton = UIButton.init(type: .custom)
    let designRequiresBtnInCell:UIButton = UIButton.init(type: .custom)
    let modifyRequiresBtnInCell:UIButton = UIButton.init(type: .custom)
    let priceLabelBackgroundView:UIImageView = UIImageView.init()
    let priceLabel:UILabel = UILabel.init()
    
    let orderIDValue:UILabel = UILabel.init()
    
//    //状态ImageView
//    let overPeriodStatusImageView:UIImageView = UIImageView.init()
//    //续订标志
//    lazy var renewOrderImageView:UIImageView = {
//        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
//        tempImageView.image = UIImage(named: "renewordericonimg")
//        return tempImageView
//    }()
//    //竞价标志
//    lazy var barginOrderImageView:UIImageView = {
//        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
//        tempImageView.image = UIImage(named: "barginordericonimg")
//        return tempImageView
//    }()
//    //问题已提交
//    lazy var issueSubmittedImageView:UIImageView = {
//        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
//        tempImageView.image = UIImage(named: "issuesubmittediconimg")
//        return tempImageView
//    }()
//    
//    //问题已提交
//    lazy var emptyImageView:UIImageView = {
//        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
//        tempImageView.image = UIImage.init()
//        return tempImageView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        orderCellView.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        orderCellImageView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.width - 10)
        priceLabelBackgroundView.frame = CGRect(x: 5, y: frame.width - 40, width: frame.width - 10, height: 35)
        priceLabel.frame = CGRect(x: 11, y: frame.width - 37, width: frame.width - 26, height: 20)
        productTypeAndMaterialInCell.frame = CGRect(x: 10, y: frame.width, width: 300, height: 20)
        productSize.frame =  CGRect(x: 40, y: frame.width + 18, width: (kWidth - 60)/2, height: 17)
        productQuantityInCell.frame = CGRect(x: 40, y: frame.width + 33, width: 100, height: 17)
        productSizeLabel.frame =  CGRect(x: 10, y: frame.width + 18, width: 80, height: 17)
        productQuantityInCellLabel.frame = CGRect(x: 10, y: frame.width + 33, width: 80, height: 17)
        
        quotePriceBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        dealBargainBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        acceptProduceBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        biddingBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        acceptDesignBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        takePhotoForProductBtnInCell.frame = CGRect(x: 5, y: frame.width + 15, width: (kWidth - 60)/2, height: 30)
        shippingBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        designRequiresBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        modifyRequiresBtnInCell.frame = CGRect(x: 33 , y: frame.width + 53, width: frame.width - 66, height: 32)
        orderIDValue.frame = CGRect(x: 10, y: frame.width - 5, width: 200, height: 20)
        
        orderCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        orderCellView.layer.cornerRadius = 2
        orderCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        orderCellView.layer.shadowOpacity = 1.0
        
        orderCellView.layer.shadowColor = UIColor.lineColors(color: .grayLevel3).cgColor//UIColor.black.cgColor
        
        
        orderCellImageView.image = UIImage(named: "defualt-design-pic-loading")
        orderCellImageView.contentMode = .scaleAspectFit//.scaleAspectFill
        orderCellImageView.layer.cornerRadius = 2
        orderCellImageView.layer.masksToBounds = true
        orderCellImageView.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
//        orderCellImageView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
//        orderCellImageView.layer.borderWidth = 0.5
        
        priceLabelBackgroundView.image = UIImage(named: "maskonimage")
        priceLabelBackgroundView.layer.cornerRadius = 2
        priceLabelBackgroundView.layer.masksToBounds = true
        //priceLabelBackgroundView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
       // priceLabelBackgroundView.layer.borderWidth = 0.5
        //priceLabelBackgroundView.alpha = 0.6
        
        priceLabel.text = "¥3000.00"
        priceLabel.textAlignment  = .left
        priceLabel.textColor = UIColor.titleColors(color: .white)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        
        productTypeAndMaterialInCell.text = "徽章 锌合金"
        productTypeAndMaterialInCell.textColor = UIColor.titleColors(color: .black)
        productTypeAndMaterialInCell.font = UIFont.systemFont(ofSize: 14)

        orderIDValue.text = "10000000"
        orderIDValue.textColor = UIColor.titleColors(color: .darkGray)
        orderIDValue.font = UIFont.systemFont(ofSize: 14)
        orderIDValue.isHidden = true
        
        productSize.text = "300x300x30(mm)"
        productSize.textColor = UIColor.titleColors(color: .gray)
        productSize.font = UIFont.systemFont(ofSize: 12)
        
        productSizeLabel.text = "尺寸"
        productSizeLabel.textColor = UIColor.titleColors(color: .darkGray)
        productSizeLabel.font = UIFont.systemFont(ofSize: 12)
        
        productQuantityInCell.text = "3000"
        productQuantityInCell.textColor = UIColor.titleColors(color: .gray)
        productQuantityInCell.font = UIFont.systemFont(ofSize: 12)
        
        productQuantityInCellLabel.text = "数量"
        productQuantityInCellLabel.textColor = UIColor.titleColors(color: .darkGray)
        productQuantityInCellLabel.font = UIFont.systemFont(ofSize: 12)
        
        quotePriceBtnInCell.layer.cornerRadius = 4
        quotePriceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        quotePriceBtnInCell.setTitle("报价", for: UIControlState.normal)
        quotePriceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        quotePriceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        quotePriceBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        quotePriceBtnInCell.layer.borderWidth = 1.0
        
        dealBargainBtnInCell.layer.cornerRadius = 4
        dealBargainBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        dealBargainBtnInCell.setTitle("处理议价", for: UIControlState.normal)
        dealBargainBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        dealBargainBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        dealBargainBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        dealBargainBtnInCell.layer.borderWidth = 1.0
        
        biddingBtnInCell.layer.cornerRadius = 4
        biddingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        biddingBtnInCell.setTitle("报价", for: UIControlState.normal)
        biddingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        biddingBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        biddingBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        biddingBtnInCell.layer.borderWidth = 1.0
        
        acceptProduceBtnInCell.layer.cornerRadius = 4
        acceptProduceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        acceptProduceBtnInCell.setTitle("接受生产", for: UIControlState.normal)
        acceptProduceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptProduceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        acceptProduceBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        acceptProduceBtnInCell.layer.borderWidth = 1.0
        
        acceptDesignBtnInCell.layer.cornerRadius = 4
        acceptDesignBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        acceptDesignBtnInCell.setTitle("接受设计", for: UIControlState.normal)
        acceptDesignBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptDesignBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        acceptDesignBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        acceptDesignBtnInCell.layer.borderWidth = 1.0
        
        let takePhotoiCon:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 22, height: 17))
        takePhotoiCon.image = UIImage(named: "takePhotoiconimg")
        takePhotoForProductBtnInCell.addSubview(takePhotoiCon)
        takePhotoForProductBtnInCell.layer.cornerRadius = 2
        takePhotoForProductBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        takePhotoForProductBtnInCell.setTitle("       拍摄成品", for: UIControlState.normal)
        takePhotoForProductBtnInCell.contentHorizontalAlignment = .left
        takePhotoForProductBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        takePhotoForProductBtnInCell.setTitleColor(UIColor.titleColors(color: .black), for: UIControlState.normal)
        
        shippingBtnInCell.layer.cornerRadius = 4
        shippingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        shippingBtnInCell.setTitle("上传物流", for: UIControlState.normal)
        shippingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        shippingBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        shippingBtnInCell.layer.borderWidth = 1.0
        
        designRequiresBtnInCell.layer.cornerRadius = 4
        designRequiresBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        designRequiresBtnInCell.setTitle("设计要求", for: UIControlState.normal)
        designRequiresBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        designRequiresBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        designRequiresBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        designRequiresBtnInCell.layer.borderWidth = 1.0
        
        modifyRequiresBtnInCell.layer.cornerRadius = 4
        modifyRequiresBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        modifyRequiresBtnInCell.setTitle("设计要求", for: UIControlState.normal)
        modifyRequiresBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        modifyRequiresBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        modifyRequiresBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        modifyRequiresBtnInCell.layer.borderWidth = 1.0
        

        //self.backgroundColor = UIColor.orange
        self.addSubview(orderCellView)
        orderCellView.addSubview(orderCellImageView)
        orderCellView.addSubview(priceLabelBackgroundView)
        orderCellView.addSubview(priceLabel)
        orderCellView.addSubview(productSizeLabel)
        orderCellView.addSubview(productQuantityInCellLabel)
        orderCellView.addSubview(productTypeAndMaterialInCell)
        orderCellView.addSubview(productSize)
        orderCellView.addSubview(productQuantityInCell)
        orderCellView.addSubview(quotePriceBtnInCell)
        orderCellView.addSubview(acceptProduceBtnInCell)
        orderCellView.addSubview(acceptDesignBtnInCell)
        orderCellView.addSubview(shippingBtnInCell)
        orderCellView.addSubview(orderIDValue)
        orderCellView.addSubview(designRequiresBtnInCell)
        orderCellView.addSubview(modifyRequiresBtnInCell)
        orderCellView.addSubview(takePhotoForProductBtnInCell)
        orderCellView.addSubview(dealBargainBtnInCell)
        orderCellView.addSubview(biddingBtnInCell)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
