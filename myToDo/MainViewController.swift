//
//  MainViewController.swift
//  myToDo
//
//  Created by aokabin on 2016/05/01.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
	
	let toDoNav = ToDoListViewController(rootViewController: TaskTableViewController())
	let settingView = SettingViewController()
//	let viewArray: [UIViewController] = [UINavigationController(rootViewController: TaskTableViewController()), UIViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()
		
    	let viewArray: [UIViewController] = [toDoNav, settingView]
		
//		toDoNav.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 0)
//		toDoNav.title = "Tasks"
		toDoNav.tabBarItem = UITabBarItem(title: "Tasks", image:nil, tag: 0)
//		toDoNav.tabBarItem.title = "hoge"
//		toDoNav.tabBarItem.title = "Tasks"
		settingView.tabBarItem = UITabBarItem(tabBarSystemItem: .More, tag: 1)
//		settingView.title = "Settings"
//		toDoNav.tabBarItem.title = "Settings"
		
		
		self.setViewControllers(viewArray, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
