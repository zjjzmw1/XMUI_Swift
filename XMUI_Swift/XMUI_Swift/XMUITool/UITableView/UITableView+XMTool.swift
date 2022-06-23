//
//  UITableView+XMTool.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

extension UITableView {
    
    /// 便利的获取UITableView
    public class func getInstanceTableView(frame: CGRect, style: UITableView.Style? = nil ) -> UITableView {
        var tableV:UITableView
        if let style = style {
            tableV = UITableView.init(frame: frame, style: style)
        } else {
            tableV = UITableView.init(frame: frame, style: .plain)
        }
        tableV.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableV.separatorStyle = .none // 默认隐藏横线
//        tableV.separatorColor = UIColor.lightGray
        //        tableView.separatorStyle = .singleLine
        //        tableView.separatorColor = UIColor.getSeparator()
        //        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableV.separatorInset = .zero
        tableV.tableFooterView = UIView()
        tableV.tableHeaderView = UIView()
        // iOS11后，不加这三句，会出现，reloadData的时候页面闪动，滚动到其他地方的bug。
        tableV.estimatedRowHeight = 0
        tableV.estimatedSectionHeaderHeight = 0
        tableV.estimatedSectionFooterHeight = 0
        
        if #available(iOS 15.0, *) {
            tableV.sectionHeaderTopPadding = 0 // 修复section上面横条的bug
        }
        
        return tableV
    }

}
