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
    /// 记录保存前的滑动次数 （每执行50次 自动保存一次，除此之外退到后台会自动保存一次）
    fileprivate var _swipeCountBeforeSave: Int = 0
    
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
        
        uploadView()
        debugPrint(GameDataManager.shared.titleList)
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
        
        //  当前分数
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
        undoButton.fillColor = BrownColor
        undoButton.updateTitle(text: "撤销")
        undoButton.addTarget(target: self, selector: #selector(undoButtonAction(sender:)))
        headNode.addChild(undoButton)
        
        //  最大分数
        let maxView = SKShapeNode(rect: CGRect(x: currentView.frame.minX - 20 - width_score, y: currentView.frame.minY, width: width_score, height: height_score))
        maxView.fillColor = SKColor.white
        headNode.addChild(maxView)
        
        let maxTitleLabel = SKLabelNode(text: "最大分数")
        maxTitleLabel.fontColor = SKColor.black
        maxTitleLabel.fontSize = 12
        maxTitleLabel.position = CGPoint(x: maxView.frame.minX + width_score/2, y: maxView.frame.minY + height_score/2 + 10)
        maxView.addChild(maxTitleLabel)
        
        _maxScoreLabel.fontColor = SKColor.black
        _maxScoreLabel.fontSize = 14
        _maxScoreLabel.fontName = TitleFontName
        _maxScoreLabel.position = CGPoint(x: maxView.frame.minX + width_score/2, y: maxView.frame.minY + height_score/2 - 10)
        maxView.addChild(_maxScoreLabel)
        
        //  重新开始按钮
        let restartButton = SKButtonNode(rect: CGRect(x: maxView.frame.minX, y: maxView.frame.minY - 50, width: maxView.frame.width, height: 35),
                                         cornerRadius: 3)
        restartButton.fillColor = BrownColor
        restartButton.updateTitle(text: "重新开始")
        restartButton.addTarget(target: self, selector: #selector(restartButtonAction(sender:)))
        headNode.addChild(restartButton)
    }
    
    /// 准备矩阵视图
    fileprivate func prepareMatrixNode() {
        let matrixNode = MatrixNodeManager.shared.creatMatrixNode(rect: CGRect(x: 10, y: 60, width: ScreenWidth - 20, height: ScreenWidth - 20))
        _scene.addChild(matrixNode)
    }
}

// MARK: - Private - Methods
extension GameViewController {
    fileprivate func uploadView() {
        //  刷新页面
        GameDataManager.shared.queryHistory()
        MatrixNodeManager.shared.upload()
        _currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
        _maxScoreLabel.text = "\(GameDataManager.shared.maxScore)"
    }
}

// MARK: - GestureRecognizer & Button - Action
extension GameViewController {
    /// 上下左右滑动手势
    @objc fileprivate func swipeViewGestureRecognizerAction(sender: UISwipeGestureRecognizer) {
        MatrixNodeManager.shared.swipeGestureRecognizerAction(direction: sender.direction)
        //  更新分数
        _currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
        _maxScoreLabel.text = "\(GameDataManager.shared.maxScore)"
        
        //  每执行50次 自动保存一次，除此之外退到后台会自动保存一次
        if _swipeCountBeforeSave >= 50 {
            GameDataManager.shared.saveToFile()
            _swipeCountBeforeSave = 0
        }
        _swipeCountBeforeSave += 1
    }
 
    /// 撤销按钮 返回上一步
    @objc fileprivate func undoButtonAction(sender: SKButtonNode) {
        GameDataManager.shared.undo()
        //  刷新页面
        MatrixNodeManager.shared.upload()
        _currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
    }

    /// 重新开始
    @objc fileprivate func restartButtonAction(sender: SKButtonNode) {
        let doneAction = UIAlertAction(title: "确定", style: .default) { [weak self] (action) in
            GameDataManager.shared.restart()
            MatrixNodeManager.shared.upload()
            guard let weakSelf = self else { return }
            weakSelf._currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
            weakSelf._maxScoreLabel.text = "\(GameDataManager.shared.maxScore)"
        }
        let cancelAtion = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "重新开始", message: "将会删除现在的所有记录", preferredStyle: .alert)
        alert.addAction(doneAction)
        alert.addAction(cancelAtion)
        present(alert, animated: true, completion: nil)
    }
}
