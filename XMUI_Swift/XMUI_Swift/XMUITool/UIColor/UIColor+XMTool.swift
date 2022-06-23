//
//  UIColor+XMTool.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

extension UIColor {
    
    
    /// 根据十六进制，获取 UIColor
    /// - Parameters:
    ///   - value: 例如：0x333333
    ///   - alphe: 默认是不透明 1.0
    /// - Returns: UIColor
    class func colorWithHex(value: __uint32_t, alphe: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((value & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((value & 0xFF)) / 255.0,
                            alpha: alphe);
    }
}
