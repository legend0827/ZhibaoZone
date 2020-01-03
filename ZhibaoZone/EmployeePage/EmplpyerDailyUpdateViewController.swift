//
//  EmplpyerDailyUpdateViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/11/30.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import Alamofire

class EmplpyerDailyUpdateViewController: UIViewController {
    //存储下载下来的资料
    lazy var wellcomeLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 30+heightChangeForiPhoneXFromTop, width: 200, height: 40))
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 14)
        tempLabel.textAlignment = .left
        return tempLabel
    }()
    
    lazy var wordLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 50, width: 200, height: 40))
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 14)
        tempLabel.textAlignment = .left
        tempLabel.contentMode = .topLeft
        tempLabel.numberOfLines = 5
        return tempLabel
    }()
    
    lazy var imageAuthorLabel:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 50, width: 200, height: 22))
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 14)
        tempLabel.textAlignment = .right
        tempLabel.contentMode = .bottomRight
        return tempLabel
    }()
    
    var DailyDataDic:[NSDictionary] = [["word_from" : "《少有人走的路》",
                                       "vol" : "VOL.2246",
                                       "img_url" : "http://image.wufazhuce.com/FkTj2FaQWLPgNC4HGbgZ_AUKlvA2",
                                       "date" : "2018-11-30 06:00:00",
                                       "word" : "多数人认为勇气就是不害怕。现在让我来告诉你，不害怕不是勇气，它是某种脑损伤。勇气是尽管你感觉害怕，但仍能迎难而上；尽管你感觉痛苦，但仍能直接面对。",
                                       "id" : 4941,
                                       "img_author" : "赵延斌",
                                       "word_id" : 2276,
                                       "img_kind" : "插画",
        "url" : "http://m.wufazhuce.com/one/2276"]]
    
    lazy var dateLabelOfDay:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 150, width: 100, height: 40))
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont(name: "DINPro-Medium", size: 46)
        tempLabel.textAlignment = .center
        return tempLabel
    }()

    lazy var dateLabelOfMonth:UILabel = {
        let tempLabel = UILabel.init(frame: CGRect(x: 20, y: 195, width: 100, height: 40))
        tempLabel.textColor = UIColor.titleColors(color: .white)
        tempLabel.font = UIFont.systemFont(ofSize: 18)
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    
    
    lazy var dailyImageView:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 80 + heightChangeForiPhoneXFromTop, width: kWidth, height: kWidth))
        tempImageView.contentMode = .scaleToFill
        return tempImageView
    }()
    
    lazy var backgoundImageView:UIImageView = {
        let tempImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kHight, height: kHight))
        tempImageView.contentMode = .scaleToFill
        return tempImageView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setStatusBarBackgroundColor(color: UIColor.clear)
        setStatusBarHiden(toHidden: true, ViewController: self)
        
        setupUI()
        updatePage()
        //getDailyUpdate()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(color: UIColor.clear)
        setStatusBarHiden(toHidden: true, ViewController: self)
       // getDailyUpdate()
    }
    func setupUI(){
        let now = Date()
        
        //天
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = .current
        let dayOfToday = dateFormatter.string(from: now) //date(from: now)
        
        //月
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM"
        dateFormatter1.locale = .current
        let monthOfToday = dateFormatter1.string(from: now)
        //年
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy"
        dateFormatter2.locale = .current
        let yearOfToday = dateFormatter2.string(from: now)
        
        dateLabelOfDay.text = dayOfToday
        dateLabelOfMonth.text = monthOfToday + ". " + yearOfToday
        
        dailyImageView.image = UIImage(named: "dailyupdatedefaultimg")
        self.view.addSubview(backgoundImageView)
        let grayLayer = showBlurEffect()
        self.view.addSubview(grayLayer)
        let whiteBg = UIView.init(frame: CGRect(x: 0, y: 0, width: kWidth, height: kHight))
        whiteBg.backgroundColor = UIColor.backgroundColors(color: .white)
        whiteBg.alpha = 0.3
        
        self.view.addSubview(whiteBg)
        
        wordLabel.frame = CGRect(x: 20, y: dailyImageView.frame.maxY + 10, width: kWidth - 40, height: 120)
        imageAuthorLabel.frame = CGRect(x: kWidth - 200, y: dailyImageView.frame.maxY - 30, width: 180, height: 20)
        self.view.addSubview(dailyImageView)
        self.view.addSubview(dateLabelOfDay)
        self.view.addSubview(dateLabelOfMonth)
        self.view.addSubview(wellcomeLabel)
        self.view.addSubview(wordLabel)
        self.view.addSubview(imageAuthorLabel)
    }
    func updatePage(){
        print("updating page")
        let imageURLString = DailyDataDic[0].value(forKey: "img_url") as! String
        let url = URL(string: imageURLString)!
        do{
            let data = try Data.init(contentsOf: url)
            let oImage = UIImage.gif(data:data)
            dailyImageView.image = oImage
            backgoundImageView.image = oImage
        }catch{
            print("download Image Error")
        }
        
        //显示今日话语
        let words = DailyDataDic[0].value(forKey: "word") as! String
        wordLabel.text = words
        
        //漫画作者
        let author = DailyDataDic[0].value(forKey: "img_author") as! String
        imageAuthorLabel.text = "插画by: \(author)"
        
        //根据时间显示欢迎标签
        let now = Date()
        
        //天
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = .current
        let dayOfToday = dateFormatter.string(from: now) //date(from: now)
        
        //月
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM"
        dateFormatter1.locale = .current
        let monthOfToday = dateFormatter1.string(from: now)
        //年
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy"
        dateFormatter2.locale = .current
        let yearOfToday = dateFormatter2.string(from: now)
        //时间
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "HH"
        dateFormatter3.locale = .current
        let hourOfNow = dateFormatter3.string(from: now)
        
        dateLabelOfDay.text = dayOfToday
        dateLabelOfMonth.text = monthOfToday + ". " + yearOfToday
        
        let userinfo = getCurrentUserInfo()
        let userNickName = userinfo.value(forKey: "nikename") as! String
        
        switch hourOfNow {
        case "00","01","02","03","04","05":
            let orignalText = NSMutableAttributedString(string: "\(userNickName)   夜深了,早点休息")
            let range = orignalText.string.range(of: userNickName)
            let nsRange = orignalText.string.nsRange(from: range!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 26)], range: nsRange)
            
            wellcomeLabel.attributedText = orignalText
            //凌晨
        case "06","07","08","09","10","11":
        //早上
            let orignalText = NSMutableAttributedString(string: "\(userNickName)   早上好!")
            let range = orignalText.string.range(of: userNickName)
            let nsRange = orignalText.string.nsRange(from: range!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 26)], range: nsRange)
            
            wellcomeLabel.attributedText = orignalText
        case "12","13","14","15","16","17":
        //下午
            let orignalText = NSMutableAttributedString(string: "\(userNickName)   下午好!")
            let range = orignalText.string.range(of: userNickName)
            let nsRange = orignalText.string.nsRange(from: range!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 26)], range: nsRange)
            
            wellcomeLabel.attributedText = orignalText
        case "18","19","20","21","22","23":
            let orignalText = NSMutableAttributedString(string: "\(userNickName)   晚上好!")
            let range = orignalText.string.range(of: userNickName)
            let nsRange = orignalText.string.nsRange(from: range!)
            orignalText.addAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 26)], range: nsRange)
            
            wellcomeLabel.attributedText = orignalText
        //晚上
        default:
            wellcomeLabel.text = "\(userNickName)   夜深了，早点休息"
        }
        
    }
    func getDailyUpdate(){
        //获取列表
        let plistFile = Bundle.main.path(forResource: "config", ofType: "plist")
        let data:NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistFile!)!
        let apiAddresses:NSDictionary = data.value(forKey: "apiAddress") as! NSDictionary
        #if DEBUG
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "dailyUpdateAPI") as! String
        #else
        let newTaskUpdateURL:String = apiAddresses.value(forKey: "dailyUpdateAPI") as! String
        #endif
        //定义请求参数
        let params:NSMutableDictionary = NSMutableDictionary()
      //  var header:HTTPHeaders = NSMutableDictionary() as! HTTPHeaders
        //  params["userId"] =  _userId// userID
        // params["orderId"] =  OrderID
        params["TransCode"] =  "030112"
        //  params["roleType"] = _roleType// roletype
        params["OpenId"] = "123456789"// token
      //  params["Body"] = ""
        
        _ = Alamofire.request(newTaskUpdateURL,method:.post, parameters:params as? [String:AnyObject],encoding: URLEncoding.default) .responseJSON{
            (responseObject) in
            switch responseObject.result.isSuccess{
            case true:
                if  let value = responseObject.result.value{
                    let json = JSON(value)
                    let errorCode = json["ErrCode"].string!
                    if errorCode == "OK"{
                        print(json)
                        self.DailyDataDic.removeAll()
                        for item in json["Body"].array!{
                            self.DailyDataDic.append(item.dictionaryObject! as NSDictionary)
                        }
                        self.updatePage()
                    }else{
                        print("获取今日图片失败了")
                    }
                    
                }
            case false:
                greyLayerPrompt.show(text: "服务器异常，获取订单信息失败")
                print("get order detail failed")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
