//
//  AHStockUnitFormOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHStockUnitFormOptionDelegate {
    @objc optional func receivedShopOption(option: AHShop)
    @objc optional func receivedReceivingDetailOption(option: AHReceivingDetail)
    @objc optional func receivedReceivingOption(option: AHReceiving)
}

class AHStockUnitFormOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var shops = [AHShop]()
    var receivings = [AHReceiving]()
    var receiving_details = [AHReceivingDetail]()

    var mode = 1
    var selectedReceiving = AHReceiving()

    var delegate: AHStockUnitFormOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {

        if mode == 1 {
            self.title = "Choose Shop"
        } else if mode == 2 {
            self.title = "Choose Receiving"
        } else {
            self.title = "Choose Product"
        }

        shops = getAllShops()
        receivings = getAllReceivings()


        for item in selectedReceiving.rec_prd_list {
            receiving_details.append(item)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == 1 {
            return shops.count
        } else if mode == 2 {
            return receivings.count
        } else {
            return receiving_details.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        if mode == 1 {
            let shop = shops[indexPath.row]
            cell.setCell(title: "Shop : \(shop.shop_name), Address : \(shop.shop_address)")
        } else if mode == 2 {
            let receiving = receivings[indexPath.row]
            cell.setCell(title: "No : \(receiving.rec_no), Date : \(dateString(date: receiving.rec_date))")
        } else {
            let receiving_detail = receiving_details[indexPath.row]
            cell.setCell(title: "\(receiving_detail.rd_pu?.pu_prd?.prd_barcode ?? "") | \(receiving_detail.rd_pu?.pu_prd?.prd_name ?? "") | \(receiving_detail.rd_quantity)")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == 1 {
            let shop = shops[indexPath.row]
            delegate?.receivedShopOption?(option: shop)
        } else if mode == 2 {
            let receiving = receivings[indexPath.row]
            delegate?.receivedReceivingOption?(option: receiving)
        } else {
            let receiving_detail = receiving_details[indexPath.row]
            delegate?.receivedReceivingDetailOption?(option: receiving_detail)
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
