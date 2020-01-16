//
//  AHShop.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHShop:  Object {
    @objc dynamic var shop_name = ""
    @objc dynamic var shop_city = ""
    @objc dynamic var shop_address = ""
    @objc dynamic var shop_phone = ""
    @objc dynamic var shop_status = 1
}
