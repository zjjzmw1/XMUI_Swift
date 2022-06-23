//
//  XMPaddingLabel.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import UIKit

/// 上下左右的边距 （例如：想给UILabel 左右留出一点空隙的时候，更美观。）
class XMPaddingLabel: UILabel {

    private var padding = UIEdgeInsets.zero

    /// 左边间隙
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }

    /// 右边间隙
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }

    // 上面间隙
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }

    /// 底部间隙
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }

}
