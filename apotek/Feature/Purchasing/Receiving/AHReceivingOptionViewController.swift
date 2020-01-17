//
//  AHReceivingOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHReceivingOptionDelegate {
    @objc optional func receivedPurchaseOrderOption(option: AHPurchaseOrder)
}


class AHReceivingOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var purchaseOrders = [AHPurchaseOrder]()

    var delegate: AHReceivingOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = "Choose Purchase Order"
        purchaseOrders = getAllPurchaseOrders()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseOrders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        let po = purchaseOrders[indexPath.row]

        cell.setCell(title: "No : \(po.po_no) | Date: \(dateString(date: po.po_order_date))")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let po = purchaseOrders[indexPath.row]
        delegate?.receivedPurchaseOrderOption?(option: po)

        self.navigationController?.popViewController(animated: true)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }

}
