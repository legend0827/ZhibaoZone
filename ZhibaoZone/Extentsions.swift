//
//  Extentsions.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire


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
    case lightOrange
}

//图标颜色枚举
enum iconColorsType{
    case red
    case lightRed
    case lightestRed
    case white
    case orange
    case darkGray
    case lightOrange
}

//线条颜色枚举
enum lineColorsType{
    case red
    case white
    case grayLevel1
    case grayLevel2
    case grayLevel3
    case grayLevel4
    case grayLevel5
    case lightOrange
}

//背景颜色枚举
enum backgroundColorsType{
    case red
    case lightRed
    case lightestGray
    case white
    case black
    case clear
    case purple
    case lightOrange
}

//数据验证格式
enum validateType {
    case Email
    case CNPhoneNum
    case CNIDCard
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
    case customerConfirmedCategory
    case bargainNotDealedCategory
    case bargainDealedCategory
    case designningCategory
    case waitForConfirmDesignCategory
    case allFactoryNotQuoteCategory
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
    case dealBargain
    case contactInfos
}

//标题颜色枚举
enum filterType{
    case timeInterval
    case shop
    case goodsClass
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

enum KVAnimationType:String{
    case Float
    case Int
}

enum unitType:String{
    case perSecond
    case perMinite
    case perHour
    case PerDay
}

enum seperateType:String{
    case byDay
    case byMonth
    case byYear
}

enum selectionModelType:String{
    case single
    case multiple
}

enum statisticCategoryListType:String{
    case newCreateOrder// 新建订单
    case dealOrder//成交订单
    case bargainingOrder//议价中订单
    case waitForDesignOrder//待设计
    case designingOrder//设计中
    case designComfirmed//已定稿
    case waitForQuotePrice//待报价
    case waitForBargain//待议价
    case waitForBid//待竞价
    case waitForProduce//待生产
    case producingOrder//生产中
    case waitForDelivery//待发货
}
enum parameterSettingType:String{
    case CSCreateOrderSetting
    case MGFollowOrderSetting
    case DSDistributeOrderSetting
    case DSHangUpSetting
    case DSDesignFeeSetting
    case AutoPricingSetting
}

class Extentsions: NSObject {

}

//通过TableViewCell查找父级TableView
extension UITableViewCell{
    //返回cell所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview}){
            if let tableView = view as? UITableView{
                return tableView
            }else{
                print(view)
            }
        }
        return nil
    }
}

extension UIView{

