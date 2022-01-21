//
//  AppDelegate.swift
//  JKPageView
//
//  Created by JoanKing on 07/21/2020.
//  Copyright (c) 2020 JoanKing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 15.0, *) {
            let app = UINavigationBarAppearance()
            // 重置背景和阴影颜色
            app.configureWithOpaqueBackground()
            app.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.brown
            ]
            app.backgroundColor = UIColor.white// 设置导航栏背景色
            app.shadowColor = .clear
            app.backgroundEffect = nil
            // 带scroll滑动的页面
            UINavigationBar.appearance().scrollEdgeAppearance = app
            // 常规页面，描述导航栏以标准高度
            UINavigationBar.appearance().standardAppearance = app
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()
        
        return true
    }


}
