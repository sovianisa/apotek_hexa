//
//  AHProductCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 20/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllProducts() -> [AHProduct] {
    let realm = try! Realm()
    let listed = realm.objects(AHProduct.self).filter("prd_status = 1")
    var list = [AHProduct]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveProduct(product: AHProduct) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(product)
    }
}

func editProduct(product: AHProduct, newProduct: AHProduct) {
    let realm = try! Realm()
    try! realm.write {
        if product.isInvalidated == false {
            product.prd_name = newProduct.prd_name
            product.prd_indication = newProduct.prd_indication
            product.prd_barcode = newProduct.prd_barcode
            product.prd_pc = newProduct.prd_pc
            product.prd_fct = newProduct.prd_fct
            product.prd_cod = newProduct.prd_cod

        }
    }

}

func deleteProduct(product: AHProduct) {
    let realm = try! Realm()
    try! realm.write {
        if product.isInvalidated == false {
            product.prd_status = 0
        }
    }
}
