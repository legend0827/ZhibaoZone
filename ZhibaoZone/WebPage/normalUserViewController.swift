//
//  normalUserViewController.swift
//  ZhibaoZone
//
//  Created by Kevin on 23/03/2018.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class normalUserViewController: UIViewController,UIWebViewDelegate {
    
    let OnlineShopWebView:UIWebView = UIWebView.init(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var loadingSubViews:[UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.isX() {
            OnlineShopWebView.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-113)
        }else{
            OnlineShopWebView.frame = CGRect(x: 0, y: 25, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-72)
        }
        OnlineShopWebView.delegate = self
        OnlineShopWebView.backgroundColor = UIColor.white
        let url = URL(string:"http://tianda.m.tmall.com/")
        let urlRequest:URLRequest = URLRequest.init(url: url!)
        OnlineShopWebView.loadRequest(urlRequest)
        
        DispatchQueue.main.async {
            //self.ShowLoading()
//            while(true){
//                print("loading status\(self.OnlineShopWebView.isLoading)")
//                if self.OnlineShopWebView.isLoading == true{
//                    self.StopLoding()
//                    break
//                }
//            }
        }
//
//        if OnlineShopWebView.isLoading == false{
//            StopLoding()
//        }
//        OnlineShopWebView
//        DispatchQueue.main.async {
//           self.OnlineShopWebView.loadRequest(urlRequest)
//
//
//            while(true){
//                if !self.OnlineShopWebView.isLoading{
//
//                    break
//                }
//            }
//        }
        self.view.addSubview(OnlineShopWebView)
        // Do any additional setup after loading the view.
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        StopLoding()
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        ShowLoading()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        if error.localizedDescription != "The URL can’t be shown" || error.localizedDescription != "无法显示 URL"{
        if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "似乎已断开与互联网的连接。"{
                greyLayerPrompt.show(text: "未接入网络，接入网络后再试")
            StopLoding()
            showRetryBtn()
        }
//        else{
//                greyLayerPrompt.show(text: "加载失败，请检查网络")
//        }

//        }else{
//
//        }
        print("出错了")
    }
    
    func showRetryBtn(){
        let retryBtn:UIButton = UIButton.init(type: .system)
        retryBtn.frame = CGRect(x: UIScreen.main.bounds.width/2 - 75, y: UIScreen.main.bounds.height/2 + 50, width: 150, height: 44)
        retryBtn.backgroundColor = UIColor.white
        retryBtn.layer.cornerRadius = 5
        retryBtn.layer.borderColor = #colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1)
        retryBtn.layer.borderWidth = 1
        retryBtn.tag = 902
        retryBtn.setTitle("刷新试试", for: .normal)
        retryBtn.setTitleColor(#colorLiteral(red: 0.9104188085, green: 0.2962309122, blue: 0.2970536053, alpha: 1), for: .normal)
        retryBtn.addTarget(self, action: #selector(reloadDate), for: .touchUpInside)
        self.view.addSubview(retryBtn)
        loadingSubViews.append(retryBtn)
    }
    @objc func reloadDate(){
        StopLoding()
        OnlineShopWebView.reload()
    }
    func ShowLoading(){
        StopLoding()
        //loading文字
        let noticeWhenLoadingData:UILabel = UILabel.init(frame: CGRect(x: UIScreen.main.bounds.width/2 - 90, y: UIScreen.main.bounds.height/2 - 50, width: 200, height: 30))
        noticeWhenLoadingData.text = "加载中，请稍侯..."
        noticeWhenLoadingData.font = UIFont.systemFont(ofSize: 14)
        noticeWhenLoadingData.textColor = UIColor.gray
        noticeWhenLoadingData.textAlignment = .center
        //loading动画
        var images:[UIImage] = []
        for i in 0...27{
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named:imagePath)!
            images.append(image)
        }
        let imageView = UIImageView()
        imageView.frame = CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 200, width: 200, height: 200)//self.view.bounds
        imageView.contentMode = .scaleAspectFit//.center
        imageView.animationImages = images
        imageView.animationDuration = 1
        imageView.animationRepeatCount = 0
        imageView.startAnimating()
        self.view.addSubview(imageView)
        self.view.addSubview(noticeWhenLoadingData)
        
        loadingSubViews.removeAll()
        loadingSubViews.append(imageView)
        loadingSubViews.append(noticeWhenLoadingData)
//        if !self.view.subviews.contains(AllOrdersTableView) {
//            self.view.addSubview(imageView)
//            self.view.addSubview(noticeWhenLoadingData)
//        }
    }
    
    func StopLoding(){
        for item in loadingSubViews{
            item.removeFromSuperview()
        }
        loadingSubViews.removeAll()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func WebView(){
        
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
