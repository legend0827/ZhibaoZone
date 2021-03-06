//
//  orderSearchCollectionViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/17.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class OrderSearchCollectionViewCell: UICollectionViewCell {
    
    
    let orderCellView:UIView = UIView.init()
    let orderCellImageView:UIImageView = UIImageView.init()
    let productTypeAndMaterialInCell:UILabel = UILabel.init()
    let productSize:UILabel = UILabel.init()
    let productQuantityInCell:UILabel = UILabel.init()
    let quotePriceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptProduceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptDesignBtnInCell:UIButton = UIButton.init(type: .custom)
    let shippingBtnInCell:UIButton = UIButton.init(type: .custom)
    let editOrderBtnInCell:UIButton = UIButton.init(type: .custom)
    let takePhotoForProductBtnInCell:UIButton = UIButton.init(type: .custom)
    //let priceLabelBackgroundView:UIImageView = UIImageView.init()
    let priceLabel:UILabel = UILabel.init()
    let statusImageView:UIImageView = UIImageView.init()
    let orderIDLabel:UILabel = UILabel.init()
    let orderIDValue:UILabel = UILabel.init()
    let orderTimeValue:UILabel = UILabel.init()
    let seperateLineView:UIView = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        orderCellView.frame =  CGRect(x: 15, y: 10, width: frame.width - 30 , height: frame.height - 20)
        orderIDLabel.frame = CGRect(x: 10, y: 11, width: 200, height: 20)
        orderIDValue.frame = CGRect(x: 60, y: 11, width: 200, height: 20)
        orderTimeValue.frame = CGRect(x: frame.width - 240 , y: 11, width: 200, height: 20)
        seperateLineView.frame = CGRect(x: 10, y: 42, width: orderCellView.frame.width - 20 , height: 1)
        orderCellImageView.frame = CGRect(x: 10, y: seperateLineView.frame.maxY + 11, width: 118, height: 118)
        priceLabel.frame = CGRect(x: 140, y: 151, width: frame.width - 10, height: 22)
        productTypeAndMaterialInCell.frame = CGRect(x: 140, y: 55, width: 300, height: 20)
        productSize.frame =  CGRect(x: 140, y: 79, width: (kWidth - 60)/2, height: 20)
        productQuantityInCell.frame = CGRect(x: 140, y: 101, width: 100, height: 20)
        
        quotePriceBtnInCell.frame = CGRect(x: orderCellView.frame.width - 95, y: 143, width: 85, height: 30)
        acceptProduceBtnInCell.frame = CGRect(x: orderCellView.frame.width - 95, y: 143, width: 85, height: 30)
        acceptDesignBtnInCell.frame = CGRect(x: orderCellView.frame.width - 95, y: 143, width: 85, height: 30)
        shippingBtnInCell.frame = CGRect(x: orderCellView.frame.width - 95, y: 143, width: 85, height: 30)
        editOrderBtnInCell.frame = CGRect(x: orderCellView.frame.width - 95, y: 143, width: 85, height: 30)
        takePhotoForProductBtnInCell.frame = CGRect(x: productQuantityInCell.frame.minX, y: productQuantityInCell.frame.maxY , width: 100, height: 30)
        statusImageView.frame = CGRect(x: 80 , y: seperateLineView.frame.maxY + 11, width: 48, height: 48)
        
        
        
        orderCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        orderCellView.layer.cornerRadius = 6
        orderCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        orderCellView.layer.shadowOpacity = 1.0
        
        orderCellView.layer.shadowColor = UIColor.lineColors(color: .grayLevel3).cgColor//UIColor.black.cgColor
        
        
        orderCellImageView.image = UIImage(named: "defualt-design-pic")
        orderCellImageView.contentMode = .scaleAspectFit
        orderCellImageView.layer.cornerRadius = 6
        orderCellImageView.layer.masksToBounds = true
        orderCellImageView.layer.backgroundColor = UIColor.backgroundColors(color: .lightestGray).cgColor
