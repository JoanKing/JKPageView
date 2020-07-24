//
//  JKContentView.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit
import Foundation
/// 标识
private let kContentCellID = "kContentCellID"

protocol JKContentViewDelegate: class {
    func scrollContentView(_ contentView: JKContentView, targetIndex: Int)
    func scrollContentView(sourceIndex: Int,targetIndex: Int, progress: CGFloat)
}

class JKContentView: UIView {
    var currentTitleBlock: CurrentTitleBlock?
    /// 是否禁止
    fileprivate var isForbidScroll: Bool = false
    /// 滚动的代理
    weak var delegate: JKContentViewDelegate?
    // 子控制器
    fileprivate var childVcs: [UIViewController]
    // 父控制器
    fileprivate var parentVc: UIViewController
    /// 创建CollectionView
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // item 的宽高
        layout.itemSize = self.bounds.size
        // 间距设置
        layout.minimumLineSpacing = 0
        // 设置水平滚动
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        // 支持分页
        collectionView.isPagingEnabled = true
        // 不支持弹性
        collectionView.bounces = false
        // 取消点状态栏滚动到顶部
        collectionView.scrollsToTop = false
        // 去掉水平滚动条
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
        return collectionView
    }()
    
    /// 开始拖拽的位置
    fileprivate var startOffSetX: CGFloat = 0
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JKContentView {
    
    fileprivate func setupUI() {
        // 1.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChild(childVc)
        }
        
        // 2.添加UICollectionView用于展示内容
        addSubview(collectionView)
    }
}

extension JKContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
      
        // 移除掉之前的，防止重复添加
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        // cell 上添加控制器的 view
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension JKContentView: UICollectionViewDelegate {
    // 当滚动视图已经结束减速时被系统自动调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    // 当滚动视图已经结束拖拽时被系统自动调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // 没有减速就代表滚动停止了
            contentEndScroll()
        }
    }
    
    // 开始拖拽的那一刻
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScroll = false
        
        // 记录刚开始拖拽的 X 值
        startOffSetX = scrollView.contentOffset.x
    }
    
    // 监听实时滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0.判断是否是禁止状态
        guard !isForbidScroll else {
            return
        }
        
        // 先判断和开始的偏移量是否一致
        guard startOffSetX != scrollView.contentOffset.x else {
            return
        }
        
        // 1.定义targetIndex/progress
        var targetIndex: Int = 0
        var sourceIndex : Int = 0
        var progress: CGFloat = 0.0
        
        // 2.给targetIndex/progress赋值
        // 判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if startOffSetX < scrollView.contentOffset.x {
            // 左滑动
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            // progress = (currentOffsetX - startOffSetX) / scrollView.bounds.width
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
                progress = 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffSetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        } else {
            // 右滑动
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            // progress = (startOffSetX - scrollView.contentOffset.x) / scrollView.bounds.width
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 处理系统的bug
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.通知代理
        if self.delegate != nil {
            self.delegate?.scrollContentView(sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
        }
    }
    
    /// 停止了滚动
    func contentEndScroll() {
        
        // 1、获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 2、通知titleView进行调整
        if self.delegate != nil {
            self.delegate?.scrollContentView(self, targetIndex: currentIndex)
        }
    }
}

// MARK:- 遵守title的协议
extension JKContentView: JKTitleViewDelegate {
    
    func clickTitleView(_ pageView: JKTitleView, targetIndex: Int) {
        
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
