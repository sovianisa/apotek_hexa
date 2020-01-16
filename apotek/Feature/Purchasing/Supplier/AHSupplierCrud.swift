//
//  AHSupplierCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllSuppliers() -> [AHSupplier] {
    let realm = try! Realm()
    let listed = realm.objects(AHSupplier.self).filter("sup_status = 1")
    var list = [AHSupplier]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveSupplier(supplier: AHSupplier) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(supplier)
    }
}

func editSupplier(supplier: AHSupplier, newSupplier: AHSupplier) {
    let realm = try! Realm()
    try! realm.write {
        if supplier.isInvalidated == false {
            supplier.sup_name = newSupplier.sup_name
            supplier.sup_city = newSupplier.sup_city
            supplier.sup_address = newSupplier.sup_address
            supplier.sup_phone = newSupplier.sup_phone

        }
    }

}

func deleteSupplier(supplier: AHSupplier) {
    let realm = try! Realm()
    try! realm.write {
        if supplier.isInvalidated == false {
            supplier.sup_status = 0
        }
    }
}
