//
//  ViewController.swift
//  JKPageView
//
//  Created by JoanKing on 07/21/2020.
//  Copyright (c) 2020 JoanKing. All rights reserved.
//

import UIKit
import JKPageView

fileprivate let kViewControllerCellID = "kViewControllerCellID"

class ViewController: UIViewController {

    var titles: [String] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame:CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - UIApplication.shared.statusBarFrame.height - 44), style: .grouped)
        if #available(iOS 11, *) {
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }
        // tableview的背景色
        tableView.backgroundColor = UIColor.white
        // tableview挂代理
        tableView.delegate = self
        tableView.dataSource = self
        // tableview的分割方式
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kViewControllerCellID)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JKPageView的使用"
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = .white
        titles = ["JKPageView样式", "JKPageCollectionView样式"]
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kViewControllerCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        if title == "JKPageView样式" {
            let pageViewViewController = JKPageViewViewController()
            navigationController?.pushViewController(pageViewViewController, animated: true)
        } else if title == "JKPageCollectionView样式" {
            let pageViewController = JKPageCollectionViewController()
            navigationController?.pushViewController(pageViewController, animated: true)
        } else {
            print("----等待更新----")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}


