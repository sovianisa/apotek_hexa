//
//  AHSalesFormOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHSalesFormOptionDelegate {
    @objc optional func receivedProductUnitPriceOption(option: AHProductUnitPrice)
}

class AHSalesFormOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    var productUnitPrices = [AHProductUnitPrice]()

    var delegate: AHSalesFormOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = "Choose Product"
        productUnitPrices = getAllProductUnitPrices()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        searchTextField.autocapitalizationType = .words
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(AHSalesFormOptionViewController.textFieldDidChange(_:)),
            for: .editingChanged)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productUnitPrices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        let productUnitPrice = productUnitPrices[indexPath.row]

        cell.setCell(title: "\(productUnitPrice.pup_pu?.pu_prd?.prd_barcode ?? "") | \(productUnitPrice.pup_pu?.pu_prd?.prd_name ?? "") - \(productUnitPrice.pup_pu?.pu_unitname ?? "")")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productUnitPrice = productUnitPrices[indexPath.row]
        delegate?.receivedProductUnitPriceOption?(option: productUnitPrice)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        if let text = textField.text {
            if text.count > 2 {
                productUnitPrices = searchProductUnitPrice(keyword: text)
                tableView.reloadData()
            }
        }
        }

    }
