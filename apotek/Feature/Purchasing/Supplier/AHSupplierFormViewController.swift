//
//  AHSupplierFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHSupplierFormDelegate {
    @objc optional func receivedSupplier()
}

class AHSupplierFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Supplier Name", "Address", "City", "Phone Number"]
    var listValues = ["", "", "", ""]
    var supplier = AHSupplier()
    var isEdit = false

    var delegate: AHSupplierFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Supplier" : "Add Supplier"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = supplier.sup_name
            listValues[1] = supplier.sup_address
            listValues[2] = supplier.sup_city
            listValues[3] = supplier.sup_phone
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

            cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: (indexPath.row == 3) ? UIKeyboardType.phonePad : UIKeyboardType.namePhonePad, delegate: self)


            if isEdit == true {
                cell.setCellEdit(value: listValues[indexPath.row])
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditsupplier), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSavesupplier), for: .touchUpInside)
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

    @objc func executeSavesupplier() {
        view.endEditing(true)
        let newSupplier = AHSupplier()
        newSupplier.sup_name = listValues[0]
        newSupplier.sup_address = listValues[1]
        newSupplier.sup_city = listValues[2]
        newSupplier.sup_phone = listValues[3]
        saveSupplier(supplier: newSupplier)
        backToList()
    }

    @objc func executeEditsupplier() {
        view.endEditing(true)
        let newSupplier = AHSupplier()
        newSupplier.sup_name = listValues[0]
        newSupplier.sup_address = listValues[1]
        newSupplier.sup_city = listValues[2]
        newSupplier.sup_phone = listValues[3]
        editSupplier(supplier: supplier, newSupplier: newSupplier)
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
        delegate?.receivedSupplier?()
        self.navigationController?.popViewController(animated: true)
    }

}
