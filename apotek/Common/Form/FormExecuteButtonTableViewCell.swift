//
//  FormExecuteButtonTableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class FormExecuteButtonTableViewCell: UITableViewCell {

   
    @IBOutlet weak var executeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(isEdit:Bool){
        
        self.selectionStyle = .none
        executeButton.layer.masksToBounds = true
        executeButton.layer.cornerRadius = 10
        
        if isEdit == true {
            executeButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            executeButton.setTitle("Edit", for: .normal)
        } else {
           executeButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            executeButton.setTitle("Save", for: .normal)
        }
    }

}
