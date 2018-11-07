//
//  InvoiceCollectionViewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/11/6.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class InvoiceCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {
    
    var index:IndexPath = [0,0]
    //滚动视图
    var scrollView:UIScrollView!
    
    //用于显示图片的imageView
    var imageView:UIImageView!
    
    let copyBtn:UIButton = UIButton.init(type: .custom)
    //导航栏
    //let navigationBar:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: 0 + heightChangeForiPhoneXFromTop, width: UIScreen.main.bounds.width, height: 60))
    //let deleteBtn:UIButton = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 40, width: 50, height: 50))
    
    //初始化
    override init(frame: CGRect) {
        // self.images = images
        // self.index = index
        super.init(frame: frame)
        
        //scrollView初始化
        scrollView = UIScrollView(frame: self.contentView.bounds)
        self.contentView.addSubview(scrollView)
        scrollView.delegate = self
        //scrollView缩放范围 1~3
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        
        //imageView初始化
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 80, width: scrollView.bounds.width, height: scrollView.bounds.height)//scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        copyBtn.frame = CGRect(x: kWidth - 230, y:  455, width: 200, height: 22)
        copyBtn.setTitle("一键复制信息", for: .normal)
        copyBtn.contentHorizontalAlignment = .right
        copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        copyBtn.setTitleColor(UIColor.titleColors(color: .red), for: .normal)
        self.contentView.addSubview(copyBtn)
        
        let notice:UILabel = UILabel.init(frame: CGRect(x: 25, y: kHight - heightChangeForiPhoneXFromBottom - 180, width: kWidth - 50, height: 150))
        notice.text = "公司开销需开入发票，个人奖励1%车马费，单张面额最好在500元以上（多次小额可以累积一起开）。优先开票类目：办公用品（具体），劳保用品，工作餐，差旅费，交通费（打车，油费），电话费，技术服务费，设计服务费，咨询费，印刷费"
        notice.numberOfLines = 5
        notice.font = UIFont.systemFont(ofSize: 12)
        notice.textColor = UIColor.titleColors(color: .gray)
        self.contentView.addSubview(notice)
    }

    @objc func cancelBtnClicked() {
        let responder = responderViewController()
        responder?.dismiss(animated: true, completion: nil)
        setStatusBarBackgroundColor(color: UIColor.backgroundColors(color: .red))
    }
    //重置单元格内元素尺寸
    func resetSize(){
        //scrollView重置，不缩放
        scrollView.frame = self.contentView.bounds
        scrollView.zoomScale = 1.0
        //imageView重置
        if let image = self.imageView.image {
            //设置imageView的尺寸确保一屏能显示的下
            imageView.frame.size = scaleSize(size: image.size)
            //imageView居中
           // imageView.center = scrollView.center
        }
    }
//    func updateNavigationBar(){
//        //        if previewModel == PreviewModeType.previewWithDelete {
//        //            navigationBar.items?.remove(at: <#T##Int#>)
//        //        }
//
//        navigationBar.isHidden = true
//        navigationBar.backgroundColor = UIColor.clear
//        navigationBar.barTintColor = UIColor.black
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 20 + heightChangeForiPhoneXFromTop, width: 50, height: 60))
//        titleLabel.text = "附件预览"
//        titleLabel.textColor = UIColor.white
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//
//        let navItem = UINavigationItem()
//        navItem.titleView = titleLabel
//        let leftButton = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelBtnClicked))
//        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
//
//        let rightButton = UIBarButtonItem(image: UIImage(named:"delete-white"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(deleteBtnClicked))
//        rightButton.tintColor = UIColor.white
//        //        print("previewModel in cell is \(previewModel)")
//        if previewModel == .previewWithDelete{
//            navItem.setRightBarButton(rightButton, animated: false)
//        }
//        navItem.setLeftBarButton(leftButton, animated: false)
//        navigationBar.pushItem(navItem, animated: false)
//
//        self.addSubview(navigationBar)
//    }
    //视图布局改变时（横竖屏切换时cell尺寸也会变化）
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //重置单元格内元素尺寸
//        //resetSize()
//    }
    
    //获取imageView的缩放尺寸（确保首次显示是可以完整显示整张图片）
    func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/UIScreen.main.bounds.width
        let heightRatio = height/UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
    //查找所在的ViewController
    func responderViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
