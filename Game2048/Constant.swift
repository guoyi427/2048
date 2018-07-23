//
//  Constant.swift
//  Game2048
//
//  Created by kokozu on 22/11/2017.
//  Copyright © 2017 guoyi. All rights reserved.
//

import UIKit

/// 撤销最大次数
let UndoMaxCount: Int = 3

let ScreenSize = UIScreen.main.bounds.size
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let BackgroundColor = #colorLiteral(red: 0.9843137255, green: 0.968627451, blue: 0.937254902, alpha: 1)
let BlackColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

let HeadButtonColor = #colorLiteral(red: 0.9254901961, green: 0.6, blue: 0.3764705882, alpha: 1)
let HeadMenuColor = #colorLiteral(red: 0.9333333333, green: 0.7607843137, blue: 0.1725490196, alpha: 1)

let ScoreLabelColor = #colorLiteral(red: 0.7176470588, green: 0.6705882353, blue: 0.6274509804, alpha: 1)

let MatrixBackgroundColor = #colorLiteral(red: 0.7921568627, green: 0.7450980392, blue: 0.7058823529, alpha: 1)

let TitleFontName = "AvenirNext-Bold"

let kUserDefault_UndoCount = "kUserDefault_UndoCount"

class Constant: NSObject {
    static let topArea: CGFloat = ScreenHeight == 812 ? 44 : 0
}
