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
import SystemConfiguration

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
        let listRef = listsRef.childByAutoId()
        listRef.setValue(list.toAnyObj())
    }

    func saveItem(item: Item) {
        let itemRef = itemsRef.childByAutoId()
        itemRef.setValue(item.toAnyObj())
    }

    func getLists(completion: @escaping ([List]) -> Void) {
        listsRef.observe(.value, with: { snapshot in
            var lists: [List] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let list = List.init(snapshot: snapshot) {
                    lists.append(list)
                }
                
            }
            completion(lists)
        })
    }

    func getItems(completion: @escaping ([Item]) -> Void) {
        var items: [Item] = []
        itemsRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let item = Item.init(snapshot: snapshot) {
                    items.append(item)
                }
            }
            completion(items)
        })
    }

    func verifyInternet() -> Bool {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com") else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if self.verifyNetwork(with: flags) || flags.contains(.isWWAN) {
            return true
        } else {
            return false
        }
    }

    private func verifyNetwork(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}
