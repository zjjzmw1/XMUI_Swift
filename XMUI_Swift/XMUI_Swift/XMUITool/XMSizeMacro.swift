//
//  XMSizeMacro.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

// MARK: -  尺寸相关的宏定义

/// 屏幕宽度
let kScreenWidth           = UIScreen.main.bounds.width
/// 屏幕高度
let kScreenHeight          = UIScreen.main.bounds.height
/// 判断是否是 全面屏
var kIsIphoneX: Bool {
    get {
        if #available(iOS 11.0, *) {
            if let safeBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return safeBottom > 0 ? true : false
            }
        }
        return false
    }
}

// 状态栏高度
var kStatusbarHeight : CGFloat {
    get {
        if #available(iOS 11.0, *) {
            if let safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                return safeTop
            }
        }
        return 20
    }
}
/// 导航栏 + 状态栏 高度
var kNavigationStatusbarHeight: CGFloat {
    get {
        kStatusbarHeight + 44
    }
}
/// tabbar的高度
var kTabbarHeight: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            if let safeBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return safeBottom + 49.0
            }
        }
        return 49.0
    }
}

/// 全面屏安全区顶部高度
var kSafeTopHeight: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            if let safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                return safeTop
            }
        }
        return 0
    }
}

/// 全面屏安全区底部高度
var kSafeBottomHeight: CGFloat {
    get {
        if #available(iOS 11.0, *) {
            if let safeBottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                return safeBottom
            }
        }
        return 0
    }
}

/// 是否是ipad
let kIsIpad       =   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
