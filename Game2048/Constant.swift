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

let YellowColor = #colorLiteral(red: 0.9418478538, green: 1, blue: 0.5519205822, alpha: 1)
let BlackColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
let HeadButtonColor = #colorLiteral(red: 0.5678169406, green: 0.3616148786, blue: 1, alpha: 1)
let HeadMenuColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
let MatrixBackgroundColor = #colorLiteral(red: 0.9627590674, green: 0.9627590674, blue: 0.9627590674, alpha: 1)

let TitleFontName = "AvenirNext-Bold"

let kUserDefault_UndoCount = "kUserDefault_UndoCount"

class Constant: NSObject {
    static let topArea: CGFloat = ScreenHeight == 812 ? 44 : 0
}
