//
//  UIFont+XMTool.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

extension UIFont {
    
    /// 获取 PingFangSC-Regular 字体 -- 常规
    public func getFont_PingFangRegular(fontSize: CGFloat) -> UIFont {
        if let font = UIFont.init(name: "PingFangSC-Regular", size: fontSize) {
            return font
        }
        return UIFont.systemFont(ofSize: fontSize)
    }
    /// 获取 Helvetica-Oblique 字体 -- 粗体
    public func getFont_PingFangBold(fontSize: CGFloat) -> UIFont {
        let font = UIFont.init(name: "Helvetica-Oblique", size: fontSize)
        return font!
    }

    // MARK: - 获取本地字体
    /// 加载本地TTF字体
    class func getFontWithTTF_XMS(atPath: String, size: CGFloat = 15.0) -> UIFont {
        let foundFile = FileManager.default.fileExists(atPath: atPath);
        if !foundFile {
            return UIFont.systemFont(ofSize: size);
        }
        let fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, atPath as CFString?, CFURLPathStyle.cfurlposixPathStyle, false);
        let dataProvider = CGDataProvider.init(url: fontURL!);
        let graphicsFont = CGFont.init(dataProvider!);
        let smallFont = CTFontCreateWithGraphicsFont(graphicsFont!, size, nil, nil);
        return smallFont as UIFont;
    }

}
