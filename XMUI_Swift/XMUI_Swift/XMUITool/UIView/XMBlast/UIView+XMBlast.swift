//
//  UIView+XMBlast.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import Foundation
import UIKit

// tip : 不添加这些变量的话，无法用 &获取关联的对象的值
private var kTapBlast            = "kTapBlast"
private var kDragBlast           = "kDragBlast"
private var kIsFragment          = "kIsFragment"
private var kCircle1             = "kCircle1"
private var kShapeLayer          = "kShapeLayer"
private var kResetSuperView      = "kResetSuperView"
private var kOriginPoint         = "kOriginPoint"
private var kCompletionBlock     = "kCompletionBlock"

//设置最大偏移距离为当前控件的倍数
let MAXMultiple_XMS: CGFloat     =   3.0

/// 类似QQ未读消息的红点拖拽、点击爆炸效果 ----- 爆炸完就 hidden = true了，并且removefromSuper了。
/// 爆炸后，想重新展示的话，需要 hidden = false ,并且重新 add 到父视图。（因为并没有设置为nil ，所以不用重新alloc）
/// 拖拽爆炸效果 类目
extension UIView {
    
    /// 点击爆炸 -- 默认为fase
    @objc var tapBlast_XMS: Bool {
        set {
            objc_setAssociatedObject(self, &kTapBlast, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                self.isUserInteractionEnabled = true
                let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(tapBlastAction(tap:)))
                self.addGestureRecognizer(tapGR)
            }
        }
        get {
            return (objc_getAssociatedObject(self, &kTapBlast) as? Bool) ?? false
        }
    }
    /// 拖拽爆炸 -- 默认为false
    @objc var dragBlast_XMS: Bool {
        set {
            objc_setAssociatedObject(self, &kDragBlast, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                self.isUserInteractionEnabled = true
                if self.circle1 == nil {
                    self.circle1 = UIView()
                    self.circle1?.isHidden = true
                }
                if self.shapeLayer == nil {
                    self.shapeLayer = CAShapeLayer()
                    self.shapeLayer?.fillColor = self.backgroundColor?.cgColor
                }
                self.originPoint = CGPoint.zero
                let panGR = UIPanGestureRecognizer.init(target: self, action: #selector(dragPanAction_XMS(pan:)))
                self.addGestureRecognizer(panGR)
            }
        }
        get {
            return (objc_getAssociatedObject(self, &kDragBlast) as? Bool) ?? false
        }
    }
    /// 是否是帧动画 「 帧动画需要图片。粒子动画不需要图片，默认是粒子动画」
    var isFrameAnimation: Bool {
        set {
            objc_setAssociatedObject(self, &kIsFragment, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return (objc_getAssociatedObject(self, &kIsFragment) as? Bool) ?? false
        }
    }
    // ------------------------------ 私有属性
    private var circle1: UIView? {
        set {
            objc_setAssociatedObject(self, &kCircle1, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kCircle1) as? UIView)
        }
    }
    private var shapeLayer: CAShapeLayer? {
        set {
            objc_setAssociatedObject(self, &kShapeLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kShapeLayer) as? CAShapeLayer)
        }
    }
    /// 保存self的父视图，用于恢复原位
    private var resetSuperView: UIView {
        set {
            objc_setAssociatedObject(self, &kResetSuperView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kResetSuperView) as? UIView) ?? UIView()
        }
    }
    /// 初始值
    private var originPoint: CGPoint {
        set {
            objc_setAssociatedObject(self, &kOriginPoint, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &kOriginPoint) as? CGPoint) ?? CGPoint()
        }
    }
    /// 是否完成的闭包
    var completionBlock: ((Bool) -> (Void)) {
        set {
            objc_setAssociatedObject(self, &kCompletionBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if (objc_getAssociatedObject(self, &kCompletionBlock) as? ((Bool) -> (Void))) != nil {
                return objc_getAssociatedObject(self, &kCompletionBlock) as! ((Bool) -> (Void))
            } else {
                return {isfinish in ()}
            }
        }
    }
    /// 拖动爆炸或者点击爆炸后的回调
    func blast(completion: @escaping (_ isFinished: Bool) -> Void) {
        self.completionBlock = completion // 当self.completionBlock赋值后，调用blast的地方就收到回调了。
    }
    
    // MARK: - 点击爆炸的方法
    @objc func tapBlastAction(tap: UITapGestureRecognizer) {
        if tapBlast_XMS {
            tap.view?.isHidden = true
            circle1?.isHidden = true
            originPoint = tap.view?.center ?? CGPoint()
            if isFrameAnimation == false { // 粒子动画
                self.boomCellsInGesture_XMS(gesture: tap)
            } else { // 图片的帧动画
                self.aViewBlastEffect_XMS(gesture: tap)
            }
        } else {
            transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }, completion: { (finished) in
                self.circle1?.isHidden = false
            })
        }
    }
    // MARK: - 图片的帧动画-爆炸 需要图片
    func aViewBlastEffect_XMS(gesture: UIGestureRecognizer) {
        let window = UIApplication.shared.keyWindow!
        // 获取在顶层视图的位置
        let topFloorRect: CGRect = (gesture.view?.superview?.convert(gesture.view!.frame, to: window)) ?? CGRect()
        // 爆炸效果
        let imageV = UIImageView.init(frame: topFloorRect)
        imageV.contentMode = .scaleToFill
        var imageArr: [UIImage] = []
        for i in 1 ..< 5 {
            if let image = UIImage.init(named: String.init(format: "unreadBomb_%d",i)) {
                imageArr.append(image)
            }
        }
        imageV.animationImages = imageArr
        imageV.animationDuration = 0.5
        imageV.animationRepeatCount = 1
        imageV.startAnimating()
        window.addSubview(imageV)
        // 延迟0.5后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.5 * 1000))) { [weak self] in
            if self == nil {
                return
            }
            imageV.removeFromSuperview()
            self!.circle1?.removeFromSuperview()
            self!.shapeLayer?.removeFromSuperlayer()
            // 复位
            // 复位
            if let gestureView = gesture.view {
                self?.resetSuperView.addSubview(gestureView)
                let belowFloorPoint = window.convert(self?.originPoint ?? CGPoint(), to: self?.resetSuperView)
                // 判断有没有约束和是哪种手势
                if self!.translatesAutoresizingMaskIntoConstraints {
                    gesture.view?.center = belowFloorPoint
                } else if (gesture.isMember(of: UIPanGestureRecognizer.self) && !(self!.translatesAutoresizingMaskIntoConstraints)) {
                    let R = self!.bounds.size.height / 2.0
                    // 创建左边约束
                    let leftLc = NSLayoutConstraint.init(item: self!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self?.resetSuperView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: (belowFloorPoint.x) - R)
                    self?.resetSuperView.addConstraint(leftLc)
                    // 创建顶部约束
                    let topLc = NSLayoutConstraint.init(item: self!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self?.resetSuperView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: (belowFloorPoint.y) - R)
                    self?.resetSuperView.addConstraint(topLc)
                }
            }
            // 爆炸完成
            self?.completionBlock(true)
        }
    }
    
    // MARK: - CALayer实现粒子爆炸动画
    func boomCellsInGesture_XMS(gesture: UIGestureRecognizer) {
        let rowClocn = 3
        var boomCells: [CALayer] = []
        for _ in 0 ..< rowClocn * rowClocn {
            let pw = min(self.frame.size.width, self.frame.size.height)
            let shape = CALayer()
            shape.backgroundColor = UIColor.init(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1.0).cgColor
            shape.cornerRadius = pw / 2.0
            shape.frame = CGRect.init(x: 0, y: 0, width: pw, height: pw)
            layer.superlayer?.addSublayer(shape)
            boomCells.append(shape)
        }
        self.cellAnimations_XMS(cells: boomCells, gesture: gesture)
    }
    func cellAnimations_XMS(cells: [CALayer], gesture: UIGestureRecognizer) {
        for j in 0 ..< cells.count {
            let shape = cells[j]
            shape.position = self.center
            let animationGroup = CAAnimationGroup()
            let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
            scaleAnimation.fromValue = (0.5)
            scaleAnimation.toValue = (0.1)
            let pathAnimation = CAKeyframeAnimation.init(keyPath: "position")
            pathAnimation.path = self.makeRandomPath_XMS(alayer: shape, index: CGFloat(j)).cgPath
            pathAnimation.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)]
            animationGroup.animations = [scaleAnimation,pathAnimation]
            animationGroup.fillMode = CAMediaTimingFillMode.forwards
            animationGroup.duration = 0.5
            animationGroup.isRemovedOnCompletion = false
            animationGroup.repeatCount = 1
            shape.add(animationGroup, forKey: "animationGroup")
            // 延迟animationGroup.duration后执行
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(animationGroup.duration * 1000))) {
                shape.removeAnimation(forKey: "animationGroup")
                shape.isHidden = true
                shape.removeFromSuperlayer()
            }
        }
        // 延迟0.6后执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(0.6 * 1000))) { [weak self] in
            if self == nil {
                return
            }
            let window = UIApplication.shared.keyWindow
            // 复位
            if let gestureView = gesture.view {
                self?.resetSuperView.addSubview(gestureView)
                let belowFloorPoint = window?.convert(self?.originPoint ?? CGPoint(), to: self?.resetSuperView)
                // 判断有没有约束和是哪种手势
                if self!.translatesAutoresizingMaskIntoConstraints {
                    gesture.view?.center = belowFloorPoint ?? CGPoint()
                } else if (gesture.isMember(of: UIPanGestureRecognizer.self) && !(self!.translatesAutoresizingMaskIntoConstraints)) {
                    let R = self!.bounds.size.height / 2.0
                    // 创建左边约束
                    let leftLc = NSLayoutConstraint.init(item: self!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self?.resetSuperView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: (belowFloorPoint?.x)! - R)
                    self?.resetSuperView.addConstraint(leftLc)
                    // 创建顶部约束
                    let topLc = NSLayoutConstraint.init(item: self!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self?.resetSuperView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: (belowFloorPoint?.y)! - R)
                    self?.resetSuperView.addConstraint(topLc)
                }
            }
            // 爆炸完成
            self?.completionBlock(true)
        }
    }
    // MARK: - 设置爆炸的碎片路径
    func makeRandomPath_XMS(alayer: CALayer, index: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: self.center)
        if index > 0 {
            var w = UInt32(self.frame.size.width/1.5)
            if w == 0 {
                w = 15
            }
            // 爆炸的半径
            let R = CGFloat(arc4random() % (w/2) + w/2)
            let x = cos((CGFloat.pi * 2.0) / (index)) * R
            let y = sin((CGFloat.pi * 2.0) / (index)) * R
            path.addLine(to: CGPoint.init(x: self.center.x + x, y: self.center.y + y))
        } else {
            path.addLine(to: CGPoint.init(x: self.center.x, y: self.center.y))
        }
        return path
    }
    
    // MARK: 拖拽方法
    @objc func dragPanAction_XMS(pan: UIPanGestureRecognizer) {
        let window = UIApplication.shared.keyWindow!
        let translation = pan.translation(in: window)
        let topFloorPoint: CGPoint = pan.view?.superview?.convert(pan.view?.center ?? CGPoint(), to: window) ?? CGPoint()
        if __CGPointEqualToPoint(self.originPoint, CGPoint.zero) {
            self.originPoint = topFloorPoint
        }
        let panPoint = CGPoint.init(x: topFloorPoint.x + translation.x, y: topFloorPoint.y + translation.y)
        pan.view?.center = panPoint
        pan.setTranslation(CGPoint.zero, in: window)
        switch pan.state {
        case .began:
            self.circle1?.bounds = pan.view?.bounds ?? CGRect()
            self.circle1?.layer.cornerRadius = pan.view?.layer.cornerRadius ?? 0
            self.circle1?.layer.masksToBounds = pan.view?.layer.masksToBounds ?? false
            self.circle1?.backgroundColor = pan.view?.backgroundColor
            self.circle1?.center = self.originPoint
            self.circle1?.isHidden = false
            self.resetSuperView = pan.view?.superview ?? UIView()
            window.addSubview(self)
            window.insertSubview(self.circle1!, belowSubview: self)
            window.layer.insertSublayer(self.shapeLayer!, below: self.circle1!.layer)
        case .changed:
            let centerDistance = self.distanceBetweenPoints(firstP: self.circle1!.center, secondP: pan.view!.center)
            var scale = 1 - centerDistance/(MAXMultiple_XMS*pan.view!.bounds.size.height)
            if centerDistance > (MAXMultiple_XMS*pan.view!.bounds.size.height) {
                self.shapeLayer?.path = nil
                self.circle1?.isHidden = true
            } else {
                self.circle1?.isHidden = false
                self.reloadBeziePath(scale: 1-scale)
            }
            if scale < 0.4 {
                scale = 0.4
            }
            self.circle1?.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        case .ended:
            // 求圆心的距离
            let distance = sqrt(pow(self.originPoint.x - panPoint.x, 2) + pow(self.originPoint.y - panPoint.y, 2))
            if distance > MAXMultiple_XMS*pan.view!.bounds.size.height {
                pan.view?.isHidden = true
                if self.isFrameAnimation == false { // 粒子效果
                    self.boomCellsInGesture_XMS(gesture: pan)
                } else { // 图片的帧动画
                    self.aViewBlastEffect_XMS(gesture: pan)
                }
            } else {
                self.circle1?.isHidden = true
                self.shapeLayer?.path = nil
                // 添加阻尼系统的动画
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveLinear, animations: {
                    pan.view?.center = self.circle1?.center ?? CGPoint()
                }, completion: { (finished) in
                    self.circle1?.removeFromSuperview()
                    self.shapeLayer?.removeFromSuperlayer()
                    // 复位
                    self.resetSuperView.addSubview(self)
                    let belowFloorPoint = window.convert((pan.view?.center)!, to: self.resetSuperView)
                    // 判断有没有约束和是哪种手势
                    if self.translatesAutoresizingMaskIntoConstraints {
                        self.center = belowFloorPoint
                    } else {
                        let R = self.bounds.size.height / 2.0
                        // 创建左边约束
                        let leftLc = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.resetSuperView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: (belowFloorPoint.x) - R)
                        self.resetSuperView.addConstraint(leftLc)
                        // 创建顶部约束
                        let topLc = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.resetSuperView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: (belowFloorPoint.y) - R)
                        self.resetSuperView.addConstraint(topLc)
                    }
                })
            }
        default:
            break
        }
    }
    // MARK: - 两个CGPoint之间的距离
    func distanceBetweenPoints(firstP: CGPoint, secondP: CGPoint) -> CGFloat {
        let deltaX = secondP.x - firstP.x
        let deltaY = secondP.y - firstP.y
        return sqrt(deltaX*deltaX + deltaY*deltaY)
    }
    // MARK: - 绘制贝塞尔图形
    func reloadBeziePath(scale: CGFloat) {
        let r1 = self.circle1!.frame.size.width / 2.0
        let r2 = self.frame.size.width / 2.0
        let x1 = self.circle1!.center.x
        let y1 = self.circle1!.center.y
        let x2 = self.center.x
        let y2 = self.center.y
        let distance = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))
        let sinDegree = (x2 - x1)/distance
        let cosDegree = (y2 - y1)/distance
        let pointA = CGPoint.init(x: x1 - r1*cosDegree, y: y1 + r1*sinDegree)
        let pointB = CGPoint.init(x: x1 + r1*cosDegree, y: y1 - r1*sinDegree)
        let pointC = CGPoint.init(x: x2 + r2*cosDegree, y: y2 - r2*sinDegree)
        let pointD = CGPoint.init(x: x2 - r2*cosDegree, y: y2 + r2*sinDegree)
        let pointP = CGPoint.init(x: pointB.x + (distance / 2) * sinDegree, y: pointB.y + (distance / 2) * cosDegree)
        let pointO = CGPoint.init(x: pointA.x + (distance / 2) * sinDegree, y: pointA.y + (distance / 2) * cosDegree)
        let path = UIBezierPath()
        path.move(to: pointA)
        path.addLine(to: pointB)
        path.addQuadCurve(to: pointC, controlPoint: CGPoint.init(x: pointP.x - r1*cosDegree*scale, y: pointP.y + r1*sinDegree*scale))
        path.addLine(to: pointD)
        path.addQuadCurve(to: pointA, controlPoint: CGPoint.init(x: pointO.x - r1*cosDegree*scale, y: pointO.y + r1*sinDegree*scale))
        self.shapeLayer?.path = path.cgPath
    }

}
