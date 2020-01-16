//
//  AHPurchaseRequest.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHPurchaseRequest: Object {
    @objc dynamic var pr_no = ""
    @objc dynamic var pr_create_by = ""
    @objc dynamic var pr_created_date = Date()
    @objc dynamic var pr_notes = ""
    @objc dynamic var pr_status = 1
    var pr_prd_list = List<AHPurchaseRequestDetail>()
}
