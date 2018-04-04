//
//  MarkSlider.swift
//  ZhibaoZone
//
//  Created by Kevin on 29/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class MarkSlider: UISlider {
    
    //刻度位置集合
    var markPositions:[CGFloat] = []
    //刻度颜色
    var markColor: UIColor?
    //刻度宽度
    var markWidth: CGFloat?
    //左侧轨道的颜色
    var leftBarColor: UIColor?
    //右侧轨道的颜色
    var rightBarColor:UIColor?
    //轨道高度
    var barHeight: CGFloat?
    //最大值
    var maxValue: Float?
    //最小值
    var minValue: Float?
    
    //初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置样式的默认值
        self.markColor = UIColor.gray
        self.markPositions = [1,10,20,30,40,50,60,70,80,90,100]
        self.markWidth = 1.0
        self.leftBarColor = UIColor.gray
        self.rightBarColor = UIColor.gray
        self.barHeight = 1.0
        self.maxValue = 100.0
        self.minValue = 1.0
        self.maximumValue = 100.0
        self.minimumValue = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            //得到左侧带有刻度的轨道图片（注意：图片不拉伸）
            let leftTrackImage = createTrackImage(rect: rect, barColor: self.leftBarColor!)
                .resizableImage(withCapInsets: .zero)
            
            //得到右侧带有刻度的轨道图片
            let rightTrackImage = createTrackImage(rect: rect, barColor: self.rightBarColor!)
            
            //将前面生产的左侧、右侧轨道图片设置到UISlider上
            self.setMinimumTrackImage(leftTrackImage, for: .normal)
            self.setMaximumTrackImage(rightTrackImage, for: .normal)
        }
    //生成轨道图片
    func createTrackImage(rect: CGRect, barColor:UIColor) -> UIImage {
        //开始图片处理上下文
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        //绘制轨道背景
        context.setLineCap(.round)
        context.setLineWidth(self.barHeight!)
        context.move(to: CGPoint(x:self.barHeight!/2, y:rect.height/2))
        context.addLine(to: CGPoint(x:rect.width-self.barHeight!/2, y:rect.height/2))
        context.setStrokeColor(barColor.cgColor)
        context.strokePath()
        
        //绘制轨道上的刻度
        for i in 0..<self.markPositions.count {
            context.setLineWidth(self.markWidth!)
            var devideNum:CGFloat = 1.0
            var position: CGFloat = 1.0
            if self.markPositions.count == 1{
                devideNum = 2
                position = self.markPositions[i]*rect.width/(CGFloat(maxValue!)/devideNum)
                print("only 1 value should with only mid mark")
            }else{
                if i == 0{
                    position = 1
                    print("the start position in \(self.markPositions.count) value and postion at\(position) and in total width:\(rect.width)")
                }else if i == self.markPositions.count - 1{
                    position = rect.width
                    print("the end position in \(self.markPositions.count) value and postion at\(position) and in total width:\(rect.width)")
                }else{
                    devideNum = CGFloat(self.markPositions.count - 1)
                    position = rect.width/devideNum*CGFloat(i)
                    print("the mid position in \(self.markPositions.count) value and postion at\(position) and in total width:\(rect.width)")
                }
                
            }
            context.move(to: CGPoint(x:position, y: rect.height/2-self.barHeight!/2+3))
            context.addLine(to: CGPoint(x:position, y:rect.height/2+self.barHeight!/2-3))
            context.setStrokeColor(self.markColor!.cgColor)
            context.strokePath()
        }
        
        //得到带有刻度的轨道图片
        let trackImage = UIGraphicsGetImageFromCurrentImageContext()!
        //结束上下文
        UIGraphicsEndImageContext()
        return trackImage
    }

}
