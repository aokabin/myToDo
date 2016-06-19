//
//  TaskTableViewCell.swift
//  myToDo
//
//  Created by aokabin on 2016/05/15.
//  Copyright © 2016年 aokabin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

	var titleLabel = UILabel()
	var contentLabel = UILabel()
	var mySwitch: UISwitch = UISwitch()
//	var backColor: UIColor = UIColor.grayColor()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!)
	{
		//First Call Super
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		titleLabel = UILabel(frame: CGRectMake(10, 2, 300 , 15));
		titleLabel.text = "";
		titleLabel.font = UIFont.systemFontOfSize(12)
		self.addSubview(titleLabel);
		
		contentLabel = UILabel(frame: CGRectMake(10, 20, 300, 15));
		contentLabel.text = "";
		contentLabel.font = UIFont.systemFontOfSize(22)
		self.addSubview(contentLabel);
		
		// Switchを作成する.
		mySwitch.layer.position = CGPoint(x: UIScreen.mainScreen().bounds.size.width - mySwitch.frame.size.width, y: self.bounds.height/2)
		
		// Switchの枠線を表示する.
		mySwitch.tintColor = UIColor.blackColor()
		
		// SwitchをOnに設定する.
		mySwitch.on = true
		
//		self.backgroundColor = backColor
		
		// SwitchのOn/Off切り替わりの際に、呼ばれるイベントを設定する.
		
		// SwitchをViewに追加する.
		self.addSubview(mySwitch)
	}
	
	required init(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)!
	}

}
