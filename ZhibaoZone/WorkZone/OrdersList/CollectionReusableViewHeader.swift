//
//  CollectionReusableViewHeader.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/5/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

// 自定义headerview
import UIKit

let headerIdentifier = "CollectionReusableViewHeader"

class CollectionReusableViewHeader: UICollectionReusableView {
    var label:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label = UILabel(frame: CGRect(x: 10.0, y: 0, width: 200, height: 40))
//        self.label = UILabel(frame: CGRectMake(10.0, 0.0, (CGRectGetWidth(self.bounds) - 10.0 * 2), heightHeader))
        self.addSubview(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
