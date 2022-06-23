//
//  UIView+XMTool.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import Foundation
import UIKit

/// UIView 相关类目
extension UIView {
    
    /// 获取高斯模糊的view，覆盖到需要的地方就OK了。
    class func getBlurView(frame: CGRect) -> UIVisualEffectView {
        let blur = UIBlurEffect.init(style: .light)
        let effectView = UIVisualEffectView.init(effect: blur)
        effectView.frame = frame
        return effectView
    }
    
    /// 获取View所在的控制器，响应链上的第一个Controller
    func viewController() -> UIViewController? {
        var nextResponder = self as UIResponder?;
        
        repeat {
            nextResponder = nextResponder?.next!;
            if nextResponder is UIViewController {
                return nextResponder as? UIViewController;
            }
        }while (nextResponder != nil);
        
        return nil;
    }
    
    /// 清空所有子视图
    func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    }

    // MARK: - 截屏截图相关
    /// 视图快照(截图) 大小跟self的大小一样
    func snapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0);
        self.layer.render(in: (UIGraphicsGetCurrentContext())!);
        let snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap!;
    }
    
    /// 视图快照(截图) --- 固定大小
    func snapshotImageWith(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0);
        self.layer.render(in: (UIGraphicsGetCurrentContext())!);
        let snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap!;
    }

    /// 生成快照PDF
    func snapshotPDF() -> NSData {
        var bounds = self.bounds;
        let data = NSMutableData.init();
        let consumer = CGDataConsumer.init(data: data as CFMutableData);
        let context = CGContext.init(consumer: consumer!, mediaBox: &bounds, nil);
        context?.beginPDFPage(nil);
        context?.translateBy(x: 0, y: bounds.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        self.layer.render(in: context!);
        context?.endPDFPage();
        context?.closePDF();
        return data;
    }
        
}
