//
//  AHProductUnitPrice.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHProductUnitPrice: Object {
    @objc dynamic var pup_date_start = Date()
    @objc dynamic var pup_date_end = Date()
    @objc dynamic var pup_purchase_price = 0
    @objc dynamic var pup_purchase_price_in_tax = 0
    @objc dynamic var pup_price = 0
    @objc dynamic var pup_price_in_tax = 0
    @objc dynamic var pup_margin = 0
    @objc dynamic var pup_status = 1
    @objc dynamic var pup_pu : AHProductUnit? = nil

}
