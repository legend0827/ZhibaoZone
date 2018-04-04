//
//  CircleInfoView.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class CircleInfoView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        lockViewPrepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lockViewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lockViewPrepare() {
        
        self.backgroundColor = UIColor.clear
        
        
        for _ in 0..<9 {
            let circle = Circle()
            circle.type = CircleTye.circleTypeInfo
            
            addSubview(circle)
            
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemViewWH = CGFloat(5.0) * 2
        let marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0
        
        (self.subviews as NSArray).enumerateObjects({(object, idx, stop) in
            let row:NSInteger = idx % 3;
            let col = idx / 3;
            
            let x:CGFloat = marginValue * CGFloat(row) + CGFloat(row) * itemViewWH + marginValue/2
            let y:CGFloat = marginValue * CGFloat(col) + CGFloat(col) * itemViewWH + marginValue/2
            
            let frame = CGRect(x: x, y: y, width: itemViewWH, height: itemViewWH)
            
            //设置tag -> 用于记录密码的单元
            (object as! UIView).tag = idx + 1
            (object as! UIView).frame = frame
        })
    }
}