    func getFirstViewController()->UIViewController?{

        for view in sequence(first: self.superview, next: {$0?.superview}){

            if let responder = view?.next{

                if responder.isKind(of: UIViewController.self){

                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
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
        case .lightOrange:
            tempColor = UIColor.colorWithRgba(255, g: 120, b: 83, a: 1.0)
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
        case .lightOrange:
            tempColor = UIColor.colorWithRgba(255, g: 120, b: 83, a: 1.0)
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
        case .white:
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .grayLevel1:
            tempColor = UIColor.colorWithRgba(204, g: 204, b: 204, a: 1.0)
        case .grayLevel2:
            tempColor = UIColor.colorWithRgba(232, g: 232, b: 232, a: 1.0)
        case .grayLevel3:
            tempColor = UIColor.colorWithRgba(242, g: 242, b: 242, a: 1.0)
        case .grayLevel4:
            tempColor = UIColor.colorWithRgba(248, g: 248, b: 248, a: 1.0)
        case .grayLevel5:
            tempColor = UIColor.colorWithRgba(250, g: 251, b: 251, a: 1.0)
        case .lightOrange:
            tempColor = UIColor.colorWithRgba(255, g: 120, b: 83, a: 1.0)
        default:
            tempColor = UIColor.colorWithRgba(204, g: 204, b: 204, a: 1.0)
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
        case .lightestGray:
            tempColor = UIColor.colorWithRgba(250, g: 251, b: 251, a: 1.0)
        case .white:
          //  tempColor = UIColor.colorWithRgba(254 , g: 120, b: 83, a: 1.0)
            tempColor = UIColor.colorWithRgba(255, g: 255, b: 255, a: 1.0)
        case .black:
            tempColor = UIColor.colorWithRgba(18, g: 18, b: 18, a: 1.0)
        case .clear:
            tempColor = UIColor.clear
        case .purple:
            tempColor = UIColor.colorWithRgba(111, g: 70, b: 138, a: 1.0)
        case .lightOrange:
            tempColor = UIColor.colorWithRgba(255, g: 120, b: 83, a: 1.0)
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
    if #available(iOS 13.0, *){
//        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
//        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = color
//        }
        if color == UIColor.backgroundColors(color: .red) || color == UIColor.backgroundColors(color: .black) { //|| color == UIColor.backgroundColors(color: .clear)
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 改成白色字体
        }else{
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default // 改成深色字体
        }
    }else{
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
        if color == UIColor.backgroundColors(color: .red) || color == UIColor.backgroundColors(color: .black) { //|| color == UIColor.backgroundColors(color: .clear)
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent // 改成白色字体
        }else{
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default // 改成深色字体
        }
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

//通过id查找值
func findValue(key:String,keyValue:String,In DicArray:NSArray,By keyName:String)->String{
    
    for item in DicArray{
        if (item as! NSDictionary).value(forKey: key) as? Int != nil && (item as! NSDictionary).value(forKey: key) as? Int == Int(keyValue){
            return (item as! NSDictionary).value(forKey: keyName) as! String
        }
    }
    return ""
}


func calculateLabelHeightWithText(with text:String , labelWidth: CGFloat ,textFont:UIFont) -> CGFloat{ // 计算Label高度
    var size = CGRect()
    let size2 = CGSize(width: labelWidth, height: 0)//设置label的最大宽度
    let attibute = [NSAttributedStringKey.font:textFont]
    size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attibute , context: nil);
    return size.size.height
}

func compressionImage(with image:UIImage) -> NSData{
    print("Original Size \(image.size)")
    //实现等比缩放
    let hfactor = image.size.width / kScreenW
    let vfactor = image.size.width / kScreenH
    let factor = fmax(hfactor, vfactor)
    //画布大小
    let newWidth:CGFloat = image.size.width / factor
    let newHeight:CGFloat = image.size.height / factor
    let newSize = CGSize(width: newWidth, height: newHeight)
    
    UIGraphicsBeginImageContext(newSize)
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    //图像压缩
    let newImageData = UIImageJPEGRepresentation(newImage!, 0.5)
    print("Compressed Size \(newImage?.size)")
    print("Compressed Data\(newImageData?.description)")
    return newImageData! as NSData
}

func clearImageCache(){
    
}

func increamingNumberAnimation(from startNum:Float, to endNum:Float, on Label:UILabel){
    let repeatCount = 10
    let repeatRate = 0.001 / (Double(startNum) - Double(endNum))
    Label.text = "\(startNum)"
    
}

func getSystemParasFromPlist() ->[AnyObject]{
    //从plist获取CheckListItem
    var systemParam:[AnyObject] = []
    let plistOfSystemParas = Bundle.main.path(forResource: "config_systemParas", ofType: "plist")
    let tempParaItems = NSArray.init(contentsOfFile: plistOfSystemParas!)
    systemParam.removeAll()
    
    for i in tempParaItems!{
        systemParam.append(i as AnyObject)
    }
    
    return systemParam
}

func getEndDateTimeOfToday() -> (TimeInterval:TimeInterval,String:String){
    
    let now = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = .current
    let dateOfToday = dateFormatter.string(from: now) //date(from: now)
    
//    let calendar = NSCalendar.init(identifier: .chinese)
//    let componets = calendar?.components(in: .current, from: now as Date)
//    let year = componets?.year as! Int
//    let month = componets?.month as! Int
//    let day = componets?.day as! Int
    
    let endTimeOfToday = "23:59:59"
    
    let endTimeString = dateOfToday + " " + endTimeOfToday
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
    let endDateTime = formatter.date(from: endTimeString)
    let endTime = endDateTime?.timeIntervalSince1970
    
    return (endTime!,endTimeString)
}

func getStartDateTimeOfToday() -> (TimeInterval:TimeInterval,String:String){
    
    let now = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = .current
    let dateOfToday = dateFormatter.string(from: now) //date(from: now)
    
    //    let calendar = NSCalendar.init(identifier: .chinese)
    //    let componets = calendar?.components(in: .current, from: now as Date)
    //    let year = componets?.year as! Int
    //    let month = componets?.month as! Int
    //    let day = componets?.day as! Int
    
    let endTimeOfToday = "00:00:00"
    
    let endTimeString = dateOfToday + " " + endTimeOfToday
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
    let endDateTime = formatter.date(from: endTimeString)
    let endTime = endDateTime?.timeIntervalSince1970
    
    return (endTime!,endTimeString)// endTime!
}

func getDateTimeStamp(of dateString:String) -> TimeInterval{
//
//    let now = NSDate()
//
//    let calendar = NSCalendar.init(identifier: .chinese)
//    let componets = calendar?.components(in: .current, from: now as Date)
//    let year = componets?.year
//    let month = componets?.month
//    let day = componets?.day
//
//    let endTimeOfToday = "23:59:59"
//
//    let endTimeString = "\(year)-\(month)-\(day) \(endTimeOfToday)"
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
    let endDateTime = formatter.date(from: dateString)
    let endTime = endDateTime?.timeIntervalSince1970
    
    return endTime!
}
// MARK: 前一天的时间
// nowDay 是传入的需要计算的日期
 func getLastDay(_ nowDay: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // 先把传入的时间转为 date
    let date = dateFormatter.date(from: nowDay)
    let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
    //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
    
    let lastDate = date?.addingTimeInterval(lastTime)
    let lastDay = dateFormatter.string(from: lastDate!)
    return lastDay
}

// MARK: 获取某一天所在的周一和周日
func getWeekTime(_ dateStr: String) -> (Monday:String,Sunday:String) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let nowDate = dateFormatter.date(from: dateStr)
    let calendar = Calendar.current
    let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate!)
    
    // 获取今天是周几
    let weekDay = comp.weekday
    // 获取几天是几号
    let day = comp.day
    
    // 计算当前日期和本周的星期一和星期天相差天数
    var firstDiff: Int
    var lastDiff: Int
    // weekDay = 1;
    if (weekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    } else {
        firstDiff = calendar.firstWeekday - weekDay! + 1
        lastDiff = 8 - weekDay!
    }
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    var firstDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate!)
    firstDayComp.day = day! + firstDiff
    let firstDayOfWeek = calendar.date(from: firstDayComp)
    var lastDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate!)
    lastDayComp.day = day! + lastDiff
    let lastDayOfWeek = calendar.date(from: lastDayComp)
    
