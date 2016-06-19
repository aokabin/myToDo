//
//  ShowTaskViewController.swift
//  myToDo
//
//  Created by aokabin on 2016/04/24.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit
import RealmSwift

class ShowTaskViewController: UIViewController {
	
	let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "goToEditView:")
		
		let realm = try! Realm()
		let task = realm.objects(Task).filter("id == \(self.delegate.taskID)").first!
		
		let taskLabel: UILabel = UILabel()
		taskLabel.frame = CGRectMake(30, 80, 300, 100)
		taskLabel.text = "\(task.label)"
		self.view.addSubview(taskLabel)
		
		let taskDesc: UILabel = UILabel()
		taskDesc.frame = CGRectMake(30, 200, 300, 100)
		taskDesc.text = "\(task.desc)"
		self.view.addSubview(taskDesc)

        // Do any additional setup after loading the view.
    }
	
	func goToEditView(button: UIBarButtonItem) {
		self.navigationController!.pushViewController(EditTaskViewController(), animated: true)
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
