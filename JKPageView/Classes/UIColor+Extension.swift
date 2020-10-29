//
//  UIColor+Extension.swift
//  JKWeiBo
//
//  Created by 王冲 on 2017/12/20.
//  Copyright © 2017年 希爱欧科技有限公司. All rights reserved.
//

import UIKit

// MARK: 有关颜色的判断
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
    
    // Mark: 十六进制字符串设置颜色
    /// 十六进制字符串设置颜色
    /// - Parameters:
    ///   - hex: 十六进制字符串
    ///   - alpha: 透明度
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let color = Self.hexCustomColor(hex: hex)
        guard let r = color.r, let g = color.g, let b = color.b else {
            assert(false, "颜色值有误")
            return nil
        }
        self.init(r: r, g: g, b: b, alpha: alpha)
    }
    
    // MARK:- RGBA的颜色设置
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    // MARK: 获取颜色的渐变的 RGB
    /// 获取颜色的渐变色
    /// - Parameters:
    ///   - firstColor: 第一个颜色
    ///   - secondColor: 第二个颜色
    /// - Returns: 返回渐变的 RGB
    static func getRGBDelta(_ firstColor: UIColor, _ secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        
        let firstRGB = firstColor.colorToRGBA()
        let secondRGB = secondColor.colorToRGBA()
        
        guard let firstR = firstRGB.r, let firstG = firstRGB.g, let firstB = firstRGB.b, let secondR = secondRGB.r, let secondG = secondRGB.g, let secondB = secondRGB.b  else {
            return (0,0,0)
        }
        return (firstR - secondR, firstG - secondG, firstB - secondB)
    }
    
    // MARK: color 转 RGBA
    /// color 转 RGBA
    /// - Returns: 返回对应的 RGBA
    func colorToRGBA() -> (r: CGFloat?, g: CGFloat?, b: CGFloat?, a: CGFloat?) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return (nil, nil, nil, nil)
        }
        return (toCGFloat(string: "\(Int(red * multiplier))"), toCGFloat(string: "\(Int(green * multiplier))"), toCGFloat(string: "\(Int(blue * multiplier))"), alpha)
    }
    
    func toCGFloat(string: String) -> CGFloat? {
        if let doubleValue = Double(string) {
           return CGFloat(doubleValue)
        }
        return nil
    }
    
    // MARK:- 私有 - RGBA的颜色设置
    fileprivate static func hexCustomColor(hex: String) -> (r: CGFloat?, g: CGFloat?, b: CGFloat?) {
        
        // 1、判断字符串的长度是否符合
        guard hex.count >= 6 else {
            return (nil, nil, nil)
        }
        
        // 2、将字符串转成大写
        var tempHex = hex.uppercased()
        
        // 3、判断开头： 0x/#/##
        if tempHex.hasSuffix("0x") || tempHex.hasSuffix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasSuffix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        // 4、分别取出 RGB
        // FF --> 255
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        // 5、将十六进制转成 255 的数字
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return (r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
}

