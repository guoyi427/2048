//
//  GameViewController.swift
//  Game2048
//
//  Created by kokozu on 21/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    fileprivate let _scene = SKScene(size: UIScreen.main.bounds.size)
    
    fileprivate var _nodel: SKNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            prepareScene(view: view)
            prepareChildNode()
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Prepare
extension GameViewController {
    fileprivate func prepareScene(view: SKView) {
        _scene.scaleMode = .aspectFill
        view.presentScene(_scene)
        
        let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeViewGestureRecognizerAction))
        view.addGestureRecognizer(swipeGR)
    }
    
    fileprivate func prepareChildNode() {
        
        let node = SKShapeNode(rectOf: CGSize(width: 10, height: 10), cornerRadius: 3)
        node.position = view.center
        node.fillColor = UIColor.red
        _scene.addChild(node)
        _nodel = node
    }
}

// MARK: - GestureRecognizer - Action
extension GameViewController {
    @objc
    fileprivate func swipeViewGestureRecognizerAction() {
        if let node = _nodel {
            node.run(SKAction.move(to: CGPoint(x: 200, y: 200), duration: 0.25))
        }
    }
}
