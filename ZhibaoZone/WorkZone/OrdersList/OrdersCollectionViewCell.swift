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
    let statusImageView:UIImageView = UIImageView.init()
    let orderIDValue:UILabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        orderCellView.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        orderCellImageView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.width - 10)
        priceLabelBackgroundView.frame = CGRect(x: 5, y: frame.width - 35, width: frame.width - 10, height: 30)
        priceLabel.frame = CGRect(x: 13, y: frame.width - 30, width: frame.width - 26, height: 20)
        productTypeAndMaterialInCell.frame = CGRect(x: 5, y: frame.width - 5, width: 300, height: 20)
        productSize.frame =  CGRect(x: 35, y: frame.width + 15, width: (kWidth - 60)/2, height: 17)
        productQuantityInCell.frame = CGRect(x: 35, y: frame.width + 30, width: 100, height: 17)
        productSizeLabel.frame =  CGRect(x: 5, y: frame.width + 15, width: 80, height: 17)
        productQuantityInCellLabel.frame = CGRect(x: 5, y: frame.width + 30, width: 80, height: 17)
        
        quotePriceBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        dealBargainBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        acceptProduceBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        biddingBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        acceptDesignBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        takePhotoForProductBtnInCell.frame = CGRect(x: 5, y: frame.width + 15, width: (kWidth - 60)/2, height: 30)
        shippingBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        designRequiresBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        modifyRequiresBtnInCell.frame = CGRect(x: 5 , y: frame.width + 50, width: frame.width - 10, height: 35)
        statusImageView.frame = CGRect(x: frame.width - 55 , y: frame.width - 5, width: 50, height: 21)
        orderIDValue.frame = CGRect(x: 5, y: frame.width - 5, width: 200, height: 20)
        
        orderCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        orderCellView.layer.cornerRadius = 2
        orderCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        orderCellView.layer.shadowOpacity = 1.0
        
        orderCellView.layer.shadowColor = UIColor.lineColors(color: .lightGray).cgColor//UIColor.black.cgColor
        
        
        orderCellImageView.image = UIImage(named: "defualt-design-pic-loading")
        orderCellImageView.contentMode = .scaleAspectFit//.scaleAspectFill
        orderCellImageView.layer.cornerRadius = 2
        orderCellImageView.layer.masksToBounds = true
        orderCellImageView.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
        orderCellImageView.layer.borderWidth = 0.5
        
        priceLabelBackgroundView.image = UIImage(named: "maskonimage")
        priceLabelBackgroundView.layer.cornerRadius = 2
        priceLabelBackgroundView.layer.masksToBounds = true
        //priceLabelBackgroundView.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
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
        
        quotePriceBtnInCell.layer.cornerRadius = 2
        quotePriceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        quotePriceBtnInCell.setTitle("报价", for: UIControlState.normal)
        quotePriceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        quotePriceBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        quotePriceBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        quotePriceBtnInCell.layer.borderWidth = 1.0
        
        dealBargainBtnInCell.layer.cornerRadius = 2
        dealBargainBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        dealBargainBtnInCell.setTitle("处理议价", for: UIControlState.normal)
        dealBargainBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        dealBargainBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        dealBargainBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        dealBargainBtnInCell.layer.borderWidth = 1.0
        
        biddingBtnInCell.layer.cornerRadius = 2
        biddingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        biddingBtnInCell.setTitle("报价", for: UIControlState.normal)
        biddingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        biddingBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        biddingBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        biddingBtnInCell.layer.borderWidth = 1.0
        
        acceptProduceBtnInCell.layer.cornerRadius = 2
        acceptProduceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        acceptProduceBtnInCell.setTitle("接受生产", for: UIControlState.normal)
        acceptProduceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptProduceBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        acceptProduceBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        acceptProduceBtnInCell.layer.borderWidth = 1.0
        
        acceptDesignBtnInCell.layer.cornerRadius = 2
        acceptDesignBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        acceptDesignBtnInCell.setTitle("接受设计", for: UIControlState.normal)
        acceptDesignBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptDesignBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
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
        
        shippingBtnInCell.layer.cornerRadius = 2
        shippingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        shippingBtnInCell.setTitle("上传物流", for: UIControlState.normal)
        shippingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        shippingBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        shippingBtnInCell.layer.borderWidth = 1.0
        
        designRequiresBtnInCell.layer.cornerRadius = 2
        designRequiresBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        designRequiresBtnInCell.setTitle("设计要求", for: UIControlState.normal)
        designRequiresBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        designRequiresBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        designRequiresBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        designRequiresBtnInCell.layer.borderWidth = 1.0
        
        modifyRequiresBtnInCell.layer.cornerRadius = 2
        modifyRequiresBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        modifyRequiresBtnInCell.setTitle("设计要求", for: UIControlState.normal)
        modifyRequiresBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        modifyRequiresBtnInCell.setTitleColor(UIColor.titleColors(color: .lightOrange), for: UIControlState.normal)
        modifyRequiresBtnInCell.layer.borderColor = UIColor.lineColors(color: .lightOrange).cgColor
        modifyRequiresBtnInCell.layer.borderWidth = 1.0
        
        statusImageView.isHidden = true
        statusImageView.image = UIImage(named: "overperoidicon")

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
        orderCellView.addSubview(statusImageView)
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
