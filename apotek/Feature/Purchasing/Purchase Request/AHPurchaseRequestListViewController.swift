//
//  AHPurchaseRequestListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHPurchaseRequestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHPurchaseRequestFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHPurchaseRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Purchase Requests"
        list = getAllPurchaseRequests()
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
        let productRequest = list[indexPath.row]
        
        cell.setCell(text1: "NO : \(productRequest.pr_no)", text2: "Date: \(dateString(date: productRequest.pr_created_date)) | created by: \(productRequest.pr_create_by)", text3: "", number: "\(indexPath.row + 1)")
        
        cell.editButton.addTarget(self, action: #selector(editPurchaseRequest(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletePurchaseRequest(sender:)), for: .touchUpInside)
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

    @objc func editPurchaseRequest(sender: UIButton) {
        let tag = sender.tag
        let purchaseRequest = list[tag]
        goToFormPage(isEdit: true, purchaseRequest:purchaseRequest)
    }

    @objc func deletePurchaseRequest(sender: UIButton) {
        let tag = sender.tag
        let purchaseRequest = list[tag]
        apotek.deletepurchaseRequest(purchaseRequest: purchaseRequest)
        list = getAllPurchaseRequests()
        tableView.reloadData()
    }

    @objc func addProductUnit() {
        goToFormPage(isEdit: false, purchaseRequest: AHPurchaseRequest())
    }

    func goToFormPage(isEdit: Bool, purchaseRequest: AHPurchaseRequest) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHPurchaseRequestFormViewController") as! AHPurchaseRequestFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.purchaseRequest = purchaseRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedPurchaseRequest() {
        settingUp()
    }

}
