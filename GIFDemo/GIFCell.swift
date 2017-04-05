//
//  gifCell.swift
//  GIFDemo
//
//  Created by Kaibo Lu on 2017/4/5.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class GIFCell: UITableViewCell {

    static let cellHeight: CGFloat = 120
    
    var gifView: FLAnimatedImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        gifView = FLAnimatedImageView(frame: CGRect(x: 10, y: 10, width: 300, height: 100))
        gifView.runLoopMode = RunLoopMode.defaultRunLoopMode.rawValue
        gifView.contentMode = .scaleAspectFit
        contentView.addSubview(gifView)
    }

}
