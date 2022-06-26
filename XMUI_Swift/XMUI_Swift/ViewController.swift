//
//  ViewController.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableV = UITableView.getInstanceTableView(frame: CGRect.init(x: 0, y: kNavigationStatusbarHeight, width: kScreenWidth, height: kScreenHeight - kNavigationStatusbarHeight))
        tableV.delegate = self
        tableV.dataSource = self
        return tableV
    }()
    
    let dataArr = ["XMPaddingLabel","DemoBlastVC","DemoAnimationVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "首页"

        self.view.addSubview(self.tableView)
    }

}

// MARK: - 表格代理
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        var vc = UIViewController()
        if self.dataArr.count > indexPath.row {
            currentStr = self.dataArr[indexPath.row]
        }
        
        if currentStr == "XMPaddingLabel" {
            vc = DemoLabelVC()
        }
        if currentStr == "DemoBlastVC" {
            vc = DemoBlastVC()
        }
        if currentStr == "DemoAnimationVC" {
            vc = DemoAnimationVC()
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }

}

