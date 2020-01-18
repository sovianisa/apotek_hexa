//
//  AHStockUnitCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllStockUnits() -> [AHStockUnit] {
    let realm = try! Realm()
    let listed = realm.objects(AHStockUnit.self).filter("su_status = 1")
    var list = [AHStockUnit]()
    for item in listed {
        list.append(item)
    }
    return list
}

func getStockUnit(barcode: String) -> AHStockUnit {
    let realm = try! Realm()
    let listed = realm.objects(AHStockUnit.self).filter("su_pu.pu_prd.prd_barcode = '\(barcode)' AND pu_status = 1")
    var list = [AHStockUnit]()
    for item in listed {
        list.append(item)
    }

    if list.count > 0 {
        return list[0]
    } else {
        return AHStockUnit()
    }
}

func searchStockUnits(keyword: String) -> [AHStockUnit] {
    let realm = try! Realm()
    let listed = realm.objects(AHStockUnit.self).filter("su_pu.pu_prd.prd_name like '\(keyword)*' AND pu_status = 1")
    var list = [AHStockUnit]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveStockUnit(stockUnit: AHStockUnit) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(stockUnit)
    }
}

func editStockUnit(stockUnit: AHStockUnit, newStockUnit: AHStockUnit) {
    let realm = try! Realm()
    try! realm.write {
        if stockUnit.isInvalidated == false {
            stockUnit.su_barcode = newStockUnit.su_barcode
            stockUnit.su_expired_date = newStockUnit.su_expired_date
            stockUnit.su_shop = newStockUnit.su_shop
            stockUnit.su_rd = newStockUnit.su_rd
        }
    }

}

func deleteStockUnit(stockUnit: AHStockUnit) {
    let realm = try! Realm()
    try! realm.write {
        if stockUnit.isInvalidated == false {
            stockUnit.su_status = 0
        }
    }
}


