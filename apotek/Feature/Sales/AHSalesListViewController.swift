//
//  AHSalesListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class AHSalesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHSalesFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHSales]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Sales"
        list = getAllSales()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSales))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let sale = list[indexPath.row]

        cell.setCell(text1: "NO : \(sale.sale_no)", text2: "Date: \(dateString(date: sale.sale_date)) | created by: \(sale.sale_create_by)", text3: "", number: "\(indexPath.row + 1)")

        cell.editButton.addTarget(self, action: #selector(editSales(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteSales(sender:)), for: .touchUpInside)
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

    @objc func editSales(sender: UIButton) {
        let tag = sender.tag
        let sales = list[tag]
        goToFormPage(isEdit: true, sales: sales)
    }

    @objc func deleteSales(sender: UIButton) {
        let tag = sender.tag
        let sales = list[tag]
        apotek.deleteSales(sales: sales)
        list = getAllSales()
        tableView.reloadData()
    }

    @objc func addSales() {
        goToFormPage(isEdit: false, sales: AHSales())
    }

    func goToFormPage(isEdit: Bool, sales: AHSales) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHSalesFormViewController") as! AHSalesFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.sales = sales
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedSales() {
        settingUp()
    }

}
