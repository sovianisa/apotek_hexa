//
//  AHProductUnitPriceListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHProductUnitPriceListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHProductUnitPriceFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHProductUnitPrice]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Product Unit Prices"
        list = getAllProductUnitPrices()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProductUnit))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let productUnitPrice = list[indexPath.row]
        cell.setCell(text1: "\(productUnitPrice.pup_pu?.pu_prd?.prd_name ?? "") | \(productUnitPrice.pup_pu?.pu_unitname ?? "")", text2: "Purchase Price: \(productUnitPrice.pup_purchase_price) | Sale Price: \(productUnitPrice.pup_price)", text3: "Validate Date: \(dateString(date: productUnitPrice.pup_date_start)) - \(dateString(date: productUnitPrice.pup_date_end)) ", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editProductUnit(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteProductUnit(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }


    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

    @objc func editProductUnit(sender: UIButton) {
        let tag = sender.tag
        let productUnitPrice = list[tag]
        goToFormPage(isEdit: true, productUnitPrice: productUnitPrice)
    }

    @objc func deleteProductUnit(sender: UIButton) {
        let tag = sender.tag
        let productUnitPrice = list[tag]
        apotek.deleteProductUnitPrice(productUnitPrice: productUnitPrice)
        list = getAllProductUnitPrices()
        tableView.reloadData()
    }

    @objc func addProductUnit() {
        goToFormPage(isEdit: false, productUnitPrice: AHProductUnitPrice())
    }

    func goToFormPage(isEdit: Bool, productUnitPrice: AHProductUnitPrice) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductUnitPriceFormViewController") as! AHProductUnitPriceFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.productUnitPrice = productUnitPrice
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedProductUnitPrice() {
        settingUp()
    }

}
