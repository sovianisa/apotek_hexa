//
//  AHProduct.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHProduct: Object {
    @objc dynamic var prd_name = ""
    @objc dynamic var prd_indication = ""
    @objc dynamic var prd_barcode = ""
    @objc dynamic var prd_cod : AHClassOfDrug? = nil
    @objc dynamic var prd_pc : AHProductCategory? = nil
    @objc dynamic var prd_fct : AHFactory? = nil
    @objc dynamic var prd_status = 1
    
}
