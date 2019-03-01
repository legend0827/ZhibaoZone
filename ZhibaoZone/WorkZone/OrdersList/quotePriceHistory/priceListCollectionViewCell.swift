//
//  priceListCollectionViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2019/2/28.
//  Copyright © 2019 Kevin. All rights reserved.
//

import UIKit

class priceListCollectionViewCell: UICollectionViewCell {
    lazy var priceCountSequenceValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 5, y: 21, width: 30, height: 15))
        tempLabel.text = "1"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return tempLabel
    }()
    lazy var priceValue:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 5, y: 61, width: 130, height: 15))
        tempLabel.text = "尚未报价"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return tempLabel
    }()
    lazy var priceTime:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 5, y: 103, width: 130, height: 15))
        tempLabel.text = "-"
        tempLabel.textColor = UIColor.titleColors(color: .black)
        tempLabel.textAlignment = .left
        tempLabel.font = UIFont.systemFont(ofSize: 10)
        return tempLabel
    }()
    lazy var currentPriceIcon:UIImageView = {
        let tempLabel = UIImageView.init(frame: CGRect(x: 17, y: 21, width: 26, height: 15))
        tempLabel.image = UIImage(named: "newesticonimg")
        return tempLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(priceCountSequenceValue)
        self.contentView.addSubview(priceTime)
        self.contentView.addSubview(priceValue)
        self.contentView.addSubview(currentPriceIcon)
        currentPriceIcon.isHidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
