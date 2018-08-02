//
//  CommonToolManager.swift
//  Game2048
//
//  Created by 默认 on 2018/8/1.
//  Copyright © 2018年 guoyi. All rights reserved.
//

import UIKit
import SpriteKit

class CommonToolManager: NSObject {

    static func screenShot(scene: SKScene) -> UIImage? {
        guard let view = scene.view else { return nil }
        guard let texture = view.texture(from: scene) else { return nil }
        if #available(iOS 9.0, *) {
            let cgImage = texture.cgImage()
            let image = UIImage(cgImage: cgImage)
            return image
        } else {
            // Fallback on earlier versions
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
}
