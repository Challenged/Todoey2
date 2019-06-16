//
//  Category.swift
//  Todoey2
//
//  Created by Rustam on 6/10/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""

    let items = List<Item>()
}
