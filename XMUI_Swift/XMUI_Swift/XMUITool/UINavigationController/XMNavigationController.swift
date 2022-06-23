//
//  XMNavigationController.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import UIKit

class XMNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        /// 不加这句会导致--个别场景的个别页面从屏幕左边缘滑动的时候卡死的bug，某种场景必须。
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = weakSelf as? UIGestureRecognizerDelegate
        }
    }
    
    // 自动移除tabbar
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

}
