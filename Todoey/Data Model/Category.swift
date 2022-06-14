//
//  Category.swift
//  Todoey
//
//  Created by Kenneth Sidibe on 2022-06-13.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name:String = ""
//    Another way of initializing an array of Item
    let items = List<Item>()
    
}
