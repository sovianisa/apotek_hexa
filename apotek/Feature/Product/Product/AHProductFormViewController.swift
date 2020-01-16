//
//  AHProductFormViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductFormDelegate {
    @objc optional func receivedProduct()
}


class AHProductFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AHProductFormOptionDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    let listInputs = ["Product Name", "Barcode", "Indication", "Product Category", "Factory", "Class of Drug"]
    var listValues = ["", "", "", AHProductCategory(), AHFactory(), AHClassOfDrug()] as [Any]
    var product = AHProduct()
    var isEdit = false

    var delegate: AHProductFormDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
        fillForm()
    }

    func settingUp() {
        self.title = (isEdit == true) ? "Edit product" : "Add product"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }

    @objc func segmentSelected(sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 1 {
            listValues[5] = AHClassOfDrug()
        }

        tableView.reloadData()

    }

    func fillForm() {
        if isEdit == true {
            listValues[0] = product.prd_name
            listValues[1] = product.prd_barcode
            listValues[2] = product.prd_indication
            listValues[3] = product.prd_pc ?? AHProductCategory()
            listValues[4] = product.prd_fct ?? AHFactory()
            listValues[5] = product.prd_cod ?? AHClassOfDrug()

        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if segmentedControl.selectedSegmentIndex == 0 {
                return listInputs.count
            } else {
                return listInputs.count - 1
            }
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            if indexPath.row < 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextFieldTableViewCell", for: indexPath) as! FormTextFieldTableViewCell
                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row], keyboardType: (indexPath.row == 1) ? UIKeyboardType.numberPad : UIKeyboardType.default, delegate: self)
                if isEdit == true {
                    cell.setCellEdit(value: listValues[indexPath.row] as! String)
                }

                return cell

            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormOptionTableViewCell", for: indexPath) as! FormOptionTableViewCell

                cell.setCell(tag: indexPath.row, title: listInputs[indexPath.row])
                cell.tapButton.tag = indexPath.row
                cell.tapButton.addTarget(self, action: #selector(showOption(sender:)), for: .touchUpInside)

                var title = ""

                if indexPath.row == 3 {
                    let pc = listValues[indexPath.row] as? AHProductCategory
                    title = pc?.pc_name ?? ""
                } else if indexPath.row == 4 {
                    let factory = listValues[indexPath.row] as? AHFactory
                    title = factory?.fct_name ?? ""
                } else if indexPath.row == 5 {
                    let cod = listValues[indexPath.row] as? AHClassOfDrug
                    title = cod?.cod_name ?? ""
                }

                cell.setCellEdit(value: title)


                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormExecuteButtonTableViewCell", for: indexPath) as! FormExecuteButtonTableViewCell

            cell.setUp(isEdit: isEdit)
            if isEdit == true {
                cell.executeButton.addTarget(self, action: #selector(executeEditProduct), for: .touchUpInside)
            } else {
                cell.executeButton.addTarget(self, action: #selector(executeSaveProduct), for: .touchUpInside)
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

    @objc func executeSaveProduct() {
        view.endEditing(true)
        let newProduct = AHProduct()
        newProduct.prd_name = listValues[0] as! String
        newProduct.prd_barcode = listValues[1] as! String
        newProduct.prd_indication = listValues[2] as! String
        newProduct.prd_pc = listValues[3] as? AHProductCategory
        newProduct.prd_fct = listValues[4] as? AHFactory
        newProduct.prd_cod = listValues[5] as? AHClassOfDrug

        saveProduct(product: newProduct)
        backToList()
    }

    @objc func executeEditProduct() {
        view.endEditing(true)
        let newProduct = AHProduct()
        newProduct.prd_name = listValues[0] as! String
        newProduct.prd_barcode = listValues[1] as! String
        newProduct.prd_indication = listValues[2] as! String
        newProduct.prd_pc = listValues[3] as? AHProductCategory
        newProduct.prd_fct = listValues[4] as? AHFactory
        newProduct.prd_cod = listValues[5] as? AHClassOfDrug
        editProduct(product: product, newProduct: newProduct)
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
        delegate?.receivedProduct?()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func showOption(sender: UIButton) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductFormOptionViewController") as! AHProductFormOptionViewController

        if sender.tag == 3 {
            vc.typeTitle = "Choose Product Category"
        } else if sender.tag == 4 {
            vc.typeTitle = "Choose Factory"
        } else {
            vc.typeTitle = "Choose Class of Drug"
        }

        vc.delegate = self

        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedCategoryOption(option: AHProductCategory) {
        print("selected :\(option.pc_name)")
        listValues[3] = option
        tableView.reloadData()
    }


    func receivedFactoryOption(option: AHFactory) {
        print("selected :\(option.fct_name)")
        listValues[4] = option
        tableView.reloadData()
    }


    func receivedCODOption(option: AHClassOfDrug) {
        print("selected :\(option.cod_name)")
        listValues[5] = option
        tableView.reloadData()

    }


}
