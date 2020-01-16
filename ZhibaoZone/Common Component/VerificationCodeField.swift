//
//  VerificationCodeField.swift
//  ZhibaoZone
//
//  Created by Kevin on 2020/1/15.
//  Copyright © 2020 Kevin. All rights reserved.
//

import UIKit

class VerificationCodeField: UITextField {
    //保存上一次的文本内容
       var _previousText:String!
        
       //保持上一次的文本范围
       var _previousRange:UITextRange!
        
       //当本视图的父类视图改变的时候
       override func willMove(toSuperview newSuperview: UIView?) {
           //监听值改变通知事件
           if newSuperview != nil {
               NotificationCenter.default.addObserver(self,
                                      selector: #selector(VerificationCodeFormat(_:)),
                                      name: NSNotification.Name.UITextFieldTextDidChange,
                                      object: nil)
           }else{
               NotificationCenter.default.removeObserver(self,
                                         name: Notification.Name.UITextFieldTextDidChange,
                                         object: nil)
           }
       }
        
       //输入框内容改变时对其内容做格式化处理
       @objc func VerificationCodeFormat(_ notification: Notification) {
           let textField = notification.object as! UITextField
            
           if(!textField.isEqual(self)){
               return
           }
            //当前光标的位置（后面会对其做修改）
            var cursorPostion = textField.offset(from: textField.beginningOfDocument,
                                                 to: textField.selectedTextRange!.start)
            
           //过滤掉非数字，非英文字符，只保留数字和英文字符
           var digitsText = getDigitsOrLetterText(string: textField.text!,
                                          cursorPosition: &cursorPostion)
            textField.text = digitsText
           //避免超过4位的输入
            if digitsText.count > 4 {
               textField.text = _previousText
               textField.selectedTextRange = _previousRange
               return
           }
            
           //现在的值和选中范围，供下一次输入使用
           _previousText = self.text!
           _previousRange = self.selectedTextRange!
       }
    
    //除去非数字字符，同时确定光标正确位置
       func getDigitsOrLetterText(string:String, cursorPosition:inout Int) -> String{
           //保存开始时光标的位置
           let originalCursorPosition = cursorPosition
           //处理后的结果字符串
           var result = ""
            
           var i = 0
           //遍历每一个字符
           for uni in string.unicodeScalars {
               //如果是数字则添加到返回结果中
            if CharacterSet.alphanumerics.contains(uni) { //CharacterSet.decimalDigits.contains(uni) ||
                   result.append(string[i])
               }
                   //非数字则跳过，如果这个非法字符在光标位置之前，则光标需要向前移动
               else{
                   if i < originalCursorPosition {
                       cursorPosition = cursorPosition - 1
                   }
               }
               i = i + 1
           }
            
           return result
       }

}
