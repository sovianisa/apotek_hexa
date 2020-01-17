//
//  AHPurchaseOrderOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHPurchaseOrderOptionDelegate {
    @objc optional func receivedSupplierOption(option: AHSupplier)
    @objc optional func receivedPurchaseRequestOption(option: AHPurchaseRequest)
}


class AHPurchaseOrderOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var suppliers = [AHSupplier]()
    var purchaseRequests = [AHPurchaseRequest]()

    var delegate: AHPurchaseOrderOptionDelegate?
    var isSupplierMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = (isSupplierMode == true) ? "Choose Supplier" : "Choose Product Request"

        suppliers = getAllSuppliers()
        purchaseRequests = getAllPurchaseRequests()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isSupplierMode == true {
            return suppliers.count
        } else {
            return purchaseRequests.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        if isSupplierMode == true {
            let supplier = suppliers[indexPath.row]
            cell.titleLabel.numberOfLines = 2
            cell.setCell(title: "\(supplier.sup_name) \n\(supplier.sup_address)")
        } else {
            let pr = purchaseRequests[indexPath.row]
            cell.setCell(title: "No : \(pr.pr_no) | Date: \(dateString(date: pr.pr_created_date))")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSupplierMode == true {
            let supplier = suppliers[indexPath.row]
            delegate?.receivedSupplierOption?(option: supplier)
        } else {
            let pr = purchaseRequests[indexPath.row]
            delegate?.receivedPurchaseRequestOption?(option: pr)
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    func dateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let result = formatter.string(from: date)
        return result
    }
}
