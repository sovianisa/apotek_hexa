//
//  AHStockUnit.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHStockUnit: Object {
    @objc dynamic var su_barcode = ""
    @objc dynamic var su_quantity = 0
    @objc dynamic var su_expired_date = Date()
    @objc dynamic var su_shop: AHShop? = nil
    @objc dynamic var su_rec: AHReceiving? = nil
    @objc dynamic var su_rd: AHReceivingDetail? = nil
    @objc dynamic var su_status = 1
}
