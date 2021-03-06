## JKPageView
Swift的标题滚动组件

## <a id="How_to_use_JKPageView"></a>How to use JKPageView

* Installation with CocoaPods：`pod 'JKPageView'`
* Installation with [Carthage](https://github.com/Carthage/Carthage)：`github "JoanKing/JKPageView"`

      主要类： 
      JKPageView：传控制器的分组
      JKPageCollectionView：多个collectionView的分组
      JKTitleStyle：样式
- 使用方式一，如下：

     ![](https://upload-images.jianshu.io/upload_images/1728484-648cd156898b86a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

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
      
- 使用方式二，如下：

    ![JKPageCollectionView](https://upload-images.jianshu.io/upload_images/1728484-b78ac5b1f8d3789f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

      let titles = ["推荐", "LooK直播", "官方", "饭圈营业", "现场", "翻唱", "广场", "舞蹈"]
        
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
      
- 使用方式三，如下：

    ![自定义视图](https://upload-images.jianshu.io/upload_images/1728484-96fb321cde7e84ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
    
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
        