    let firstDay = dateFormatter.string(from: firstDayOfWeek!)
    let lastDay = dateFormatter.string(from: lastDayOfWeek!)
    let weekArr = (firstDay, lastDay)
    
    return weekArr
}
func dateStringToTimeInterval(_ dateString:String) -> TimeInterval{
    //var timeInterval:TimeInterval?
    let datefmatter = DateFormatter()
    datefmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = datefmatter.date(from: dateString)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateStr:Int = Int(dateStamp)
    return dateStamp
}
// MARK: 当月开始日期
// nowDay 为传入需要计算的日期
func startOfCurrentMonth(_ nowDay: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let nowDayDate = dateFormatter.date(from: nowDay)
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: nowDayDate!)
    let startOfMonth = calendar.date(from: components)
    

    
    let day = dateFormatter.string(from: startOfMonth!)
    return day
}
// MARK: 当月结束日期
func endOfCurrentMonth(_ nowDay: String, returnEndTime:Bool = false) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let nowDayDate = dateFormatter.date(from: nowDay)
    
    let calendar = Calendar.current
    var components = DateComponents()
    components.month = 1
    if returnEndTime {
        components.second = -1
    } else {
        components.day = -1
    }
    //startOfCurrentMonth
    let currentMonth = calendar.dateComponents([.year, .month], from: nowDayDate!)
    let startOfMonth = calendar.date(from: currentMonth)
    let endOfMonth = calendar.date(byAdding: components, to: startOfMonth!)
    
    let day = dateFormatter.string(from: endOfMonth!)
    return day
}


func dateAheadToday(before num:Int, getStart isStart:Bool,UnitType unitType:seperateType) -> (TimeInterval:TimeInterval,String:String){
    let now = Date()
    
    let nowTimeStamp = now.timeIntervalSince1970
    
    let dateFormatterForDay = DateFormatter()
    dateFormatterForDay.dateFormat = "yyyy-MM-dd"
    dateFormatterForDay.locale = .current
    let dateOfToday = dateFormatterForDay.string(from: now) //date(from: now)
    
    //    let calendar = NSCalendar.init(identifier: .chinese)
    //    let componets = calendar?.components(in: .current, from: now as Date)
    //    let year = componets?.year as! Int
    //    let month = componets?.month as! Int
    //    let day = componets?.day as! Int
    
    let startTimeOfToday = "00:00:00"
    let endTimeOfToday = "23:59:59"
    
    let startTimeString = dateOfToday + " " + startTimeOfToday
    let endTimeString = dateOfToday + " " + endTimeOfToday
    let formatter = DateFormatter()
    formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
    let endDateTime = formatter.date(from: endTimeString)
    let startDateTime = formatter.date(from: startTimeString)
    let endTime = endDateTime?.timeIntervalSince1970
    let startTime = startDateTime?.timeIntervalSince1970
    
    var timeInterval = num * 24 * 60 * 60
    var targetTimeStamp:Int = 0
    var targetString:String = ""
    if isStart{
        targetTimeStamp = Int(startTime!) - timeInterval
        targetString = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(targetTimeStamp))) // startTimeString
    }else{
        targetTimeStamp = Int(endTime!) - timeInterval
        targetString = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(targetTimeStamp)))
    }
    
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter1.locale = .current
    let date = Date(timeIntervalSince1970: TimeInterval(targetTimeStamp))
    let dateString = dateFormatter1.string(from: date)
    
    return (TimeInterval(targetTimeStamp),targetString)
}

