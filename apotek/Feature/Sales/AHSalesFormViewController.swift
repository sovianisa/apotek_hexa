//
//  AHSalesFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

@objc protocol AHSalesFormDelegate {
    @objc optional func receivedSales()
}

class AHSalesFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHStockUnitFormOptionDelegate, AHSalesFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var noPRLabel: UILabel!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var shopButton: UIButton!

    let listInputs = ["No :", "Created Date", "Created By", "Shop", "Discount", "Total"]
    var listValues = ["", Date(), "", AHShop(), 0, 0] as [Any]
    var sale_details = [AHSalesDetail]()
    var sales = AHSales()
    var isEdit = false

    var delegate: AHSalesFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Sales" : "Add Sales"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = sales.sale_no
            listValues[1] = sales.sale_date
            listValues[2] = sales.sale_create_by
            listValues[3] = sales.sale_shop ?? AHShop()
            listValues[4] = sales.sale_discount
            listValues[5] = sales.sale_total

            noPRLabel.text = "No : \(self.listValues[0])"
            dateButton.setTitle("\(self.dateString(date: listValues[1] as! Date))", for: UIControl.State.normal)

            for item in sales.sale_prd_list {
                sale_details.append(item)
            }

        } else {
            generateForm(dt: Date())

        }
    }

    func generateNoSL(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let dateF = formatter.string(from: dt)
        return "SL" + dateF

    }

    func generateForm(dt: Date) {
        listValues[0] = self.generateNoSL(dt: dt)
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
            return sale_details.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormTrans2TableViewCell", for: indexPath) as! FormTrans2TableViewCell

            let saleDetail = sale_details[indexPath.row]

            let text1 = "\(saleDetail.sd_pup?.pup_pu?.pu_prd?.prd_barcode ?? "") | \(saleDetail.sd_pup?.pup_pu?.pu_prd?.prd_name ?? "") | \(saleDetail.sd_pup?.pup_pu?.pu_unitname ?? "")"

            let text2 = "\(saleDetail.sd_quantity)"
            let price = "\(saleDetail.sd_pup?.pup_price ?? 0)"
            let text3 = "\(saleDetail.sd_quantity * (saleDetail.sd_pup?.pup_price ?? 0))"

            cell.setCell(text1: text1, text2: text2, price: price, text3: text3, number: indexPath.row + 1, tag: indexPath.row)

            cell.priceTextField.delegate = self


            cell.deleteButton.addTarget(self, action: #selector(deleteRequestDetail(sender:)), for: .touchUpInside)

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditSales), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveSales), for: .touchUpInside)

            }

            cell.totalLabel.isHidden = false
            cell.totalLabel.text = countTotalSale()

            return cell
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }


    func countTotalSale() -> String {
        var total = 0
        for item in sale_details {
            total = total + item.sd_total_price
        }

        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = NSLocale(localeIdentifier: "id_ID") as Locale

        let withTax = ((total * 10) / 100) + total
        let amountString = currencyFormatter.string(from: NSNumber.init(value: total))
        let withTaxString = currencyFormatter.string(from: NSNumber.init(value: withTax))

        return "Total : \(amountString ?? "0") \n Include Tax : \(withTaxString ?? "0")"
    }



    func isValidForm() -> Bool {


        if sale_details.count > 0 {
            for item in sale_details {
                if item.sd_quantity == 0 {
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
        sale_details.remove(at: sender.tag)
        tableView.reloadData()
    }

    @objc func executeSaveSales() {
        view.endEditing(true)

        if isValidForm() {

            let newSales = AHSales()

            newSales.sale_no = listValues[0] as! String
            newSales.sale_date = listValues[1] as! Date
            newSales.sale_create_by = listValues[2] as! String
            newSales.sale_shop = listValues[3] as? AHShop
            newSales.sale_discount = listValues[4] as! Int
            newSales.sale_total = listValues[5] as! Int

            for item in sale_details {
                newSales.sale_prd_list.append(item)
            }

            saveSales(sales: newSales)
            backToList()
        }
    }

    @objc func executeEditSales() {
        view.endEditing(true)

        if isValidForm() {
            let newSales = AHSales()

            newSales.sale_no = listValues[0] as! String
            newSales.sale_date = listValues[1] as! Date
            newSales.sale_create_by = listValues[2] as! String
            newSales.sale_shop = listValues[3] as? AHShop
            newSales.sale_discount = listValues[4] as! Int
            newSales.sale_total = listValues[5] as! Int

            for item in sale_details {
                newSales.sale_prd_list.append(item)
            }

            editSales(sales: sales, newSales: newSales)

            backToList()
        }
    }


    @IBAction func tapDateButton(_ sender: Any) {
        DatePickerDialog().show("Sale Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.generateForm(dt: dt)
            }
        }
    }


    @IBAction func tapChooseShop(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AHStockUnit", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AHStockUnitFormOptionViewController") as! AHStockUnitFormOptionViewController
        vc.delegate = self
        vc.mode = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }


    @IBAction func tapAddButton(_ sender: Any) {

        let stockUnit = getStockUnit(barcode: barcodeTextField.text ?? "")
        let productUnitPrice = getProductUnitPrice(barcode: barcodeTextField.text ?? "")
        if stockUnit.su_quantity != 0 {
            let saleDetail = AHSalesDetail.init()
            saleDetail.sd_quantity = 1
            saleDetail.sd_pup = productUnitPrice
            saleDetail.sd_su = stockUnit
            let totalPrice = saleDetail.sd_quantity * (saleDetail.sd_pup?.pup_price ?? 0)
            saleDetail.sd_total_price = totalPrice
            sale_details.append(saleDetail)
            tableView.reloadData()
            barcodeTextField.text = ""
        } else {

            let alert = UIAlertController(title: nil, message: "Stock is not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func tapSearchButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHSalesFormOptionViewController") as! AHSalesFormOptionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        if textField == barcodeTextField {

        } else {

            if textField.tag < sale_details.count {
                let saleDetail = sale_details[textField.tag]
                let quantity = Int(textField.text ?? "")

                if isEdit == true {
                    let realm = try! Realm()
                    try! realm.write() {
                        saleDetail.sd_quantity = quantity ?? 0
                    }
                } else {
                    saleDetail.sd_quantity = quantity ?? 0
                }
            }

        }


        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    func backToList() {
        delegate?.receivedSales?()
        self.navigationController?.popViewController(animated: true)
    }


    func receivedProductUnitPriceOption(option: AHProductUnitPrice) {
        print("selected :\(option.pup_pu?.pu_prd?.prd_name ?? "")")
        let saleDetail = AHSalesDetail.init()
        saleDetail.sd_quantity = 1
        saleDetail.sd_pup = option
        saleDetail.sd_su = getStockUnit(barcode: option.pup_pu?.pu_prd?.prd_barcode ?? "")
        let totalPrice = saleDetail.sd_quantity * (saleDetail.sd_pup?.pup_price ?? 0)
        saleDetail.sd_total_price = totalPrice
        sale_details.append(saleDetail)
        tableView.reloadData()
    }

    func receivedShopOption(option: AHShop) {
        listValues[3] = option
        shopButton.setTitle("\(option.shop_name)", for: UIControl.State.normal)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

}
