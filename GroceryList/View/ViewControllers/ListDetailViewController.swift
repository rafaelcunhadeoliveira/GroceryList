//
//  ListDetailViewController.swift
//  GroceryList
//
//  Created by Rafael Cunha on 30/11/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit


class ListDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var items: [Item] = []
    var listId: String?
    var listDesc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpProperties()
    }
    
    func setUpProperties() {
        if FirebaseController.shared.verifyInternet() {
            getItems()
        } else {
            AlertHelper.show(message: "No Internet Connection", tapHandler: {_ in})
        }
    }

    func getItems() {
        Loading.shared.showLoading()
        FirebaseController.shared.getItems(completion: {(itemsResponse) in
            var itemsTemp: [Item] = []
            guard let id = self.listId else { return }
            for item in itemsResponse {
                if item.listId == id {
                    itemsTemp.append(item)
                }
            }
            self.items = itemsTemp
            self.tableView.reloadData()
            Loading.shared.hideLoading()
        })
    }
    
    @IBAction func addItemButtonClicked(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "AddItemsViewController")
            as? AddItemsViewController,
            let id = self.listId else { return }
        vc.listId = id
        vc.isNewList = false
        navigationController?.pushViewController(vc, animated: true)
    }

    func buildQuantityText(item: Item) -> String {
        return "\(item.quantity) \(item.measure)"
    }
}

extension ListDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListDescriptionTableViewCell")
                as? ListDescriptionTableViewCell else { return UITableViewCell()}
            cell.descriptionLabel.text = self.listDesc
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailsTableViewCell")
                as? ListDetailsTableViewCell else { return UITableViewCell() }
            //items[indexPath.row - 1].listId = id
            let item = items[indexPath.row - 1]
            cell.itemNameLabel.text = item.title
            cell.quantityLabel.text = buildQuantityText(item: item)
            return cell
        }
        
    }
}