func dateAheadNow(before num:Int, countAs unitType: unitType) -> (TimeInterval:TimeInterval,String:String){
    let now = Date()
    
    let nowTimeStamp = now.timeIntervalSince1970
    var timeInterval = 0
    switch unitType {
    case .perSecond:
        timeInterval = num
    case .perMinite:
        timeInterval = num * 60
    case .perHour:
        timeInterval = num * 60 * 60
    case .PerDay:
        timeInterval = num * 24 * 60 * 60
    }
    
    let targetTimeStamp = Int(nowTimeStamp) - timeInterval
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = .current
    let date = Date(timeIntervalSince1970: TimeInterval(targetTimeStamp))
    let dateString = dateFormatter.string(from: date)
    
    return (TimeInterval(targetTimeStamp),dateString)
    //        let formatter = DateFormatter()
    //        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
    //        let endDateTime = formatter.date(from: endTimeString)
    //        let endTime = endDateTime?.timeIntervalSince1970
}

// MARK : 我们要进行类的扩展
extension String  {
    
    // MARK : 添加千分位的函数实现
    func addMicrometerLevel() -> String {
        // 判断传入参数是否有值
        if self.characters.count != 0 {
            /**
             创建两个变量
             integerPart : 传入参数的整数部分
             decimalPart : 传入参数的小数部分
             */
            var integerPart:String?
            var decimalPart = String.init()
            
            // 先将传入的参数整体赋值给整数部分
            integerPart =  self
            // 然后再判断是否含有小数点(分割出整数和小数部分)
            if self.contains(".") {
                let segmentationArray = self.components(separatedBy: ".")
                integerPart = segmentationArray.first
                decimalPart = segmentationArray.last!
            }
            
            /**
             创建临时存放余数的可变数组
             */
            let remainderMutableArray = NSMutableArray.init(capacity: 0)
            // 创建一个临时存储商的变量
            var discussValue:Int32 = 0
            
            /**
             对传入参数的整数部分进行千分拆分
             */
            repeat {
                let tempValue = integerPart! as NSString
                // 获取商
                discussValue = tempValue.intValue / 1000
                // 获取余数
                let remainderValue = tempValue.intValue % 1000
                // 将余数一字符串的形式添加到可变数组里面
                let remainderStr = String.init(format: "%d", remainderValue)
                remainderMutableArray.insert(remainderStr, at: 0)
                // 将商重新复制
                integerPart = String.init(format: "%d", discussValue)
            } while discussValue>0
            
            // 创建一个临时存储余数数组里的对象拼接起来的对象
            var tempString = String.init()
            
            // 根据传入参数的小数部分是否存在，是拼接“.” 还是不拼接""
            let lastKey = (decimalPart.characters.count == 0 ? "":".")
            /**
             获取余数组里的余数
             */
            for i in 0..<remainderMutableArray.count {
                // 判断余数数组是否遍历到最后一位
                let  param = (i != remainderMutableArray.count-1 ?",":lastKey)
                tempString = tempString + String.init(format: "%@%@", remainderMutableArray[i] as! String,param)
            }
            //  清楚一些数据
            integerPart = nil
            remainderMutableArray.removeAllObjects()
            // 最后返回整数和小数的合并
            return tempString as String + decimalPart
        }
        return self
    }
    
    // MARK : 获取字符串的长度
    func length() -> Int {
        /**
         另一种方法：
         let tempStr = self as NSString
         return tempStr.length
         */
        return self.characters.count
    }
}

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!),length: utf16.distance(from: from!, to: to!))
    }
    
}

