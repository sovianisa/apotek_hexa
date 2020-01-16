//
//  AHProductFormOptionViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

@objc protocol AHProductFormOptionDelegate {
    @objc optional func receivedCODOption(option: AHClassOfDrug)
    @objc optional func receivedFactoryOption(option: AHFactory)
    @objc optional func receivedCategoryOption(option: AHProductCategory)
}


class AHProductFormOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var cods = [AHClassOfDrug]()
    var factories = [AHFactory]()
    var categories = [AHProductCategory]()
    var typeTitle = ""

    var delegate: AHProductFormOptionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        settingUp()
    }

    func settingUp() {
        self.title = typeTitle
        cods = getAllClassOfDrugs()
        factories = getAllFactories()
        categories = getAllProductCategories()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if typeTitle == "Choose Class of Drug" {
            return cods.count
        } else if typeTitle == "Choose Factory" {
            return factories.count
        } else {
            return categories.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style2TableViewCell", for: indexPath) as! Style2TableViewCell

        var title = ""

        if typeTitle == "Choose Class of Drug" {
            let cod = cods[indexPath.row]
            title = cod.cod_name
        } else if typeTitle == "Choose Factory" {
            let factory = factories[indexPath.row]
            title = factory.fct_name
        } else {
            let category = categories[indexPath.row]
            title = category.pc_name
        }

        cell.setCell(title: title)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typeTitle == "Choose Class of Drug" {
            let cod = cods[indexPath.row]
            delegate?.receivedCODOption?(option: cod)
        } else if typeTitle == "Choose Factory" {
            let factory = factories[indexPath.row]
            delegate?.receivedFactoryOption?(option: factory)
        } else {
            let category = categories[indexPath.row]
            delegate?.receivedCategoryOption?(option: category)
        }

        self.navigationController?.popViewController(animated: true)
    }

}
