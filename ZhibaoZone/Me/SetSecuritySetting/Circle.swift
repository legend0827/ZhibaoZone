//
//  Circle.swift
//  ZhibaoZone
//
//  Created by Kevin on 15/02/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

/**
 单个圆的各种状态
 
 - CircleStateNormal:          正常
 - CircleStateSelected:        锁定
 - CircleStateError:           错误
 - CircleStateLastOneSelected: 最后一个锁定
 - CircleStateLastOneError:    最后一个错误
 */
enum CircleState:Int {
    case circleStateNormal = 1
    case circleStateSelected
    case circleStateError
    case circleStateLastOneSelected
    case circleStateLastOneError
}

/**
 圆的用途
 
 - CircleTypeInfo:    正常
 - CircleTypeGesture: 手势下的圆
 */
enum CircleTye:Int {
    case circleTypeInfo = 1
    case circleTypeGesture
}

class Circle: UIView {

    /// 空心圆圆环宽度
    let CircleEdgeWidth:CGFloat = 1.0
    /// 三角形边长
    let kTrangleLength:CGFloat = 10.0
    
    
    /// 圆所处状态
    var _state: CircleState!
    var state:CircleState?
    {
        set{
            _state = newValue
            setNeedsDisplay()
        }
        
        get{
            return _state
        }
    }
    /// 圆的类型
    var type: CircleTye?
    /// 是否带有箭头  默认有
    var isArrow:Bool = true
    /// 角度 三角形的方向
    var _angle:CGFloat?
    var angle:CGFloat?
    {
        set {
            _angle = newValue
            setNeedsDisplay()
        }
        get {
            return _angle
        }
        
    }
    
    /// 外环颜色
    var outCircleColor: UIColor?
    {
        var color: UIColor?
        
        
        guard (self.state != nil) else {
            return  UIColor.colorWithRgba(115, g: 115, b: 115, a: 1)
           // return  UIColor.colorWithRgba(241, g: 241, b: 241, a: 1)
            
        }
        switch self.state! {
        case CircleState.circleStateNormal:
            color = UIColor.colorWithRgba(115, g: 115, b: 115, a: 1)
            //color = UIColor.colorWithRgba(241, g: 241, b: 241, a: 1)

        case CircleState.circleStateSelected:
           // color = UIColor.colorWithRgba(239, g: 57, b: 5, a: 1)
            color = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)

        case CircleState.circleStateError:
            color = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)
            
