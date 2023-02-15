//
//  Category.swift
//  Todoey
//
//  Created by Giovanni Zangue on 13/02/2023.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    let items = List<Item>()
    
}
