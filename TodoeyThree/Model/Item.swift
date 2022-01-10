//
//  Item.swift
//  TodoeyThree
//
//  Created by Keith Steffen on 1/10/22.
//

import Foundation
import RealmSwift

class Item: Object {
    static let oneYear = TimeInterval(365.0*24.0*60.0*60.0)
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: String = (Date()-oneYear).description
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
