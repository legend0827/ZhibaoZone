//
//  Extentsions.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

//随机头像列表
let avatars:NSDictionary = [
    "1":"default1",
    "2":"default2",
    "3":"default3",
    "4":"default4",
    "5":"default5",
    "6":"default6",
    "7":"default7",
    "8":"default8",
    "9":"default9",
    "10":"default10"
]

//屏幕宽度和高度
let kWidth = UIScreen.main.bounds.width
let kHight = UIScreen.main.bounds.height

//调整iPhone X高度
var heightChangeForiPhoneXFromTop:CGFloat = 0.0
var heightChangeForiPhoneXFromBottom:CGFloat = 0.0

//标题颜色枚举
enum titleColorsType{
    case red
    case white
    case black
    case lightGray
    case gray
    case darkGray
    case blue
}

//图标颜色枚举
enum iconColorsType{
    case red
    case lightRed
    case lightestRed
    case white
    case orange
    case darkGray
}

//线条颜色枚举
enum lineColorsType{
    case red
    case white
    case lightGray
    case gray
    case darkGray
}

//背景颜色枚举
enum backgroundColorsType{
    case red
    case lightRed
    case lightestgray
    case white
    case black
    case clear
}

//数据验证格式
enum validateType {
    case EMAIL
    case CNPHONENUM
    case CNIDCARD
}
//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}

//检索内容枚举
enum searchContentsType {
    case orderidOnly
    case orderidAndWangWangID
}

//订单分类举例：
enum orderListCategoryType{
    case allOrderCategory
    case notQuotePriceYetOrderCategory
    case alreadyQuotedOderCategory
    case waitForAcceptProduceOrderCategory
    case producingOrderCategory
    case waitForDesignCategory
    case waitForModifyCategory
    case DesigningCategory
    //case allOrderCategory
}

//操作类型：
enum actionType {
    case quotePrice
    case acceptDesign
    case acceptProduce
    case shippingProduct
    case designRequires
    case modifyRequires
}

//工艺属性类型：
enum produceType:String {
    case mold
    case produceStyle
    case color
    case taxRadio
    case size
}

//参数更改弹窗的类型
enum paraSourceType:String{
    case quotePrice
    case editOrder
}
//转接订单类型：
enum switchOrderType:String{
    case designingOrder
    case producingOrder
}
//头像外框形状类型
enum AvatarShape: String {
    /// 圆角正方形
    case AvatarShapeTypeSquareWithRadius = "Radius"
    /// 圆形
    case AvatarShapeTypeRound
    /// 正方形
    case AvatarShapeTypeSquare
    
}

//客户心理价溢价类型
enum quotePriceOverType: String {
    /// 圆角正方形
    case included
    /// 圆形
    case overBugget
}

enum taskListType:String{
    case waitToHandle
    case mineCreation
    case taskHistory
}

enum scanCodeActionType:String{
    case qrCode
    case barCode
    case barCodeForShipping
}
class Extentsions: NSObject {

}

//颜色拓展
extension UIColor {
    
