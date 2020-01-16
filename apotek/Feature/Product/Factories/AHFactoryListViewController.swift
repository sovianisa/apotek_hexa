//
//  AHFactoryListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHFactoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHFactoryFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHFactory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Factories"
        list = getAllFactories()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFactory))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let factory = list[indexPath.row]
        cell.setCell(text1: "\(factory.fct_name) - \(factory.fct_phone)", text2: "\(factory.fct_address)", text3: "\(factory.fct_city)", number: "\(indexPath.row + 1)")
        cell.editButton.addTarget(self, action: #selector(editFactory(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteFactory(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    @objc func editFactory(sender: UIButton) {
        let tag = sender.tag
        let factory = list[tag]
        goToFormPage(isEdit: true, factory: factory)
    }

    @objc func deleteFactory(sender: UIButton) {
        let tag = sender.tag
        let factory = list[tag]
        apotek.deleteFactory(factory: factory)
        list = getAllFactories()
        tableView.reloadData()
    }

    @objc func addFactory() {
        goToFormPage(isEdit: false, factory: AHFactory())
    }

    func goToFormPage(isEdit: Bool, factory: AHFactory) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHFactoryFormViewController") as! AHFactoryFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.factory = factory
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedFactory() {
        settingUp()
    }

}
