//
//  AHSales.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHSales: Object {
    @objc dynamic var sale_no = ""
    @objc dynamic var sale_create_by = ""
    @objc dynamic var sale_date = Date()
    @objc dynamic var sale_discount = 0
    @objc dynamic var sale_total = 0
    @objc dynamic var payment = "Cash"
    @objc dynamic var sale_status = 1
    @objc dynamic var sale_shop: AHShop? = nil
    var sale_prd_list = List<AHSalesDetail>()
}
