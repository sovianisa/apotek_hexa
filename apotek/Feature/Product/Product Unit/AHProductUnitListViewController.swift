//
//  AHProductUnitListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHProductUnitListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHProductUnitFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHProductUnit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Product Units"
        list = getAllProductUnits()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addproductUnit))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let productUnit = list[indexPath.row]
        cell.setCell(text1: "\(productUnit.pu_unitname) | \(productUnit.pu_prd?.prd_name ?? "")", text2: "\(productUnit.pu_convertion)", text3:"", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editproductUnit(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteproductUnit(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @objc func editproductUnit(sender: UIButton) {
        let tag = sender.tag
        let productUnit = list[tag]
        goToFormPage(isEdit: true, productUnit: productUnit)
    }

    @objc func deleteproductUnit(sender: UIButton) {
        let tag = sender.tag
        let productUnit = list[tag]
        apotek.deleteProductUnit(productUnit: productUnit)
        list = getAllProductUnits()
        tableView.reloadData()
    }

    @objc func addproductUnit() {
        goToFormPage(isEdit: false, productUnit: AHProductUnit())
    }

    func goToFormPage(isEdit: Bool, productUnit: AHProductUnit) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductUnitFormViewController") as! AHProductUnitFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.productUnit = productUnit
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedProductUnit() {
        settingUp()
    }



}
