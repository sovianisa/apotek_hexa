//
//  AHProductUnitPriceFormOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductUnitPriceFormOptionDelegate {
    @objc optional func receivedProductUnitOption(option: AHProductUnit)
}

class AHProductUnitPriceFormOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var productUnits = [AHProductUnit]()

    var delegate: AHProductUnitPriceFormOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = "Choose Product Unit"
        productUnits = getAllProductUnits()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        searchTextField.autocapitalizationType = .words
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(AHProductUnitPriceFormOptionViewController.textFieldDidChange(_:)),
        for: .editingChanged)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productUnits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        let productUnit = productUnits[indexPath.row]

        cell.setCell(title: "\(productUnit.pu_prd?.prd_barcode ?? "") | \(productUnit.pu_prd?.prd_name ?? "") - \(productUnit.pu_unitname)")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productUnit = productUnits[indexPath.row]
        delegate?.receivedProductUnitOption?(option: productUnit)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if  let text = textField.text {
            if text.count > 2 {
                productUnits = searchProductUnits(keyword: text)
                tableView.reloadData()
            }
        }
    }
    
    
}
