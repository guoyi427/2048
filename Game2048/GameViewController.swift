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
    
    //  UI
    fileprivate let _scene = SKScene(size: ScreenSize)
    
    //  Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.backgroundColor = UIColor.white
            
            prepareScene(view: view)
            prepareMatrixNode()
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        debugPrint(DataManager.shared.titleList)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Prepare
extension GameViewController {
    
    /// 准备游戏场景
    fileprivate func prepareScene(view: SKView) {
        _scene.scaleMode = .aspectFill
        _scene.backgroundColor = SKColor.lightGray
        view.presentScene(_scene)
        
        //  准备 四个方向的手势
        let directions: [UISwipeGestureRecognizerDirection] = [.left, .right, .down, .up]
        for direction in directions {
            let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeViewGestureRecognizerAction(sender:)))
            swipeGR.direction = direction
            view.addGestureRecognizer(swipeGR)
        }
    }
    
    /// 准备矩阵视图
    fileprivate func prepareMatrixNode() {
        let matrixNode = MatrixNodeManager.shared.creatMatrixNode(rect: CGRect(x: 10, y: 60, width: ScreenWidth - 20, height: ScreenWidth - 20))
        _scene.addChild(matrixNode)
    }
}

// MARK: - Private - Methods
extension GameViewController {
    
}

// MARK: - GestureRecognizer - Action
extension GameViewController {
    @objc
    fileprivate func swipeViewGestureRecognizerAction(sender: UISwipeGestureRecognizer) {
        MatrixNodeManager.shared.swipeGestureRecognizerAction(direction: sender.direction)
    }
}
