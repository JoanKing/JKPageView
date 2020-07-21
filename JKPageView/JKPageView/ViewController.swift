//
//  ViewController.swift
//  JKPageView
//
//  Created by 王冲 on 2020/7/20.
//  Copyright © 2020 王冲. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .green
        
        // 1.标题
        let titles = ["游戏", "娱乐活动", "趣玩", "美女才艺", "颜值报表", "日常活动"]
        
        // 2.所有的子控制器
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.JKRandomColor()
            childVcs.append(vc)
        }
        
        let style = JKTitleStyle()
        style.isScrollEnable = true
        style.isShowScrollLine = true
        style.isNeedScale = true
        style.isShowSplitLine = true
        style.splitLineHeight = 1
        style.isShowCover = true
        
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

