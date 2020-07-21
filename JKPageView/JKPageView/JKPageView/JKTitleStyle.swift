//
//  JKTitleStyle.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

class JKTitleStyle: NSObject {
    
    /// 标题的高度
    var titleHeight: CGFloat = 44.0
    /// 头部 titleView 的背景色
    var titleViewBackgroundColor: UIColor = UIColor.white
    /// 默认的颜色
    var normalColor: UIColor = UIColor.JKColor(r: 0, g: 0, b: 0)
    /// 选中的颜色
    var selectedColor: UIColor = UIColor.JKColor(r: 255, g: 127, b: 0)
    /// 标题的大小
    var fontSize: CGFloat = 15.0
    /// 是否可以滚动
    var isScrollEnable: Bool = false
    /// 标题之间的间距
    var itemMargin: CGFloat = 20.0
    /// 是否显示下划线
    var isShowScrollLine: Bool = false
    /// 下划线的高度，默认是 2.0
    var bottomLineHeight: CGFloat = 2.0
    /// 滚动条的默认颜色
    var bottomLineColor: UIColor = UIColor.green
    /// 是否显示底部的分割线
    var isShowSplitLine: Bool = false
    /// 底部分割线的高度
    var splitLineHeight: CGFloat = 0.5
    /// 底部分割线的颜色
    var splitLineColor: UIColor = UIColor.lightGray
    
    /// 是否进行缩放
    var isNeedScale: Bool = false
    var scaleRange: CGFloat = 1.2
    
    /// 是否显示遮盖
    var isShowCover: Bool = false
    /// 遮盖背景颜色
    var coverBgColor: UIColor = UIColor.lightGray
    /// 遮盖背景颜色
    var coverBgColorAlpha: CGFloat = 0.7
    /// 文字&遮盖间隙
    var coverMargin: CGFloat = 5
    /// 遮盖的高度
    var coverH: CGFloat = 25
    /// 设置圆角大小
    var coverRadius: CGFloat = 12
    
}
