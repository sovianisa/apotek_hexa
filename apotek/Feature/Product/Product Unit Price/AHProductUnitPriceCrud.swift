//
//  AHProductUnitPriceCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 21/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllProductUnitPrices() -> [AHProductUnitPrice] {
    let realm = try! Realm()
    let listed = realm.objects(AHProductUnitPrice.self).filter("pup_status = 1")
    var list = [AHProductUnitPrice]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveproductUnitPrice(productUnitPrice: AHProductUnitPrice) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(productUnitPrice)
    }
}

func editProductUnitPrice(productUnitPrice: AHProductUnitPrice, newProductUnitPrice: AHProductUnitPrice) {
    let realm = try! Realm()
    try! realm.write {
        if productUnitPrice.isInvalidated == false {
            productUnitPrice.pup_date_start  = newProductUnitPrice.pup_date_start
            productUnitPrice.pup_date_end = newProductUnitPrice.pup_date_end
            productUnitPrice.pup_purchase_price = newProductUnitPrice.pup_purchase_price
            productUnitPrice.pup_price = newProductUnitPrice.pup_price
            productUnitPrice.pup_price_in_tax = newProductUnitPrice.pup_price_in_tax
            productUnitPrice.pup_margin  = newProductUnitPrice.pup_margin
            productUnitPrice.pup_pu  = newProductUnitPrice.pup_pu
        }
    }

}

func deleteProductUnitPrice(productUnitPrice: AHProductUnitPrice) {
    let realm = try! Realm()
    try! realm.write {
        if productUnitPrice.isInvalidated == false {
            productUnitPrice.pup_status = 0
        }
    }
}
