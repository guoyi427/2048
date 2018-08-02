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
    fileprivate let CellOffset_y: CGFloat = 0
    
    //  Data
    fileprivate var _cellNodeList: [[CellNode]] = [[],[],[],[],[],[]]
    fileprivate var _separateLineList: [SKShapeNode] = []
    
    //  UI
    fileprivate var _matrixNode: SKShapeNode?
    
    override init() {
        super.init()
        
    }
    
    fileprivate func prepareChildNode() {
        /// 格子外圈尺寸
        let cellWidth = Constant.queryCellWidth(backgroundWidth: _matrixNode!.frame.width)
        let originX = _matrixNode!.frame.minX
        let originY = _matrixNode!.frame.minY
        let lineColor = SKColor.white
        
        for column in 0...GameDataManager.shared.currentModelList.count - 1 {
            let modelList = GameDataManager.shared.currentModelList[column]
            var cellList: [CellNode] = []
            for _ in 0...modelList.count - 1 {
                cellList.append(CellNode(number: 0, size: CGSize.zero))
            }
            _cellNodeList[column] = cellList
            
            //  添加网格分割线
            if column > 0 { //  少画一条分割线
                let pathToVertical = CGMutablePath()
                pathToVertical.move(to: CGPoint(x: originX + cellWidth * CGFloat(column), y: originY))
                pathToVertical.addLine(to: CGPoint(x: originX + cellWidth * CGFloat(column), y: originY + _matrixNode!.frame.height))
                let verLine = SKShapeNode(path: pathToVertical)
                verLine.strokeColor = lineColor
                _matrixNode!.addChild(verLine)
                _separateLineList.append(verLine)
                
                let pathToHorizontal = CGMutablePath()
                pathToHorizontal.move(to: CGPoint(x: originX, y: originY + cellWidth * CGFloat(column) - 1))
                pathToHorizontal.addLine(to: CGPoint(x: originX + _matrixNode!.frame.width, y: originY + cellWidth * CGFloat(column) - 1))
                let horLine = SKShapeNode(path: pathToHorizontal)
                horLine.strokeColor = lineColor
                _matrixNode!.addChild(horLine)
                _separateLineList.append(horLine)
            }
        }
        
        //  添加滑块儿
        addCellNode(model: GameDataManager.shared.addCellModel())
        addCellNode(model: GameDataManager.shared.addCellModel())
    }
}

// MARK: - Private - Methods
extension MatrixNodeManager {
    /// 移动单元格
    fileprivate func moveCellNode(column: Int, row: Int, node: CellNode) {
        let cellWidth = Constant.queryCellWidth(backgroundWidth: _matrixNode!.frame.width)
        let point = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _matrixNode!.frame.minY + cellWidth * CGFloat(column) + CellOffset_y)
        
        let removeNode = _cellNodeList[column][row]
        
