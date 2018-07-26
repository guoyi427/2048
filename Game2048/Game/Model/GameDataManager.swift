//
//  GameDataManager.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

let Key_CurrentScore = "currentScore"
let Key_MaxScore = "maxScore"

class GameDataManager: NSObject {
    static let shared: GameDataManager = GameDataManager()
    
    /// 默认尺寸 6x6 用于限制2048的规格
    var size = 6
    
    /// cell显示的文字数组，根据cell.number作为数组下标获取cell对应的文字
    lazy var titleList: [String] = {
        var list: [String] = []
        for i in 1...size * size {
            let number = pow(2, i)
            let string = "\(number)"
            list.append(string)
        }
        return list
    }()
    
    /// 当前所有cell的二维数组，包含number=0的model
    lazy var currentModelList: [[CellModel]] = {
        var list: [[CellModel]] = []
        for column in 0...size-1 {
            var modelList: [CellModel] = []
            for row in 0...size-1 {
                let model = CellModel(number: 0)
                modelList.append(model)
            }
            list.append(modelList)
        }
        return list
    }()
    
    /// 历史数据
    var historyModelList: [[[Int]]] = []
    
    /// 总共得分    得分规则，合成几就加几分
    var currentScore: Int = 0
    /// 最高分数
    var maxScore: Int = 0
    
    
    
    override init() {
        super.init()
        
    }
}

// MARK: - Public - Methods
extension GameDataManager {
    /// 随机位置 给一个number=0的 cellmodel赋值 1或者2
    func addCellModel() -> CellModel {
        let emptyModel = emptyModelWithCurrentModelList()
        let number = arc4random_uniform(10)==1 ? 2 : 1
        emptyModel.number = number
        return emptyModel
    }
    
    /// 保存数据到缓存中
    func saveModelList() {
        //  将记录保存到缓存
        var sectionList: [[Int]] = []
        currentModelList.forEach({ (list) in
            var numberList: [Int] = []
            list.forEach({ (model) in
                numberList.append(model.number)
            })
            sectionList.append(numberList)
        })
        
        historyModelList.append(sectionList)
    }
    
    /// 保存到本地
    func saveToFile() {
        //  保存记录
        if historyModelList.count > 0 {
            //  保存最后10个记录
            var saveList:[[[Int]]] = []
            var list = historyModelList
            
            //  最多只保存9次历史记录
            for _ in 0...9 {
                if list.count > 0 {
                    saveList.insert(list.last!, at: 0)
                    list.removeLast()
                } else {
                    break
                }
            }
            
            var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if path == nil {
                return
            }
            if size == 6 {
                path!.append("/history.archive")
            } else {
                path!.append("/history\(size).archive")
            }
            
            NSKeyedArchiver.archiveRootObject(saveList, toFile: path!)
        }
        //  保存分数
        UserDefaults.standard.setValue(currentScore, forKey: Key_CurrentScore)
        let maxLocal = UserDefaults.standard.value(forKey: Key_MaxScore) as? Int ?? 0
        if maxScore > maxLocal {
            UserDefaults.standard.setValue(maxScore, forKey: Key_MaxScore)
        }
    }
    
    /// 查询历史
    func queryHistory() {
        guard let n_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        var path = n_path
        
        if size == 6 {
            path.append("/history.archive")
        } else {
            path.append("/history\(size).archive")
        }
        
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [[[Int]]], data.count != 0 {
            historyModelList = data
            debugPrint(historyModelList)
            
            if historyModelList.count > 0 {
                var sectionList: [[CellModel]] = []
                if let list: [[Int]] = historyModelList.last {
                    list.forEach({ (numberList) in
                        var modelList: [CellModel] = []
                        numberList.forEach({ (number) in
                            let model = CellModel(number: number)
                            modelList.append(model)
                        })
                        sectionList.append(modelList)
                    })
                    currentModelList = sectionList
                }
            }
        } else {
            //  本地不存在
            restart()
        }
        //  获取当前分数 和 最大分数
        if let score = UserDefaults.standard.value(forKey: Key_CurrentScore) as? Int  {
            currentScore = score
        }
        
        if let score = UserDefaults.standard.value(forKey: Key_MaxScore) as? Int {
            maxScore = score
        }
    }
    
    /// 返回上一步
    func undo() {
        if historyModelList.count < 2 {
            //  无可显示历史
            return
        }

        let numberSet = historyModelList[historyModelList.count - 2]
        var modelSet: [[CellModel]] = []
        for numberList in numberSet {
            var modelList: [CellModel] = []
            for number in numberList {
                let model = CellModel(number: number)
                modelList.append(model)
            }
            modelSet.append(modelList)
        }
        
        //  更新成最后一组数据
        currentModelList = modelSet
        historyModelList.removeLast()
//        currentScore -= 100
    }
    
    /// 重新开始
    func restart() {
        currentModelList.removeAll()
        historyModelList.removeAll()
        currentScore = 0
        for _ in 0...size-1 {
            var modelList: [CellModel] = []
            for _ in 0...size-1 {
                let model = CellModel(number: 0)
                modelList.append(model)
            }
            currentModelList.append(modelList)
        }
        
        _ = addCellModel()
        _ = addCellModel()
        saveModelList()
        saveToFile()
    }
    
    /// 加分
    func addScore(number: Int) {
        currentScore += Int(truncating: pow(2, number) as NSDecimalNumber)
        if currentScore > maxScore {
            maxScore = currentScore
        }
    }
}

// MARK: - Private - Methods
extension GameDataManager {
    /// 随机返回当前所有cellModel中number = 0的那个
    fileprivate func emptyModelWithCurrentModelList() -> CellModel {
        //  获取所有number = 0的model
        var emptyNumberList: [CellModel] = []
        for column in 0...currentModelList.count - 1 {
            let modelList = currentModelList[column]
            for row in 0...modelList.count - 1 {
                let model = modelList[row]
                if model.number == 0 {
                    emptyNumberList.append(model)
                }
            }
        }
        
        //  如果没有空model的话 游戏结束
        if emptyNumberList.count == 0 {
            return CellModel(number: 0)
        }
        
        //  从筛选数据中 随机出一个并返回
        let randomIndex = Int(arc4random_uniform(UInt32(emptyNumberList.count)))
        return emptyNumberList[randomIndex]
    }
}
