//
//  AddItemsViewController.swift
//  GroceryList
//
//  Created by Rafael Cunha on 30/11/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit

class AddItemsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var measureTextField: UITextField!
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var listView: UIView!

    var item: Item?
    var list: List?
    var listId: String?
    var isNewList = false

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }

    func setupLayout() {
        listView.isHidden = !isNewList
        itemView.isHidden = isNewList
        datePicker.datePickerMode = .date
    }

    func setObject() {
        if isNewList {
            guard let title = titleTextField.text,
                let desc = descriptionTextField.text else { return }
            list = List.init(title: title,
                             desc: desc,
                             date: getDatePickerValue())
        } else {
            guard let name = itemNameTextField.text,
                let quantity = quantityTextField.text,
                let measure = measureTextField.text,
                let id = self.listId else { return }
            item = Item.init(title: name,
                             quantity: quantity,
                             measure: measure,
                             listId: id)
        }
    }

    func getDatePickerValue() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: datePicker.date)
    }

    func validation() -> String{
        if isNewList {
            if titleTextField.text?.isEmpty ?? false {
                return "Please, enter a title for your list"
            }
            if descriptionTextField.text?.isEmpty ?? false {
                return "Please, enter a description for your list"
            }
        } else {
            if itemNameTextField.text?.isEmpty ?? false {
                return "Please, enter a name for your item"
            }
            if quantityTextField.text?.isEmpty ?? false {
                return "Please, enter a quantity for your item"
            }
            if measureTextField.text?.isEmpty ?? false {
                return "Please, enter a measure for your item"
            }
        }
        return ""
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        let response = validation()
        if response == "" {
            setObject()
            if isNewList {
                saveList()
            } else {
                saveItem()
            }
        } else {
            AlertHelper.show(title: "Error", message: response, tapHandler: {_ in })
        }
    }

    func saveItem() {
        Loading.shared.showLoading()
        guard let item = self.item else { return }
        FirebaseController.shared.saveItem(item: item)
        Loading.shared.hideLoading()
        AlertHelper.show(title: "Success", message: "List has been saved!", tapHandler: {_ in })
    }

    func saveList() {
        Loading.shared.showLoading()
        guard let list = self.list else { return }
        FirebaseController.shared.saveList(list: list)
        Loading.shared.hideLoading()
        AlertHelper.show(title: "Success", message: "Item has been saved!", tapHandler: {_ in })
    }
}
