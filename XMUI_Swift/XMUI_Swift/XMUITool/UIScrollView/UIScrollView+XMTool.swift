//
//  UIScrollView+XMTool.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import Foundation
import UIKit

extension UIScrollView {
    /// 滚到顶点
    func scrollToTop_XM(animated: Bool) {
        var off = self.contentOffset;
        off.y = 0 - self.contentInset.top;
        self.setContentOffset(off, animated: animated);
    }
    
    /// 滚到底边
    func scrollToBottom_XM(animated: Bool) {
        var off = self.contentOffset;
        off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
        self.setContentOffset(off, animated: animated);
    }
    
    /// 滚到左边
    func scrollToLeft_XM(animated: Bool) {
        var off = self.contentOffset;
        off.x = 0 - self.contentInset.left;
        self.setContentOffset(off, animated: animated);
    }
    
    /// 滚到右边
    func scrollToRight_XM(animated: Bool) {
        var off = self.contentOffset;
        off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
        self.setContentOffset(off, animated: animated);
    }
}
