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
    var isNewList = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupLayout() {
        listView.isHidden = !isNewList
        itemView.isHidden = isNewList
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
    }
    
}
