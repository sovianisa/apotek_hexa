//
//  AHStockUnitListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class AHStockUnitListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHStockUnitFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHStockUnit]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Stock Units"
        list = getAllStockUnits()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addstockUnit))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let stockUnit = list[indexPath.row]
        cell.setCell(text1: "\(stockUnit.su_barcode) | \(stockUnit.su_rd?.rd_pu?.pu_prd?.prd_name ?? "")", text2: "Stock : \(stockUnit.su_quantity)", text3: "No. Receiving Document : \(stockUnit.su_rec?.rec_no ?? "")", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editStockUnit(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteStockUnit(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    @objc func editStockUnit(sender: UIButton) {
        let tag = sender.tag
        let stockUnit = list[tag]
        goToFormPage(isEdit: true, stockUnit: stockUnit)
    }

    @objc func deleteStockUnit(sender: UIButton) {
        let tag = sender.tag
        let stockUnit = list[tag]
        apotek.deleteStockUnit(stockUnit: stockUnit)
        list = getAllStockUnits()
        tableView.reloadData()
    }

    @objc func addstockUnit() {
        goToFormPage(isEdit: false, stockUnit: AHStockUnit())
    }

    func goToFormPage(isEdit: Bool, stockUnit: AHStockUnit) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHStockUnitFormViewController") as! AHStockUnitFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.stockUnit = stockUnit
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedStockUnit() {
        settingUp()
    }


}
