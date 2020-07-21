//
//  ViewController.swift
//  JKPageView
//
//  Created by JoanKing on 07/21/2020.
//  Copyright (c) 2020 JoanKing. All rights reserved.
//

import UIKit
import JKPageView
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = .green
        
        // 1.标题
        let titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈"]
        
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
