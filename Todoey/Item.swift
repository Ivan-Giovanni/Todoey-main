//
//  Item.swift
//  Todoey
//
//  Created by Giovanni Zangue on 13/02/2023.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
