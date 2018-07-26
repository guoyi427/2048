//
//  MenuView.swift
//  Game2048
//
//  Created by 默认 on 2018/7/26.
//  Copyright © 2018年 guoyi. All rights reserved.
//

import UIKit
import SnapKit

class MenuView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var buttonClick: (_ index: Int) -> Void
    

    init(callback: @escaping (_ index: Int) -> Void) {
        buttonClick = callback
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        let contentView = UIView(frame: CGRect.zero)
        contentView.backgroundColor = HeadMenuColor
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(150)
            make.bottom.equalTo(-150)
        }
        
        let titles:[String] = ["4x4", "6x6", "8x8"]
        for i in 0...2 {
            let btn = UIButton(type: .custom)
            btn.addTarget(self, action: #selector(menuButtonAction(button:)), for: .touchUpInside)
            btn.setTitle(titles[i], for: .normal)
            btn.backgroundColor = HeadButtonColor
            btn.frame = CGRect(x: 10, y: 10 + i * 60, width: Int(frame.width - 100), height: 50)
            btn.tag = 200 + i
            contentView.addSubview(btn)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
}

extension MenuView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
}

// MARK: - Button Action
extension MenuView {
    @objc
    fileprivate func menuButtonAction(button: UIButton) {
        buttonClick(button.tag - 200)
        removeFromSuperview()
    }
}
