//
//  JKPageView.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

public protocol JKPageViewDelegate {
    /// 点击第几个标题
    /// - Parameters:
    ///   - targetIndex: 点击的第几个
    func currentTitleIndex(targetIndex: Int)
}

public class JKPageView: UIView {
    public var delegate: JKPageViewDelegate?
    /// 标题
    fileprivate var titles: [String]
    /// 控制器
    fileprivate var childVcs: [UIViewController]
    /// 父控制器
    fileprivate var parentVc: UIViewController
    /// 样式
    fileprivate var style: JKTitleStyle
    /// 标题的 view
    fileprivate var titleView: JKTitleView?
    
    public init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, style: JKTitleStyle) {
        
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        if style.isShowCover || style.showStyle == .coverStyle {
            self.style.isShowScrollLine = false
        }
    
        // UI布局
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
public extension JKPageView {
    
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
    }
    
    /// 标题的 UI
    fileprivate func setupTitleView() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = JKTitleView(frame: titleFrame, titles: self.titles, style: style)
        titleView?.currentTitleBlock = { [weak self] (targetIndex) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.delegate?.currentTitleIndex(targetIndex: targetIndex)
        }
        titleView?.backgroundColor = self.style.titleViewBackgroundColor
        addSubview(titleView!)
    }
    
    /// 内容的 UI
    fileprivate func setupContentView() {
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = JKContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        addSubview(contentView)

        // 让 content 成为 titleView 的代理
        titleView?.delegate = contentView
        // 让 titleView 成为 content 的代理
        contentView.delegate = titleView
    }
}
