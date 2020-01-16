//
//  FormTextFieldTableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class FormTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(tag:Int, title:String, keyboardType:UIKeyboardType, delegate:UITextFieldDelegate){
        titleLabel.text = title
        inputTextField.placeholder = title
        inputTextField.keyboardType = keyboardType
        inputTextField.tag = tag
        inputTextField.delegate = delegate
        inputTextField.autocorrectionType = .no
        self.selectionStyle = .none
        
    }
    
    func setCellEdit(value:String) {
        inputTextField.text = value
    }
    
    func setCellEditInt(value:Int) {
        inputTextField.text = "\(value)"
    }

}
