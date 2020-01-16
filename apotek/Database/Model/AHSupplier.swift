//
//  AHSupplier.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHSupplier: Object {
    @objc dynamic var sup_name = ""
    @objc dynamic var sup_city = ""
    @objc dynamic var sup_address = ""
    @objc dynamic var sup_phone = ""
    @objc dynamic var sup_status = 1
}
