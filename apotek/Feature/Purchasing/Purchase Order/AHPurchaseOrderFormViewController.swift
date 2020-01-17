//
//  AHPurchaseOrderFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AHPurchaseOrderFormDelegate {
    @objc optional func receivedPurchaseOrder()
}

class AHPurchaseOrderFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHPurchaseOrderOptionDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var noPRLabel: UILabel!

    @IBOutlet weak var purchaseRequestButton: UIButton!
    @IBOutlet weak var supplierButton: UIButton!

    let listInputs = ["No :", "Order Date", "Created By", "Purchase Request", "Supplier"]
    var listValues = ["", Date(), "", AHPurchaseRequest(), AHSupplier()] as [Any]
    var po_details = [AHPurchaseOrderDetail]()
    var purchaseOrder = AHPurchaseOrder()
    var isEdit = false

    var delegate: AHPurchaseOrderFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Purchase Order" : "Add Purchase Order"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = purchaseOrder.po_no
            listValues[1] = purchaseOrder.po_order_date
            listValues[2] = purchaseOrder.po_create_by
            listValues[3] = purchaseOrder.po_pr ?? AHPurchaseRequest()
            listValues[4] = purchaseOrder.po_sup ?? AHSupplier()

            noPRLabel.text = "No : \(self.listValues[0])"
            dateButton.setTitle("\(self.dateString(date: listValues[1] as! Date))", for: UIControl.State.normal)
            supplierButton.setTitle("\(purchaseOrder.po_sup?.sup_name ?? "")", for: .normal)
            purchaseRequestButton.setTitle("No. \(purchaseOrder.po_pr?.pr_no ?? "")", for: .normal)

            for item in purchaseOrder.po_prd_list {
                po_details.append(item)
            }

        } else {
            generateForm(dt: Date())

        }
    }

    func generateNoPR(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let dateF = formatter.string(from: dt)
        return "PO" + dateF

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
            return po_details.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormTrans2TableViewCell", for: indexPath) as! FormTrans2TableViewCell

            let po_detail = po_details[indexPath.row]
            let text1 = "\(po_detail.pod_pu?.pu_prd?.prd_barcode ?? "") | \(po_detail.pod_pu?.pu_prd?.prd_name ?? "") | \(po_detail.pod_pu?.pu_unitname ?? "")"

            let text2 = "\(po_detail.pod_quantity)"
            let price = "\(po_detail.pod_price)"
            let text3 = "\(po_detail.pod_quantity * po_detail.pod_price)"

            cell.setCell(text1: text1, text2: text2, price: price, text3: text3, number: indexPath.row + 1, tag: indexPath.row)

            cell.priceTextField.delegate = self
            cell.deleteButton.addTarget(self, action: #selector(deleteOrderDetail(sender:)), for: .touchUpInside)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            cell.totalLabel.isHidden = false
            cell.totalLabel.text = countTotalPurchase()
            
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditPurchaseOrder), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSavePurchaseOrder), for: .touchUpInside)

            }

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    func countTotalPurchase()-> String{
        var total = 0
        for item in po_details {
            total = total + item.pod_total_price
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "id_ID") as Locale

        let withTax = ((total * 10)/100 ) + total
        let amountString = currencyFormatter.string(from: NSNumber.init(value: total))
        let withTaxString = currencyFormatter.string(from: NSNumber.init(value: withTax))
        
        return "Total : \(amountString ?? "0") \n Include Tax : \(withTaxString ?? "0")"
    }

    func isValidForm() -> Bool {
        if po_details.count > 0 {
            for item in po_details {
                if item.pod_quantity == 0 {

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

    @objc func deleteOrderDetail(sender: UIButton) {
        po_details.remove(at: sender.tag)
        tableView.reloadData()
    }

    @objc func executeSavePurchaseOrder() {
        view.endEditing(true)

        if isValidForm() {

            let newPurchaseOrder = AHPurchaseOrder()
            newPurchaseOrder.po_no = listValues[0] as! String
            newPurchaseOrder.po_order_date = listValues[1] as! Date
            newPurchaseOrder.po_create_by = listValues[2] as! String
            newPurchaseOrder.po_pr = listValues[3] as? AHPurchaseRequest
            newPurchaseOrder.po_sup = listValues[4] as? AHSupplier

            for item in po_details {
                newPurchaseOrder.po_prd_list.append(item)
            }

            savePurchaseOrder(purchaseOrder: newPurchaseOrder)
            backToList()
        }
    }

    @objc func executeEditPurchaseOrder() {
        view.endEditing(true)

        if isValidForm() {
            let newPurchaseOrder = AHPurchaseOrder()
            newPurchaseOrder.po_no = listValues[0] as! String
            newPurchaseOrder.po_order_date = listValues[1] as! Date
            newPurchaseOrder.po_create_by = listValues[2] as! String
            newPurchaseOrder.po_pr = listValues[3] as? AHPurchaseRequest
            newPurchaseOrder.po_sup = listValues[4] as? AHSupplier

            for item in po_details {
                newPurchaseOrder.po_prd_list.append(item)
            }

            editPurchaseOrder(purchaseOrder: purchaseOrder, newPurchaseOrder: newPurchaseOrder)

            backToList()
        }
    }


    @IBAction func tapDateButton(_ sender: Any) {
        DatePickerDialog().show("Date Purchase Order", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.generateForm(dt: dt)
            }
        }
    }

    @IBAction func tapChoosePurchaseRequest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHPurchaseOrderOptionViewController") as! AHPurchaseOrderOptionViewController
        vc.delegate = self
        vc.isSupplierMode = false
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func tapChooseSupplier(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHPurchaseOrderOptionViewController") as! AHPurchaseOrderOptionViewController
        vc.delegate = self
        vc.isSupplierMode = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        let orderDetail = po_details[textField.tag]
        let price = Int(textField.text ?? "")

        if isEdit == true {
            let realm = try! Realm()
            try! realm.write() {
                orderDetail.pod_price = price ?? 0
                orderDetail.pod_total_price = (price ?? 0) * orderDetail.pod_quantity

            }
        } else {
            orderDetail.pod_price = price ?? 0
            orderDetail.pod_total_price = (price ?? 0) * orderDetail.pod_quantity
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
        delegate?.receivedPurchaseOrder?()
        self.navigationController?.popViewController(animated: true)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

    func receivedSupplierOption(option: AHSupplier) {
        listValues[4] = option
        supplierButton.setTitle("\(option.sup_name)", for: .normal)
    }

    func receivedPurchaseRequestOption(option: AHPurchaseRequest) {
        listValues[3] = option
        purchaseRequestButton.setTitle("No. \(option.pr_no)", for: .normal)

        for item in option.pr_prd_list {
            let orderDetail = AHPurchaseOrderDetail.init()
            orderDetail.pod_pu = item.prd_pu
            orderDetail.pod_quantity = item.prd_quantity
            po_details.append(orderDetail)
        }

        tableView.reloadData()
    }

}