//extension UIApplication {
//    var statusBarUIView: UIView? {
//        if #available(iOS 13.0, *) {
//            let tag = 38482458385
//            if let statusBar = self.keyWindow?.viewWithTag(tag) {
//                return statusBar
//            } else {
//                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
//                statusBarView.tag = tag
//
//                self.keyWindow?.addSubview(statusBarView)
//                return statusBarView
//            }
//        } else {
//            if responds(to: Selector(("statusBar"))) {
//                return value(forKey: "statusBar") as? UIView
//            }
//        }
//        return nil
//    }
//}

func transferTimeToString(with updateTime:TimeInterval) -> String{
    var days = 0
    var hrs = 0
    var mins = 0
    var tranferedString = "0分钟"
    // print("deadLine to Int\(Int(timeInterval))")
    
    let now = Date()
    
    
    let nowInterval = Int(now.timeIntervalSince1970)
    let timeInterval = Double(nowInterval) - updateTime/1000
    if timeInterval < 60{
        mins = 0
        tranferedString = "\(mins)分钟"
    }else{
        //> 60秒时
        mins = (Int(timeInterval)/60)%60
        if Int(timeInterval)/60 < 60{
            tranferedString = "\(mins)分钟"
        }else {
            // > 60分钟时
            hrs = Int(timeInterval)/60/60%24
            if Int(timeInterval)/60 < 60*24{
                //< 60*24分钟
                tranferedString = "\(hrs)小时 \(mins)分钟"
            }else{
                //60*24分钟
                days = Int(timeInterval)/60/60/24
                tranferedString = "\(days)天 \(hrs)小时 \(mins)分钟"
            }
        }
    }
    return tranferedString
}

func LogoutMission(viewControler:UIViewController){
    //跳转页面
    let LoginVC =  LoginViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    LoginVC.isAutoLoginEnabled = false
    let userinfos = getCurrentUserInfo()
    let userID = userinfos.value(forKey: "userid") as! String
    
    //变更devicetoken
    let deviceToken = UserDefaults.standard.object(forKey: "myDeviceToken")
    if deviceToken != nil{
        updatesDeviceToken(withDeviceToken: deviceToken as! String, user: userID, toBind: false)
    }

    logoutFromServer()

    appDelegate.window?.rootViewController = LoginVC
    viewControler.dismiss(animated: true, completion: nil)
}

func autoLogin(viewControler:UIViewController){
        let userinfo = getCurrentUserInfo()
        let username = userinfo.value(forKey: "username") as! String
        let password = userinfo.value(forKey: "password") as! String
    
    
        let loginUser = User()
        let hub = viewControler.pleaseWait()
        loginUser.isToAutoLogin = true
        loginUser.Login(username: username, password: password,view:viewControler,hub:hub)
}

//正则表达式验证输入有效性 邮箱 中国电话 身份证号
func stringValidator(with validateType:validateType, string: String) -> Bool {
    var validateRegex = ""
    if validateType == .Email{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        validateRegex = emailRegex
    }else if validateType == .CNPhoneNum{
        let ChinaPhoneRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
        validateRegex = ChinaPhoneRegex
    }else if validateType == .CNIDCard{
        let ChinaIDCardRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        validateRegex = ChinaIDCardRegex
    }else{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        validateRegex = emailRegex
    }
    let RegexTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", validateRegex)
    return RegexTest.evaluate(with: string)
}

func logoutFromServer(){
    
    let userinfos = getCurrentUserInfo()
    let token = userinfos.value(forKey: "token") as! String
    
    let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
    let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
    let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
    #if DEBUG
    let requstURL:String = apiAddresses.value(forKey: "logoutAPIDebug") as! String
    #else
    let requstURL:String = apiAddresses.value(forKey: "logoutAPI") as! String
    #endif
    //定义请求参数
    let params:NSMutableDictionary = NSMutableDictionary()
    var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
    //从datacore获取用户数据
    
    header["token"] = token
    params["onlineStatus"] = 0 //用户在线状态（0 离线，1在线，2 挂起）. Size: 0
    
    _ = Alamofire.request(requstURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default,headers:header) .responseJSON{
        (responseObject) in
        switch responseObject.result.isSuccess{
        case true:
            if  let value = responseObject.result.value{
                let json = JSON(value)
                let statusCode = json["code"].int!
                if statusCode == 200{
                    print("登出成功")
                    
                }else if statusCode == 99999 || statusCode == 99998{
                    print("token过期")
                    
                }else{
                    print("登出失败")
                }
            }
        case false:
            print("处理失败")
        }
    }
    
}
