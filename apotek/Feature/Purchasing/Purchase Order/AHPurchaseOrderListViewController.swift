//
//  AHPurchaseOrderListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class AHPurchaseOrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHPurchaseOrderFormDelegate  {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHPurchaseOrder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Purchase Orders"
        list = getAllPurchaseOrders()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPurchaseOrder))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let purchaseOrder = list[indexPath.row]

        cell.setCell(text1: "NO : \(purchaseOrder.po_no)", text2: "Date: \(dateString(date: purchaseOrder.po_order_date)) | created by: \(purchaseOrder.po_create_by)", text3: "", number: "\(indexPath.row + 1)")

        cell.editButton.addTarget(self, action: #selector(editPurchaseOrder(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletePurchaseOrder(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }


    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

    @objc func editPurchaseOrder(sender: UIButton) {
        let tag = sender.tag
        let purchaseOrder = list[tag]
        goToFormPage(isEdit: true, purchaseOrder: purchaseOrder)
    }

    @objc func deletePurchaseOrder(sender: UIButton) {
        let tag = sender.tag
        let purchaseOrder = list[tag]
        apotek.deletepurchaseOrder(purchaseOrder: purchaseOrder)
        list = getAllPurchaseOrders()
        tableView.reloadData()
    }

    @objc func addPurchaseOrder() {
        goToFormPage(isEdit: false, purchaseOrder: AHPurchaseOrder())
    }

    func goToFormPage(isEdit: Bool, purchaseOrder: AHPurchaseOrder) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHPurchaseOrderFormViewController") as! AHPurchaseOrderFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.purchaseOrder = purchaseOrder
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedPurchaseOrder() {
        settingUp()
    }

}
