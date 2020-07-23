//
//  JKPageCollectionViewLayout.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/23.
//

import UIKit

public class JKPageCollectionViewLayout: UICollectionViewFlowLayout {

    /// 几列，默认 4 列
    var cols: Int = 4
    /// 几行，默认 2 行
    var rows: Int = 2
    /// 保存 UICollectionViewlazyLayoutAttributes 的数组
    fileprivate lazy var cellAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    /// 最大的宽度
    fileprivate lazy var maxWith: CGFloat = 0
    
}

extension JKPageCollectionViewLayout {
    public override func prepare() {
        super.prepare()
        
        // 0.计算item的宽和高
        let itemW: CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH: CGFloat = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        // 每页的数量
        let pageNumber = cols * rows
        
        // 1.获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        // 2.获取每组中有多少个Item
        // 前面有几页
        var prePageCount: Int = 0
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                // 2.1、获取cell对应的indexPath
                let indexPath = IndexPath(item: j, section: i)
                // 2.2、根据indexPath创建 UICollectionViewLayoutAttributes
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                // 2.3、item位置计算
                // 计算 j 在该组中第几页
                let page = j / pageNumber
                // 在第几页的第几个
                let index = j % pageNumber
                // 在某一页的第几行
                let rowIndex = index / cols
                // 在某一页的第几列
                let colsIndex = index % cols
                
                // item的X
                let itemX: CGFloat = CGFloat(prePageCount + page) * collectionView!.bounds.width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(colsIndex)
                // item的Y
                let itemY: CGFloat = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat(rowIndex)
    
                // 2.4、设置 attr 的frame
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            
                // 保存下来
                cellAttributes.append(attr)
            }
            
            prePageCount += (itemCount - 1) / (cols * rows) + 1
        }
        maxWith = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension JKPageCollectionViewLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes
    }
}

extension JKPageCollectionViewLayout {
    public override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWith, height: 0)
    }
}
