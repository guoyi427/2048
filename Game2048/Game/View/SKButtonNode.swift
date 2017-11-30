//
//  SKButtonNode.swift
//  Game2048
//
//  Created by kokozu on 28/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import SpriteKit

class SKButtonNode: SKShapeNode {

    var target: AnyObject?
    var selector: Selector?
    
    fileprivate let _titleLabel = SKLabelNode(text: "")
    
    override init() {
        super.init()
        _titleLabel.fontSize = 14
        _titleLabel.verticalAlignmentMode = .center
        _titleLabel.fontColor = SKColor.white
        addChild(_titleLabel)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target : AnyObject, selector: Selector) {
        self.target = target
        self.selector = selector
        self.isUserInteractionEnabled = true
    }
    
    func updateTitle(text: String) {
        _titleLabel.text = text
        _titleLabel.position = CGPoint(x: position.x + frame.midX, y: position.y + frame.midY)
    }
}

// MARK: - Touch - Delegate
extension SKButtonNode {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let n_tar = self.target, let n_sel = self.selector {
            _ = n_tar.perform(n_sel, with: self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
