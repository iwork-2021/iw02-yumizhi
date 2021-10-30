//
//  todoItem.swift
//  MyTodoList
//
//  Created by nju on 2021/10/16.
//

import UIKit

class todoItem: NSObject,Encodable,Decodable {
    var title:String
    var is_Checked:Bool
    
    init(title:String,is_Checked:Bool){
        self.title = title
        self.is_Checked = is_Checked
    }
}
