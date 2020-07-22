//
//  JKTitleView.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

protocol JKTitleViewDelegate: class {
    
    /// 点击标题
    /// - Parameters:
    ///   - pageView: 容器视图
    ///   - targetIndex: 点击的第几个
    func clickTitleView(_ pageView: JKTitleView, targetIndex: Int)
}

typealias CurrentTitleBlock = (_ currentIndex: Int)->()

class JKTitleView: UIView {
    
    var currentTitleBlock: CurrentTitleBlock?
    /// 设置代理
    weak var delegate: JKTitleViewDelegate?
    /// 当前选中是第几个标题
    fileprivate var currentIndex: Int = 0
    /// 标题数组
    fileprivate var titles: [String]
    /// 样式
    fileprivate var style: JKTitleStyle
    /// Label 数组
    fileprivate var titleLabels = [UILabel]()
    /// collectionview
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        return scrollView
    }()
    /// 底部横线的创建
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()
    /// 底部的分割线
    fileprivate lazy var splitLineView : UIView = {
        let splitView = UIView()
        splitView.backgroundColor = self.style.splitLineColor
        let h : CGFloat = self.style.splitLineHeight
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    
    /// 覆盖样式
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverBgColorAlpha
        return coverView
    }()
    
    // MARK: 计算属性
    fileprivate lazy var deltaRGB = UIColor.getRGBDelta(style.selectedColor, style.normalColor)
    fileprivate lazy var selectedRGB = style.selectedColor.getRGB()
    fileprivate lazy var normalRGB = style.normalColor.getRGB()
    
    init(frame: CGRect, titles: [String], style: JKTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JKTitleView {
    
    // MARK:- UI布局
    func setupUI() {
        // 1.将UIScrollview添加到view中
        addSubview(scrollView)
        
        // 2.添加底部分割线
        if self.style.isShowSplitLine {
            addSubview(splitLineView)
        }
        
        // 3.将titleLabel添加到 UIScrollView 中
        setupTitleLabels()
        
        // 4.设置 titleLabel 的frame
        setTitleLabelsFrame()
        
        // 5.添加滚动条
        if style.isShowScrollLine {
            scrollView.addSubview(bottomLine)
        }
        
        // 6.设置遮盖的View
        if style.isShowCover || style.showStyle == .coverStyle {
            setupCoverView()
        }
    }
    
    /// 布局标题控件
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            titleLabel.tag = i + 100
            titleLabel.textAlignment = .center
            titleLabel.isUserInteractionEnabled = true
            scrollView.addSubview(titleLabel)
            
            // 给 Label 增加手势
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick))
            titleLabel.addGestureRecognizer(tapGestureRecognizer)
            
            // Label 放到数组里面
            titleLabels.append(titleLabel)
        }
    }
    
    /// 设置 titleLabel 的frame
    private func setTitleLabelsFrame() {
        let count = titles.count
        
        for (i, label) in titleLabels.enumerated() {
            var w: CGFloat = 0
            let h: CGFloat = bounds.height
            var x: CGFloat = 0
            let y: CGFloat = 0
            
            if style.isScrollEnable {
                // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: style.fontSize)], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                    if style.isShowScrollLine {
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width = w
                    }
                } else {
                    let preLabel = titleLabels[i - 1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
                
            } else {
                // 不可以滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                
                if i == 0, style.isShowScrollLine {
                    // 不能滚动从 0 开始
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
                
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            if i == 0 {
                let scale = style.isNeedScale ? style.scaleRange : 1.0
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
    }
    
    /// 布局覆盖部分
    private func setupCoverView() {
        
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels[0]
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

//MARK:- 监听事件
extension JKTitleView {
    
    // MARK: 标题的点击
    /// 标题的点击
    /// - Parameter gestureRecognizer: 手势
    @objc fileprivate func titleLabelClick(_ gestureRecognizer: UITapGestureRecognizer) {
        
        // 1.取出用户点击的view
        guard let targetLabel = gestureRecognizer.view as? UILabel else {
            return
        }
        
        // 重复点击没反应
        guard currentIndex != targetLabel.tag - 100 else {
            return
        }
        // 传出去点击的第几个
        if currentTitleBlock != nil {
            currentTitleBlock!(targetLabel.tag - 100)
        }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        
        // 2.处理标题点击后的事件
        adjustTitleLabel(targetIndex: targetLabel.tag - 100)
        
        // 3.调整 bottomLine 的位置
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25) {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width
            }
        }
        
        // 8.调整比例
        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            targetLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        // 9.遮盖移动
        if style.isShowCover || style.showStyle == .coverStyle {
            let coverX = style.isScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
        
        // 4.触发代理 让 界面跟着滚动
        if self.delegate != nil {
            self.delegate?.clickTitleView(self, targetIndex: currentIndex)
        }
    }
    
    /// 调整label的为重
    /// - Parameter targetIndex: 目标title的索引
    fileprivate func adjustTitleLabel(targetIndex: Int) {
        
        // 重复点击没反应
        guard currentIndex != targetIndex else {
            return
        }
        
        // 获取点击的title
        let targetLabel = titleLabels[targetIndex]
        // 获取之前点击的Label
        let oldlabel = titleLabels[currentIndex]
        
        // 2.切换文字的颜色
        targetLabel.textColor = style.selectedColor
        oldlabel.textColor = style.normalColor
        
        // 3.重新设置选中的第几个
        currentIndex = targetIndex
        
        contentViewDidEndScroll()
    }
    
    func contentViewDidEndScroll() {
        
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        
        // 4.调整选中标题的位置
        // 能滚动还要保证 > scrollView 的宽度
        if style.isScrollEnable, scrollView.contentSize.width > scrollView.bounds.width {
            // 可以滚动
            var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
            // 小于 scrollView 的一半偏移 0
            if offsetX < 0 {
                offsetX = 0
            }
            // 最后一屏 滚动 scrollView.contentSize.width - scrollView.bounds.width
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width) {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        } else {
            // 不可以滚动
        }
    }
}

// MARK:- 实现页面滚动的代理
extension JKTitleView: JKContentViewDelegate {
    func scrollContentView(_ contentView: JKContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        
        print("sourceIndex == \(sourceIndex)")
        print("targetIndex == \(targetIndex)")
        print("progress == \(progress)")
        
        // 1.获取Label
        // 获取点击的 title 的 Label
        let targetLabel = titleLabels[targetIndex]
        // 获取之前点击的 Label
        let oldlabel = titleLabels[sourceIndex]
        
        // 2.颜色渐变
        targetLabel.textColor = UIColor.color(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        oldlabel.textColor = UIColor.color(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        // 3.记录最新的index
        currentIndex = targetIndex
        
        // 4.渐变BottomLine
        let moveTotalX = targetLabel.frame.origin.x - oldlabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - oldlabel.frame.width
        if style.isShowScrollLine {
            bottomLine.frame.origin.x = oldlabel.frame.origin.x + moveTotalX * progress
            bottomLine.frame.size.width = oldlabel.frame.width + moveTotalW * progress
        }
        
        // 5.调整缩放
        if style.isNeedScale {
            let scaleDelta = (style.scaleRange - 1.0) * progress
            oldlabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
        }
        
        // 6.计算cover的滚动
        if style.isShowCover || style.showStyle == .coverStyle {
            coverView.frame.origin.x = style.isScrollEnable ? (oldlabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (oldlabel.frame.origin.x + moveTotalX * progress)
            coverView.frame.size.width = style.isScrollEnable ? (oldlabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (oldlabel.frame.width + moveTotalW * progress)
        }
    }
    
    func scrollContentView(_ contentView: JKContentView, targetIndex: Int) {
        // 判断是否需要滚动
        guard style.isScrollEnable else {
            return
        }
        // 传出去点击的第几个
        if currentTitleBlock != nil {
            currentTitleBlock!(targetIndex)
        }
        contentViewDidEndScroll()
    }
}
