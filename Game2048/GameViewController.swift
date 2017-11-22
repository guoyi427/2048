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
    fileprivate let _containeNode = SKShapeNode(rect: CGRect(x: 10, y: 60, width: ScreenWidth - 20, height: ScreenWidth - 20), cornerRadius: 5)
    
    //  Data
    fileprivate let Padding: CGFloat = 10.0
    fileprivate var _cellNodeList: [[CellNode]] = [[],[],[],[],[],[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            view.backgroundColor = UIColor.white
            
            prepareScene(view: view)
            prepareBackgroundNode()
            prepareChildNode()
            
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
    
    fileprivate func prepareScene(view: SKView) {
        _scene.scaleMode = .aspectFill
        view.presentScene(_scene)
        
        let directions: [UISwipeGestureRecognizerDirection] = [.left, .right, .down, .up]
        for direction in directions {
            let swipeGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeViewGestureRecognizerAction(sender:)))
            swipeGR.direction = direction
            view.addGestureRecognizer(swipeGR)
        }
    }
    
    fileprivate func prepareBackgroundNode() {
        _containeNode.fillColor = SKColor.white
        _scene.addChild(_containeNode)
    }
    
    fileprivate func prepareChildNode() {
        
        for column in 0...DataManager.shared.currentModelList.count - 1 {
            let modelList = DataManager.shared.currentModelList[column]
            var cellList: [CellNode] = []
            for row in 0...modelList.count - 1 {
                cellList.append(CellNode(number: 0, size: CGSize.zero))
            }
            _cellNodeList[column] = cellList
        }
        
        addCellNode(model: DataManager.shared.addCellModel())
        addCellNode(model: DataManager.shared.addCellModel())
    }
}

// MARK: - Private - Methods
extension GameViewController {
    fileprivate func moveCellNode(column: Int, row: Int, node: CellNode) {
        let cellWidth = (ScreenWidth - Padding * 2) / DataManager.shared.size.width
        let point = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _containeNode.frame.minY + cellWidth * CGFloat(column))

        node.run(SKAction.move(to: point, duration: 0.25)) {
            //  移除之前在这里的node
            let lastNode = self._cellNodeList[column][row]
            lastNode.removeFromParent()
            self._cellNodeList[column][row] = node
        }
    }
    
    /// 根据model 添加一个cellNode
    fileprivate func addCellNode(model: CellModel) {
        let cellWidth = (ScreenWidth - Padding * 2) / DataManager.shared.size.width

        for column in 0...DataManager.shared.currentModelList.count-1 {
            let modelList = DataManager.shared.currentModelList[column]
            for row in 0...modelList.count-1 {
                let tempModel = modelList[row]
                if tempModel == model {
                    let node = CellNode(number: model.number, size: CGSize(width: cellWidth, height: cellWidth))
                    node.position = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _containeNode.frame.minY + cellWidth * CGFloat(column))
                    _containeNode.addChild(node)
                    _cellNodeList[column][row] = node
                }
            }
        }
    }
}

// MARK: - GestureRecognizer - Action
extension GameViewController {
    @objc
    fileprivate func swipeViewGestureRecognizerAction(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            var doSomething: Bool = false
            for column in 0...DataManager.shared.currentModelList.count-1 {
                let modelList = DataManager.shared.currentModelList[column]
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = -1
                for row in 0...modelList.count-1 {
                    let model = modelList[row]
                    if model.number != 0 {
                        if model.number != 0 && lastNumber == model.number {
                            //  相同的数字 合并
                            let currentNumber = model.number + 1
                            model.number = 0    //  还原当前number
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: column, row: lastIndex, node: node)
                            node.updateNumber(number: currentNumber)
                            
                            DataManager.shared.currentModelList[column][lastIndex].number = currentNumber
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex < row - 1 {
                            //  数字不相同 并且需要想左挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: column, row: lastIndex+1, node: node)
                            
                            DataManager.shared.currentModelList[column][lastIndex+1].number = model.number
                            model.number = 0
                            
                            lastNumber = DataManager.shared.currentModelList[column][row].number
                            lastIndex += 1
                            doSomething = true
                        } else {
                            //  数字不相同，也不需要想左挪
                            lastNumber = model.number
                            lastIndex = row
                        }
                    }
                }
            }
//            if doSomething {
                addCellNode(model: DataManager.shared.addCellModel())
//            }
            break
        case .right:
            break
        case .down:
            break
        case .up:
            break
        default:
            break
        }
    }
}
