//
//  invoiceViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/11/6.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class invoiceViewController: UIViewController,UIScrollViewDelegate {

    let scrollView:UIScrollView = UIScrollView.init()
    let agreementArticle:UIImageView = UIImageView.init()
    //  var loginVC = ViewController()
    //存储图片数组
    var images:[UIImage]
    
    //默认显示的图片索引
    var index:Int
    
    var playingIndex:Int = 0
    //用来放置各个图片单元
    var collectionView:UICollectionView!
    
    //collectionView的布局
    var collectionViewLayout: UICollectionViewFlowLayout!
    
    let invoiceAitimiImageView:UIImageView = UIImageView.init()
    let invoiceDoulianImageView:UIImageView = UIImageView.init()
    let invoiceHengyueshijueImageView:UIImageView = UIImageView.init()
    let invoiceXiemaiImageView:UIImageView = UIImageView.init()
    let invoiceYigemixiuImageView:UIImageView = UIImageView.init()
    
    //页控制器（小圆点）
    var pageControl : UIPageControl!
    //初始化
    init(){
        let invoiceAitimi:UIImage = UIImage(named: "invoice-aitimi")!
        let invoiceDoulian:UIImage = UIImage(named: "invoice-doulian")!
        let invoiceHengyueshijue:UIImage = UIImage(named: "invoice-hengyueshijue")!
        let invoiceXiemai:UIImage = UIImage(named: "invoice-xiemai")!
        let invoiceYigemixiu:UIImage = UIImage(named: "invoice-yigemixiu")!
        self.images = [invoiceXiemai,invoiceDoulian,invoiceAitimi,invoiceYigemixiu,invoiceHengyueshijue]
        self.index = 0
        
        
        invoiceAitimiImageView.frame = CGRect(x: 0, y: 40, width: kWidth, height: 367/375*kWidth)
        
       // self.previewMode = previewMode
        // print("init with previewMode\(previewMode)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarHiden(toHidden: false, ViewController: self)
        setStatusBarBackgroundColor(color: .backgroundColors(color: .clear))
        self.view.backgroundColor = UIColor.backgroundColors(color: .clear)// UIColor.backgroundColors(color: .)
        //先隐藏系统提供的导航栏
        self.navigationController?.isNavigationBarHidden = true
        
        //自定义导航栏 navigationBar
        let navBar = UINavigationBar(frame: CGRect(x:0, y:19 + heightChangeForiPhoneXFromTop, width:kWidth, height:44))
        // 导航栏背景颜色
        navBar.backgroundColor = UIColor.backgroundColors(color: .white)
        navBar.barTintColor = UIColor.backgroundColors(color: .white)
        navBar.isTranslucent = false //关闭模糊效果
        //这里是导航栏透明
        //navBar.shadowImage = UIImage()
        //navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        // 自定义导航栏的title，用UILabel实现
        let titleLabel = UILabel(frame: CGRect(x:0,y:0,width:50,height:60))
        titleLabel.text = "开入发票信息"
        titleLabel.textColor = UIColor.titleColors(color: .black)
        // 这里使用系统自定义的字体
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        // 创建导航栏组件
        let navItem = UINavigationItem()
        // 设置自定义的title
        navItem.titleView = titleLabel
        
        //        // 创建左侧按钮
        let backImg=UIImage(named: "left-arrow-black")
        let leftBarItem=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelBtnClicked))
        leftBarItem.tintColor = UIColor.backgroundColors(color: .black)
        
        //去除导航栏下方的横线
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        navItem.setLeftBarButton(leftBarItem, animated: false)
        
        navigationItem.setHidesBackButton(true, animated: false)
        // 把导航栏组件加入导航栏
        navBar.pushItem(navItem, animated: false)
        
        
        //4817/2275
