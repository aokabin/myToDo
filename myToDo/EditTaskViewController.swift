//
//  EditTaskViewController.swift
//  myToDo
//
//  Created by aokabin on 2016/05/15.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit
import RealmSwift

class EditTaskViewController: UIViewController {

	let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	let taskLabel: UITextField = UITextField()
	let taskDesc: UITextField = UITextField()
	let realm = try! Realm()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		let task = realm.objects(Task).filter("id == \(self.delegate.taskID)").first!
		
		taskLabel.frame = CGRectMake(30, 80, 300, 100)
		taskLabel.text = "\(task.label)"
		self.view.addSubview(taskLabel)
		
		taskDesc.frame = CGRectMake(30, 200, 300, 100)
		taskDesc.text = "\(task.desc)"
		self.view.addSubview(taskDesc)
		
		let xPosition: CGFloat = 10
		
		let saveButton: UIButton = UIButton()
		saveButton.frame = CGRectMake(xPosition, 300, 100, 20)
		saveButton.setTitle("SAVE", forState: .Normal)
		saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		saveButton.backgroundColor = UIColor.blueColor()
		saveButton.addTarget(self, action: "saveData:", forControlEvents: .TouchUpInside)
		self.view.addSubview(saveButton)
		
		// Do any additional setup after loading the view.
	}
	
	func saveData(sender: UIButton) {
		let task: Task = realm.objects(Task).filter("id == \(self.delegate.taskID)").first!
		
		// TODO:末尾にremoteIDを追加すること！！
		let postURL: NSURL = NSURL(string: "http://localhost:3000/todos")!
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: postURL)
		request.HTTPMethod = "PATCH"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let params: [String: AnyObject] = [
			"todo": [
				"label": taskLabel.text!,
				"done": task.done,
				"desc": taskDesc.text!
			]
		]
		
		do {
			request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.init(rawValue: 2))
		} catch {
			print("NSJSONSerialization Error")
			return
		}
		
		let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
			if (error == nil) {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
				print(result)
			} else {
				print("しっぱい！！")
				print(error!)
			}
		})
		
		requestTask.resume()
		
		
		try! realm.write({
    		task.label = taskLabel.text!
    		task.desc = taskDesc.text!
			realm.add(task)
		})
		
		self.navigationController!.pushViewController(TaskTableViewController(), animated: true)
		
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
