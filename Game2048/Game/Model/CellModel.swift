//
//  CellModel.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

class CellModel: NSObject {
    var number: Int = 0
    var location: CGPoint = CGPoint.zero
    
    init(number: Int) {
        super.init()
        self.number = number
    }
}
