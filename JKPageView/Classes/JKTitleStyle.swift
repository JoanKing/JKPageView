//
//  JKTitleStyle.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

/// 展示的样式
public enum JKPageViewShowStyle {
    // 普通带下划线的样式
    case customStyle
    // 遮盖的样式（title文字下有背景）
    case coverStyle
}
public class JKTitleStyle: NSObject {
    
    /// 样式的设置
    public var showStyle: JKPageViewShowStyle = .customStyle
    
    // MARK:- 基本的配置
    /// 标题的高度
    public var titleHeight: CGFloat = 44.0
    /// 头部 titleView 的背景色
    public var titleViewBackgroundColor: UIColor = UIColor.white
    /// 默认的颜色
    public var normalColor: UIColor = UIColor.color(r: 0, g: 0, b: 0)
    /// 选中的颜色
    public var selectedColor: UIColor = UIColor.color(r: 255, g: 127, b: 0)
    /// 标题的大小
    public var fontSize: CGFloat = 15.0
    /// 是否可以滚动
    public var isScrollEnable: Bool = false
    /// 标题之间的间距
    public var itemMargin: CGFloat = 20.0
    
    // MARK:- 底部的滑动条
    /// 是否显示下划线
    public var isShowScrollLine: Bool = false
    /// 下划线的高度，默认是 2.0
    public var bottomLineHeight: CGFloat = 2.0
    /// 滚动条的默认颜色
    public var bottomLineColor: UIColor = UIColor.green
    
    // MARK:- 底部的分割线
    /// 是否显示底部的分割线
    public var isShowSplitLine: Bool = false
    /// 底部分割线的高度
    public var splitLineHeight: CGFloat = 0.5
    /// 底部分割线的颜色
    public var splitLineColor: UIColor = UIColor.lightGray
    
    // MARK:- 缩放的设置
    /// 是否进行缩放
    public var isNeedScale: Bool = false
    public var scaleRange: CGFloat = 1.2
    
    // MARK:- 遮盖的设置
    /// 是否显示遮盖
    public var isShowCover: Bool = false
    /// 遮盖背景颜色
    public var coverBgColor: UIColor = UIColor.lightGray
    /// 遮盖背景颜色
    public var coverBgColorAlpha: CGFloat = 0.7
    /// 文字&遮盖间隙
    public var coverMargin: CGFloat = 5
    /// 遮盖的高度
    public var coverH: CGFloat = 25
    /// 设置圆角大小
    public var coverRadius: CGFloat = 12
    
}
