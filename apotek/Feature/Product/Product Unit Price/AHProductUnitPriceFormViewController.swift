//
//  AHProductUnitPriceFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductUnitPriceFormDelegate {
    @objc optional func receivedProductUnitPrice()
}

class AHProductUnitPriceFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHProductUnitPriceFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Product Unit", "Purchase Price", "Purchase Price in Tax", "Sale Price", "Sale Price in Tax", "Margin (%)", "Start Date", "End Date"]
    var listValues = [AHProductUnit(), 0, 0, 0, 0, 0, Date(), Date()] as [Any]
    var productUnitPrice = AHProductUnitPrice()
    var isEdit = false

    var delegate: AHProductUnitPriceFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Product Unit Price" : "Add Product Unit Price"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = productUnitPrice.pup_pu ?? AHProductUnit()
            listValues[1] = productUnitPrice.pup_purchase_price
            listValues[2] = productUnitPrice.pup_purchase_price_in_tax
            listValues[3] = productUnitPrice.pup_price
            listValues[4] = productUnitPrice.pup_price_in_tax
            listValues[5] = productUnitPrice.pup_margin
            listValues[6] = productUnitPrice.pup_date_start
            listValues[7] = productUnitPrice.pup_date_end
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

            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormOptionTableViewCell", for: indexPath) as! FormOptionTableViewCell

                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row])
                cell.tapButton.tag = indexPath.row
                cell.tapButton.addTarget(self, action: #selector(showOption(sender:)), for: .touchUpInside)

                let productUnit = listValues[indexPath.row] as? AHProductUnit

                if productUnit?.pu_unitname != "" {
                    cell.setCellEdit(value: "\(productUnit?.pu_prd?.prd_barcode ?? "") | \(productUnit?.pu_prd?.prd_name ?? "") - \(productUnit?.pu_unitname ?? "")")
                } else {
                    cell.setCellEdit(value: "")
                }

                return cell
            } else if indexPath.row == 6 || indexPath.row == 7 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormOptionTableViewCell", for: indexPath) as! FormOptionTableViewCell

                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row])
                cell.tapButton.tag = indexPath.row
                cell.tapButton.addTarget(self, action: #selector(showDatePicker(sender:)), for: .touchUpInside)

                let dt = listValues[indexPath.row] as! Date
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"

                let title = formatter.string(from: dt)

                cell.setCellEdit(value: title)

                return cell
            } else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell
                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: UIKeyboardType.default, delegate: self)

                cell.setCellEditInt(value: listValues[indexPath.row] as! Int)


                if indexPath.row == 2 || indexPath.row == 4 {
                    cell.inputTextField.isEnabled = false
                } else {
                    cell.inputTextField.isEnabled = true
                }

                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditproductUnitPrice), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveProductUnitPrice), for: .touchUpInside)
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

    @objc func executeSaveProductUnitPrice() {
        view.endEditing(true)
        let newProductUnitPrice = AHProductUnitPrice()

        newProductUnitPrice.pup_pu = listValues[0] as? AHProductUnit
        newProductUnitPrice.pup_purchase_price = listValues[1] as! Int
        newProductUnitPrice.pup_purchase_price_in_tax = listValues[2] as! Int
        newProductUnitPrice.pup_price = listValues[3] as! Int
        newProductUnitPrice.pup_price_in_tax = listValues[4] as! Int
        newProductUnitPrice.pup_margin = listValues[5] as! Int
        newProductUnitPrice.pup_date_start = listValues[6] as! Date
        newProductUnitPrice.pup_date_end = listValues[7] as! Date

        saveproductUnitPrice(productUnitPrice: newProductUnitPrice)
        backToList()
    }

    @objc func executeEditproductUnitPrice() {
        view.endEditing(true)
        let newProductUnitPrice = AHProductUnitPrice()
        newProductUnitPrice.pup_pu = listValues[0] as? AHProductUnit
        newProductUnitPrice.pup_purchase_price = listValues[1] as! Int
        newProductUnitPrice.pup_purchase_price_in_tax = listValues[2] as! Int
        newProductUnitPrice.pup_price = listValues[3] as! Int
        newProductUnitPrice.pup_price_in_tax = listValues[4] as! Int
        newProductUnitPrice.pup_margin = listValues[5] as! Int
        newProductUnitPrice.pup_date_start = listValues[6] as! Date
        newProductUnitPrice.pup_date_end = listValues[7] as! Date

        editProductUnitPrice(productUnitPrice: productUnitPrice, newProductUnitPrice: newProductUnitPrice)

        backToList()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        print("tango :\(textField.tag)")

        let value = Int(textField.text ?? "")
        listValues[textField.tag] = value ?? 0

        if textField.tag == 1 {
            let purchasePrice = listValues[1] as! Int
            let tax = (purchasePrice * 10) / 100

            listValues[2] = purchasePrice + tax

            let indexPath = IndexPath(row: 2, section: 0)
            tableView.reloadRows(at: [indexPath], with: .fade)

        } else if textField.tag == 3 {
            let salePrice = listValues[3] as! Int
            let purchasePrice = listValues[1] as! Int
            let tax = (salePrice * 10) / 100
            let percentMargin = (((salePrice - purchasePrice) * 100) / purchasePrice)
            print("museee :\(percentMargin)")

            listValues[4] = salePrice + tax
            listValues[5] = percentMargin

            let indexPath4 = IndexPath(row: 4, section: 0)
            let indexPath5 = IndexPath(row: 5, section: 0)
            tableView.reloadRows(at: [indexPath4], with: .fade)
            tableView.reloadRows(at: [indexPath5], with: .fade)

        } else if textField.tag == 5 {
            let percentMargin = listValues[5] as! Int
            let purchasePrice = listValues[1] as! Int
            let profit = (percentMargin * purchasePrice) / 100
            let salePrice = purchasePrice + profit
            let tax = (salePrice * 10) / 100

            listValues[3] = salePrice
            listValues[4] = salePrice + tax

            let indexPath3 = IndexPath(row: 3, section: 0)
            let indexPath4 = IndexPath(row: 4, section: 0)
            tableView.reloadRows(at: [indexPath3], with: .fade)
            tableView.reloadRows(at: [indexPath4], with: .fade)

        }

        print("avas : \(listValues)")

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedProductUnitPrice?()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showOption(sender: UIButton) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductUnitPriceFormOptionViewController") as! AHProductUnitPriceFormOptionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func showDatePicker(sender: UIButton) {

        DatePickerDialog().show("\(sender.tag == 6 ? "Start Date" : "End Date")", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.listValues[sender.tag] = dt
                self.tableView.reloadData()
            }
        }

    }

    func receivedProductUnitOption(option: AHProductUnit) {
        print("selected :\(option.pu_unitname)")
        listValues[0] = option
        tableView.reloadData()
    }


}
