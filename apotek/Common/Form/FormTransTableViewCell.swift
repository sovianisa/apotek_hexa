//
//  FormTransTableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 16/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit

class FormTransTableViewCell: UITableViewCell {
    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var totalTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(text1:String, total:Int, number:Int, tag:Int){
        text1Label.text = text1
        totalTextField.text = "\(total)"
        totalTextField.tag = tag
        deleteButton.tag = tag
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
