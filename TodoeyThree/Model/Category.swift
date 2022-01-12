//
//  Category.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = "#777777"
    var items = List<Item>()
}
