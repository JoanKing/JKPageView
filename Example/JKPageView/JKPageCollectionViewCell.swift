//
//  JKPageCollectionViewCell.swift
//  JKPageView_Example
//
//  Created by 王冲 on 2020/7/24.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class JKPageCollectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel(frame: self.contentView.bounds)
        label.textColor = .yellow
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
