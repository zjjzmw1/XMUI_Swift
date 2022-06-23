//
//  UIView+XMAnimation.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import Foundation
import UIKit

/// UIView 动画相关类目
extension UIView {
    
    /// 移动动画
    ///
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - delay: 开始延迟时间
    ///   - from: 开始位置
    ///   - to: 结束位置
    ///   - isRepeat: 是否重复
    @objc func moveAnimation(duration: TimeInterval, delay: TimeInterval = 0.0, from: CGRect, to: CGRect, isRepeat: Bool) {
        let animation = CABasicAnimation(keyPath: "position")
        //开始的位置
        animation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: frame.origin.x + from.width/2.0, y: frame.origin.y + frame.height/2.0))
        //移动到的位置
        animation.toValue = NSValue.init(cgPoint: CGPoint.init(x: to.origin.x + to.width/2.0, y: to.origin.y + to.height/2.0))
        //持续时间
        animation.duration = duration
        //运动后的位置保持不变（layer的最后位置是toValue）
        if isRepeat {
            animation.repeatCount = MAXFLOAT
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.autoreverses = false
        } else {
            animation.repeatCount = 0
        }
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        //添加动画
        self.layer.add(animation, forKey: "position") // key是可以随便定义的
    }
    
    /// 原地抖动动画
    ///
    /// - Parameter delay: 延迟几秒后开始
    /// - Parameter duration: 动画执行时间
    /// - Parameter isRepeat: 是否重复
    @objc func shakeAnimation(delay: CGFloat = 0.0, duration: CGFloat, isRepeat: Bool) {
        let animati = CAKeyframeAnimation(keyPath: "transform.rotation")
        // rotation 旋转，需要添加弧度值
        // 角度转弧度
        animati.values = [angle2Radion_XMS(angle: -50), angle2Radion_XMS(angle: 50), angle2Radion_XMS(angle: -50)]
        if isRepeat {
            animati.repeatCount = MAXFLOAT
        } else {
            animati.repeatCount = 0
        }
        self.layer.add(animati, forKey: nil)
    }
    func angle2Radion_XMS(angle: Float) -> Float {
        return angle / Float(180.0 * Double.pi)
    }

}
