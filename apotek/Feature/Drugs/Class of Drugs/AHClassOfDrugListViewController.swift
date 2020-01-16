//
//  AHClassOfDrugListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHClassOfDrugListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHClassOfDrugFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHClassOfDrug]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Class of Drugs"
        list = getAllClassOfDrugs()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClassOfDrug))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let drug = list[indexPath.row]
        cell.setCell(text1: "\(drug.cod_name)", text2: "\(drug.cod_information)", text3: "", number: "\(indexPath.row + 1)")
        cell.text2Label.numberOfLines = 5
        cell.editButton.addTarget(self, action: #selector(editdrug(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletedrug(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    @objc func editdrug(sender: UIButton) {
        let tag = sender.tag
        let drug = list[tag]
        goToFormPage(isEdit: true, drug: drug)
    }

    @objc func deletedrug(sender: UIButton) {
        let tag = sender.tag
        let drug = list[tag]
        apotek.deleteClassOfDrug(drug: drug)
        list = getAllClassOfDrugs()
        tableView.reloadData()
    }

    @objc func addClassOfDrug() {
        goToFormPage(isEdit: false, drug: AHClassOfDrug())
    }

    func goToFormPage(isEdit: Bool, drug: AHClassOfDrug) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHClassOfDrugFormViewController") as! AHClassOfDrugFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.drug = drug
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedClassOfDrug() {
       settingUp()
    }

}
