//
//  AHShopCrud.swift
//  apotek
//
//  Created by Annisa Sofia Noviantina on 19/12/19.
//  Copyright © 2019 Hexa. All rights reserved.
//

import UIKit
import RealmSwift

func getAllShops() -> [AHShop] {
    let realm = try! Realm()
    let listed = realm.objects(AHShop.self).filter("shop_status = 1")
    var list = [AHShop]()
    for item in listed {
        list.append(item)
    }
    return list
}

func getSelectedShop() -> AHShop {
    let realm = try! Realm()
    let listed = realm.objects(AHShop.self).filter("shop_status = 1")
    var list = [AHShop]()
    for item in listed {
        list.append(item)
    }
    
    if list.count > 0 {
        return list[0]
    } else {
        let shop = AHShop()
        shop.shop_name = "Shop Utama"
        shop.shop_city = "Bandung"
        shop.shop_address = "Jalan Utama No.1"
        shop.shop_phone = "0228478374"
        return shop
    }
}

func saveShop(shop: AHShop) {
    let realm = try! Realm()
    try! realm.write {
        realm.add(shop)
    }
}

func editShop(shop: AHShop, newShop: AHShop) {
    let realm = try! Realm()
    try! realm.write {
        if shop.isInvalidated == false {
            shop.shop_name = newShop.shop_name
            shop.shop_city = newShop.shop_city
            shop.shop_address = newShop.shop_address
            shop.shop_phone = newShop.shop_phone

        }
    }

}

func deleteShop(shop: AHShop) {
    let realm = try! Realm()
    try! realm.write {
        if shop.isInvalidated == false {
            shop.shop_status = 0
        }
    }
}
