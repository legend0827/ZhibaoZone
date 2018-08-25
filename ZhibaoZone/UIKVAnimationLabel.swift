//
//  UIKVAnimationLabel.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/8/25.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class UIKVAnimationLabel: UILabel {

    //计时器 CADisplayLink会比NSTimer准确一些
    var timer:CADisplayLink!

    //进程戳 从开始计时到实时的时间戳 后面会与传进来的最长时间对比
    var progress:TimeInterval!
    //最后一次记录时间戳
    var lastupdate:TimeInterval!
    //多长时间完成的参数
    var totolupdate:TimeInterval!
    
    //最开始的计数
    var startValue:Float!
    //将要结束的参数
    var endValue:Float!
    
    //以Float 还是Int 类型增长
    var type:KVAnimationType!
    
    var newText:String{
        get{
            return updateNewInfo()
        }
    }
    
    init(frame: CGRect, type:KVAnimationType) {
        super.init(frame: frame)
        self.type = type
    }
    func initCADisplayLink(){
        progress = 0
        timer = CADisplayLink(target: self, selector:#selector(UIKVAnimationLabel.timerclick(sender:)))
        timer.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func timerclick(sender:CADisplayLink){
        //当执行这个方法的时候 判断当前时间戳与lastupdate这个参数的差 直到将其相加 直到与 totalupdate 相等时 即为消耗了等量时间 此时强行将text置为endValue
        
        //记录当前时间戳
        let now:TimeInterval = Date.timeIntervalSinceReferenceDate
        //当前时间 减去 开始时间
        progress = now - lastupdate
        
        if (now - lastupdate) >= totolupdate{
            progress = totolupdate
            stopLoop()
        }
        let text = newText
        self.text = text
    }
    
    func updateNewInfo() -> String{
        //当前时间/总共所需时间，来判断应该进到哪里（肯定不会大于1）
        let timeBi:Float = Float(progress)/Float(totolupdate)
        let updateVal = startValue + (timeBi * (self.endValue - self.startValue))
        
        if type == .Float{
            return String(format: "%.2f", updateVal)
        }
        return String(format: "%.0f", updateVal)
    }
    
    func countFrom(start:Float, to:Float, duration:TimeInterval){
        //将计时器销毁再重新生成
        if timer != nil{
            timer.invalidate()
            timer = nil
        }
        initCADisplayLink()
        
        //记录时间戳
        lastupdate = Date.timeIntervalSinceReferenceDate
        //消耗时间戳
        totolupdate = duration
        
        //赋值
        startValue = start
        endValue = to
    }
    
    func stopLoop(){
        timer.invalidate()
        timer = nil
    }
}

