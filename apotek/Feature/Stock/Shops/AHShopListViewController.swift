//
//  AHShopListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHShopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHShopFormDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = [AHShop]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Shops"
        list = getAllShops()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShop))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let shop = list[indexPath.row]
        cell.setCell(text1: "\(shop.shop_name) - \(shop.shop_phone)", text2: "\(shop.shop_address)", text3: "\(shop.shop_city)", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editShop(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteShop(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    @objc func editShop(sender: UIButton) {
        let tag = sender.tag
        let shop = list[tag]
        goToFormPage(isEdit: true, shop: shop)
    }

    @objc func deleteShop(sender: UIButton) {
        let tag = sender.tag
        let shop = list[tag]
        apotek.deleteShop(shop: shop)
        list = getAllShops()
        tableView.reloadData()
    }

    @objc func addShop() {
        goToFormPage(isEdit: false, shop: AHShop())
    }

    func goToFormPage(isEdit: Bool, shop: AHShop) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHShopFormViewController") as! AHShopFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.shop = shop
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedShop() {
        settingUp()
    }


}
