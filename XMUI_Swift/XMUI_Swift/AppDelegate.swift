//
//  AppDelegate.swift
//  XMUI_Swift
//
//  Created by 张明炜 on 2022/6/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        let vc = ViewController.init()
        let navi = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = navi

        return true
    }

}

