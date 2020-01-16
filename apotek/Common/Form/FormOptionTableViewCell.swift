//
//  FormOptionTableViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class FormOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var tapButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        contentsView.layer.borderColor = UIColor.lightGray.cgColor
        contentsView.layer.borderWidth = 1
        contentsView.layer.masksToBounds = true
        contentsView.layer.cornerRadius = 10
    }
    
    func setCell(tag:Int, title:String){
        tapButton.tag = tag
        titleLabel.text = title
    }
    
    func setCellEdit(value:String) {
        chooseLabel.text = value
    }
    
    

}
