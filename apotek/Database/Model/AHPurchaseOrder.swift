//
//  AHPurchaseOrder.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHPurchaseOrder: Object {
    @objc dynamic var po_no = ""
    @objc dynamic var po_create_by = ""
    @objc dynamic var po_order_date = Date()
    @objc dynamic var po_status = 1
    @objc dynamic var po_pr : AHPurchaseRequest? = nil
    @objc dynamic var po_sup : AHSupplier? = nil
    var po_prd_list = List<AHPurchaseOrderDetail>()
}
