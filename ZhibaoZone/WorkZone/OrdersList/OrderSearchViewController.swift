//
//  OrderSearchViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class OrderSearchViewController: UIViewController,UISearchBarDelegate {
    //搜索类型
    var _searchModel:searchContentsType = .orderidOnly
    
    let searchBar:UISearchBar = UISearchBar.init(frame: CGRect(x: 0, y: 20+heightChangeForiPhoneXFromTop, width: kWidth, height: 45))

    init(searchModel:searchContentsType) {
        super.init(nibName: nil, bundle: nil)
        _searchModel = searchModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.backgroundColors(color: .white)
        setStatusBarBackgroundColor(color: .clear)
        //设置搜索栏
        searchBar.backgroundColor = UIColor.titleColors(color: .white)
        searchBar.layer.backgroundColor = UIColor.titleColors(color: .white).cgColor
        searchBar.placeholder = "输入订单号搜索"
        searchBar.backgroundColor = UIColor.white
        searchBar.barTintColor = UIColor.white
        searchBar.searchBarStyle = .minimal
        searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        searchBar.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
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
