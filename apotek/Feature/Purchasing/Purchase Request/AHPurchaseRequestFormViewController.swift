//
//  AHPurchaseRequestFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AHPurchaseRequestFormDelegate {
    @objc optional func receivedPurchaseRequest()
}

class AHPurchaseRequestFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHProductUnitPriceFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var noPRLabel: UILabel!
    @IBOutlet weak var barcodeTextField: UITextField!

    let listInputs = ["No :", "Created Date", "Created By", "Notes", "Product List"]
    var listValues = ["", Date(), "", "", ""] as [Any]
    var pr_details = [AHPurchaseRequestDetail]()
    var purchaseRequest = AHPurchaseRequest()
    var isEdit = false

    var delegate: AHPurchaseRequestFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Purchase Request" : "Add Purchase Request"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = purchaseRequest.pr_no
            listValues[1] = purchaseRequest.pr_created_date
            listValues[2] = purchaseRequest.pr_create_by
            listValues[3] = purchaseRequest.pr_notes

            noPRLabel.text = "No : \(self.listValues[0])"
            dateButton.setTitle("\(self.dateString(date: listValues[1] as! Date))", for: UIControl.State.normal)

            for item in purchaseRequest.pr_prd_list {
                pr_details.append(item)
            }

        } else {
            generateForm(dt: Date())

        }
    }

    func generateNoPR(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let dateF = formatter.string(from: dt)
        return "PR" + dateF

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
            return pr_details.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormTransTableViewCell", for: indexPath) as! FormTransTableViewCell

            let pr_detail = pr_details[indexPath.row]
            cell.setCell(text1: "\(pr_detail.prd_pu?.pu_prd?.prd_barcode ?? "") | \(pr_detail.prd_pu?.pu_prd?.prd_name ?? "") | \(pr_detail.prd_pu?.pu_unitname ?? "")", total: pr_detail.prd_quantity, number: indexPath.row + 1, tag: indexPath.row)
            cell.totalTextField.delegate = self
            cell.deleteButton.addTarget(self, action: #selector(deleteRequestDetail(sender:)), for: .touchUpInside)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditPurchaseRequest), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSavePurchaseRequest), for: .touchUpInside)

            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }


    func isValidForm() -> Bool {


        if pr_details.count > 0 {
            for item in pr_details {
                if item.prd_quantity == 0 {

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

    @objc func deleteRequestDetail(sender: UIButton) {
        pr_details.remove(at: sender.tag)
        tableView.reloadData()
    }

    @objc func executeSavePurchaseRequest() {
        view.endEditing(true)

        if isValidForm() {

            let newPurchaseRequest = AHPurchaseRequest()
            newPurchaseRequest.pr_no = listValues[0] as! String
            newPurchaseRequest.pr_created_date = listValues[1] as! Date
            newPurchaseRequest.pr_create_by = listValues[2] as! String
            newPurchaseRequest.pr_notes = listValues[3] as! String

            for item in pr_details {
                newPurchaseRequest.pr_prd_list.append(item)
            }

            savePurchaseRequest(purchaseRequest: newPurchaseRequest)
            backToList()
        }
    }

    @objc func executeEditPurchaseRequest() {
        view.endEditing(true)

        if isValidForm() {
            let newPurchaseRequest = AHPurchaseRequest()
            newPurchaseRequest.pr_no = listValues[0] as! String
            newPurchaseRequest.pr_created_date = listValues[1] as! Date
            newPurchaseRequest.pr_create_by = listValues[2] as! String
            newPurchaseRequest.pr_notes = listValues[3] as! String

            for item in pr_details {
                newPurchaseRequest.pr_prd_list.append(item)
            }

            editPurchaseRequest(purchaseRequest: purchaseRequest, newPurchaseRequest: newPurchaseRequest)

            backToList()
        }
    }


    @IBAction func tapDateButton(_ sender: Any) {
        DatePickerDialog().show("Date Purchase Request", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.generateForm(dt: dt)
            }
        }
    }


    @IBAction func tapAddButton(_ sender: Any) {
        let productUnit = getProductUnit(barcode: barcodeTextField.text ?? "")
        if productUnit.pu_unitname != "" {
            let requestDetail = AHPurchaseRequestDetail.init()
            requestDetail.prd_quantity = 0
            requestDetail.prd_pu = productUnit
            pr_details.append(requestDetail)
            tableView.reloadData()
            barcodeTextField.text = ""
        } else {

            let alert = UIAlertController(title: nil, message: "Product is not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func tapSearchButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AHProductUnitPrice", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHProductUnitPriceFormOptionViewController") as! AHProductUnitPriceFormOptionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField == barcodeTextField {

        } else {
            let requestDetail = pr_details[textField.tag]
            let quantity = Int(textField.text ?? "")

            if isEdit == true {
                let realm = try! Realm()
                try! realm.write() {
                    requestDetail.prd_quantity = quantity ?? 0
                }
            } else {
                requestDetail.prd_quantity = quantity ?? 0
            }

        }


        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedPurchaseRequest?()
        self.navigationController?.popViewController(animated: true)
    }


    func receivedProductUnitOption(option: AHProductUnit) {
        print("selected :\(option.pu_prd?.prd_name ?? "")")
        let requestDetail = AHPurchaseRequestDetail.init()
        requestDetail.prd_quantity = 0
        requestDetail.prd_pu = option
        pr_details.append(requestDetail)
        tableView.reloadData()
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }


}
