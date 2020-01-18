//
//  AHSalesDetail.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHSalesDetail: Object {
    @objc dynamic var pod_quantity = 0
    @objc dynamic var pod_total_price = 0
    @objc dynamic var sd_status = 1
    @objc dynamic var sd_pup: AHProductUnitPrice? = nil
}
