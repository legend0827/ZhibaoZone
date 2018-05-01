//
//  ActionViewInOrder.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ActionViewInOrder: UIView {
//
//    //报价窗口变量定义
//    var quotePriceWeight = 1
//    //mark  3 字 y = 60, 4字 y = 75
//    let orderTimeLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 50, width: 200, height: 30))
//    let orderID:UILabel = UILabel.init(frame: CGRect(x: 198, y: 50, width: 150, height: 30))
//    
//    //参考图
//    let orderDefaultPic: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 75, width: 100, height: 100))
//    //点击预览层
//    let orderDefaultPicLayer:UIView = UIView.init(frame: CGRect(x: 0, y: 80, width: 100, height: 20))
//    
//    //产品类型
//    let productTypeNameValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 175, width: 250, height: 30))
//    //工艺
//    let makeStyleValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 200, width: 280, height: 30))
//    //附件
//    let accessoriesValue:UILabel = UILabel.init(frame: CGRect(x: 50, y: 225, width: 280, height: 30))
//    
//    //订购数目
//    let orderCountValue:UILabel = UILabel.init(frame: CGRect(x: 160, y: 75, width: 100, height: 30))
//    //产品尺寸
//    //长
//    // x: 190
//    let productSizeOfLengthValue:UILabel = UILabel.init(frame: CGRect(x: 130, y: 125, width: 100, height: 30))
//    //宽
//    let productSizeOfWidthValue:UILabel = UILabel.init(frame: CGRect(x: 190, y: 125, width: 100, height: 30))
//    //高
//    let productSizeOfHeightValue:UILabel = UILabel.init(frame: CGRect(x: 250, y: 125, width: 100, height: 30))
//    
//    let quotePriceAtLastTimeValue:UILabel = UILabel.init(frame: CGRect(x: 80, y: 295, width: 200, height: 44))
//    let customerPriceValue:UILabel = UILabel.init(frame: CGRect(x: 225, y: 295, width: 200, height: 44))
//    let customerPriceLabel:UILabel = UILabel.init(frame: CGRect(x: 190, y: 295, width: 200, height: 44))
//    
//    let designFeeValue:UILabel = UILabel.init(frame: CGRect(x: 65, y: 285, width: 200, height: 44))
//    let setQuotePriceWeightBtn:UIButton = UIButton.init(type: .system)
//    
//    
//    //y 最终等于110
//    let blurPopView:UIView = UIView.init(frame: CGRect(x: (UIScreen.main.bounds.width - 350)/2, y: UIScreen.main.bounds.height, width: 350, height: 500))
//    
//    let quotePriceSlideBarRightLabel:UILabel = UILabel.init(frame: CGRect(x: 85, y: 415, width: 250, height: 30))
//    let quotePriceSlideBarMidLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 320, height: 30))
//    let quotePriceSlideBarLeftLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 415, width: 250, height: 30))
//    
//    //设置设计备注，订单备注输入框
//    lazy var orderMemosForDesignOrProducer:UILabel = {
//        //label值55，当前值62 差 7
//        var tempLabel = UILabel.init(frame: CGRect(x: 15, y: 335+24, width: 320, height: 85))
//        tempLabel.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
//        tempLabel.layer.cornerRadius = 5
//        tempLabel.font = UIFont.systemFont(ofSize: 14)
//        tempLabel.textColor = UIColor.black
//        //tempLabel.textAlignment = NSTextAlignment.left
//        tempLabel.lineBreakMode = .byTruncatingTail
//        tempLabel.numberOfLines = 4
//        tempLabel.textAlignment = .justified
//        return tempLabel
//    }()
//    
//    //报价的滑动条
//    lazy var quotePriceSlideBar:UISlider = {
//        var tempSliderBar = UISlider.init(frame: CGRect(x: 15, y: 390, width: 320, height: 20))
//        return tempSliderBar
//    }()
//    
//    //设置生产工期输入框
//    lazy var produceTimeCostTextField:UITextField = {
//        //label值55，当前值62 差 7
//        var tempSliderTextField = UITextField.init(frame: CGRect(x: 250, y: 342, width: 56, height: 30))
//        tempSliderTextField.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
//        tempSliderTextField.layer.cornerRadius = 5
//        tempSliderTextField.delegate = self
//        return tempSliderTextField
//    }()
//    
//    //当前设置报价框
//    lazy var currentValueOnSliderTextField:UITextField = {
//        //label值55，当前值62 差 7
//        var tempSliderTextField = UITextField.init(frame: CGRect(x: 110, y: 342, width: 86, height: 30)) // width 225 。 位置 335
//        tempSliderTextField.backgroundColor = UIColor.init(red: 244.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
//        tempSliderTextField.layer.cornerRadius = 5
//        tempSliderTextField.delegate = self
//        return tempSliderTextField
//    }()
//    
//    //定义毛玻璃灰层
//    lazy var grayLayer:UIView = {
//        //y= 64表示要显示上方的切换按钮
//        var tempView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        tempView.backgroundColor = UIColor.gray
//        tempView.alpha = 0.2
//        return tempView
//    }()
//    
//    
//    quotePriceWeight =  getQuotePriceWeight()
//    
//    currentValueOnSliderTextField.keyboardType = .decimalPad
//    produceTimeCostTextField.keyboardType = .decimalPad

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
