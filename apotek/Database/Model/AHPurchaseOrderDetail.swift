//
//  AHPurchaseOrderDetail.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHPurchaseOrderDetail: Object {
    @objc dynamic var pod_quantity = 0
    @objc dynamic var pod_price = 0
    @objc dynamic var pod_total_price = 0
    @objc dynamic var pod_status = 1
    @objc dynamic var pod_pu : AHProductUnit? = nil
   
}
