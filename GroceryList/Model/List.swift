//
//  List.swift
//  GroceryList
//
//  Created by Rafael Cunha de Oliveira on 01/12/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import Firebase

class List {
    var listId: String
    var title: String
    var desc: String
    var date: String
    var items: [Item]

    init(listId: String = "", title: String, desc: String,
         date: String, itens: [Item] = []) {
        self.listId = listId
        self.title = title
        self.desc = desc
        self.date = date
        self.items = itens
    }

    convenience init() {
        self.init(listId:"", title: "", desc: "", date: "", itens: [])
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let description = value["description"] as? String,
            let date = value["date"] as? String else {
                return nil
        }
        
        self.listId = snapshot.key
        self.title = name
        self.desc = description
        self.date = date
        self.items = []
    }

    func toAnyObj() -> Any {
        return [
            "name": title,
            "description": desc,
            "date": date
        ]
    }
}
