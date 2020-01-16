//
//  AHProductUnit.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHProductUnit: Object {
    @objc dynamic var pu_unitname = ""
    @objc dynamic var pu_convertion = ""
    @objc dynamic var pu_status = 1
    @objc dynamic var pu_prd : AHProduct? = nil
}
