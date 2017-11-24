//
//  MatrixNodeManager.swift
//  Game2048
//
//  Created by kokozu on 24/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import SpriteKit

class MatrixNodeManager: NSObject {
    static let shared: MatrixNodeManager = MatrixNodeManager()
    
    fileprivate let Padding: CGFloat = 10.0
    
    //  Data
    fileprivate var _cellNodeList: [[CellNode]] = [[],[],[],[],[],[]]
    
    //  UI
    fileprivate var _matrixNode: SKShapeNode?
    
    override init() {
        super.init()
        
    }
    
    fileprivate func prepareChildNode() {
        
        for column in 0...DataManager.shared.currentModelList.count - 1 {
            let modelList = DataManager.shared.currentModelList[column]
            var cellList: [CellNode] = []
            for _ in 0...modelList.count - 1 {
                cellList.append(CellNode(number: 0, size: CGSize.zero))
            }
            _cellNodeList[column] = cellList
        }
        
        addCellNode(model: DataManager.shared.addCellModel())
        addCellNode(model: DataManager.shared.addCellModel())
    }
}

// MARK: - Private - Methods
extension MatrixNodeManager {
    fileprivate func moveCellNode(column: Int, row: Int, node: CellNode) {
        let cellWidth = (ScreenWidth - Padding * 2) / DataManager.shared.size.width
        let point = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _matrixNode!.frame.minY + cellWidth * CGFloat(column))
        
        let removeNode = _cellNodeList[column][row]
        
        node.run(SKAction.move(to: point, duration: 0.25)) {
            //  移除之前在这里的node
            removeNode.removeFromParent()
        }
        removeCellNodel(column: column, row: row, newNode: node)
    }
    
    fileprivate func removeCellNodel(column: Int, row: Int, newNode: CellNode) {
        _cellNodeList[column][row] = newNode
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
                    node.position = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _matrixNode!.frame.minY + cellWidth * CGFloat(column))
                    _matrixNode!.addChild(node)
                    _cellNodeList[column][row] = node
                }
            }
        }
    }
}

// MARK: - Public - Methods
extension MatrixNodeManager {
    
    /// 创建矩阵视图 并初始化所有子视图
    func creatMatrixNode(rect: CGRect) -> SKShapeNode {
        if let node = _matrixNode {
            node.removeFromParent()
            _matrixNode = nil
        }
        
        _matrixNode = SKShapeNode(rect: rect, cornerRadius: CornerRadius_Cell)
        guard let newNode = _matrixNode else { return SKShapeNode() }
        newNode.fillColor = SKColor.white
        newNode.strokeColor = SKColor.black
        prepareChildNode()
        
        
        return newNode
    }
    
    /// 手势处理方法，移动所有cell
    func swipeGestureRecognizerAction(direction: UISwipeGestureRecognizerDirection) {
        var doSomething: Bool = false
        
        switch direction {
        case .left:
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
                            _cellNodeList[column][lastIndex+1].updateNumber(number: model.number)
                            
                            DataManager.shared.currentModelList[column][lastIndex+1].number = model.number
                            model.number = 0
                            
                            lastNumber = DataManager.shared.currentModelList[column][lastIndex+1].number
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
            break
            
        case .right:
            for column in 0...DataManager.shared.currentModelList.count-1 {
                let modelList = DataManager.shared.currentModelList[column]
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = modelList.count
                for i in 0...modelList.count-1 {
                    let row = modelList.count - i - 1
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
                        } else if lastIndex > row + 1 {
                            //  数字不相同 并且需要想右挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: column, row: lastIndex-1, node: node)
                            _cellNodeList[column][lastIndex-1].updateNumber(number: model.number)
                            
                            DataManager.shared.currentModelList[column][lastIndex-1].number = model.number
                            model.number = 0
                            
                            lastNumber = DataManager.shared.currentModelList[column][lastIndex-1].number
                            lastIndex -= 1
                            doSomething = true
                        } else {
                            //  数字不相同，也不需要想左挪
                            lastNumber = model.number
                            lastIndex = row
                        }
                    }
                }
            }
            break
            
        case .down:
            for row in 0...DataManager.shared.currentModelList.first!.count-1 {
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = -1
                for column in 0...DataManager.shared.currentModelList.count-1 {
                    let model = DataManager.shared.currentModelList[column][row]
                    if model.number != 0 {
                        if model.number != 0 && lastNumber == model.number {
                            //  相同的数字 合并
                            let currentNumber = model.number + 1
                            model.number = 0    //  还原当前number
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex, row: row, node: node)
                            node.updateNumber(number: currentNumber)
                            
                            DataManager.shared.currentModelList[lastIndex][row].number = currentNumber
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex < column - 1 {
                            //  数字不相同 并且需要想下挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex+1, row: row, node: node)
                            _cellNodeList[lastIndex+1][row].updateNumber(number: model.number)
                            
                            DataManager.shared.currentModelList[lastIndex+1][row].number = model.number
                            model.number = 0
                            
                            lastNumber = DataManager.shared.currentModelList[lastIndex+1][row].number
                            lastIndex += 1
                            doSomething = true
                        } else {
                            //  数字不相同，也不需要想左挪
                            lastNumber = model.number
                            lastIndex = column
                        }
                    }
                }
            }
            break
        case .up:
            for row in 0...DataManager.shared.currentModelList.first!.count-1 {
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = DataManager.shared.currentModelList.count
                for i in 0...DataManager.shared.currentModelList.count-1 {
                    let column = DataManager.shared.currentModelList.count - i - 1
                    let model = DataManager.shared.currentModelList[column][row]
                    if model.number != 0 {
                        if model.number != 0 && lastNumber == model.number {
                            //  相同的数字 合并
                            let currentNumber = model.number + 1
                            model.number = 0    //  还原当前number
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex, row: row, node: node)
                            node.updateNumber(number: currentNumber)
                            
                            DataManager.shared.currentModelList[lastIndex][row].number = currentNumber
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex > column + 1 {
                            //  数字不相同 并且需要想上挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex-1, row: row, node: node)
                            _cellNodeList[lastIndex-1][row].updateNumber(number: model.number)
                            
                            DataManager.shared.currentModelList[lastIndex-1][row].number = model.number
                            model.number = 0
                            
                            lastNumber = DataManager.shared.currentModelList[lastIndex-1][row].number
                            lastIndex -= 1
                            doSomething = true
                        } else {
                            //  数字不相同，也不需要想左挪
                            lastNumber = model.number
                            lastIndex = column
                        }
                    }
                }
            }
            break
        default:
            break
        }
        
        if doSomething {
            addCellNode(model: DataManager.shared.addCellModel())
        }
    }
}
