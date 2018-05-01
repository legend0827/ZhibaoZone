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
    let productSize:UILabel = UILabel.init()
    let productQuantityInCell:UILabel = UILabel.init()
    let quotePriceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptProduceBtnInCell:UIButton = UIButton.init(type: .custom)
    let acceptDesignBtnInCell:UIButton = UIButton.init(type: .custom)
    let shippingBtnInCell:UIButton = UIButton.init(type: .custom)
    let priceLabelBackgroundView:UIImageView = UIImageView.init()
    let priceLabel:UILabel = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        orderCellView.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        orderCellImageView.frame = CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.width - 10)
        priceLabelBackgroundView.frame = CGRect(x: 5, y: frame.width - 35, width: frame.width - 10, height: 30)
        priceLabel.frame = CGRect(x: 5, y: frame.width - 30, width: frame.width - 10, height: 20)
        productTypeAndMaterialInCell.frame = CGRect(x: 5, y: frame.width - 5, width: 100, height: 20)
        productSize.frame =  CGRect(x: 5, y: frame.width + 15, width: (kWidth - 60)/2, height: 20)
        productQuantityInCell.frame = CGRect(x: 5, y: frame.width + 35, width: 100, height: 20)
        
        quotePriceBtnInCell.frame = CGRect(x: (frame.width - 85) / 2 , y: frame.width + 55, width: 85, height: 30)
        acceptProduceBtnInCell.frame = CGRect(x: (frame.width - 85) / 2, y: frame.width + 55, width: 85, height: 30)
        acceptDesignBtnInCell.frame = CGRect(x: (frame.width - 85) / 2, y: frame.width + 55, width: 85, height: 30)
        shippingBtnInCell.frame = CGRect(x: (frame.width - 85) / 2, y: frame.width + 55, width: 85, height: 30)
        
        
        orderCellView.layer.backgroundColor = UIColor.backgroundColors(color: .white).cgColor
        orderCellView.layer.cornerRadius = 6
        orderCellView.layer.shadowOffset = CGSize.zero//CGSize(width: 0, height: 0)
        orderCellView.layer.shadowOpacity = 1.0
        orderCellView.layer.shadowColor = UIColor.lineColors(color: .lightGray).cgColor//UIColor.black.cgColor
        
        
        orderCellImageView.image = UIImage(named: "defualt-design-pic")
        orderCellImageView.layer.cornerRadius = 6
        orderCellImageView.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
        orderCellImageView.layer.borderWidth = 0.5
        
        priceLabelBackgroundView.image = UIImage(named: "maskonimage")
        //priceLabelBackgroundView.alpha = 0.6
        
        priceLabel.text = "¥3000.00"
        priceLabel.textAlignment  = .center
        priceLabel.textColor = UIColor.titleColors(color: .white)
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        
        productTypeAndMaterialInCell.text = "徽章 锌合金"
        productTypeAndMaterialInCell.textColor = UIColor.titleColors(color: .black)
        productTypeAndMaterialInCell.font = UIFont.systemFont(ofSize: 14)

        
        productSize.text = "300x300x30(mm)"
        productSize.textColor = UIColor.titleColors(color: .black)
        productSize.font = UIFont.systemFont(ofSize: 14)
        
        productQuantityInCell.text = "x3000"
        productQuantityInCell.textColor = UIColor.titleColors(color: .red)
        productQuantityInCell.font = UIFont.systemFont(ofSize: 14)
        
        
        quotePriceBtnInCell.layer.cornerRadius = 6
        quotePriceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .red).cgColor
        quotePriceBtnInCell.setTitle("报价", for: UIControlState.normal)
        quotePriceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        quotePriceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        
        acceptProduceBtnInCell.layer.cornerRadius = 6
        acceptProduceBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .red).cgColor
        acceptProduceBtnInCell.setTitle("接受生产", for: UIControlState.normal)
        acceptProduceBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptProduceBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        acceptDesignBtnInCell.layer.cornerRadius = 6
        acceptDesignBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .red).cgColor
        acceptDesignBtnInCell.setTitle("接受设计", for: UIControlState.normal)
        acceptDesignBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        acceptDesignBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        shippingBtnInCell.layer.cornerRadius = 6
        shippingBtnInCell.layer.backgroundColor = UIColor.backgroundColors(color: .red).cgColor
        shippingBtnInCell.setTitle("上传物流", for: UIControlState.normal)
        shippingBtnInCell.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        shippingBtnInCell.setTitleColor(UIColor.titleColors(color: .white), for: UIControlState.normal)
        
        //self.backgroundColor = UIColor.orange
        self.addSubview(orderCellView)
        orderCellView.addSubview(orderCellImageView)
        orderCellView.addSubview(priceLabelBackgroundView)
        orderCellView.addSubview(priceLabel)
        orderCellView.addSubview(productTypeAndMaterialInCell)
        orderCellView.addSubview(productSize)
        orderCellView.addSubview(productQuantityInCell)
        orderCellView.addSubview(quotePriceBtnInCell)
        orderCellView.addSubview(acceptProduceBtnInCell)
        orderCellView.addSubview(acceptDesignBtnInCell)
        orderCellView.addSubview(shippingBtnInCell)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
