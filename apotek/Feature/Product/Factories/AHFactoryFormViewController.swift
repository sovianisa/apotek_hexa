//
//  AHFactoryFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHFactoryFormDelegate {
    @objc optional func receivedFactory()
}

class AHFactoryFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Factory Name", "Address", "City", "Phone Number"]
    var listValues = ["", "", "", ""]
    var factory = AHFactory()
    var isEdit = false
    
    var delegate : AHFactoryFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Factory" : "Add Factory"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = factory.fct_name
            listValues[1] = factory.fct_address
            listValues[2] = factory.fct_city
            listValues[3] = factory.fct_phone
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
                cell.executeButton.addTarget(self, action: #selector(executeEditFactory), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveFactory), for: .touchUpInside)
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

    @objc func executeSaveFactory() {
        view.endEditing(true)
        let newFactory = AHFactory()
        newFactory.fct_name = listValues[0]
        newFactory.fct_address = listValues[1]
        newFactory.fct_city = listValues[2]
        newFactory.fct_phone = listValues[3]
        saveFactory(factory: newFactory)
        backToList()
    }

    @objc func executeEditFactory() {
        view.endEditing(true)
        let newFactory = AHFactory()
        newFactory.fct_name = listValues[0]
        newFactory.fct_address = listValues[1]
        newFactory.fct_city = listValues[2]
        newFactory.fct_phone = listValues[3]
        editFactory(factory: factory, newFactory: newFactory)
        backToList()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        listValues[textField.tag] = textField.text ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func backToList(){
        delegate?.receivedFactory?()
        self.navigationController?.popViewController(animated: true)
    }



}
