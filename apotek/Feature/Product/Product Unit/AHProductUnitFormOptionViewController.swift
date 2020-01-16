//
//  AHProductUnitFormOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductUnitFormOptionDelegate {
    @objc optional func receivedProductOption(option: AHProduct)
}

class AHProductUnitFormOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var products = [AHProduct]()

    var delegate: AHProductUnitFormOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = "Choose Product"
        products = getAllProducts()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        let product = products[indexPath.row]

        cell.setCell(title: "\(product.prd_barcode) | \(product.prd_name)")

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        delegate?.receivedProductOption?(option: product)
        self.navigationController?.popViewController(animated: true)
    }

}
