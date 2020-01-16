//
//  AHShopFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHShopFormDelegate {
    @objc optional func receivedShop()
}

class AHShopFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Shop Name", "Address", "City", "Phone Number"]
    var listValues = ["", "", "", ""]
    var shop = AHShop()
    var isEdit = false

    var delegate: AHShopFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Shop" : "Add Shop"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = shop.shop_name
            listValues[1] = shop.shop_address
            listValues[2] = shop.shop_city
            listValues[3] = shop.shop_phone
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
                cell.executeButton.addTarget(self, action: #selector(executeEditShop), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveShop), for: .touchUpInside)
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

    @objc func executeSaveShop() {
        view.endEditing(true)
        let newShop = AHShop()
        newShop.shop_name = listValues[0]
        newShop.shop_address = listValues[1]
        newShop.shop_city = listValues[2]
        newShop.shop_phone = listValues[3]
        saveShop(shop: newShop)
        backToList()
    }

    @objc func executeEditShop() {
        view.endEditing(true)
        let newShop = AHShop()
        newShop.shop_name = listValues[0]
        newShop.shop_address = listValues[1]
        newShop.shop_city = listValues[2]
        newShop.shop_phone = listValues[3]
        editShop(shop: shop, newShop: newShop)
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
        delegate?.receivedShop?()
        self.navigationController?.popViewController(animated: true)
    }

}
