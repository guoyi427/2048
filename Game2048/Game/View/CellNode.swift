//
//  CellNode.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import SpriteKit

let CornerRadius_Cell: CGFloat = 5
let CellPadding: CGFloat = 5

class CellNode: SKNode {
    
    fileprivate let _labelNode = SKLabelNode()
    fileprivate var _backgroundNode: SKShapeNode?
    fileprivate var _cellWidth: CGFloat = ScreenWidth / 6
    
    
    fileprivate let _cellColors: [SKColor] = [#colorLiteral(red: 0.9333333333, green: 0.8941176471, blue: 0.8588235294, alpha: 1), #colorLiteral(red: 0.9294117647, green: 0.8784313725, blue: 0.7882352941, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.6941176471, blue: 0.4901960784, alpha: 1), #colorLiteral(red: 0.9176470588, green: 0.5529411765, blue: 0.3529411765, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.4862745098, blue: 0.3882352941, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.3529411765, blue: 0.2431372549, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.8431372549, blue: 0.4509803922, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.8117647059, blue: 0.3411764706, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.7490196078, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 0.8588235294, green: 0.7176470588, blue: 0.231372549, alpha: 1), #colorLiteral(red: 0.8274509804, green: 0.6862745098, blue: 0.2274509804, alpha: 1)]
    
    init(number: Int, size: CGSize) {
        super.init()
        zPosition = 10
        let cellSize = CGSize(width: size.width - CellPadding * 2, height: size.height - CellPadding * 2)
        _cellWidth = cellSize.width
        
        _backgroundNode = SKShapeNode(rectOf: cellSize, cornerRadius: CornerRadius_Cell)
        _backgroundNode!.position = CGPoint(x: cellSize.width/2, y: cellSize.height/2)
        addChild(_backgroundNode!)
        
        _labelNode.fontColor = BlackColor
        _labelNode.fontSize = 14
        _labelNode.fontName = TitleFontName
        _labelNode.verticalAlignmentMode = .center
        _labelNode.position = CGPoint(x: _backgroundNode!.frame.midX, y: _backgroundNode!.frame.midY)
        addChild(_labelNode)
        updateNumber(number: number)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private - Methods
extension CellNode {
    /// 更新颜色 根据number
    fileprivate func updateColor(number: Int) {
        var bgColor = HeadMenuColor
        if number <= _cellColors.count {
            bgColor = _cellColors[number - 1]
        }
        _backgroundNode!.fillColor = bgColor
        _backgroundNode!.strokeColor = bgColor

        var textColor = SKColor.white
        if number <= 2 {
            textColor = #colorLiteral(red: 0.5019607843, green: 0.4705882353, blue: 0.4392156863, alpha: 1)
        }
        
        _labelNode.fontColor = textColor
    }
}

// MARK: - Public - Methods
extension CellNode {
    func updateNumber(number: Int) {
        if number == 0 || number > GameDataManager.shared.titleList.count {
            _labelNode.text = ""
            return
        }
    
        _labelNode.text = GameDataManager.shared.titleList[number-1]
        
        //  更新label的字号
        let count = _labelNode.text!.count < 2 ? 2 : _labelNode.text!.count
        let fontSize = (_cellWidth)/CGFloat(count)
        _labelNode.fontSize = CGFloat(fontSize)
        //  更新背景颜色
        updateColor(number: number)
    }
}
