//
//  LockLabel.swift
//  ZhibaoZone
//
//  Created by Kevin on 12/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class LockLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewPrepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewPrepare(){
        self.font = UIFont.systemFont(ofSize:14)
        self.textAlignment = .center
    }
    
    /**
     普通提示信息
     
     - parameter msg: 信息
     */
    func showNormalMag(_ msg:NSString){
        self.text = msg as String
        self.textColor = UIColor.colorWithRgba(115, g: 115, b: 115, a: 1) //UIColor.colorWithRgba(241, g: 241, b: 241, a: 1) // 普通状态下文字提示的颜色
    }
    
    /**
     警示信息
     
     - parameter msg: 信息
     */
    func showWarnMsg(_ msg: String){
        self.text = msg
        self.textColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)     /// 警告状态下文字提示的颜色
    }
    
    /**
     警示信息(shake)
     
     - parameter msg: 警示信息
     */
    func showWarnMsgAndShake(_ msg:String) {
        
        self.text = msg
        self.textColor = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)//    /// 警告状态下文字提示的颜色
        //添加一个shake动画
        self.layer.shake()
        
    }

}

extension UIColor {
    
    class func colorWithRgba(_ r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat)-> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        
    }
    
}

extension CALayer {
    
    func shake() {
        let kfa = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        let s:CGFloat = 5.0
        
        
        kfa.values = [(-s),(0),s,0,-s,0,s,0]
        
        //晃动时长
        kfa.duration = 0.3
        
        //重复次数
        kfa.repeatCount = 2
        
        //移除
        kfa.isRemovedOnCompletion = true
        
        add(kfa, forKey: "shake")
        
    }
    
}
