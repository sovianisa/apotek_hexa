//
//  AHClassOfDrug.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHClassOfDrug: Object {
    @objc dynamic var cod_name = ""
    @objc dynamic var cod_information = ""
    @objc dynamic var cod_status = 1
}
