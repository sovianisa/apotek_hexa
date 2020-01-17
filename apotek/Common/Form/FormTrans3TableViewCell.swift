//
//  FormTrans3TableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class FormTrans3TableViewCell: UITableViewCell {

    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var text2Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(text1: String, text2: String, quantity: String, number: Int, tag: Int) {
        text1Label.text = text1
        text2Label.text = text2
        quantityTextField.text = "\(quantity)"
        quantityTextField.tag = tag
        numberLabel.text = "\(number)"

        let result = number % 2

        if result == 0 {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }

        self.selectionStyle = .none
    }

}
