//
//  UIColor+extension.swift
//  JKPageView_Example
//
//  Created by IronMan on 2020/9/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK:- 自定义RGBA的颜色
     /// 自定义初始化器设置 Color
     /// - Parameters:
     ///   - r: red 颜色值
     ///   - g: green颜色值
     ///   - b: blue颜色值
     ///   - alpha: 透明度
     convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
         // 提示：在 extension 中给系统的类扩充构造函数，只能扩充：遍历构造函数
         self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
     }
     
     
     // MARK:- RGBA的颜色设置
     static func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
         return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
     }
     
     // MARK:- 随机色
     /// 随机色
     /// - Returns: 返回颜色
     static func randomColor() -> UIColor {
         return color(r: CGFloat(arc4random()%256) , g: CGFloat(arc4random()%256), b: CGFloat(arc4random()%256), a: 1.0)
     }
}
