//
//  AHFactory.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHFactory: Object {
    @objc dynamic var fct_name = ""
    @objc dynamic var fct_city = ""
    @objc dynamic var fct_address = ""
    @objc dynamic var fct_phone = ""
    @objc dynamic var fct_status = 1
}
