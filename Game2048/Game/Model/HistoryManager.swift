//
//  HistoryManager.swift
//  Game2048
//
//  Created by 默认 on 2018/6/12.
//  Copyright © 2018年 guoyi. All rights reserved.
//

import UIKit
import SQLite

class HistoryManager: NSObject {

    static let shared = HistoryManager()
    
    fileprivate var db: Connection?
    fileprivate let history4x4Table = Table("History4x4")
    
    fileprivate let stepKey = Expression<String>("step")
    fileprivate let scoreKey = Expression<Int>("score")
    fileprivate let timestampKey = Expression<Int64>("timestamp")
    
    override init() {
        guard let dbPath = Bundle.main.path(forResource: "History", ofType: "db") else { print("db path error"); return }
        
        do {
            db = try Connection(dbPath)
        } catch {
            print("connection db error \(error)")
        }
        
    }
    
    func insert(step: [[Int]], score: Int) -> Bool {
        guard let _db = db else { return false }
        
        let stepString = translateStep(array: step)
        let insert = history4x4Table.insert(scoreKey <- score, timestampKey <- 123, stepKey <- stepString)
        print(insert)
        
        return true
    }
    
}

extension HistoryManager {
    func translateStep(array:[[Int]]) -> String {
        for section in array {
            var secList = section
            
            
        }
        return ""
    }
    
    func translateStep(string: String) -> [[Int]] {
        return []
    }
}
