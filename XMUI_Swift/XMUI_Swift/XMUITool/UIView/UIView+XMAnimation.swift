//
//  UIView+XMAnimation.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

/// UIView 动画相关类目
extension UIView: CAAnimationDelegate {
    
    // MARK: - 移动动画
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
    
    // MARK: - 抖动动画
    /// 原地抖动动画
    ///
    /// - Parameter delay: 延迟几秒后开始
    /// - Parameter duration: 动画执行时间
    /// - Parameter isRepeat: 是否重复
    @objc func shakeAnimation(delay: CGFloat = 0.0, duration: CGFloat, isRepeat: Bool) {
        let animati = CAKeyframeAnimation(keyPath: "transform.rotation")
        // rotation 旋转，需要添加弧度值
        // 角度转弧度
        animati.values = [angle2Radion(angle: -50), angle2Radion(angle: 50), angle2Radion(angle: -50)]
        if isRepeat {
            animati.repeatCount = MAXFLOAT
        } else {
            animati.repeatCount = 0
        }
        self.layer.add(animati, forKey: nil)
    }
    func angle2Radion(angle: Float) -> Float {
        return angle / Float(180.0 * Double.pi)
    }
    
    // MARK: - 上下浮动动画
    /// 上下浮动动画
    func floatAnimation() {
        let basicAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        basicAnimation.duration = 0.25
        basicAnimation.fromValue = NSNumber(value: -5)
        basicAnimation.toValue = NSNumber(value: 5)
        basicAnimation.autoreverses = true
        self.layer.add(basicAnimation, forKey: "floatAnimation")
    }

    //MARK: - 抛物线动画
    typealias animationFinishedBlock = (_ finish : Bool) -> Void
    /// 展示抛物线动画
     func showParabolaAnimation(andFinishedRect finishPoint : CGPoint, andFinishBlock completion : @escaping animationFinishedBlock) -> Void{
         let layer = CALayer()
         layer.contents = self.layer.contents
         layer.contentsGravity = CALayerContentsGravity.resize
         layer.frame = self.frame
     
         let myWindow : UIView = ((UIApplication.shared.delegate?.window)!)!
         myWindow.layer.addSublayer(layer)
         //创建路径 其路径是抛物线
         let path : UIBezierPath = UIBezierPath()
         path.move(to: layer.position)
         path.addQuadCurve(to: finishPoint, controlPoint:CGPoint(x: myWindow.frame.size.width/2, y: self.frame.origin.y - 40))
         
         //这里要使用组合动画 一个负责旋转，另一个负责曲线的运动
         //创建 关键帧动画 负责曲线的运动
         let pathAnimation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")//位置的平移
         pathAnimation.path = path.cgPath
         //负责旋转 rotation
         let basicAnimation = CABasicAnimation(keyPath: "transform.rotation")
         basicAnimation.isRemovedOnCompletion = true
         basicAnimation.fromValue = NSNumber(value: 0)
         basicAnimation.toValue = NSNumber(value: 3 * 2 * Double.pi)//这里是旋转的角度 共是：3圈 （2 * M_PI）是一圈
         basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
         
         //创建组合动画 主要是负责时间的相关设置 如下
         let groups : CAAnimationGroup = CAAnimationGroup()
         groups.animations = [pathAnimation,basicAnimation]
         groups.duration = 1.5//国际单位制 S
         groups.fillMode = CAMediaTimingFillMode.forwards
         groups.isRemovedOnCompletion = true
         groups.delegate = self
         self.layer.add(groups, forKey: "groups")
         completion(true)
     }

    
}
