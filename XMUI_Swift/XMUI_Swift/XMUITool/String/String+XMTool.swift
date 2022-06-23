//
//  String+XMTool.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import Foundation

/// 字符串相关类目
extension String {
    
    // MARK: - 判断空字符串
    
    /// 判断是否是空字符串
    /// - Parameter str: 字符串
    /// - Returns: ture/false
    public static func isEmptyString(str: String?) -> Bool {
        if str == nil {
            return true
        } else if (str == "") {
            return true
        } else if (str == "<null>") {
            return true
        } else if (str == "(null)") {
            return true
        } else if (str == "null") {
            return true
        }
        return false
    }

}
