//
//  UnlockGestureView.swift
//  ZhibaoZone
//
//  Created by Kevin on 05/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import CoreGraphics

class UnlockGestureView: UIView {
    private let   imgsize = 150
    private  var   pawd:String!
    private var   rowcount = 3
    var  back:UIImage {
        return UIImage(named:"defualt-design-pic")!
    }
    var btns: [UIButton]! = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        initialview()
    }
    convenience init(frame: CGRect, _ row:Int,_ pwd:String!) {
        self.init(frame:frame)
        self.rowcount = row
        self.pawd = pwd
        
    }
    func initialview(){
        //布局
        
        let    xpadding = (Int( self.bounds.size.width) - 3 * imgsize) / 4 //  计算一个横间距
        let    ypadding =  (Int( self.bounds.size.height) - (rowcount ) * imgsize) / (rowcount + 1)
        var   x = 0
        var   y = 0
        for  i in 0  ..< rowcount * 3  {
            let   btn = UIButton()
            btn.isSelected  = false
            btn.setImage(UIImage(named:"unlock-selected"), for: .selected)
            btn.setImage(UIImage(named:"unlock-highlighted"), for: .highlighted)
            btn.setImage(UIImage(named:"unlock-unselected"), for: .normal)
            // 并设置一个tag
            btn.tag = i
            addSubview(btn)
            btn.isUserInteractionEnabled = false
            x=xpadding*((i%3)+1)+imgsize*(i%3)
            y=ypadding*((i/rowcount)+1)+imgsize*(i/rowcount)
            btn.frame = CGRect(x: x, y: y, width: imgsize, height: imgsize)
            
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let  touch = touches.first  //
        let  point  = touch?.location(in: self)
        
        for    abtn in self.subviews{
            let  btn = abtn  as!  UIButton
            //表示滑动的时候这个矩形框是否包含这个点
            if btn.frame.contains(point!) {
                if btn.isSelected == false  {
                    if !btns.contains(btn) {
                        btns.append(btn)
                    }
                    
                    setNeedsDisplay()
                    
                }
                btn.isSelected = true
            }
        }
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //自定义视图如果设置交互为false默认会向俯视图传递响应莲  因此  解决方式  hittest
        var   result = ""
        for  btn  in btns{
            
            if btn.isSelected {
                result  +=  "\(btn.tag)"
                
                print(result)
            }
            btn.isSelected = false
            
            
            
        }
        
        
        if (result == self.pawd) {
            print("解锁成功！")
        }
        self.btns.removeAll()
        
        setNeedsDisplay()
    }
    
    // 重写draw方法
    override func draw(_ rect: CGRect) {
        let  cout = self.btns.count
        let   path = UIBezierPath()
        for  i in 0..<cout {
            let  point  = self.btns[i].center
            if i == 0 {
                path.move(to: point)
            }
            else{
                path.addLine(to: point)
            }
        }
        UIColor.blue.setStroke()//画笔颜色
        path.lineWidth   =  3
        path.stroke()
    }
}
