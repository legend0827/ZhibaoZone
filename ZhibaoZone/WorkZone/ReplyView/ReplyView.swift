//
//  replyView.swift
//  ZhibaoZone
//
//  Created by Kevin on 01/04/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

//回复可携带附件
enum ReplyAttachmentsType {
    case replyWithAttach
    case replyWithoutAttach
}

//回复带不带回复给昵称
enum ReplyToReceiverType {
    case replyWithoutReceiver
    case replyWithReceiver
}




class ReplyView: UIView {
 
//   // var fatherVC = TaskDetailViewController()
//    lazy var fatherVC:UIViewController = {
//       let tempVC =  TaskDetailViewController()
//        return tempVC
//    }()
    
//    var AttachPicArrayInRelay:[UIImageView] = []
//    
//    //回复页面的TableView
//    lazy var replyTaskTableView:UITableView = {
//        //y = 58调好的
//        var tempTableView = UITableView(frame: CGRect(x: 0, y: 58, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55), style: UITableViewStyle.grouped)
//        tempTableView.delegate = self
//        tempTableView.dataSource = self
//        tempTableView.backgroundColor = UIColor.green
//        tempTableView.isScrollEnabled = true
//        tempTableView.tableHeaderView = UITableViewHeaderFooterView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat.leastNormalMagnitude))
//        tempTableView.estimatedRowHeight = 100
//        tempTableView.rowHeight = UITableViewAutomaticDimension
//        return tempTableView
//    }()
//    
//    //回复输入框
//    lazy var replyTextView:UITextView = {
//        let tempTextView:UITextView = UITextView.init(frame: CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 410))) // 305
//        //tempTextView.delegate = self as! UITextViewDelegate
//        tempTextView.isScrollEnabled = true
//        
//        return tempTextView
//    }()
//    
//    
//    var replyTaskViewTitle:UILabel = UILabel.init(frame:CGRect(x: UIScreen.main.bounds.width/2 - 44, y: 13, width: 88, height: 30))
//    let placeholderLabel = UILabel.init() // placeholderLabel是全局属性
//    let textNumberLimit:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width - 115, y: UIScreen.main.bounds.height - 410, width: 100, height: 40))
//    
//    let progressBtn = KVProgressBar.init(frame: CGRect(x: UIScreen.main.bounds.width - 50, y: 10, width: 30, height: 30))
//    var iPhoneXHeightChange:CGFloat = 35.0
//    //回复附件
//    var attachmentPicCountInReply = 0
//    var AttachmentPicsInReply:[UIImage] = []
//    var AttachmentTypesInReply:[String] = []
//    var previewURLsInReply:[URL] = []
//    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.frame =  CGRect(x: 0, y: UIScreen.main.bounds.height , width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 35)
//        self.backgroundColor = UIColor.white
//        self.layer.cornerRadius = 8
//        self.addSubview(replyTaskTableView)
//        
//        placeholderLabel.frame = CGRect(x:5 , y:5, width:200, height:20)
//        placeholderLabel.font = UIFont.systemFont(ofSize: 13)
//        self.replyTextView.addSubview(placeholderLabel)
//        placeholderLabel.textColor = UIColor.colorWithRgba(72, g: 82, b: 93, a: 1.0)
//        self.replyTextView.becomeFirstResponder()
//        textNumberLimit.text = "\(replyTextView.text.count)\\300"
//        
//        textNumberLimit.textAlignment = .right
//        textNumberLimit.font = UIFont.systemFont(ofSize: 13)
//        textNumberLimit.textColor = UIColor.gray
//        self.addSubview(textNumberLimit)
//        if UIDevice.current.isX(){
//            iPhoneXHeightChange = 35.0
//        }else{
//            iPhoneXHeightChange = 0.0
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    //初始化值
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        
////        if self.viewWithTag(10) != nil{
////            self.viewWithTag(10)?.removeFromSuperview()
////        }
////        if self.viewWithTag(11) != nil{
////            self.viewWithTag(11)?.removeFromSuperview()
////        }
////        if self.viewWithTag(12) != nil{
////            self.viewWithTag(12)?.removeFromSuperview()
////        }
//        
//       
//        
//        if attachmentPicCountInReply == 0 {
//            replyTextView.frame = CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 410 + iPhoneXHeightChange))
//            textNumberLimit.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY+10, width: 100, height: 40)
//            return UIScreen.main.bounds.height - 345
//
//        }else{
//            replyTextView.frame = CGRect(x: 5, y: 5, width: Int(UIScreen.main.bounds.width - 10), height: Int(UIScreen.main.bounds.height - 480 + iPhoneXHeightChange))
//            textNumberLimit.frame = CGRect(x: UIScreen.main.bounds.width - 115, y: replyTextView.frame.maxY+10, width: 100, height: 40)
//            
//            
//           
//        }
//        return UIScreen.main.bounds.height - 345
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55 - 300))// ReplyTableViewCell.customCell(tableView: replyTaskTableView)
//        cell.backgroundColor = UIColor.white//UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
//        cell.selectionStyle = .none
//        
//        //上传图片
//        progressBtn.isHidden = true
//        progressBtn.backgroundColor = UIColor.white
//        cell.addSubview(progressBtn)
//        
//        cell.addSubview(replyTextView)
//        
////
////        if self.viewWithTag(10) != nil{
////            self.viewWithTag(10)?.removeFromSuperview()
////        }
////        if self.viewWithTag(11) != nil{
////            self.viewWithTag(11)?.removeFromSuperview()
////        }
////        if self.viewWithTag(12) != nil{
////            self.viewWithTag(12)?.removeFromSuperview()
////        }
////
////        AttachPicArrayInRelay.removeAll()
////        //修改导航栏返回按钮文字
//        for i in 0..<3{
//            let AttachPic = UIImageView()
//            AttachPic.frame = CGRect(x: 15+i*70, y: Int(replyTextView.frame.maxY + 10), width: 60, height: 60)
//            AttachPic.tag = i+10
//            AttachPic.contentMode = .scaleAspectFill
//            AttachPic.clipsToBounds = true
//            AttachPic.image = UIImage(named:"defualt-design-pic-loading")
//            cell.contentView.addSubview(AttachPic)
//            AttachPicArrayInRelay.append(AttachPic)
//        }
//        if attachmentPicCountInReply == 3{
//            print("maxmim count reached")
//        }
//
//        return cell
//    }
//    func reloadPics(){
//        self.replyTaskTableView.reloadData()
//    }
}
