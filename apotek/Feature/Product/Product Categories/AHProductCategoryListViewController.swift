//
//  AHProductCategoryListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHProductCategoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHProductCategoryFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHProductCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Product Categories"
        list = getAllProductCategories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addcategory))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let category = list[indexPath.row]
        cell.setCell(text1: "\(category.pc_name)", text2: "\(category.pc_information)", text3: "", number: "\(indexPath.row + 1)")
        cell.text2Label.numberOfLines = 5
        cell.editButton.addTarget(self, action: #selector(editCategory(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteCategory(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    @objc func editCategory(sender: UIButton) {
        let tag = sender.tag
        let category = list[tag]
        goToFormPage(isEdit: true, category: category)
    }

    @objc func deleteCategory(sender: UIButton) {
        let tag = sender.tag
        let category = list[tag]
        apotek.deletecategory(category: category)
        list = getAllProductCategories()
        tableView.reloadData()
    }

    @objc func addcategory() {
        goToFormPage(isEdit: false, category: AHProductCategory())
    }

    func goToFormPage(isEdit: Bool, category: AHProductCategory) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHProductCategoryFormViewController") as! AHProductCategoryFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.category = category
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedCategory() {
        settingUp()
    }

}
