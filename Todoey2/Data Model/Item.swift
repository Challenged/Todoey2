//
//  Item.swift
//  Todoey2
//
//  Created by Rustam on 6/10/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false

    @objc dynamic var dateCreated: Date = Date()

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")


}
