//
//  TaskTableViewController.swift
//  myToDo
//
//  Created by aokabin on 2016/04/24.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit
import RealmSwift

class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// Tableで使用する配列を設定する
	private var myItems: [Task] = []
	private var myTableView: UITableView!
	let realm = try! Realm()
	
	let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		let getURL: NSURL = NSURL(string: "http://localhost:3000/todos")!
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: getURL)
		
		// NOTE: GETして差異があるものを叩く？
		request.HTTPMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let requestTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { data, response, error in
			if (error == nil) {
				let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
				let json = JSON.parse(String(result))
				print(json)
				// このあと、ここに同期させるための処理を書きます。
				// ローカルのデータを元に、データを同期させるので、こっちからデータを送るイメージ
				
			}
		})
		requestTask.resume()
		
		self.title = "Tasks"
		
		let create: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "goToCreateTask:")
		
		self.navigationItem.rightBarButtonItem = create
		
		// 戻るボタンを削除する
		self.navigationItem.hidesBackButton = true
		
		// Status Barの高さを取得する.
		let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
		
		// Viewの高さと幅を取得する.
//		UIScreen.mainScreen().bounds.size.height
		let displayWidth: CGFloat = self.view.frame.width
		let displayHeight: CGFloat = self.view.frame.height
		
		// TableViewの生成する(status barの高さ分ずらして表示).
		myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
		
		// Cell名の登録をおこなう.
//		print(UITableViewCell.self)
		myTableView.registerClass(TaskTableViewCell.self, forCellReuseIdentifier: "MyCell")
		
		// DataSourceの設定をする.
		myTableView.dataSource = self
		
		// Delegateを設定する.
		myTableView.delegate = self
		
		let tasks = self.realm.objects(Task)
		
		for task in tasks {
			myItems.append(task)
//			print(task.done)
		}
		
		// Viewに追加する.
		self.view.addSubview(myTableView)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	/*
	Cellが選択された際に呼び出されるデリゲートメソッド.
	*/
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("Num: \(indexPath.row)")
		print("Value: \(myItems[indexPath.row].label)")
		
		self.delegate.taskID = myItems[indexPath.row].id
		
		self.navigationController!.pushViewController(ShowTaskViewController(), animated: true)
	}
	
	/*
	Cellの総数を返すデータソースメソッド.
	(実装必須)
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myItems.count
	}
	
	/*
	Cellに値を設定するデータソースメソッド.
	(実装必須)
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// 再利用するCellを取得する.
		let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! TaskTableViewCell
		
		// titleLabelのtext
		cell.titleLabel.text = "hogehoge"
		cell.contentLabel.text = "\(myItems[indexPath.row].label)"
		
		cell.mySwitch.on = myItems[indexPath.row].done
		
		// mySwitchが切り替えられた時に実行されるメソッド
		cell.mySwitch.addTarget(self, action: "onClickMySwitch:", forControlEvents: UIControlEvents.ValueChanged)
		
		cell.mySwitch.tag = indexPath.row
		
		return cell
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let deleteTask: UITableViewRowAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action: UITableViewRowAction, indexPath: NSIndexPath) in
			
			// 一旦実行されているかどうかの確認
			print("Delete")
			
			let removeItem = self.myItems[indexPath.row]
			
			// 実際のタスクのリストから削除
			self.myItems.removeAtIndex(indexPath.row)
			
			// TableViewからの削除
			self.myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			
			// Realmの中から削除
			try! self.realm.write({
				self.realm.delete(removeItem)
			})
			
			
		})
		
		return [deleteTask]
	}
	
	func onClickMySwitch(button: UISwitch) {
		
//		self.myTableView.cellForRowAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>)
		
		let task = myItems[button.tag]
		try! realm.write({
			// 書き換えはトランザクションの中で行う
			task.done = button.on
			realm.add(task)
		})
//		self.myTableView.reloadRowsAtIndexPaths(<#T##indexPaths: [NSIndexPath]##[NSIndexPath]#>, withRowAnimation: <#T##UITableViewRowAnimation#>)
	}
	
	func goToCreateTask(button: UIBarButtonItem){
		self.navigationController!.pushViewController(CreateTaskViewController(), animated: true)
	}

}
