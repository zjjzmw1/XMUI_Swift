//
//  UIView+XMFrame.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

/// UIView 尺寸 相关类目
extension UIView {
    // MARK: - 上、下、左、右、宽、高、center等
    
    /// frame.origin.x
    var left: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.x = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.origin.x;
        }
    }
    
    /// frame.origin.y
    var top: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.y = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.origin.y;
        }
    }
    
    /// frame.origin.x + frame.size.width
    var right: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.x = newValue - rect.size.width;
            self.frame = rect;
        }
        get {
            return self.frame.origin.x + self.frame.size.width;
        }
    }
    
    /// self.frame.origin.y + self.frame.size.height
    var bottom: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.y = newValue - rect.size.height;
            self.frame = rect;
        }
        get {
            return self.frame.origin.y + self.frame.size.height;
        }
    }
    
    /// frame.size.width
    var width: CGFloat {
        set {
            var rect = self.frame;
            rect.size.width = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.size.width;
        }
    }
    
    /// frame.size.height
    var height: CGFloat {
        set {
            var rect = self.frame;
            rect.size.height = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.size.height;
        }
    }
    
    /// frame.origin
    var origin: CGPoint {
        set {
            var rect = self.frame;
            rect.origin = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.origin;
        }
    }
    
    /// frame.size
    var size: CGSize {
        set {
            var rect = self.frame;
            rect.size = newValue;
            self.frame = rect;
        }
        get {
            return self.frame.size;
        }
    }
    
    /// center.x
    var centerX: CGFloat {
        set {
            var center = self.center;
            center.x = newValue;
            self.center = center;
        }
        get {
            return self.center.x;
        }
    }
    
    /// center.y
    var centerY: CGFloat {
        set {
            var center = self.center;
            center.y = newValue;
            self.center = center;
        }
        get {
            return self.center.y;
        }
    }

}
