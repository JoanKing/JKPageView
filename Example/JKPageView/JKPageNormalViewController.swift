//
//  JKPageNormalViewController.swift
//  JKPageView_Example
//
//  Created by IronMan on 2020/9/18.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import JKPageView
class JKPageNormalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = []
        // 1.标题
        let titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈", "现场", "翻唱", "广场", "舞蹈"]
        
        // 2.所有的子控制器
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        // 自定义一个 view
        let normalView = UIView(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 0, width: 100, height: 60))
        normalView.backgroundColor = .brown
        
        let style = JKTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.isNeedScale = false
        style.isShowSplitLine = true
        style.splitLineHeight = 1
        style.showStyle = .customStyle
        style.titleHeight = 60
        style.titleWidth = UIScreen.main.bounds.width - 100
        style.normalView = normalView
        
        // 3.pageView的frame
        let pageFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - UIApplication.shared.statusBarFrame.height - 44)
        
        // 4.创建JKPageView，并且添加到控制器 view 中
        let pageView = JKPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style: style)
        pageView.delegate = self
        view.addSubview(pageView)
    }
    
}

extension JKPageNormalViewController: JKPageViewDelegate {
    
    func currentTitleIndex(targetIndex: Int) {
         // print("当前是第 \(targetIndex) 个标题 ")
    }
}
