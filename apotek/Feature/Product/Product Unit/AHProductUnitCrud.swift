//
//  AHProductUnitCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllProductUnits() -> [AHProductUnit] {
    let realm = try! Realm()
    let listed = realm.objects(AHProductUnit.self).filter("pu_status = 1")
    var list = [AHProductUnit]()
    for item in listed {
        list.append(item)
    }
    return list
}

func getProductUnit(barcode:String) -> AHProductUnit {
    let realm = try! Realm()
    let listed = realm.objects(AHProductUnit.self).filter("pu_prd.prd_barcode = '\(barcode)' AND pu_status = 1")
    var list = [AHProductUnit]()
    for item in listed {
        list.append(item)
    }
    
    if list.count > 0 {
        return list[0]
    } else {
        return AHProductUnit()
    }
}

func searchProductUnits(keyword:String) -> [AHProductUnit] {
    let realm = try! Realm()
    let listed = realm.objects(AHProductUnit.self).filter("pu_prd.prd_name like '\(keyword)*' AND pu_status = 1")
    var list = [AHProductUnit]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveProductUnit(productUnit: AHProductUnit) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(productUnit)
    }
}

func editProductUnit(productUnit: AHProductUnit, newProductUnit: AHProductUnit) {
    let realm = try! Realm()
    try! realm.write {

        if productUnit.isInvalidated == false {
            productUnit.pu_unitname  = newProductUnit.pu_unitname
            productUnit.pu_convertion  = newProductUnit.pu_convertion
            productUnit.pu_prd = newProductUnit.pu_prd
            

        }
    }

}

func deleteProductUnit(productUnit: AHProductUnit) {
    let realm = try! Realm()
    try! realm.write {
        if productUnit.isInvalidated == false {
            productUnit.pu_status = 0
        }
    }
}
