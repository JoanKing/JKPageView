# JKPageView
Swift组件的标题滚动组件

- 导入方式
    
    pod 'JKPageView'


- 使用方式如下：

    导入 import JKPageView 即可使用


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
