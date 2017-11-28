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
    fileprivate let _currentScoreLabel = SKLabelNode(text: "0")
    fileprivate let _maxScoreLabel = SKLabelNode(text: "0")
    
    //  Data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.backgroundColor = UIColor.white
            
            prepareScene(view: view)
            prepareHeadNode()
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
    
    fileprivate func prepareHeadNode() {
        let height_headNode: CGFloat = 150
        let headNode = SKShapeNode(rect: CGRect(x: 0, y: ScreenHeight - height_headNode, width: ScreenWidth, height: height_headNode), cornerRadius: 0)
        headNode.fillColor = YellowColor
        _scene.addChild(headNode)
        
        let width_score: CGFloat = 120
        let height_score: CGFloat = 50
        let currentView = SKShapeNode(rect: CGRect(x: ScreenWidth - width_score - 20, y: ScreenHeight - height_score - 20, width: width_score, height: height_score))
        currentView.fillColor = SKColor.white
        headNode.addChild(currentView)
        
        let currentTitleLabel = SKLabelNode(text: "当前分数")
        currentTitleLabel.fontColor = SKColor.black
        currentTitleLabel.fontSize = 12
        currentTitleLabel.position = CGPoint(x: currentView.frame.minX + width_score/2, y: currentView.frame.minY + height_score/2 + 10)
        currentView.addChild(currentTitleLabel)
        
        _currentScoreLabel.fontColor = SKColor.black
        _currentScoreLabel.fontSize = 14
        _currentScoreLabel.fontName = TitleFontName
        _currentScoreLabel.position = CGPoint(x: currentView.frame.minX + width_score/2, y: currentView.frame.minY + height_score/2 - 10)
        currentView.addChild(_currentScoreLabel)
        
        
        
        
        //  撤销按钮
        let undoButton = SKButtonNode(rect: CGRect(x: currentView.frame.minX, y: currentView.frame.minY - 50, width: currentView.frame.width, height: 35), cornerRadius: 3)
        undoButton.fillColor = YellowColor
        undoButton.addTarget(target: self, selector: #selector(undoButtonAction(sender:)))
        headNode.addChild(undoButton)
        
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

// MARK: - GestureRecognizer & Button - Action
extension GameViewController {
    @objc
    fileprivate func swipeViewGestureRecognizerAction(sender: UISwipeGestureRecognizer) {
        MatrixNodeManager.shared.swipeGestureRecognizerAction(direction: sender.direction)
    }
    
    @objc
    fileprivate func undoButtonAction(sender: SKButtonNode) {
        debugPrint(sender)
    }
}
