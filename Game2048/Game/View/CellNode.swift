//
//  CellNode.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import SpriteKit

class CellNode: SKNode {
    
    fileprivate let _labelNode = SKLabelNode()
    
    init(number: Int, size: CGSize) {
        super.init()
        
        let backgroundNode = SKShapeNode(rectOf: size, cornerRadius: 5)
        backgroundNode.fillColor = YellowColor
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(backgroundNode)
        
        if number == 0 {
            _labelNode.text = ""
        } else {
            _labelNode.text = DataManager.shared.titleList[number-1]
        }
        
        _labelNode.fontColor = BlackColor
        _labelNode.fontSize = 30
        _labelNode.verticalAlignmentMode = .center
        _labelNode.position = CGPoint(x: backgroundNode.frame.midX, y: backgroundNode.frame.midY)
        addChild(_labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public - Methods
extension CellNode {
    func updateNumber(number: Int) {
        _labelNode.text = DataManager.shared.titleList[number-1]
    }
}
