//
//  Item.swift
//  Todoey
//
//  Created by Kenneth Sidibe on 2022-06-13.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item:Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
//    This is the relationship between our Dbs
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
