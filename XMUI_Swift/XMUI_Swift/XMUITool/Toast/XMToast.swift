//
//  XMToast.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/28.
//

import UIKit

enum XMToastPositionType {
    /// 居中
    case center
    /// 底部
    case bottom
}

/// 通用的 toast 提示框
class XMToast: UIView {

    /// 内容的view
    lazy var contentV: UIView = {
        let v = UIView.init()
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8
        v.backgroundColor = UIColor.init(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 0.8)
        v.alpha = 1.0
        v.isUserInteractionEnabled = false
        return v
    }()
    
    /// 提示文字 label
    lazy var tipLbl: UILabel = {
        let lbl = UILabel.init()
        lbl.textColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    /// 定时器
    var timer: Timer?
    
    /// 单例
    static let shareInstance: XMToast = XMToast.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        if self.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(self)
        }
        if self.superview == nil {
            UIApplication.shared.windows.last?.addSubview(self)
        }
        self.addSubview(contentV)
        self.addSubview(tipLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 弹出 toast 提示框
    /// 弹出 toast 提示框
    /// - Parameters:
    ///   - text: 提示文字
    ///   - positionType: 居中/居底 - 默认居中
    class func showText(text: String, positionType: XMToastPositionType = .center) {
        XMToast.shareInstance.timer?.invalidate()
        XMToast.shareInstance.timer = nil
        XMToast.shareInstance.removeFromSuperview()
        XMToast.shareInstance.alpha = 1.0
        if text.count <= 0 {
            return
        }
        if XMToast.shareInstance.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(XMToast.shareInstance)
        }
        if XMToast.shareInstance.superview == nil {
            UIApplication.shared.windows.last?.addSubview(XMToast.shareInstance)
        }
        XMToast.shareInstance.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        XMToast.shareInstance.isUserInteractionEnabled = false
        // 添加行间距
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineSpacing = 5 // 行间距
        paraStyle.lineBreakMode = .byWordWrapping
        paraStyle.alignment = .center
        let attributeStr = NSMutableAttributedString.init(string: text)
        attributeStr.addAttribute(.paragraphStyle, value: paraStyle, range: NSRange.init(location: 0, length: text.count))
        XMToast.shareInstance.tipLbl.attributedText = attributeStr
        XMToast.shareInstance.tipLbl.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth - 60*2, height: 0)
        XMToast.shareInstance.tipLbl.sizeToFit()
        // 文字距离背景的间隙
        let topMargin = 16.0
        let leftMargin = 20.0
        let bottomMargin = 16.0
        var contentW = XMToast.shareInstance.tipLbl.frame.size.width + leftMargin * 2
        if contentW < 150 {
            contentW = 150
        }
        XMToast.shareInstance.tipLbl.textAlignment = .center
        XMToast.shareInstance.contentV.layer.cornerRadius = 10
        // 默认居中
        XMToast.shareInstance.tipLbl.center = XMToast.shareInstance.center
        // 居底部
        if positionType == .bottom {
            XMToast.shareInstance.tipLbl.frame = CGRect.init(x: XMToast.shareInstance.tipLbl.frame.origin.x, y: kScreenHeight - XMToast.shareInstance.tipLbl.frame.size.height - 60 - kSafeBottomHeight, width: XMToast.shareInstance.tipLbl.frame.size.width, height: XMToast.shareInstance.tipLbl.frame.size.height)
        }
        XMToast.shareInstance.contentV.frame = CGRect.init(x: XMToast.shareInstance.tipLbl.frame.origin.x - leftMargin, y: XMToast.shareInstance.tipLbl.origin.y - topMargin, width: XMToast.shareInstance.tipLbl.frame.size.width + leftMargin*2, height: XMToast.shareInstance.tipLbl.frame.size.height + topMargin + bottomMargin)
        // 延迟消失
        var delayHiddenTime = 1.5
        if text.count > 10 {
            delayHiddenTime = 1.8
        }
        if text.count > 15 {
            delayHiddenTime = 2.0
        }
        XMToast.shareInstance.timer = Timer.scheduledTimer(timeInterval: delayHiddenTime, target: XMToast.shareInstance, selector: #selector(hiddenAction), userInfo: nil, repeats: false)
        RunLoop.current.add(XMToast.shareInstance.timer!, forMode: .common)
    }
    
    // MARK: - 隐藏方法
    @objc func hiddenAction() {
        self.timer?.invalidate()
        self.timer = nil
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction) {
            self.alpha = 0.0
        } completion: { _ in
            
        }
    }
}
