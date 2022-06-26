//
//  DemoAnimationVC.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/26.
//

import UIKit

/// 动画相关 demo
class DemoAnimationVC: UIViewController {

    lazy var testView1: UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.red
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(testAnimation1))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    lazy var testView2: UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.red
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(testAnimation2))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    lazy var testView3: UIView = {
        let v = UIView.init()
        v.backgroundColor = UIColor.red
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(testAnimation3))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "UIView+XMAnimation"
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(testView1)
        testView1.frame = CGRect.init(x: 50, y: 100, width: 80, height: 80)
        
        self.view.addSubview(testView2)
        testView2.frame = CGRect.init(x: 200, y: 100, width: 80, height: 80)
        
        self.view.addSubview(testView3)
        testView3.frame = CGRect.init(x: 50, y: 220, width: 80, height: 80)

    }
    
    @objc func testAnimation1() {
        testView1.showParabolaAnimation(andFinishedRect: CGPoint.init(x: 300, y: 500)) { finish in
            print("动画完成。\(finish)")
        }
    }
    
    @objc func testAnimation2() {
        testView2.shakeAnimation(duration: 2.0, isRepeat: false)
    }
    
    @objc func testAnimation3() {
        testView3.moveAnimation(duration: 2.0, from: testView3.frame, to: CGRect.init(x: 200, y: 300, width: testView3.width, height: testView3.height), isRepeat: false)
    }
   

}
