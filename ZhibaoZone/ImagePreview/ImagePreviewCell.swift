//
//  ImagePreviewCell.swift
//  ZhibaoZone
//
//  Created by Kevin on 17/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ImagePreviewCell: UICollectionViewCell {
    
    var index:IndexPath = [0,0]
    
    var objectOfImagePVC:ImagePreviewVC?
    
    var taskDetailReplyObject = TaskDetailViewController(currentTaskID: "nothing", currentCustomid: "123456", currentOrderID: "123456", currentGoodsID: "123456", currentTaskType: 0)
    var previewSourceVC:String = ""

    //滚动视图
    var scrollView:UIScrollView!
    var previewModel:PreviewModeType?// = .previewWithDelete
    
    //用于显示图片的imageView
    var imageView:UIImageView!
    
    //导航栏
    let navigationBar:UINavigationBar = UINavigationBar.init(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 60))
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
        imageView.frame = scrollView.bounds
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        //单击监听
        let tapSingle=UITapGestureRecognizer(target:self,
                                             action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        //双击监听
        let tapDouble=UITapGestureRecognizer(target:self,
                                             action:#selector(tapDoubleDid(_:)))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        //声明点击事件需要双击事件检测失败后才会执行
        tapSingle.require(toFail: tapDouble)
        self.imageView.addGestureRecognizer(tapSingle)
        self.imageView.addGestureRecognizer(tapDouble)
    }
    //删除按钮相应
    @objc func deleteBtnClicked(){
        objectOfImagePVC?.deletePic(indexPath: index)
        print("delete index at \(index.row)")
    }
    @objc func cancelBtnClicked() {
        
        let responder = responderViewController()
        if previewSourceVC != "WorkZoneVC"{
            taskDetailReplyObject.replyTextView.becomeFirstResponder()
        }
        responder?.dismiss(animated: true, completion: nil)
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
            imageView.center = scrollView.center
        }
    }
    func updateNavigationBar(){
//        if previewModel == PreviewModeType.previewWithDelete {
//            navigationBar.items?.remove(at: <#T##Int#>)
//        }
        
        navigationBar.isHidden = true
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.barTintColor = UIColor.black
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
        titleLabel.text = "附件预览"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        let navItem = UINavigationItem()
        navItem.titleView = titleLabel
        let leftButton = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelBtnClicked))
        leftButton.tintColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        
        let rightButton = UIBarButtonItem(image: UIImage(named:"delete-white"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(deleteBtnClicked))
        rightButton.tintColor = UIColor.white
        print("previewModel in cell is \(previewModel)")
        if previewModel == .previewWithDelete{
            navItem.setRightBarButton(rightButton, animated: false)
        }
        navItem.setLeftBarButton(leftButton, animated: false)
        navigationBar.pushItem(navItem, animated: false)
        
        self.addSubview(navigationBar)
    }
    //视图布局改变时（横竖屏切换时cell尺寸也会变化）
    override func layoutSubviews() {
        super.layoutSubviews()
        //重置单元格内元素尺寸
        resetSize()
    }
    
    //获取imageView的缩放尺寸（确保首次显示是可以完整显示整张图片）
    func scaleSize(size:CGSize) -> CGSize {
        let width = size.width
        let height = size.height
        let widthRatio = width/UIScreen.main.bounds.width
        let heightRatio = height/UIScreen.main.bounds.height
        let ratio = max(heightRatio, widthRatio)
        return CGSize(width: width/ratio, height: height/ratio)
    }
    
    
    //图片单击事件响应
    @objc func tapSingleDid(_ ges:UITapGestureRecognizer){
        if navigationBar.isHidden == true{
            UIView.animate(withDuration: 0.3, animations: {()->Void in
                self.navigationBar.transform = CGAffineTransform(translationX: 0, y: 20)//UIScreen.main.bounds.height+300)
            },completion: { (finished) in
                self.navigationBar.isHidden = false
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {()->Void in
                self.navigationBar.transform = CGAffineTransform(translationX: 0, y: -60) //负数，向上移动
            },completion: { (finished) in
                self.navigationBar.isHidden = true
            })
        }
    }
    
    //图片双击事件响应
    @objc func tapDoubleDid(_ ges:UITapGestureRecognizer){
        //隐藏导航栏
        if let nav = self.responderViewController()?.navigationController{
            nav.setNavigationBarHidden(true, animated: true)
        }
        //缩放视图（带有动画效果）
        UIView.animate(withDuration: 0.5, animations: {
            //如果当前不缩放，则放大到3倍。否则就还原
            if self.scrollView.zoomScale == 1.0 {
                self.scrollView.zoomScale = 3.0
            }else{
                self.scrollView.zoomScale = 1.0
            }
        })
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

//ImagePreviewCell的UIScrollViewDelegate代理实现
extension ImagePreviewCell:UIScrollViewDelegate{
    
    //缩放视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    //缩放响应，设置imageView的中心位置
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ?
            scrollView.contentSize.width/2:centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?
            scrollView.contentSize.height/2:centerY
        print(centerX,centerY)
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}
