//
//  AHReceiving.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHReceiving: Object {
    @objc dynamic var rec_no = ""
    @objc dynamic var rec_by = ""
    @objc dynamic var rec_date = Date()
    @objc dynamic var rec_status = 1
    @objc dynamic var rec_po: AHPurchaseOrder? = nil
    var rec_prd_list = List<AHReceivingDetail>()
}