    //rgb转Color值
    class func colorWithRgba(_ r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat)-> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        
    }
    
    //设置标题颜色
    class func titleColors(color:titleColorsType) ->UIColor{
        var tempColor = UIColor.colorWithRgba(232, g: 75, b: 76, a: 1.0)
        switch color {
        case .red:
            tempColor = UIColor.colorWithRgba(232, g: 75, b: 76, a: 1.0)
        case .white:
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .black:
            tempColor = UIColor.colorWithRgba(51, g: 51, b: 51, a: 1.0)
        case .lightGray:
            tempColor = UIColor.colorWithRgba(221, g: 221, b: 221, a: 1.0)
        case .gray:
            tempColor = UIColor.colorWithRgba(153, g: 153, b: 153, a: 1.0)
        case .darkGray:
            tempColor = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        case .blue:
            tempColor = UIColor.colorWithRgba(16, g: 142, b: 233, a: 1.0)
        default:
            tempColor = UIColor.colorWithRgba(68, g: 68, b: 68, a: 1.0)
        }
        return tempColor
    }
    
    //设置图标颜色
    class func iconColors(color:iconColorsType) ->UIColor{
        var tempColor =  UIColor.colorWithRgba(232, g: 75, b: 76, a: 1.0)
        switch color {
        case .red:
            tempColor = UIColor.colorWithRgba(232, g: 75, b: 76, a: 1.0)
        case .lightRed:
            tempColor = UIColor.colorWithRgba(255, g: 177, b: 177, a: 1.0)
        case .lightestRed:
            tempColor = UIColor.colorWithRgba(251, g: 242, b: 242, a: 1.0)
        case .white:
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .darkGray:
            tempColor = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        case .orange:
            tempColor = UIColor.colorWithRgba(255, g: 144, b: 23, a: 1.0)
        default:
            tempColor = UIColor.colorWithRgba(68, g: 68, b: 68, a: 1.0)
        }
        return tempColor
    }
    
    //设置线条颜色
    class func lineColors(color:lineColorsType) ->UIColor{
        var tempColor = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        switch color {
        case .red:
            tempColor = UIColor.colorWithRgba(236, g: 113, b: 113, a: 1.0)
        case .lightGray:
            tempColor = UIColor.colorWithRgba(221, g: 221, b: 221, a: 1.0)
        case .white:
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .darkGray:
            tempColor = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        case .gray:
            tempColor = UIColor.colorWithRgba(155, g: 155, b: 155, a: 1.0)
        default:
            tempColor = UIColor.colorWithRgba(102, g: 102, b: 102, a: 1.0)
        }
        return tempColor
    }
    
    //设置背景颜色
    class func backgroundColors(color:backgroundColorsType) ->UIColor{
        var tempColor = UIColor.colorWithRgba(245, g: 245, b: 245, a: 1.0)
        switch color {
        case .red:
            tempColor = UIColor.colorWithRgba(232, g: 75, b: 76, a: 1.0)
        case .lightRed:
            tempColor = UIColor.colorWithRgba(255, g: 246, b: 246, a: 1.0)
        case .lightestgray:
            tempColor = UIColor.colorWithRgba(245, g: 245, b: 245, a: 1.0)
        case .white:
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .black:
            tempColor = UIColor.colorWithRgba(18, g: 18, b: 18, a: 1.0)
        case .clear:
            tempColor = UIColor.clear
        default:
            tempColor = UIColor.colorWithRgba(245, g: 245, b: 245, a: 1.0)
        }
        return tempColor
    }
}

//检测设备属性
extension UIDevice{
    public func isX() ->Bool{
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}

extension String{
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat{
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = NSDictionary(object: font, forKey: kCTFontAttributeName as! NSCopying)
        //        let attributes:NSDictionary = NSDictionary(object:UIFont.systemFont(ofSize: 15),                                                   forKey: NSAttributedStringKey.font as NSCopying)
        //[NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any], context: nil)
        print("height in extension calc as \(rect.size.height)")
        return rect.size.height
    }
}
extension UITextView {
    //添加链接文本（链接为空时则表示普通文本）
    func appendLinkString(string:String, withURLString:String) {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText!)
        
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedStringKey.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedStringKey.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        print(appendString)
        print(attrString)
        //设置合并后的文本
        self.attributedText = attrString
    }
}

func getRandomName()->String{
    var randomCharactors = ""
    let repeatCount = 28//6 + arc4random()%120
    for i in 1 ... repeatCount{
        var num = 0 + arc4random()%9 // 自定义ASCII码范围从48到122
        //var num = 0 + arc4random()%61 // 自定义ASCII码范围从48到122
//        if num >= 0 && num <= 9{
//            num += 48
//        }else if (num >= 10 && num <= 35){
//            num += 55
//        }else if (num >= 36 && num <= 61){
//            num += 61
//        }
//        var randomCharactor = Character(UnicodeScalar(num)!)
        randomCharactors += "\(num)"
       // randomCharactors.append(num)
    }
    return randomCharactors
}


