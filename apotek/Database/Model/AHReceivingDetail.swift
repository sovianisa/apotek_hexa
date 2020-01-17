//
//  AHReceivingDetail.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 17/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHReceivingDetail: Object {
    @objc dynamic var rd_quantity = 0
    @objc dynamic var rd_po_quantity = 0
    @objc dynamic var rd_status = 1
    @objc dynamic var rd_pu: AHProductUnit? = nil
}
