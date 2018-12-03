//
//  Item.swift
//  GroceryList
//
//  Created by Rafael Cunha de Oliveira on 01/12/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import Firebase

class Item {
    var title: String
    var quantity: String
    var measure: String
    var listId: String

    init(title: String, quantity: String,
         measure: String, listId: String = "") {
        self.title = title
        self.quantity = quantity
        self.measure = measure
        self.listId = listId
    }

    convenience init() {
        self.init(title: "", quantity: "", measure: "", listId: "")
    }

    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let quantity = value["quantity"] as? String,
            let measure = value["measure"] as? String,
            let listId = value["listId"] as? String else {
                return nil
        }
        
        self.listId = listId
        self.title = name
        self.quantity = quantity
        self.measure = measure
    }

    func toAnyObj() -> Any {
        return [
            "name": title,
            "quantity": quantity,
            "measure": measure,
            "listId": listId
        ]
    }
}