//        orderCellImageView.layer.borderColor = UIColor.lineColors(color: .grayLevel3).cgColor
//        orderCellImageView.layer.borderWidth = 0.5
        
        
        priceLabel.text = "¥3000.00"
        priceLabel.textAlignment  = .left
        priceLabel.textColor = UIColor.titleColors(color: .red)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        orderTimeValue.text = "2018-01-01 21:00:00"
        orderTimeValue.textColor = UIColor.titleColors(color: .black)
        orderTimeValue.font = UIFont.systemFont(ofSize: 14)
        orderTimeValue.textAlignment = .right
        
        
        orderIDLabel.text = "订单号:"
        orderIDLabel.textColor = UIColor.titleColors(color: .black)
        orderIDLabel.font = UIFont.systemFont(ofSize: 14)
        
        seperateLineView.backgroundColor = UIColor.lineColors(color: .grayLevel3)
        
        productTypeAndMaterialInCell.text = "徽章 锌合金"
        productTypeAndMaterialInCell.textColor = UIColor.titleColors(color: .black)
        productTypeAndMaterialInCell.font = UIFont.systemFont(ofSize: 14)
        
        orderIDValue.text = "10000000"
        orderIDValue.textColor = UIColor.titleColors(color: .black)
        orderIDValue.font = UIFont.systemFont(ofSize: 14)
        
        productSize.text = "300x300x30(mm)"
        productSize.textColor = UIColor.titleColors(color: .darkGray)
        productSize.font = UIFont.systemFont(ofSize: 14)
        
        productQuantityInCell.text = "x3000"
        productQuantityInCell.textColor = UIColor.titleColors(color: .darkGray)
        productQuantityInCell.font = UIFont.systemFont(ofSize: 14)
        
        
        quotePriceBtnInCell.layer.cornerRadius = 4
        quotePriceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        quotePriceBtnInCell.setTitle("报价", for: UIControlState.normal)
        quotePriceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        quotePriceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        
        acceptProduceBtnInCell.layer.cornerRadius = 4
        acceptProduceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        acceptProduceBtnInCell.setTitle("接受生产", for: UIControlState.normal)
        acceptProduceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptProduceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        acceptDesignBtnInCell.layer.cornerRadius = 4
        acceptDesignBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        acceptDesignBtnInCell.setTitle("接受设计", for: UIControlState.normal)
        acceptDesignBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptDesignBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        shippingBtnInCell.layer.cornerRadius = 4
        shippingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        shippingBtnInCell.setTitle("上传物流", for: UIControlState.normal)
        shippingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        editOrderBtnInCell.layer.cornerRadius = 4
        editOrderBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .lightOrange).cgColor
        editOrderBtnInCell.setTitle("编辑参数", for: UIControlState.normal)
        editOrderBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editOrderBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        let takePhotoiCon:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 5, width: 22, height: 17))
        takePhotoiCon.image = UIImage(named: "takePhotoiconimg")
        takePhotoForProductBtnInCell.addSubview(takePhotoiCon)
        takePhotoForProductBtnInCell.layer.cornerRadius = 4
        takePhotoForProductBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        takePhotoForProductBtnInCell.setTitle("       拍摄成品", for: UIControlState.normal)
        takePhotoForProductBtnInCell.contentHorizontalAlignment = .left
        takePhotoForProductBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        takePhotoForProductBtnInCell.setTitleColor(UIColor.titleColors(color: .black), for: UIControlState.normal)
        takePhotoForProductBtnInCell.isHidden = true
        
        statusImageView.isHidden = true
        statusImageView.image = UIImage(named: "overbudgeticon")
        statusImageView.layer.cornerRadius = 4 
        statusImageView.layer.borderColor = UIColor.clear.cgColor
        statusImageView.layer.borderWidth = 0.5
        statusImageView.layer.masksToBounds = true
        //self.backgroundColor = UIColor.orange
        self.addSubview(orderCellView)
        orderCellView.addSubview(seperateLineView)
        orderCellView.addSubview(orderCellImageView)
        orderCellView.addSubview(priceLabel)
        orderCellView.addSubview(productTypeAndMaterialInCell)
        orderCellView.addSubview(productSize)
        orderCellView.addSubview(productQuantityInCell)
        orderCellView.addSubview(quotePriceBtnInCell)
        orderCellView.addSubview(acceptProduceBtnInCell)
        orderCellView.addSubview(acceptDesignBtnInCell)
        orderCellView.addSubview(shippingBtnInCell)
        orderCellView.addSubview(statusImageView)
        orderCellView.addSubview(orderIDValue)
        orderCellView.addSubview(orderIDLabel)
        orderCellView.addSubview(orderTimeValue)
        orderCellView.addSubview(takePhotoForProductBtnInCell)
        orderCellView.addSubview(editOrderBtnInCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
