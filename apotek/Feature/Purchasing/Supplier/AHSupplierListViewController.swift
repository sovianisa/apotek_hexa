//
//  AHSupplierListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHSupplierListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHSupplierFormDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = [AHSupplier]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Suppliers"
        list = getAllSuppliers()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSupplier))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let supplier = list[indexPath.row]
        cell.setCell(text1: "\(supplier.sup_name) - \(supplier.sup_phone)", text2: "\(supplier.sup_address)", text3: "\(supplier.sup_city)", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editsupplier(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletesupplier(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    @objc func editsupplier(sender: UIButton) {
        let tag = sender.tag
        let supplier = list[tag]
        goToFormPage(isEdit: true, supplier: supplier)
    }

    @objc func deletesupplier(sender: UIButton) {
        let tag = sender.tag
        let supplier = list[tag]
        apotek.deleteSupplier(supplier: supplier)
        list = getAllSuppliers()
        tableView.reloadData()
    }

    @objc func addSupplier() {
        goToFormPage(isEdit: false, supplier: AHSupplier())
    }

    func goToFormPage(isEdit: Bool, supplier: AHSupplier) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHSupplierFormViewController") as! AHSupplierFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.supplier = supplier
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedSupplier() {
        settingUp()
    }

}
