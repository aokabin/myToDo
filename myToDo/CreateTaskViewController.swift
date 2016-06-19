//
//  CreateTaskViewController.swift
//  myToDo
//
//  Created by aokabin on 2016/04/17.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit
import RealmSwift

class CreateTaskViewController: UIViewController {
	let taskNameField: UITextField = UITextField()
	let descriptionField: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor()
		
		let xPosition: CGFloat = 10
		let fieldWidth: CGFloat = 200
		let fieldHeight: CGFloat = 50
		
		taskNameField.frame = CGRectMake(xPosition, 80, fieldWidth, fieldHeight)
		taskNameField.placeholder = "Task Name"
		self.view.addSubview(taskNameField)
		
		descriptionField.frame = CGRectMake(xPosition, taskNameField.frame.origin.y + fieldHeight, fieldWidth, fieldHeight)
		descriptionField.placeholder = "Your task's description."
		self.view.addSubview(descriptionField)
		
		let saveButton: UIButton = UIButton()
		saveButton.frame = CGRectMake(xPosition, descriptionField.frame.origin.y + fieldHeight, 100, 20)
		saveButton.setTitle("SAVE", forState: .Normal)
		saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		saveButton.backgroundColor = UIColor.blueColor()
		saveButton.addTarget(self, action: "saveData:", forControlEvents: .TouchUpInside)
		self.view.addSubview(saveButton)

        // Do any additional setup after loading the view.
    }
	
	func saveData(sender: UIButton) {
		let realm = try! Realm()
		let task: Task = Task()
		let lastTask: Task? = realm.objects(Task).sorted("id").last
		task.id = lastTask == nil ? 1 : lastTask!.id + 1
		task.label = taskNameField.text!
		task.desc = descriptionField.text!
		task.done = false
		
		let postURL: NSURL = NSURL(string: "http://localhost:3000/todos")!
//		let postURL: NSURL = NSURL(string: "http://23a520e3.ngrok.io/todos")!
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: postURL)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let params: [String: AnyObject] = [
			"todo": [
				"label": taskNameField.text!,
				"done": false,
				"desc": descriptionField.text!
			]
		]
		
		do {
			request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.init(rawValue: 2))
		} catch {
			// Error Handling
			print("NSJSONSerialization Error")
			return
		}
		
		let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error in
			if (error == nil) {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//				print(result)
				let json = JSON.parse(String(result))
				print(json["id"]) 
			} else {
				print("しっぱい！！")
				print(error!)
			}
		})
		
		requestTask.resume()
		
		
		try! realm.write({
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
