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
    
    let contentView = UIView(frame: CGRect.zero)

    
    var buttonClick: (_ index: Int) -> Void
    

    init(callback: @escaping (_ index: Int) -> Void) {
        buttonClick = callback
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        contentView.backgroundColor = BackgroundColor
        contentView.layer.cornerRadius = CornerRadius
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.centerY.equalToSuperview()
            make.height.equalTo(230)
        }
        
        let titles:[String] = ["4x4", "6x6", "8x8"]
        for i in 0...2 {
            let btn = UIButton(type: .custom)
            btn.addTarget(self, action: #selector(menuButtonAction(button:)), for: .touchUpInside)
            btn.setTitle(titles[i], for: .normal)
            btn.backgroundColor = HeadButtonColor
            btn.frame = CGRect(x: 10, y: 10 + i * 60, width: Int(frame.width - 100), height: 50)
            btn.tag = 200 + i
            btn.layer.cornerRadius = CornerRadius
            contentView.addSubview(btn)
        }
        
        prepareAboutMe()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    fileprivate func prepareAboutMe() {
        let qqLabel = UILabel(frame: CGRect.zero)
        qqLabel.text = "QQ群:"
        qqLabel.textColor = GrayTextColor
        qqLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(qqLabel)
        
        let qqNumberLabel = UILabel(frame: CGRect.zero)
        qqNumberLabel.text = "21770500"
        qqNumberLabel.textColor = BlackTextColor
        qqNumberLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(qqNumberLabel)
        
        qqLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        qqNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(qqLabel.snp.right).offset(10)
            make.bottom.equalTo(qqLabel)
        }
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
