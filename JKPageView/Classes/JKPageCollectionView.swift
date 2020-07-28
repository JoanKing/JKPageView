//
//  JKPageCollectionView.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/23.
//

import UIKit

/// 数据源
public protocol JKPageCollectionViewDataSoure: class {
    /// 返回几组
    /// - Parameter collectionView: 对象
    func pageNumberOfSections(in collectionView: UICollectionView) -> Int
    /// 返回每组多少个
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    /// 返回外面自定义的 cell
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

/// 代理
public protocol JKPageCollectionViewDelegate: class {
    /// 点击事件的响应
    func pageCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    /// 当前处于第几个标题
    func currentTitleIndex(targetIndex: Int)
}

/// 不需要实现的协议
public extension JKPageCollectionViewDelegate {
    // 不需要必须实现
    func currentTitleIndex(targetIndex: Int) {
    }
}

public class JKPageCollectionView: UIView {
    /// 是否禁止
    fileprivate var isForbidScroll: Bool = false
    /// 代理
    public weak var dataSource: JKPageCollectionViewDataSoure?
    /// 代理
    public weak var delegate: JKPageCollectionViewDelegate?
    /// 标题
    fileprivate var titles: [String]
    /// 是否标题在顶部
    fileprivate var isTitleInTop: Bool
    /// UICollectionView布局
    fileprivate var layout: JKPageCollectionViewLayout
    /// 样式
    fileprivate var style: JKTitleStyle
    /// UICollectionView
    fileprivate var collectionView: UICollectionView!
    /// UIPageControl
    fileprivate var pageControl: UIPageControl!
    /// 头部title
    fileprivate var titleView: JKTitleView!
    /// 记录当前是第几组
    fileprivate var sourceIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    public init(frame: CGRect, titles: [String], style: JKTitleStyle, isTitleInTop: Bool, layout: JKPageCollectionViewLayout) {
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        self.style = style
        super.init(frame: frame)
    
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JKPageCollectionView {
    fileprivate func setUpUI() {
        // 1.创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = JKTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = style.titleViewBackgroundColor
       titleView.currentTitleBlock = { [weak self] (targetIndex) in
            guard let weakSelf = self else {
                return
            }
            if weakSelf.delegate != nil {
                weakSelf.delegate!.currentTitleIndex(targetIndex: targetIndex)
            }
        }
        titleView.delegate = self
        addSubview(titleView)
        
        // 2.创建UIPageControl
        let pageControlHeight: CGFloat = 20
        let pageControlY: CGFloat = isTitleInTop ? (bounds.height - pageControlHeight) : (bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.currentPageIndicatorTintColor = style.pageControlCurrentPageColor
        pageControl.pageIndicatorTintColor = style.pageIndicatorTintColor
        pageControl.isEnabled = false
        addSubview(pageControl)
        
        // 3.创建 UICollectionView
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        let collectionVieFrame = CGRect(x: 0, y: collectionViewY, width:bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionVieFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = style.collectionViewBackgroundColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
    }

}

// MARK:- UICollectionViewDataSource 代理
extension JKPageCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.pageNumberOfSections(in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let itemCount = dataSource?.pageCollectionView(pageCollectionView: self, collectionView: collectionView, numberOfItemsInSection: section) ?? 0
        if section == 0 {
            // 给第一组设置页码
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        return itemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(pageCollectionView: self, collectionView: collectionView, cellForItemAt: indexPath)
    }
}

extension JKPageCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate!.pageCollectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
    }
    
    // 当滚动视图已经结束减速时被系统自动调用
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    // 当滚动视图已经结束拖拽的时候系统自动调用
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 没有减速，也就是停止滚动了
            scrollViewEndScroll()
        }
    }
    
    /// 停止滚动
    private func scrollViewEndScroll() {
        // 1.取出屏幕中显示的cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        // 2.判断我们的分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            // 2.1修改 pageControll的个数
            let itemCount = dataSource?.pageCollectionView(pageCollectionView: self, collectionView: collectionView, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            // 2.2、设置 titleView 位置
            titleView.scrollContentView(sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section, progress: 1.0)
            // 2.3、记录新的 indexPath
            sourceIndexPath = indexPath
            // 2.4、通知titleView进行调整位置
            titleView.adjustTitleContentOfSetX(targetIndex: indexPath.section)
        }
        // 3.根据 indexPath 设置 pageControll
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

extension JKPageCollectionView: JKTitleViewDelegate {
    func clickTitleView(_ pageView: JKTitleView, targetIndex: Int) {
        isForbidScroll = true
        collectionView.scrollToItem(at: IndexPath(item: 0, section: targetIndex), at: .left, animated: true)
        collectionView.contentOffset.x -= layout.sectionInset.left
        pageControl.currentPage = 0
    }
}

// MARK:- 对外暴露注册方式
extension JKPageCollectionView {
    /// 类注册
    public func register(cell: AnyClass, identifier: String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    /// xib 注册
    public func register(nib: UINib, identifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    /// 重新访问数据源（刷新数据）
    public func reloadData() {
        collectionView.reloadData()
    }
}
