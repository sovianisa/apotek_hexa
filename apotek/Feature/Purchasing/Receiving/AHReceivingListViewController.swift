//
//  AHReceivingListViewController.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class AHReceivingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AHReceivingFormDelegate {

    @IBOutlet weak var tableView: UITableView!

    var list = [AHReceiving]()

    override func viewDidLoad() {
        super.viewDidLoad()
        settingNav()
        settingUp()
    }

    func settingUp() {
        self.title = "Receivings"
        list = getAllReceivings()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func settingNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReceiving))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style1TableViewCell", for: indexPath) as! Style1TableViewCell
        let receiving = list[indexPath.row]

        cell.setCell(text1: "NO : \(receiving.rec_no)", text2: "Date: \(dateString(date: receiving.rec_date)) | created by: \(receiving.rec_by)", text3: "", number: "\(indexPath.row + 1)")

        cell.editButton.addTarget(self, action: #selector(editreceiving(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deletereceiving(sender:)), for: .touchUpInside)
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

    @objc func editreceiving(sender: UIButton) {
        let tag = sender.tag
        let receiving = list[tag]
        goToFormPage(isEdit: true, receiving: receiving)
    }

    @objc func deletereceiving(sender: UIButton) {
        let tag = sender.tag
        let receiving = list[tag]
        apotek.deleteReceiving(receiving: receiving)
        list = getAllReceivings()
        tableView.reloadData()
    }

    @objc func addReceiving() {
        goToFormPage(isEdit: false, receiving: AHReceiving())
    }

    func goToFormPage(isEdit: Bool, receiving: AHReceiving) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AHReceivingFormViewController") as! AHReceivingFormViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.delegate = self
        vc.isEdit = isEdit
        vc.receiving = receiving
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func receivedReceiving() {
        settingUp()
    }

}
