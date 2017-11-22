//
//  DataManager.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static let shared: DataManager = DataManager()
    
    /// 默认尺寸 6x6 用于限制2048的规格
    var size = CGSize(width: 6, height: 6)
    /// cell显示的文字数组，根据cell.number作为数组下标获取cell对应的文字
    var titleList: [String] = {
        var list: [String] = []
        for i in 1...36 {
            let number = pow(2, i)
            let string = "\(number)"
            list.append(string)
        }
        return list
    }()
    /// 当前所有cell的二维数组，包含number=0的model
    var currentModelList: [[CellModel]] = {
        var list: [[CellModel]] = []
        for column in 0...5 {
            var modelList: [CellModel] = []
            for row in 0...5 {
                let model = CellModel(number: 0)
                modelList.append(model)
            }
            list.append(modelList)
        }
        return list
    }()
    
    override init() {
        super.init()
        
    }
}

// MARK: - Public - Methods
extension DataManager {
    /// 随机位置 给一个number=0的 cellmodel赋值 1或者2
    func addCellModel() -> CellModel {
        let emptyModel = emptyModelWithCurrentModelList()
        let number = Int(arc4random_uniform(2)+1)
        emptyModel.number = number
        return emptyModel
    }
}

// MARK: - Private - Methods
extension DataManager {
    /// 随机返回当前所有cellModel中number = 0的那个
    fileprivate func emptyModelWithCurrentModelList() -> CellModel {
        /*
        let randomColumn = Int(arc4random_uniform(UInt32(size.height)))
        let randomRow = Int(arc4random_uniform(UInt32(size.width)))
        let model = currentModelList[randomColumn][randomRow]
        if model.number != 0 {
            return emptyModelWithCurrentModelList()
        } else {
            return model
        } //  这种随机方法对于number=0占大多数的情况效率高，但当number=0个数较少时效率较低，下面这种方法相反
        */
        
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
