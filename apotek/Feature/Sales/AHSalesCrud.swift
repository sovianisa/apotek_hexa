//
//  AHSalesCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 18/01/20.
//  Copyright © 2020 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllSales() -> [AHSales] {
    let realm = try! Realm()
    let listed = realm.objects(AHSales.self).filter("sale_status = 1")
    var list = [AHSales]()
    for item in listed {
        list.append(item)
    }
    return list
}

func saveSales(sales: AHSales) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(sales)
    }
}

func editSales(sales: AHSales, newSales: AHSales) {
    
    let realm = try! Realm()
    try! realm.write {
        if sales.isInvalidated == false {
            sales.sale_no = newSales.sale_no
            sales.sale_create_by = newSales.sale_create_by
            sales.sale_date = newSales.sale_date
            sales.sale_discount = newSales.sale_discount
            sales.sale_total = newSales.sale_total
            sales.sale_shop = newSales.sale_shop
            
            sales.sale_prd_list.removeAll()
            
            for item in newSales.sale_prd_list {
                sales.sale_prd_list.append(item)
            }
        }
    }

}

func deleteSales(sales: AHSales) {
    let realm = try! Realm()
    try! realm.write {
        if sales.isInvalidated == false {
            sales.sale_status = 0
        }
    }
}
