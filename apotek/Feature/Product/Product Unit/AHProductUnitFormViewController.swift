//
//  AHProductUnitFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductUnitFormDelegate {
    @objc optional func receivedProductUnit()
}

class AHProductUnitFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHProductUnitFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!

    let listInputs = ["Product", "Product Unit Name", "Convertion"]
    var listValues = [AHProduct(), "", ""] as [Any]
    var productUnit = AHProductUnit()
    var isEdit = false

    var delegate: AHProductUnitFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit Product Unit" : "Add Product Unit"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func fillForm() {
        if isEdit == true {
            listValues[0] = productUnit.pu_prd ?? AHProduct()
            listValues[1] = productUnit.pu_unitname
            listValues[2] = productUnit.pu_convertion
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

                let product = listValues[indexPath.row] as? AHProduct
                
                if product?.prd_name != "" {
                    cell.setCellEdit(value: "\(product?.prd_barcode ?? "") | \(product?.prd_name ?? "")")
                } else {
                    cell.setCellEdit(value: "")
                }

                return cell


            } else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell
                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: UIKeyboardType.default, delegate: self)
                if isEdit == true {
                    cell.setCellEdit(value: listValues[indexPath.row] as! String)
                }

                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditProductUnit), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveProductUnit), for: .touchUpInside)
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

    @objc func executeSaveProductUnit() {
        view.endEditing(true)
        let newProductUnit = AHProductUnit()
        newProductUnit.pu_prd = listValues[0] as? AHProduct
        newProductUnit.pu_unitname = listValues[1] as! String
        newProductUnit.pu_convertion = listValues[2] as! String
      

        saveProductUnit(productUnit: newProductUnit)
        backToList()
    }

    @objc func executeEditProductUnit() {
        view.endEditing(true)
        let newProductUnit = AHProductUnit()
        newProductUnit.pu_prd = listValues[0] as? AHProduct
        newProductUnit.pu_unitname = listValues[1] as! String
        newProductUnit.pu_convertion = listValues[2] as! String
      
        editProductUnit(productUnit: productUnit, newProductUnit: newProductUnit)
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
        delegate?.receivedProductUnit?()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showOption(sender: UIButton) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductUnitFormOptionViewController") as! AHProductUnitFormOptionViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedProductOption(option: AHProduct) {
        print("selected :\(option.prd_name)")
        listValues[0] = option
        tableView.reloadData()
    }


}
