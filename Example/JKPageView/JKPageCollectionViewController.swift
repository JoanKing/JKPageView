//
//  JKPageCollectionViewViewController.swift
//  JKPageView_Example
//
//  Created by 王冲 on 2020/7/24.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JKPageView
/// 标识
private let kJKPageCollectionViewViewCellID = "kJKPageCollectionViewViewCellID"
class JKPageCollectionViewController: UIViewController {
    var titles: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        
        titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈"]
        
        let style = JKTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.collectionViewBackgroundColor = .yellow
        style.titleViewBackgroundColor = .yellow
        style.pageIndicatorTintColor = .blue
        style.pageControlCurrentPageColor = .red
        
        let layout = JKPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        
        let pageCollectionView = JKPageCollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200), titles: titles, style: style, isTitleInTop: false, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .brown
        pageCollectionView.register(cell: JKPageCollectionViewCell.self, identifier: kJKPageCollectionViewViewCellID)
        view.addSubview(pageCollectionView)
    }
}

// MARK:- JKPageCollectionViewDataSoure 代理
extension JKPageCollectionViewController: JKPageCollectionViewDataSoure {
    
    func currentTitleIndex(targetIndex: Int) {
        print("当前是第 \(targetIndex) 个标题 ")
    }
    
    func pageNumberOfSections(in collectionView: UICollectionView) -> Int {
        return titles.count
    }
    
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kJKPageCollectionViewViewCellID, for: indexPath) as! JKPageCollectionViewCell
        cell.backgroundColor = UIColor.randomColor()
        cell.label.text = "\(indexPath.section)-\(indexPath.row)"
        return cell
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击的第 \(indexPath.section) 组 第 \(indexPath.row) 个")
    }
}
