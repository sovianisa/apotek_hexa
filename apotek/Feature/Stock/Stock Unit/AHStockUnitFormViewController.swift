//
//  AHStockUnitFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AHStockUnitFormDelegate {
    @objc optional func receivedStockUnit()
}

class AHStockUnitFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHStockUnitFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!


    let listInputs = ["Shop", "No. Receiving", "Product", "Quantity", "Expired Date", "Barcode"]
    var listValues = [AHShop(), AHReceiving(), AHReceivingDetail(), 0, Date(), ""] as [Any]
    var stockUnit = AHStockUnit()
    var isEdit = false

    var delegate: AHStockUnitFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Stock Unit" : "Add Stock Unit"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = stockUnit.su_shop ?? AHShop()
            listValues[1] = stockUnit.su_rec ?? AHReceiving()
            listValues[2] = stockUnit.su_rd ?? AHReceivingDetail()
            listValues[3] = stockUnit.su_quantity
            listValues[4] = stockUnit.su_expired_date
            listValues[5] = stockUnit.su_barcode
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

            if indexPath.row == 3 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell
                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: UIKeyboardType.default, delegate: self)

                let receiving_detail = listValues[2] as! AHReceivingDetail
                if receiving_detail.rd_po_quantity != 0 {
                    cell.setCellEdit(value: "\(receiving_detail.rd_po_quantity)")
                } else {
                    cell.setCellEdit(value: "")
                }

                cell.inputTextField.isEnabled = false

                return cell

            } else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell
                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: UIKeyboardType.default, delegate: self)

                let barcode = listValues[5] as! String
                if barcode != "" {
                    cell.setCellEdit(value: "\(barcode)")
                } else {
                    cell.setCellEdit(value: "")
                }

                cell.inputTextField.isEnabled = false

                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormOptionTableViewCell", for: indexPath) as! FormOptionTableViewCell

                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row])
                cell.tapButton.tag = indexPath.row + 1

                if indexPath.row == 0 {
                    cell.tapButton.addTarget(self, action: #selector(showOption(sender:)), for: .touchUpInside)
                    let shop = listValues[0] as? AHShop
                    if shop?.shop_name != "" {
                        cell.setCellEdit(value: "Shop : \(shop?.shop_name ?? ""), Address : \(shop?.shop_address ?? "")")
                    } else {
                        cell.setCellEdit(value: "")
                    }
                } else if indexPath.row == 1 {
                    cell.tapButton.addTarget(self, action: #selector(showOption(sender:)), for: .touchUpInside)
                    let receiving = listValues[1] as! AHReceiving
                    if receiving.rec_no != "" {
                        cell.setCellEdit(value: "No : \(receiving.rec_no), Date : \(dateString(date: receiving.rec_date))")
                    } else {
                        cell.setCellEdit(value: "")
                    }
                } else if indexPath.row == 2 {
                    cell.tapButton.addTarget(self, action: #selector(showOption(sender:)), for: .touchUpInside)
                    let receiving_detail = listValues[2] as! AHReceivingDetail
                    if receiving_detail.rd_po_quantity != 0 {
                        cell.setCellEdit(value: "\(receiving_detail.rd_pu?.pu_prd?.prd_barcode ?? "") | \(receiving_detail.rd_pu?.pu_prd?.prd_name ?? "") | \(receiving_detail.rd_quantity)")
                    } else {
                        cell.setCellEdit(value: "")
                    }
                } else {
                    cell.tapButton.addTarget(self, action: #selector(tapDateButton(sender:)), for: .touchUpInside)
                    let date = listValues[4] as? Date
                    if date != nil {
                        cell.setCellEdit(value: "\(dateString(date: date ?? Date()))")
                    } else {
                        cell.setCellEdit(value: "")
                    }
                }

                return cell

            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditStockUnit), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveStockUnit), for: .touchUpInside)
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

    @objc func executeSaveStockUnit() {
        view.endEditing(true)
        let newStockUnit = AHStockUnit()

        newStockUnit.su_shop = listValues[0] as? AHShop
        newStockUnit.su_rec = listValues[1] as? AHReceiving
        newStockUnit.su_rd = listValues[2] as? AHReceivingDetail
        newStockUnit.su_quantity = listValues[3] as! Int
        newStockUnit.su_expired_date = listValues[4] as! Date
        newStockUnit.su_barcode = listValues[5] as! String

        saveStockUnit(stockUnit: newStockUnit)
        backToList()
    }

    @objc func executeEditStockUnit() {
        view.endEditing(true)
        let newStockUnit = AHStockUnit()
        newStockUnit.su_shop = listValues[0] as? AHShop
        newStockUnit.su_rec = listValues[1] as? AHReceiving
        newStockUnit.su_rd = listValues[2] as? AHReceivingDetail
        newStockUnit.su_quantity = listValues[3] as! Int
        newStockUnit.su_expired_date = listValues[4] as! Date
        newStockUnit.su_barcode = listValues[5] as! String

        editStockUnit(stockUnit: stockUnit, newStockUnit: newStockUnit)
        backToList()
    }

    @objc func tapDateButton(sender: UIButton) {
        DatePickerDialog().show("Date Purchase Request", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.listValues[5] = self.generateBarcode(dt: dt)
                self.tableView.reloadData()
            }
        }
    }

    func generateBarcode(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let dateF = formatter.string(from: dt)
        return "010" + dateF

    }


    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        listValues[textField.tag] = textField.text ?? ""
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedStockUnit?()
        self.navigationController?.popViewController(animated: true)
    }


    @objc func showOption(sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHStockUnitFormOptionViewController") as! AHStockUnitFormOptionViewController
        vc.delegate = self
        vc.mode = sender.tag

        if sender.tag == 3 {
            let receiving = listValues[1] as? AHReceiving
            var list = [AHReceivingDetail]()
            for item in receiving?.rec_prd_list ?? List<AHReceivingDetail>() {
                list.append(item)
            }
            vc.receiving_details = list
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

    func receivedShopOption(option: AHShop) {
        print("selected :\(option.shop_name)")
        listValues[0] = option
        tableView.reloadData()
    }

    func receivedReceivingOption(option: AHReceiving) {
        print("selected :\(option.rec_no)")
        listValues[1] = option
        tableView.reloadData()
    }

    func receivedReceivingDetailOption(option: AHReceivingDetail) {
        print("selected :\(option.rd_pu?.pu_prd?.prd_name ?? "")")
        listValues[2] = option
        listValues[3] = option.rd_quantity
        tableView.reloadData()
    }


}
