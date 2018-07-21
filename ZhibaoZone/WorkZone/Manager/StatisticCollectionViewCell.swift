//
//  StatisticCollectionViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/7/12.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class StatisticCollectionViewCell: UICollectionViewCell {
    let backgc:UIImageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgc.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backgc.image = UIImage(named: "asa") 
        self.contentView.addSubview(backgc)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
