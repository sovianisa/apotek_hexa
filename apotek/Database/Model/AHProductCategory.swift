//
//  AHProductCategory.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

class AHProductCategory: Object {
    @objc dynamic var pc_name = ""
    @objc dynamic var pc_information = ""
    @objc dynamic var pc_status = 1
}
