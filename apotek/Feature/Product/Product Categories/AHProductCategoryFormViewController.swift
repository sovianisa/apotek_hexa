//
//  AHProductCategoryFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductCategoryFormDelegate {
    @objc optional func receivedCategory()
}

class AHProductCategoryFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Name", "Information"]
    var listValues = ["", ""]
    var category = AHProductCategory()
    var isEdit = false

    var delegate: AHProductCategoryFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }
    func settingUp() {
        self.title = (isEdit == true) ? "Edit Product Category" : "Add Product Category"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = category.pc_name
            listValues[1] = category.pc_information
           
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listInputs.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell

            cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: UIKeyboardType.default, delegate: self)


            if isEdit == true {
                cell.setCellEdit(value: listValues[indexPath.row])
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditCategory), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveCategory), for: .touchUpInside)
            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 85
        }
    }

    @objc func executeSaveCategory() {
        view.endEditing(true)
        let newCategory = AHProductCategory()
        newCategory.pc_name = listValues[0]
        newCategory.pc_information = listValues[1]
      
        saveProductCategory(category: newCategory)
        backToList()
    }

    @objc func executeEditCategory() {
        view.endEditing(true)
        let newCategory = AHProductCategory()
        newCategory.pc_name = listValues[0]
        newCategory.pc_information = listValues[1]
       
        editProductCategory(category: category, newCategory: newCategory)
        backToList()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        listValues[textField.tag] = textField.text ?? ""
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedCategory?()
        self.navigationController?.popViewController(animated: true)
    }


}
