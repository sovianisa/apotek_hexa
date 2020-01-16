//
//  AHClassOfDrugFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHClassOfDrugFormDelegate {
    @objc optional func receivedClassOfDrug()
}


class AHClassOfDrugFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Name", "Information"]
    var listValues = ["", ""]
    var drug = AHClassOfDrug()
    var isEdit = false

    var delegate: AHClassOfDrugFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }
    func settingUp() {
        self.title = (isEdit == true) ? "Edit Class of Drug" : "Add Class of Drug"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = drug.cod_name
            listValues[1] = drug.cod_information

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
                cell.executeButton.addTarget(self, action: #selector(executeEditdrug), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSavedrug), for: .touchUpInside)
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

    @objc func executeSavedrug() {
        view.endEditing(true)
        let newDrug = AHClassOfDrug()
        newDrug.cod_name = listValues[0]
        newDrug.cod_information = listValues[1]

        saveClassOfDrug(drug:newDrug)
        backToList()
    }

    @objc func executeEditdrug() {
        view.endEditing(true)
        let newDrug = AHClassOfDrug()
        newDrug.cod_name = listValues[0]
        newDrug.cod_information = listValues[1]

        editClassOfDrug(drug: drug, newDrug: newDrug)
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
        delegate?.receivedClassOfDrug?()
        self.navigationController?.popViewController(animated: true)
    }

}