//颜色渐变
// UIView 渐变色 , UIView及其子类都可以使用，比如UIButton、UILabel等。
//
// Usage:
// myButton.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), [UIColor(hex: "#FF2619").cgColor, UIColor(hex: "#FF8030").cgColor])

public extension UIView {
    
    // MARK: 添加渐变色图层
    public func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        
        var gradientLayer: CAGradientLayer!
        
        removeGradientLayer()
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        self.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    public func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}


//设置状态栏颜色
func setStatusBarBackgroundColor(color : UIColor) {
    
    let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
    let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
    if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
        statusBar.backgroundColor = color
    }
    if color == UIColor.backgroundColors(color: .red) || color == UIColor.backgroundColors(color: .black) || color == UIColor.backgroundColors(color: .clear){
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 改成白色字体
    }else{
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default // 改成深色字体
    }
}

//设置状态栏显示或隐藏
func setStatusBarHiden(toHidden:Bool,ViewController:UIViewController){
    UIApplication.shared.isStatusBarHidden = toHidden
    UIView.animate(withDuration: 0.5) { () -> Void in
        ViewController.setNeedsStatusBarAppearanceUpdate()
    }
}
//创建毛玻璃效果
func showBlurEffect() -> UIVisualEffectView {
    //创建一个模糊效果
    let blurEffect = UIBlurEffect(style: .light)
    //创建一个承载模糊效果的视图
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:UIScreen.main.bounds.height )
//    let label = UILabel(frame: CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width - 20, height: 100))
//    label.text = text
//    label.font = UIFont.systemFont(ofSize: 30)
//    label.numberOfLines = 0
//    label.textAlignment = .center
//    label.textColor = UIColor.black
//    blurView.contentView.addSubview(label)
    // blurView.contentView.addSubview(closeBtn)
    return blurView
}

//创建头像方法
func createIcon(imageSize:CGFloat,locale:CGRect,iconShape:AvatarShape) -> UIView {
    let photo = UIImageView()
    //随机取头像
    let avatarIndex = Int(arc4random()%10+1)
    print(avatarIndex)
    let image = UIImage(named:avatars.value(forKey: String(avatarIndex)) as! String)
    
    photo.bounds = CGRect(x:(UIScreen.main.bounds.width - imageSize)/2,y:(UIScreen.main.bounds.height-imageSize)/2-122,width:imageSize,height:imageSize)
    photo.frame = locale
    
    // 设置图片的外围圆框*
    photo.layer.masksToBounds = true
    photo.layer.borderColor = UIColor.white.cgColor
    photo.layer.borderWidth = 3
    
    // 用设置圆角的方法设置圆形
    switch iconShape {
    case .AvatarShapeTypeSquare:
        photo.layer.cornerRadius =  0
    case .AvatarShapeTypeRound:
        photo.layer.cornerRadius =  photo.bounds.height/2
        photo.layer.borderColor = UIColor.colorWithRgba(240, g: 240, b: 240, a: 1).cgColor
    case .AvatarShapeTypeSquareWithRadius:
        var cornerRadius = photo.bounds.height/6
        if cornerRadius >= 10{
            cornerRadius = 10
        }
        photo.layer.cornerRadius =  cornerRadius
        
    default:
        var cornerRadius = photo.bounds.height/6
        if cornerRadius >= 10{
            cornerRadius = 10
        }
        photo.layer.cornerRadius =  cornerRadius
    }
    
    photo.image = image
    return photo
}

func calculateLabelHeightWithText(with text:String , labelWidth: CGFloat ,textFont:UIFont) -> CGFloat{ // 计算Label高度
    var size = CGRect()
    let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
    let attibute = [NSAttributedStringKey.font:textFont]
    size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attibute , context: nil);
    return size.size.height
}

