//
//  AHReceivingFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AHReceivingFormDelegate {
    @objc optional func receivedReceiving()
}

class AHReceivingFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHReceivingOptionDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var noPRLabel: UILabel!

    @IBOutlet weak var purchaseOrderButton: UIButton!
    @IBOutlet weak var supplierButton: UIButton!


    let listInputs = ["No :", "Receiving Date", "Receiving By", "Purchase Order"]
    var listValues = ["", Date(), "", AHPurchaseOrder(), AHSupplier()] as [Any]
    var rec_details = [AHReceivingDetail]()
    var receiving = AHReceiving()
    var isEdit = false

    var delegate: AHReceivingFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Receiving" : "Add Receiving"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = receiving.rec_no
            listValues[1] = receiving.rec_date
            listValues[2] = receiving.rec_by
            listValues[3] = receiving.rec_po ?? AHPurchaseOrder()

            noPRLabel.text = "No : \(self.listValues[0])"
            dateButton.setTitle("\(self.dateString(date: listValues[1] as! Date))", for: UIControl.State.normal)
            supplierButton.setTitle("\(receiving.rec_po?.po_sup?.sup_name ?? "")", for: .normal)
            purchaseOrderButton.setTitle("No. \(receiving.rec_po?.po_no ?? "")", for: .normal)

            for item in receiving.rec_prd_list {
                rec_details.append(item)
            }

        } else {
            generateForm(dt: Date())

        }
    }

    func generateNoPR(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let dateF = formatter.string(from: dt)
        return "REC" + dateF

    }

    func generateForm(dt: Date) {
        listValues[0] = self.generateNoPR(dt: dt)
        noPRLabel.text = "No : \(self.listValues[0])"
        listValues[1] = dt
        dateButton.setTitle("\(self.dateString(date: dt))", for: UIControl.State.normal)
        listValues[2] = "Admin"
        listValues[3] = ""
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return rec_details.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormTrans3TableViewCell", for: indexPath) as! FormTrans3TableViewCell

            let rec_detail = rec_details[indexPath.row]
            let text1 = "\(rec_detail.rd_pu?.pu_prd?.prd_barcode ?? "") | \(rec_detail.rd_pu?.pu_prd?.prd_name ?? "") | \(rec_detail.rd_pu?.pu_unitname ?? "")"

            let text2 = "\(rec_detail.rd_po_quantity)"
            let quantity = "\(rec_detail.rd_quantity)"

            cell.setCell(text1: text1, text2: text2, quantity: quantity, number: indexPath.row + 1, tag: indexPath.row)

            cell.quantityTextField.delegate = self

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)

            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditreceiving), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSavereceiving), for: .touchUpInside)

            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func isValidForm() -> Bool {
        if rec_details.count > 0 {
            for item in rec_details {
                if item.rd_quantity == 0 {

                    let alert = UIAlertController(title: nil, message: "Quantity is Zero found", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
            }

            return true
        } else {
            let alert = UIAlertController(title: nil, message: "Product list is not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
    }

    @objc func executeSavereceiving() {
        view.endEditing(true)

        if isValidForm() {

            let newReceiving = AHReceiving()
            newReceiving.rec_no = listValues[0] as! String
            newReceiving.rec_date = listValues[1] as! Date
            newReceiving.rec_by = listValues[2] as! String
            newReceiving.rec_po = listValues[3] as? AHPurchaseOrder

            for item in rec_details {
                newReceiving.rec_prd_list.append(item)
            }

            saveReceiving(receiving: newReceiving)
            backToList()
        }
    }

    @objc func executeEditreceiving() {
        view.endEditing(true)

        if isValidForm() {
            let newReceiving = AHReceiving()
            newReceiving.rec_no = listValues[0] as! String
            newReceiving.rec_date = listValues[1] as! Date
            newReceiving.rec_by = listValues[2] as! String
            newReceiving.rec_po = listValues[3] as? AHPurchaseOrder

            for item in rec_details {
                newReceiving.rec_prd_list.append(item)
            }

            editReceiving(receiving: receiving, newReceiving: newReceiving)

            backToList()
        }
    }


    @IBAction func tapDateButton(_ sender: Any) {
        DatePickerDialog().show("Date Receiving", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.generateForm(dt: dt)
            }
        }
    }

    @IBAction func tapChoosePurchaseOrder(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHReceivingOptionViewController") as! AHReceivingOptionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        let recDetail = rec_details[textField.tag]
        let quantity = Int(textField.text ?? "")

        if isEdit == true {
            let realm = try! Realm()
            try! realm.write() {
                recDetail.rd_quantity = quantity ?? 0

            }
        } else {
            recDetail.rd_quantity = quantity ?? 0
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let indexPath = IndexPath(row: textField.tag, section: 0)
        let indexPath2 = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.reloadRows(at: [indexPath2], with: .automatic)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedReceiving?()
        self.navigationController?.popViewController(animated: true)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

    func receivedPurchaseOrderOption(option: AHPurchaseOrder) {
        listValues[3] = option
        purchaseOrderButton.setTitle("No. \(option.po_no)", for: .normal)
        supplierButton.setTitle("\(option.po_sup?.sup_name ?? "")", for: .normal)

        for item in option.po_prd_list {
            let recDetail = AHReceivingDetail.init()
            recDetail.rd_pu = item.pod_pu
            recDetail.rd_po_quantity = item.pod_quantity
            recDetail.rd_quantity = 0
            rec_details.append(recDetail)
        }

        tableView.reloadData()
    }

}
