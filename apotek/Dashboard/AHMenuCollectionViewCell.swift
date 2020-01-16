//
//  AHMenuCollectionViewCell.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit

class AHMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setCell(image:UIImage, title:String){
        titleLabel.text = title
        imageView.image = image
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
}
