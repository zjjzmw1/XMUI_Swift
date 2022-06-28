//
//  DemoToastVC.swift
//  XMUI_Swift
//
//  Created by ext.zhangmingwei1 on 2022/6/28.
//

import UIKit

/// Toast demo
class DemoToastVC: UIViewController {

    lazy var tableView: UITableView = {
        let tableV = UITableView.getInstanceTableView(frame: CGRect.init(x: 0, y: kNavigationStatusbarHeight, width: kScreenWidth, height: kScreenHeight - kNavigationStatusbarHeight))
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
    
    let dataArr = ["居中-短文","居中长文-逻辑阿萨德；高科技爱斯达克老规矩科利达；几个号卡戴珊；就广发卡拉斯；估计","底部-短文","底部-长文塞德里克老规矩；卡拉多；结果考虑打几个；蓝卡队如何寄过来的看法较高的萨"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "XMToast"

        self.view.addSubview(self.tableView)
    }


}

// MARK: - 表格代理
extension DemoToastVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        if self.dataArr.count > indexPath.row {
            cell.textLabel?.text = self.dataArr[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        var currentStr = ""
        if self.dataArr.count > indexPath.row {
            currentStr = self.dataArr[indexPath.row]
        }
        
        if indexPath.row <= 1 {
            XMToast.showText(text: currentStr)
        } else {
            XMToast.showText(text: currentStr, positionType: .bottom)
        }

    }

}

