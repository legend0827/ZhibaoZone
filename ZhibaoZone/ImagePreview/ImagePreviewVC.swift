//
//  ImagePreviewVC.swift
//  ZhibaoZone
//
//  Created by Kevin on 17/01/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import AVKit
import AVFoundation

//预览状态
enum PreviewModeType:Int {
    case previewWithDelete = 1
    case previewWithoutDelete
}

class ImagePreviewVC: UIViewController {
    
    var workZoneVCObject =  WorkZoneViewController()
    var taskDetailReplyObject = TaskDetailViewController(currentTaskID: "nothing", currentCustomid: "123456", currentOrderID: "123456", currentGoodsID: "123456", currentTaskType: 0)
    
    var PreviewType:[String] = []//"public.image" // 默认为图片.
    var imageUrls:[URL] = []
    
    var roleType = 0//
    
    var previewMode:PreviewModeType = PreviewModeType.previewWithDelete // 默认带删除
    var previewSourceVC:String = ""
    //存储图片数组
    var images:[UIImage]
    
    //默认显示的图片索引
    var index:Int
    
    var playingIndex:Int = 0
    //用来放置各个图片单元
    var collectionView:UICollectionView!
    
    //collectionView的布局
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    //页控制器（小圆点）
    var pageControl : UIPageControl!
    
   
    //初始化
    init(images:[UIImage], index:Int = 0,previewMode:PreviewModeType){
        self.images = images
        self.index = index
        self.previewMode = previewMode
        print("init with previewMode\(previewMode)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景设为黑色
        self.view.backgroundColor = UIColor.black
        
        //collectionView尺寸样式设置
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        //横向滚动
        collectionViewLayout.scrollDirection = .horizontal
        
        //collectionView初始化
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.register(ImagePreviewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        //不自动调整内边距，确保全屏
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(collectionView)
        
        //将视图滚动到默认图片上
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //设置页控制器
        pageControl = UIPageControl()
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
        pageControl.numberOfPages = images.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index
        view.addSubview(self.pageControl)

        // Do any additional setup after loading the view.
    }
    //视图显示时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //视图消失时
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //显示导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //将要对子视图布局时调用（横竖屏切换时）
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //重新设置collectionView的尺寸
        collectionView.frame.size = self.view.bounds.size
        collectionView.collectionViewLayout.invalidateLayout()
        
        //将视图滚动到当前图片上
        let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
        //重新设置页控制器的位置
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                     y: UIScreen.main.bounds.height - 20)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deletePic(indexPath:IndexPath){
        var lastPic = false // 最后一张图片
        
        collectionView.cellForItem(at: indexPath)?.removeFromSuperview()
        images.remove(at: indexPath.row)
        PreviewType.remove(at: indexPath.row)
        imageUrls.remove(at: indexPath.row)
        
        //
        if images.count == 2 {
            //collectionView.
            pageControl.currentPage = 1
            pageControl.numberOfPages = 2
            let tempIndexPath = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: tempIndexPath, at: .left, animated: true)
            collectionView.reloadData()
        }else if images.count == 1{
            let tempIndexPath = IndexPath(item: 0, section: 0)
            pageControl.currentPage = 0
            pageControl.numberOfPages = 1
            collectionView.scrollToItem(at: tempIndexPath, at: .left, animated: true)
            collectionView.reloadData()
        }else{
            lastPic = true
            print("there's no images to display")
        }
        print("delete succeed on index\(indexPath.row)")
        if previewSourceVC == "WorkZoneVC"{
            workZoneVCObject.deleteAttachment(atIndex:indexPath.row)
        }else{
            taskDetailReplyObject.deleteAttachment(atIndex:indexPath.row)
        }
        if lastPic {
            if previewSourceVC != "WorkZoneVC"{
                taskDetailReplyObject.replyTextView.becomeFirstResponder()
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//ImagePreviewVC的CollectionView相关协议方法实现
extension ImagePreviewVC:UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    //collectionView单元格创建
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! ImagePreviewCell
            
            cell.imageView.image = images[indexPath.row]
            if PreviewType[indexPath.row] == "public.movie" {
                
                let playerLayerBtn:UIButton = UIButton.init(type: .custom)
                
                playerLayerBtn.frame =  CGRect(x: UIScreen.main.bounds.width/2 - 60, y:UIScreen.main.bounds.height/2 - 60, width: 120, height: 120)
                playerLayerBtn.backgroundColor = UIColor.clear
                
                //播放按钮图标
                let playerBtnIcon = UIImageView(frame: CGRect(x: 30, y: 30, width: 60, height: 60))
                playerBtnIcon.image = UIImage(named:"playvideoicon-white")
                playerLayerBtn.addSubview(playerBtnIcon)
                
                playerLayerBtn.addTarget(self, action: #selector(playBtnClicked), for: .touchUpInside)
                playingIndex = indexPath.row
                
                cell.contentView.addSubview(playerLayerBtn)
                //播放视频
                let player = AVPlayer(url: imageUrls[indexPath.row])
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            cell.index = indexPath
            cell.objectOfImagePVC = self
            cell.previewModel = self.previewMode
            cell.previewSourceVC = previewSourceVC
            cell.taskDetailReplyObject = taskDetailReplyObject
            cell.updateNavigationBar()
            return cell
    }
    @objc func playBtnClicked(){
        //播放视频
        let player = AVPlayer(url: imageUrls[playingIndex])
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    //collectionView单元格数量
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    //collectionView单元格尺寸
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    //collectionView里某个cell将要显示
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImagePreviewCell{
            //由于单元格是复用的，所以要重置内部元素尺寸
            cell.resetSize()// resetSize()
        }
    }
    
    //collectionView里某个cell显示完毕
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        //当前显示的单元格
        let visibleCell = collectionView.visibleCells[0]
        //设置页控制器当前页
        self.pageControl.currentPage = collectionView.indexPath(for: visibleCell)!.item
    }
}

// 只有当uiImage.cgImage有值的时候才可以使用UIImagePNGRepresentation(_ image: UIImage)
// 或者UIImageJPEGRepresentation(_ image: UIImage, _ compressionQuality: CGFloat)转换为Data
//func convertUIImageToData(uiImage:UIImage) -> Data {
//    var data = UIImagePNGRepresentation(uiImage)
//    if data == nil {
//        let cgImage = self.convertUIImageToCGImage(uiImage: uiImage)
//        let uiImage_ = UIImage.init(cgImage: cgImage)
//        data = UIImagePNGRepresentation(uiImage_)
//    }
//    return data!
//}

