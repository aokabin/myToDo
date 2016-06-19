//
//  RealmObjects.swift
//  myToDo
//
//  Created by aokabin on 2016/04/17.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import Foundation
import RealmSwift

// v0
class Task: Object {
	dynamic var id: Int = 0
	dynamic var label: String = ""
	dynamic var deadline: Double = 0
	dynamic var done: Bool = false
	dynamic var desc: String = ""
	//v1
	dynamic var remoteID: Int = 0
	
	override class func primaryKey() -> String {
		return "id"
	}
}