//        agreementArticle.frame = CGRect(x: 0, y: 0, width: kWidth, height: 1977/414 * kWidth)
//        agreementArticle.image = UIImage(named: "agreementArticleimg-zh")
        
        //collectionView尺寸样式设置
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        //横向滚动
        collectionViewLayout.scrollDirection = .horizontal
        
        //collectionView初始化
        collectionView = UICollectionView(frame: self.view.bounds,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(InvoiceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        // 导航栏添加到view上
        self.view.addSubview(navBar)
       // scrollView.frame = CGRect(x: 0, y: 66 + heightChangeForiPhoneXFromTop, width: kWidth, height: kHight - 66 - heightChangeForiPhoneXFromTop)
      //  scrollView.contentSize = CGSize(width: kWidth * 5, height: kHight)
      //
    //    scrollView.delegate = self
       //  self.view.addSubview(scrollView)
//        scrollView.addSubview(agreementArticle)
//        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
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
    
    
    @objc func cancelBtnClicked(){
        self.dismiss(animated: true, completion: nil)
    }

    @objc func copyBtnClicked(_ button:UIButton){
        let tag = button.tag
        switch tag {
        case 0:
            UIPasteboard.general.strings = ["发票类型：专票（优先），普票",
                                            "开票名称：    北京协迈科技有限公司",
                                            "纳税人识别号：911101165657958673",
                                            "地址： 北京市怀柔区北大街1号院3号楼1层01",
                                            "电话：13720025512",
                                            "开户行：中国银行股份有限公司北京怀柔支行",
                                            "账号：341556413683"
            ]
        case 1:
            
            UIPasteboard.general.strings = ["发票类型：普票",
                                            "开票名称：    北京豆联科技有限公司",
                                            "纳税人识别号：91110116330328906Q",
                                            "地址： 北京市怀柔区北大街1号院3号楼1层01层-07",
                                            "电话：010-60686052",
                                            "开户行及账号：中国工商银行北京雁栖支行",
                                            "账号：0200066309200064508"
            ]
        case 2:
            
            UIPasteboard.general.strings = ["发票类型：普票",
                                            "开票名称：    北京艾提米科技有限公司",
                                            "纳税人识别号：91110116MA00F1WJ0R",
                                            "地址： 北京市怀柔区北大街1号院3号楼1层01层-09",
                                            "电话：13720025512",
                                            "开户行及账号：中国工商银行股份有限公司北京雁栖支行",
                                            "账号：0200066309200081614"
            ]
        case 3:
            
            UIPasteboard.general.strings = ["发票类型：普票",
                                            "开票名称：    武汉意格米修艺术设计有限公司",
                                            "纳税人识别号：91420111055723310C",
                                            "地址： 武汉市洪山区珞狮路145号未来城A座1304房",
                                            "电话：15337118879",
                                            "开户行及账号：中国银行股份有限公司武汉楚雄大道支行",
                                            "账号：569060584861"
            ]
        case 4:
            UIPasteboard.general.strings = ["发票类型：普票",
                                            "开票名称：    武汉恒烁视觉传媒有限公司",
                                            "纳税人识别号：91420106303477033N",
                                            "地址： 武汉市武昌区丰收村1号汇东佳韵小区(二期) 10栋1层商场区A区01号",
                                            "电话：15337118879",
                                            "开户行及账号：武汉农村商业银行",
                                            "账号：200771890310018"
            ]
        default:
            UIPasteboard.general.strings = ["发票类型：普票",
                                            "开票名称：    北京艾提米科技有限公司",
                                            "纳税人识别号：91110116MA00F1WJ0R",
                                            "地址： 北京市怀柔区北大街1号院3号楼1层01层-09",
                                            "电话：13720025512",
                                            "开户行及账号：中国工商银行股份有限公司北京雁栖支行",
                                            "账号：0200066309200081614"
            ]
        }
        greyLayerPrompt.show(text: "发票信息复制成功")
    }
}
//invoiceViewController的CollectionView相关协议方法实现
extension invoiceViewController:UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    
    //collectionView单元格创建
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! InvoiceCollectionViewCell
            
            cell.index = indexPath
            cell.imageView.image = images[indexPath.row]
            cell.copyBtn.tag = indexPath.row
            cell.copyBtn.addTarget(self, action: #selector(copyBtnClicked(_:)), for: .touchUpInside)
//            let Label:UILabel = UILabel.init(frame: CGRect(x: 10, y: 100, width: 100, height: 22))
//            Label.text = "\(indexPath)"
//            cell.contentView.addSubview(Label)
          //  cell.updateNavigationBar()
            return cell
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
        if let cell = cell as? InvoiceCollectionViewCell{
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
