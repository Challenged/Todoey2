//
//  Data.swift
//  Todoey2
//
//  Created by Rustam on 6/9/19.
//  Copyright © 2019 Rustam Duspayev. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
