//
//  DemoBlastVC.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/23.
//

import UIKit

class DemoBlastVC: UIViewController {
    
    /// 重置按钮
    lazy var resetBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(.red, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("重置", for: .normal)
        btn.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var lbl1: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.text = "拖拽"
        lbl.textColor = .red
        lbl.backgroundColor = UIColor.blue
        // 拖拽消失
        lbl.dragBlast_XMS = true
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 40
        return lbl
    }()
    
    lazy var lbl2: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.text = "点击"
        lbl.textColor = .red
        lbl.backgroundColor = UIColor.blue
        // 点击消失
        lbl.tapBlast_XMS = true
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 40
        return lbl
    }()

    lazy var lbl3: UILabel = {
        let lbl = UILabel.init()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.text = "拖拽+点击"
        lbl.textColor = .red
        lbl.backgroundColor = UIColor.blue
        // 拖拽消失
        lbl.dragBlast_XMS = true
        // 点击消失
        lbl.tapBlast_XMS = true
        // 帧动画
        lbl.isFrameAnimation = true
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 40
        return lbl
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "XMBlast"
        self.view.backgroundColor = UIColor.white

        self.view.addSubview(self.resetBtn)
        self.resetBtn.frame = CGRect.init(x: 0, y: 100, width: kScreenWidth, height: 60)
        
        self.initBlastView()
    }
    
    /// 初始化
    @objc func initBlastView() {
        self.view.addSubview(self.lbl1)
        self.view.addSubview(self.lbl2)
        self.view.addSubview(self.lbl3)
        lbl1.frame = CGRect.init(x: 50, y: 200, width: 80, height: 80)
        lbl2.frame = CGRect.init(x: 50, y: 300, width: 80, height: 80)
        lbl3.frame = CGRect.init(x: 50, y: 400, width: 80, height: 80)
        lbl1.blast { isFinished in
            print("1消失后的回调")
        }
        lbl2.blast { isFinished in
            print("2消失后的回调")
        }
        lbl3.blast { isFinished in
            print("3消失后的回调")
        }
    }

    
    // MARK: - 重置方法
    @objc func resetAction() {
        lbl1.isHidden = false
        lbl2.isHidden = false
        lbl3.isHidden = false
        self.initBlastView()
    }

}
