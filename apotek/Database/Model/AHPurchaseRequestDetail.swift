//
//  AHPurchaseRequestDetail.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHPurchaseRequestDetail: Object {
    @objc dynamic var prd_quantity = 1
    @objc dynamic var prd_status = 1
    @objc dynamic var prd_pu : AHProductUnit? = nil
}