        node.run(SKAction.move(to: point, duration: 0.25)) {
            //  移除之前在这里的node
            removeNode.removeFromParent()
        }
        removeCellNodel(column: column, row: row, newNode: node)
    }
    
    /// 移除单元格
    fileprivate func removeCellNodel(column: Int, row: Int, newNode: CellNode) {
        _cellNodeList[column][row] = newNode
    }
    
    /// 根据model 添加一个cellNode
    fileprivate func addCellNode(model: CellModel) {
        let cellWidth = Constant.queryCellWidth(backgroundWidth: _matrixNode!.frame.width)
        
        for column in 0...GameDataManager.shared.currentModelList.count-1 {
            let modelList = GameDataManager.shared.currentModelList[column]
            for row in 0...modelList.count-1 {
                let tempModel = modelList[row]
                if tempModel == model {
                    let node = CellNode(number: model.number, size: CGSize(width: cellWidth, height: cellWidth))
                    node.position = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _matrixNode!.frame.minY + cellWidth * CGFloat(column) + CellOffset_y)
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
        newNode.fillColor = MatrixBackgroundColor
        newNode.strokeColor = MatrixBackgroundColor
        prepareChildNode()
        
        return newNode
    }
    
    /// 手势处理方法，移动所有cell
    func swipeGestureRecognizerAction(direction: UISwipeGestureRecognizerDirection) {
        var doSomething: Bool = false
        
        switch direction {
        case .left:
            for column in 0...GameDataManager.shared.currentModelList.count-1 {
                let modelList = GameDataManager.shared.currentModelList[column]
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
                            
                            GameDataManager.shared.currentModelList[column][lastIndex].number = currentNumber
                            GameDataManager.shared.addScore(number: currentNumber)
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex < row - 1 {
                            //  数字不相同 并且需要想左挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: column, row: lastIndex+1, node: node)
                            _cellNodeList[column][lastIndex+1].updateNumber(number: model.number)
                            
                            GameDataManager.shared.currentModelList[column][lastIndex+1].number = model.number
                            model.number = 0
                            
                            lastNumber = GameDataManager.shared.currentModelList[column][lastIndex+1].number
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
            for column in 0...GameDataManager.shared.currentModelList.count-1 {
                let modelList = GameDataManager.shared.currentModelList[column]
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
                            
                            GameDataManager.shared.currentModelList[column][lastIndex].number = currentNumber
                            GameDataManager.shared.addScore(number: currentNumber)
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex > row + 1 {
                            //  数字不相同 并且需要想右挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: column, row: lastIndex-1, node: node)
                            _cellNodeList[column][lastIndex-1].updateNumber(number: model.number)
                            
                            GameDataManager.shared.currentModelList[column][lastIndex-1].number = model.number
                            model.number = 0
                            
                            lastNumber = GameDataManager.shared.currentModelList[column][lastIndex-1].number
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
            for row in 0...GameDataManager.shared.currentModelList.first!.count-1 {
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = -1
                for column in 0...GameDataManager.shared.currentModelList.count-1 {
                    let model = GameDataManager.shared.currentModelList[column][row]
                    if model.number != 0 {
                        if model.number != 0 && lastNumber == model.number {
                            //  相同的数字 合并
                            let currentNumber = model.number + 1
                            model.number = 0    //  还原当前number
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex, row: row, node: node)
                            node.updateNumber(number: currentNumber)
                            
                            GameDataManager.shared.currentModelList[lastIndex][row].number = currentNumber
                            GameDataManager.shared.addScore(number: currentNumber)
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex < column - 1 {
                            //  数字不相同 并且需要想下挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex+1, row: row, node: node)
                            _cellNodeList[lastIndex+1][row].updateNumber(number: model.number)
                            
                            GameDataManager.shared.currentModelList[lastIndex+1][row].number = model.number
                            model.number = 0
                            
                            lastNumber = GameDataManager.shared.currentModelList[lastIndex+1][row].number
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
            for row in 0...GameDataManager.shared.currentModelList.first!.count-1 {
                /// 上一个 不为空的 number
                var lastNumber: Int = 0
                /// 上一个 不为空的 下标
                var lastIndex: Int = GameDataManager.shared.currentModelList.count
                for i in 0...GameDataManager.shared.currentModelList.count-1 {
                    let column = GameDataManager.shared.currentModelList.count - i - 1
                    let model = GameDataManager.shared.currentModelList[column][row]
                    if model.number != 0 {
                        if model.number != 0 && lastNumber == model.number {
                            //  相同的数字 合并
                            let currentNumber = model.number + 1
                            model.number = 0    //  还原当前number
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex, row: row, node: node)
                            node.updateNumber(number: currentNumber)
                            
                            GameDataManager.shared.currentModelList[lastIndex][row].number = currentNumber
                            GameDataManager.shared.addScore(number: currentNumber)
                            
                            lastNumber = model.number
                            doSomething = true
                        } else if lastIndex > column + 1 {
                            //  数字不相同 并且需要想上挪
                            let node = _cellNodeList[column][row]
                            _cellNodeList[column][row] = CellNode(number: 0, size: CGSize.zero)
                            
                            moveCellNode(column: lastIndex-1, row: row, node: node)
                            _cellNodeList[lastIndex-1][row].updateNumber(number: model.number)
                            
                            GameDataManager.shared.currentModelList[lastIndex-1][row].number = model.number
                            model.number = 0
                            
                            lastNumber = GameDataManager.shared.currentModelList[lastIndex-1][row].number
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
            addCellNode(model: GameDataManager.shared.addCellModel())
            //  保存数据到缓存
            GameDataManager.shared.saveModelList()
        }
    }
    
    /// 根据 GameDataManager的currentModelList 刷新页面
    func upload() {
        //  移除老的
        for nodeList in _cellNodeList {
            for node in nodeList {
                node.removeFromParent()
            }
        }
        _cellNodeList = [[],[],[],[],[],[],[],[]]
        
        for separateLine in _separateLineList {
            separateLine.removeFromParent()
        }
        _separateLineList = []
        
        
        let cellWidth = Constant.queryCellWidth(backgroundWidth: _matrixNode!.frame.width)
        let originX = _matrixNode!.frame.minX
        let originY = _matrixNode!.frame.minY
        let lineColor = SKColor.white
        
        //  创建新的
        for column in 0...GameDataManager.shared.currentModelList.count - 1 {
            let modelList = GameDataManager.shared.currentModelList[column]
            var cellList: [CellNode] = []
            for row in 0...modelList.count - 1 {
                //  添加网格分割线
                if column > 0 { //  少画一条分割线
                    let pathToVertical = CGMutablePath()
                    pathToVertical.move(to: CGPoint(x: originX + cellWidth * CGFloat(column), y: originY))
                    pathToVertical.addLine(to: CGPoint(x: originX + cellWidth * CGFloat(column), y: originY + _matrixNode!.frame.height))
                    let verLine = SKShapeNode(path: pathToVertical)
                    verLine.strokeColor = lineColor
                    _matrixNode!.addChild(verLine)
                    _separateLineList.append(verLine)
                    
                    let pathToHorizontal = CGMutablePath()
                    pathToHorizontal.move(to: CGPoint(x: originX, y: originY + cellWidth * CGFloat(column) - 1))
                    pathToHorizontal.addLine(to: CGPoint(x: originX + _matrixNode!.frame.width, y: originY + cellWidth * CGFloat(column) - 1))
                    let horLine = SKShapeNode(path: pathToHorizontal)
                    horLine.strokeColor = lineColor
                    _matrixNode!.addChild(horLine)
                    _separateLineList.append(horLine)
                }
                
                let model = modelList[row]
                let node = CellNode(number: model.number, size: CGSize(width: cellWidth, height: cellWidth))
                node.position = CGPoint(x: Padding + cellWidth * CGFloat(row), y: _matrixNode!.frame.minY + cellWidth * CGFloat(column) + CellOffset_y)
                if model.number > 0 {
                    _matrixNode!.addChild(node)
                }
                cellList.append(node)
            }
            _cellNodeList[column] = cellList
        }
    }
}
