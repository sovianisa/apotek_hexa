//
//  AHProductListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHProductFormDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var list = [AHProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Products"
        list = getAllProducts()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let product = list[indexPath.row]
        
        if product.prd_cod?.cod_name != "" {
             cell.setCell(text1: "\(product.prd_barcode) | \(product.prd_name) | \(product.prd_fct?.fct_name ?? "")", text2: "COD : \(product.prd_cod?.cod_name ?? "") - Category : \(product.prd_pc?.pc_name ?? "")", text3: "\(product.prd_indication)", number: "\(indexPath.row + 1)")
        } else {
             cell.setCell(text1: "\(product.prd_barcode) | \(product.prd_name) | \(product.prd_fct?.fct_name ?? "")", text2: "Category : \(product.prd_pc?.pc_name ?? "")", text3: "\(product.prd_indication)", number: "\(indexPath.row + 1)")
        }
       
        cell.editButton.addTarget(self, action: #selector(editProduct(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteProduct(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    @objc func editProduct(sender: UIButton) {
        let tag = sender.tag
        let product = list[tag]
        goToFormPage(isEdit: true, product: product)
    }

    @objc func deleteProduct(sender: UIButton) {
        let tag = sender.tag
        let product = list[tag]
        apotek.deleteProduct(product: product)
        list = getAllProducts()
        tableView.reloadData()
    }

    @objc func addProduct() {
        goToFormPage(isEdit: false, product: AHProduct())
    }

    func goToFormPage(isEdit: Bool, product: AHProduct) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductFormViewController") as! AHProductFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedProduct() {
        settingUp()
    }

}
