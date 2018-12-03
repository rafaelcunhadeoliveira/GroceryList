//
//  FIrebaseController.swift
//  GroceryList
//
//  Created by Rafael Cunha on 30/11/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseController {
    
    public class var shared: FirebaseController {
        struct Static {
            static let instance: FirebaseController = FirebaseController()
        }
        return Static.instance
    }

    let listsRef = Database.database().reference(withPath: "List")
    let itemsRef = Database.database().reference(withPath: "Items")

    func saveList(list: List) {
        let listRef = listsRef.child(list.title.lowercased())
        listRef.setValue(list.toAnyObj())
    }

    func saveItem(item: Item) {
        let itemRef = itemsRef.child(item.title.lowercased())
        itemRef.setValue(item.toAnyObj())
    }

    func getLists() -> [List] {
        var lists: [List] = []
        listsRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let list = List.init(snapshot: snapshot) {
                    lists.append(list)
                }
                
            }
        })
        return lists
    }

    func getItems() -> [Item] {
        var items: [Item] = []
        listsRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let item = Item.init(snapshot: snapshot) {
                    items.append(item)
                }
            }
        })
        return items
    }
}