        case CircleState.circleStateLastOneSelected:
            //color = UIColor.colorWithRgba(239, g: 57, b: 5, a: 1)
            color = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)
            
        case CircleState.circleStateLastOneError:
            color = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)
            
        }
        return color
    }
    /// 实心圆颜色
    var inCircleColor: UIColor?
    {
        
        var color: UIColor?
        
        guard (self.state != nil) else {
            return  UIColor.clear
            
        }
        switch self.state! {
        case CircleState.circleStateNormal:
            color = UIColor.clear
            
        case CircleState.circleStateSelected:
            //color = UIColor.colorWithRgba(239, g: 57, b: 5, a: 1) //橙色
        color = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1) //蓝色
            
        case CircleState.circleStateError:
            color = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)
            
        case CircleState.circleStateLastOneSelected:
            //color = UIColor.colorWithRgba(239, g: 57, b: 5, a: 1)
        color = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)
            
        case CircleState.circleStateLastOneError:
            color = UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)
            
        }
        return color
    }
    /// 三角形颜色
    var trangleColor: UIColor?
    {
        var color: UIColor?
        
        guard (self.state != nil) else {
            return  UIColor.clear
            
        }
        switch self.state! {
        case CircleState.circleStateNormal:
            color = UIColor.clear
            
        case CircleState.circleStateSelected:
            //color = UIColor.colorWithRgba(239, g: 57, b: 5, a: 1)
            color = UIColor.colorWithRgba(34, g: 178, b: 246, a: 1)
            
        case CircleState.circleStateError:
            color =  UIColor.colorWithRgba(254, g: 82, b: 92, a: 1)
            
        case CircleState.circleStateLastOneSelected:
            color = UIColor.clear
            
        case CircleState.circleStateLastOneError:
            color = UIColor.clear
            
        }
        return color
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        angle = 0
        //        self.angle = 5
    }
    //
    //    convenience  init() {
    //        self.init()
    //        self.backgroundColor = CircleBackgroundColor
    //
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        angle = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        angle = 0
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func draw(_ rect: CGRect) {
        
        /// 获取画布
        let ctx = UIGraphicsGetCurrentContext()
        
        /// 所占圆比例
        var radio:CGFloat = 0
        let circleRect = CGRect(x: CircleEdgeWidth, y: CircleEdgeWidth, width: rect.size.width - 2 * CircleEdgeWidth, height: rect.size.height - 2 * CircleEdgeWidth)
        
        if self.type == CircleTye.circleTypeGesture {
            radio = 0.4
        } else if self.type == CircleTye.circleTypeInfo {
            radio = 1
        }
        
        //上下文旋转
        transFormCtx(ctx!, rect: rect)
        
        //画圆环
        drawEmptyCircleWithContext(ctx!, rect: circleRect, color: self.outCircleColor!)
        
        // 画实心圆
        drawSolidCircleWithContext(ctx!, rect: rect, radio: radio, color: self.inCircleColor!)
        
        if self.isArrow {
            
            //画三角形箭头
            drawTrangleWithContext(ctx!, point:CGPoint(x: rect.size.width/2, y: 10) , length: kTrangleLength, color: self.trangleColor!)
        }
        
    }
    
    //MARK:- 画三角形
    
    /**
     上下文旋转
     
     - parameter ctx:  画布
     - parameter rect: Rect
     */
    fileprivate func transFormCtx(_ ctx: CGContext,rect: CGRect) {
        
        let translateXY = rect.size.width * 0.5
        //平移
        ctx.translateBy(x: translateXY, y: translateXY)
        //已解决:- 三角形箭头指向
        //        angle = 2
        guard angle != nil else {
            return
        }
        ctx.rotate(by: angle!)
        //再平移回来
        ctx.translateBy(x: -translateXY, y: -translateXY)
        
    }
    
    //MARK:- 画外圆环
    
    /**
     画外圆环
     
     - parameter ctx:   图形上下文
     - parameter rect:  绘图范围
     - parameter color: 绘制颜色
     */
    
    fileprivate func drawEmptyCircleWithContext(_ ctx: CGContext,rect: CGRect,color: UIColor) {
        
        
        let circlePath = CGMutablePath()
        
        circlePath.addEllipse(in: rect)
        //        CGPathAddEllipseInRect(circlePath, nil, rect)
        ctx.addPath(circlePath)
        color.set()
        ctx.setLineWidth(CircleEdgeWidth)
        ctx.strokePath()
        //        CGPathRelease(circlePath)
        
        
    }
    //MARK:- 花实心圆
    /**
     画实心圆
     
     - parameter ctx:   图形上下文
     - parameter rect:  绘制范围
     - parameter radio: 占大圆比例
     - parameter color: 绘制颜色
     */
    fileprivate func drawSolidCircleWithContext(_ ctx: CGContext,rect: CGRect, radio: CGFloat, color: UIColor) {
        
        let circlePath = CGMutablePath()
        circlePath.addEllipse(in: CGRect(x: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, y: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, width: rect.size.width * radio - CircleEdgeWidth * 2, height: rect.size.width * radio - CircleEdgeWidth * 2))
        //        CGPathAddEllipseInRect(circlePath, nil, CGRect(x: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, y: rect.size.width / 2 * (1 - radio) + CircleEdgeWidth, width: rect.size.width * radio - CircleEdgeWidth * 2, height: rect.size.width * radio - CircleEdgeWidth * 2))
        color.set()
        ctx.addPath(circlePath)
        ctx.fillPath()
        //
        ctx.strokePath()
        //        CGPathRelease(circlePath)
        
    }
    
    
    //MARK:- 画三角形
    fileprivate func drawTrangleWithContext(_ ctx: CGContext,point: CGPoint,length: CGFloat,color: UIColor) {
        
        
        let trianglePathM = CGMutablePath() as CGMutablePath
        
        //3.0+
        trianglePathM.move(to: point)
        //2.0+
        //        CGPathMoveToPoint(trianglePathM, &transform, point.x , point.y)
        trianglePathM.addLine(to: CGPoint(x: point.x - length/2, y: point.y + length/2))
        //        CGPathAddLineToPoint(trianglePathM,nil, point.x - length/2, point.y + length/2)
        trianglePathM.addLine(to: CGPoint(x: point.x + length/2, y: point.y + length/2))
        //        CGPathAddLineToPoint(trianglePathM, nil, point.x + length/2, point.y + length/2)
        
        ctx.addPath(trianglePathM)
        color.set()
        ctx.fillPath()
        //
        ctx.strokePath()
        
        //        CGPathRelease(trianglePathM)
        
    }

}
