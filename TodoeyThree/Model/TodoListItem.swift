//
//  TodoListItem.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/9/22.
//

import Foundation

class TodoListItem {
    var task: String = ""
    var isChecked: Bool = false

    init(_ task:String, _ isChecked: Bool) {
        self.task = task
        self.isChecked = isChecked
    }
}
