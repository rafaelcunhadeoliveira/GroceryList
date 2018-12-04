//
//  ListViewController.swift
//  GroceryList
//
//  Created by Rafael Cunha on 30/11/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit
import SystemConfiguration

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var lists: [List] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpProperties()
    }

    func setUpProperties() {
        if FirebaseController.shared.verifyInternet() {
            getLists()
        } else {
            AlertHelper.show(message: "No Internet Connection", tapHandler: {_ in})
        }
    }
    
    func getLists() {
        Loading.shared.showLoading()
        FirebaseController.shared.getLists(completion: {(listsResponse) in
            self.lists = listsResponse
            self.tableView.reloadData()
            Loading.shared.hideLoading()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let vc = segue.destination as? ListDetailViewController,
                let index = sender as? IndexPath{
                vc.listId = lists[index.row].listId
                vc.listDesc = lists[index.row].desc
            }
        }
    }

    @IBAction func addItemButtonClicked(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "AddItemsViewController")
            as? AddItemsViewController else { return }
        vc.isNewList = true
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell")
            as? ListTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = lists[indexPath.row].title
        cell.dateLabel.text = lists[indexPath.row].date
        return cell
    }
}

extension ListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailsSegue", sender: indexPath)
    }
}
