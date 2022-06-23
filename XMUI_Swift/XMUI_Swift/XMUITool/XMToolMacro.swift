//
//  XMToolMacro.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation

/// 网络断开的统一提示文字
let kNetworkErrorTipString      =   "网络连接断开,请检查网络"
/// 请求失败统一的提示文字
let kRequestFailureTipString    =   "加载失败，请稍后重试"

/// 当前语言是否是中文 ture or false
let kCurrent_language_is_chinese = NSLocale.preferredLanguages.first?.hasPrefix("zh") ?? false

/// 当前版本号： 例如：2.6.1
let kCurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/// 当前的 CFBundleIdentifier 例如： 3
let kCFBundleIdentifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
