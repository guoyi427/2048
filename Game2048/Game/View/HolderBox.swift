//
//  HolderBox.swift
//  Game2048
//
//  Created by 默认 on 2018/8/13.
//  Copyright © 2018年 guoyi. All rights reserved.
//

import SpriteKit

class HolderBox: SKShapeNode {

    init(row: Int, column: Int, size: CGSize, topY: CGFloat) {
        super.init()
        
        self.path = CGPath(roundedRect: CGRect(x: 0, y: 0,
                                               width: size.width - CellPadding * 2,
                                               height: size.height - CellPadding * 2),
                           cornerWidth: CornerRadius,
                           cornerHeight: CornerRadius,
                           transform: nil)
        position = CGPoint(x: MatrixNodePadding + size.width * CGFloat(row) + CellPadding,
                           y: topY + size.height * CGFloat(column) + CellPadding)
        
        fillColor = MatrixHolderBoxColor
        strokeColor = MatrixHolderBoxColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
