//
//  CellNode.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import SpriteKit

let CornerRadius_Cell: CGFloat = 5

class CellNode: SKNode {
    
    fileprivate let _labelNode = SKLabelNode()
    fileprivate var _backgroundNode: SKShapeNode?
    
    init(number: Int, size: CGSize) {
        super.init()
        
        _backgroundNode = SKShapeNode(rectOf: size, cornerRadius: CornerRadius_Cell)
        _backgroundNode!.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(_backgroundNode!)
        updateColor(number: number)
        
        if number == 0 {
            _labelNode.text = ""
        } else {
            _labelNode.text = DataManager.shared.titleList[number-1]
        }
        
        _labelNode.fontColor = BlackColor
        _labelNode.fontSize = 30
        _labelNode.fontName = TitleFontName
        _labelNode.verticalAlignmentMode = .center
        _labelNode.position = CGPoint(x: _backgroundNode!.frame.midX, y: _backgroundNode!.frame.midY)
        addChild(_labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private - Methods
extension CellNode {
    /// 更新颜色 根据number
    fileprivate func updateColor(number: Int) {
//        let colorCount = 36
        /// 6个颜色分组，分别是 0红强， 1红绿强，2红弱绿，3绿蓝强，4绿弱蓝，5蓝红强，6蓝弱红
        let colorSectionCount = 6
        let colorSection = number / colorSectionCount
        let colorGraduation = number % colorSectionCount
        /// 颜色增量        颜色分组注释中  强为增， 弱为减
        let colorAddValue = 150 * CGFloat(colorGraduation) / CGFloat(colorSectionCount) + 105
        /// 颜色减量
        let colorSubValue = 150 - 150 * CGFloat(colorGraduation) / CGFloat(colorSectionCount) + 105
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        switch colorSection {
        case 0:
            red = colorAddValue
            break
        case 1:
            red = 255
            green = colorAddValue
            break
        case 2:
            green = 255
            red = colorSubValue
            break
        case 3:
            green = 255
            blue = colorAddValue
            break
        case 4:
            blue = 255
            green = colorSubValue
            break
        case 5:
            red = 255
            blue = colorSubValue
            break
        default:
            break
        }
        
        let textColor = SKColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
        _backgroundNode!.fillColor = textColor
    }
}

// MARK: - Public - Methods
extension CellNode {
    func updateNumber(number: Int) {
        _labelNode.text = DataManager.shared.titleList[number-1]
        updateColor(number: number)
    }
}
