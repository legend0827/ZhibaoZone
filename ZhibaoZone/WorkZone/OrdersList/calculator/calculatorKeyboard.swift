//
//  calculatorKeyboard.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/9/15.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class calculatorKeyboard: UIView {
    //弹窗ViewVC
    var popupVC = PopupViewController()
    lazy var actionView = ActionViewInOrder()
    var _roleType = 3
    //背景View
    let backgroundView:UIView = UIView.init()
    let resultView:UIView = UIView.init()
    let quotePriceResult:UILabel = UILabel.init()
    //结果处理
    var targetResult = 0
    //取整
    var isCutResultTail:Bool = false
    var quotePriceWeight = 1
    lazy var upToNextIntBtn:UIButton = {
        let tempButton:UIButton = UIButton.init(type: .custom)
        tempButton.frame = CGRect(x: 15, y: 124, width: 72, height: 30)
        tempButton.setTitle("取整", for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        tempButton.contentHorizontalAlignment = .center
        tempButton.layer.cornerRadius = 2
        tempButton.layer.borderColor = UIColor.clear.cgColor
        tempButton.backgroundColor = UIColor.backgroundColors(color: .red)
        tempButton.layer.borderWidth = 1
        tempButton.tag = 101
        tempButton.addTarget(self, action: #selector(switchResultOperation(_:)), for: .touchUpInside)
        return tempButton
    }()

    
    lazy var cutTailBtn:UIButton = {
        let tempButton:UIButton = UIButton.init(type: .custom)
        tempButton.frame = CGRect(x: 102, y: 124, width: 72, height: 30)
        tempButton.setTitle("抹零", for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        tempButton.contentHorizontalAlignment = .center
        tempButton.layer.cornerRadius = 2
        tempButton.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
        tempButton.layer.borderWidth = 1
        tempButton.tag = 102
        tempButton.addTarget(self, action: #selector(switchResultOperation(_:)), for: .touchUpInside)
        return tempButton
    }()
    //笑脸图标
    lazy var smileLabel:UIImageView = {
        let tempLalbel = UIImageView.init(frame: CGRect(x: kWidth - 80, y: 85, width: 18, height: 18))
        tempLalbel.image = UIImage(named: "smileimg")
        tempLalbel.isHidden = true
        return tempLalbel
    }()
    
    lazy var operatonLabel:UILabel = {
        let tempLabel:UILabel = UILabel.init(frame: CGRect(x: kWidth - 70, y: 84, width: 55, height: 20))
        tempLabel.text = "已取整"
        tempLabel.textAlignment = .right
        tempLabel.textColor = UIColor.colorWithRgba(255, g: 120, b: 83, a: 1.0)
        tempLabel.isHidden = true
        tempLabel.font = UIFont.systemFont(ofSize: 14)
        return tempLabel
    }()
    
    //设置报价精准度
    let setQuotePriceWeightBtn:UIButton = UIButton.init(type: .system)
    
    lazy var resultLabel:UILabel = {
        let tempLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 18, width: kWidth - 30, height: 40))
        tempLabel.text = "0"
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont.systemFont(ofSize: 28)
        return tempLabel
    }()
    
    lazy var closeLayer:UIButton = {
        let tempButton:UIButton = UIButton.init(type: .custom)
        tempButton.frame = CGRect(x: kWidth - 65, y: 6, width: 55, height: 20)
        tempButton.setTitle("关闭", for: .normal)
        tempButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tempButton.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
        tempButton.contentHorizontalAlignment = .right
        tempButton.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        return tempButton
    }()
    // 1
    lazy var oneKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "onekeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 1
        return tempKey
    }()

    //2
    lazy var twoKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "twokeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 2
        return tempKey
    }()
    
    //3
    lazy var threeKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "threekeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 3
        return tempKey
    }()
    
    //4
    lazy var fourKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "fourkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 4
        return tempKey
    }()
    
    
    //5
    lazy var fiveKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "fivekeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 5
        return tempKey
    }()
    
    //6
    lazy var sixKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "sixkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 6
        return tempKey
    }()
    
    //7
    lazy var sevenKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "sevenkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 7
        return tempKey
    }()
    
    //8
    lazy var eightKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "eightkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 8
        return tempKey
    }()
    
    //9
    lazy var nineKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "ninekeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 9
        return tempKey
    }()
    
    //0
    lazy var zeroKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "zerokeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 0
        return tempKey
    }()
    //.
    lazy var dotKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "dotkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 10
        return tempKey
    }()
    
    // 删除按钮
    lazy var deleteKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "deletekeyimg-small") , for: .normal)
        tempKey.tag = 11
        return tempKey
    }()
    
    
    // 确认提交报价
    lazy var confirmKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "savepriceimg") , for: .normal)
        tempKey.tag = 12
        return tempKey
    }()
    
    // =
    lazy var equalKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "equalkeyimg") , for: .normal)
        tempKey.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        tempKey.contentVerticalAlignment = .center
        tempKey.contentHorizontalAlignment = .center
        tempKey.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
        //        oneKeyBtn.layer.borderColor = UIColor.titleColors(color: .gray).cgColor
        //        oneKeyBtn.layer.borderWidth = 0.5
        tempKey.setTitleColor(UIColor.titleColors(color: .white), for: .highlighted)
        tempKey.tag = 13
        return tempKey
    }()
    
    // 加号
    lazy var plusKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "pluskeyimg") , for: .normal)
        tempKey.tag = 14
        return tempKey
    }()
    
    // 减号
    lazy var minusKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "minuskeyimg") , for: .normal)
        tempKey.tag = 15
        return tempKey
    }()
    
    // 乘号
    lazy var byKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "bykeyimg") , for: .normal)
        tempKey.tag = 16
        return tempKey
    }()
    // 除号
    lazy var devideKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "devidekeyimg") , for: .normal)
        tempKey.tag = 17
        return tempKey
    }()
    
    // AC
    lazy var acKeyBtn:UIButton = {
        let tempKey:UIButton = UIButton.init(type: .custom)
        tempKey.setImage(UIImage(named: "ackeyimg") , for: .normal)
        tempKey.tag = 18
        return tempKey
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 416)
        backgroundView.backgroundColor = UIColor.backgroundColors(color: .white)
        setupKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupKeyboard(){
        let keyWight:CGFloat = kWidth/4
        let keyHeight:CGFloat = 255/5
        
        let keyboardBG:UIView = UIView.init(frame: CGRect(x: 0, y: 169, width: kWidth, height: 255))
        keyboardBG.backgroundColor = UIColor.colorWithRgba(250, g: 251, b: 251, a: 1.0)
        
        //报价值和标题
        let quotePriceResultLabel:UILabel = UILabel.init(frame: CGRect(x: 15, y: 84, width: 80, height: 22))
        quotePriceResultLabel.text = "报价："
        quotePriceResultLabel.font = UIFont.systemFont(ofSize: 16)
        
        quotePriceResult.frame = CGRect(x: 83, y: 82, width: kWidth - 100, height: 25)
        quotePriceResult.text = "¥0.0"
        quotePriceResult.font = UIFont.systemFont(ofSize: 18)
        quotePriceResult.textColor = UIColor.titleColors(color: .darkGray)
        
        resultView.frame = CGRect(x: 0, y: 0, width: kWidth, height: 64)
        resultView.backgroundColor = UIColor.colorWithRgba(34, g: 27, b: 27, a: 0.85)
        resultView.addSubview(resultLabel)
        
        let seperateLine:UIView = UIView.init(frame: CGRect(x: 15, y: 122, width: kWidth - 15, height: 0.5))
        seperateLine.backgroundColor = UIColor.lineColors(color: .lightGray)
        
        setQuotePriceWeightBtn.frame = CGRect(x: kWidth - 115, y: seperateLine.frame.maxY + 4, width: 100, height: 20)
        setQuotePriceWeightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setQuotePriceWeightBtn.contentHorizontalAlignment = .right
        setQuotePriceWeightBtn.setTitleColor(UIColor.titleColors(color: .darkGray), for: .normal)
        setQuotePriceWeightBtn.setTitle("设置精准度", for: .normal)
        setQuotePriceWeightBtn.addTarget(self, action: #selector(setQuotePriceWeight), for: .touchUpInside)
        backgroundView.addSubview(setQuotePriceWeightBtn)
        
        plusKeyBtn.frame =      CGRect(x: 1,              y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        minusKeyBtn.frame =     CGRect(x: 1 + keyWight,   y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        byKeyBtn.frame =        CGRect(x: 1 + keyWight*2, y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        devideKeyBtn.frame =    CGRect(x: 1 + keyWight*3, y: 1,               width: keyWight - 2,     height: keyHeight - 3)
        
        oneKeyBtn.frame =       CGRect(x: 1,              y: keyHeight,       width: keyWight - 2,     height: keyHeight - 3)
        twoKeyBtn.frame =       CGRect(x: 1 + keyWight,   y: keyHeight,       width: keyWight - 2,     height: keyHeight - 3)
        threeKeyBtn.frame =     CGRect(x: 1 + keyWight*2, y: keyHeight,       width: keyWight - 2,     height: keyHeight - 3)
        acKeyBtn.frame =        CGRect(x: 1 + keyWight*3, y: keyHeight,       width: keyWight - 2,     height: keyHeight - 2)
        
        fourKeyBtn.frame =      CGRect(x: 1,              y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        fiveKeyBtn.frame =      CGRect(x: 1 + keyWight,   y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        sixKeyBtn.frame =       CGRect(x: 1 + keyWight*2, y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        deleteKeyBtn.frame =    CGRect(x: 1 + keyWight*3, y: keyHeight*2,     width: keyWight - 2,     height: keyHeight - 2)
        
        sevenKeyBtn.frame =     CGRect(x: 1,              y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        eightKeyBtn.frame =     CGRect(x: 1 + keyWight,   y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        nineKeyBtn.frame =      CGRect(x: 1 + keyWight*2, y: keyHeight*3,     width: keyWight - 2,     height: keyHeight - 2)
        
        dotKeyBtn.frame =      CGRect(x: 1,              y: keyHeight*4,     width: keyWight - 2,     height: keyHeight - 2)
        zeroKeyBtn.frame =      CGRect(x: 1 + keyWight,   y: keyHeight*4,     width: keyWight - 2,     height: keyHeight - 2)
        equalKeyBtn.frame = CGRect(x: 1 + keyWight*2, y: keyHeight*4,     width: keyWight - 2,     height: keyHeight - 2)
        
        confirmKeyBtn.frame =   CGRect(x: keyWight*3, y: keyHeight*3 - 2,     width: keyWight,     height: keyHeight*2 + 4)
        
        oneKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        twoKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        threeKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        fourKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        fiveKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        sixKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        sevenKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        eightKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        nineKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        zeroKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        dotKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        deleteKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        confirmKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        plusKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        minusKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        byKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        devideKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        acKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        equalKeyBtn.addTarget(self, action: #selector(keyboardKeyPressed), for: .touchUpInside)
        
        keyboardBG.addSubview(oneKeyBtn)
        keyboardBG.addSubview(twoKeyBtn)
        keyboardBG.addSubview(threeKeyBtn)
        keyboardBG.addSubview(fourKeyBtn)
        keyboardBG.addSubview(fiveKeyBtn)
        keyboardBG.addSubview(sixKeyBtn)
        keyboardBG.addSubview(sevenKeyBtn)
        keyboardBG.addSubview(eightKeyBtn)
        keyboardBG.addSubview(nineKeyBtn)
        keyboardBG.addSubview(dotKeyBtn)
        keyboardBG.addSubview(zeroKeyBtn)
        keyboardBG.addSubview(equalKeyBtn)
        keyboardBG.addSubview(deleteKeyBtn)
        keyboardBG.addSubview(confirmKeyBtn)
        keyboardBG.addSubview(plusKeyBtn)
        keyboardBG.addSubview(minusKeyBtn)
        keyboardBG.addSubview(byKeyBtn)
        keyboardBG.addSubview(devideKeyBtn)
        keyboardBG.addSubview(acKeyBtn)
        
        
        let horizentalLine1:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: 0.5))
        horizentalLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine1)
        
        let horizentalLine2:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight - 1, width: kWidth, height: 0.5))
        horizentalLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine2)
        
        let horizentalLine3:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*2 - 1, width: kWidth, height: 0.5))
        horizentalLine3.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine3)
        
        let horizentalLine4:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*3 - 1, width: kWidth, height: 0.5))
        horizentalLine4.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine4)
        
        let horizentalLine5:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*4 - 1, width: keyWight*3, height: 0.5))
        horizentalLine5.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine5)
        
        let horizentalLine6:UIView = UIView.init(frame: CGRect(x: 0, y: keyHeight*5 - 1, width: kWidth, height: 0.5))
        horizentalLine6.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(horizentalLine6)
        
        let verticalLine1:UIView = UIView.init(frame: CGRect(x: keyWight, y: 0, width: 0.5, height: 255))
        verticalLine1.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine1)
        
        let verticalLine2:UIView = UIView.init(frame: CGRect(x: keyWight*2, y: 0, width: 0.5, height: 255))
        verticalLine2.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine2)
        
        let verticalLine3:UIView = UIView.init(frame: CGRect(x: keyWight*3, y: 0, width: 0.5, height: 255))
        verticalLine3.backgroundColor = UIColor.lineColors(color: .lightGray)
        keyboardBG.addSubview(verticalLine3)
        
        self.addSubview(backgroundView)
        backgroundView.addSubview(keyboardBG)
        backgroundView.addSubview(resultView)
        backgroundView.addSubview(quotePriceResultLabel)
        backgroundView.addSubview(quotePriceResult)
        backgroundView.addSubview(closeLayer)
        backgroundView.addSubview(upToNextIntBtn)
        backgroundView.addSubview(cutTailBtn)
        backgroundView.addSubview(smileLabel)
        backgroundView.addSubview(operatonLabel)
        print("keyboard setuped")
    }
    
    @objc func closeBtnClicked(){
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
            self.actionView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
        self.removeFromSuperview()
    }
    @objc func switchResultOperation(_ button:UIButton){
        let pressIndex = button.tag
        if pressIndex == 101 {
            //取整
            isCutResultTail = false
            
            cutTailBtn.layer.cornerRadius = 2
            cutTailBtn.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
            cutTailBtn.layer.borderWidth = 1
            cutTailBtn.backgroundColor = UIColor.clear
            cutTailBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            
            upToNextIntBtn.layer.cornerRadius = 2
            upToNextIntBtn.layer.borderColor = UIColor.clear.cgColor
            upToNextIntBtn.layer.borderWidth = 1
            upToNextIntBtn.backgroundColor = UIColor.backgroundColors(color: .red)
            upToNextIntBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            
            opreationValue(with: targetResult)
        }else if pressIndex == 102 {
            //抹零
            isCutResultTail = true
            upToNextIntBtn.layer.cornerRadius = 2
            upToNextIntBtn.layer.borderColor = UIColor.lineColors(color: .lightGray).cgColor
            upToNextIntBtn.layer.borderWidth = 1
            upToNextIntBtn.backgroundColor = UIColor.clear
            upToNextIntBtn.setTitleColor(UIColor.titleColors(color: .black), for: .normal)
            
            cutTailBtn.layer.cornerRadius = 2
            cutTailBtn.layer.borderColor = UIColor.clear.cgColor
            cutTailBtn.layer.borderWidth = 1
            cutTailBtn.backgroundColor = UIColor.backgroundColors(color: .red)
            cutTailBtn.setTitleColor(UIColor.titleColors(color: .white), for: .normal)
            opreationValue(with: targetResult)
        }else{
            print("wrong Press Index pressed")
        }
    }
    func opreationValue(with Value:Int){
        //进行抹零还是取整操作
        quotePriceWeight = getQuotePriceWeight()
        
        smileLabel.isHidden = true
        operatonLabel.isHidden = true
        
        if Value <= 0 {
            quotePriceResult.text = "¥\(String(format: "%d", Value))"
            return
        }
        
        if isCutResultTail {
            //去尾
            
            if quotePriceWeight == 1{
                quotePriceResult.text = "¥\(String(format: "%d", Value))"
            }else if quotePriceWeight == 10{
                if String(Value).lengthOfBytes(using: .utf8) < 2 {
                    quotePriceResult.text = "¥\(String(format: "%d", Value))"
                }else{
                    quotePriceResult.text = "¥\(String(format: "%d", Value/10))0" // 最后1位替换成0
                    smileLabel.isHidden = false
                    operatonLabel.isHidden = false
                    operatonLabel.text = "已抹零"
                }
            }else{
                
                if String(Value).lengthOfBytes(using: .utf8) < 3 {
                    quotePriceResult.text = "¥\(String(format: "%d", Value))"
                }else{
                    quotePriceResult.text = "¥\(String(format: "%d", Value/100))00" // 最后2位替换成0
                    smileLabel.isHidden = false
                    operatonLabel.isHidden = false
                    operatonLabel.text = "已抹零"
                }
            }
            
        }else{
            //取整
            if quotePriceWeight == 1{
                quotePriceResult.text = "¥\(String(format: "%d", Value))"
            }else if quotePriceWeight == 10{
                if String(Int(Value)).last == "0"{
                    quotePriceResult.text = "¥\(String(format: "%d", Value/10*10))"
                }else{
                    quotePriceResult.text = "¥\(String(format: "%d", Value/10*10 + 10))"
                }
                smileLabel.isHidden = false
                operatonLabel.isHidden = false
                operatonLabel.text = "已取整"
            }else{
                
                if String(Value).lengthOfBytes(using: .utf8) < 2 {
                    quotePriceResult.text = "¥\(String(format: "%d", Value))"
                }else{
          
                    if String(Int(Value)).suffix(2) == "00"{
                        quotePriceResult.text = "¥\(String(format: "%d", Value/100*100))"
                    }else{
                        quotePriceResult.text = "¥\(String(format: "%d", Value/100*100 + 100))"
                    }
                    quotePriceResult.text = "¥\(String(format: "%d", Value/100*100 + 100))"
                    smileLabel.isHidden = false
                    operatonLabel.isHidden = false
                    operatonLabel.text = "已取整"
                }
            }
        }
    }
    //设置权重
    @objc func setQuotePriceWeight(){
        let setParameterVC = SetParamtersViewController(roleType: _roleType)
        popupVC.present(setParameterVC, animated: true, completion: nil)
    }
    
    @objc func keyboardKeyPressed(_ button:UIButton){
        let pressIndex = button.tag
        print("pressed key \(pressIndex)")
        var currentText = resultLabel.text ?? ""

        switch pressIndex {
        case 0:
            var numberSequence:[String] = []
            //如果之前是运算符，输入0的时候直接返回就行了
            if currentText.last == "+" || currentText.last == "-" || currentText.last == "*"  || currentText.last == "/" {
                //currentText.removeLast()
                resultLabel.text = currentText + "\(pressIndex)" //如果之前是运算符，输入0的时候, 允许输入并直接返回就行了
                return
            }
            
            var tempOrginalString = currentText
            
            //如果以负数开头,记录一下,拆分操作数的时候先将第一个字符移除
            if currentText.first == "-" {
                tempOrginalString.removeFirst()
            }
            
            //将操作数拆分开
            let subString1 = tempOrginalString.split(separator: "+")
            for tempString1 in subString1{
                let subString2 = tempString1.split(separator: "-")
                for tempString2 in subString2{
                    let subString3 = tempString2.split(separator: "*")
                    for tempString3 in subString3{
                        let subString4 = tempString3.split(separator: "/")
                        for tempString4 in subString4{
                            print(tempString4)
                            numberSequence.append(String(tempString4))
                        }
                    }
                }
            }
            //如果拆分出来的数字的最后一个数字是0,尝试再输入其他数字的时候，直接删除最后一位，再插入新数字就可以了
            if numberSequence.last == "0"{
                currentText.removeLast()
            }
            
            resultLabel.text = currentText + "\(pressIndex)"
        case 1,2,3,4,5,6,7,8,9:
            var numberSequence:[String] = []
            //如果之前是运算符，输入0的时候直接返回就行了
            if currentText.last == "+" || currentText.last == "-" || currentText.last == "*"  || currentText.last == "/" {
                //currentText.removeLast()
                resultLabel.text = currentText + "\(pressIndex)" //如果之前是运算符，输入0的时候, 允许输入并直接返回就行了
                return
            }
            
            var tempOrginalString = currentText
            
            //如果以负数开头,记录一下,拆分操作数的时候先将第一个字符移除
            if currentText.first == "-" {
                tempOrginalString.removeFirst()
            }
            
            //将操作数拆分开
            let subString1 = tempOrginalString.split(separator: "+")
            for tempString1 in subString1{
                let subString2 = tempString1.split(separator: "-")
                for tempString2 in subString2{
                    let subString3 = tempString2.split(separator: "*")
                    for tempString3 in subString3{
                        let subString4 = tempString3.split(separator: "/")
                        for tempString4 in subString4{
                            print(tempString4)
                            numberSequence.append(String(tempString4))
                        }
                    }
                }
            }
            //如果拆分出来的数字的最后一个数字是0,尝试再输入其他数字的时候，直接删除最后一位，再插入新数字就可以了
            if numberSequence.last == "0"{
                currentText.removeLast()
            }
            resultLabel.text = currentText + "\(pressIndex)"
        case 10:
            
            var numberSequence:[String] = []
            //如果之前是运算符，输入0的时候直接返回就行了
            if currentText.last == "+" || currentText.last == "-" || currentText.last == "*"  || currentText.last == "/" {
                //currentText.removeLast()
                resultLabel.text = currentText + "\(pressIndex)" //如果之前是运算符，输入0的时候, 允许输入并直接返回就行了
                return
            }
            
            var tempOrginalString = currentText
            
            //如果以负数开头,记录一下,拆分操作数的时候先将第一个字符移除
            if currentText.first == "-" {
                tempOrginalString.removeFirst()
            }
            
            //将操作数拆分开
            let subString1 = tempOrginalString.split(separator: "+")
            for tempString1 in subString1{
                let subString2 = tempString1.split(separator: "-")
                for tempString2 in subString2{
                    let subString3 = tempString2.split(separator: "*")
                    for tempString3 in subString3{
                        let subString4 = tempString3.split(separator: "/")
                        for tempString4 in subString4{
                            print(tempString4)
                            numberSequence.append(String(tempString4))
                        }
                    }
                }
            }
            //如果拆分出来的最后一个字传里有小数点了，就直接返回就可以了
            if (numberSequence.last?.contains("."))!{
                return
            }
            
            if currentText != ""{
                resultLabel.text = currentText + "."
            }else{
                resultLabel.text = currentText + "0."
            }
            
        case 11: //delete
            //lengthValue.text =
            if currentText != "" {
                currentText.removeLast()
                resultLabel.text = currentText
            }
            
        case 12:
            if !(currentText.contains("+") || currentText.contains("-") || currentText.contains("*") || currentText.contains("/")){
                quotePriceResult.text = "¥\(String(format: "%d", Double(currentText)!))"
                targetResult = Int(Double(currentText)!)
                actionView.currentValueOnSliderTextField.text = currentText// resultLabel.text
            }else{
                var calculationNum:[Double] = [] //存放操作数
                var numberSequence:[String] = []
                var startsWithMinus = false
                //如果算式的最后一位为运算符，则直接去掉
                if currentText.last == "+" || currentText.last == "-" || currentText.last == "*"  || currentText.last == "/" {
                    currentText.removeLast()
                }
                
                var tempOrginalString = currentText
                
                //如果以负数开头,记录一下,拆分操作数的时候先将第一个字符移除
                if currentText.first == "-" {
                    startsWithMinus = true
                    tempOrginalString.removeFirst()
                }
                
                //将操作数拆分开
                let subString1 = tempOrginalString.split(separator: "+")
                for tempString1 in subString1{
                    let subString2 = tempString1.split(separator: "-")
                    for tempString2 in subString2{
                        let subString3 = tempString2.split(separator: "*")
                        for tempString3 in subString3{
                            let subString4 = tempString3.split(separator: "/")
                            for tempString4 in subString4{
                                print(tempString4)
                                //calculationNum.append(Double(tempString4)!)
                                calculationNum.append(Double(tempString4)!)
                                numberSequence.append(String(tempString4))
                            }
                        }
                    }
                }
                
                //获取操作符
                var calcType:[String] = []
                //检测是否包含乘除法
                var markByOrDevideContains = false
                for splitString in numberSequence{
                    let startIndex = splitString.startIndex
                    let index = tempOrginalString.index(startIndex, offsetBy: splitString.lengthOfBytes(using: .utf8))
                    // 已经不包含运算符时，不继续拆分
                    if !(tempOrginalString.contains("+") || tempOrginalString.contains("-") || tempOrginalString.contains("*") || tempOrginalString.contains("/") ) {
                        break
                    }
                    calcType.append(String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]))
                    //如果有乘除法，将markByOrDevide标记为true
                    if String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]) == "*" || String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]) == "/"{
                        markByOrDevideContains = true
                    }
                    //取得从 xxx 到尾部的字符串
                    tempOrginalString = String(tempOrginalString.suffix(from: tempOrginalString.index(startIndex, offsetBy: splitString.lengthOfBytes(using: .utf8))))
                    tempOrginalString.removeFirst()
                    print("tempOrginalString = \(tempOrginalString)")
                }
                
                //如果以负数开头，第一个操作数变成负数
                if startsWithMinus {
                    calculationNum[0] = calculationNum[0] * -1 //将第一个数变成负数
                }
                //先算乘除，再算加减
                print("hallo")
                if markByOrDevideContains {
                    var byOrDevideIndex = 0
                    for calculation in calcType{
                        if calculation == "*" {
                            calculationNum[byOrDevideIndex] = calculationNum[byOrDevideIndex ] * calculationNum[byOrDevideIndex + 1]
                            calculationNum.remove(at: byOrDevideIndex + 1)
                            calcType.remove(at: byOrDevideIndex)
                            byOrDevideIndex -= 1 //因为移除了数组的值，需要将将index降低一个
                        }else if calculation == "/"{
                            if calculationNum[byOrDevideIndex + 1] == 0{
                                resultLabel.text = "0"
                                greyLayerPrompt.show(text: "算式错误，除数不能为0")
                                targetResult = 0
                                return
                            }else{
                                calculationNum[byOrDevideIndex] = calculationNum[byOrDevideIndex] / calculationNum[byOrDevideIndex + 1]
                            }
                            calcType.remove(at: byOrDevideIndex)
                            calculationNum.remove(at: byOrDevideIndex + 1)
                            byOrDevideIndex -= 1 //因为移除了数组的值，需要将将index降低一个
                        }
                        byOrDevideIndex += 1
                    }
                }
                //处理完算式中的乘除后，计算剩下的加减法
                //没有乘除法，直接顺序运算
                let rangeIndex = 0
                //   var tempCalculationNums = calculationNum
                for calculation in calcType{
                    let firstNum = calculationNum[rangeIndex]
                    let secondNum = calculationNum[rangeIndex + 1]
                    if calculation == "+" {
                        let tempResult = firstNum + secondNum
                        calculationNum.removeFirst()
                        calculationNum[0] = tempResult
                    }else{
                        let tempResult = firstNum - secondNum
                        calculationNum.removeFirst()
                        calculationNum[0] = tempResult
                    }
                }
                //计算完成
                resultLabel.text = "\(calculationNum[0])"
                targetResult = Int(calculationNum[0])
                opreationValue(with: targetResult)
                
                actionView.currentValueOnSliderTextField.text = quotePriceResult.text// resultLabel.text
            }
            
            
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(translationX: 0, y: 0)
                self.actionView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            self.removeFromSuperview()
            print("confirmKeyPressed")
        //            }
        case 13: // 等于
            print("equalKeyPressed")
            if !(currentText.contains("+") || currentText.contains("-") || currentText.contains("*") || currentText.contains("/")){
                quotePriceResult.text = "¥\(String(format: "%d", Double(currentText)!))"
                targetResult = Int(Double(currentText)!)
                opreationValue(with: targetResult)
                return
            }else{
                var calculationNum:[Double] = [] //存放操作数
                var numberSequence:[String] = []
                var startsWithMinus = false
                //如果算式的最后一位为运算符，则直接去掉
                if currentText.last == "+" || currentText.last == "-" || currentText.last == "*"  || currentText.last == "/" {
                    currentText.removeLast()
                }
                
                var tempOrginalString = currentText

                //如果以负数开头,记录一下,拆分操作数的时候先将第一个字符移除
                if currentText.first == "-" {
                    startsWithMinus = true
                    tempOrginalString.removeFirst()
                }
                
                //将操作数拆分开
                let subString1 = tempOrginalString.split(separator: "+")
                for tempString1 in subString1{
                    let subString2 = tempString1.split(separator: "-")
                    for tempString2 in subString2{
                        let subString3 = tempString2.split(separator: "*")
                        for tempString3 in subString3{
                            let subString4 = tempString3.split(separator: "/")
                            for tempString4 in subString4{
                                print(tempString4)
                                calculationNum.append(Double(tempString4)!)
                                numberSequence.append(String(tempString4))
                            }
                        }
                    }
                }
                
                //获取操作符
                var calcType:[String] = []
                //检测是否包含乘除法
                var markByOrDevideContains = false
                for splitString in numberSequence{
                    let startIndex = splitString.startIndex
                    let index = tempOrginalString.index(startIndex, offsetBy: splitString.lengthOfBytes(using: .utf8))
                   // 已经不包含运算符时，不继续拆分
                    if !(tempOrginalString.contains("+") || tempOrginalString.contains("-") || tempOrginalString.contains("*") || tempOrginalString.contains("/") ) {
                        break
                    }
                    calcType.append(String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]))
                    //如果有乘除法，将markByOrDevide标记为true
                    if String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]) == "*" || String(tempOrginalString[tempOrginalString.index(index, offsetBy: 0)]) == "/"{
                        markByOrDevideContains = true
                    }
                    //取得从 xxx 到尾部的字符串
                    tempOrginalString = String(tempOrginalString.suffix(from: tempOrginalString.index(startIndex, offsetBy: splitString.lengthOfBytes(using: .utf8))))
                    tempOrginalString.removeFirst()
                    print("tempOrginalString = \(tempOrginalString)")
                }
               
                //如果以负数开头，第一个操作数变成负数
                if startsWithMinus {
                    calculationNum[0] = calculationNum[0] * -1 //将第一个数变成负数
                }
                //先算乘除，再算加减
                print("hallo")
                if markByOrDevideContains {
                    var byOrDevideIndex = 0
                    for calculation in calcType{
                        if calculation == "*" {
                            calculationNum[byOrDevideIndex] = calculationNum[byOrDevideIndex ] * calculationNum[byOrDevideIndex + 1]
                            calculationNum.remove(at: byOrDevideIndex + 1)
                            calcType.remove(at: byOrDevideIndex)
                            byOrDevideIndex -= 1 //因为移除了数组的值，需要将将index降低一个
                        }else if calculation == "/"{
                            if calculationNum[byOrDevideIndex + 1] == 0{
                                resultLabel.text = "0"
                                greyLayerPrompt.show(text: "算式错误，除数不能为0")
                                targetResult = 0
                                return
                            }else{
                                calculationNum[byOrDevideIndex] = calculationNum[byOrDevideIndex] / calculationNum[byOrDevideIndex + 1]
                            }
                            calcType.remove(at: byOrDevideIndex)
                            calculationNum.remove(at: byOrDevideIndex + 1)
                            byOrDevideIndex -= 1 //因为移除了数组的值，需要将将index降低一个
                        }
                        byOrDevideIndex += 1
                    }
                }
                //处理完算式中的乘除后，计算剩下的加减法
                //没有乘除法，直接顺序运算
                let rangeIndex = 0
             //   var tempCalculationNums = calculationNum
                for calculation in calcType{
                    let firstNum = calculationNum[rangeIndex]
                    let secondNum = calculationNum[rangeIndex + 1]
                    if calculation == "+" {
                        let tempResult = firstNum + secondNum
                        calculationNum.removeFirst()
                        calculationNum[0] = tempResult
                    }else{
                        let tempResult = firstNum - secondNum
                        calculationNum.removeFirst()
                        calculationNum[0] = tempResult
                    }
                }
                //计算完成
                resultLabel.text = "\(calculationNum[0])"
                targetResult = Int(calculationNum[0])
                opreationValue(with: targetResult)
            }
        case 14: //加
            if currentText == ""{
                return
            }else if currentText.last == "+" || currentText.last == "-" || currentText.last == "*" || currentText.last == "/"{
                currentText.removeLast()
                
            }
            resultLabel.text = currentText + "+"
        case 15: //减
            //如果当前的字符串的最后一位已经是操作符，则先行移除最后一位操作符，然后再添加-号，
            //当然如果现在的操作数为0，那么允许输入负数的开头的
            if currentText.last == "+" || currentText.last == "-" || currentText.last == "*" || currentText.last == "/" || currentText == "0"{
                currentText.removeLast()
            }
            resultLabel.text = currentText + "-"
        case 16: //乘
            if currentText == ""{
                return
            }else if currentText.last == "+" || currentText.last == "-" || currentText.last == "*" || currentText.last == "/"{
                currentText.removeLast()
                
            }
            resultLabel.text = currentText + "*"
        case 17: //除
            if currentText == ""{
                return
            }else if currentText.last == "+" || currentText.last == "-" || currentText.last == "*" || currentText.last == "/"{
                currentText.removeLast()
            }
            resultLabel.text = currentText + "/"
        case 18: // AC
            resultLabel.text = "0"
        default:
            print("wrong key pressed")
        }
        
        // 计算文本长度以调整Label字体大小
        resultLabel.numberOfLines = 1
        resultLabel.frame =  CGRect(x: 15, y: 18, width: kWidth - 30, height: 40)
        
        if (resultLabel.text?.lengthOfBytes(using: .utf8))! <= 17{
            resultLabel.font = UIFont.systemFont(ofSize: 28)
        }else if (resultLabel.text?.lengthOfBytes(using: .utf8))! > 17 && (resultLabel.text?.lengthOfBytes(using: .utf8))! <= 28{
            resultLabel.font = UIFont.systemFont(ofSize: 18)
        }else if (resultLabel.text?.lengthOfBytes(using: .utf8))! > 28 && (resultLabel.text?.lengthOfBytes(using: .utf8))! < 38{
            resultLabel.font = UIFont.systemFont(ofSize: 14)
        }else{
            resultLabel.font = UIFont.systemFont(ofSize: 12)
            resultLabel.numberOfLines = 2
            resultLabel.frame =  CGRect(x: 15, y: 18, width: kWidth - 30, height: 40)
        }
    }
}
