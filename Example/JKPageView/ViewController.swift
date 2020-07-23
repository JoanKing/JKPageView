//
//  ViewController.swift
//  JKPageView
//
//  Created by JoanKing on 07/21/2020.
//  Copyright (c) 2020 JoanKing. All rights reserved.
//

import UIKit
import JKPageView
/// 标识
private let kAnchorViewControllerCellID = "AnchorViewController"
class ViewController: UIViewController {

    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = .green
        
        titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈"]
        
        let style = JKTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.collectionViewBackgroundColor = .yellow
        
        let layout = JKPageCollectionViewLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        
        let pageCollectionView = JKPageCollectionView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200), titles: titles, style: style, isTitleInTop: false, layout: layout)
        pageCollectionView.dataSource = self
        pageCollectionView.register(cell: UICollectionViewCell.self, identifier: kAnchorViewControllerCellID)
        view.addSubview(pageCollectionView)
    }
}

// MARK:- JKPageCollectionViewDataSoure 代理
extension ViewController: JKPageCollectionViewDataSoure {
    func pageNumberOfSections(in collectionView: UICollectionView) -> Int {
        return titles.count
    }
    
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19
    }
    
    func pageCollectionView(pageCollectionView: JKPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorViewControllerCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击的第 \(indexPath.section) 组 第 \(indexPath.row) 个")
    }
}

extension ViewController {
    func test1() {
        // 1.标题
        let titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈"]
        
        // 2.所有的子控制器
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let style = JKTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.isNeedScale = false
        style.isShowSplitLine = true
        style.splitLineHeight = 1
        style.showStyle = .coverStyle
        
        // 3.pageView的frame
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        // 4.创建JKPageView，并且添加到控制器 view 中
        let pageView = JKPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        pageView.delegate = self
        view.addSubview(pageView)
    }
}

extension ViewController: JKPageViewDelegate {
    
    func clickTitleView(targetIndex: Int) {
        print("---------点击了：第 \(targetIndex) 个")
    }
}
