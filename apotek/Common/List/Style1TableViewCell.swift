//
//  Style1TableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class Style1TableViewCell: UITableViewCell {

    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var text2Label: UILabel!
    @IBOutlet weak var text3Label: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCell(text1:String, text2:String, text3:String, number:String){
        text1Label.text = text1
        text2Label.text = text2
        text3Label.text = text3
        numberLabel.text = number
        
        let result = (Int(number) ?? 0) % 2
        
        if result == 0 {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        }
        
        self.selectionStyle = .none
    }

}

