//
//  greyLayerPrompt.swift
//  ZhibaoZone
//
//  Created by Kevin on 26/12/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class greyLayerPrompt: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    ///显示提示文字
    /// - Parameter text ： 显示的文字
    public class func show(text:String){
        greyLayerPrompt.share.textDidSet(text:text)
    }
    
    /// 显示提示文字并收起键盘
    ///
    /// - Parameters:
    ///   - text: 显示的文字
    ///   - hideKeyboardView: 需要收起键盘的view
    public class func show(text: String, hideKeyboardView: UIView) {
        hideKeyboardView.endEditing(true)
        greyLayerPrompt.share.textDidSet(text: text)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> 属性定义
    private static let share = greyLayerPrompt()
    fileprivate var promptView = UIView()
    fileprivate var promptLabel = UILabel()
    fileprivate var timer: DispatchSourceTimer?
    
    // MARK: >> 常量定义
    fileprivate let padding: CGFloat = 80
    fileprivate let screenPadding: CGFloat = 80
    fileprivate let height: CGFloat = 40
    fileprivate let fontsize: CGFloat = 15
    fileprivate let backAlpha: CGFloat = 0.6
}

// MARK: >> 初始化
fileprivate extension greyLayerPrompt {
    
    fileprivate func loadView() {
        
        loadSelf()
        loadPrompt()
    }
    
    private func loadSelf() {
        
        layer.cornerRadius = 5
        clipsToBounds = true
        isUserInteractionEnabled = false
        alpha = 0
    }
    
    private func loadPrompt() {
        promptView.alpha = backAlpha
        promptView.backgroundColor = UIColor.black
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont.systemFont(ofSize: fontsize)
        promptLabel.textColor = UIColor.white
        
        addSubview(promptView)
        addSubview(promptLabel)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
}

// MARK: >> 刷新控件
fileprivate extension greyLayerPrompt {
    
    fileprivate func textDidSet(text: String) {
        reloadView(text: text)
        refreshTimer()
    }
    
    // MARK: >> 更新view
    private func reloadView(text: String) {
        promptLabel.text = text
        let sz = text.rect(fontsize: fontsize, size: CGSize(width:UIScreen.main.bounds.size.width - screenPadding, height: 100))
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
        frame = CGRect(x: 0, y: 40, width: sz.width + padding, height: height)
        center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: center.y)
        promptLabel.frame = CGRect(x: 0, y: 0, width: sz.width + padding, height: height)
        promptView.frame = promptLabel.bounds
        UIApplication.shared.keyWindow?.bringSubview(toFront: self)
    }
    
    // MARK: >> 刷新timer
    private func refreshTimer() {
        timer?.cancel()
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.scheduleRepeating(wallDeadline: .now(), interval: .seconds(1))
        var timerTime = 2
        timer?.setEventHandler {
            if timerTime<=0 {
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 0
                }
                self.timer?.cancel()
            }
            timerTime-=1
        }
        timer?.resume()
    }
    
}

extension String {
    func rect(fontsize:CGFloat, size: CGSize) -> CGSize {
        let string = self as NSString
        return string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontsize)], context: nil).size
    }
}
