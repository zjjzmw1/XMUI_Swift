//
//  DemoLabelVC.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import UIKit

class DemoLabelVC: UIViewController {

    lazy var lbl1: XMPaddingLabel = {
        let lbl = XMPaddingLabel.init()
        lbl.textColor = UIColor.red
        lbl.font = UIFont.systemFont(ofSize: 15)
        lbl.backgroundColor = UIColor.lightGray
        lbl.paddingLeft = 10
        lbl.paddingRight = 10
        lbl.paddingTop = 20
        lbl.paddingBottom = 20
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "XMPaddingLabel"
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.lbl1)
        self.lbl1.frame = CGRect.init(x: 50, y: 100, width: 0, height: 0)
        self.lbl1.text = "XMPaddingLabel测试文字"
        self.lbl1.sizeToFit()
    }
    



}
