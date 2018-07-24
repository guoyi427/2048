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
    fileprivate var _undoButton: SKButtonNode!
    
    fileprivate let height_headNode: CGFloat = 150 + Constant.topArea

    
    //  Data
    /// 记录保存前的滑动次数 （每执行50次 自动保存一次，除此之外退到后台会自动保存一次）
    fileprivate var _swipeCountBeforeSave: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            prepareScene(view: view)
            prepareHeadNode()
            prepareMatrixNode()
            
            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
        }
        
        uploadView()
        debugPrint(GameDataManager.shared.titleList)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
}

// MARK: - Prepare
extension GameViewController {
    /// 准备游戏场景
    fileprivate func prepareScene(view: SKView) {
        _scene.scaleMode = .aspectFill
        _scene.backgroundColor = BackgroundColor
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
        let headNode = SKShapeNode(rect: CGRect(x: 0, y: ScreenHeight - height_headNode, width: ScreenWidth, height: height_headNode))
        headNode.lineWidth = 0
        headNode.fillColor = BackgroundColor
        _scene.addChild(headNode)
        
        let width_score: CGFloat = ScreenWidth / 3 - 20
        let height_score: CGFloat = 50
        let height_button: CGFloat = 35
        let cornerRadius: CGFloat = 5
        let padding: CGFloat = 10
        
        //  撤销按钮
        _undoButton = SKButtonNode(rect: CGRect(x: ScreenWidth - width_score - padding, y: headNode.frame.minY, width: width_score, height: height_button), cornerRadius: cornerRadius)
        _undoButton.fillColor = HeadButtonColor
        _undoButton.updateTitle(text: "撤销（\(UndoMaxCount)）")
        _undoButton.addTarget(target: self, selector: #selector(undoButtonAction(sender:)))
        headNode.addChild(_undoButton)
        //  获取当前可撤销次数
        let undoCount = UserDefaults.standard.value(forKey: kUserDefault_UndoCount) as? Int ?? 0
        _undoButton.updateTitle(text: "撤销（\(undoCount)）")
        
        //  当前分数
        let currentView = SKShapeNode(rect: CGRect(x: _undoButton.frame.minX, y: _undoButton.frame.maxY + padding, width: _undoButton.frame.width, height: height_score), cornerRadius: cornerRadius)
        currentView.fillColor = ScoreLabelColor
        headNode.addChild(currentView)
        
        let currentTitleLabel = SKLabelNode(text: "当前分数")
        currentTitleLabel.fontColor = SKColor.white
        currentTitleLabel.fontSize = 12
        currentTitleLabel.position = CGPoint(x: currentView.frame.minX + width_score/2, y: currentView.frame.minY + height_score/2 + 10)
        
        currentView.addChild(currentTitleLabel)
        
        _currentScoreLabel.fontColor = SKColor.white
        _currentScoreLabel.fontSize = 14
        _currentScoreLabel.fontName = TitleFontName
        _currentScoreLabel.position = CGPoint(x: currentView.frame.minX + width_score/2, y: currentView.frame.minY + height_score/2 - 10)
        currentView.addChild(_currentScoreLabel)
        
        //  最大分数
        let maxView = SKShapeNode(rect: CGRect(x: currentView.frame.minX - padding - width_score, y: currentView.frame.minY, width: width_score, height: height_score), cornerRadius: cornerRadius)
        maxView.fillColor = ScoreLabelColor
        headNode.addChild(maxView)
        
        let maxTitleLabel = SKLabelNode(text: "最大分数")
        maxTitleLabel.fontColor = SKColor.white
        maxTitleLabel.fontSize = 12
        maxTitleLabel.position = CGPoint(x: maxView.frame.minX + width_score/2, y: maxView.frame.minY + height_score/2 + 10)
        maxView.addChild(maxTitleLabel)
        
        _maxScoreLabel.fontColor = SKColor.white
        _maxScoreLabel.fontSize = 14
        _maxScoreLabel.fontName = TitleFontName
        _maxScoreLabel.position = CGPoint(x: maxView.frame.minX + width_score/2, y: maxView.frame.minY + height_score/2 - 10)
        maxView.addChild(_maxScoreLabel)
        
        //  重新开始按钮
        let restartButton = SKButtonNode(rect: CGRect(x: maxView.frame.minX, y: _undoButton.frame.minY, width: maxView.frame.width, height: _undoButton.frame.height), cornerRadius: cornerRadius)
        restartButton.fillColor = HeadButtonColor
        restartButton.updateTitle(text: "重新开始")
        restartButton.addTarget(target: self, selector: #selector(restartButtonAction(sender:)))
        headNode.addChild(restartButton)
        
        //  分享按钮
        let shareButton = SKButtonNode(rect: CGRect(x: padding, y: _undoButton.frame.minY, width: maxView.frame.minX - padding * 2, height: height_button), cornerRadius: cornerRadius)
        shareButton.fillColor = HeadButtonColor
        shareButton.updateTitle(text: "分享")
        shareButton.addTarget(target: self, selector: #selector(shareButtonAction(sender:)))
        headNode.addChild(shareButton)
        
        //  菜单
        let menuButton = SKButtonNode(rect: CGRect(x: padding, y: maxView.frame.minY, width: maxView.frame.minX - padding * 2, height: maxView.frame.height), cornerRadius: cornerRadius)
        menuButton.fillColor = HeadMenuColor
        menuButton.updateTitle(text: "菜单")
        menuButton.addTarget(target: self, selector: #selector(menuButtonAction(sender:)))
        headNode.addChild(menuButton)
    }
    
    /// 准备矩阵视图
    fileprivate func prepareMatrixNode() {
        let padding: CGFloat = 10
        let width_matrix: CGFloat = ScreenWidth - padding * 2
        let height_matrix: CGFloat = width_matrix
        
        let matrixNode =
            MatrixNodeManager.shared.creatMatrixNode(rect: CGRect(x: padding, y: (ScreenHeight - height_headNode - height_matrix)/2, width: width_matrix, height: height_matrix))
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
        //  判断是否有可用次数   一共三次，用光之后弹出广告赠送三次
        if let count = UserDefaults.standard.value(forKey: kUserDefault_UndoCount) as? Int, count > 0 {
            //  还有可用次数
            UserDefaults.standard.setValue(count - 1, forKey: kUserDefault_UndoCount)
            UserDefaults.standard.synchronize()
            
            //  更新撤销按钮的剩余次数
            _undoButton.updateTitle(text: "撤销（\(count - 1)）")
            
            //  开始撤销
            GameDataManager.shared.undo()
            //  刷新页面
            MatrixNodeManager.shared.upload()
            _currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
            
        } else {
            //  无可用次数 弹出广告前的提示框
            let doneAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
                AdsManager.instance.showInterstitial(viewController: self, complete: { [weak self] (result) in
                    if result {
                        //  更新撤销按钮的剩余次数
                        UserDefaults.standard.setValue(UndoMaxCount, forKey: kUserDefault_UndoCount)
                        UserDefaults.standard.synchronize()
                        
                        self!._undoButton.updateTitle(text: "撤销（\(UndoMaxCount)）")
                    } else {
                        //  跳转广告失败
                        let knowAction = UIAlertAction(title: "知道了", style: .default, handler: nil)
                        let notClickAlert = UIAlertController(title: "您没有点击广告", message: "请点击广告跳转到浏览器后直接返回即可", preferredStyle: .alert)
                        notClickAlert.addAction(knowAction)
                        self!.present(notClickAlert, animated: true, completion: nil)
                    }
                })
            })
            let cancelAction = UIAlertAction(title: "不需要", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "您的撤销次数已用光", message: "麻烦您点击广告跳转，可获得三次撤销机会，感谢", preferredStyle: .alert)
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    /// 重新开始
    @objc fileprivate func restartButtonAction(sender: SKButtonNode) {
        let doneAction = UIAlertAction(title: "确定", style: .default) { [weak self] (action) in
            GameDataManager.shared.restart()
            MatrixNodeManager.shared.upload()
            guard let weakSelf = self else { return }
            weakSelf._currentScoreLabel.text = "\(GameDataManager.shared.currentScore)"
            weakSelf._maxScoreLabel.text = "\(GameDataManager.shared.maxScore)"
            
            //  重新开始后 很抱歉 我要添加一个广告
            AdsManager.instance.showInterstitial(viewController: weakSelf, complete: { (result) in
                debugPrint("is leave app \(result)")
            })
        }
        let cancelAtion = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "重新开始", message: "将会删除现在的所有记录", preferredStyle: .alert)
        alert.addAction(doneAction)
        alert.addAction(cancelAtion)
        present(alert, animated: true, completion: nil)
    }
    
    /// 分享按钮
    @objc fileprivate func shareButtonAction(sender: SKButtonNode) {
        let wechatAction = UIAlertAction(title: "微信朋友", style: .default) { (action) in
            
        }
        let pengYouQuanAction = UIAlertAction(title: "微信朋友圈", style: .default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        let actionSheet = UIAlertController(title: "分享", message: "炫耀一下吧", preferredStyle: .actionSheet)
        actionSheet.addAction(wechatAction)
        actionSheet.addAction(pengYouQuanAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    /// 菜单按钮
    @objc fileprivate func menuButtonAction(sender: SKButtonNode) {
        
    }
}
