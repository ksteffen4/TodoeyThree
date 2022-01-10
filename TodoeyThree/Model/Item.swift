//
//  Item.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
